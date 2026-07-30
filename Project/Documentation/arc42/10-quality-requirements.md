# 10. Quality Requirements

> Rendered from `Project/Model/Analysis/requirements/Requirements.sysml`
> (packages `Quality`, `Safety`),
> `Project/Model/Verification/test_cases/SystemTestCases.sysml`.

## Quality Requirements Overview (Quality Tree)

| ID | Requirement | Stakeholder | Target | Verified by (`SystemTestCases`) |
|---|---|---|---|---|
| REQ-Q-01 | easeOfInstallation | Installer | ≤ 30 min first-time install | `TC_Q_001_InstallationTime` |
| REQ-Q-02 | availability | User | ≥ 99.8% valid-request success rate | `TC_Q_002_OperationalAvailability` |
| REQ-Q-03 | reliability | User | ≥ 10,000 operation cycles w/o failure | `TC_Q_003_ReliabilityEndurance` |
| REQ-S-01 | safety | User | SELV (≤50 V AC) exposed; galvanic isolation; conflict suppression | `TC_S_001`, `TC_S_002`, `TC_S_003` |

## Quality Scenarios

| ID | Stimulus | Environment | Response | Response Measure | Test case |
|---|---|---|---|---|---|
| QS-01 | First-time installer begins install | New installation site | Installer completes install + basic verification | ≤ 30 min (`TC_Q_001_InstallationTime`) | TC_Q_001 |
| QS-02 | N valid control requests issued over operational life | Normal field operation | Controller executes request | ≥ 99.8% success rate (`TC_Q_002_OperationalAvailability`) | TC_Q_002 |
| QS-03 | Repeated open/close cycling under rated load/temperature | Rated environmental conditions (`operatingConditions`) | Motor switching continues without functional failure | ≥ 10,000 cycles (`TC_Q_003_ReliabilityEndurance`) | TC_Q_003 |
| QS-04 (safety) | Simultaneous UP+DOWN assertion (same-source or cross-source) | Any operating state | Motor stays de-energized in both directions | 100% suppression (`TC_S_001`/`TC_S_002`) | TC_S_001, TC_S_002 |
| QS-05 (safety) | Any user/installer probes accessible interface points | Normal operation | No point exceeds SELV limit; isolation intact | ≤ 50 V AC, isolation verified (`TC_S_003_AccessibleVoltage_SELV`) | TC_S_003 |

## Test Case Register (`Project/Model/Verification/test_cases/SystemTestCases.sysml`)

37 `verification def`s, all carrying `@TestCaseMeta {testType,
verificationMethod, priority, category}`, organized into 6 packages:

| Category | IDs | Count | Requirements covered |
|---|---|---|---|
| Functional | TC_F_001–014 | 14 | REQ-F-01..09, REQ-I-01/02 |
| Safety | TC_S_001–006 | 6 | REQ-S-01, REQ-F-06, REQ-F-08 |
| Quality | TC_Q_001–003 | 3 | REQ-Q-01..03 |
| Environmental | TC_E_001 | 1 | REQ-E-01 |
| Boundary | TC_B_001–007 | 7 | REQ-F-01, REQ-F-07, REQ-Q-03, REQ-S-01, `L0_Constraints::Electrical::{supplyVoltage,switchingLoad}`, `Environmental::operatingConditions`, `Physical::compactDimensions` |
| Negative | TC_N_001–006 | 6 | REQ-F-05/06/07/08, REQ-Q-01, REQ-I-01, `Architectural::{noPositionFeedback,timeBasedOperation}` |

### Boundary test cases (`Boundary` package)

| ID | Boundary condition |
|---|---|
| TC_B_001/002 | Supply voltage lower/upper bound (10.0 V / 14.0 V DC, ±10% of 12 V, `Electrical::supplyVoltage`) |
| TC_B_003 | `TravelTime` at exactly the 120 s max configurable travel time (REQ-F-07) |
| TC_B_004/005 | Ambient temperature lower/upper bound (0 °C / 40 °C, `Environmental::operatingConditions`) |
| TC_B_006 | Maximum rated switching load (8 A @ 230 V AC, `Electrical::switchingLoad`) |
| TC_B_007 | Maximum enclosure envelope (40×40×20 mm, `Physical::compactDimensions`) |

### Negative test cases (`Negative` package)

| ID | Scenario |
|---|---|
| TC_N_001 | Manual-mode safety timeout fires even while command is still held (failsafe) |
| TC_N_002 | Re-activating configuration mode while already active — no double-notification/lockup |
| TC_N_003 | Installation wiring-verification retry path (corrects and re-verifies) |
| TC_N_004 | Confirms purely time-based operation, no position sensor dependency |
| TC_N_005 | Wiring-mode (momentary/latching) mismatch produces detectable incorrect behavior |
| TC_N_006 | Second consecutive verification failure → terminal installation fault |

### Component-scoped (white-box) verification defs (`SystemTestCases.sysml`)

| Package | Verification def | Subject (component) | Verifies |
|---|---|---|---|
| `Logical` | `VerifyCommandArbitration` | `LogicalControlUnit` | REQ-S-01, controlRollerShutter, stopShutterMovement, configurationMode |
| `Logical` | `VerifyConfigurationModeTransitions` | `LogicalControlUnit` | configurationMode |
| `Logical` | `VerifyUserNotificationDispatch` | `LogicalUserNotification` | configurationMode |
| `Logical` | `VerifyMotorDriveEndurance` | `LogicalMotorDrive` | reliability, availability |
| `Logical` | `VerifyMovementSupervisionTiming` | `LogicalMovementSupervisor` | fullShutterMovement, manualPositioning, stopShutterMovement, configurableTimingProfile |
| `Product` | `VerifyWiringModeConfiguration` | `CommandArbitrationSoftware` | wallSwitchWiringCompatibility, controlRollerShutter |
| `Product` | `VerifyMotorRelayEnduranceRating` | `MotorDriveRelayModule` | reliability, availability |
| `Product` | `VerifyRequestInterfaceIsolation` | `RequestInterfaceCircuit` | safety, `Electrical::inputIsolation` |

These 8 white-box verification defs are scoped to specific Logical/Product
components (`LogicalControlUnit`, `LogicalUserNotification`,
`LogicalMotorDrive`, `LogicalMovementSupervisor`,
`CommandArbitrationSoftware`, `MotorDriveRelayModule`,
`RequestInterfaceCircuit`) rather than only the black-box `ShutterController`
subject used throughout the `TC_*` register above — 5 in `Logical`, 3 in
`Product`.

## Notes

- All quality/safety requirements above have at least one `verification def`
  AND at least one concrete `SystemTestCases::TC_*` test case — no coverage
  gap exists for REQ-Q-01..03 or REQ-S-01.
- REQ-Q-02 (availability) is architecturally satisfied passively via
  hardware MTBF rather than a dedicated self-test function (ADR-002) — see
  [09-architecture-decisions.md](09-architecture-decisions.md).
- Full quality-attribute prioritization is in
  [01-introduction-and-goals.md](01-introduction-and-goals.md) (Quality
  Goals table).
