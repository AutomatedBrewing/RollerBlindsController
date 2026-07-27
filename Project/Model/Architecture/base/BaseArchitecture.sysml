package BaseArchitecture {
    private import SystemIdea::*;
    private import SystemObjectives::*;
    // Import only the abstract root, NOT the wildcard: SystemArchitecture_Taxonomy
    // also declares a same-named abstract header 'BaseArchitecture' (see that
    // file's own header comment), which collides with this enclosing package's
    // own name if wildcard-imported, breaking name resolution throughout this
    // file (Syside reference-error fix).
    private import SystemArchitecture_Taxonomy::SystemArchitecture;

    comment
    /* The Base Architecture is a description of the architectural and
     * technical decisions that are preset at the project start.
     * Port interface definitions (port defs) belong in the System Context
     * package (SM-PRD-11) per SYSMOD cross-mapping §2. Internal part
     * port typings and boundary port delegation are addressed in the
     * Logical Architecture (SM-PRD-20).
     */

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

    /* Package-level usage providing a named feature endpoint for traceability
     * and satisfy links (SysML v2 requires a feature, not a classifier). */
    part shutterController : ShutterController;
} // package BaseArchitecture
