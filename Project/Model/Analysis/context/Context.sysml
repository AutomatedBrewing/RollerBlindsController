package SystemContext {
    private import Stakeholders::*;
    private import BaseArchitecture::*;
    private import SystemIdea::*;
    private import ScalarValues::Boolean;
    private import ScalarValues::Real;
    private import ScalarValues::String;

    comment
    /* The System Context lists the external entities that interact
     * with the system and shows relevant structures between and
     * inside the external entities.
     */

    enum def ActorCategory {
        user;
        externalSystem;
        environmentalEffect;
        environmentalImpact;
    }

    metadata def ActorMeta {
        attribute category : ActorCategory;
    }

    // === Port Definitions ===
    // Proxy port types formalizing all external interfaces at the system boundary.
    port def DryContactControlPort {
        doc
        /* Two dry-contact command inputs (UP, DOWN) used by both local and remote interfaces; active when voltage is present. */

        out attribute up : Boolean;
        out attribute down : Boolean;
    }

    port def ShutterDrivePort {
        doc
        /* Switched mains outputs (UP, DOWN) driving the roller shutter motor; controller relays, not generates, mains power. */

        out attribute rollerUp : Boolean;
        out attribute rollerDown : Boolean;
    }

    port def ControlPowerPort {
        doc
        /* Low-voltage control power input (12V DC) powering the controller logic and interfaces. */

        attribute nominalVoltage = 12 [SI::V];
    }

    port def MainsPowerPort {
        doc
        /* Mains power input (230V AC) switched onward to the roller shutter motor; controller relays, not generates, this voltage. */

        attribute nominalVoltage = 230 [SI::V];
    }

    // External actors definition (System boundaries)
    public part def WallSwitch {
        @ActorMeta { category = ActorCategory::externalSystem; }

        doc
        /* Controls the controller. */

        port ctrl : DryContactControlPort;
    }

    part def HomeAutomationSystem {
        @ActorMeta { category = ActorCategory::externalSystem; }

        doc
        /* Remotely controls the controller. */

        port ctrl : DryContactControlPort;
    }

    part def ControlPowerSupply {
        @ActorMeta { category = ActorCategory::externalSystem; }

        doc
        /* Delivers low-voltage control power (12V DC, GND) to the controller. */

        port supply : ControlPowerPort;
    }

    part def MainsPowerSupply {
        @ActorMeta { category = ActorCategory::externalSystem; }

        doc
        /* Delivers mains power (230V AC) to the controller, which the controller switches onward to the roller shutter motor. */

        port supply : MainsPowerPort;
    }

    part def WindowRollerShutter {
        @ActorMeta { category = ActorCategory::externalSystem; }

        doc
        /* Covers the window. */

        port drive : ~ShutterDrivePort;
    }


    part def SystemContextDiagram {

        part shutterController : ShutterController {
            port localCtrl : ~DryContactControlPort;
            port remoteCtrl : ~DryContactControlPort;
            port controlPower : ~ControlPowerPort;
            port mainsPower : ~MainsPowerPort;
            port shutterDrive : ShutterDrivePort;
        }

        /* External actors */
        part wallSwitch : WallSwitch;
        part homeAutomationSystem : HomeAutomationSystem;
        part controlPowerSupply : ControlPowerSupply;
        part mainsPowerSupply : MainsPowerSupply;
        part windowRollerShutter : WindowRollerShutter;

        /* Stakeholders */
        part user : Stakeholders::User;
        part manufacturer : Stakeholders::Manufacturer;
        part installer : Stakeholders::Installer;
        part disposalFacility : Stakeholders::DisposalFacility;

        /* Stakeholder relationships: abstract/logical connections (no typed ports). */
        connect user to wallSwitch;
        connect user to homeAutomationSystem;
        connect manufacturer to shutterController;
        connect installer to shutterController;
        connect disposalFacility to shutterController;

        /* Subsystems connection -- typed port-to-port interfaces. */
        connect wallSwitch.ctrl to shutterController.localCtrl;
        connect homeAutomationSystem.ctrl to shutterController.remoteCtrl;
        connect controlPowerSupply.supply to shutterController.controlPower;
        connect mainsPowerSupply.supply to shutterController.mainsPower;
        connect shutterController.shutterDrive to windowRollerShutter.drive;
    }

    /* Package-level usages providing named feature endpoints for Traceability connections. */
    part systemContext : SystemContextDiagram;
    part wallSwitch : WallSwitch;
    part homeAutomationSystem : HomeAutomationSystem;
    part controlPowerSupply : ControlPowerSupply;
    part mainsPowerSupply : MainsPowerSupply;
} // package SystemContext
