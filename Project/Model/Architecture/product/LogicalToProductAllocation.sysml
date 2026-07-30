package LogicalToProductAllocation {
    private import SystemArchitecture_Taxonomy::*;
    private import LogicalArchitecture::*;
    private import ProductComponents::*;
    private import ProductArchitecture::*;

    /* Logical-to-Product-Component allocation (SM-PRD-20 → SM-PRD-21), realizing the
     * loose-coupling half of ADR_007_ProductCoupling. PowerSupplyModule and
     * EnclosureAndConnectors are correctly absent: PowerSupplyModule is strong-coupled from
     * BaseArchitecture::PowerModule; EnclosureAndConnectors has no Logical counterpart (ADR-007). */

    allocation def LogicalToProductComponent :> SystemArchitecture_Taxonomy::ArchitectureAllocation {
        doc
        /* Maps each Logical Component (SM-PRD-20) to the Product
         * Component(s) (SM-PRD-21) responsible for realizing it. */
    }

    // ── LogicalLocalRequestInterface: split allocation (2 targets) ──────────
    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface
              to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;

    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface
              to ProductComponents::ControlMCU::commandArbitrationSoftware;

    // ── LogicalRemoteRequestInterface: split allocation (2 targets) ─────────
    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalRemoteRequestInterface
              to ProductArchitecture::RollerShutterControllerProductComponents::remoteRequestInterface;

    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalRemoteRequestInterface
              to ProductComponents::ControlMCU::commandArbitrationSoftware;

    // ── LogicalControlUnit: split allocation (5 targets, ADR-006) ───────────
    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit
              to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;

    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit
              to ProductComponents::ControlMCU::commandArbitrationSoftware;

    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit
              to ProductComponents::ControlMCU::movementControlSoftware;

    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit
              to ProductComponents::ControlMCU::configurationManagerSoftware;

    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit
              to ProductComponents::ControlMCU::memoryManagerSoftware;

    // ── LogicalMovementSupervisor: hosting allocation only (strong-coupled via ':>') ──
    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor
              to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;

    // ── LogicalMotorDrive: split allocation (3 targets) ─────────────────────
    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive
              to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;

    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive
              to ProductComponents::ControlMCU::motorDriveControlSoftware;

    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive
              to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;

    // ── LogicalUserNotification: split allocation (3 targets) ──────────────
    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification
              to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;

    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification
              to ProductComponents::ControlMCU::userFeedbackSoftware;

    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification
              to ProductArchitecture::RollerShutterControllerProductComponents::userNotificationBuzzer;

    // ── Whole-composite allocation ──────────────────────────────────────────
    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::rollerShutterControllerLogicalComponents
              to ProductArchitecture::rollerShutterControllerProductComponents;
} // package LogicalToProductAllocation
