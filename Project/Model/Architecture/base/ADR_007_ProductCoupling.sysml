/* Architecture Decision Record: ADR-007 — Logical-to-Product Coupling Strategy
 * Documents the per-component coupling strategy (SYSMOD Tool 11.7) for deriving Product Architecture
 * from Logical Architecture, mirroring ADR-004's role for Functional→Logical coupling.
 * arc42 section: ARC-09 Architecture Decisions.
 */
package ADR_007_ProductCoupling {
    private import LogicalArchitecture::*;
    private import BaseArchitecture::*;
    private import ADR_004_LogicalCoupling::*;
    private import ADR_006_ProductRealizationStrategy::*;
    private import ADR_Common::*;

    package ADR_007 {
        @ArchDecisionMeta {
            decisionId   = "ADR-007";
            title        = "Strong coupling for clean 1:1 Logical-to-Product realizations; loose coupling (allocation) wherever ADR-006's software modularization splits one Logical component across multiple Product components";
            status       = "accepted";
            context      = "ADR-006 splits LogicalControlUnit, LogicalMotorDrive, and LogicalUserNotification each into multiple Product components; a uniform coupling rule would either force artificial 1:1 relabeling of genuine 1-to-many splits or discard strong-coupling clarity for components that do concretize cleanly 1:1.";
            decision     = "Apply coupling per-component: strong coupling (':>') for clean 1:1 realizations (MovementSupervisorSoftware, PowerSupplyModule); loose coupling (allocation def LogicalToProduct) for all 1-to-many splits — LogicalControlUnit → {ControlMCU, CommandArbitrationSoftware, MovementControlSoftware, ConfigurationManagerSoftware, MemoryManagerSoftware}; LogicalMotorDrive → {ControlMCU, MotorDriveControlSoftware, MotorDriveRelayModule}; LogicalUserNotification → {ControlMCU, UserFeedbackSoftware, AudibleNotificationBuzzer}; LogicalLocalRequestInterface and LogicalRemoteRequestInterface → {RequestInterfaceCircuit, CommandArbitrationSoftware}. EnclosureAndConnectors has no Logical counterpart and is traced directly to physical constraints.";
            consequences = "Traceability queries must consult both ':>' specialization and the LogicalToProduct allocation def; any change to ADR-006 software-module boundaries requires revisiting allocation entries but does not affect the strong-coupled components (MovementSupervisorSoftware, PowerSupplyModule).";
            alternatives = "A. Re-split Logical Architecture to match Product-layer boundaries then strong-couple: rejected — Logical Architecture is a validated baseline; retrofitting it violates the principle that concretization happens downward. B. Loose-couple all Product components uniformly: rejected — discards strong-coupling clarity for components that concretize 1:1 (MovementSupervisorSoftware, PowerSupplyModule).";
            rationale    = "Applies the exact per-component coupling methodology ADR-004 established one layer up (strong coupling for clean 1:1 matches, loose coupling/allocation for splits), extending the same reviewed approach to the Logical→Product boundary.";
        }
    }
} // package ADR_007_ProductCoupling
