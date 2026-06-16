package SystemUseCases {
    private import BaseArchitecture::*;
    private import Stakeholders::*;
    private import L0_Requirements::*;

    /* The System Use Cases are the services and the essential ends
     * of a system. The system is developed and operated to achieve
     * these services.
     */

    use case openRollerShutter {
        subject controller : BaseArchitecture::ShutterController;
        actor user : Stakeholders::User;
        actor homeAutomationSystem : SystemContext::HomeAutomationSystem;

        objective {
            doc
            /* Move the roller shutter towards the open position. */
            require L0_Requirements::Functional.controlRollerShutter;
        }
    }

    use case closeRollerShutter {
        subject controller : BaseArchitecture::ShutterController;
        actor user : Stakeholders::User;
        actor homeAutomationSystem : SystemContext::HomeAutomationSystem;

        objective {
            doc
            /* Move the roller shutter towards the closed position. */
            require L0_Requirements::Functional.controlRollerShutter;
        }
    }

    use case positionRollerShutter {
        subject controller : BaseArchitecture::ShutterController;
        actor user : Stakeholders::User;
        actor homeAutomationSystem : SystemContext::HomeAutomationSystem;

        objective {
            doc
            /* Move the roller shutter to a desired intermediate position. */
            require L0_Requirements::Functional.manualPositioning;
        }
    }

    use case stopRollerShutterMovement {
        subject controller : BaseArchitecture::ShutterController;
        actor user : Stakeholders::User;
        actor homeAutomationSystem : SystemContext::HomeAutomationSystem;

        objective {
            doc
            /* Stop the current roller shutter movement. */
            require L0_Requirements::Functional.stopShutterMovement;
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
