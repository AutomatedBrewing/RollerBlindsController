# 8. Cross-cutting Concepts

> Rendered from `Project/Model/Analysis/domain/DomainKnowledge.sysml`,
> `Project/Model/Architecture/states/SystemStates.sysml`,
> `Project/Model/Architecture/base/ADR_003_TimeBased.sysml`,
> `Project/Model/Architecture/base/ADR_005_SecurityScope.sysml`.

## Concept 1 — Domain Vocabulary (Single Source of Truth)

`DomainKnowledge` (SM-PRD-15) defines every item/enum/flow type crossing a
function boundary — no downstream package redefines a term. Core types:
`MovementDirection` (`up`/`down`/`none`/`both`), `MovementMode` (`automatic`/
`manual`), `StopReason` (`timeout`/`userRequest`), `ChannelSource`,
`ConfigModeTransition`, `ControlCommand`, `MovementRequest`, `StopRequest`,
`MotorState`, `ShutterState`, `TravelTime`, `ConfigModeEvent`. See
[12-glossary.md](12-glossary.md) for full definitions.

## Concept 2 — Time-Based, Sensorless Positioning (ADR-003)

The single most pervasive cross-cutting concept: **no component anywhere in
the model reads shutter position.** Movement stop is always derived from
elapsed time against a persisted `TravelTime`, with a `+5s`/
`timingMarginS` margin (`MemoryManagerSoftware`) compensating for
cumulative drift (RISK-T-01, the architecture's explicitly accepted residual
risk). This discipline is enforced at every layer: `L0_Constraints::
Architectural::{noPositionFeedback,timeBasedOperation}`,
`UseCaseActivities::MonitorStopCondition`/`MonitorUserInterruption` (fork+
merge, first-of-{command,timeout} wins), through to
`LogicalMovementSupervisor`/`MovementSupervisorSoftware`.

## Concept 3 — First-Wins Arbitration & Conflict Suppression

Local and remote command channels are always received concurrently
(`ReceiveControlRequest`'s fork/merge) and arbitrated first-wins
(`CommandArbitrationSoftware.arbitrationWindowMs = 100 ms`). A simultaneous
opposite-direction (UP+DOWN) assertion is a **conflict**: `direction :=
none`/`both` is suppressed through `DetermineMovementRequest`→
`StartShutterMovement` so the motor is never energized in either direction
(REQ-S-01) — enforced with defense-in-depth at `MotorRelayOutputDriver`
itself. This same dual-channel-hold gesture, distinguished
only by duration (`calibrationHoldThresholdS = 5.0 s`,
`AssessingSimultaneousHold`), is also the trigger for entering
Configuration Mode — a single low-level signal pattern deliberately reused
for two distinct semantics.

## Concept 4 — Explicit, User-Signaled Configuration Mode

Configuration Mode (REQ-F-08) is entered/exited only through an explicit,
timed installer gesture, and every entry/exit is signaled to the user
(`ConfigModeEvent`, `DispatchConfigModeNotification`). Calibration
measurements outside the valid range (>120 s, REQ-F-07) are rejected rather
than persisted (`RejectOutOfRangeCalibration`) — a configuration-
input-validation pattern applied consistently at the UCA, Logical, and
Product layers.

## Concept 5 — State Model (Single Definition, Dual-Hosted)

`SystemStates.sysml` defines **one** state machine
(`ControllerLifecycleState`, full body on the `state def` itself, not
duplicated) exhibited by two different host `part def`s at two different
architecture layers (a previously-described second
`diagnosticLifecycle`/`DiagnosticState` machine on a `LogicalDiagnostics`
host does not exist in this model):

| Host `part def` | Layer | Usage name |
|---|---|---|
| `RollerShutterControllerWithLifecycle` | Logical | `rollerShutterControllerWithLifecycle` |
| `MovementSupervisorSoftwareInternal` | Product/Software | `movementSupervisorSoftwareInternal` |

`Uninstalled` → `Installing` → (`InstallationFault` | `Operational`,
entering at `Idle`) → `AssessingSimultaneousHold` →
(`ConflictSuppressed` | `ConfigurationMode`) → back to `Idle`;
`MovingAutomatic`/`MovingManual` from `Idle`; `Unpowered` (from any
`Operational` sub-state, or `Installing`) → `Operational` on recovery;
`Disposed` (terminal).

Cross-boundary event delivery for `PowerLost`/`PowerRestored` (producer:
`ProductComponents::PowerSupplyModule`, outside either host) is routed via
an explicit `CrossLifecycleEventRelay` part def, rather than
relying on SysML v2's ambiguous default "containing part" `accept` receiver.
`ConfigModeEvent` is within the host's own scope and does NOT route through
this relay; it has its own dedicated port/flow path instead.

## Concept 6 — No Dedicated Security Architecture (ADR-005, Scope Boundary)

Every external interface is dry-contact/relay based with no protocol stack,
no addressable identity, and no firmware-update channel — there is no
conventional attack surface. This is an explicit, falsifiable scope
decision (not a silent omission): it must be re-opened the moment any
networked/addressable interface, OTA update mechanism, data-at-rest/in-
transit capability, or remote diagnostic interface is introduced.

## Concept 7 — Firmware Resource Budgeting on a Shared MCU

Every firmware module hosted on `ControlMCU` carries an illustrative
`estimatedFlashBytes`/`estimatedRamBytes` pair, summed and checked
against `ControlMCU.flashSizeKB`/`internalRamBytes` — a lightweight,
model-level capacity-planning discipline applied uniformly across all 7
modules rather than to any single one.

## Software Cross-cutting Concepts (SWA-06)

> Rendered from `Project/Model/Architecture/software/cross_cutting_concepts/SWCrossCuttingConcepts.sysml`.
> Firmware-wide conventions distilled from recurring patterns observed while
> producing the Software Building Block View (SWA-03); each is backed by a
> concrete SWA-03 instance and traced to its originating SWA-01 constraint or
> ADR.

### Concept 8 — No Dynamic Memory Allocation

Origin: `SWConstraints::Resource::memoryDiscipline` (SWA-01). No firmware
module may use heap/dynamic allocation; every internal data item is
statically declared — e.g. `CommandArbitrationSoftwareInternal`'s
`lastLocalEdgeMs`/`lastRemoteEdgeMs`. Checkable via the
`NoDynamicAllocationMeta` marker applied to all 7 firmware `part def`s.

### Concept 9 — Single Shared Timing Source

Origin: ADR-003 / ADR-SW-009. No module may introduce its own independent
timing source; every elapsed-time measurement (movement timeout,
hold-to-run, ADR-SW-010's debounce bookkeeping) is derived from counting the
same `timerResolutionMs` (10 ms) tick — reflected in the four
`ConfirmInputDebounce` instances all sharing one tick source. Checkable via
the `SharedTimingSourceMeta` marker, applied to the two modules that
concretely consume the shared tick (`CommandArbitrationSoftware`,
`MovementSupervisorSoftware`).

### Concept 10 — Event-Dispatcher State-Machine Execution

Origin: ADR-SW-009. Every firmware module is a non-blocking event handler
invoked from the single superloop dispatcher, and the exhibited
`ControllerLifecycleState` machine is driven by the same dispatcher, never
its own scheduling mechanism — demonstrated end-to-end by
`SWRuntimeScenarios::RSCEN_02`/`RSCEN_03`. Checkable via the
`EventDispatcherExecutionMeta` marker, applied to all 7 firmware modules.

### Concept 11 — Single-Owner EEPROM Persistence Access

Origin: `ProductComponents::MemoryManagerSoftware` is the sole module with
ports touching `internalEepromBytes`; every other module reaches
`TravelTime` data only through its `durationOut`/`timingIn` flow
connections, avoiding concurrent/interleaved EEPROM writes on an MCU with no
OS-level locking. Checkable via the `SingleOwnerEepromMeta` marker, applied
to `MemoryManagerSoftware`, the sole owning module.

### Event Catalog & `EventDispatcher` (SWA-06 extension)

> Rendered from `Project/Model/Architecture/software/cross_cutting_concepts/SWEventCatalog.sysml`.
> The single enumerated catalog of every event crossing a module boundary,
> naming the two firmware-level events (`DebouncedInputChanged`,
> `TimerTick`) and the structural home for ADR-SW-009's "event dispatcher".

| Event | Producer | Consumer |
|---|---|---|
| `BeginInstallation` | Installer (external actor) | `Uninstalled` → `Installing` |
| `InstallationVerified` | `InstallController` | `Installing` → `Operational` |
| `InstallationFaultReported` | `InstallController` | `Installing` → `InstallationFault` |
| `DecommissionRequest` | User/Manufacturer (external actor) | `{Idle, Unpowered}` → `Disposed` |
| `PowerLost` | `PowerSupplyModule` | `{Operational, Installing}` → `Unpowered`, via `crossLifecycleEventRelay` |
| `PowerRestored` | `PowerSupplyModule` | `Unpowered` → `Operational`, via `crossLifecycleEventRelay` |
| `DebouncedInputChanged` | `CommandArbitrationSoftwareInternal`'s 4 `ConfirmInputDebounce` instances | `eventDispatcher.pendingIn`/`dispatchedOut` (proxy-port mediated) → `arbitrateChannels` (flow-realized) |
| `TimerTick` | `TimerDriver` | Production flow-realized to `eventDispatcher.pendingIn.timerTick`; state-machine consumption stays on `SystemStates`' native `accept after` (deliberate — no redundant dispatch route) |

`EventDispatcher` (`part def`, mirrors `SystemStates::CrossLifecycleEventRelay`'s
explicit event-routing pattern one layer down) is proxy-port mediated
(`pendingIn`/`dispatchedOut`) and holds at most one pending
instance of each routed event type (`pendingIn.debouncedChange`,
`pendingIn.timerTick` — both `[0..1]`, never queued/batched).

