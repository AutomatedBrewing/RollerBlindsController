package BaseArchitecture {
    private import SystemIdea::*;

    comment
    /* The Base Architecture is a description of the architectural and
     * technical decisions that are preset at the project start.
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

    part def PowerSupply {
        doc
        /* Converts and distributes electrical power required by controller components. */
    }

    part def ShutterController {
        doc
        /* Window Roller Shutter controller. */

        part controlLogic : ControlUnit;
        part motorDriver : MotorDriver;
        part localInterface : WallSwitchInterface;
        part remoteInterface : RemoteInterface;
        part powerSupply : PowerSupply;

        connect controlLogic to motorDriver;
        connect localInterface to controlLogic;
        connect remoteInterface to controlLogic;

        satisfy SystemIdea::systemIdea;
    }
} // package BaseArchitecture
