package DomainKnowledge {
    private import ScalarValues::Boolean;
    private import ISQ::*;

    /* Shared data vocabulary (SM-PRD-15) for the Roller Shutter Controller: all item types, enumerations, and typed flow channels. All terms are the single source of truth; no type may be redefined in downstream packages. */

    // =========================================================================
    // Enumerations
    // =========================================================================

    enum def MovementDirection {
        doc
        /* Motor movement direction (up, down, or none) used on all control commands and state objects crossing function boundaries. */

        enum up;
        enum down;
        enum none;
        enum both {
            doc
            /* User pressed UP + DOWN simultenously. */
        }
    }

    enum def MovementMode {
        doc
        /* Discriminates the two operational control modes: automatic (timed) and manual (hold-to-run). */

        enum automatic {
            doc
            /* Full-travel timed mode: shutter runs to end-of-travel and stops autonomously on timeout (REQ-F-04). */
        }
        enum manual {
            doc
            /* Hold-to-run mode: shutter moves while command is asserted; stops on release or safety timeout (REQ-F-05). */
        }
    }

    enum def StopReason {
        doc
        /* Cause that terminated a shutter movement: timeout (end-of-travel or safety) or user request. */

        enum timeout;
        enum userRequest;
    }

    enum def ChannelSource {
        doc
        /* Identifies the physical channel (local wall switch or remote home-automation interface) that originated a ControlCommand. Required to gate configuration-mode activation to local only and to report command provenance. */

        enum local;
        enum remote;
    }

    enum def ConfigModeTransition {
        doc
        /* Discriminates the two configuration-mode state transitions (entry/exit) notified to the user during UC_03 calibration (REQ-F-08). */

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
        /* Interpreted command derived from a dry-contact input signal, carrying movement direction, operation mode, and originating channel source (REQ-I-01, REQ-I-02). */

        attribute direction : MovementDirection;
        attribute mode : MovementMode;
        attribute source : ChannelSource;
    }

    item def MovementRequest {
        doc
        /* Validated movement request produced after conflict checking; direction == none encodes a simultaneous UP+DOWN conflict (UC_01e), keeping the motor de-energized. */

        attribute direction : MovementDirection;
        attribute mode : MovementMode;
    }

    item def StopRequest {
        doc
        /* Request to terminate an in-progress movement, carrying the stop reason (timeout or user request). */

        attribute reason : StopReason;
    }

    item def MotorState {
        doc
        /* Commanded state of the shutter motor relay. enable=true AND direction!=none energizes the motor; enable=false OR direction=none de-energizes it. */

        attribute enable : Boolean;
        attribute direction : MovementDirection;
    }

    item def ShutterState {
        doc
        /* Observable shutter state. moving=true AND direction!=none means traveling; moving=false OR direction=none means stationary. */

        attribute moving : Boolean;
        attribute direction : MovementDirection;
    }

    item def ConfigModeEvent {
        doc
        /* Notification event raised on entry to or exit from configuration mode (UC_03), consumed by userNotificationFunctions. */

        attribute kind : ConfigModeTransition;
    }


    // =========================================================================
    // Flow definitions
    // Typed channels enabling port and connection typing in FunctionalArchitecture
    // (SM-PRD-18) and LogicalArchitecture (SM-PRD-20). Each flow def corresponds
    // to exactly one item def. Usages MUST use the 'flow' keyword, not 'connection'.
    // =========================================================================

    flow def ControlCommandFlow {
        doc
        /* Carries a ControlCommand from request-acquisition to control-logic functions. */

        end src;
        end tgt;
        ref item :>> payload : ControlCommand;
    }

    flow def MovementRequestFlow {
        doc
        /* Carries a MovementRequest from control-logic to motor-drive and stop-condition monitoring functions. */

        end src;
        end tgt;
        ref item :>> payload : MovementRequest;
    }

    flow def StopRequestFlow {
        doc
        /* Carries a StopRequest from stop-condition monitoring to StopShutterMovement. */

        end src;
        end tgt;
        ref item :>> payload : StopRequest;
    }

    flow def MotorStateFlow {
        doc
        /* Carries a MotorState from movement-start or movement-stop functions to the system output boundary (ShutterDrivePort). */

        end src;
        end tgt;
        ref item :>> payload : MotorState;
    }

    flow def ShutterStateFlow {
        doc
        /* Carries a ShutterState from movement-start or movement-stop functions to state output and the time-counting function (UC_03). */

        end src;
        end tgt;
        ref item :>> payload : ShutterState;
    }

    flow def ConfigModeEventFlow {
        doc
        /* Carries a ConfigModeEvent from configurationControlFunctions to userNotificationFunctions. */

        end src;
        end tgt;
        ref item :>> payload : ConfigModeEvent;
    }


    // =========================================================================
    // Travel-time domain types (SM-PRD-18)
    // =========================================================================

    item def TravelTime {
        doc
        /* Measured shutter travel duration for one direction, produced during calibration (UC_03). */
        attribute value subsets ISQ::duration;
    }

    flow def TravelTimeFlow {
        doc
        /* Carries a TravelTime from the time-counting element to the memory element during calibration. */
        end src;
        end tgt;
        ref item :>> payload : TravelTime;
    }
} // package DomainKnowledge
