package UseCaseActivities {
    private import UseCaseActivities::*;
    private import BaseArchitecture::ShutterController;
    private import ScalarValues::Boolean;

    /* The Use Case Activities specify the functional decomposition
     * of the System Use Cases and, thus, the overall system in the
     * problem space. They define the sequence of execution and
     * object flow between the system functions.
     */

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

    action def ReceiveControlRequest {
        accept userWish : ControlCommand via BaseArchitecture::ShutterController::localInterface;
        accept userWish : ControlCommand via BaseArchitecture::ShutterController::remoteInterface;
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
        out stopRequest : StopRequest;
        accept stopReq : ControlCommand;
        then assign stopRequest.reason := StopReason::userRequest;
    }

    action def StopShutterMovement {
        in stopRequest : StopRequest;
        out motorState : MotorState;
        out shutterState : ShutterState; // Zmiana stanu na "not moving"

        assign shutterState.moving := false;
        assign shutterState.direction := MovementDirection::none;
    }

    action def ControlRollerShutter {
        in attribute timeout subsets ISQ::duration;
        out motorState : MotorState;
        out shutterState : ShutterState;

        /* Order */
        first start;
        then action receiveControlRequest : ReceiveControlRequest;
        then action determineMovementRequest : DetermineMovementRequest;
        then action startShutterMovement : StartShutterMovement;
        then action monitorStopCondition : MonitorStopCondition;
        then action stopShutterMovement : StopShutterMovement;

        /* Flows */
        flow from receiveControlRequest.userWish to determineMovementRequest.userWish;
        flow from determineMovementRequest.request to startShutterMovement.request;
        flow from timeout to monitorStopCondition.timeout;
        flow from determineMovementRequest.request to monitorStopCondition.request;

        /* Control flow */
        flow from monitorStopCondition.stopRequest to stopShutterMovement.stopRequest;

        /* Shutter and motor states are exported out of the system. */
        flow from startShutterMovement.motorState to motorState;
        flow from stopShutterMovement.motorState to motorState;

        flow from startShutterMovement.shutterState to shutterState;
        flow from stopShutterMovement.shutterState to shutterState;
    }

    action def OpenShutterAutomatically specializes ControlRollerShutter {
        item request : MovementRequest {
            redefines direction = MovementDirection::up;
            redefines mode = MovementMode::automatic;
        }
        send request to receiveControlRequest;
    }

    action def CloseShutterAutomatically specializes ControlRollerShutter {
        item request : MovementRequest {
            redefines direction = MovementDirection::down;
            redefines mode = MovementMode::automatic;
        }
        send request to receiveControlRequest;
    }

    action def OpenShutterManually specializes ControlRollerShutter {
        item request : MovementRequest {
            redefines direction = MovementDirection::up;
            redefines mode = MovementMode::manual;
        }
        send request to receiveControlRequest;

        action waitForStopCondition : MonitorUserInterruption redefines monitorStopCondition {
            accept stopRequest : StopRequest;
        }
    }

    action def CloseShutterManually specializes ControlRollerShutter {
        item request : MovementRequest {
            redefines direction = MovementDirection::down;
            redefines mode = MovementMode::manual;
        }
        send request to receiveControlRequest;

        action waitForStopCondition : MonitorUserInterruption redefines monitorStopCondition {
            accept stopRequest : StopRequest;
        }
    }

    /* INSTALLATION */
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
    action def CountActionTime;
    action def SaveCountedTime;
    action def ExitConfigurationMode;
    action def NotifyUserAboutDeactivationOfConfigurationMode;

    action def ConfigureController {
        first start;
        then action moveShutterToClosePosition : MoveShutterToClosePosition;
        then action activateConfigurationMode : ActivateConfigurationMode;
        then action notifyUserAboutActivationOfConfiugurationMode
            : NotifyUserAboutActivationOfConfigurationMode;
        then fork {
            perform action openShutterManually : OpenShutterManually;
            then finish;

            action countActionTime : CountActionTime;
        }
        join finish;
        then action saveCountedTime : SaveCountedTime;
        then action exitConfigurationMode : ExitConfigurationMode;
        then action notifyUserAboutDeactivationOfConfiugurationMode
            : NotifyUserAboutDeactivationOfConfigurationMode;
    }

    /* Usages */
    /* Normal operation */
    action openShutterAutomatically : OpenShutterAutomatically;
    action closeShutterAutomatically : CloseShutterAutomatically;
    action openShutterManually : OpenShutterManually;
    action closeShutterManually : CloseShutterManually;

    /* Installation */
    action installController : InstallController;
    action configureController : ConfigureController;
} // package UseCaseActivities
