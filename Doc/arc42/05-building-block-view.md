# 5. Building Block View

> Rendered from `model/Architecture/base/BaseArchitecture.sysml`,
> `model/Architecture/functional/FunctionalArchitecture.sysml`,
> `model/Architecture/logical/{LogicalArchitecture,FunctionalAllocation}.sysml`,
> `model/Architecture/product/{ProductComponents,ProductInterfaces,ProductArchitecture,LogicalToProductAllocation}.sysml`.

## 5.0 Whitebox Overall System — Base Architecture (Level 0)

`BaseArchitecture::ShutterController` (satisfies `SystemIdea::systemIdea`) is
composed of five parts fixed at project start (SM-PRD-07), fully connected:

| Building Block | Purpose | Fulfilled Requirements (via allocation chain) |
|---|---|---|
| `ControlUnit` | Processes commands and determines shutter movement behaviour | REQ-F-01, REQ-F-08, REQ-Q-02, REQ-Q-03 |
| `MotorDriver` | Switches motor power circuits to drive the shutter up/down | REQ-F-04..06, REQ-Q-02, REQ-Q-03 |
| `WallSwitchInterface` | Receives commands from a locally connected wall switch | REQ-F-02, REQ-I-01 |
| `RemoteInterface` | Receives commands from an external automation/control system | REQ-F-03, REQ-I-02 |
| `PowerModule` | Converts/distributes electrical power to controller components | (no Logical counterpart, ADR-004; realized by `PowerSupplyModule` at Product layer) |

Connections: `controlLogic↔motorDriver`, `localInterface→controlLogic`,
`remoteInterface→controlLogic`, `powerSupply→{controlLogic, motorDriver,
localInterface, remoteInterface}`.

## 5.1 Level 1 — Functional Architecture

`FunctionalArchitecture::RollerShutterControllerFunctions` (technology-
independent, derived from `UseCaseActivities` via the FAS method) is composed
of 9 Functional Elements:

| Functional Element | Realizes (UCA) | Key Ports |
|---|---|---|
| `requestAcquisitionFunctions` | `ReceiveControlRequest` | `commandIn` (boundary), `commandOut` |
| `controlLogicFunctions` | `DetermineMovementRequestFE` | `commandIn`, `requestOut`, `conflictOut` |
| `movementSupervisionFunctions` | `SuperviseMovementStop` (wraps `MonitorStopCondition`/`MonitorUserInterruption`) | `requestIn`, `timingIn`, `shutterStateIn`, `stopOut`, `durationOut` |
| `shutterControlFunctions` | `StartShutterMovement`, `StopShutterMovement`, `MoveShutterToClosePosition` | `requestIn`, `stopIn`, `motorOut` (boundary), `shutterOut` (boundary) |
| `configurationControlFunctions` | `ActivateConfigurationModeFE`, `ExitConfigurationModeFE`, `RejectConfigurationModeReentry` | `commandIn`, `modeEventOut` |
| `timeCountingFunctions` | `CountActionTimeFE`, `CheckTravelTimeInRange` | `shutterStateIn`, `durationOut` |
| `memoryFunctions` | `SaveCountedTime`, `LoadTimingProfile` | `durationIn`, `timingOut` |
| `userNotificationFunctions` | `DispatchConfigModeNotification`, `NotifyUserAboutConflict`, `ReportInstallationFault`, `RejectConfigurationModeReentry` | `modeEventIn`, `conflictEventIn`, `faultEventIn` |
| `diagnosticsFunctions` | `DetectFault`, `IsolateFault`, `RepairOrReplaceUnit` | `diagnosticRequest` (boundary), `diagnosticResultOut`, `faultEventOut` |

**Internal connections (composite, numbered per model):** boundary
`controlInput`→`requestAcquisitionFunctions`; →`controlLogicFunctions` and
(fan-out) →`movementSupervisionFunctions`; `controlLogicFunctions`→
`movementSupervisionFunctions` + `shutterControlFunctions` (`MovementRequest`
fan-out); `movementSupervisionFunctions`→`shutterControlFunctions`
(`StopRequest`); `shutterControlFunctions`→boundary (`MotorState`) and
→boundary+`timeCountingFunctions` (`ShutterState`); `timeCountingFunctions`→
`memoryFunctions` (`TravelTime`); `memoryFunctions`→`movementSupervisionFunctions`
(`TimingProfile`); `configurationControlFunctions`→`userNotificationFunctions`
(`ConfigModeEvent`); `controlLogicFunctions`→`userNotificationFunctions`
(`ConflictEvent`); boundary↔`diagnosticsFunctions` (`DiagnosticRequest`/
`DiagnosticResult`); `diagnosticsFunctions`→`userNotificationFunctions`
(`FaultIndicationEvent`).

## 5.2 Level 2 — Logical Architecture

`LogicalArchitecture::RollerShutterControllerLogicalComponents` — 7 components,
allocated (loosely) from the 9 Functional Elements per
`FunctionalAllocation::FunctionToLogicalComponent` (ADR-004):

| Logical Component | Base Counterpart (`:>`) | Realizes FE(s) |
|---|---|---|
| `LogicalLocalRequestInterface` | `WallSwitchInterface` | `requestAcquisitionFunctions` (local translation) |
| `LogicalRemoteRequestInterface` | `RemoteInterface` | `requestAcquisitionFunctions` (remote translation) |
| `LogicalControlUnit` | `ControlUnit` | `requestAcquisitionFunctions` (arbitration), `controlLogicFunctions`, `configurationControlFunctions`, `memoryFunctions` |
| `LogicalMovementSupervisor` | — (no Base counterpart, ADR-004) | `movementSupervisionFunctions`, `timeCountingFunctions` |
| `LogicalMotorDrive` | `MotorDriver` | `shutterControlFunctions` |
| `LogicalUserNotification` | — (no Base counterpart) | `userNotificationFunctions` |
| `LogicalDiagnostics` | — (no Base counterpart) | `diagnosticsFunctions` |

`requestAcquisitionFunctions` is the one documented 1-FE-to-3-component split
(translation split by physical channel; arbitration requires simultaneous
visibility of both channels, hence `LogicalControlUnit`).

`LogicalControlUnit` is flagged in the model as the architectural
bottleneck (4 of 9 FEs, connected to 4 of the other 6 components, sole trace
target for REQ-Q-02/REQ-Q-03) — Product Architecture is required to
re-evaluate splitting it (see §5.3).

Key inter-component flows: local/remote `LogicalRequestInterface.commandOut`
→ `LogicalControlUnit.{local,remote}CommandIn`; `LogicalControlUnit.
commandRelayOut` → `LogicalMovementSupervisor.commandIn`; `LogicalControlUnit.
requestOut` fan-out → `LogicalMovementSupervisor`/`LogicalMotorDrive`;
`LogicalMovementSupervisor.stopOut` → `LogicalMotorDrive.stopIn`;
`LogicalMotorDrive.shutterStateOut` → `LogicalMovementSupervisor.
shutterStateIn`; `LogicalMovementSupervisor.durationOut` →
`LogicalControlUnit.durationIn`; `LogicalControlUnit.conflictOut`/
`modeEventOut` → `LogicalUserNotification`; `LogicalDiagnostics.
faultEventOut` → `LogicalUserNotification.faultEventIn`.

## 5.3 Level 3 — Product Architecture

`ProductArchitecture::RollerShutterControllerProductComponents` — single
low-cost 8-bit MCU platform (ADR-006/ADR-007), realizing
`LogicalControlUnit`'s concentration concern by **software modularization**
rather than hardware fragmentation:

| Product Component | Type | Realizes (allocation) | Unit Cost (PLN) |
|---|---|---|---|
| `localRequestInterface` / `remoteRequestInterface` | `RequestInterfaceCircuit` (×2) | `LogicalLocalRequestInterface` / `LogicalRemoteRequestInterface` (signal conditioning) | 1.5 each |
| `controlMCU` | `ControlMCU` | Hosts 8 firmware modules (below) | 2.0 |
| `motorDriveRelayModule` | `MotorDriveRelayModule` | `LogicalMotorDrive` | 3.5 |
| `userNotificationBuzzer` | `AudibleNotificationBuzzer` | `LogicalUserNotification` (ADR-008) | 0.5 |
| `powerSupplyModule` | `PowerSupplyModule` (`:> BaseArchitecture::PowerModule`) | — (strong-coupled, no Logical counterpart) | 1.5 |
| `enclosureAndConnectors` | `EnclosureAndConnectors` | — (new mechanical element, no signal port) | 4.0 |

**Total: `totalUnitCostPLN` = 14.5** (asserted `≤ 50.0`, satisfying `costEffective`).

**Firmware modules hosted on `ControlMCU`** (LogicalControlUnit split,
closing the Level-2 follow-up):

| Firmware Module | Realizes | Coupling |
|---|---|---|
| `CommandArbitrationSoftware` | `LogicalLocalRequestInterface`/`LogicalRemoteRequestInterface` translation + `LogicalControlUnit` arbitration/conflict detection | Loose (allocation, ADR-007) |
| `MovementControlSoftware` | Remainder of `controlLogicFunctions` (arbitrated → `MovementRequest`) | Loose |
| `ConfigurationManagerSoftware` | `configurationControlFunctions` (+ PA-2 wiring-mode selection) | Loose |
| `MemoryManagerSoftware` | `memoryFunctions` (EEPROM persistence of `TimingProfile`, wiring mode) | Loose |
| `MovementSupervisorSoftware` | `LogicalMovementSupervisor` | Strong (`:>`) |
| `MotorDriveControlSoftware` | Relay coil drive logic | Loose |
| `UserFeedbackSoftware` | `LogicalUserNotification` (buzzer pattern arbitration) | Loose |
| `DiagnosticsSoftware` | `LogicalDiagnostics` | Strong (`:>`) |

New Product-layer-only interfaces (`ProductInterfaces.sysml`, no earlier-layer
counterpart): `RelayControlPort` (relay coil drive), `BuzzerControlPort`
(ADR-008), `LogicPowerRailPort` (3.3 V regulated rail), `ProgrammingPort`
(manufacturing test/flash, REQ-Q-01/REQ-Q-05), `FaultIndicationPort`/
`FaultClass` enum (`noResponseToControlInput`, `motorDriveFault` — closes the
PA-1 Diagnostics dead-end finding).

`PowerSupplyModule` and `EnclosureAndConnectors` are the two Product
components with no Logical-to-Product allocation entry — both intentionally
justified (strong-coupled from Base, and a new mechanical-only element,
respectively; ADR-007).
