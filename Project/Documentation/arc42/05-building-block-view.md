# 5. Building Block View

> Rendered from `Project/Model/Architecture/base/BaseArchitecture.sysml`,
> `Project/Model/Architecture/functional/FunctionalArchitecture.sysml`,
> `Project/Model/Architecture/logical/{LogicalArchitecture,FunctionalAllocation}.sysml`,
> `Project/Model/Architecture/product/{ProductComponents,ProductInterfaces,ProductArchitecture,LogicalToProductAllocation}.sysml`.

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
of 8 Functional Elements:

| Functional Element | Realizes (UCA) | Key Ports |
|---|---|---|
| `requestAcquisitionFunctions` | `ReceiveControlRequest` | `commandIn` (boundary), `commandOut` |
| `controlLogicFunctions` | `DetermineMovementRequest` | `commandIn`, `requestOut` |
| `movementSupervisionFunctions` | `SuperviseMovementStop` (wraps `MonitorStopCondition`/`MonitorUserInterruption`) | `commandIn`, `requestIn`, `timingIn`, `stopOut`, `modeEventIn` |
| `shutterControlFunctions` | `StartShutterMovement`, `StopShutterMovement` | `requestIn`, `stopIn`, `motorOut` (boundary), `shutterOut` (boundary) |
| `configurationControlFunctions` | `DetermineConfigurationMode`, `CheckConfigurationModeState`, `RejectConfigurationModeReentry`, `ActivateConfigurationModeFE`, `ExitConfigurationModeFE` | `commandIn`, `modeEventOut` |
| `timeCountingFunctions` | `CountActionTimeFE` | `shutterStateIn`, `durationOut` |
| `memoryFunctions` | `SaveCountedTime`, `LoadTimingProfile` | `durationIn`, `durationOut` |
| `userNotificationFunctions` | `DispatchConfigModeNotification` | `modeEventIn` |

**Internal connections (composite, numbered per model):** boundary
`controlInput`→`requestAcquisitionFunctions`; →`controlLogicFunctions` and
(fan-out) →`movementSupervisionFunctions` and →`configurationControlFunctions`;
`controlLogicFunctions`→`movementSupervisionFunctions` + `shutterControlFunctions`
(`MovementRequest` fan-out); `movementSupervisionFunctions`→`shutterControlFunctions`
(`StopRequest`); `shutterControlFunctions`→boundary (`MotorState`) and
→boundary+`timeCountingFunctions` (`ShutterState`); `timeCountingFunctions`→
`memoryFunctions` (`TravelTime`); `memoryFunctions`→`movementSupervisionFunctions`
(`TravelTime`); `configurationControlFunctions`→`userNotificationFunctions` and
(fan-out) →`movementSupervisionFunctions` (`ConfigModeEvent`).

## 5.2 Level 2 — Logical Architecture

`LogicalArchitecture::RollerShutterControllerLogicalComponents` — 6 components,
allocated (loosely) from the 8 Functional Elements per
`FunctionalAllocation::FunctionToLogicalComponent` (ADR-004):

| Logical Component | Base Counterpart (`:>`) | Realizes FE(s) |
|---|---|---|
| `LogicalLocalRequestInterface` | `WallSwitchInterface` | `requestAcquisitionFunctions` (local translation) |
| `LogicalRemoteRequestInterface` | `RemoteInterface` | `requestAcquisitionFunctions` (remote translation) |
| `LogicalControlUnit` | `ControlUnit` | `requestAcquisitionFunctions` (arbitration), `controlLogicFunctions`, `configurationControlFunctions`, `memoryFunctions` |
| `LogicalMovementSupervisor` | — (no Base counterpart, ADR-004) | `movementSupervisionFunctions`, `timeCountingFunctions` |
| `LogicalMotorDrive` | `MotorDriver` | `shutterControlFunctions` |
| `LogicalUserNotification` | — (no Base counterpart) | `userNotificationFunctions` |

`requestAcquisitionFunctions` is the one documented 1-FE-to-3-component split
(translation split by physical channel; arbitration requires simultaneous
visibility of both channels, hence `LogicalControlUnit`).

`LogicalControlUnit` is flagged in the model as the architectural
bottleneck (4 of 8 FEs, connected to all 5 of the other Logical components;
one of two components REQ-Q-02/REQ-Q-03 cross-cut, together with
`LogicalMotorDrive`) — Product Architecture is required to re-evaluate
splitting it (see §5.3).

Key inter-component flows: local/remote `LogicalRequestInterface.commandOut`
→ `LogicalControlUnit.{local,remote}CommandIn`; `LogicalControlUnit.
commandRelayOut` → `LogicalMovementSupervisor.commandIn`; `LogicalControlUnit.
requestOut` fan-out → `LogicalMovementSupervisor`/`LogicalMotorDrive`;
`LogicalMovementSupervisor.stopOut` → `LogicalMotorDrive.stopIn`;
`LogicalMotorDrive.shutterStateOut` → `LogicalMovementSupervisor.
shutterStateIn`; `LogicalMovementSupervisor.durationOut` →
`LogicalControlUnit.durationIn`; `LogicalControlUnit.modeEventOut` →
`LogicalUserNotification.modeEventIn` (fan-out) → `LogicalMovementSupervisor.
modeEventIn`.

## 5.3 Level 3 — Product Architecture

`ProductArchitecture::RollerShutterControllerProductComponents` — single
low-cost 8-bit MCU platform (ADR-006/ADR-007), realizing
`LogicalControlUnit`'s concentration concern by **software modularization**
rather than hardware fragmentation:

| Product Component | Type | Realizes (allocation) | Unit Cost (PLN) |
|---|---|---|---|
| `localRequestInterface` / `remoteRequestInterface` | `RequestInterfaceCircuit` (×2) | `LogicalLocalRequestInterface` / `LogicalRemoteRequestInterface` (signal conditioning) | 1.5 each |
| `controlMCU` | `ControlMCU` | Hosts 7 firmware modules (below) | 2.0 |
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
| `ConfigurationManagerSoftware` | `configurationControlFunctions` (+ wiring-mode selection) | Loose |
| `MemoryManagerSoftware` | `memoryFunctions` (EEPROM persistence of `TravelTime`, wiring mode) | Loose |
| `MovementSupervisorSoftware` | `LogicalMovementSupervisor` | Strong (`:>`) |
| `MotorDriveControlSoftware` | Relay coil drive logic | Loose |
| `UserFeedbackSoftware` | `LogicalUserNotification` (buzzer pattern arbitration) | Loose |

New Product-layer-only interfaces (`ProductInterfaces.sysml`, no earlier-layer
counterpart): `RelayControlPort` (relay coil drive), `BuzzerControlPort`
(ADR-008), `LogicPowerRailPort` (3.3 V regulated rail), `ProgrammingPort`
(manufacturing test/flash, REQ-Q-01).

`PowerSupplyModule` and `EnclosureAndConnectors` are the two Product
components with no Logical-to-Product allocation entry — both intentionally
justified (strong-coupled from Base, and a new mechanical-only element,
respectively; ADR-007).

## 5.4 Level 4 — Software Building Block View (SWA-03)

> Rendered from `Project/Model/Architecture/software/building_block_view/SWBuildingBlocks.sysml`.
> Continues Product Architecture one level deeper: internal structure,
> algorithms, and state-machine hosting for the firmware modules selected for
> whitebox decomposition (SWA-02's decomposition rationale, §4.5 above).

### State-machine hosting

`MovementSupervisorSoftwareInternal` (`:> MovementSupervisorSoftware`)
exhibits `SystemStates::ControllerLifecycleState` directly —
`exhibit state lifecycle : ControllerLifecycleState;` — reusing the state
machine's full body (defined once on the `state def` itself) without
duplicating it. The Logical-layer specialization
`RollerShutterControllerWithLifecycle` exhibits the same state def; both
hosts are deliberate, documented reuse (see `SystemStates.sysml`'s
dual-host summary), not accidental duplication.

### `CommandArbitrationSoftwareInternal` whitebox

| Element | Kind | Purpose |
|---|---|---|
| `ConfirmInputDebounce` | `action def` | Confirms a raw GPIO transition as genuine (stable ≥ `debounceConfirmMs`) rather than residual electrical noise; one instance per input line (`confirmLocalUp/Down`, `confirmRemoteUp/Down`) |
| `ArbitrateAndDetectConflict` | `action def` (specializes `ReceiveControlRequest`) | Refines the UC-level accept race with `arbitrationWindowMs`-based UP+DOWN conflict detection, forcing `direction := none` on a genuine conflict |
| `lastLocalEdgeMs` / `lastRemoteEdgeMs` | internal `attribute` | Per-channel last confirmed edge timestamp; flowed into `arbitrateChannels` as input data — the comparison algorithm itself stays SDD-deferred |

### `MovementControlSoftwareInternal` whitebox

Reuses `UseCaseActivities::DetermineMovementRequest` directly via
`perform action translateCommand : DetermineMovementRequest;` — command-to-
request translation is already fully specified at the Use Case Activities
level, so no further firmware-level refinement was needed.

### Driver / HAL layer (ADR-SW-011)

> Each driver is the sole owner of one hardware-facing port group, nested as
> a `part def` inside its owning module's `*Internal` whitebox. Drivers stay
> signature-free (name, responsibility, owning module, layer placement only)
> — API/method design is explicitly SDD scope.

| Driver | Owning module | Responsibility |
|---|---|---|
| `GpioInputDriver` | `CommandArbitrationSoftwareInternal` | Owns the four raw GPIO change-notification lines (ADR-SW-010); forwards raw, unconfirmed levels only |
| `TimerDriver` | `MovementSupervisorSoftwareInternal` | Owns the periodic timer peripheral (ADR-003/ADR-SW-009); produces `TimerTick`, routed via `eventDispatcher` |
| `MotorRelayOutputDriver` | `MotorDriveControlSoftwareInternal` | Sole owner of `upCoil`/`downCoil`; enforces break-before-make so both coils are never asserted together |
| `BuzzerOutputDriver` | `UserFeedbackSoftwareInternal` | Sole owner of the single `buzzerOn` drive line (ADR-008) |
| `EepromDriver` | `MemoryManagerSoftwareInternal` | Sole owner of `internalEepromBytes` read/write access (ADR-006, Cross-cutting Concept 4) |

No Application-level action references a hardware-facing port directly; each
goes through its module's driver only.
