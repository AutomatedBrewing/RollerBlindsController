/* Software Solution Strategy (SWA-02) — executive summary of the fundamental
 * software approach, bridging Product Architecture (SM-PRD-21) to the deeper
 * Software Building Block View (SWA-03). arc42 section: ARC-04 Solution Strategy.
 */
package SWSolutionStrategy {
    private import ADR_009_SWExecutionModel::*;
    private import ADR_010_InputDebouncing::*;
    private import ADR_011_SoftwareLayering::*;
    private import SWConstraints::*;
    private import ProductComponents::*;
    private import SystemStates::*;

    // =========================================================================
    // 1 -- Constraints Envelope (SWA-01)
    // =========================================================================
    // Split into per-topic doc blocks below (previously one ~100-line block).
    doc
    /* Every choice below is made within SWConstraints.sysml's (SWA-01) ceilings:
     * noRtosAvailable rules out an RTOS a priori; flashBudget/ramBudget bound the
     * seven modules' combined footprint; isrLatencyBudget bounds every ISR body;
     * dispatcherDeterminism requires the dispatcher to preserve the state
     * model's already-verified determinism (Rule 6). */

    // =========================================================================
    // 2 -- ADR-SW-010 Recap: Input Debouncing
    // =========================================================================
    doc
    /* Each of the four wall-switch/remote lines (local/remote up/down) has a
     * dedicated GPIO change-notification interrupt; RequestInterfaceCircuit's RC
     * filter removes only electrical noise, so CommandArbitrationSoftware adds a
     * software debounce-confirmation stage (debounceConfirmMs) before treating a
     * transition as genuine. */

    // =========================================================================
    // 3 -- ADR-SW-009 Recap: Execution Model
    // =========================================================================
    doc
    /* A periodic 10ms timer tick (ADR-003/timerResolutionMs) drives movement
     * supervision; the main loop is an event dispatcher reacting to debounced
     * input-changed events and the timer tick, with every module a non-blocking
     * event handler invoked from it. Compatible with porting the team's existing
     * FreeRTOS-backed event library to bare-metal later (open item, ADR_009). */

    // =========================================================================
    // 4 -- Decomposition Rationale (SWA-03 scope)
    // =========================================================================
    // Names the driver-layer question ADR-SW-011 answers; reflects that 6 of 7modules now
    // have SWA-03 whitebox structure, not 2.
    doc
    /* Product Architecture (ADR-006/007) fixes the seven part def boundaries;
     * SWA-03 reuses them unchanged. CommandArbitrationSoftware/MovementControlSoftware
     * get full algorithmic whitebox decomposition; MovementSupervisorSoftware,
     * MotorDriveControlSoftware, UserFeedbackSoftware, MemoryManagerSoftware each get
     * one driver (ADR-SW-011 answers "is a driver layer needed underneath" — yes,
     * uniformly). Only ConfigurationManagerSoftware stays blackbox (no hardware port). */

    // =========================================================================
    // 5 -- State-Machine Hosting Assignment (SWA-03 Rule 2)
    // =========================================================================
    doc
    /* SystemStates::ControllerLifecycleState (SM-PRD-23) is hosted on
     * MovementSupervisorSoftware — the sole module with strong ADR-007 coupling.
     * Hosting means it structurally exhibits the machine; other modules still
     * coordinate entry/do/exit actions via the ADR-SW-009 dispatcher. Realized
     * in SWBuildingBlocks.sysml (SWA-03, Phase 3). */

    // =========================================================================
    // 6 -- Resource Strategy Outcome (SWA-05)
    // =========================================================================
    doc
    /* Aggregate firmware footprint fits ControlMCU's budget with SWA-01's 10%
     * margin applied: 5600B flash of 14745.6B (~9145.6B margin), 216B RAM of
     * 921.6B (~705.6B margin) — SWResourceBudget.sysml. No module-boundary or
     * execution-model change was forced by resource pressure. */

    // Downstream artifacts enabled: SWA-03 (SWBuildingBlocks.sysml), SWA-04
    // (SWRuntimeScenarios.sysml), SWA-05 (SWResourceBudget.sysml), SWA-06
    // (SWCrossCuttingConcepts.sysml).

    /* Every strategic choice above is elaborated in full as an ADR (Traceability Rule 1,
     * architecture-decisions.md §4): execution model -> ADR_009_SWExecutionModel;
     * input debouncing/GPIO strategy -> ADR_010_InputDebouncing. */
} // package SWSolutionStrategy
