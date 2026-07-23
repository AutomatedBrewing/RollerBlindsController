# 10. Quality Requirements

> Rendered from `model/Analysis/requirements/Requirements.sysml`
> (packages `Quality`, `Safety`), `model/Verification/test_cases/
> Verification.sysml`, `model/Verification/test_cases/SystemTestCases.sysml`.

## Quality Requirements Overview (Quality Tree)

| ID | Requirement | Stakeholder | Target | Verified by (`verification def`) | Test cases |
|---|---|---|---|---|---|
| REQ-Q-01 | easeOfInstallation | Installer | ≤ 30 min first-time install | `Verification::Quality::VerifyEaseOfInstallation` | TC_Q_001 |
| REQ-Q-02 | availability | User | ≥ 99.8% valid-request success rate | `Verification::Quality::VerifyAvailability` | TC_Q_002 |
| REQ-Q-03 | reliability | User | ≥ 10,000 operation cycles w/o failure | `Verification::Quality::VerifyReliability` | TC_Q_003 |
| REQ-Q-04 | diagnosability | MaintenanceTechnician | Field-diagnosable fault classes, no lab equipment | `Verification::Quality::VerifyDiagnosability` | TC_Q_004 |
| REQ-Q-05 | fieldReplaceability | MaintenanceTechnician | On-site repair/replace via existing wiring | `Verification::Quality::VerifyFieldReplaceability` | TC_Q_005 |
| REQ-S-01 | safety | User | SELV (≤50 V AC) exposed; galvanic isolation; conflict suppression | `Verification::Constraints::{VerifySupplyVoltageRange,VerifyMaximumSwitchingLoad}` | TC_S_001, TC_S_002, TC_S_003 |
| REQ-S-02 | conflictIndication | User | Distinct, user-perceivable indication on suppressed conflict | `Verification::Constraints::VerifyConflictNotification` | TC_S_004 |

REQ-Q-04 and REQ-Q-05 were added during the system-model-review corrective
pass to close Major finding M3 (`Stakeholders::MaintenanceTechnician`
concerns previously had no `L0_Requirements` usage). REQ-S-02 was split out
of REQ-S-01 to close Major finding M2 (silent conflict suppression).

## Quality Scenarios

| ID | Stimulus | Environment | Response | Response Measure | Test case |
|---|---|---|---|---|---|
| QS-01 | First-time installer begins install | New installation site | Installer completes install + basic verification | ≤ 30 min (`TC_Q_001_InstallationTime`) | TC_Q_001 |
| QS-02 | N valid control requests issued over operational life | Normal field operation | Controller executes request | ≥ 99.8% success rate (`TC_Q_002_OperationalAvailability`) | TC_Q_002 |
| QS-03 | Repeated open/close cycling under rated load/temperature | Rated environmental conditions (`operatingConditions`) | Motor switching continues without functional failure | ≥ 10,000 cycles (`TC_Q_003_ReliabilityEndurance`) | TC_Q_003 |
| QS-04 | Controller malfunctions in the field | No specialized lab equipment available | Technician distinguishes fault class via buzzer/LED pattern | Correct fault class identified (`TC_Q_004_FieldDiagnosis`) | TC_Q_004 |
| QS-05 | Controller unit fails | Existing installation wiring unchanged | Technician swaps unit and restores function | ≤ 30 min, no rewiring (`TC_Q_005_FieldReplacement`) | TC_Q_005 |
| QS-06 (safety) | Simultaneous local UP+DOWN assertion | Any operating state | Motor stays de-energized in both directions | 100% suppression (`TC_S_001`/`TC_S_002`) | TC_S_001, TC_S_002 |
| QS-07 (safety) | Conflict suppressed | Any operating state | Buzzer emits distinct 3-pulse pattern | `conflictSuppressionBeepCount == 3` within 5s window (`TC_S_004`) | TC_S_004 |
| QS-08 (safety) | Any user/installer probes accessible interface points | Normal operation | No point exceeds SELV limit; isolation intact | ≤ 50 V AC, isolation verified (`TC_S_003_AccessibleVoltage_SELV`) | TC_S_003 |

## Test Case Register (`model/Verification/test_cases/SystemTestCases.sysml`)

36 `verification def`s, all carrying `@TestCaseMeta {testType,
verificationMethod, priority, category}`, organized into 6 packages:

| Category | IDs | Count | Requirements covered |
|---|---|---|---|
| Functional | TC_F_001–013 | 13 | REQ-F-01..08, REQ-I-01/02 |
| Safety | TC_S_001–004 | 4 | REQ-S-01, REQ-S-02 |
| Quality | TC_Q_001–005 | 5 | REQ-Q-01..05 |
| Environmental | TC_E_001 | 1 | REQ-E-01 |
| Boundary | TC_B_001–007 | 7 | `L0_Constraints::Electrical::{supplyVoltage,switchingLoad}`, `Environmental::operatingConditions`, `Physical::compactDimensions`, REQ-F-07 |
| Negative | TC_N_001–006 | 6 | REQ-F-05/06/07, `Architectural::noPositionFeedback`, REQ-I-01, UC_02 retry/failure paths |

### Boundary test cases (`Boundary` package)

| ID | Boundary condition |
|---|---|
| TC_B_001/002 | Supply voltage lower/upper bound (10.0 V / 14.0 V DC, ±10% of 12 V, `Electrical::supplyVoltage`) |
| TC_B_003 | `TimingProfile` at exactly the 120 s max configurable travel time (REQ-F-07) |
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

### Component-scoped (white-box) verification defs (`Verification.sysml`)

| Package | Verification def | Subject (component) | Verifies |
|---|---|---|---|
| `Logical` | `VerifyCommandArbitration` | `LogicalControlUnit` | REQ-S-01, controlRollerShutter |
| `Logical` | `VerifyConfigurationModeTransitions` | `LogicalControlUnit` | configurationMode |
| `Logical` | `VerifyUserNotificationDispatch` | `LogicalUserNotification` | configurationMode |
| `Logical` | `VerifyMotorDriveEndurance` | `LogicalMotorDrive` | reliability, availability |
| `Logical` | `VerifyMovementSupervisionTiming` | `LogicalMovementSupervisor` | fullShutterMovement, manualPositioning, stopShutterMovement, configurableTimingProfile |
| `Product` | `VerifyWiringModeConfiguration` | `CommandArbitrationSoftware` | wallSwitchWiringCompatibility, controlRollerShutter |
| `Product` | `VerifyDiagnosticFaultClassification` | `DiagnosticsSoftware` | diagnosability, fieldReplaceability |
| `Product` | `VerifyMotorRelayEnduranceRating` | `MotorDriveRelayModule` | reliability, availability |
| `Product` | `VerifyRequestInterfaceIsolation` | `RequestInterfaceCircuit` | safety, `Electrical::inputIsolation` |

These 9 white-box verification defs close formal-review finding C8
(previously every verification def was black-box, subject
`ShutterController` only) and PA-4 (no verification def had referenced a
Product component).

## Notes

- All quality/safety requirements above have at least one `verification def`
  AND at least one concrete `SystemTestCases::TC_*` test case — no coverage
  gap exists for REQ-Q-01..05 or REQ-S-01..02.
- REQ-Q-02 (availability) is architecturally satisfied passively via
  hardware MTBF rather than a dedicated self-test function (ADR-002) — see
  [09-architecture-decisions.md](09-architecture-decisions.md).
- Full quality-attribute prioritization is in
  [01-introduction-and-goals.md](01-introduction-and-goals.md) (Quality
  Goals table).
