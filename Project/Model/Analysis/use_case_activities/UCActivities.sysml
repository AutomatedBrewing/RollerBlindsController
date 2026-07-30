package UseCaseActivities {
    private import DomainKnowledge::*;
    private import ISQ::*;
    private import ScalarValues::Boolean;

    /* Specifies the functional decomposition of System Use Cases (SM-PRD-14), defining action sequence and object flow between system functions. Domain types are imported from DomainKnowledge (SM-PRD-15). */

    // =========================================================================
    // Abstract action definitions (Black-box functional blocks)
    // =========================================================================

    // Local and remote commands race via fork+merge; whichever arrives first initiates movement. The 'source' attribute is preserved on the payload for downstream inspection (e.g. DetermineConfigurationMode).
    action def ReceiveControlRequest {
        out command : ControlCommand;

        action acceptLocalCmd accept localCmd : ControlCommand;
        action acceptRemoteCmd accept remoteCmd : ControlCommand;

        fork acceptFork;
        merge acceptMerge;

        first start;
        then acceptFork;
        first acceptFork then acceptLocalCmd;
        first acceptFork then acceptRemoteCmd;
        first acceptLocalCmd then acceptMerge;
        first acceptRemoteCmd then acceptMerge;

        // Whichever accept fires first flows its payload to 'command'.
        flow from acceptLocalCmd.localCmd to command;
        flow from acceptRemoteCmd.remoteCmd to command;
    }

    action def DetermineMovementRequest {
        in command : ControlCommand;
        out request : MovementRequest;

        action suppressMovement {
            doc
            /* UC_01e path: simultaneous UP+DOWN conflict — no movement. */
            assign request.direction := MovementDirection::none;
            assign request.mode := command.mode;
        }
        action passThrough {
            assign request.direction := command.direction;
            assign request.mode := command.mode;
        }

        first start;
        decide;
            // 'both' is suppressed here too: a
            // simultaneous UP+DOWN conflict must never reach the motor, whether
            // it arrives as 'none' (already-arbitrated) or 'both' (raw conflict).
            if command.direction == MovementDirection::none
                or command.direction == MovementDirection::both then suppressMovement;
            else passThrough;
    }

    // Config-mode activation (simultaneous UP+DOWN held >=5s) is gated to the local channel only (REQ-F-08); a remote-originated UP+DOWN never activates configuration mode.
    action def DetermineConfigurationMode {
        in command : ControlCommand;
        out configurationModeRequested : Boolean;

        first start;
        decide;
        if command.direction == MovementDirection::both and command.source == ChannelSource::local {
            assign configurationModeRequested := true;
        } else {
            assign configurationModeRequested := false;
        }
    }

    // motorState assigned symmetrically with shutterState; direction==none branch keeps motor de-energized (UC_01e).
    action def StartShutterMovement {
        in request : MovementRequest;
        out motorState : MotorState;
        out shutterState : ShutterState;

        action activateMotor {
            assign motorState.enable := true;
            assign motorState.direction := request.direction;
            assign shutterState.moving := true;
            assign shutterState.direction := request.direction;
        }
        action suppressMotor {
            doc
            /* UC_01e path: conflict — motor remains de-energized. */
            assign motorState.enable := false;
            assign motorState.direction := MovementDirection::none;
            assign shutterState.moving := false;
            assign shutterState.direction := MovementDirection::none;
        }

        first start;
        decide;
            // Defense-in-depth: even if 'both' ever
            // reached this stage, it is excluded here too, never just 'none'.
            if request.direction != MovementDirection::none
                and request.direction != MovementDirection::both then activateMotor;
            else suppressMotor;
    }

    // Fork+merge: stops on whichever fires first — a stop command from either channel (equal priority) or the travel-time timeout.
    action def MonitorStopCondition {
        in request : MovementRequest;
        in attribute timeout subsets ISQ::duration;
        out stopRequest : StopRequest;

        action listenForStopCommand {
            accept stopReq : ControlCommand;
            then assign stopRequest.reason := StopReason::userRequest;
        }
        action monitorTimeout {
            accept after timeout;
            then assign stopRequest.reason := StopReason::timeout;
        }

        fork stopFork;
        merge stopMerge;

        first start;
        then stopFork;
        first stopFork then listenForStopCommand;
        first stopFork then monitorTimeout;
        first listenForStopCommand then stopMerge;
        first monitorTimeout then stopMerge;
    }

    // Fork+merge: stops on whichever fires first -- release/stop command
    // from EITHER channel (equal priority, UC_01c/d) or the safety timeout.
    action def MonitorUserInterruption {
        in request : MovementRequest;
        in attribute timeout subsets ISQ::duration;
        out stopRequest : StopRequest;

        action listenForRelease {
            accept releaseReq : ControlCommand;
            then assign stopRequest.reason := StopReason::userRequest;
        }
        action monitorTimeout {
            accept after timeout;
            then assign stopRequest.reason := StopReason::timeout;
        }

        fork interruptFork;
        merge interruptMerge;

        first start;
        then interruptFork;
        first interruptFork then listenForRelease;
        first interruptFork then monitorTimeout;
        first listenForRelease then interruptMerge;
        first monitorTimeout then interruptMerge;
    }

    action def StopShutterMovement {
        in stopRequest : StopRequest;
        out motorState : MotorState;
        out shutterState : ShutterState;

        assign motorState.enable := false;
        assign motorState.direction := MovementDirection::none;
        assign shutterState.moving := false;
        assign shutterState.direction := MovementDirection::none;
    }

    // =========================================================================
    // Base Use Case Activity
    // =========================================================================
    action def ControlRollerShutter {
        in attribute timeout subsets ISQ::duration;
        out motorState : MotorState;
        out shutterState : ShutterState;

        first start;
        then action loadProfile : LoadTimingProfile;
        then action receiveControlRequest : ReceiveControlRequest;
        then action determineMovementRequest : DetermineMovementRequest;
        then action determineConfigurationMode : DetermineConfigurationMode;
        if determineConfigurationMode.configurationModeRequested == true {
            // Drop this workflow.
        }

        then action startShutterMovement : StartShutterMovement;
        then action monitorStopCondition : MonitorStopCondition;
        then action stopShutterMovement : StopShutterMovement;

        // loadProfile output is not flowed into monitorStopCondition here; that binding is deferred to FA's SuperviseMovementStop.
        flow from receiveControlRequest.command to determineMovementRequest.command;
        flow from receiveControlRequest.command to determineConfigurationMode.command;
        flow from determineMovementRequest.request to startShutterMovement.request;
        flow from timeout to monitorStopCondition.timeout;
        flow from determineMovementRequest.request to monitorStopCondition.request;
        flow from monitorStopCondition.stopRequest to stopShutterMovement.stopRequest;

        flow from startShutterMovement.motorState to motorState;
        flow from stopShutterMovement.motorState to motorState;
        flow from startShutterMovement.shutterState to shutterState;
        flow from stopShutterMovement.shutterState to shutterState;
    }

    // =========================================================================
    // Variant specializations
    // =========================================================================

    action def OpenShutterAutomatically specializes ControlRollerShutter {
        action redefines receiveControlRequest {
            out redefines command : ControlCommand {
                attribute redefines direction = MovementDirection::up;
                attribute redefines mode = MovementMode::automatic;
            }
        }
    }

    action def CloseShutterAutomatically specializes ControlRollerShutter {
        action redefines receiveControlRequest {
            out redefines command : ControlCommand {
                attribute redefines direction = MovementDirection::down;
                attribute redefines mode = MovementMode::automatic;
            }
        }
    }

    action def OpenShutterManually specializes ControlRollerShutter {
        action redefines receiveControlRequest {
            out redefines command : ControlCommand {
                attribute redefines direction = MovementDirection::up;
                attribute redefines mode = MovementMode::manual;
            }
        }
        action waitForStopCondition : MonitorUserInterruption redefines monitorStopCondition;
    }

    action def CloseShutterManually specializes ControlRollerShutter {
        action redefines receiveControlRequest {
            out redefines command : ControlCommand {
                attribute redefines direction = MovementDirection::down;
                attribute redefines mode = MovementMode::manual;
            }
        }
        action waitForStopCondition : MonitorUserInterruption redefines monitorStopCondition;
    }

    action def HandleConflictingMovementCommands specializes ControlRollerShutter {
        doc
        /* Realizes UC_01e: simultaneous UP+DOWN commands — motor remains de-energized; no shutter movement occurs. */
        action redefines receiveControlRequest {
            out redefines command : ControlCommand {
                attribute redefines direction = MovementDirection::none;
                attribute redefines mode = MovementMode::automatic;
            }
        }

        first stopShutterMovement;
    }

    // =========================================================================
    // Installation
    // =========================================================================
    action def TurnOffPowerSupplyForShutters;
    action def DisassembleWallswitch;
    action def ConnectController {
        action connectPowerSupply;
        action connectRemoteInterface;
        action connectLocalInterface;
        action connectRollerShuttersMotor;
    }

    action def VerifyWorking {
        out success : Boolean;
    }

    action def AssembleWallswitch;
    action def ReportInstallationFault {
        doc
        /* Terminal fault path: reached only after two
         * failed install attempts. Realizes SystemStates::InstallationFaultReported. */
    }

    action verifyWorking : VerifyWorking;
    action retryConnectController : ConnectController;
    action retryVerifyWorking : VerifyWorking;
    action reportInstallationFault : ReportInstallationFault;

    action def InstallController {
        doc
        /* Bounded single-retry install sequence (the
         * former unbounded 'loop until success' never reported a fault). One
         * retry via retryConnectController/retryVerifyWorking; second failure
         * reports the fault instead of looping. Matches SystemStates.sysml's
         * InstallationVerified/InstallationFaultReported citations verbatim. */

        action assembleWallswitch : AssembleWallswitch;

        first start;
        then action turnOffPowerSupplyForShutters : TurnOffPowerSupplyForShutters;
        then action disassembleWallswitch : DisassembleWallswitch;
        then action connectController : ConnectController;
        then verifyWorking;
        decide firstAttempt;
            if verifyWorking.success == true then assembleWallswitch;
            else retryConnectController;
        then retryVerifyWorking;
        decide secondAttempt;
            if retryVerifyWorking.success == true then assembleWallswitch;
            else reportInstallationFault;
    }

    // =========================================================================
    // Configuration
    // =========================================================================
    action def ActivateConfigurationMode {
        doc
        /* To activate configuration mode, user presses UP + DOWN simultaneously for more than 5 seconds. */
    }

    action def NotifyUserAboutActivationOfConfigurationMode;

    action def CountActionTime {
        in shutterStateIn : ShutterState;
        out measuredTime : TravelTime;
        // Behavior is refined in FunctionalArchitecture (SM-PRD-18) by CountActionTimeFE.
    }

    action def SaveCountedTime {
        in timeToSave : TravelTime;
    }

    action def LoadTimingProfile {
        doc
        /* Retrieves the stored timing profile (opening and closing travel times) from non-volatile memory for use as the automatic-mode timeout (REQ-F-07). */
        out timingProfile : TravelTime;
    }

    action def ExitConfigurationMode;
    action def NotifyUserAboutDeactivationOfConfigurationMode;
    action def CheckConfigurationModeState {
        out attribute alreadyActive : Boolean;
        doc
        /* Checks whether configuration mode is already active before a new activation request is accepted (UC_03 precondition). */
    }
    action def RejectConfigurationModeReentry {
        doc
        /* Configuration mode is already active; the new activation request is rejected and the in-progress session continues (REQ-F-08). */
    }

    action def CheckTravelTimeInRange {
        in measuredTime : TravelTime;
        out attribute inRange : Boolean;
        doc
        /* Validates a just-measured travel time against REQ-F-07's maxConfigurableTravelTime limit (120 s). */
    }

    action def RejectOutOfRangeCalibration {
        doc
        /* The just-measured travel time exceeded REQ-F-07's maxConfigurableTravelTime limit and is discarded. */
    }

    // Both opening and closing travel times are measured independently (REQ-F-07). The shutter must be fully closed before activation — a precondition for the installer/user, not an automated step.
    action def ConfigureController {
        action checkConfigurationModeState : CheckConfigurationModeState;
        action rejectConfigurationModeReentry : RejectConfigurationModeReentry;
        action activateConfigurationMode : ActivateConfigurationMode;
        action notifyUserAboutActivationOfConfigurationMode
            : NotifyUserAboutActivationOfConfigurationMode;
        action runOpenMovement : OpenShutterManually;
        action countOpenTime : CountActionTime;
        action checkOpenTimeInRange : CheckTravelTimeInRange;
        action saveOpenTime : SaveCountedTime;
        action rejectOutOfRangeCalibration : RejectOutOfRangeCalibration;
        action exitConfigurationMode : ExitConfigurationMode;
        action notifyUserAboutDeactivationOfConfigurationMode
            : NotifyUserAboutDeactivationOfConfigurationMode;

        // Reentry guard: activation is rejected if configuration mode is already active.
        first start then checkConfigurationModeState;
        if checkConfigurationModeState.alreadyActive == true {
            action rejectConfigurationModeReentry;
        }
        else activateConfigurationMode;

        then notifyUserAboutActivationOfConfigurationMode;
        then runOpenMovement;
        then countOpenTime;
        then checkOpenTimeInRange;
        if checkOpenTimeInRange.inRange == true then saveOpenTime;
        else rejectOutOfRangeCalibration;
        then exitConfigurationMode;
        then notifyUserAboutDeactivationOfConfigurationMode;

        // Object flows
        flow from runOpenMovement.shutterState to countOpenTime.shutterStateIn;
        flow from countOpenTime.measuredTime to checkOpenTimeInRange.measuredTime;
        flow from countOpenTime.measuredTime to saveOpenTime.timeToSave;
    }

    // DisposeController sub-steps realizing REQ-E-01 (regulatedDisposal) for UC_05.
    action def CollectController {
        doc
        /* DisposalFacility collects the decommissioned controller unit from the end user/installer at end of life. */
    }
    action def DisassembleController {
        doc
        /* DisposalFacility disassembles the collected unit for material separation without specialist equipment (REQ-E-01). */
    }
    action def TransferToAuthorizedDisposal {
        doc
        /* DisposalFacility transfers separated materials to an authorized WEEE/RoHS-compliant recycling pathway (REQ-E-01). */
    }

    action def DisposeController {
        doc
        /* Realizes UC_05: collect, disassemble, and dispose of a retired controller in compliance with WEEE/RoHS regulation. */

        first start;
        then action collectController : CollectController;
        then action disassembleController : DisassembleController;
        then action transferToAuthorizedDisposal : TransferToAuthorizedDisposal;
    }

    // Package-level action usages providing named feature endpoints for traceability connections in Traceability::Traceability.
    action receiveControlRequest : ReceiveControlRequest;
    action determineMovementRequest : DetermineMovementRequest;
    action startShutterMovement : StartShutterMovement;
    action monitorStopCondition : MonitorStopCondition;
    action monitorUserInterruption : MonitorUserInterruption;
    action stopShutterMovement : StopShutterMovement;
    action controlRollerShutter : ControlRollerShutter;
    action activateConfigurationMode : ActivateConfigurationMode;
    action exitConfigurationMode : ExitConfigurationMode;
    action notifyUserAboutActivationOfConfigurationMode
        : NotifyUserAboutActivationOfConfigurationMode;
    action notifyUserAboutDeactivationOfConfigurationMode
        : NotifyUserAboutDeactivationOfConfigurationMode;
    action countActionTime : CountActionTime;
    action saveCountedTime : SaveCountedTime;
    action openShutterAutomatically : OpenShutterAutomatically;
    action closeShutterAutomatically : CloseShutterAutomatically;
    action openShutterManually : OpenShutterManually;
    action closeShutterManually : CloseShutterManually;
    action handleConflictingMovementCommands : HandleConflictingMovementCommands;
    action installController : InstallController;
    action configureController : ConfigureController;
    action disposeController : DisposeController;
    action loadTimingProfile : LoadTimingProfile;
    action checkConfigurationModeState : CheckConfigurationModeState;
    action rejectConfigurationModeReentry : RejectConfigurationModeReentry;
    action checkTravelTimeInRange : CheckTravelTimeInRange;
    action rejectOutOfRangeCalibration : RejectOutOfRangeCalibration;
} // package UseCaseActivities
