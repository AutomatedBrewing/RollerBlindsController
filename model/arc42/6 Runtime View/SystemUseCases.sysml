package SystemUseCases {
    private import BaseArchitecture::*;
    private import Stakeholders::*;
    private import SystemContext::**;
    private import L0_Requirements::*;

    /* The System Use Cases are the services and the essential ends
     * of a system. The system is developed and operated to achieve
     * these services.
     */


    use case controlRollerShutter {
        subject controller : BaseArchitecture::ShutterController;
        actor user : Stakeholders::User;
        actor homeAutomationSystem : SystemContext::HomeAutomationSystem;

        objective {
            doc
            /* Change shutter state: open, close, move to position or stop current movement.  */
            require L0_Requirements::Functional.controlRollerShutter;
        }
    }

    use case installController {
        subject controller : BaseArchitecture::ShutterController;
        actor installer : Stakeholders::Installer;

        objective {
            doc
            /* Install the controller into the shutter system. */
            require L0_Requirements::Quality.easeOfInstallation;
        }
    }

    use case configureController {
        subject controller : BaseArchitecture::ShutterController;
        actor installer : Stakeholders::Installer;

        objective {
            doc
            /* Configure controller parameters required for operation. */
            require L0_Constraints::Architectural::timeBasedOperation;
        }
    }
} // package SystemUseCases
