package FunctionalArchitecture {
    private import DomainKnowledge::*;
    private import UseCaseActivities::*;
    private import ISQ::*;
    private import SystemArchitecture_Taxonomy::SystemArchitecture;

    /* Technology-independent functional description of the system (SM-PRD-18, SYSMOD Tool 11.2),
     * derived from UseCaseActivities and allocated to Logical Architecture (SM-PRD-20). */

    // =========================================================================
    // Functional port definitions
    // Typed by DomainKnowledge flow/item types (SM-PRD-15 Traceability Rule 2).
    // =========================================================================

    port def ControlCommandPort {
        doc
        /* Carries a typed ControlCommand from request-acquisition to control-logic. */
        out item command : ControlCommand;
    }

    port def MovementRequestPort {
        doc
        /* Carries a validated MovementRequest from control-logic to downstream FEs. */
        out item request : MovementRequest;
    }

    port def StopRequestPort {
        doc
        /* Carries a StopRequest from movement-supervision to the motor-stop function. */
        out item stopRequest : StopRequest;
    }

    port def MotorStatePort {
        doc
        /* Carries MotorState to the system output boundary (shutter motor relay). */
        out item motorState : MotorState;
    }

    port def ShutterStatePort {
        doc
        /* Carries observable ShutterState for internal FA use (time-counting, UC_03). */
        out item shutterState : ShutterState;
    }

    port def TravelTimePort {
        doc
        /* Carries a TravelTime measurement from time-counting to memory functions. */
        out item travelTime : TravelTime;
    }

    port def ConfigModeEventPort {
        doc
        /* Carries a typed ConfigModeEvent from configuration-control to user-notification functions. */
        out item modeEvent : ConfigModeEvent;
    }

    // =========================================================================
    // FA-level action def refinement
    // =========================================================================

    action def CountActionTimeFE specializes CountActionTime {

        action recordIntervalStart {
            doc
            /* shutterStateIn.moving == true: travel interval begins. */
        }
        action recordIntervalEnd {
            doc
            /* shutterStateIn.moving == false: travel interval ends;
             * measuredTime is derived from the elapsed interval.
             */
        }

        first start;
        decide;
            if shutterStateIn.moving == true then recordIntervalStart;
            else recordIntervalEnd;
    }

    action def ActivateConfigurationModeFE specializes ActivateConfigurationMode {
        out item modeEvent : ConfigModeEvent;
        assign modeEvent.kind := ConfigModeTransition::activated;
    }

    action def ExitConfigurationModeFE specializes ExitConfigurationMode {
        out item modeEvent : ConfigModeEvent;
        assign modeEvent.kind := ConfigModeTransition::deactivated;
    }

    action def DispatchConfigModeNotification {
        in item modeEvent : ConfigModeEvent;

        action notifyConfigActivation : NotifyUserAboutActivationOfConfigurationMode;
        action notifyConfigDeactivation : NotifyUserAboutDeactivationOfConfigurationMode;

        first start;
        decide;
            if modeEvent.kind == ConfigModeTransition::activated then notifyConfigActivation;
            else notifyConfigDeactivation;
    }

    action def SuperviseMovementStop {
        in request : MovementRequest;
        in profile : TravelTime;
        out stopRequest : StopRequest;

        action monitorAutoStop : MonitorStopCondition;
        action monitorManualStop : MonitorUserInterruption;

        first start;
        decide;
            if request.mode == MovementMode::automatic then monitorAutoStop;
            else monitorManualStop;

        flow from request to monitorAutoStop.request;
        flow from request to monitorManualStop.request;
        flow from monitorAutoStop.stopRequest to stopRequest;
        flow from monitorManualStop.stopRequest to stopRequest;
    }

    // =========================================================================
    // Composite Functional Architecture
    // =========================================================================

    part def RollerShutterControllerFunctions :> SystemArchitecture {
        doc
        /* Top-level Functional Architecture composite: technology-independent assembly of
         * Functional Elements derived from UseCaseActivities (SM-PRD-18, Tool 11.2). */

        // ── System boundary ports ─────────────────────────────────────────────
        // Physical signal mapping is deferred to Logical Architecture (SM-PRD-20).
        port controlInput : ~ControlCommandPort;
        port motorOutput : MotorStatePort;
        port shutterOutput : ShutterStatePort;

        // ── Functional Elements ───────────────────────────────────────────────

        part requestAcquisitionFunctions {
            doc
            /* Acquires control inputs from local and remote channels into typed ControlCommand objects
             * (UC_01a-e, ReceiveControlRequest). FAS cluster: physical signal → ControlCommand. */
            port commandIn : ~ControlCommandPort;
            port commandOut : ControlCommandPort;
            perform action receiveRequest : ReceiveControlRequest;
        }

        part controlLogicFunctions {
            doc
            /* Validates the incoming ControlCommand, detects UP+DOWN conflicts, and produces
             * a typed MovementRequest (UC_01e, DetermineMovementRequest). */
            port commandIn : ~ControlCommandPort;
            port requestOut : MovementRequestPort;
            perform action parseRequest : DetermineMovementRequest;
        }

        part movementSupervisionFunctions {
            doc
            /* Monitors stop conditions for in-progress shutter movement: automatic timeout
             * (UC_01a/b, MonitorStopCondition) and manual hold-to-run release/timeout
             * (UC_01c/d, MonitorUserInterruption). commandIn carries equal-priority stop
             * signals from both channels (REQ-F-06). */
            port commandIn : ~ControlCommandPort;
            port requestIn : ~MovementRequestPort;
            port timingIn : ~TravelTimePort;
            port stopOut : StopRequestPort;
            // ConfigModeEvent has a real port path down to Logical/Product, not just prose.
            in port modeEventIn : ~ConfigModeEventPort;
            perform action superviseStop : SuperviseMovementStop;
        }

        part shutterControlFunctions {
            doc
            /* Energizes and de-energizes the shutter motor relay in response to movement
             * requests (StartShutterMovement) and stop triggers (StopShutterMovement). */
            port requestIn : ~MovementRequestPort;
            port stopIn : ~StopRequestPort;
            port motorOut : MotorStatePort;
            port shutterOut : ShutterStatePort;
            perform action startMovement : StartShutterMovement;
            perform action stopMovement : StopShutterMovement;
        }

        part configurationControlFunctions {
            doc
            /* Manages configuration-mode state transitions (activate/exit), emitting a
             * typed ConfigModeEvent on modeEventOut; guards against reentrant activation
             * (REQ-F-08, UC_03). commandIn feeds determineConfigMode, the local-only
             * sustained UP+DOWN hold detector. */
            port commandIn : ~ControlCommandPort;
            port modeEventOut : ConfigModeEventPort;
            perform action determineConfigMode : DetermineConfigurationMode;
            perform action checkConfigModeState : CheckConfigurationModeState;
            perform action rejectConfigModeReentry : RejectConfigurationModeReentry;
            perform action activateConfigMode : ActivateConfigurationModeFE;
            perform action exitConfigMode : ExitConfigurationModeFE;
        }

        part timeCountingFunctions {
            doc
            /* Measures elapsed shutter travel time from the ShutterState event stream during
             * UC_03 calibration, producing a typed TravelTime (CountActionTimeFE). */
            port shutterStateIn : ~ShutterStatePort;
            port durationOut : TravelTimePort;
            perform action countTime : CountActionTimeFE;
        }

        part memoryFunctions {
            doc
            /* Persists (SaveCountedTime, UC_03) and retrieves (LoadTimingProfile, runtime)
             * the timing profile in non-volatile storage (REQ-F-07). */
            port durationIn : ~TravelTimePort;
            port durationOut : TravelTimePort;
            perform action saveTime : SaveCountedTime;
            perform action loadTime : LoadTimingProfile;
        }

        part userNotificationFunctions {
            doc
            /* Delivers user-visible feedback for configuration-mode transitions (activation
             * and deactivation) via the typed ConfigModeEvent on modeEventIn (REQ-F-08). */
            in port modeEventIn : ~ConfigModeEventPort;
            perform action dispatchNotification : DispatchConfigModeNotification;
        }

        // ── Inter-FE connections ─────────────────────────────────────────────
        // `flow` used for typed inter-FE data flows (SM-PRD-15 Traceability Rule 3);
        // `connect` used for port delegations (composite boundary ↔ sub-part).

        // 1. System boundary → requestAcquisitionFunctions  [port delegation]
        connect controlInput to requestAcquisitionFunctions.commandIn;

        // 2. requestAcquisitionFunctions → controlLogicFunctions  [ControlCommand]
        flow : ControlCommandFlow
            from requestAcquisitionFunctions.commandOut to controlLogicFunctions.commandIn;

        // 2b. requestAcquisitionFunctions → movementSupervisionFunctions  [ControlCommand]
        // Fan-out sibling of connection 2; realizes the trigger source for UC_01c/d/e stop accept-actions.
        flow : ControlCommandFlow
            from requestAcquisitionFunctions.commandOut to movementSupervisionFunctions.commandIn;

        // 2c. requestAcquisitionFunctions → configurationControlFunctions  [ControlCommand]
        // Fan-out sibling of connections 2/2b; feeds determineConfigMode.
        flow : ControlCommandFlow
            from requestAcquisitionFunctions.commandOut to configurationControlFunctions.commandIn;

        // 3. controlLogicFunctions → movementSupervisionFunctions  [MovementRequest]
        // requestOut fans out to both movementSupervisionFunctions and shutterControlFunctions
        // (connections 3 and 4); independent concurrent consumers, not a merge.
        flow : MovementRequestFlow
            from controlLogicFunctions.requestOut to movementSupervisionFunctions.requestIn;

        // 4. controlLogicFunctions → shutterControlFunctions  [MovementRequest]
        flow : MovementRequestFlow
            from controlLogicFunctions.requestOut to shutterControlFunctions.requestIn;

        // 5. movementSupervisionFunctions → shutterControlFunctions  [StopRequest]
        flow : StopRequestFlow
            from movementSupervisionFunctions.stopOut to shutterControlFunctions.stopIn;

        // 6. shutterControlFunctions → system boundary  [typed flow, MotorState]
        flow : MotorStateFlow from shutterControlFunctions.motorOut to motorOutput;

        // 6b. shutterControlFunctions → system boundary  [port delegation, ShutterState]
        // Exposes observable ShutterState at the FA composite boundary.
        connect shutterControlFunctions.shutterOut to shutterOutput;

        // 7. shutterControlFunctions → timeCountingFunctions  [ShutterState, UC_03 only]
        flow : ShutterStateFlow
            from shutterControlFunctions.shutterOut to timeCountingFunctions.shutterStateIn;

        // 8. timeCountingFunctions → memoryFunctions  [TravelTime]
        flow : TravelTimeFlow from timeCountingFunctions.durationOut to memoryFunctions.durationIn;

        // 9. memoryFunctions → movementSupervisionFunctions  [TravelTime, runtime timeout]
        flow : TravelTimeFlow
            from memoryFunctions.durationOut to movementSupervisionFunctions.timingIn;

        // 10. configurationControlFunctions → userNotificationFunctions  [ConfigModeEvent]
        flow : ConfigModeEventFlow
            from configurationControlFunctions.modeEventOut
            to userNotificationFunctions.modeEventIn;

        // 10b. configurationControlFunctions → movementSupervisionFunctions  [ConfigModeEvent]
        // Fan-out sibling of connection 10; gives the state-machine-relevant
        // ConfigModeEvent a real port path down to Logical/Product.
        flow : ConfigModeEventFlow
            from configurationControlFunctions.modeEventOut
            to movementSupervisionFunctions.modeEventIn;
    }
    /* Package-level usage providing a named feature endpoint for traceability
     * links (SysML v2 connection ends must reference features, not classifiers).
     */
    part rollerShutterControllerFunctions : RollerShutterControllerFunctions;
} // package FunctionalArchitecture
