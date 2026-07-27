# 8. Cross-cutting Concepts

> Rendered from `model/Analysis/domain/DomainKnowledge.sysml`,
> `model/Architecture/states/SystemStates.sysml`,
> `model/Architecture/base/ADR_003_TimeBased.sysml`,
> `model/Architecture/base/ADR_005_SecurityScope.sysml`.

## Concept 1 — Domain Vocabulary (Single Source of Truth)

`DomainKnowledge` (SM-PRD-15) defines every item/enum/flow type crossing a
function boundary — no downstream package redefines a term. Core types:
`MovementDirection` (`up`/`down`/`none`), `MovementMode` (`automatic`/
`manual`), `StopReason` (`timeout`/`userRequest`), `ConfigModeTransition`,
`ControlCommand`, `MovementRequest`, `StopRequest`, `MotorState`,
`ShutterState`, `TravelTime`, `TravelTime`, `ConfigModeEvent`,
`ConflictEvent`, `DiagnosticRequest`/`DiagnosticResult`,
`FaultIndicationEvent`. See [12-glossary.md](12-glossary.md) for full
definitions.

## Concept 2 — Time-Based, Sensorless Positioning (ADR-003)

The single most pervasive cross-cutting concept: **no component anywhere in
the model reads shutter position.** Movement stop is always derived from
elapsed time against a persisted `TravelTime`, with a `+5s`/
`timingMarginS` margin (`MemoryManagerSoftware`, PA-6 fix) compensating for
cumulative drift (RISK-T-01, the architecture's explicitly accepted residual
risk). This discipline is enforced at every layer: `L0_Constraints::
Architectural::{noPositionFeedback,timeBasedOperation}`,
`UseCaseActivities::MonitorStopCondition`/`MonitorUserInterruption` (fork+
merge, first-of-{command,timeout} wins), through to
`LogicalMovementSupervisor`/`MovementSupervisorSoftware`.

## Concept 3 — First-Wins Arbitration & Conflict Suppression

Local and remote command channels are always received concurrently
(`ReceiveControlRequest`'s fork/merge) and arbitrated first-wins
(`CommandArbitrationSoftware.arbitrationWindowMs = 50 ms`). A simultaneous
opposite-direction (UP+DOWN) assertion is a **conflict**: `direction :=
none` is propagated through `DetermineMovementRequest`→
`StartShutterMovement` so the motor is never energized in either direction
(REQ-S-01), and the suppressed state is always surfaced to the user via a
distinct buzzer pattern (REQ-S-02, `ConflictEvent`→`LogicalUserNotification`/
`UserFeedbackSoftware`). This same dual-channel-hold gesture, distinguished
only by duration (`calibrationHoldThresholdS = 3.0 s`,
`AssessingSimultaneousHoldState`), is also the trigger for entering
Configuration Mode — a single low-level signal pattern deliberately reused
for two distinct semantics.

## Concept 4 — Explicit, User-Signaled Configuration Mode

Configuration Mode (REQ-F-08) is entered/exited only through an explicit,
timed installer gesture, and every entry/exit is signaled to the user
(`ConfigModeEvent`, `DispatchConfigModeNotification`). Calibration
measurements outside the valid range (>120 s, REQ-F-07) are rejected rather
than persisted (`RejectOutOfRangeCalibration`, MAJ-8 fix) — a configuration-
input-validation pattern applied consistently at the UCA, Logical, and
Product layers.

## Concept 5 — State Model (Logical-Layer, Technology-Independent)

`SystemStates.sysml` defines two independent state machines, kept
deliberately at the Logical Architecture layer per explicit instruction that
the state model "shall remain technology-independent where possible":

- **`systemLifecycle`** (`ControllerLifecycleState`, exhibited on
  `RollerShutterControllerLogicalComponents`): `Uninstalled` →
  `Installing` → (`InstallationFault` | `Idle`) → `AssessingSimultaneousHold`
  → (`ConflictSuppressed` | `ConfigurationMode`) → back to `Idle`;
  `MovingAutomatic`/`MovingManual` from `Idle`; `Unpowered` (from any active
  state) → `Idle` on recovery; `Disposed` (terminal).
- **`diagnosticLifecycle`** (`DiagnosticState`, exhibited on
  `LogicalDiagnostics`): `Nominal` → `ClassifyingFault` →
  (`NoResponseFault` | `MotorDriveFault` | `ConfigurationRequiredFault`) →
  `Repairing` → `Nominal`.

Cross-machine event delivery (`FaultReported`, `TimingProfileReadFailure`,
`ConfigModeEvent`, `PowerLost`, `PowerRestored`) between the two otherwise-
unconnected machines is routed via an explicit `CrossLifecycleEventRelay`
part def (MAJOR-2 fix), rather than relying on SysML v2's ambiguous
default "containing part" `accept` receiver.

## Concept 6 — No Dedicated Security Architecture (ADR-005, Scope Boundary)

Every external interface is dry-contact/relay based with no protocol stack,
no addressable identity, and no firmware-update channel — there is no
conventional attack surface. This is an explicit, falsifiable scope
decision (not a silent omission): it must be re-opened the moment any
networked/addressable interface, OTA update mechanism, data-at-rest/in-
transit capability, or remote diagnostic interface is introduced.

## Concept 7 — Firmware Resource Budgeting on a Shared MCU

Every firmware module hosted on `ControlMCU` carries an illustrative
`estimatedFlashBytes`/`estimatedRamBytes` pair (PA-9 fix), summed and checked
against `ControlMCU.flashSizeKB`/`internalRamBytes` — a lightweight,
model-level capacity-planning discipline applied uniformly across all 8
modules rather than to any single one.
