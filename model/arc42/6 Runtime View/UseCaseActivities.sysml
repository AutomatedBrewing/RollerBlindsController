package UseCaseActivities {
    private import BaseArchitecture::ShutterController;
    private import ScalarValues::Boolean;
    private import ISQ::*; // Import międzynarodowego systemu ilości (dla czasu/duration)

    /* The Use Case Activities specify the functional decomposition
     * of the System Use Cases and, thus, the overall system in the
     * problem space. They define the sequence of execution and
     * object flow between the system functions.
     */

    // =========================================================================
    // Definicje domenowe (Słownik danych - Problem Space)
    // =========================================================================
    enum def MovementDirection {
        enum up;
        enum down;
        enum none;
    }

    enum def MovementMode {
        enum automatic;
        enum manual;
    }

    enum def StopReason {
        enum timeout;
        enum userRequest;
    }

    item def StopRequest {
        attribute reason : StopReason;
    }

    item def ControlCommand {
        attribute direction : MovementDirection;
        attribute mode : MovementMode;
    }

    item def MovementRequest {
        attribute direction : MovementDirection;
        attribute mode : MovementMode;
    }

    item def MotorState {
        attribute direction : MovementDirection;
        attribute enable : Boolean;
    }

    item def ShutterState {
        attribute moving : Boolean;
        attribute direction : MovementDirection;
    }

    // =========================================================================
    // Definicje abstrakcyjnych akcji (Bloki funkcjonalne czarnej skrzynki)
    // =========================================================================
    action def ReceiveControlRequest {
        accept userWish : ControlCommand via BaseArchitecture::ShutterController::localInterface;
        accept remoteWish : ControlCommand via BaseArchitecture::ShutterController::remoteInterface;
        out userWish;
    }

    action def DetermineMovementRequest {
        in userWish : ControlCommand;
        out request : MovementRequest;
    }

    action def StartShutterMovement {
        in request : MovementRequest;
        out motorState : MotorState;
        out shutterState : ShutterState;

        assign shutterState.moving := true;
        assign shutterState.direction := request.direction;
    }

    action def MonitorStopCondition {
        in request : MovementRequest;
        in attribute timeout subsets ISQ::duration;
        out stopRequest : StopRequest;

        fork {
            action listenForStopCommand {
                accept stopReq : ControlCommand;
                then assign stopRequest.reason := StopReason::userRequest;
            }

            action monitorTimeout {
                accept after timeout;
                assign stopRequest.reason := StopReason::timeout;
            }
        }
    }

    action def MonitorUserInterruption {
        in request : MovementRequest;
        in attribute timeout subsets ISQ::duration;
        out stopRequest : StopRequest;

        accept stopReq : ControlCommand;
        then assign stopRequest.reason := StopReason::userRequest;
    }

    action def StopShutterMovement {
        in stopRequest : StopRequest;
        out motorState : MotorState;
        out shutterState : ShutterState;

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

        /* Execution sequence. */
        first start;
        then action receiveControlRequest : ReceiveControlRequest;
        then action determineMovementRequest : DetermineMovementRequest;
        then action startShutterMovement : StartShutterMovement;
        then action monitorStopCondition : MonitorStopCondition;
        then action stopShutterMovement : StopShutterMovement;

        /* Object Flows */
        flow from receiveControlRequest.userWish to determineMovementRequest.userWish;
        flow from determineMovementRequest.request to startShutterMovement.request;
        flow from timeout to monitorStopCondition.timeout;
        flow from determineMovementRequest.request to monitorStopCondition.request;
        flow from monitorStopCondition.stopRequest to stopShutterMovement.stopRequest;

        /* Mapowanie stanów na wyjście systemu */
        flow from startShutterMovement.motorState to motorState;
        flow from stopShutterMovement.motorState to motorState;
        flow from startShutterMovement.shutterState to shutterState;
        flow from stopShutterMovement.shutterState to shutterState;
    }

    // =========================================================================
    // Processes specialization
    // =========================================================================

    action def OpenShutterAutomatically specializes ControlRollerShutter {
        action redefines receiveControlRequest {
            out redefines userWish : ControlCommand {
                attribute redefines direction = MovementDirection::up;
                attribute redefines mode = MovementMode::automatic;
            }
        }
    }

    action def CloseShutterAutomatically specializes ControlRollerShutter {
        action redefines receiveControlRequest {
            out redefines userWish : ControlCommand {
                attribute redefines direction = MovementDirection::down;
                attribute redefines mode = MovementMode::automatic;
            }
        }
    }

    action def OpenShutterManually specializes ControlRollerShutter {
        action redefines receiveControlRequest {
            out redefines userWish : ControlCommand {
                attribute redefines direction = MovementDirection::up;
                attribute redefines mode = MovementMode::manual;
            }
        }

        action waitForStopCondition : MonitorUserInterruption redefines monitorStopCondition;
    }

    action def CloseShutterManually specializes ControlRollerShutter {
        action redefines receiveControlRequest {
            out redefines userWish : ControlCommand {
                attribute redefines direction = MovementDirection::down;
                attribute redefines mode = MovementMode::manual;
            }
        }
        action waitForStopCondition : MonitorUserInterruption redefines monitorStopCondition;
    }

    // =========================================================================
    // Installation and configuration.
    // =========================================================================
    action def TurnOffPowerSupplyForShutters;
    action def DisassembleWallswitch;
    action def ConnectController;
    action def VerifyWorking;
    action def AssembleWallswitch;

    action def InstallController {
        first start;
        then action turnOffPowerSupplyForShutters : TurnOffPowerSupplyForShutters;
        then action disassembleWallswitch : DisassembleWallswitch;
        then action connectController : ConnectController;
        then action verifyWorking : VerifyWorking;
        then action assembleWallswitch : AssembleWallswitch;
    }

    action def MoveShutterToClosePosition;
    action def ActivateConfigurationMode;
    action def NotifyUserAboutActivationOfConfigurationMode;

    action def CountActionTime {
        in shutterStateIn : ShutterState;
        out measuredTime subsets ISQ::duration;
    }

    action def SaveCountedTime {
        in timeToSave subsets ISQ::duration;
    }

    action def ExitConfigurationMode;
    action def NotifyUserAboutDeactivationOfConfigurationMode;

    action def ConfigureController {
        action runMovement : OpenShutterManually;
        action countActionTime : CountActionTime;

        first start;
        then action moveShutterToClosePosition : MoveShutterToClosePosition;
        then action activateConfigurationMode : ActivateConfigurationMode;
        then action notifyUserAboutActivationOfConfiugurationMode
            : NotifyUserAboutActivationOfConfigurationMode;

        then fork {
            action runMovement;
            action countActionTime;
        }

            then action saveCountedTime : SaveCountedTime;
            then action exitConfigurationMode : ExitConfigurationMode;
            then action notifyUserAboutDeactivationOfConfiugurationMode
                : NotifyUserAboutDeactivationOfConfigurationMode;

        /* Przepływy dla konfiguratora */
        flow from runMovement.shutterState to countActionTime.shutterStateIn;
        flow from countActionTime.measuredTime to saveCountedTime.timeToSave;
    }

    // =========================================================================
    // Action Usages
    // =========================================================================
    action openShutterAutomatically : OpenShutterAutomatically;
    action closeShutterAutomatically : CloseShutterAutomatically;
    action openShutterManually : OpenShutterManually;
    action closeShutterManually : CloseShutterManually;
    action installController : InstallController;
    action configureController : ConfigureController;
} // package UseCaseActivities
