package BaseArchitecture {
    private import SystemIdea::*;

    // --- System Context (L0) ---
    // This defines the system under consideration and its key stakeholders.
    // It provides the foundational context for all subsequent requirements and design activities.

    // 1. Controller definition
    part def ShutterController {
        doc
        /* Window Roller Shutter controller. */
        part controlLogic {
            doc
            /* Controls behaviour of the motorDriver based on the local and remote interfaces. */
        }
        part motorDriver {
            doc
            /* Controls the window roller shutter motor movement. */
        }
        part localInterface
        {
            doc /* Handles commands from wallswitch. */
        }
        part remoteInterface
        {
            doc /* Handles commands from external system. */
        }
        part powerSupply
        {
            doc /* Delivers power to all controller's components. */
        }

        connect controlLogic to motorDriver;
        connect localInterface to controlLogic;
        connect remoteInterface to controlLogic;
    }

    //satisfy SystemIdea::WindowRollerShutterControllerIdea;
} // package BaseArchitecture
