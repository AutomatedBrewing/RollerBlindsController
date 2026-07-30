/* Software Runtime View (SWA-04): elaborates selected Scenarios (SM-PRD-22)
 * in firmware-execution terms — superloop iteration order, interrupt vs.
 * dispatcher-context execution, and timer/GPIO-driven state transitions —
 * over the internal actions and exhibited state machine defined in the
 * Software Building Block View (SWA-03, SWBuildingBlocks.sysml).
 * arc42 section: ARC-06 Runtime View.
 *
 * Follows the same action-def/succession/doc narration style already
 * established by Architecture/scenarios/Scenarios.sysml (SM-PRD-22), applied
 * one level deeper to firmware-internal participants (crossmapping §2).
 * Per crossmapping §4 Traceability Rule 1, every participant referenced below
 * already exists in SWBuildingBlocks.sysml; per Rule 3, every timing figure
 * matches an existing Product/Software Architecture attribute value — none
 * are invented here.
 */
package SWRuntimeScenarios {
    private import ProductComponents::*;
    private import SWBuildingBlocks::*;
    private import SystemStates::*;
    private import UseCaseActivities::*;

    // Named lifeline participants, mirroring Scenarios.sysml's 'sut' convention.
    part sut {
        part commandArbitration : CommandArbitrationSoftwareInternal = commandArbitrationSoftwareInternal;
        part movementControl : MovementControlSoftwareInternal = movementControlSoftwareInternal;
        part movementSupervisor : MovementSupervisorSoftwareInternal = movementSupervisorSoftwareInternal;
    }

    // ---- RSCEN_01: Superloop Iteration -- Debounced Input to Arbitrated Command ----
    action def RSCEN_01_DebouncedInput_ToArbitratedCommand {
        doc
        /* Elaborates Scenarios::SCEN_01_AutomaticOpen_NormalPath's s1/s2 in firmware-execution
         * terms (ADR-SW-009 event-driven dispatch, ADR-SW-010 GPIO debounce).
         * Pre: controller powered, superloop running, no input line asserted.
         * Trigger: wall switch UP contact closes (local channel).
         * Post: sut.commandArbitration.commandOut carries ControlCommand(direction=up,
         *   mode=automatic, source=local); dispatcher, not the ISR, produced it. */

        action s1 {
            doc /* localRawIn's UP GPIO change-notification interrupt fires; the ISR only
                 * timestamps/flags the raw transition (ADR-SW-009) -- it does not itself
                 * confirm or arbitrate anything. */
        }
        action s2 {
            doc /* sut.commandArbitration.confirmLocalUp (ConfirmInputDebounce) tracks
                 * stableDurationMs against the raw level; RequestInterfaceCircuit's RC
                 * glitch filter (debounceTimeConstantMs=20ms) has already removed
                 * electrical noise upstream, so this stage only needs to absorb genuine
                 * mechanical switch bounce. */
        }
        action s3 {
            doc /* Once stableDurationMs reaches CommandArbitrationSoftware.debounceConfirmMs
                 * (30ms), confirmedLevel becomes true; the event dispatcher (superloop main
                 * loop, not the ISR) is woken by the debounced input-changed event. */
        }
        action s4 {
            doc /* sut.commandArbitration.arbitrateChannels (ArbitrateAndDetectConflict) finds
                 * no opposing remote edge within arbitrationWindowMs (100ms), so it passes
                 * the local UP edge through unchanged onto commandOut (receiveControlRequest,
                 * acceptLocalCmd branch, no conflict). */
        }

        succession s1 then s2 then s3 then s4;
    }

    // ---- RSCEN_02: GPIO Conflict-Detection Path -- Simultaneous UP+DOWN Suppressed ----
    action def RSCEN_02_SimultaneousUpDown_ConflictDetectedAndSuppressed {
        doc
        /* Elaborates Scenarios::SCEN_07_ConflictingUpDownCommand_Suppressed in
         * firmware-execution terms; safety-relevant (REQ-S-01).
         * Pre: controller powered; lifecycle machine in Idle; no movement in progress.
         * Trigger: local UP and remote DOWN GPIO change-notification interrupts fire
         *   within CommandArbitrationSoftware.arbitrationWindowMs (100ms) of each other.
         * Post: motor never energized; lifecycle machine reaches ConflictSuppressed. */

        action s1 {
            doc /* Local UP and remote DOWN change-notification interrupts each fire; ISRs
                 * only timestamp/flag their own raw transition (ADR-SW-009). */
        }
        action s2 {
            doc /* sut.commandArbitration.confirmLocalUp and .confirmRemoteDown each
                 * independently confirm their edge after debounceConfirmMs (30ms) --
                 * both dispatched as debounced input-changed events. */
        }
        action s3 {
            doc /* sut.commandArbitration.arbitrateChannels (ArbitrateAndDetectConflict)
                 * observes both confirmed edges within arbitrationWindowMs and forces the
                 * resulting ControlCommand.direction := MovementDirection::none instead of
                 * passing either channel through -- the UP+DOWN conflict-detection mechanism
                 * realizing CommandArbitrationSoftware's documented responsibility. */
        }
        action s4 {
            doc /* sut.movementControl.translateCommand (DetermineMovementRequest) receives
                 * the conflict-resolved command; suppressMovement branch fires
                 * (request.direction := none) -- motor never energized (REQ-S-01). */
        }
        action s5 {
            doc /* sut.movementSupervisor's exhibited lifecycle machine transitions
                 * Idle -> AssessingSimultaneousHold on accept ControlCommand[direction==none];
                 * no ConfigModeEvent[activated] can arrive (cross-channel hold), so the
                 * 'accept after 5.0[SI::s]' transition fires -> ConflictSuppressed -> Idle
                 * (SystemStates::ControllerLifecycleState, exhibited per SWA-03). */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // ---- RSCEN_03: Movement-Supervision Timer Tick -- Automatic Timeout Stop ----
    action def RSCEN_03_SupervisionTimerTick_AutomaticTimeoutStop {
        doc
        /* Elaborates Scenarios::SCEN_01_AutomaticOpen_NormalPath's s5/s6/s7 in
         * firmware-execution terms (ADR-003 timer-based supervision, ADR-SW-009 tick).
         * Pre: lifecycle machine in MovingAutomatic; motor energized UP.
         * Trigger: elapsed ticks since movement start reach the loaded openTime.
         * Post: motor de-energized; lifecycle machine back in Idle. */

        action s1 {
            doc /* The single periodic timer interrupt fires every
                 * MovementSupervisorSoftware.timerResolutionMs (10ms, ADR-SW-009); its ISR
                 * only increments the shared tick counter -- no movement-timeout comparison
                 * happens inside the ISR itself. */
        }
        action s2 {
            doc /* Once per superloop iteration, the event dispatcher invokes
                 * sut.movementSupervisor's do action (MovingAutomatic.monitorStopCondition,
                 * MonitorStopCondition's monitorTimeout branch), comparing elapsed ticks
                 * against the openTime loaded via MemoryManagerSoftware (loadTimingProfile). */
        }
        action s3 {
            doc /* Elapsed time reaches the loaded openTime; monitorTimeout fires
                 * StopRequest[reason == StopReason::timeout]. */
        }
        action s4 {
            doc /* sut.movementSupervisor's exhibited lifecycle machine transitions
                 * MovingAutomatic -> Idle on accept StopRequest[reason==timeout];
                 * MovingAutomatic's exit action stopShutterMovement de-energizes the motor
                 * (SystemStates::ControllerLifecycleState, exhibited per SWA-03). */
        }

        succession s1 then s2 then s3 then s4;
    }
} // package SWRuntimeScenarios
