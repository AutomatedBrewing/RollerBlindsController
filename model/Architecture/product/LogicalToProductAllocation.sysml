package LogicalToProductAllocation {
    private import SystemArchitecture_Taxonomy::*;
    private import LogicalArchitecture::*;
    private import ProductComponents::*;
    private import ProductArchitecture::*;

    /* Logical-to-Product-Component allocation (SM-PRD-20 → SM-PRD-21),
     * realizing the LOOSE-coupling half of ADR_007_ProductCoupling: applied
     * wherever a Logical component is realized by more than one Product
     * component, or where a Product component (ControlMCU) hosts firmware
     * realizing more than one Logical component. Components covered instead
     * by STRONG coupling (':>') -- MovementSupervisorSoftware :>
     * LogicalMovementSupervisor, DiagnosticsSoftware :> LogicalDiagnostics --
     * do NOT need a redundant allocation entry for their own firmware
     * realization; they still receive an allocation entry to ControlMCU
     * (hardware host), since hosting is a many-to-one relationship that
     * specialization cannot express (see ADR_007_ProductCoupling
     * consequence #3).
     *
     * LogicalToProductComponent specializes the existing cross-architecture
     * allocation type SystemArchitecture_Taxonomy::ArchitectureAllocation,
     * exactly as FunctionalAllocation::FunctionToLogicalComponent already
     * does one layer up.
     *
     * Every allocation usage below follows the same anonymous-typed-usage
     * pattern already established in FunctionalAllocation.sysml: 'allocation
     * : LogicalToProductComponent allocate A to B;'. Qualified names
     * navigate through the composite classifier's nested namespace
     * (Package::Composite::feature), exactly as FunctionalAllocation.sysml
     * and Traceability.sysml already do.
     *
     * COMPLETENESS (Traceability Rule 1): all seven Logical components of
     * LogicalArchitecture::RollerShutterControllerLogicalComponents appear
     * below, and every Product component introduced in ProductComponents.sysml
     * is allocated from at least one Logical component EXCEPT: (a)
     * PowerSupplyModule, which is strong-coupled directly from
     * BaseArchitecture::PowerModule (no Logical counterpart exists, per
     * ADR-004) and therefore correctly has no Logical-to-Product allocation
     * entry; (b) EnclosureAndConnectors, a genuinely new mechanical
     * Product-layer element with no Logical or Base Architecture
     * counterpart, traced directly to constraints/requirements in
     * Traceability::Traceability instead (ADR-007). Neither is an orphan
     * component -- both are fully justified, just not via this allocation
     * mechanism (see ADR_007_ProductCoupling for the full rationale).
     */

    allocation def LogicalToProductComponent :> SystemArchitecture_Taxonomy::ArchitectureAllocation {
        doc
        /* Maps each Logical Component (SM-PRD-20) to the Product
         * Component(s) (SM-PRD-21) responsible for realizing it. */
    }

    // ── LogicalLocalRequestInterface: split allocation (2 targets) ──────────
    // Rationale: ADR-006 places raw signal conditioning in a shared hardware
    // circuit type while ControlCommand interpretation is realized by
    // CommandArbitrationSoftware (which already inspects both channels for
    // arbitration).
    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface
              to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;

    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface
              to ProductComponents::ControlMCU::commandArbitrationSoftware;

    // ── LogicalRemoteRequestInterface: split allocation (2 targets) ─────────
    // Rationale: identical to LogicalLocalRequestInterface above (REQ-I-02
    // equivalence), using the same shared RequestInterfaceCircuit type and
    // the same CommandArbitrationSoftware interpretation module.
    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalRemoteRequestInterface
              to ProductArchitecture::RollerShutterControllerProductComponents::remoteRequestInterface;

    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalRemoteRequestInterface
              to ProductComponents::ControlMCU::commandArbitrationSoftware;

    // ── LogicalControlUnit: split allocation (5 targets) ────────────────────
    // Rationale: ADR-006 software-modularizes LogicalControlUnit's four FE
    // groupings into four independently replaceable/testable firmware
    // components, all physically hosted by the single ControlMCU hardware
    // element (closes the FIRM PRODUCT-ARCHITECTURE FOLLOW-UP mandated in
    // LogicalArchitecture.sysml).
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

    // ── LogicalMovementSupervisor: hosting allocation (1 target) ────────────
    // Rationale: MovementSupervisorSoftware is STRONG-coupled (':>') to this
    // Logical component (see ProductComponents.sysml) -- no redundant
    // firmware-realization allocation entry is needed here. This entry
    // covers ONLY the many-to-one hardware-hosting relationship to
    // ControlMCU, which specialization cannot express.
    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor
              to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;

    // ── LogicalMotorDrive: split allocation (3 targets) ─────────────────────
    // Rationale: firmware (motor direction decision + relay coil control)
    // hosted on ControlMCU; mains-side switching realized by the dedicated
    // relay hardware module.
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
    // Rationale: firmware (feedback pattern generation) hosted on
    // ControlMCU; physical indication realized by the passive piezo buzzer hardware.
    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification
              to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;

    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification
              to ProductComponents::ControlMCU::userFeedbackSoftware;

    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification
              to ProductArchitecture::RollerShutterControllerProductComponents::userNotificationBuzzer;

    // ── LogicalDiagnostics: hosting allocation (1 target) ───────────────────
    // Rationale: DiagnosticsSoftware is STRONG-coupled (':>') to this Logical
    // component (see ProductComponents.sysml) -- no redundant
    // firmware-realization allocation entry is needed here. This entry
    // covers ONLY the many-to-one hardware-hosting relationship to
    // ControlMCU, mirroring LogicalMovementSupervisor above.
    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalDiagnostics
              to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;

    // ── Whole-composite allocation ──────────────────────────────────────────
    allocation : LogicalToProductComponent
        allocate LogicalArchitecture::rollerShutterControllerLogicalComponents
              to ProductArchitecture::rollerShutterControllerProductComponents;
} // package LogicalToProductAllocation
