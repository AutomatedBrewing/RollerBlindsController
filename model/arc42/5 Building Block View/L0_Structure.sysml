package L0_Structure {
    private import ISQ::voltage;
    private import SI::V;
    private import ContextAndScope::*;

    /* CONNECTIONS */

    // Item definitions
    enum def ShutterCommand {
        enum MoveUp;
        enum MoveDown;
        enum Stop;
    }

    port def CommandPort {
        out item command : ShutterCommand;
    }

    connection def ShutterCommandConnection {
        end part sender : ShutterCommandSource;
        end part receiver : ShutterController;

        interface : ShutterControlInterface connect sender.commandPort to receiver.commandPort;
    }

    // Interface definitions connecting ports, composing flows
    interface def ShutterControlInterface {
        end port issuer : CommandPort;
        end port receiver : ~CommandPort;

        flow of ShutterCommand from issuer.command to receiver.command;
    }

    /* PARTIES */
    part def ShutterCommandSource {
        ref part controller : ShutterController;
        port commandPort : CommandPort;
    }
    part def WallSwitch specializes ShutterCommandSource;
    part def ExternalSystem specializes ShutterCommandSource;

    part def PowerSource specializes ContextAndScope::PowerSource {
        attribute voltage subsets ISQ::voltage default 12 [SI::V];
        ref part controller : ShutterController;
    }

    part def WindowShutter specializes ContextAndScope::WindowShutter {
        ref part controller : ShutterController;
    }

    part def ShutterController specializes ContextAndScope::ShutterController {
        ref part wallswitch : WallSwitch;
        ref part externalSystem : ExternalSystem;
        ref part powerSource : PowerSource;
        ref part windowShutter : WindowShutter;

        port commandPort : CommandPort;
    }

    part def ShutterControlSystem {
        part wallswitch : WallSwitch;
        part externalSystem : ExternalSystem;
        part powerSource : PowerSource;
        part windowShutter : WindowShutter;
        part controller : ShutterController;

        connection wallswitchConnection : ShutterCommandConnection connect [1] wallswitch to [1] controller;
        connection externalSystemConnection : ShutterCommandConnection
            connect [1] externalSystem to [1] controller;
    }
} // package L0_Structure
