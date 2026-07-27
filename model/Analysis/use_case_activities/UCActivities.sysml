package UseCaseActivities {
    private import DomainKnowledge::*;
    private import ISQ::*;
    private import ScalarValues::Boolean;

    /* The Use Case Activities specify the functional decomposition
     * of the System Use Cases and, thus, the overall system in the
     * problem space. They define the sequence of execution and
     * object flow between the system functions.
     *
     * Domain types (item defs, enum defs, flow defs) are defined in
     * DomainKnowledge (SM-PRD-15) and imported above.
     */

    // =========================================================================
    // Abstract action definitions (Black-box functional blocks)
    // =========================================================================

    // Both local and remote commands routed via fork+merge (first-wins).
    // No 'via' reference to internal architecture parts (architecture-independent).
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
            if command.direction == MovementDirection::none then suppressMovement;
            else passThrough;
    }

    action def DetermineConfigurationMode {
        in command : ControlCommand;
        out configurationModeRequested : Boolean;

        first start;
        decide;
        if command.direction == MovementDirection::both {
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
            if request.direction != MovementDirection::none then activateMotor;
            else suppressMotor;
    }

    // Fork+merge (first-wins): user stop-command or timeout, whichever fires first.
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

    // Fork+merge (first-wins): user release or timeout — stops on either (UC_01c/d).
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
        then action determineConfiguratedMode : DetermineConfigurationMode;
        if determineConfiguratedMode.configurationModeRequested == true {
            // Drop this workflow.
        }

        then action startShutterMovement : StartShutterMovement;
        then action monitorStopCondition : MonitorStopCondition;
        then action stopShutterMovement : StopShutterMovement;

        // loadProfile (system model review corrective pass, closes the
        // LoadTimingProfile orphan finding): composed here so the
        // profile-loading step's position in the overall sequence is
        // explicit even at this abstract UCA layer, and so LoadTimingProfile
        // is no longer an un-composed, package-level-only usage. Its output
        // is not flowed into monitorStopCondition here -- see the timeout
        // attribute doc above for why that reduction is deferred to FA's
        // SuperviseMovementStop.
        flow from receiveControlRequest.command to determineMovementRequest.command;
        flow from receiveControlRequest.command to determineConfiguratedMode.command;
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
        /* Realizes UC_01e: simultaneous UP+DOWN commands — motor remains
         * de-energized in both directions; no shutter movement occurs.
         */
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

    action verifyWorking : VerifyWorking;

    action def InstallController {
        first start;
        loop {
            then action turnOffPowerSupplyForShutters : TurnOffPowerSupplyForShutters;
            then action disassembleWallswitch : DisassembleWallswitch;
            then action connectController : ConnectController;
            then verifyWorking;
        } until verifyWorking.success == true;

        then action assembleWallswitch : AssembleWallswitch;
    }

    // =========================================================================
    // Configuration
    // =========================================================================
    action def MoveShutterToClosePosition;
    action def ActivateConfigurationMode {
        doc
        /* To activate configuration mode, user need to press UP + DOWN
         * simultanously for more than 5 seconds.
         */
    }

    action def NotifyUserAboutActivationOfConfigurationMode;

    action def CountActionTime {
        in shutterStateIn : ShutterState;
        out measuredTime : TravelTime;
        // NOTE: Behavior underspecified here; refined in the Functional
        // Architecture layer by CountActionTimeFE (SM-PRD-18), which clarifies
        // that the ShutterState input is a stream of change events (moving=true
        // → moving=false) from which the elapsed duration is computed.
    }

    action def SaveCountedTime {
        in timeToSave : TravelTime;
    }

    action def LoadTimingProfile {
        doc
        /* Retrieves the stored timing profile (opening and closing travel times)
         * from non-volatile memory for use by movement-supervision functions as
         * the automatic-mode movement timeout (supports REQ-F-07,
         * configurableTimingProfile).
         */
        out timingProfile : TravelTime;
    }

    action def ExitConfigurationMode;
    action def NotifyUserAboutDeactivationOfConfigurationMode;
    action def CheckConfigurationModeState {
        out attribute alreadyActive : Boolean;
        doc
        /* Checks whether configuration mode is already active before a new
         * activation request is accepted, realizing UC_03's documented
         * precondition ("configuration mode not already active").
         */
    }
    action def RejectConfigurationModeReentry {
        doc
        /* Configuration mode is already active; the new activation request
         * is rejected and the in-progress configuration session continues
         * unaffected (REQ-F-08).
         */
    }

    action def CheckTravelTimeInRange {
        in measuredTime : TravelTime;
        out attribute inRange : Boolean;
        doc
        /* Validates a just-measured travel time against REQ-F-07's hard boundary
         * ('maxConfigurableTravelTime <= 120 [SI::s]').
         */
    }

    action def RejectOutOfRangeCalibration {
        doc
        /* The just-measured travel time exceeded REQ-F-07's
         * maxConfigurableTravelTime boundary (120 s) and is discarded, not
         * persisted.
         */
    }

    // Both opening and closing travel times measured independently (REQ-F-07).
    action def ConfigureController {
        action checkConfigurationModeState : CheckConfigurationModeState;
        action rejectConfigurationModeReentry : RejectConfigurationModeReentry;
        action moveShutterToClosePosition : MoveShutterToClosePosition;
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

        // Reentry guard (system model review corrective pass, closes the
        // Major finding described above): configuration-mode activation is
        // rejected, not silently re-entered/overlapped, if already active.
        first start then checkConfigurationModeState;
        if checkConfigurationModeState.alreadyActive == true {
            action rejectConfigurationModeReentry;
        }
        else moveShutterToClosePosition;

        then activateConfigurationMode;
        then notifyUserAboutActivationOfConfigurationMode;
        then action startCountingTime;
        then action openRollerShutter;
        then action stopCountingTime;
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

    // DiagnoseAndRepairController sub-steps (system model review corrective
    // pass, closes Major finding M3): previously a fully empty stub, giving
    // UC_04 a "hollow" end-to-end trace. Elaborated to the minimum level
    // needed to realize REQ-Q-04 (diagnosability) and REQ-Q-05
    // (fieldReplaceability); further elaboration remains a candidate for a
    // dedicated UC_04 deep-dive pass.
    action def DetectFault {
        doc
        /* Observes the controller's field diagnostic indication (REQ-Q-04)
         * to classify the reported malfunction into one of the supported
         * fault classes (no power, no response to any control input, or
         * motor-drive fault) without specialized lab equipment.
         */
    }
    action def IsolateFault {
        doc
        /* Isolates the classified fault to the controller unit using the
         * existing installation wiring, without modifying that wiring
         * (REQ-Q-05).
         */
    }
    action def RepairOrReplaceUnit {
        doc
        /* Repairs or replaces the faulty controller on-site using the
         * existing wiring (REQ-Q-05), restoring normal operation.
         */
    }

    action def DiagnoseAndRepairController {
        doc
        /* Realizes UC_04_DiagnoseAndRepairController.
         * Diagnose a failed or malfunctioning controller in the field and
         * repair or replace it on-site without modifying existing wiring.
         */

        first start;
        then action detectFault : DetectFault;
        then action isolateFault : IsolateFault;
        then action repairOrReplaceUnit : RepairOrReplaceUnit;
    }

    // DisposeController sub-steps (MAJ-2 fix, SMRR corrective pass): previously
    // a fully empty stub (doc-only, zero sub-actions), leaving UC_05 as the
    // one "Not Realized" requirement chain (REQ-E-01). Elaborated to the
    // minimum, lightweight level needed to realize REQ-E-01
    // (regulatedDisposal), mirroring DiagnoseAndRepairController's own
    // three-step elaboration pattern immediately above. Kept simple per
    // instruction -- no further sub-decomposition attempted.
    action def CollectController {
        doc
        /* DisposalFacility collects the decommissioned, retired controller
         * unit from the end user/installer at end of life.
         */
    }
    action def DisassembleController {
        doc
        /* DisposalFacility disassembles the collected unit for material
         * separation, using the disassembly access already designed into
         * EnclosureAndConnectors (no specialist equipment required, per
         * REQ-E-01's "allow disassembly and material separation without
         * specialist equipment" clause).
         */
    }
    action def TransferToAuthorizedDisposal {
        doc
        /* DisposalFacility transfers the separated materials to an
         * authorized WEEE/RoHS-compliant recycling/disposal pathway,
         * completing the regulated end-of-life chain.
         */
    }

    action def DisposeController {
        doc
        /* Realizes UC_05_DisposeController.
         * Collect, disassemble, and dispose of / recycle a retired controller
         * in compliance with WEEE/RoHS regulation.
         */

        first start;
        then action collectController : CollectController;
        then action disassembleController : DisassembleController;
        then action transferToAuthorizedDisposal : TransferToAuthorizedDisposal;
    }

    // Action usages (package-level instances for traceability).
    // Note: 'satisfy' links from L0_Requirements to these elements belong in
    // Traceability::Traceability, following the project convention.
    //
    // Primitive black-box action usages — these provide named feature endpoints
    // for every action def that is referenced as a Derivation connection source
    // in Traceability::Traceability. SysML v2 connection ends must reference
    // features (usages), not classifier definitions (action def).
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
    action moveShutterToClosePosition : MoveShutterToClosePosition;
    action openShutterAutomatically : OpenShutterAutomatically;
    action closeShutterAutomatically : CloseShutterAutomatically;
    action openShutterManually : OpenShutterManually;
    action closeShutterManually : CloseShutterManually;
    action handleConflictingMovementCommands : HandleConflictingMovementCommands;
    action installController : InstallController;
    action configureController : ConfigureController;
    action diagnoseAndRepairController : DiagnoseAndRepairController;
    action disposeController : DisposeController;
    action collectController : CollectController;
    action disassembleController : DisassembleController;
    action transferToAuthorizedDisposal : TransferToAuthorizedDisposal;
    action loadTimingProfile : LoadTimingProfile;
    action checkConfigurationModeState : CheckConfigurationModeState;
    action rejectConfigurationModeReentry : RejectConfigurationModeReentry;
    action detectFault : DetectFault;
    action isolateFault : IsolateFault;
    action repairOrReplaceUnit : RepairOrReplaceUnit;
    action checkTravelTimeInRange : CheckTravelTimeInRange;
    action rejectOutOfRangeCalibration : RejectOutOfRangeCalibration;
} // package UseCaseActivities
