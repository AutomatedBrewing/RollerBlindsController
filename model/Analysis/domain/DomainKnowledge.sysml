package DomainKnowledge {
    private import ScalarValues::Boolean;
    private import ISQ::*;

    /* Domain Knowledge (SM-PRD-15) is the shared data vocabulary of the
     * Roller Shutter Controller system. It defines every item type, enumeration,
     * and typed flow channel that crosses a system-function boundary or appears
     * as an action parameter in UseCaseActivities (SM-PRD-14), FunctionalArchitecture
     * (SM-PRD-18), LogicalArchitecture (SM-PRD-20), and ProductArchitecture (SM-PRD-21).
     *
     * All terms defined here are the single source of truth; no item or enum type
     * may be redefined in any downstream package.
     *
     * arc42 ARC-12 Glossary entries are derived directly from the 'doc' strings below.
     */

    // =========================================================================
    // Enumerations
    // =========================================================================

    enum def MovementDirection {
        doc
        /* The direction in which the roller shutter motor is commanded to move,
         * or the absence of movement. Used on every control command, movement
         * request, motor state, and shutter state crossing a function boundary.
         */

        enum up {
            doc
            /* Motor is energized to raise (open) the roller shutter. */
        }
        enum down {
            doc
            /* Motor is energized to lower (close) the roller shutter. */
        }
        enum none {
            doc
            /* Motor is de-energized; no shutter movement is occurring or commanded.
             * Produced by StartShutterMovement when a conflicting UP+DOWN command
             * is detected (UC_01e), and by StopShutterMovement after any movement ends.
             */
        }
        enum both {
            doc
            /* User pressed UP + DOWN simultenously. */
        }
    }

    enum def MovementMode {
        doc
        /* Discriminates the two operational control modes supported by the controller.
         * Derived from the trigger semantics of the initiating use case variant.
         */

        enum automatic {
            doc
            /* Full-travel timed mode: the controller runs the shutter to the
             * end-of-travel position using the configured timeout (REQ-F-04,
             * UC_01a, UC_01b). Movement stops autonomously when the timeout expires.
             */
        }
        enum manual {
            doc
            /* Hold-to-run mode: the shutter moves only while the command is actively
             * asserted by the user; it stops immediately on release or when the safety
             * timeout expires (REQ-F-05, UC_01c, UC_01d).
             */
        }
    }

    enum def StopReason {
        doc
        /* Records the cause that terminated an in-progress shutter movement,
         * enabling downstream functions (logging, diagnostics) to distinguish
         * normal end-of-travel from operator-initiated interruptions.
         */

        enum timeout {
            doc
            /* The configured travel-time timeout expired. For automatic mode this
             * indicates normal end-of-travel; for manual mode it is the safety
             * failsafe stop. Maps to REQ-F-07 (configurableTimingProfile).
             */
        }
        enum userRequest {
            doc
            /* An explicit stop command was received from the wall switch or the
             * remote (home automation) interface before the timeout elapsed.
             * Maps to REQ-F-06 (stopShutterMovement).
             */
        }
    }

    enum def ConfigModeTransition {
        doc
        /* Discriminates the two configuration-mode state transitions notified
         * to the user during UC_03 calibration (REQ-F-08, ActivateConfigurationMode
         * / ExitConfigurationMode). Added to close the FA formal-review finding
         * F2 (see model_issues.md): configurationControlFunctions and
         * userNotificationFunctions previously had no typed interaction.
         */

        enum activated {
            doc
            /* Configuration mode has just been entered (ActivateConfigurationMode). */
        }
        enum deactivated {
            doc
            /* Configuration mode has just been exited (ExitConfigurationMode). */
        }
    }

    // =========================================================================
    // Domain data entities (item defs)
    // =========================================================================

    item def ControlCommand {
        doc
        /* An interpreted command object derived from a raw dry-contact input signal
         * (UP or DOWN voltage assertion on the localCtrl or remoteCtrl boundary port).
         * The controller's request-acquisition function maps the physical signal to
         * this typed object, adding the inferred operation mode.
         *
         * Note: the underlying electrical interface is a dry-contact (voltage-present
         * = active) signal per REQ-I-01 and REQ-I-02; no serial protocol is involved.
         */

        attribute direction : MovementDirection;
        attribute mode : MovementMode;
    }

    item def MovementRequest {
        doc
        /* A validated movement request produced by the control-logic function
         * (DetermineMovementRequest) after checking for conflicting commands.
         * Passed to the motor-drive functions and to the stop-condition monitor.
         *
         * When direction == MovementDirection::none the request encodes a
         * simultaneous UP+DOWN conflict (UC_01e); StartShutterMovement will
         * keep the motor de-energized in response.
         */

        attribute direction : MovementDirection;
        attribute mode : MovementMode;
    }

    item def StopRequest {
        doc
        /* A request to terminate an in-progress shutter movement, carrying the
         * reason that triggered the stop. Produced by MonitorStopCondition (automatic
         * mode) or MonitorUserInterruption (manual mode) and consumed by
         * StopShutterMovement.
         */

        attribute reason : StopReason;
    }

    item def MotorState {
        doc
        /* The current commanded state of the shutter motor relay or triac.
         * Produced as an output by StartShutterMovement (motor on) and
         * StopShutterMovement (motor off). Consumed by the motor-drive
         * functional block and by the ShutterDrivePort at the system boundary.
         *
         * enable == true  AND direction != none  →  motor energized in 'direction'.
         * enable == false OR  direction == none  →  motor de-energized.
         */

        attribute enable : Boolean;
        attribute direction : MovementDirection;
    }

    item def ShutterState {
        doc
        /* The observable state of the window roller shutter as reported by the
         * controller. Produced by StartShutterMovement (moving == true) and
         * StopShutterMovement (moving == false). Also consumed by
         * CountActionTime during the configuration use case (UC_03).
         *
         * moving == true  AND direction != none  →  shutter is traveling.
         * moving == false OR  direction == none  →  shutter is stationary.
         */

        attribute moving : Boolean;
        attribute direction : MovementDirection;
    }

    item def ConfigModeEvent {
        doc
        /* A notification event raised on entry to or exit from configuration
         * mode (UC_03), produced by configurationControlFunctions
         * (ActivateConfigurationMode / ExitConfigurationMode) and consumed by
         * userNotificationFunctions to trigger the corresponding user-visible
         * feedback (NotifyUserAboutActivationOfConfigurationMode /
         * NotifyUserAboutDeactivationOfConfigurationMode). Added to close FA
         * formal-review finding F2 (see model_issues.md).
         */

        attribute kind : ConfigModeTransition;
    }


    // =========================================================================
    // Flow definitions
    // Typed channels enabling port and connection typing in FunctionalArchitecture
    // (SM-PRD-18) and LogicalArchitecture (SM-PRD-20).
    // Each flow def corresponds to exactly one item def (SM-PRD-15 traceability rule 3).
    //
    // NOTE (F9 fix, see model_issues.md): all flow defs below are declared
    // non-abstract and structurally binary-compatible (single 'ref item :>>
    // payload' end), consistent with their concrete use in 'flow : <FlowDef>
    // from <src> to <tgt>;' statements throughout FunctionalArchitecture and
    // LogicalArchitecture — no flow def in this package is used abstractly,
    // so none carry the 'abstract' keyword.
    //
    // NOTE (C1 fix, formal Logical Architecture review): these are 'flow def'
    // (a kind of action def, KnowledgeSource/sysml2/concepts/flow.md), NOT
    // 'connection def'. Per SysML v2 kind-matching rules ("a connection usage
    // must only be defined by connection definitions" / "a flow usage must
    // only be defined by flow definitions"), usages of these types MUST use
    // the 'flow' keyword (e.g. 'flow : ControlCommandFlow from a to b;'), never
    // 'connection : <FlowDef> connect a to b;' — the latter was an invalid
    // def/usage kind mismatch present in earlier revisions of
    // FunctionalArchitecture.sysml and LogicalArchitecture.sysml.
    // =========================================================================

    flow def ControlCommandFlow {
        doc
        /* Carries a ControlCommand from the request-acquisition functions to the
         * control-logic functions. Used on the internal interface between
         * requestAcquisitionFunctions and controlLogicFunctions in FA.
         */

        end src;
        end tgt;
        ref item :>> payload : ControlCommand;
    }

    flow def MovementRequestFlow {
        doc
        /* Carries a MovementRequest from the control-logic functions to both the
         * motor-drive functions (StartShutterMovement) and the stop-condition
         * monitoring functions (MonitorStopCondition / MonitorUserInterruption).
         */

        end src;
        end tgt;
        ref item :>> payload : MovementRequest;
    }

    flow def StopRequestFlow {
        doc
        /* Carries a StopRequest from stop-condition monitoring to the
         * StopShutterMovement function.
         */

        end src;
        end tgt;
        ref item :>> payload : StopRequest;
    }

    flow def MotorStateFlow {
        doc
        /* Carries a MotorState from movement-start or movement-stop functions
         * to the system output boundary (ShutterDrivePort). Currently realized
         * in FunctionalArchitecture via an untyped 'connect' port delegation
         * (shutterControlFunctions.motorOut → motorOutput) rather than a typed
         * 'flow : MotorStateFlow from ... to ...;' (F8, see model_issues.md);
         * retained here as the canonical typed channel for that interface and
         * for future Logical Architecture (SM-PRD-20) realizations that may
         * require an explicit typed flow.
         */

        end src;
        end tgt;
        ref item :>> payload : MotorState;
    }

    flow def ShutterStateFlow {
        doc
        /* Carries a ShutterState from movement-start or movement-stop functions
         * to system-level state output and to the time-counting function during
         * configuration (UC_03).
         */

        end src;
        end tgt;
        ref item :>> payload : ShutterState;
    }

    flow def ConfigModeEventFlow {
        doc
        /* Carries a ConfigModeEvent from configurationControlFunctions to
         * userNotificationFunctions (F2 fix, see model_issues.md).
         */

        end src;
        end tgt;
        ref item :>> payload : ConfigModeEvent;
    }


    // =========================================================================
    // Diagnostics domain types (SMRR corrective pass, closes CRIT-1/CRIT-2).
    // Previously diagnosticsFunctions (FunctionalArchitecture) had zero ports
    // and ProductInterfaces::FaultIndication (PA-1 fix) was introduced with
    // "no counterpart at any earlier architecture layer" (self-documented
    // gap). These two item/flow defs restore the missing Functional/Logical
    // precursor, mirroring the existing ConfigModeEvent/ConflictEvent
    // dual-pattern (doc-only occurrence signal, no premature technology
    // commitment). The Product-layer FaultClass taxonomy remains exclusively
    // at ProductInterfaces.sysml (technology-specific classification detail,
    // untouched by this fix) -- these types stay deliberately generic.
    // =========================================================================

    item def DiagnosticRequest {
        doc
        /* A technician-asserted request to run field diagnosis on the
         * controller (UC_04_DiagnoseAndRepairController, DetectFault),
         * observed by diagnosticsFunctions without specialized lab equipment
         * (REQ-Q-04/REQ-Q-05). Carries no attributes: it is a pure trigger
         * occurrence, mirroring ConflictEvent/ConfigModeEvent's existing
         * occurrence-signal pattern in this package.
         */
    }

    flow def DiagnosticRequestFlow {
        doc
        /* Carries a DiagnosticRequest to diagnosticsFunctions from the
         * Functional Architecture system boundary (technician-triggered
         * field diagnosis). Added to close CRIT-1 (SMRR corrective pass).
         */

        end src;
        end tgt;
        ref item :>> payload : DiagnosticRequest;
    }

    item def DiagnosticResult {
        doc
        /* A technology-independent field-diagnosis outcome, produced
         * internally by diagnosticsFunctions from its diagnosticRequestIn
         * observation (UC_04_DiagnoseAndRepairController, REQ-Q-04/REQ-Q-05).
         * Deliberately attribute-minimal at this layer -- the concrete fault
         * taxonomy (FaultClass: noResponseToControlInput / motorDriveFault)
         * is committed only at Product Architecture (ProductInterfaces.sysml,
         * PA-1 fix), consistent with every other FA-layer type in this
         * package remaining technology-independent.
         */

        attribute faultDetected : Boolean;
    }

    flow def DiagnosticResultFlow {
        doc
        /* Carries a DiagnosticResult from diagnosticsFunctions to the
         * Functional Architecture system boundary, giving the field-diagnosis
         * outcome an observable, testable interface (REQ-Q-04/REQ-Q-05).
         * Added to close CRIT-1 (SMRR corrective pass).
         */

        end src;
        end tgt;
        ref item :>> payload : DiagnosticResult;
    }

    item def FaultIndicationEvent {
        doc
        /* A notification event raised when diagnosticsFunctions classifies a
         * fault condition, produced by diagnosticsFunctions and consumed by
         * userNotificationFunctions to drive a distinct user-perceivable
         * fault indication (REQ-Q-04). Mirrors ConflictEvent exactly: a pure
         * occurrence signal carrying no attributes, since the concrete
         * FaultClass classification detail is a Product-layer concern
         * (ProductInterfaces::FaultIndication, PA-1 fix). This is the missing
         * Functional/Logical precursor that closes CRIT-2 (SMRR corrective
         * pass): ProductInterfaces::FaultIndication previously had "no
         * counterpart at any earlier architecture layer"; ProductInterfaces::
         * FaultIndication is now the Product-layer, technology-committed
         * concretization of this same real-world signal.
         */
    }

    flow def FaultIndicationEventFlow {
        doc
        /* Carries a FaultIndicationEvent from diagnosticsFunctions to
         * userNotificationFunctions (FunctionalArchitecture), and from
         * logicalDiagnostics to logicalUserNotification (LogicalArchitecture)
         * -- the same top-down chain ProductComponents.sysml already
         * realizes one layer further down (DiagnosticsSoftware.faultOut →
         * UserFeedbackSoftware.faultIndicationIn). Added to close CRIT-2
         * (SMRR corrective pass).
         */

        end src;
        end tgt;
        ref item :>> payload : FaultIndicationEvent;
    }

    // =========================================================================
    // Travel-time domain types
    // Added during Functional Architecture layer (SM-PRD-18) to type the
    // time-counting and memory function interfaces consistently with the
    // item-def / flow-def conventions above.
    // =========================================================================

    item def TravelTime {
        doc
        /* A measured shutter travel duration for one movement direction
         * (opening or closing). Produced by CountActionTime during calibration
         * (UC_03) and consumed by SaveCountedTime for persistence.
         */
        attribute value subsets ISQ::duration;
    }

    flow def TravelTimeFlow {
        doc
        /* Carries a TravelTime measurement from the time-counting functional
         * element to the memory functional element during UC_03 calibration.
         */
        end src;
        end tgt;
        ref item :>> payload : TravelTime;
    }
} // package DomainKnowledge
