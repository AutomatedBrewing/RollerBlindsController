package UseCaseActivities {

    
    enum def MovementDirection {
        enum up;
        enum down;
    }

    enum def MovementMode {
        enum automatic;
        enum manual;
    }

    /* ------ Requests */
    item def MovementRequest {
        attribute direction : MovementDirection;
        attribute mode : MovementMode;
    }

    item def StopRequest;

    /* ------ Actions */
    action def StartShutterMovement {
        in request : MovementRequest;
    }

    action def WaitForStopCondition {
        in attribute timeout subsets ISQ::duration;
        then fork {
            accept after timeout;
            then finish;

            accept stopRequest : StopRequest;
            then finish;
        }

        join finish;
    }

    action def StopShutterMovement;

    action def ShutterMovementProcess {
        in movementRequest : MovementRequest;
        in attribute movementTimeout subsets ISQ::duration;

        first start;
        then action startShutterMovement : StartShutterMovement {
            in redefines request = movementRequest;
        }
        then action waitForStopCondition : WaitForStopCondition {
            in attribute redefines timeout = movementTimeout;
        }
        then action stopShutterMovement : StopShutterMovement;
    }

    action def OpenShutterAutomatically specializes ShutterMovementProcess {
        item request : MovementRequest {
            redefines direction = MovementDirection::up;
            redefines mode = MovementMode::automatic;
        }
        in redefines movementRequest = request;
    }

    action def CloseShutterAutomatically specializes ShutterMovementProcess {
        item request : MovementRequest {
            redefines direction = MovementDirection::down;
            redefines mode = MovementMode::automatic;
        }
        in redefines movementRequest = request;
    }

    action def OpenShutterManually specializes ShutterMovementProcess {
        item request : MovementRequest {
            redefines direction = MovementDirection::up;
            redefines mode = MovementMode::manual;
        }
        in redefines movementRequest = request;

        action waitForStopCondition redefines waitForStopCondition {
            accept stopRequest : StopRequest;
        }
    }

    action def CloseShutterManually specializes ShutterMovementProcess {
        item request : MovementRequest {
            redefines direction = MovementDirection::down;
            redefines mode = MovementMode::manual;
        }
        in redefines movementRequest = request;

        action waitForStopCondition redefines waitForStopCondition {
            accept stopRequest : StopRequest;
        }
    }
} // package UseCaseActivities
