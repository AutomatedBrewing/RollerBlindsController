# 6. Runtime View

> Rendered from `Project/Model/Architecture/scenarios/Scenarios.sysml` (21
> scenarios: `SCEN_01`–`SCEN_17`, `SCEN_21`–`SCEN_23`, `SCEN_25`; `SCEN_18`–
> `20`/`24` are intentionally not assigned). Each scenario traces to exactly
> one UseCaseActivities path and names its Logical/Product participants
> (Traceability Rules, `crossmapping/scenarios.md §4`). Selected below are
> the architecturally most significant; the full scenario catalogue is
> available in the `.sysml` source.

## Scenario 1 — Automatic Open, Normal Path (`SCEN_01`)

UCA path: `UseCaseActivities::OpenShutterAutomatically` (UC_01a).
Mission-critical: core movement capability.

- Precondition: powered; `logicalMovementSupervisor` idle; shutter not
  already fully open.
- Trigger: User asserts UP on the wall switch (momentary press).
- Flow: `LogicalLocalRequestInterface` → `LogicalControlUnit` (arbitration,
  no conflict) → `LogicalMovementSupervisor`/`LogicalMotorDrive`
  (`MovementRequest`) → motor energized UP → timeout from `TravelTime`
  stops movement.
- Postcondition: shutter fully open; motor de-energized;
  `shutterState.moving == false`.

`SCEN_02` (`AutomaticClose_NormalPath`) mirrors this for UC_01b/DOWN.

## Scenario 2 — Manual Hold, Safety Timeout Stop (`SCEN_05`)

UCA path: `MonitorUserInterruption` (UC_01c/d), `monitorTimeout` branch.
Illustrates the fork/merge "first-wins" pattern stopping on whichever of
user-release or safety timeout fires first — the primary manual-mode safety
mechanism given no position feedback (ADR-003).

## Scenario 3 — Conflicting UP+DOWN Command, Suppressed (`SCEN_07`)

UCA path: `HandleConflictingMovementCommands` (UC_01e) —
`receiveControlRequest`→`determineMovementRequest` (`suppressMovement`)→
`startShutterMovement` (`suppressMotor`). Safety-relevant (REQ-S-01): motor
never energizes in either direction. The conflict is silently suppressed —
no buzzer fires (buzzer scope is config-mode activation/deactivation only,
per REQ-F-08/ADR-008).

## Scenario 4 — Local + Remote Simultaneous, Equal-Priority Stop Arbitration (`SCEN_09`)

UCA path: `MonitorStopCondition`/`MonitorUserInterruption`'s channel-agnostic
fork/merge (REQ-F-06). Local UP starts automatic movement; while the
movement is in progress, a remote DOWN is asserted. `listenForStopCommand`
accepts the remote DOWN identically to a local stop — neither channel has
priority over the other — and the shutter stops immediately at an
intermediate position.

## Scenario 5 — Configure Controller, Timing Calibration (`SCEN_13`)

UCA path: `ConfigureController` — installer holds simultaneous UP+DOWN
beyond `calibrationHoldThresholdS` (5.0 s, discriminates from a transient
UP+DOWN conflict per `AssessingSimultaneousHold`); shutter driven to a
reference position, full travel timed (`CountActionTimeFE`), result saved
via `MemoryManagerSoftware` to internal EEPROM; user notified of activation
and deactivation (REQ-F-08).

## Scenario 6 — Invalid Calibration Rejected (`SCEN_22`)

UCA path: `ConfigureController`'s `checkOpenTimeInRange` gate diverts an
out-of-range measurement (>120 s, REQ-F-07 boundary) into
`RejectOutOfRangeCalibration` instead of persisting it; mitigates RISK-T-05
(misconfiguration during install).

## Scenario 7 — Mechanical Jam, Time-Based Stop Without Feedback (`SCEN_17`)

UCA path: `MonitorStopCondition`'s `monitorTimeout` branch — the **only**
stop mechanism available on a jam, by design (ADR-003, no position sensor).
Mission-critical: directly exercises RISK-T-01 (positioning drift), the
architecture's explicitly accepted residual risk. Direct test precedent:
`TC_N_004_NoPosiitonFeedback_TimeBased`.

## Scenario 8 — Power Loss During Movement / Recovery (`SCEN_15`/`SCEN_16`)

No corresponding UCA action exists (traces only to `ADR_002_Availability`'s
explicit "no self-healing, failover, or watchdog architecture" decision and
`SystemObjectives::reliability`). On `controlPower` loss, the motor relay
coil de-energizes passively (fail-safe by circuit design, not firmware).
On recovery, `ControlMCU` reboots and `MemoryManagerSoftware` reloads the
persisted `TravelTime`/`wiringMode` from EEPROM; the shutter's physical
position is NOT recoverable (no position feedback) — an accepted,
documented limitation.

## Scenario 9 — Field Diagnosis

**Note:** an earlier `DiagnosticsSoftware`/`LogicalDiagnostics` component and
its `FaultClass`/`FaultIndicationPort` were removed from the model
permanently (`PLAN.md`); no field-diagnosis scenario or UC exists in the
current model. This section intentionally no longer describes one.

## Scenario 10 — Boundary Condition, Low-Temperature Automatic Open (`SCEN_25`)

Identical UCA path to `SCEN_01`, performed at the
`L0_Constraints::Environmental::operatingConditions` minimum boundary (0 °C).
Direct test precedent: `TC_B_004_OperatingTemp_LowerBoundary`.

## Documented Open Gaps (informative, not defects)

Several scenarios carry explicit `// GAP:` comments flagging unresolved
model-level questions rather than silently inventing a resolution
(`Scenarios.sysml` Traceability Rule 3):

- `SCEN_15`/`SCEN_16` (power-loss/recovery): no Logical or Product component
  observes, logs, or reacts to a `controlPower` interruption; no position
  persistence or recovery exists (ADR-002's explicit no-watchdog/no-failover
  scope, compounded by the no-position-feedback design, ADR-003/RISK-T-01).
- `SCEN_17` (mechanical jam): no fault classification, indication, or
  recovery mechanism distinguishes a mid-travel jam from normal completion —
  ADR-003's explicitly accepted residual risk (RISK-T-01).
- `SCEN_21` (`DisposeController`): UC_05 remains an intentionally
  underspecified stub (single doc-only action).
- `SCEN_23` (`LocalControl_WiringModeMismatch`): no UseCaseActivities action
  models wiring-mode-mismatch detection specifically; the closest anchor is
  `handleConflictingMovementCommands` (see
  [11-risks-and-technical-debts.md](11-risks-and-technical-debts.md)).

## Software Runtime Scenarios (SWA-04)

> Rendered from `Project/Model/Architecture/software/runtime_view/SWRuntimeScenarios.sysml`.
> Elaborates selected scenarios above in firmware-execution terms — superloop
> iteration order, ISR vs. dispatcher-context execution, and timer/GPIO-driven
> state transitions — over the internal actions/states from
> [05-building-block-view.md §5.4](05-building-block-view.md).

### RSCEN_01 — Debounced Input to Arbitrated Command

Elaborates `SCEN_01`'s early steps: a GPIO change-notification interrupt
timestamps a raw UP transition (ISR context only); `confirmLocalUp`
confirms it stable after `debounceConfirmMs` (30 ms); the dispatcher (not
the ISR) is woken by the debounced event; `arbitrateChannels` finds no
opposing edge within `arbitrationWindowMs` (100 ms) and passes it through
unchanged.

### RSCEN_02 — Simultaneous UP+DOWN, Conflict Detected and Suppressed

Elaborates `SCEN_07` in firmware-execution terms (safety-relevant,
REQ-S-01): local UP and remote DOWN interrupts each confirm independently;
`arbitrateChannels` detects both confirmed edges within the arbitration
window and forces `direction := none`; `translateCommand` suppresses
movement; the exhibited lifecycle machine walks
`Idle → AssessingSimultaneousHold → ConflictSuppressed → Idle`.

### RSCEN_03 — Movement-Supervision Timer Tick, Automatic Timeout Stop

Elaborates `SCEN_01`'s stop path: the single periodic timer ISR only
increments a tick counter; once per superloop iteration the dispatcher
invokes the do-action comparing elapsed ticks against the loaded `openTime`;
on timeout, `StopRequest[reason==timeout]` fires and the lifecycle machine
transitions `MovingAutomatic → Idle`, de-energizing the motor.
