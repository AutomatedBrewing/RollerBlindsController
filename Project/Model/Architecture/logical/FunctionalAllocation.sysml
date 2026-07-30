package FunctionalAllocation {
    private import SystemArchitecture_Taxonomy::*;
    private import FunctionalArchitecture::*;
    private import LogicalArchitecture::*;

    /* Function-to-Logical-Component allocation (SM-PRD-18 → SM-PRD-20) using loose coupling
     * (allocation def, ADR_004_LogicalCoupling). All eight Functional Elements of
     * RollerShutterControllerFunctions are covered; requestAcquisitionFunctions is the
     * only FE split across multiple Logical components (translation vs. arbitration sub-behavior). */

    allocation def FunctionToLogicalComponent :> SystemArchitecture_Taxonomy::ArchitectureAllocation {
        doc
        /* Maps each Functional Element (action def host, SM-PRD-18) to the
         * Logical Component(s) (SM-PRD-20) responsible for realizing it. */
    }

    // ── requestAcquisitionFunctions: split allocation (3 targets) ───────────
    // Translation allocates to LogicalLocalRequestInterface / LogicalRemoteRequestInterface;
    // arbitration (requires visibility of both channels) allocates to LogicalControlUnit.
    allocation : FunctionToLogicalComponent
        allocate FunctionalArchitecture::RollerShutterControllerFunctions::requestAcquisitionFunctions
              to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;

    allocation : FunctionToLogicalComponent
        allocate FunctionalArchitecture::RollerShutterControllerFunctions::requestAcquisitionFunctions
              to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalRemoteRequestInterface;

    allocation : FunctionToLogicalComponent
        allocate FunctionalArchitecture::RollerShutterControllerFunctions::requestAcquisitionFunctions
              to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;

    // ── controlLogicFunctions ────────────────────────────────────────────────
    // Core control-unit responsibility; 1:1 with BaseArchitecture::ControlUnit (ADR-004).
    allocation : FunctionToLogicalComponent
        allocate FunctionalArchitecture::RollerShutterControllerFunctions::controlLogicFunctions
              to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;

    // ── movementSupervisionFunctions ─────────────────────────────────────────
    // Timer-based supervision (ADR-003); no Base Architecture counterpart (ADR-004).
    allocation : FunctionToLogicalComponent
        allocate FunctionalArchitecture::RollerShutterControllerFunctions::movementSupervisionFunctions
              to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;

    // ── shutterControlFunctions ──────────────────────────────────────────────
    // Motor energize/de-energize responsibility; 1:1 with BaseArchitecture::MotorDriver (ADR-004).
    allocation : FunctionToLogicalComponent
        allocate FunctionalArchitecture::RollerShutterControllerFunctions::shutterControlFunctions
              to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;

    // ── configurationControlFunctions ────────────────────────────────────────
    // Control-plane responsibility cohesive with controlLogicFunctions; allocated to LogicalControlUnit.
    allocation : FunctionToLogicalComponent
        allocate FunctionalArchitecture::RollerShutterControllerFunctions::configurationControlFunctions
              to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;

    // ── timeCountingFunctions ────────────────────────────────────────────────
    // Timing capability cohesive with movement supervision (ADR-003); allocated to LogicalMovementSupervisor.
    allocation : FunctionToLogicalComponent
        allocate FunctionalArchitecture::RollerShutterControllerFunctions::timeCountingFunctions
              to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;

    // ── memoryFunctions ───────────────────────────────────────────────────────
    // Control-plane data-management responsibility; allocated to LogicalControlUnit.
    allocation : FunctionToLogicalComponent
        allocate FunctionalArchitecture::RollerShutterControllerFunctions::memoryFunctions
              to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;

    // ── userNotificationFunctions ────────────────────────────────────────────
    // Decoupled from control logic for independent realization; no Base Architecture counterpart (ADR-004).
    allocation : FunctionToLogicalComponent
        allocate FunctionalArchitecture::RollerShutterControllerFunctions::userNotificationFunctions
              to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification;
} // package FunctionalAllocation
