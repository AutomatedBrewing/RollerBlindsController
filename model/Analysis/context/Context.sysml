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
    // Proxy port types (SYSMOD Tool 11.4) formalizing every external interface
    // at the system boundary. Defined here in the System Context package per
    // SYSMOD cross-mapping SM-PRD-11 §2 ("port defs, flow defs" belong in
    // the Context file). Actors and the ShutterController usage below are
    // typed by these definitions.
    port def DryContactControlPort {
        doc
        /* Two independent dry-contact style command inputs: UP and DOWN.
         * Used identically by both the local wall switch interface and the
         * remote (home automation) interface -- electrically equivalent,
         * no protocol stack involved.
         * A line is considered active when voltage is present on it.
         */

        out attribute up : Boolean;
        out attribute down : Boolean;
    }

    port def ShutterDrivePort {
        doc
        /* Switched mains outputs driving the roller shutter motor: ROLLER UP
         * and ROLLER DOWN. The controller relays/switches this signal; it
         * does not generate the mains power itself.
         */

        out attribute rollerUp : Boolean;
        out attribute rollerDown : Boolean;
    }

    port def ControlPowerPort {
        doc
        /* Low-voltage control power input (12V DC + GND) powering the
         * controller's own logic and interfaces. This nominalVoltage attribute
         * is traced to L0_Constraints::Electrical::supplyVoltage via
         * Traceability::Traceability (system model review corrective pass:
         * this cross-layer link already existed but was undocumented at the
         * point of use, making it easy to mistake for an unjustified/
         * duplicated constraint when reading this file in isolation).
         */

        attribute nominalVoltage = 12 [SI::V];
    }

    port def MainsPowerPort {
        doc
        /* Mains power input (230V AC) that the controller switches onward to
         * the roller shutter motor via ShutterDrivePort. The controller does
         * not generate this voltage, only relays it. This nominalVoltage
         * attribute is traced to L0_Constraints::Electrical::switchingLoad via
         * Traceability::Traceability (system model review corrective pass,
         * same rationale as ControlPowerPort above).
         */

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
        part maintenanceTechnician : Stakeholders::MaintenanceTechnician;
        part disposalFacility : Stakeholders::DisposalFacility;

        /* Stakeholders relationships (abstract/logical connections -- these
         * describe human/organizational involvement, not engineering
         * signal interfaces, so no ports are typed on these connects,
         * per SysML v2 connection.md's allowance for logical/abstract
         * connections).
         */
        connect user to wallSwitch;
        connect user to homeAutomationSystem;
        connect manufacturer to shutterController;
        connect installer to shutterController;
        connect maintenanceTechnician to shutterController;
        connect disposalFacility to shutterController;

        /* Subsystems connection -- typed port-to-port interfaces. */
        connect wallSwitch.ctrl to shutterController.localCtrl;
        connect homeAutomationSystem.ctrl to shutterController.remoteCtrl;
        connect controlPowerSupply.supply to shutterController.controlPower;
        connect mainsPowerSupply.supply to shutterController.mainsPower;
        connect shutterController.shutterDrive to windowRollerShutter.drive;
    }

    /* Package-level usages providing named feature endpoints for Traceability
     * connections. SysML v2 connection ends must reference features (usages),
     * not classifier definitions (part def).
     */
    part systemContext : SystemContextDiagram;
    part wallSwitch : WallSwitch;
    part homeAutomationSystem : HomeAutomationSystem;
    part controlPowerSupply : ControlPowerSupply;
    part mainsPowerSupply : MainsPowerSupply;
} // package SystemContext
