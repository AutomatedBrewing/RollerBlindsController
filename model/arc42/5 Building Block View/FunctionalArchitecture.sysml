package FunctinalArchitecture {
    private import UseCaseActivities::*;

    /* The Functional Architecture strengthens the functional aspect
     * and is a technology-independent functional description of the
     * system.
     *      The functional architecture view of a completed system architecture should, at minimum, define the following:
     *
     * - the functional capabilities that the system uses to fulfill mission objectives and meet stakeholder needs;
     * - the required inputs and outputs for those system functions;
     * - the steps through which the system will transform provided inputs into the desired outputs;
     * - the grouping of those steps into independently executable sub-functions, if sub-functions are being employed, with corresponding definitions of the inputs and outputs for those sub-functions;
     * - the variations in the inputs, outputs, and execution of the system's function/sub-functions for each system mode, if the system has multiple modes; and
     * - the internal and external interfaces enabling input flow and output flow for each defined function, sub-function, and auxiliary function.
     */

    part def RollerShutterControllerFunctions {
        part requestAcquisition {
            perform action receiveRequest : ReceiveControlRequest;
            perform action receiveStop : MonitorUserInterruption;
        }

        part controlLogic {
            perform action parseRequest : DetermineMovementRequest;
            perform action scheduleShutterMovement : ControlRollerShutter;
        }

        part shutterControl {
            perform action startMovement : StartShutterMovement;
            perform action stoptMovement : StopShutterMovement;
        }

        part timeCounting {
            perform action countTime : CountActionTime;
        }

        part handleMemory {
            perform action saveTime : SaveCountedTime;
        }

        part userNotification {
            perform action notifyUserAboutActivationOfConfiugurationMode
                : NotifyUserAboutActivationOfConfigurationMode;
            perform action notifyUserAboutDeactivationOfConfiugurationMode
                : NotifyUserAboutDeactivationOfConfigurationMode;
        }
    }
} // package FunctinalArchitecture
