/* Product Architecture (SM-PRD-21) — Top-Level Composite.
 * Realizes LogicalArchitecture::RollerShutterControllerLogicalComponents (SM-PRD-20)
 * per ADR_006_ProductRealizationStrategy and ADR_007_ProductCoupling. */
package ProductArchitecture {
    // Imports only the abstract root — SystemArchitecture_Taxonomy has no other public types.
    private import SystemArchitecture_Taxonomy::SystemArchitecture;
    private import ProductComponents::*;
    private import SystemContext::*;

    part def RollerShutterControllerProductComponents :> SystemArchitecture {
        doc
        /* Top-level Product Architecture of the Window Roller Shutter Controller.
         * Realizes LogicalArchitecture::RollerShutterControllerLogicalComponents via a single
         * 8-bit MCU (ControlMCU) hosting seven firmware modules, shared RequestInterfaceCircuits,
         * a relay motor drive, an active piezo buzzer (ADR-008), and a linear-regulator power supply. */

        // ── System boundary ports (mirrors SystemContext / Logical Architecture) ──
        port localCtrl    : ~DryContactControlPort;
        port remoteCtrl   : ~DryContactControlPort;
        port controlPower : ~ControlPowerPort;
        port mainsPower   : ~MainsPowerPort;
        port shutterDrive : ShutterDrivePort;

        // ── Product Components ───────────────────────────────────────────────
        part localRequestInterface     : RequestInterfaceCircuit;
        part remoteRequestInterface    : RequestInterfaceCircuit;
        part controlMCU                : ControlMCU;
        part motorDriveRelayModule     : MotorDriveRelayModule;
        part userNotificationBuzzer : AudibleNotificationBuzzer;
        part powerSupplyModule         : PowerSupplyModule;
        part enclosureAndConnectors    : EnclosureAndConnectors;

        // ── Boundary delegations ────────────────────────────────────────────
        // 1. System boundary → RequestInterfaceCircuit (local)  [port delegation]
        connect localCtrl to localRequestInterface.ctrlIn;

        // 2. System boundary → RequestInterfaceCircuit (remote)  [port delegation]
        connect remoteCtrl to remoteRequestInterface.ctrlIn;

        // 3. System boundary → PowerSupplyModule  [port delegation]
        connect controlPower to powerSupplyModule.controlPowerIn;

        // 4. System boundary → MotorDriveRelayModule  [port delegation]
        connect mainsPower to motorDriveRelayModule.mainsIn;

        // 5. shutterDrive boundary ← MotorDriveRelayModule  [port delegation]
        connect motorDriveRelayModule.driveOut to shutterDrive;

        // ── Inter-component connections ─────────────────────────────────────
        // 6. RequestInterfaceCircuit (local) → ControlMCU  [conditioned digital signal]
        connect localRequestInterface.digitalOut to controlMCU.localRawIn;

        // 7. RequestInterfaceCircuit (remote) → ControlMCU  [conditioned digital signal]
        connect remoteRequestInterface.digitalOut to controlMCU.remoteRawIn;

        // 8. ControlMCU → MotorDriveRelayModule  [relay coil control]
        connect controlMCU.relayOut to motorDriveRelayModule.coilIn;

        // 9. ControlMCU → AudibleNotificationBuzzer  [buzzer control]
        connect controlMCU.buzzerOut to userNotificationBuzzer.driveIn;

        // ── Power distribution ──────────────────────────────────────────────
        // 10. PowerSupplyModule → ControlMCU
        connect powerSupplyModule.logicRailOut to controlMCU.powerIn;
        // 11. PowerSupplyModule → RequestInterfaceCircuit (local)
        connect powerSupplyModule.logicRailOut to localRequestInterface.powerIn;
        // 12. PowerSupplyModule → RequestInterfaceCircuit (remote)
        connect powerSupplyModule.logicRailOut to remoteRequestInterface.powerIn;
        // 13. PowerSupplyModule → AudibleNotificationBuzzer
        connect powerSupplyModule.logicRailOut to userNotificationBuzzer.powerIn;
        // 14. PowerSupplyModule → MotorDriveRelayModule (coil-driver stage)
        connect powerSupplyModule.logicRailOut to motorDriveRelayModule.coilPowerIn;

        // EnclosureAndConnectors has no signal port — purely mechanical/structural containment.

        // ── Cost aggregation ─────────────────────────────────────────────────
        // Literal sum of all component unitCostPLN; MUST be updated on any change.
        // Satisfies L0_Constraints::Business::costEffective (manufacturingCost <= 50).
        //   localRequestInterface 1.5 + remoteRequestInterface 1.5 + controlMCU 2.0
        //   + motorDriveRelayModule 3.5 + userNotificationBuzzer 0.5
        //   + powerSupplyModule 1.5 + enclosureAndConnectors 4.0 = 14.5
        attribute totalUnitCostPLN : Real = 14.5;

        assert constraint {
            totalUnitCostPLN <= 50.0
        }
    }

    /* Package-level usage providing a named feature endpoint for traceability
     * links (SysML v2 connection ends must reference features, not classifiers). */
    part rollerShutterControllerProductComponents : RollerShutterControllerProductComponents;
} // package ProductArchitecture
