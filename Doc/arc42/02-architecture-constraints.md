# 2. Architecture Constraints

> Rendered from `model/Architecture/base/Constraints.sysml` (`L0_Constraints`)
> and `model/Architecture/base/ADR_001_CostConstraint.sysml`.

| Constraint ID | Constraint | Background | Scope |
|---|---|---|---|
| `costEffective` | Manufacturing cost ≤ 50 PLN per unit | Manufacturer `CostConcern`; drives ADR-001's "no MCU / relay-based / dry-contact" architecture (later revised by ADR-006) | Whole BOM (`ProductArchitecture::totalUnitCostPLN` asserts ≤ 50.0) |
| `compactDimensions` | Dimensions ≤ 40×40×20 mm | User `MinimalSize` — must fit a typical ⌀60 flush-mounted junction box | Enclosure / physical form factor |
| `operatingConditions` | Operate 0 °C – 40 °C | Manufacturer `OperatingConditions` — typical residential environment | Whole controller |
| `supplyVoltage` | 12 VDC ±10% (10–14 V) control supply | Fixed low-voltage logic supply rail | Control logic, interfaces |
| `switchingLoad` | Up to 8 A at 230 VAC motor switching | Represents standard residential roller-shutter motor load | MotorDriver / motor switching circuit |
| `motorIsolation` | Motor control circuitry galvanically isolated from low-voltage control logic | Safety — mitigates RISK-S-01 | MotorDriver ↔ ControlUnit boundary |
| `inputIsolation` | Galvanic isolation on all external input interfaces | Safety — mitigates RISK-S-01 | WallSwitchInterface, RemoteInterface |
| `noPositionFeedback` | No position sensor/feedback from the shutter | Core architectural simplicity/cost decision (ADR-003); accepts residual RISK-T-01 | Movement supervision |
| `timeBasedOperation` | Configurable time-based positioning only | Realizes `noPositionFeedback` without a sensor | Movement supervision, configuration |

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
