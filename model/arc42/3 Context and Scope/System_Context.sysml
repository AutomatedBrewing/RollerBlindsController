package SystemContext {
    private import Stakeholders::*;
    private import BaseArchitecture::*;
    private import SystemIdea::*;

    comment
    /* The System Context lists the external entities that interact
     * with the system and shows relevant structures between and
     * inside the external entities.
     */

    // External actors definition (System boundaries)
    part def WallSwitch {
        doc
        /* Controls the controller. */
    }

    part def HomeAutomationSystem {
        doc
        /* Remotely controls the controller. */
    }

    part def PowerSupply {
        doc
        /* Delivers power to the controller. */
    }

    part def WindowRollerShutter {
        doc
        /* Covers the window. */
    }

    // Context diagram
    part def SystemContext {
        part shutterController : ShutterController;

        /* External actors */
        part wallSwitch : WallSwitch;
        part homeAutomationSystem : HomeAutomationSystem;
        part powerSupply : PowerSupply;
        part windowRollerShutter : WindowRollerShutter;

        /* Stakeholders */
        part user : Stakeholders::User;
        part manufacturer : Stakeholders::Manufacturer;
        part installer : Stakeholders::Installer;

        /* Stakeholders relationships. */
        connect user to wallSwitch;
        connect user to homeAutomationSystem;
        connect manufacturer to shutterController;
        connect installer to shutterController;

        /* Subsystems connection. */
        connect wallSwitch to shutterController;
        connect homeAutomationSystem to shutterController;
        connect powerSupply to shutterController;
        connect shutterController to windowRollerShutter;
    }
} // package SystemContext
