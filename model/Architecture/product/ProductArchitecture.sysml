/* Product Architecture (SM-PRD-21) — Top-Level Composite.
 *
 * Technology-specific structural realization of
 * LogicalArchitecture::RollerShutterControllerLogicalComponents (SM-PRD-20),
 * per ADR_006_ProductRealizationStrategy and ADR_007_ProductCoupling.
 * Boundary ports mirror SystemContext::SystemContextDiagram::shutterController
 * and LogicalArchitecture::RollerShutterControllerLogicalComponents exactly
 * (Traceability Rule 3 / modeling procedure step 5), giving full
 * external-interface parity across all three layers.
 */
package ProductArchitecture {
    // Import only the abstract root, NOT the wildcard: SystemArchitecture_Taxonomy
    // also declares a same-named abstract header 'ProductArchitecture' (see
    // that file's own header comment), which collides with this enclosing
    // package's own name if wildcard-imported, breaking name resolution
    // throughout this file (same Syside reference-error fix already applied
    // in BaseArchitecture.sysml, FunctionalArchitecture.sysml, and
    // LogicalArchitecture.sysml for the identical reason).
    //
    // TRACEABILITY RULE 2 DEVIATION (mirrors LogicalArchitecture.sysml's own
    // deviation, same tooling-driven reason): RollerShutterControllerProductComponents
    // specializes the abstract root 'SystemArchitecture' directly rather than
    // the same-named intermediate 'SystemArchitecture_Taxonomy::ProductArchitecture'
    // header, to avoid reintroducing the self-name collision described above.
    private import SystemArchitecture_Taxonomy::SystemArchitecture;
    private import ProductComponents::*;
    private import SystemContext::*;

    part def RollerShutterControllerProductComponents :> SystemArchitecture {
        doc
        /* Top-level Product Architecture of the Window Roller Shutter
         * Controller. Realizes LogicalArchitecture::
         * RollerShutterControllerLogicalComponents with a single low-cost
         * 8-bit MCU (ControlMCU) hosting eight firmware components, a
         * shared dual-instantiated request-conditioning circuit
         * (RequestInterfaceCircuit), a relay-based motor drive module, a
         * passive piezo buzzer user feedback element (ADR-008), and a linear-regulator power supply
         * (see LogicalToProductAllocation.sysml for the complete
         * Logical-to-Product allocation and ProductComponents.sysml for
         * every component's full responsibilities). Boundary ports mirror
         * SystemContext::SystemContextDiagram::shutterController and
         * LogicalArchitecture::RollerShutterControllerLogicalComponents
         * exactly, giving full external-interface parity with both. */

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
        // Confirms the "anticipated future ownership" note in
        // LogicalArchitecture.sysml: the regulated logic rail powers every
        // logic-level Product component. mainsPower is routed only to
        // MotorDriveRelayModule (connection 4 above), which alone switches
        // it onward via shutterDrive -- mirroring the Logical Architecture's
        // own controlPower/mainsPower boundary-port note exactly.
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

        // NOTE: EnclosureAndConnectors has no engineering signal port (purely
        // mechanical/structural containment for every other component in
        // this composite) -- mirrors how LogicalDiagnostics/
        // LogicalUserNotification were introduced as plain structural
        // members without requiring a Base Architecture precedent.

        // ── Cost aggregation (PA-5 fix, model_issues.md item 18) ────────────
        // Manual sum of every Product component's unitCostPLN, mirroring the
        // documented fallback in productArchitectureRepairPlan.md PA-5 (a
        // literal, reviewed sum rather than a computed cross-part expression,
        // for SysML v2 textual-notation safety -- this model's established
        // preference given prior costly multi-round syntax-error recoveries
        // from unvalidated expression patterns, see model_issues.md item 12
        // errata / item 15). Reviewed and MUST be updated whenever any
        // component's unitCostPLN changes:
        //   localRequestInterface (RequestInterfaceCircuit)  1.5
        //   remoteRequestInterface (RequestInterfaceCircuit) 1.5
        //   controlMCU                                       2.0
        //   motorDriveRelayModule                             3.5
        //   userNotificationBuzzer                           0.5
        //   powerSupplyModule                                1.5
        //   enclosureAndConnectors                            4.0
        //   ────────────────────────────────────────────────────
        //   totalUnitCostPLN                                 14.5
        // Cross-references L0_Constraints::Business::costEffective's
        // 'manufacturingCost <= 50' bound (Traceability::Traceability
        // already links costEffective to this composite; this attribute
        // makes that existing link checkable rather than merely declared).
        attribute totalUnitCostPLN : Real = 14.5;

        assert constraint {
            totalUnitCostPLN <= 50.0
        }
    }

    /* Package-level usage providing a named feature endpoint for traceability
     * links (SysML v2 connection ends must reference features, not classifiers). */
    part rollerShutterControllerProductComponents : RollerShutterControllerProductComponents;
} // package ProductArchitecture
