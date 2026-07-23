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

    // CF-2, CF-5 compliant:
    //   Both local and remote commands routed via fork+merge (first-wins).
    //   No 'via' reference to internal architecture parts (architecture-independent).
    action def ReceiveControlRequest {
        out command : ControlCommand;

        action acceptLocalCmd  accept localCmd  : ControlCommand;
        action acceptRemoteCmd accept remoteCmd : ControlCommand;

        fork  acceptFork;
        merge acceptMerge;

        first start;
        then acceptFork;
        first acceptFork then acceptLocalCmd;
        first acceptFork then acceptRemoteCmd;
        first acceptLocalCmd  then acceptMerge;
        first acceptRemoteCmd then acceptMerge;

        // Whichever accept fires first flows its payload to 'command'.
        flow from acceptLocalCmd.localCmd   to command;
        flow from acceptRemoteCmd.remoteCmd to command;
    }

    // CF-1: adds runtime conflict check; direction == none triggers suppress-movement path.
    action def DetermineMovementRequest {
        in command : ControlCommand;
        out request : MovementRequest;

        action suppressMovement {
            doc /* UC_01e path: simultaneous UP+DOWN conflict — no movement. */
            assign request.direction := MovementDirection::none;
            assign request.mode      := command.mode;
        }
        action passThrough {
            assign request.direction := command.direction;
            assign request.mode      := command.mode;
        }

        first start;
        decide;
        if command.direction == MovementDirection::none then suppressMovement;
        else passThrough;
    }

    // motorState assigned symmetrically with shutterState; direction==none branch keeps motor de-energized (UC_01e).
    action def StartShutterMovement {
        in request : MovementRequest;
        out motorState   : MotorState;
        out shutterState : ShutterState;

        action activateMotor {
            assign motorState.enable      := true;
            assign motorState.direction   := request.direction;
            assign shutterState.moving    := true;
            assign shutterState.direction := request.direction;
        }
        action suppressMotor {
            doc /* UC_01e path: conflict — motor remains de-energized. */
            assign motorState.enable      := false;
            assign motorState.direction   := MovementDirection::none;
            assign shutterState.moving    := false;
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

        fork  stopFork;
        merge stopMerge;

        first start;
        then stopFork;
        first stopFork then listenForStopCommand;
        first stopFork then monitorTimeout;
        first listenForStopCommand then stopMerge;
        first monitorTimeout       then stopMerge;
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

        fork  interruptFork;
        merge interruptMerge;

        first start;
        then interruptFork;
        first interruptFork then listenForRelease;
        first interruptFork then monitorTimeout;
        first listenForRelease then interruptMerge;
        first monitorTimeout   then interruptMerge;
    }

    action def StopShutterMovement {
        in stopRequest : StopRequest;
        out motorState   : MotorState;
        out shutterState : ShutterState;

        assign motorState.enable      := false;
        assign motorState.direction   := MovementDirection::none;
        assign shutterState.moving    := false;
        assign shutterState.direction := MovementDirection::none;
    }

    // =========================================================================
    // Base Use Case Activity
    // =========================================================================
    action def ControlRollerShutter {
        in attribute timeout subsets ISQ::duration {
            doc
            /* Abstract UCA-level movement-stop timeout. This parameter keeps
             * ControlRollerShutter self-contained at the Use Case Activities
             * layer, before the timing-profile persistence mechanism (UC_03)
             * is introduced. It is REFINED (not contradicted) at the
             * Functional Architecture layer by SuperviseMovementStop, which
             * derives the concrete, direction-specific timeout from the
             * persisted TimingProfile (see loadProfile below and
             * memoryFunctions) rather than receiving it as an external
             * scalar. NOTE (system model review corrective pass, closes
             * Major finding M4 -- interface-shape drift): this doc makes the
             * UCA-abstraction-to-FA-refinement relationship explicit so
             * Product Architecture does not implement against the wrong
             * layer's contract; the FA-level TimingProfile-based mechanism
             * is the authoritative one for any concrete realization. */
        }
        out motorState   : MotorState;
        out shutterState : ShutterState;

        first start;
        then action loadProfile              : LoadTimingProfile;
        then action receiveControlRequest    : ReceiveControlRequest;
        then action determineMovementRequest : DetermineMovementRequest;
        then action startShutterMovement     : StartShutterMovement;
        then action monitorStopCondition     : MonitorStopCondition;
        then action stopShutterMovement      : StopShutterMovement;

        // loadProfile (system model review corrective pass, closes the
        // LoadTimingProfile orphan finding): composed here so the
        // profile-loading step's position in the overall sequence is
        // explicit even at this abstract UCA layer, and so LoadTimingProfile
        // is no longer an un-composed, package-level-only usage. Its output
        // is not flowed into monitorStopCondition here -- see the timeout
        // attribute doc above for why that reduction is deferred to FA's
        // SuperviseMovementStop.
        flow from receiveControlRequest.command    to determineMovementRequest.command;
        flow from determineMovementRequest.request to startShutterMovement.request;
        flow from timeout                          to monitorStopCondition.timeout;
        flow from determineMovementRequest.request to monitorStopCondition.request;
        flow from monitorStopCondition.stopRequest to stopShutterMovement.stopRequest;

        flow from startShutterMovement.motorState   to motorState;
        flow from stopShutterMovement.motorState    to motorState;
        flow from startShutterMovement.shutterState to shutterState;
        flow from stopShutterMovement.shutterState  to shutterState;
    }

    // =========================================================================
    // Variant specializations
    // =========================================================================
    // NOTE (CF-6 partial mitigation): The 'redefines command' here acts as a
    // variant-level type constraint — it characterizes which command is *expected*
    // in this use case variant, not a runtime override of the accepted signal value.
    // The actual runtime value flows from the accept actions in ReceiveControlRequest.
    // Full runtime mode/direction discrimination from dry-contact signals (e.g.,
    // press-duration detection for automatic vs. manual) is deferred to Functional
    // and Logical Architecture refinement, where sensing logic can be allocated.

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

    action def NotifyUserAboutConflict {
        doc
        /* Realizes REQ-S-02 (conflictIndication): raises a distinct,
         * user-perceivable indication (e.g. a dedicated LED/buzzer pattern)
         * when a simultaneous UP+DOWN conflict has been detected and motor
         * activation suppressed, so the suppressed-movement state is
         * observable rather than silent. Added to close Major finding M2
         * (system model review corrective pass). */

        out conflictEvent : ConflictEvent;
    }

    action def HandleConflictingMovementCommands specializes ControlRollerShutter {
        doc
        /* Realizes UC_01e: simultaneous UP+DOWN commands — motor remains
         * de-energized in both directions; no shutter movement occurs.
         * Behavioral counterpart to the galvanic-isolation safety constraint
         * (L0_Constraints::Electrical::motorIsolation) and REQ-S-01. Also
         * realizes REQ-S-02 (conflictIndication, system model review
         * corrective pass, closes Major finding M2): the suppressed-movement
         * state is followed by an explicit user-facing notification step,
         * distinguishing it from normal idle behavior. */
        action redefines receiveControlRequest {
            out redefines command : ControlCommand {
                attribute redefines direction = MovementDirection::none;
                attribute redefines mode = MovementMode::automatic;
            }
        }
        action notifyUserAboutConflict : NotifyUserAboutConflict;

        first stopShutterMovement then notifyUserAboutConflict;
    }

    // =========================================================================
    // Installation
    // =========================================================================
    action def TurnOffPowerSupplyForShutters;
    action def DisassembleWallswitch;
    action def ConnectController;
    action def VerifyWorking {
        out success : Boolean;
    }
    action def AssembleWallswitch;
    action def ReportInstallationFault {
        doc
        /* Terminal fault signal surfaced when a second consecutive wiring/
         * power-supply verification attempt still fails. Repair of this
         * fault (wiring or power-supply defect) is out of scope for the
         * controller itself and requires external intervention before
         * installation can proceed. Added to close a model/comment mismatch
         * found during the system model review corrective pass: the
         * previous InstallController retry branch looped indefinitely with
         * no terminal action, contradicting its own comment. */
    }

    action def InstallController {
        first start;
        then action turnOffPowerSupplyForShutters : TurnOffPowerSupplyForShutters;
        then action disassembleWallswitch         : DisassembleWallswitch;
        then action connectController             : ConnectController;
        then action verifyWorking                 : VerifyWorking;
        then action assembleWallswitch            : AssembleWallswitch;

        action retryConnectController  : ConnectController;
        action retryVerifyWorking      : VerifyWorking;
        action reportInstallationFault : ReportInstallationFault;

        // Exception path (system model review corrective pass -- fixes a
        // model/comment mismatch found during the review: the previous
        // 'else connectController;' branch looped back into the
        // already-declared 'first connectController then verifyWorking'
        // succession, creating an INFINITE retry loop with no terminal
        // branch, contradicting this very comment, which already claimed "a
        // second failure ... is surfaced as a terminal fault signal." A
        // single bounded retry is now modeled; a second consecutive failure
        // surfaces an explicit ReportInstallationFault action instead of
        // looping forever.
        decide afterVerify;
        if verifyWorking.success == true then assembleWallswitch;
        else retryConnectController;

        first retryConnectController then retryVerifyWorking;
        decide afterRetryVerify;
        if retryVerifyWorking.success == true then assembleWallswitch;
        else reportInstallationFault;
    }

    // =========================================================================
    // Configuration
    // =========================================================================
    action def MoveShutterToClosePosition;
    action def ActivateConfigurationMode;
    action def NotifyUserAboutActivationOfConfigurationMode;

    action def CountActionTime {
        in shutterStateIn : ShutterState;
        out measuredTime  : TravelTime;
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
         * configurableTimingProfile). */
        out timingProfile : TimingProfile;
    }

    action def ExitConfigurationMode;
    action def NotifyUserAboutDeactivationOfConfigurationMode;
    action def CheckConfigurationModeState {
        out attribute alreadyActive : Boolean;
        doc
        /* Checks whether configuration mode is already active before a new
         * activation request is accepted, realizing UC_03's documented
         * precondition ("configuration mode not already active"). Added to
         * close a Major finding from the system model review corrective
         * pass: TC_N_002_ConfigMode_ReentryRejected previously verified
         * behavior with no corresponding activity-level guard. */
    }
    action def RejectConfigurationModeReentry {
        doc
        /* Configuration mode is already active; the new activation request
         * is rejected and the in-progress configuration session continues
         * unaffected (REQ-F-08). */
    }

    action def CheckTravelTimeInRange {
        in measuredTime : TravelTime;
        out attribute inRange : Boolean;
        doc
        /* MAJ-8 fix (SMRR corrective pass): validates a just-measured travel
         * time against REQ-F-07's hard boundary
         * ('maxConfigurableTravelTime <= 120 [SI::s]') before the value is
         * allowed to reach SaveCountedTime, closing the previously
         * documented "no validate-before-persist guard" gap (Scenario
         * Repair Plan SR-7, RISK-T-05 residual, Scenarios::SCEN_22).
         * inRange == false when measuredTime exceeds the 120 s boundary;
         * reused identically for both the opening and closing measurement
         * (REQ-F-07 bounds both directions), mirroring how CountActionTime/
         * SaveCountedTime are already reused for both directions above. */
    }

    action def RejectOutOfRangeCalibration {
        doc
        /* MAJ-8 fix: the just-measured travel time exceeded REQ-F-07's
         * maxConfigurableTravelTime boundary (120 s) and is discarded, not
         * persisted -- SaveCountedTime is never reached on this path. The
         * installer is left to retry in a subsequent configuration-mode
         * session; configuration mode exits without saving the invalid
         * value, so the previously-persisted (or default) TimingProfile
         * remains authoritative (Scenarios::SCEN_22 s3-s5). Reuses the
         * existing exit/notification path
         * (ExitConfigurationMode + NotifyUserAboutDeactivationOfConfigurationMode)
         * rather than introducing a new notification function. */
    }

    // Both opening and closing travel times measured independently (REQ-F-07).
    action def ConfigureController {
        action checkConfigurationModeState                  : CheckConfigurationModeState;
        action rejectConfigurationModeReentry               : RejectConfigurationModeReentry;
        action moveShutterToClosePosition                   : MoveShutterToClosePosition;
        action activateConfigurationMode                    : ActivateConfigurationMode;
        action notifyUserAboutActivationOfConfigurationMode : NotifyUserAboutActivationOfConfigurationMode;
        action runOpenMovement  : OpenShutterManually;
        action countOpenTime    : CountActionTime;
        action checkOpenTimeInRange  : CheckTravelTimeInRange;
        action saveOpenTime     : SaveCountedTime;
        action runCloseMovement : CloseShutterManually;
        action countCloseTime   : CountActionTime;
        action checkCloseTimeInRange : CheckTravelTimeInRange;
        action saveCloseTime    : SaveCountedTime;
        action rejectOutOfRangeCalibration                     : RejectOutOfRangeCalibration;
        action exitConfigurationMode                           : ExitConfigurationMode;
        action notifyUserAboutDeactivationOfConfigurationMode : NotifyUserAboutDeactivationOfConfigurationMode;

        fork openFork;
        join openJoin;
        fork closeFork;
        join closeJoin;

        // Reentry guard (system model review corrective pass, closes the
        // Major finding described above): configuration-mode activation is
        // rejected, not silently re-entered/overlapped, if already active.
        first start                          then checkConfigurationModeState;
        decide reentryGuard;
        if checkConfigurationModeState.alreadyActive == true then rejectConfigurationModeReentry;
        else moveShutterToClosePosition;

        // Linear pre-measurement sequence
        first moveShutterToClosePosition                    then activateConfigurationMode;
        first activateConfigurationMode                     then notifyUserAboutActivationOfConfigurationMode;

        // Measure opening travel time (fork+join: both complete before saving)
        first notifyUserAboutActivationOfConfigurationMode  then openFork;
        first openFork                                      then runOpenMovement;
        first openFork                                      then countOpenTime;
        first runOpenMovement                               then openJoin;
        first countOpenTime                                 then openJoin;
        first openJoin                                      then checkOpenTimeInRange;

        // MAJ-8 fix (SMRR corrective pass): out-of-range calibration guard,
        // REQ-F-07 (maxConfigurableTravelTime <= 120 [SI::s]). Closes the
        // previously documented gap at Scenarios::SCEN_22 s3 -- an
        // out-of-range measurement is now rejected before it can reach
        // SaveCountedTime, instead of being trusted unconditionally.
        decide openRangeGuard;
        if checkOpenTimeInRange.inRange == true then saveOpenTime;
        else rejectOutOfRangeCalibration;

        // Measure closing travel time (fork+join: both complete before saving)
        first saveOpenTime                                  then closeFork;
        first closeFork                                     then runCloseMovement;
        first closeFork                                     then countCloseTime;
        first runCloseMovement                              then closeJoin;
        first countCloseTime                                then closeJoin;
        first closeJoin                                     then checkCloseTimeInRange;

        // MAJ-8 fix: identical guard applied to the closing-direction
        // measurement (REQ-F-07 bounds both directions).
        decide closeRangeGuard;
        if checkCloseTimeInRange.inRange == true then saveCloseTime;
        else rejectOutOfRangeCalibration;

        // Exit sequence: reached either via the nominal save path or via the
        // MAJ-8 rejection path (Scenarios::SCEN_22 s5 -- configuration mode
        // exits without persisting the invalid value).
        first saveCloseTime                                 then exitConfigurationMode;
        first rejectOutOfRangeCalibration                   then exitConfigurationMode;
        first exitConfigurationMode                         then notifyUserAboutDeactivationOfConfigurationMode;

        // Object flows
        flow from runOpenMovement.shutterState     to countOpenTime.shutterStateIn;
        flow from countOpenTime.measuredTime       to checkOpenTimeInRange.measuredTime;
        flow from countOpenTime.measuredTime       to saveOpenTime.timeToSave;
        flow from runCloseMovement.shutterState    to countCloseTime.shutterStateIn;
        flow from countCloseTime.measuredTime      to checkCloseTimeInRange.measuredTime;
        flow from countCloseTime.measuredTime      to saveCloseTime.timeToSave;
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
         * motor-drive fault) without specialized lab equipment. */
    }
    action def IsolateFault {
        doc
        /* Isolates the classified fault to the controller unit using the
         * existing installation wiring, without modifying that wiring
         * (REQ-Q-05). */
    }
    action def RepairOrReplaceUnit {
        doc
        /* Repairs or replaces the faulty controller on-site using the
         * existing wiring (REQ-Q-05), restoring normal operation. */
    }

    action def DiagnoseAndRepairController {
        doc
        /* Realizes UC_04_DiagnoseAndRepairController.
         * Diagnose a failed or malfunctioning controller in the field and
         * repair or replace it on-site without modifying existing wiring. */

        first start;
        then action detectFault         : DetectFault;
        then action isolateFault        : IsolateFault;
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
         * unit from the end user/installer at end of life. */
    }
    action def DisassembleController {
        doc
        /* DisposalFacility disassembles the collected unit for material
         * separation, using the disassembly access already designed into
         * EnclosureAndConnectors (no specialist equipment required, per
         * REQ-E-01's "allow disassembly and material separation without
         * specialist equipment" clause). */
    }
    action def TransferToAuthorizedDisposal {
        doc
        /* DisposalFacility transfers the separated materials to an
         * authorized WEEE/RoHS-compliant recycling/disposal pathway,
         * completing the regulated end-of-life chain. */
    }

    action def DisposeController {
        doc
        /* Realizes UC_05_DisposeController.
         * Collect, disassemble, and dispose of / recycle a retired controller
         * in compliance with WEEE/RoHS regulation. */

        first start;
        then action collectController              : CollectController;
        then action disassembleController           : DisassembleController;
        then action transferToAuthorizedDisposal    : TransferToAuthorizedDisposal;
    }

    // Action usages (package-level instances for traceability).
    // Note: 'satisfy' links from L0_Requirements to these elements belong in
    // Traceability::Traceability, following the project convention.
    //
    // Primitive black-box action usages — these provide named feature endpoints
    // for every action def that is referenced as a Derivation connection source
    // in Traceability::Traceability. SysML v2 connection ends must reference
    // features (usages), not classifier definitions (action def).
    action receiveControlRequest                              : ReceiveControlRequest;
    action determineMovementRequest                           : DetermineMovementRequest;
    action startShutterMovement                               : StartShutterMovement;
    action monitorStopCondition                               : MonitorStopCondition;
    action monitorUserInterruption                            : MonitorUserInterruption;
    action stopShutterMovement                                : StopShutterMovement;
    action controlRollerShutter                               : ControlRollerShutter;
    action activateConfigurationMode                          : ActivateConfigurationMode;
    action exitConfigurationMode                              : ExitConfigurationMode;
    action notifyUserAboutActivationOfConfigurationMode       : NotifyUserAboutActivationOfConfigurationMode;
    action notifyUserAboutDeactivationOfConfigurationMode     : NotifyUserAboutDeactivationOfConfigurationMode;
    action countActionTime                                    : CountActionTime;
    action saveCountedTime                                    : SaveCountedTime;
    action moveShutterToClosePosition                         : MoveShutterToClosePosition;
    action openShutterAutomatically                           : OpenShutterAutomatically;
    action closeShutterAutomatically                          : CloseShutterAutomatically;
    action openShutterManually                                : OpenShutterManually;
    action closeShutterManually                               : CloseShutterManually;
    action handleConflictingMovementCommands                  : HandleConflictingMovementCommands;
    action installController                                  : InstallController;
    action configureController                                : ConfigureController;
    action diagnoseAndRepairController                        : DiagnoseAndRepairController;
    action disposeController                                  : DisposeController;
    action collectController                                  : CollectController;
    action disassembleController                              : DisassembleController;
    action transferToAuthorizedDisposal                        : TransferToAuthorizedDisposal;
    action loadTimingProfile                                  : LoadTimingProfile;
    action notifyUserAboutConflict                            : NotifyUserAboutConflict;
    action checkConfigurationModeState                        : CheckConfigurationModeState;
    action rejectConfigurationModeReentry                     : RejectConfigurationModeReentry;
    action detectFault                                        : DetectFault;
    action isolateFault                                       : IsolateFault;
    action repairOrReplaceUnit                                : RepairOrReplaceUnit;
    action reportInstallationFault                            : ReportInstallationFault;
    action checkTravelTimeInRange                             : CheckTravelTimeInRange;
    action rejectOutOfRangeCalibration                        : RejectOutOfRangeCalibration;

} // package UseCaseActivities
