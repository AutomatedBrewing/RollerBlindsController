# 12. Glossary

> Rendered from `model/Analysis/domain/DomainKnowledge.sysml` (SM-PRD-15 —
> single source of truth for domain vocabulary) plus acronyms used
> throughout `model/**/*.sysml`.

## Domain Terms (enums and item defs)

| Term | Definition |
|---|---|
| `MovementDirection` | The direction a shutter motor is commanded to move, or absence thereof: `up` (raise/open), `down` (lower/close), `none` (de-energized — produced by `StartShutterMovement` on a UP+DOWN conflict, UC_01e, or by `StopShutterMovement` after any movement ends). |
| `MovementMode` | The two control modes: `automatic` (full-travel timed run to end-of-travel using the configured timeout, REQ-F-04, UC_01a/b) vs. `manual` (hold-to-run; stops on release or safety timeout, REQ-F-05, UC_01c/d). |
| `StopReason` | Cause that terminated an in-progress movement: `timeout` (configured travel-time expired — normal end-of-travel in automatic mode, safety failsafe in manual mode, REQ-F-07) or `userRequest` (explicit stop command received before timeout, REQ-F-06). |
| `ConfigModeTransition` | Discriminates the two configuration-mode notifications during calibration (UC_03, REQ-F-08): `activated` / `deactivated`. |
| `ControlCommand` | Interpreted command object derived from a raw dry-contact UP/DOWN voltage-present signal on `localCtrl`/`remoteCtrl` (REQ-I-01/02); carries `direction` and `mode`. |
| `MovementRequest` | Validated movement request produced by `DetermineMovementRequest` after conflict checking; `direction == none` encodes a suppressed UP+DOWN conflict (UC_01e). |
| `StopRequest` | Request to terminate in-progress movement, carrying a `StopReason`; produced by `MonitorStopCondition`/`MonitorUserInterruption`. |
| `MotorState` | Commanded state of the shutter motor relay/triac (`enable`, `direction`); energized only when `enable == true AND direction != none`. |
| `ShutterState` | Observable shutter state (`moving`, `direction`) reported by movement start/stop functions; also consumed by `CountActionTime` during UC_03. |
| `ConfigModeEvent` | Notification raised on entering/exiting configuration mode; carries a `ConfigModeTransition` kind. |
| `ConflictEvent` | Pure occurrence signal raised when a simultaneous UP+DOWN conflict is detected and motor activation suppressed (UC_01e, REQ-S-02); no attributes. |
| `DiagnosticRequest` | Technician-asserted trigger to run field diagnosis (UC_04, `DetectFault`), observable without specialized lab equipment (REQ-Q-04/05); no attributes. |
| `DiagnosticResult` | Technology-independent field-diagnosis outcome (`faultDetected : Boolean`); the concrete `FaultClass` taxonomy is committed only at Product Architecture (`ProductInterfaces::FaultIndication`). |
| `FaultIndicationEvent` | Pure occurrence signal raised when `diagnosticsFunctions` classifies a fault, consumed by `userNotificationFunctions` to drive user-perceivable fault feedback (REQ-Q-04). |
| `TravelTime` | A measured one-direction shutter travel duration, produced by `CountActionTime` during calibration (UC_03). |
| `TimingProfile` | The persisted per-installation `{openTime, closeTime}` pair (REQ-F-07), retrieved at runtime to supply the movement-supervision timeout. |
| `ControlCommandFlow` / `MovementRequestFlow` / `StopRequestFlow` / `MotorStateFlow` / `ShutterStateFlow` / `ConfigModeEventFlow` / `ConflictEventFlow` / `DiagnosticRequestFlow` / `DiagnosticResultFlow` / `FaultIndicationEventFlow` / `TravelTimeFlow` / `TimingProfileFlow` | Typed `flow def` channels, each carrying exactly one corresponding `item def` above between functional/logical elements. |

## Acronyms & Technical Terms

| Term | Definition |
|---|---|
| WRSC | Window Roller Shutter Controller — the system of interest, `BaseArchitecture::ShutterController`. |
| ADR | Architecture Decision Record — see [09-architecture-decisions.md](09-architecture-decisions.md). |
| MCU | Microcontroller Unit — the single shared compute platform (`ControlMCU`, ADR-006), hosting all 8 firmware modules. |
| SELV | Safety Extra-Low Voltage — the ≤50 V AC exposure limit mandated by REQ-S-01. |
| MTBF | Mean Time Between Failures — the hardware-reliability metric underpinning availability (REQ-Q-02) per ADR-002. |
| BOM | Bill of Materials — basis of the ≤50 PLN unit cost target (`L0_Constraints::Business::costEffective`, ADR-001). |
| WEEE | Waste Electrical and Electronic Equipment (EU directive) — disposal compliance target for REQ-E-01. |
| RoHS | Restriction of Hazardous Substances (EU directive) — material compliance target for REQ-E-01, verified by TC_E_001. |
| ALARP | As Low As Reasonably Practicable — the safety-escalation convention applied to RISK-S-01's severity rating. |
| UC / UCA | Use Case / Use Case Activity — behavioral analysis artifacts in `model/Analysis/use_cases`, `use_case_activities`. |
| FE | Functional Element — a unit of `FunctionalArchitecture::RollerShutterControllerFunctions` (9 total). |
| ARC-NN | arc42 section number, per `KnowledgeSource/integration/okf-ontology.md §6.1` (e.g. ARC-06 = Runtime View). |
