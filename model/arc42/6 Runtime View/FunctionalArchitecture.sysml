package FunctionalArchitecture {
    private import UseCaseActivities::*;
    private import ScalarValues::Boolean;

    /* The Functional Architecture strengthens the functional aspect
     * and is a technology-independent functional description of the
     * system.
     */

    enum def CommandSource {
        enum wallSwitch;
        enum remoteSystem;
    }
    item def ControlCommand {
        attribute source : CommandSource;
        attribute direction : MovementDirection;
    }

    item def MotorCommand {
        attribute direction : MovementDirection;
        attribute enable : Boolean;
    }

    item def ShutterState {
        attribute moving : Boolean;
        attribute direction : MovementDirection;
    }

    action def ReceiveControlRequest {
        out command : ControlCommand;
    }

    action def DetermineMovementRequest {
        in command : ControlCommand;
        out request : MovementRequest;
    }

    action def StartShutterMovement {
        in request : MovementRequest;
        out motorCommand : MotorCommand;
        out shutterState : ShutterState; // Funkcja generuje też informację o stanie

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

    action def StopShutterMovement {
        in stopRequest : StopRequest;
        out motorCommand : MotorCommand;
        out shutterState : ShutterState; // Zmiana stanu na "not moving"

        assign shutterState.moving := false;
        assign shutterState.direction := MovementDirection::none;
    }

    action def ControlRollerShutter {
        in attribute timeout subsets ISQ::duration;
        out currentMotorCommand : MotorCommand;
        out currentShutterState : ShutterState;

        action receiveControlRequest : ReceiveControlRequest;
        action determineMovementRequest : DetermineMovementRequest;
        action startShutterMovement : StartShutterMovement;
        action monitorStopCondition : MonitorStopCondition;
        action stopShutterMovement : StopShutterMovement;

        /* Order */
        first receiveControlRequest;
        then determineMovementRequest;
        then startShutterMovement;
        then monitorStopCondition;
        then stopShutterMovement;

        /* Flows */
        flow from receiveControlRequest.command to determineMovementRequest.command;
        flow from determineMovementRequest.request to startShutterMovement.request;
        flow from timeout to monitorStopCondition.timeout;
        flow from determineMovementRequest.request to monitorStopCondition.request;

        /* Control flow */
        flow from monitorStopCondition.stopRequest to stopShutterMovement.stopRequest;

        /* Shutter and motor states are exported out of the system. */
        flow from startShutterMovement.motorCommand to currentMotorCommand;
        flow from stopShutterMovement.motorCommand to currentMotorCommand;

        flow from startShutterMovement.shutterState to currentShutterState;
        flow from stopShutterMovement.shutterState to currentShutterState;
    }
} // package FunctionalArchitecture
