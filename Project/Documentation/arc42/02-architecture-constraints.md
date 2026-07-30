# 2. Architecture Constraints

> Rendered from `Project/Model/Architecture/base/Constraints.sysml` (`L0_Constraints`),
> `Project/Model/Architecture/base/ADR_001_CostConstraint.sysml`, and
> `Project/Model/Architecture/base/ADR_003_TimeBased.sysml`.

| Constraint ID | Constraint | Background | Scope |
|---|---|---|---|
| `CNST-B-01` (`costEffective`) | Manufacturing cost ≤ 50 PLN per unit | Manufacturer `CostConcern`; drives ADR-001's "no MCU / relay-based / dry-contact" architecture (later revised by ADR-006) | Whole BOM (`ProductArchitecture::totalUnitCostPLN` asserts ≤ 50.0) |
| `CNST-P-01` (`compactDimensions`) | Dimensions ≤ 40×40×20 mm | User `MinimalSize` — must fit a typical ⌀60 flush-mounted junction box | Enclosure / physical form factor |
| `CNST-E-01` (`operatingConditions`) | Operate 0 °C – 40 °C | Manufacturer `OperatingConditions` — typical residential environment | Whole controller |
| `CNST-EL-01` (`supplyVoltage`) | 12 VDC ±10% (10–14 V) control supply | Fixed low-voltage logic supply rail | Control logic, interfaces |
| `CNST-EL-02` (`switchingLoad`) | Up to 8 A at 230 VAC motor switching | Represents standard residential roller-shutter motor load | MotorDriver / motor switching circuit |
| `CNST-EL-03` (`motorIsolation`) | Motor control circuitry galvanically isolated from low-voltage control logic | Safety — mitigates RISK-S-01 | MotorDriver ↔ ControlUnit boundary |
| `CNST-EL-04` (`inputIsolation`) | Galvanic isolation on all external input interfaces | Safety — mitigates RISK-S-01 | WallSwitchInterface, RemoteInterface |
| `CNST-A-01` (`noPositionFeedback`) | No position sensor/feedback from the shutter | Core architectural simplicity/cost decision (ADR-003); accepts residual RISK-T-01 | Movement supervision |
| `CNST-A-02` (`timeBasedOperation`) | Configurable time-based positioning only | Realizes `noPositionFeedback` without a sensor | Movement supervision, configuration |

## Category summary

| Category | Constraints |
|---|---|
| Business | `costEffective` |
| Physical | `compactDimensions` |
| Environmental | `operatingConditions` |
| Electrical | `supplyVoltage`, `switchingLoad`, `motorIsolation`, `inputIsolation` |
| Architectural | `noPositionFeedback`, `timeBasedOperation` |

## Architectural decisions driven by these constraints

- **ADR-001** (`ADR_001_CostConstraint`): cost target realized via no MCU
  (timer IC/discrete RC), relay-based switching, dry-contact I/O — partially
  superseded by **ADR-006** (MCU clause only; all other ADR-001 decisions
  remain in force).
- **ADR-003** (`ADR_003_TimeBased`): accepted trade-off realizing
  `noPositionFeedback`/`timeBasedOperation`, with RISK-T-01 (positioning
  drift) as a documented residual risk.

See [09-architecture-decisions.md](09-architecture-decisions.md) for the full
ADR set.

## Software Architecture Constraints (SWA-01)

> Rendered from `Project/Model/Architecture/software/architecture_constraints/SWConstraints.sysml`.
> Firmware-specific constraints derived from `ProductComponents::ControlMCU`'s
> attributes and from the base constraints above that also bind the software.

| Constraint | Category | Summary |
|---|---|---|
| `flashBudget` | Resource | Aggregate `estimatedFlashBytes` of the 7 firmware modules ≤ `flashSizeKB` with a 10% safety margin (preview check; authoritative check in [07-deployment-view.md §7.4](07-deployment-view.md)) |
| `ramBudget` | Resource | Aggregate `estimatedRamBytes` of the 7 firmware modules ≤ `internalRamBytes` with a 10% safety margin (same preview/authoritative split) |
| `memoryDiscipline` | Resource | No dynamic (heap) allocation; statically bounded call-stack depth, verified by static analysis (no runtime stack monitoring available on this MCU) |
| `noRtosAvailable` | Execution Model | `costEffective` already rules out an RTOS-capable MCU upgrade (ADR-001); execution model restricted to bare-metal designs (ADR-SW-009) |
| `dispatcherDeterminism` | Execution Model | The firmware event dispatcher must preserve `SystemStates::ControllerLifecycleState`'s already-verified determinism (mutually exclusive guards per triggering event) |
| `isrLatencyBudget` | Timing | Every ISR (timer tick + 4 GPIO change-notification interrupts) must complete within 10% of `timerResolutionMs` (1.0 ms), keeping ISR bodies to flag/timestamp updates only |
| `codingStandardConstraint` | Toolchain | Placeholder: a specific coding standard (e.g. MISRA-C subset) has not yet been selected; open item deferred to SWA-02/a dedicated ADR |

See [09-architecture-decisions.md](09-architecture-decisions.md) for
ADR-SW-009/ADR-SW-010, which these constraints bound.
