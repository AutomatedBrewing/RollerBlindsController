package BaseArchitecture {
    private import SystemIdea::*;
    private import SystemObjectives::*;
    // Imports only the abstract root — SystemArchitecture_Taxonomy has no other public types.
    private import SystemArchitecture_Taxonomy::SystemArchitecture;

    comment
    /* Captures architectural decisions preset at project start (SM-PRD-07). Port defs belong in SystemContext (SM-PRD-11); port typings are addressed in LogicalArchitecture (SM-PRD-20). */

    part def ControlUnit {
        doc
        /* Processes commands and determines shutter movement behaviour. */
    }

    part def MotorDriver {
        doc
        /* Switches motor power circuits to drive the shutter upwards or downwards. */
    }

    part def WallSwitchInterface {
        doc
        /* Receives commands from a locally connected wall switch. */
    }

    part def RemoteInterface {
        doc
        /* Receives commands from an external automation or control system. */
    }

    part def PowerModule {
        doc
        /* Converts and distributes electrical power required by controller components. */
    }

    part def ShutterController specializes SystemArchitecture {
        doc
        /* Window Roller Shutter controller. */

        part controlLogic : ControlUnit;
        part motorDriver : MotorDriver;
        part localInterface : WallSwitchInterface;
        part remoteInterface : RemoteInterface;
        part powerSupply : PowerModule;

        connect controlLogic to motorDriver;
        connect localInterface to controlLogic;
        connect remoteInterface to controlLogic;
        connect powerSupply to controlLogic;
        connect powerSupply to motorDriver;
        connect powerSupply to localInterface;
        connect powerSupply to remoteInterface;

        satisfy SystemIdea::systemIdea;
    }

    /* Named feature endpoint required by SysML v2 for traceability and satisfy links. */
    part shutterController : ShutterController;
} // package BaseArchitecture
