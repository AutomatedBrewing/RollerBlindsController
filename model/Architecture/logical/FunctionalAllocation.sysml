package FunctionalAllocation {
    private import SystemArchitecture_Taxonomy::*;
    private import FunctionalArchitecture::*;
    private import LogicalArchitecture::*;

    /* Function-to-Logical-Component allocation (SM-PRD-18 → SM-PRD-20),
     * realizing the LOOSE coupling decided in ADR_004_LogicalCoupling: the
     * Functional Architecture and Logical Architecture are always loosely
     * coupled by an allocate relationship (SYSMOD Tool 11.7), never by
     * specialization.
     *
     * FunctionToLogicalComponent specializes the existing cross-architecture
     * allocation type SystemArchitecture_Taxonomy::ArchitectureAllocation
     * (already declared there as "Typed allocation between architecture
     * layers (e.g., Functional → Logical)"), rather than introducing an
     * unrelated new base type.
     *
     * Every allocation usage below follows the same anonymous-typed-usage
     * pattern already established for 'connection : Derivation connect A to
     * B;' throughout Traceability::Traceability, applied here to 'allocation'
     * instead of 'connection': 'allocation : FunctionToLogicalComponent
     * allocate A to B;'. Qualified names navigate through the composite
     * classifier's nested namespace (Package::Composite::feature), exactly as
     * Traceability.sysml does for FE derivation links.
     *
     * COMPLETENESS (Traceability Rule 1): all nine Functional Elements of
     * FunctionalArchitecture::RollerShutterControllerFunctions appear below.
     * requestAcquisitionFunctions is the only FE allocated to more than one
     * Logical component -- this is an intentional, documented split (see
     * inline rationale and ADR_004_LogicalCoupling), not an allocation
     * conflict: the physical-signal-to-ControlCommand TRANSLATION
     * sub-behavior is channel-specific (local vs. remote) and allocates to
     * the matching interface component, while the first-wins
     * ARBITRATION/merge sub-behavior requires simultaneous visibility of both
     * channels and can only be allocated to LogicalControlUnit.
     */

    allocation def FunctionToLogicalComponent :> SystemArchitecture_Taxonomy::ArchitectureAllocation {
        doc
        /* Maps each Functional Element (action def host, SM-PRD-18) to the
         * Logical Component(s) (SM-PRD-20) responsible for realizing it. */
    }

    // ── requestAcquisitionFunctions: split allocation (3 targets) ───────────
    // Rationale: Base Architecture already separates local/remote reception
    // into independently replaceable parts (WallSwitchInterface,
    // RemoteInterface); the translation sub-behavior naturally follows that
    // split, while arbitration (fork+merge, first-wins) requires a single
    // component with visibility of both channels.
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
    // Rationale: command validation/conflict-detection and MovementRequest
    // production are core control-unit responsibilities; 1:1 with the Base
    // Architecture ControlUnit part (strong-coupled, ADR-004).
    allocation : FunctionToLogicalComponent
        allocate FunctionalArchitecture::RollerShutterControllerFunctions::controlLogicFunctions
              to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;

    // ── movementSupervisionFunctions ─────────────────────────────────────────
    // Rationale: timer-based stop-condition supervision (ADR-003) is a
    // cohesive, cross-cutting capability distinct from command processing and
    // motor switching; no Base Architecture precedent (ADR-004).
    allocation : FunctionToLogicalComponent
        allocate FunctionalArchitecture::RollerShutterControllerFunctions::movementSupervisionFunctions
              to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;

    // ── shutterControlFunctions ──────────────────────────────────────────────
    // Rationale: motor energize/de-energize behavior is the defining
    // responsibility of the motor-drive component; 1:1 with the Base
    // Architecture MotorDriver part (strong-coupled, ADR-004).
    allocation : FunctionToLogicalComponent
        allocate FunctionalArchitecture::RollerShutterControllerFunctions::shutterControlFunctions
              to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;

    // ── configurationControlFunctions ────────────────────────────────────────
    // Rationale: configuration-mode state management is a control-plane
    // responsibility, cohesive with command processing; allocated to the
    // same component as controlLogicFunctions to maximize cohesion and avoid
    // an artificial state-management split.
    allocation : FunctionToLogicalComponent
        allocate FunctionalArchitecture::RollerShutterControllerFunctions::configurationControlFunctions
              to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;

    // ── timeCountingFunctions ────────────────────────────────────────────────
    // Rationale: elapsed-time measurement from the ShutterState event stream
    // is a timing capability, cohesive with movement supervision (both are
    // timer-based, ADR-003-driven capabilities); NOT allocated to
    // LogicalControlUnit to avoid overloading the control component with
    // unrelated timing-hardware responsibilities (minimizes coupling).
    allocation : FunctionToLogicalComponent
        allocate FunctionalArchitecture::RollerShutterControllerFunctions::timeCountingFunctions
              to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;

    // ── memoryFunctions ───────────────────────────────────────────────────────
    // Rationale: non-volatile persistence of the timing profile is a
    // control-plane data-management responsibility; allocated to
    // LogicalControlUnit (BaseArchitecture::ControlUnit "determines shutter
    // movement behaviour", which includes the configuration data it depends
    // on) rather than introducing a dedicated memory component with no
    // functional or Base Architecture justification for standing alone.
    allocation : FunctionToLogicalComponent
        allocate FunctionalArchitecture::RollerShutterControllerFunctions::memoryFunctions
              to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;

    // ── userNotificationFunctions ────────────────────────────────────────────
    // Rationale: FunctionalArchitecture.sysml explicitly documents this FE as
    // "decoupled from control logic to allow independent Logical Architecture
    // realization (e.g., LED, buzzer, or display indicator)" -- allocated to
    // its own component per that explicit guidance; no Base Architecture
    // precedent (ADR-004).
    allocation : FunctionToLogicalComponent
        allocate FunctionalArchitecture::RollerShutterControllerFunctions::userNotificationFunctions
              to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification;

    // ── diagnosticsFunctions ─────────────────────────────────────────────────
    // Rationale: fault detection/field-repair support is a distinct concern
    // from normal operation; allocated to its own component to keep the
    // (currently underspecified) diagnostic capability isolated and to
    // provide an allocation anchor for future elaboration (mirrors the FA
    // layer's own isolation of this FE). No Base Architecture precedent
    // (ADR-004).
    allocation : FunctionToLogicalComponent
        allocate FunctionalArchitecture::RollerShutterControllerFunctions::diagnosticsFunctions
              to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalDiagnostics;
} // package FunctionalAllocation
