# 6. Runtime View

> Rendered from `model/Architecture/scenarios/Scenarios.sysml` (25 scenarios,
> `SCEN_01`–`SCEN_25`). Each scenario traces to exactly one UseCaseActivities
> path and names its Logical/Product participants (Traceability Rules,
> `crossmapping/scenarios.md §4`). Selected below are the architecturally
> most significant; the full 25-scenario catalogue is available in the
> `.sysml` source.

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
`startShutterMovement` (`suppressMotor`)→`stopShutterMovement`→
`notifyUserAboutConflict`. Safety-relevant (REQ-S-01/REQ-S-02): motor never
energizes in either direction; conflict indication raised via
`LogicalControlUnit.conflictOut` → `LogicalUserNotification.conflictEventIn`
(buzzer pattern, ADR-008).

## Scenario 4 — Local + Remote Simultaneous, First-Wins Arbitration (`SCEN_09`)

UCA path: `ReceiveControlRequest`'s fork/merge, **same-direction** case
(distinguishes from `SCEN_07`'s opposite-direction conflict). Both channels
assert UP within `CommandArbitrationSoftware.arbitrationWindowMs` (50 ms);
exactly one `ControlCommand` is arbitrated through (whichever accept fires
first); no conflict raised since both channels agree.

## Scenario 5 — Configure Controller, Timing Calibration (`SCEN_13`)

UCA path: `ConfigureController` — installer holds simultaneous UP+DOWN
beyond `calibrationHoldThresholdS` (3.0 s, discriminates from a transient
UP+DOWN conflict per `AssessingSimultaneousHoldState`); shutter driven to a
reference position, full travel timed (`CountActionTimeFE`), result saved
via `MemoryManagerSoftware` to internal EEPROM; user notified of activation
and deactivation (REQ-F-08).

## Scenario 6 — Invalid Calibration Rejected (`SCEN_22`)

UCA path: `ConfigureController`'s `openRangeGuard` decide node diverts an
out-of-range measurement (>120 s, REQ-F-07 boundary) into
`RejectOutOfRangeCalibration` instead of persisting it — closes MAJ-8 (SMRR
corrective pass); mitigates RISK-T-05 (misconfiguration during install).

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

## Scenario 9 — Timing Profile Persistence Failure at First Power-On (`SCEN_24`)

UCA path: `LoadTimingProfile`, followed by the diagnostic fault-
classification pattern reused from `SCEN_18`–`20`. `MemoryManagerSoftware`
is the explicit architectural owner of a `TimingProfileReadFailure` event
(CRIT-4 fix), routed via `SystemStates::crossLifecycleEventRelay`.

## Scenario 10 — Field Diagnosis (`SCEN_18`/`SCEN_19`/`SCEN_20`)

UCA path: `DiagnoseAndRepairController` (UC_04) — `DiagnosticsSoftware`
classifies `FaultClass::noResponseToControlInput` vs.
`motorDriveFault` using `commandStateIn`/`diagnosticStateIn` taps; result
routed to `UserFeedbackSoftware` via `FaultIndicationPort` (distinct buzzer
pattern). "No power" is deliberately excluded from `FaultClass` — it is
passively observable as "buzzer entirely silent."

## Scenario 11 — Boundary Condition, Low-Temperature Automatic Open (`SCEN_25`)

Identical UCA path to `SCEN_01`, performed at the
`L0_Constraints::Environmental::operatingConditions` minimum boundary (0 °C).
Direct test precedent: `TC_B_004_OperatingTemp_LowerBoundary`.

## Documented Open Gaps (informative, not defects)

Several scenarios carry explicit `// GAP:` comments flagging unresolved
model-level questions rather than silently inventing a resolution
(`Scenarios.sysml` Traceability Rule 3):

- `SCEN_05`: no explicit "latched-stopped-until-release" guard documented on
  `MonitorUserInterruption`/`LogicalMovementSupervisor`.
- `SCEN_07`: same-direction vs. opposite-direction fork/merge race not
  explicitly distinguished at the UCA layer.
- `SCEN_21` (`DisposeController`): UC_05 remains an intentionally
  underspecified stub (single doc-only action).
- `SCEN_23` (`LocalControl_WiringModeMismatch`): no UseCaseActivities action
  models wiring-mode-mismatch detection specifically (SR-8, explicitly left
  open — see [11-risks-and-technical-debts.md](11-risks-and-technical-debts.md)).
- `SCEN_24`: `LoadTimingProfile`'s doc does not specify invalid/blank-read
  behavior explicitly.
