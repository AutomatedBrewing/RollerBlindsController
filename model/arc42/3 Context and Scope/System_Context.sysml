package SystemContext {
    private import Stakeholders::*;
    private import BaseArchitecture::*;
    private import SystemIdea::*;

    // --- System Context (L0) ---
    // This defines the system under consideration and its relationships with key stakeholders.
    // It provides the foundational context for all subsequent requirements and design activities.

    //  External actors definition (System boundaries)
    part def WallSwitch {
        doc
        /* Controls the controller. */
    }

    part def ExternalSystem {
        doc
        /* Controls the controller. */
    }

    part def PowerSource {
        doc
        /* Delivers power to the controller. */
    }

    part def WindowShutter {
        doc
        /* Covers the window. */
    }

    // Context diagram
    part def SystemContext {

        part shutterController : ShutterController;
        
        /* External actors */
        part wallSwitch : WallSwitch;
        part externalSystem : ExternalSystem;        
        part powerSource : PowerSource;
        part windowShutter : WindowShutter;

        /* Stakeholders */
        part user : Stakeholders::User;
        part manufacturer : Stakeholders::Manufacturer;
        part installer : Stakeholders::Installer;

        doc /* Stakeholders relationships. */
        connect user to wallSwitch;
        connect manufacturer to shutterController;
        connect installer to shutterController;
        connect installer to wallSwitch;
        connect installer to windowShutter;

        /* Subsystems connection. */
        connect wallSwitch to shutterController.localInterface;
        connect externalSystem to shutterController.remoteInterface;
        connect powerSource to shutterController.powerSupply;
        connect shutterController.motorDriver to windowShutter;
    }

}
