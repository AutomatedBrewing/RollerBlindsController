/* System States (SM-PRD-23) — Controller Lifecycle State Model.
 *
 * Models the ShutterController's operational lifecycle as a single state machine exhibited on
 * a part specializing LogicalArchitecture::RollerShutterControllerLogicalComponents.
 * Kept at the Logical Architecture layer (technology-independent).
 * Sources: Requirements (SM-PRD-10), UseCases (SM-PRD-12), UseCaseActivities (SM-PRD-14),
 *          LogicalArchitecture (SM-PRD-20), ProductArchitecture (SM-PRD-21), Scenarios (SM-PRD-22).
 *
 * Traceability Rules (crossmapping/system-states.md §4):
 *  1. Every state def is exhibited on a Logical Architecture part def.
 *  2. Every Use Case Activity referenced below is cited by its exact name.
 *  3. Every transition has a named trigger event, EXCEPT completion transitions ('then <target>;')
 *     — used only where no external event ends the state (ConflictSuppressed).
 *  4. Every reachable non-terminal state has >= 1 outgoing transition; terminal states
 *     (InstallationFault, Disposed) are explicitly marked.
 *  5. Safety-relevant states (ConflictSuppressed) trace to REQ-S-01.
 *  6. Deterministic: guards sharing a trigger are mutually exclusive (verified per-state below).
 *
 * CrossLifecycleEventRelay: explicit event-routing part; routes PowerLost/PowerRestored across the
 *  boundary between ProductComponents (producer) and the Logical-layer state machine (consumer),
 *  since bare 'accept' defaults its receiver to the containing part.
 *
 * Dual-host summary — both exhibit the SAME ControllerLifecycleState def, no
 * duplicated body:
 *   | Host part def                        | Layer             | Usage name                            |
 *   |---------------------------------------|-------------------|----------------------------------------|
 *   | RollerShutterControllerWithLifecycle   | Logical           | rollerShutterControllerWithLifecycle   |
 *   | MovementSupervisorSoftwareInternal     | Product/Software  | movementSupervisorSoftwareInternal     |
 */
package SystemStates {
    private import LogicalArchitecture::*;
    private import UseCaseActivities::*;
    private import DomainKnowledge::*;
    private import SI::*;
    // SI imported for AssessingSimultaneousHold's 'accept after' duration literal ([SI::s]).

    // =========================================================================
    // Trigger events
    // =========================================================================

    // ---- Documented-trigger formalizations ---------------------------------
    // Typed events mirroring existing UseCaseMeta.trigger strings or UCActivities.sysml outcomes.

    attribute def BeginInstallation {
        doc /* Formalization of UC_02_InstallController's trigger ("Installer begins physical installation"); no payload. */
    }

    attribute def InstallationVerified {
        doc /* Formalization of UseCaseActivities::InstallController's happy-path outcome
             * (verifyWorking.success == true or retryVerifyWorking.success == true -> assembleWallswitch). */
    }

    attribute def InstallationFaultReported {
        doc /* Formalization of UseCaseActivities::InstallController's terminal fault branch
             * (retryVerifyWorking.success == false -> reportInstallationFault). */
    }

    attribute def DecommissionRequest {
        doc /* Formalization of UC_05_DisposeController's trigger ("Controller retired at end of life"). */
    }

    // ---- Gap-derived placeholders -------------------------------------------
    // Structural placeholder events mirroring Scenarios.sysml '// GAP:' comments; no component currently raises these.

    attribute def PowerLost {
        doc
        /* GAP-derived (Scenarios::SCEN_15_PowerLoss_DuringMovement). Producer = ProductComponents::PowerSupplyModule
         * (true->false transition of supplyPresent); consumer = Operational (all 6 powered sub-states, hoisted
         * once) and Installing -> Unpowered. Routed via CrossLifecycleEventRelay.
         * ADR-002 scope unchanged (no self-healing). */
    }

    attribute def PowerRestored {
        doc
        /* GAP-derived (Scenarios::SCEN_16_PowerRecovery_AfterOutage). Producer = ProductComponents::PowerSupplyModule
         * (false->true transition of supplyPresent); consumer = Unpowered (-> Operational, entering at Idle via
         * Operational's own entry, after loadTimingProfile). Routed via CrossLifecycleEventRelay. */
    }


    // =========================================================================
    // Cross-lifecycle event relay — explicit event-routing element.
    // =========================================================================

    part def CrossLifecycleEventRelay {
        doc
        /* Explicit event-routing element routing PowerLost and PowerRestored across the boundary
         * between ProductComponents::PowerSupplyModule (producer) and the Logical-layer systemLifecycle
         * (consumer), making 'via crossLifecycleEventRelay' accept clauses structurally verifiable.
         * ConfigModeEvent is within systemLifecycle's own scope and does NOT route through this relay. */
    }

    /* Single named routing endpoint referenced by every 'via crossLifecycleEventRelay' accept clause. */
    part crossLifecycleEventRelay : CrossLifecycleEventRelay;

    // =========================================================================
    // State def taxonomy -- top-level controller lifecycle (SM-PRD-23)
    // =========================================================================

    state def ControllerLifecycleState {
        doc
        /* Root state for the ShutterController's operational lifecycle, refining
         * SystemProcesses::ControllerLifecycle (install -> configure -> operate).
         * The full nested state/transition body lives here (in the def), not on any
         * individual 'exhibit state' usage, so multiple hosts at different
         * architecture layers (RollerShutterControllerWithLifecycle at the Logical
         * layer, ProductComponents::MovementSupervisorSoftware-based firmware host
         * at the Product/Software layer, per SWA-02/PLAN Phase 3) can each exhibit
         * this SAME def by reference, without duplicating the body. */

        entry; then Uninstalled;

        state Uninstalled {
            doc
            /* Pre-installation state; exits on BeginInstallation (-> Installing).
             * Traces to UC_02_InstallController precondition ("Power supply to the shutter circuit isolated/off"). */
            accept BeginInstallation then Installing;
        }

        state Installing {
            doc
            /* Realizes UC_02_InstallController end-to-end; bounded single retry modeled inside InstallController.
             * Exit: InstallationVerified (-> Idle) or InstallationFaultReported (-> InstallationFault). REQ-Q-01.
             * Powered, non-terminal: mirrors Operational's own PowerLost
             * handling rather than leaving this plausible powered state uncovered. */
            entry action installController : InstallController;
            accept InstallationVerified      then Operational;
            accept InstallationFaultReported then InstallationFault;
            accept PowerLost via crossLifecycleEventRelay then Unpowered;
        }

        state InstallationFault {
            doc
            /* Terminal fault state: second consecutive verification attempt failed; external repair required (SCEN_12).
             * TERMINAL — no outgoing transitions (Traceability Rule 4). REQ-Q-01. */
            entry action reportInstallationFault : ReportInstallationFault;
        }

        state Operational {
            doc
            /* Composite super-state: groups the 6 powered/operational
             * sub-states so PowerLost coverage and future powered-state additions are enforced once
             * at this level, not per-sibling. Entry mirrors the root's own 'entry; then Uninstalled;'
             * idiom so external transitions target Operational directly (no qualified nested path). */

            entry; then Idle;

            state Idle {
                doc
                /* Controller powered, installed, and at rest — awaiting the next command, configuration,
                 * or decommission request. Guards on ControlCommand partition exhaustively and mutually
                 * exclusively on direction==none vs. automatic+direction!=none vs. manual+direction!=none
                 * (Rule 6). ControlCommand[direction==none] leads to AssessingSimultaneousHold (not
                 * directly to ConflictSuppressed), discriminating a brief conflict from a sustained
                 * local calibration hold. PowerLost is handled once at the Operational level. */
                accept ControlCommand [direction == MovementDirection::none]
                    then AssessingSimultaneousHold;
                accept ControlCommand [mode == MovementMode::automatic and direction != MovementDirection::none]
                    then MovingAutomatic;
                accept ControlCommand [mode == MovementMode::manual and direction != MovementDirection::none]
                    then MovingManual;
                accept DecommissionRequest then Disposed;
            }

            state AssessingSimultaneousHold {
                doc
                /* Discriminator state between ConflictSuppressed and ConfigurationMode: both arise from the same
                 * simultaneous UP+DOWN gesture, resolved by waiting up to calibrationHoldThresholdS (5.0 s).
                 * ConfigModeEvent[activated] fires only when the hold is local-only (REQ-F-08); a remote-originated
                 * hold or any short gesture falls through the timeout leg to ConflictSuppressed.
                 * Rule 6: exactly one of the two transitions fires — no double-firing possible.
                 * SCEN_07 -> ConflictSuppressed; SCEN_13 -> ConfigurationMode.
                 * ConfigModeEvent is within systemLifecycle's own scope and does NOT route through CrossLifecycleEventRelay. */
                accept ConfigModeEvent [kind == ConfigModeTransition::activated]
                    then ConfigurationMode;
                accept after 5.0 [SI::s] // mirrors ProductComponents::ConfigurationManagerSoftware.calibrationHoldThresholdS
                    then ConflictSuppressed;
            }

            state MovingAutomatic {
                doc
                /* Realizes UseCaseActivities::OpenShutterAutomatically/CloseShutterAutomatically (UC_01a/UC_01b).
                 * Do: MonitorStopCondition (fork/merge: listenForStopCommand vs. monitorTimeout). Exit: StopRequest
                 * (timeout or userRequest, both -> Idle). StopReason has exactly two members so guards are
                 * exhaustive and mutually exclusive (Rule 6). PowerLost handled once at Operational level. REQ-F-04. */
                entry action startShutterMovement  : StartShutterMovement;
                do    action monitorStopCondition  : MonitorStopCondition;
                exit  action stopShutterMovement   : StopShutterMovement;
                accept StopRequest [reason == StopReason::timeout]     then Idle;
                accept StopRequest [reason == StopReason::userRequest] then Idle;
            }

            state MovingManual {
                doc
                /* Realizes UseCaseActivities::OpenShutterManually/CloseShutterManually (UC_01c/UC_01d), hold-to-run.
                 * Do: MonitorUserInterruption (fork/merge: listenForRelease vs. monitorTimeout). Exit: StopRequest
                 * (timeout or userRequest, both -> Idle). PowerLost handled once at Operational level. REQ-F-05.
                 * The latched-stopped-until-release guard's structural owner is
                 * ProductComponents::CommandArbitrationSoftware — per its doc (ADR-SW-010) it reports only a
                 * genuine, debounce-confirmed edge, not a continuously-held level, so the still-asserted
                 * input does not re-trigger ControlCommand until an actual release+re-press edge occurs. */
                entry action startShutterMovement    : StartShutterMovement;
                do    action monitorUserInterruption : MonitorUserInterruption;
                exit  action stopShutterMovement     : StopShutterMovement;
                accept StopRequest [reason == StopReason::timeout]     then Idle;
                accept StopRequest [reason == StopReason::userRequest] then Idle;
            }

            state ConflictSuppressed {
                doc
                /* Realizes UseCaseActivities::HandleConflictingMovementCommands (UC_01e); motor already de-energized
                 * upstream (REQ-S-01). Entered from AssessingSimultaneousHold on timeout; completes unconditionally
                 * back to Idle via completion transition (no external event ends this state). Safety-relevant (Rule 5). */
                then Idle;
            }

            state ConfigurationMode {
                doc
                /* Realizes UseCaseActivities::ConfigureController (UC_03) — travel-time calibration (REQ-F-07).
                 * Entry via AssessingSimultaneousHold on ConfigModeEvent[activated] (local-only hold confirmed, REQ-F-08).
                 * Do: ConfigureController, including out-of-range guard (checkOpenTimeInRange, REQ-F-07 <= 120 [SI::s]).
                 * Only open-travel time is measured; same value used for both directions since travel times are equal (REQ-F-06).
                 * Self-transition on ConfigModeEvent[activated] rejects reentry without interrupting the session (TC_N_002).
                 * Guards kind==activated vs. kind==deactivated are mutually exclusive (Rule 6). REQ-F-07, REQ-F-08. */
                do action configureController : ConfigureController;
                accept ConfigModeEvent [kind == ConfigModeTransition::activated]
                    do action rejectConfigurationModeReentry : RejectConfigurationModeReentry;
                    then ConfigurationMode;
                accept ConfigModeEvent [kind == ConfigModeTransition::deactivated]
                    then Idle;
            }

            // Hoisted once from the 4 sibling duplicates; also extends coverage to
            // AssessingSimultaneousHold/ConflictSuppressed.
            accept PowerLost via crossLifecycleEventRelay then Unpowered;
        }

        state Unpowered {
            doc
            /* Unifies SCEN_15/SCEN_16 "no power" episode into a single observable state, reachable from any
             * powered Operational sub-state via PowerLost. Exit: PowerRestored -> Operational (loadTimingProfile,
             * re-entering at Idle) or DecommissionRequest -> Disposed. No entry action — de-energization is
             * electrically passive (SCEN_15 GAP). Shutter position is not restored on power recovery
             * (SCEN_16 GAP). REQ-Q-02, ADR_002. */
            accept PowerRestored via crossLifecycleEventRelay
                do action loadTimingProfile : LoadTimingProfile;
                then Operational;
            accept DecommissionRequest then Disposed;
        }

        state Disposed {
            doc
            /* Terminal state realizing UC_05_DisposeController; controller disposed/recycled per WEEE/RoHS.
             * TERMINAL — no outgoing transitions (Traceability Rule 4). REQ-E-01. */
            entry action disposeController : DisposeController;
        }
    }

    // =========================================================================
    // Top-level state machine.
    // =========================================================================

    part def RollerShutterControllerWithLifecycle :> RollerShutterControllerLogicalComponents {
        doc
        /* Additive specialization (no existing file modified) adding an exhibited lifecycle
         * state machine to the validated Logical Architecture composite, using ':>' (strong-coupling pattern).
         * The full state/transition body is defined once on ControllerLifecycleState itself (the def, above);
         * this usage is a plain reference so the same def can also be exhibited, without duplication, by a
         * firmware host at the Product/Software layer (see ProductComponents::MovementSupervisorSoftware's
         * specializing part def in Architecture/software/building_block_view/SWBuildingBlocks.sysml, SWA-03). */

        exhibit state systemLifecycle : ControllerLifecycleState;
    }

    /* Named feature endpoint for traceability links (mirrors existing architecture-layer package-level part usages). */
    part rollerShutterControllerWithLifecycle : RollerShutterControllerWithLifecycle;
} // package SystemStates
