/* Architecture Decision Record: ADR-SW-009 — Firmware Execution Model.
 * Documents how ControlMCU's seven firmware modules are actually scheduled at runtime
 * (SWA-02 Software Solution Strategy, continuing the Product Architecture SM-PRD-21).
 * Scope is deliberately limited to the scheduling/dispatch model; the input
 * debouncing/GPIO strategy is a separate, atomic decision — see
 * ADR_010_InputDebouncing.sysml (ADR-SW-010).
 * arc42 section: ARC-09 Architecture Decisions.
 */
package ADR_009_SWExecutionModel {
    private import ProductComponents::*;
    private import ADR_001_CostConstraint::*;
    private import ADR_003_TimeBased::*;
    private import ADR_Common::*;

    package ADR_009 {
        @ArchDecisionMeta {
            decisionId = "ADR-SW-009";
            title =
                "Bare-metal, event-driven superloop execution model: the main loop is
                an event dispatcher reacting to debounced input-changed events and a
                periodic movement-supervision timer tick, not a flat polling loop";
            status = "accepted";
            context =
                "ProductComponents::ControlMCU is an 8-bit MCU with 16KB flash / 1KB RAM
                / 16MHz clock (ADR-006); ADR-001's cost ceiling already rules out a more
                capable, RTOS-capable MCU. ADR-003 established timer-based movement
                supervision, realized in ProductComponents::MovementSupervisorSoftware.
                timerResolutionMs (10ms). ADR-SW-010 separately establishes that each of
                the four dry-contact input lines is wired to its own dedicated GPIO with
                a change-notification interrupt and a software debounce-confirmation
                stage; this ADR only concerns itself with the resulting question of HOW
                the firmware is scheduled at runtime, given that it must react to both
                those debounced input-changed events and the periodic timer tick.";
            decision =
                "Firmware overall follows a bare-metal, event-driven superloop model:
                the main loop is an event dispatcher that reacts to (a) debounced
                input-changed events (raised per ADR-SW-010) and (b) a periodic timer
                tick at MovementSupervisorSoftware.timerResolutionMs (10ms) driving
                movement-timeout/hold-to-run supervision. All seven firmware modules
                (CommandArbitrationSoftware, MovementControlSoftware,
                ConfigurationManagerSoftware, MemoryManagerSoftware,
                MovementSupervisorSoftware, MotorDriveControlSoftware,
                UserFeedbackSoftware) are non-blocking event handlers/functions invoked
                from the dispatcher, never blocking inside an ISR.";
            consequences =
                "Every module must be designed as a non-blocking event handler callable
                from the dispatcher; ISR bodies stay minimal (flag/timestamp updates
                only — the actual GPIO/timer resource accounting is ADR-SW-010's and
                the Phase 6 deployment view's (SWA-05) concern). The choice of an
                event-driven dispatch style (vs. a flat polling loop) is intentionally
                compatible with porting the existing FreeRTOS-backed event-driven
                abstraction library to a bare-metal backend (see Phase 4/7 open item
                below) without a foundational rework.";
            alternatives =
                "A. RTOS: rejected — no flash/RAM headroom on ControlMCU and no benefit
                given the absence of any true concurrency requirement; ADR-001 already
                ruled out the MCU upgrade an RTOS-capable part would require.
                B. Cooperative round-robin scheduler with per-module task control
                blocks: rejected — adds RAM overhead with no concurrency benefit for
                seven modules that have no independent timing needs beyond the shared
                event set.
                C. Flat sequential polling loop (no dispatcher abstraction): rejected —
                functionally similar throughput, but does not compose cleanly with
                porting the team's existing event-driven abstraction library to
                bare-metal, and mixes event-reaction logic with iteration bookkeeping
                inside every module instead of a single dispatch point.";
            rationale =
                "Framing the superloop as an event dispatcher (rather than a flat
                sequential poll) is the simplest model that fits the 16KB flash / 1KB
                RAM budget and keeps the firmware architecture compatible with porting
                the team's existing event-driven abstraction library (currently
                FreeRTOS-backed) to a bare-metal backend later, avoiding a structural
                rewrite when that porting work happens.";
        }

        comment
        /* OPEN ITEM: the team has an existing event-driven abstraction library with a FreeRTOS
         * backend, intended to be ported to bare-metal for this project. This ADR commits to an
         * event-driven dispatch *style* compatible with that library, but does NOT yet commit to
         * reusing the library itself, nor has its source been reviewed — that review/decision is
         * deferred to Phase 4 (internal decomposition) / Phase 7 (cross-cutting concepts), once
         * the library sources are available for inspection.
         */
    } // package ADR_009
} // package ADR_009_SWExecutionModel
