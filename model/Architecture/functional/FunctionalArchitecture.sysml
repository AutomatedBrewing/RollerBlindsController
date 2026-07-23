package FunctionalArchitecture {
    private import DomainKnowledge::*;
    private import UseCaseActivities::*;
    private import ISQ::*;
    // Import only the abstract root, NOT the wildcard: SystemArchitecture_Taxonomy
    // also declares a same-named abstract header 'FunctionalArchitecture' (see
    // that file's own header comment), which collides with this enclosing
    // package's own name if wildcard-imported, breaking name resolution
    // throughout this file (Syside reference-error fix).
    private import SystemArchitecture_Taxonomy::SystemArchitecture;

    /* The Functional Architecture provides a technology-independent functional
     * description of the system derived from Use Case Activities (SM-PRD-14)
     * using the FAS method (SYSMOD Tool 11.2, SM-PRD-18). Each Functional
     * Element (FE) groups related UCA sub-functions by functional cohesion and
     * exposes typed input/output ports using DomainKnowledge (SM-PRD-15) flow
     * and item types.
     *
     * This artifact is the primary source for allocation to Logical Architecture
     * (SM-PRD-20) and Product Architecture (SM-PRD-21) components.
     *
     * FAS sub-function input matrix (UCA → FE mapping):
     *   ReceiveControlRequest              → requestAcquisitionFunctions
     *   DetermineMovementRequest           → controlLogicFunctions
     *   MonitorStopCondition               → movementSupervisionFunctions (via SuperviseMovementStop)
     *   MonitorUserInterruption            → movementSupervisionFunctions (via SuperviseMovementStop)
     *   StartShutterMovement               → shutterControlFunctions
     *   StopShutterMovement                → shutterControlFunctions
     *   MoveShutterToClosePosition         → shutterControlFunctions
     *   ActivateConfigurationMode          → configurationControlFunctions (via ActivateConfigurationModeFE)
     *   ExitConfigurationMode              → configurationControlFunctions (via ExitConfigurationModeFE)
     *   CountActionTime                    → timeCountingFunctions (via CountActionTimeFE)
     *   SaveCountedTime                    → memoryFunctions
     *   LoadTimingProfile                  → memoryFunctions
     *   NotifyUser…ConfigurationMode (×2)  → userNotificationFunctions (via DispatchConfigModeNotification)
     *   ControlRollerShutter (orchestrator)→ RollerShutterControllerFunctions (composite)
     *
     * NOTE: SuperviseMovementStop, DispatchConfigModeNotification,
     * ActivateConfigurationModeFE and ExitConfigurationModeFE are FA-layer
     * action defs (see "FA-level action def refinement" below) introduced to
     * close formal-review findings F2 (UC_03 notification wiring), F4
     * (mode-based monitor dispatch) and F5 (timeout reduction) — see
     * model_issues.md. Each still traces to its underlying UCA action(s) via
     * `specializes`/composition, preserving Traceability Rule 1.
     */

    // =========================================================================
    // Functional port definitions
    // Typed by DomainKnowledge flow/item types (SM-PRD-15 Traceability Rule 2).
    // =========================================================================

    port def ControlCommandPort {
        doc /* Carries a typed ControlCommand from request-acquisition to control-logic. */
        out item command : ControlCommand;
    }

    port def MovementRequestPort {
        doc /* Carries a validated MovementRequest from control-logic to downstream FEs. */
        out item request : MovementRequest;
    }

    port def StopRequestPort {
        doc /* Carries a StopRequest from movement-supervision to the motor-stop function. */
        out item stopRequest : StopRequest;
    }

    port def MotorStatePort {
        doc /* Carries MotorState to the system output boundary (shutter motor relay). */
        out item motorState : MotorState;
    }

    port def ShutterStatePort {
        doc /* Carries observable ShutterState for internal FA use (time-counting, UC_03). */
        out item shutterState : ShutterState;
    }

    port def TravelTimePort {
        doc /* Carries a TravelTime measurement from time-counting to memory functions. */
        out item travelTime : TravelTime;
    }

    port def TimingProfilePort {
        doc /* Carries the stored TimingProfile from memory to movement-supervision. */
        out item profile : TimingProfile;
    }

    port def ConfigModeEventPort {
        doc
        /* Carries a typed ConfigModeEvent from configuration-control functions
         * to user-notification functions (F2 fix, see model_issues.md). */
        out item modeEvent : ConfigModeEvent;
    }

    port def ConflictEventPort {
        doc
        /* Carries a typed ConflictEvent from control-logic functions to
         * user-notification functions, so a suppressed simultaneous UP+DOWN
         * command is surfaced as an observable user indication rather than
         * silent inaction. Added to close Major finding M2 (system model
         * review corrective pass; realizes REQ-S-02, conflictIndication). */
        out item conflictEvent : ConflictEvent;
    }

    // -------------------------------------------------------------------------
    // Diagnostics ports (SMRR corrective pass, closes CRIT-1: diagnosticsFunctions
    // previously had zero ports; and CRIT-2: restores the missing FA-layer
    // precursor for ProductInterfaces::FaultIndication). Same port-def style as
    // ConflictEventPort/ConfigModeEventPort above -- typed by the new
    // DomainKnowledge diagnostics item types.
    // -------------------------------------------------------------------------

    port def DiagnosticRequestPort {
        doc /* Carries a typed DiagnosticRequest from the system boundary
             * (technician-triggered field diagnosis) to diagnosticsFunctions. */
        out item request : DiagnosticRequest;
    }

    port def DiagnosticResultPort {
        doc /* Carries a typed DiagnosticResult from diagnosticsFunctions to
             * the system boundary, giving the field-diagnosis outcome an
             * observable, testable interface (REQ-Q-04/REQ-Q-05). */
        out item result : DiagnosticResult;
    }

    port def FaultIndicationEventPort {
        doc
        /* Carries a typed FaultIndicationEvent from diagnosticsFunctions to
         * userNotificationFunctions, so a classified fault is surfaced as an
         * observable user indication (REQ-Q-04). Mirrors ConflictEventPort
         * exactly. Closes CRIT-2: this is the FA-layer precursor of
         * ProductInterfaces::FaultIndicationPort. */
        out item faultEvent : FaultIndicationEvent;
    }

    // =========================================================================
    // FA-level action def refinement
    // =========================================================================

    action def CountActionTimeFE specializes CountActionTime {
        doc
        /* FA-layer refinement of CountActionTime (delegated from UCActivities).
         * Closes formal-review finding F11 (see model_issues.md): replaces the
         * previous doc-only stub with an explicit decision structure. Each
         * invocation classifies one incoming ShutterState value as either the
         * interval-start marker (moving becomes true) or the interval-end
         * marker (moving becomes false) for one movement direction; the
         * containing timeCountingFunctions element (see below) invokes this
         * action once per ShutterState event on its shutterStateIn port, and
         * accumulates the two markers to derive measuredTime. The actual
         * timestamp/duration arithmetic between the two markers is a
         * timing-platform capability allocated during Logical/Product
         * Architecture (SM-PRD-20/21) — keeping this FA-level action
         * technology-independent per SysMod abstraction-level guidance. */

        action recordIntervalStart {
            doc /* shutterStateIn.moving == true: travel interval begins. */
        }
        action recordIntervalEnd {
            doc /* shutterStateIn.moving == false: travel interval ends;
                  * measuredTime is derived from the elapsed interval. */
        }

        first start;
        decide;
        if shutterStateIn.moving == true then recordIntervalStart;
        else recordIntervalEnd;
    }

    action def ActivateConfigurationModeFE specializes ActivateConfigurationMode {
        doc
        /* FA-layer refinement adding the typed ConfigModeEvent output needed to
         * close formal-review finding F2 (see model_issues.md): the bare
         * UCA-level ActivateConfigurationMode declares no output, so this
         * refinement adds one to drive userNotificationFunctions. */

        out item modeEvent : ConfigModeEvent;
        assign modeEvent.kind := ConfigModeTransition::activated;
    }

    action def ExitConfigurationModeFE specializes ExitConfigurationMode {
        doc
        /* FA-layer refinement adding the typed ConfigModeEvent output needed to
         * close formal-review finding F2 (see model_issues.md). */

        out item modeEvent : ConfigModeEvent;
        assign modeEvent.kind := ConfigModeTransition::deactivated;
    }

    action def DetermineMovementRequestFE specializes DetermineMovementRequest {
        doc
        /* FA-layer refinement adding the typed ConflictEvent output needed to
         * close Major finding M2 (system model review corrective pass; see
         * model_issues.md). Does not alter DetermineMovementRequest's existing
         * UCA-level signature/behavior (UC_01e conflict suppression is
         * unchanged); this refinement only adds the missing notification
         * signal so the suppressed state becomes observable downstream,
         * preserving Traceability Rule 1. */

        // ConflictEvent carries no attributes (pure occurrence signal, see
        // DomainKnowledge) so no 'assign' is needed -- its mere production is
        // the signal.
        out item conflictEvent : ConflictEvent;
    }

    action def DispatchConfigModeNotification {
        doc
        /* FA-layer dispatcher closing formal-review finding F2 (see
         * model_issues.md): routes an incoming ConfigModeEvent to the UCA
         * notification action matching its transition (activated →
         * NotifyUserAboutActivationOfConfigurationMode; deactivated →
         * NotifyUserAboutDeactivationOfConfigurationMode). */

        in item modeEvent : ConfigModeEvent;

        action notifyConfigActivation   : NotifyUserAboutActivationOfConfigurationMode;
        action notifyConfigDeactivation : NotifyUserAboutDeactivationOfConfigurationMode;

        first start;
        decide;
        if modeEvent.kind == ConfigModeTransition::activated then notifyConfigActivation;
        else notifyConfigDeactivation;
    }

    action def SuperviseMovementStop {
        doc
        /* FA-layer supervisory action closing formal-review findings F4
         * (mode-based stop-monitor dispatch) and F5 (timeout reduction from the
         * persisted TimingProfile) — see model_issues.md. Extracts the scalar
         * timeout for the requested direction via computeTimeout, then dispatches
         * to the UCA-level stop-condition monitor matching the request's
         * MovementMode. Both underlying UCA actions (MonitorStopCondition,
         * MonitorUserInterruption) are used unchanged; this action only adds the
         * missing selection logic around them, preserving Traceability Rule 1. */

        in request : MovementRequest;
        in profile : TimingProfile;
        out stopRequest : StopRequest;

        action computeTimeout {
            doc /* F5: extracts direction-specific timeout scalar from TimingProfile
                  * (down → closeTime, up/other → openTime). */
            out attribute selectedTimeout subsets ISQ::duration;
            if request.direction == MovementDirection::down {
                assign selectedTimeout := profile.closeTime;
            } else {
                assign selectedTimeout := profile.openTime;
            }
        }

        action monitorAutoStop   : MonitorStopCondition;
        action monitorManualStop : MonitorUserInterruption;

        first start;
        then computeTimeout;
        decide;
        if request.mode == MovementMode::automatic then monitorAutoStop;
        else monitorManualStop;

        // F4: mode dispatch; F5: direction-specific timeout from computeTimeout.
        // Fan-out of request/selectedTimeout to both branches is safe (one source,
        // two targets; only one branch executes at runtime per the decide above).
        flow from request                          to monitorAutoStop.request;
        flow from request                          to monitorManualStop.request;
        flow from computeTimeout.selectedTimeout   to monitorAutoStop.timeout;
        flow from computeTimeout.selectedTimeout   to monitorManualStop.timeout;
        flow from monitorAutoStop.stopRequest      to stopRequest;
        flow from monitorManualStop.stopRequest    to stopRequest;
    }

    // =========================================================================
    // Composite Functional Architecture
    // =========================================================================

    part def RollerShutterControllerFunctions :> SystemArchitecture {
        doc
        /* Top-level Functional Architecture of the Window Roller Shutter
         * Controller. Technology-independent assembly of Functional Elements
         * derived from UseCaseActivities via the FAS method (SM-PRD-18,
         * Tool 11.2). Every FE is traceable to one or more UCA sub-functions
         * in UseCaseActivities (see Traceability::Traceability). */

        // ── System boundary ports ─────────────────────────────────────────────
        // NOTE: Physical signal mapping (dry-contact signals → ControlCommand)
        // is deferred to Logical Architecture (SM-PRD-20) via port
        // delegation/binding. The boundary port here represents the abstract
        // functional interface at the system level.
        port controlInput  : ~ControlCommandPort;
        port motorOutput   : MotorStatePort;
        port shutterOutput : ShutterStatePort;
        // Diagnostics boundary ports (CRIT-1 fix, SMRR corrective pass):
        // exposes diagnosticsFunctions' new request/result interface at the
        // composite boundary, mirroring controlInput/motorOutput exactly.
        port diagnosticRequest : ~DiagnosticRequestPort;
        port diagnosticResult  : DiagnosticResultPort;

        // ── Functional Elements ───────────────────────────────────────────────

        part requestAcquisitionFunctions {
            doc
            /* Acquires and interprets control inputs from both the local
             * (wall switch) and remote (home automation system) interfaces into
             * typed ControlCommand objects. Handles simultaneous local+remote
             * reception via first-wins arbitration (UC_01a–e, ReceiveControlRequest).
             * FAS cluster: functions sharing the principal transformation of
             * physical control signal → typed ControlCommand. */
            port commandIn  : ~ControlCommandPort;
            port commandOut : ControlCommandPort;
            perform action receiveRequest : ReceiveControlRequest;
        }

        part controlLogicFunctions {
            doc
            /* Validates the incoming ControlCommand, detects simultaneous UP+DOWN
             * directional conflicts (UC_01e, DetermineMovementRequest), and
             * produces a typed MovementRequest encoding direction and mode.
             * FAS cluster: functions sharing the principal transformation of
             * command validation → validated MovementRequest. Also raises a
             * ConflictEvent when a conflict is detected (M2 fix, see
             * model_issues.md), routed to userNotificationFunctions. */
            port commandIn   : ~ControlCommandPort;
            port requestOut  : MovementRequestPort;
            port conflictOut : ConflictEventPort;
            perform action parseRequest : DetermineMovementRequestFE;
        }

        part movementSupervisionFunctions {
            doc
            /* Monitors stop conditions during in-progress shutter movement.
             * Covers automatic mode (timeout-driven end-of-travel, UC_01a/b,
             * MonitorStopCondition) and manual hold-to-run mode (user-release
             * or safety timeout, UC_01c/d, MonitorUserInterruption). The
             * applicable monitor and its scalar timeout are both selected at
             * runtime by SuperviseMovementStop (F4: MovementMode-based monitor
             * dispatch; F5: TimingProfile-to-timeout reduction by direction —
             * see model_issues.md).
             * FAS cluster: functions sharing the principal transformation of
             * stop-condition detection → StopRequest emission.
             *
             * commandIn (Logical Architecture review CRITICAL-1 fix, see
             * model_issues.md): realizes the trigger source for
             * MonitorStopCondition.listenForStopCommand and
             * MonitorUserInterruption.listenForRelease (both UCA-level 'accept
             * ... : ControlCommand' actions, invoked from within
             * SuperviseMovementStop's monitorAutoStop/monitorManualStop).
             * Previously neither this Functional Element nor its Logical
             * realization exposed any port carrying an in-progress
             * ControlCommand stream, leaving the repeated-press-to-stop
             * (UC_01e) and release-to-stop (UC_01c/d) behaviors structurally
             * unrealized. Fed from requestAcquisitionFunctions.commandOut
             * (see connection 2b below), mirroring the existing fan-out to
             * controlLogicFunctions. */
            port commandIn : ~ControlCommandPort;
            port requestIn : ~MovementRequestPort;
            port timingIn  : ~TimingProfilePort;
            port stopOut   : StopRequestPort;
            perform action superviseStop : SuperviseMovementStop;
        }

        part shutterControlFunctions {
            doc
            /* Energizes and de-energizes the shutter motor relay in response to
             * validated movement requests (StartShutterMovement) and stop
             * triggers (StopShutterMovement). Also drives the shutter to the
             * fully closed position as the UC_03 calibration precondition
             * (MoveShutterToClosePosition).
             * FAS cluster: functions sharing the principal transformation of
             * MotorState management (motor on/off/direction). */
            port requestIn  : ~MovementRequestPort;
            port stopIn     : ~StopRequestPort;
            port motorOut   : MotorStatePort;
            port shutterOut : ShutterStatePort;
            perform action startMovement       : StartShutterMovement;
            perform action stopMovement        : StopShutterMovement;
            perform action moveToClosePosition : MoveShutterToClosePosition;
        }

        part configurationControlFunctions {
            doc
            /* Manages configuration mode state transitions: activates the
             * dedicated calibration mode (ActivateConfigurationModeFE) and
             * exits it after travel times have been measured
             * (ExitConfigurationModeFE). Each transition emits a typed
             * ConfigModeEvent on modeEventOut, closing formal-review finding F2
             * (see model_issues.md): mode transitions now have an explicit,
             * typed interaction with userNotificationFunctions instead of an
             * unmodeled/implicit trigger. Also guards against reentrant
             * activation while configuration mode is already in progress
             * (system model review corrective pass, see model_issues.md;
             * realizes REQ-F-08 / TC_N_002_ConfigMode_ReentryRejected).
             * FAS cluster: functions sharing the principal transformation of
             * operational mode state management (REQ-F-08, UC_03). */
            port modeEventOut : ConfigModeEventPort;
            perform action checkConfigModeState    : CheckConfigurationModeState;
            perform action rejectConfigModeReentry : RejectConfigurationModeReentry;
            perform action activateConfigMode      : ActivateConfigurationModeFE;
            perform action exitConfigMode          : ExitConfigurationModeFE;
        }

        part timeCountingFunctions {
            doc
            /* Measures elapsed shutter travel time from the ShutterState event
             * stream produced by shutterControlFunctions during UC_03 calibration.
             * Monitors moving==true → moving==false transitions and produces a
             * typed TravelTime for one movement direction (CountActionTimeFE).
             * FAS cluster: functions sharing the principal transformation of
             * elapsed-time measurement. */
            port shutterStateIn : ~ShutterStatePort;
            port durationOut    : TravelTimePort;
            perform action countTime : CountActionTimeFE;
        }

        part memoryFunctions {
            doc
            /* Persists and retrieves timing profile data in non-volatile storage.
             * Write path (UC_03): receives TravelTime from timeCountingFunctions
             * and saves it (SaveCountedTime). Read path (runtime): retrieves the
             * full TimingProfile and supplies it to movementSupervisionFunctions
             * as the movement timeout (LoadTimingProfile). Closes REQ-F-07
             * (configurableTimingProfile) end-to-end.
             * FAS cluster: functions sharing the principal transformation of
             * non-volatile data management. */
            port durationIn : ~TravelTimePort;
            port timingOut  : TimingProfilePort;
            perform action saveTime : SaveCountedTime;
            perform action loadTime : LoadTimingProfile;
        }

        part userNotificationFunctions {
            doc
            /* Delivers user-visible feedback for configuration mode transitions
             * (activation and deactivation), dispatched from the single typed
             * ConfigModeEvent received on modeEventIn (F2 fix, see
             * model_issues.md; DispatchConfigModeNotification routes the event
             * to the matching UCA notification action). Also delivers the
             * user-visible conflict indication (M2 fix, see model_issues.md;
             * realizes REQ-S-02) from conflictEventIn, and (CRIT-2 fix, SMRR
             * corrective pass) the user-visible fault indication (REQ-Q-04)
             * from faultEventIn. Decoupled from control logic to allow
             * independent Logical Architecture realization (e.g., LED,
             * buzzer, or display indicator).
             * FAS cluster: functions sharing the principal transformation of
             * user feedback delivery. */
            port modeEventIn     : ~ConfigModeEventPort;
            port conflictEventIn : ~ConflictEventPort;
            port faultEventIn    : ~FaultIndicationEventPort;
            perform action dispatchNotification         : DispatchConfigModeNotification;
            perform action dispatchConflictNotification : NotifyUserAboutConflict;
        }

        part diagnosticsFunctions {
            doc
            /* Diagnoses and supports repair of a failed or malfunctioning
             * controller in the field without modifying the existing installation
             * wiring (UC_04_DiagnoseAndRepairController, REQ-Q-03 reliability).
             * Behavior is currently underspecified pending a dedicated UC_04
             * elaboration pass; this FE is introduced here to close FA open
             * finding F7 (see model_issues.md §13) and to provide an allocation
             * anchor for Logical/Product Architecture.
             * FAS cluster: functions supporting fault detection, isolation, and
             * field-repair of the ShutterController.
             *
             * PORTS (CRIT-1 fix, SMRR corrective pass): previously this FE had
             * zero ports, the sole interface-less FE in the composite. Three
             * ports are added, mirroring the same port-def style used
             * throughout this composite (typed by DomainKnowledge item types,
             * one flow per FE boundary crossing): a diagnostic-request input
             * (technician-triggered field diagnosis, realizes DetectFault), a
             * diagnostic-result output (the field-diagnosis outcome, realizes
             * IsolateFault/RepairOrReplaceUnit's precondition), and a
             * fault-indication output (CRIT-2 fix: the missing FA-layer
             * precursor of ProductInterfaces::FaultIndicationPort, routed to
             * userNotificationFunctions exactly like the existing
             * ConflictEvent/ConfigModeEvent pattern). No responsibility is
             * redesigned -- only the missing interface definition is closed. */
            port diagnosticRequestIn : ~DiagnosticRequestPort;
            port diagnosticResultOut : DiagnosticResultPort;
            port faultEventOut       : FaultIndicationEventPort;
            perform action diagnose : DiagnoseAndRepairController;
        }

        // ── Inter-FE connections ─────────────────────────────────────────────
        // `flow : FlowType from ... to ...;` used for inter-FE data flows
        // (SM-PRD-15 Traceability Rule 3 — typed by DomainKnowledge flow defs).
        // Plain `connect` used for port delegations (composite boundary ↔ sub-part).
        // NOTE (C1 fix, formal Logical Architecture review): previously written
        // as 'connection : FlowType connect ...' -- corrected to the 'flow'
        // keyword since the DomainKnowledge types are 'flow def' (a kind of
        // action def), not 'connection def'; a 'connection' usage must only be
        // defined by a connection definition (see KnowledgeSource/sysml2/
        // concepts/connection-usage.md and flow.md).

        // 1. System boundary → requestAcquisitionFunctions  [port delegation]
        connect controlInput to requestAcquisitionFunctions.commandIn;

        // 2. requestAcquisitionFunctions → controlLogicFunctions  [ControlCommand]
        flow : ControlCommandFlow
            from requestAcquisitionFunctions.commandOut to controlLogicFunctions.commandIn;

        // 2b. requestAcquisitionFunctions → movementSupervisionFunctions  [ControlCommand]
        // (Logical Architecture review CRITICAL-1 fix, see model_issues.md): fan-out
        // sibling of connection 2 — the same acquired ControlCommand stream also
        // reaches movementSupervisionFunctions, realizing the trigger source for the
        // UCA-level listenForStopCommand/listenForRelease accept actions (UC_01c/d/e).
        flow : ControlCommandFlow
            from requestAcquisitionFunctions.commandOut to movementSupervisionFunctions.commandIn;

        // 3. controlLogicFunctions → movementSupervisionFunctions  [MovementRequest]
        // NOTE (F10 fix, see model_issues.md): controlLogicFunctions.requestOut
        // fans out to two independent downstream consumers (connections 3 and 4).
        // This is an intentional one-to-many broadcast, not a merge: both
        // movementSupervisionFunctions and shutterControlFunctions receive the
        // identical MovementRequest concurrently and act on it independently
        // (supervision vs. motor drive), matching UseCaseActivities::
        // ControlRollerShutter's two outgoing 'flow from
        // determineMovementRequest.request to ...' statements.
        flow : MovementRequestFlow
            from controlLogicFunctions.requestOut to movementSupervisionFunctions.requestIn;

        // 4. controlLogicFunctions → shutterControlFunctions  [MovementRequest]
        // (second leg of the F10 broadcast documented above)
        flow : MovementRequestFlow
            from controlLogicFunctions.requestOut to shutterControlFunctions.requestIn;

        // 5. movementSupervisionFunctions → shutterControlFunctions  [StopRequest]
        flow : StopRequestFlow
            from movementSupervisionFunctions.stopOut to shutterControlFunctions.stopIn;

        // 6. shutterControlFunctions → system boundary  [typed flow, MotorState]
        // (F8 fix: replaced untyped 'connect' with a typed 'flow : MotorStateFlow'
        // for full flow-typing parity with the other 5 inter-FE data flows —
        // see model_issues.md §13 finding F8.)
        flow : MotorStateFlow
            from shutterControlFunctions.motorOut to motorOutput;

        // 6b. shutterControlFunctions → system boundary  [port delegation, ShutterState]
        // Closes F1: UseCaseActivities::ControlRollerShutter declares
        // 'out shutterState : ShutterState' at the orchestrator boundary; this
        // delegation exposes the same observable state at the FA composite
        // boundary so ControlRollerShutter's outputs are fully realized.
        connect shutterControlFunctions.shutterOut to shutterOutput;

        // 7. shutterControlFunctions → timeCountingFunctions  [ShutterState, UC_03 only]
        flow : ShutterStateFlow
            from shutterControlFunctions.shutterOut to timeCountingFunctions.shutterStateIn;

        // 8. timeCountingFunctions → memoryFunctions  [TravelTime]
        flow : TravelTimeFlow
            from timeCountingFunctions.durationOut to memoryFunctions.durationIn;

        // 9. memoryFunctions → movementSupervisionFunctions  [TimingProfile, runtime timeout]
        flow : TimingProfileFlow
            from memoryFunctions.timingOut to movementSupervisionFunctions.timingIn;

        // 10. configurationControlFunctions → userNotificationFunctions  [ConfigModeEvent]
        // Closes F2: previously this interaction was entirely unmodeled — see
        // model_issues.md. Both configurationControlFunctions and
        // userNotificationFunctions already had UCA-level derivation links
        // (Traceability::Traceability, lines 113-117) but no FA-level ports or
        // connection; this adds the missing typed interface.
        flow : ConfigModeEventFlow
            from configurationControlFunctions.modeEventOut to userNotificationFunctions.modeEventIn;

        // 11. controlLogicFunctions → userNotificationFunctions  [ConflictEvent]
        // Closes Major finding M2 (system model review corrective pass, see
        // model_issues.md): previously the UC_01e conflict-suppression
        // outcome had no observable user feedback path anywhere in the model.
        // Mirrors the ConfigModeEventFlow pattern above (typed port-to-port
        // flow between two existing FEs, no new FE introduced).
        flow : ConflictEventFlow
            from controlLogicFunctions.conflictOut to userNotificationFunctions.conflictEventIn;

        // 12. system boundary → diagnosticsFunctions  [port delegation, DiagnosticRequest]
        // (CRIT-1 fix, SMRR corrective pass): exposes the technician-triggered
        // field-diagnosis trigger at the composite boundary, mirroring
        // connection 1 (controlInput → requestAcquisitionFunctions.commandIn).
        connect diagnosticRequest to diagnosticsFunctions.diagnosticRequestIn;

        // 12b. diagnosticsFunctions → system boundary  [port delegation, DiagnosticResult]
        // (CRIT-1 fix): exposes the field-diagnosis outcome at the composite
        // boundary, mirroring connection 6b (shutterOut → shutterOutput).
        connect diagnosticsFunctions.diagnosticResultOut to diagnosticResult;

        // 13. diagnosticsFunctions → userNotificationFunctions  [FaultIndicationEvent]
        // (CRIT-2 fix, SMRR corrective pass): restores the missing FA-layer
        // precursor for ProductInterfaces::FaultIndicationPort/FaultIndicationFlow
        // (PA-1 fix), which previously had "no counterpart at any earlier
        // architecture layer". Mirrors the ConflictEventFlow pattern (11)
        // exactly -- typed port-to-port flow between two existing FEs, no new
        // FE introduced, all existing allocations preserved.
        flow : FaultIndicationEventFlow
            from diagnosticsFunctions.faultEventOut to userNotificationFunctions.faultEventIn;
    }
    /* Package-level usage providing a named feature endpoint for traceability
     * links (SysML v2 connection ends must reference features, not classifiers). */
    part rollerShutterControllerFunctions : RollerShutterControllerFunctions;
} // package FunctionalArchitecture
