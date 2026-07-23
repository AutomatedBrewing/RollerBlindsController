package Traceability
{
    private import L0_Requirements::*;
    private import L0_Constraints::*;
    private import DerivationConnections::*;

    private import SystemIdea::*;
    private import SystemObjectives::*;
    private import Stakeholders::*;
    private import SystemContext::*;
    private import SystemUseCases::*;
    private import UseCaseActivities::*;
    private import FunctionalArchitecture::*;
    private import Risks::*;
    private import BaseArchitecture::*;
    private import SystemProcesses::*;
    private import LogicalArchitecture::*;
    private import ProductComponents::*;
    private import ProductArchitecture::*;
    private import Scenarios::*;
    /* Scenario Repair Plan (SM-PRD-22, SR-1/C1): required to reach the
     * package-level 'verification' usages (SystemTestCases.sysml) as
     * connection endpoints for the new Scenario → Test Case block below. */
    private import SystemTestCases::*;
    /* State Model (SM-PRD-23): required to reach the package-level part
     * usages (SystemStates.sysml) as connection endpoints for the new
     * State Model traceability block below. */
    private import SystemStates::*;

    /* System Objectives are derived from System Idea. */
    connection : Derivation connect SystemIdea::systemIdea to SystemObjectives::affordability;
    connection : Derivation connect SystemIdea::systemIdea to SystemObjectives::easeOfUse;
    connection : Derivation connect SystemIdea::systemIdea to SystemObjectives::localControl;
    connection : Derivation connect SystemIdea::systemIdea to SystemObjectives::remoteControl;
    connection : Derivation connect SystemIdea::systemIdea to SystemObjectives::rollerShutterCompatibility;
    connection : Derivation connect SystemIdea::systemIdea to SystemObjectives::reliability;
    connection : Derivation connect SystemIdea::systemIdea to SystemObjectives::safety;
    /* shutterMovementControl (system model review corrective pass, closes
     * Major finding M1): split out of easeOfUse to give the core movement
     * capability (open/close/stop/manual positioning) its own directly
     * SystemIdea-derived objective, distinct from usability/configuration
     * ergonomics. See SystemObjectives.sysml rationale on both objectives. */
    connection : Derivation connect SystemIdea::systemIdea to SystemObjectives::shutterMovementControl;

    /* Requirements are derived from System Objectives. */
    /* Functional requirements */
    connection : Derivation connect SystemIdea::systemIdea to L0_Requirements::Functional::controlRollerShutter;
    connection : Derivation connect SystemObjectives::localControl to L0_Requirements::Functional::localControl;
    connection : Derivation connect SystemObjectives::remoteControl to L0_Requirements::Functional::remoteControl;
    /* fullShutterMovement/manualPositioning/stopShutterMovement now source
     * from shutterMovementControl, not easeOfUse (system model review
     * corrective pass, closes Major finding M1 -- see Requirements.sysml
     * @RequirementMeta.source updates on REQ-F-04/05/06). */
    connection : Derivation connect SystemObjectives::shutterMovementControl to L0_Requirements::Functional::fullShutterMovement;
    connection : Derivation connect SystemObjectives::shutterMovementControl to L0_Requirements::Functional::manualPositioning;
    connection : Derivation connect SystemObjectives::shutterMovementControl to L0_Requirements::Functional::stopShutterMovement;
    connection : Derivation connect SystemObjectives::rollerShutterCompatibility to L0_Requirements::Functional::configurableTimingProfile;
    connection : Derivation connect SystemObjectives::easeOfUse to L0_Requirements::Functional::configurationMode;

    /* Interface requirements */
    connection : Derivation connect SystemObjectives::localControl to L0_Requirements::Interface::wallSwitchWiringCompatibility;
    connection : Derivation connect SystemObjectives::remoteControl to L0_Requirements::Interface::remoteControlWiringCompatibility;

    /* Quality requirements */
    connection : Derivation connect SystemObjectives::easeOfUse to L0_Requirements::Quality::easeOfInstallation;
    connection : Derivation connect SystemObjectives::reliability to L0_Requirements::Quality::availability;
    connection : Derivation connect SystemObjectives::reliability to L0_Requirements::Quality::reliability;
    /* REQ-Q-04/REQ-Q-05 (system model review corrective pass, closes Major
     * finding M3): MaintenanceTechnician's Diagnosability/FieldReplaceability
     * concerns previously had no L0_Requirements usage at all. Sourced from
     * reliability, mirroring the existing objective-mediated pattern used for
     * diagnosticsFunctions (see reliability → diagnosticsFunctions link
     * below) -- field diagnosis/repair capability is treated as part of the
     * system's overall reliability/serviceability posture. */
    connection : Derivation connect SystemObjectives::reliability to L0_Requirements::Quality::diagnosability;
    connection : Derivation connect SystemObjectives::reliability to L0_Requirements::Quality::fieldReplaceability;

    /* Safety requirement. The safety system objective (added to close the gap
     * documented in model_issues.md) is now the primary source; the proxy link
     * via reliability is retained for backward-compatibility until all
     * downstream tools are updated. */
    connection : Derivation connect SystemObjectives::safety     to L0_Requirements::Safety::safety;
    connection : Derivation connect SystemObjectives::reliability to L0_Requirements::Safety::safety;
    /* REQ-S-02 (system model review corrective pass, closes Major finding M2):
     * split out of REQ-S-01 to independently trace the user-facing conflict-
     * indication behavior. Sourced from the same safety objective. */
    connection : Derivation connect SystemObjectives::safety to L0_Requirements::Safety::conflictIndication;


    /* Constraints */
    connection : Derivation connect SystemObjectives::affordability to L0_Constraints::Business::costEffective;
    connection : Derivation connect SystemObjectives::affordability to L0_Constraints::Physical::compactDimensions;
    connection : Derivation connect SystemObjectives::reliability   to L0_Constraints::Environmental::operatingConditions;
    connection : Derivation connect L0_Requirements::Functional::controlRollerShutter to L0_Constraints::Electrical::supplyVoltage;
    connection : Derivation connect L0_Requirements::Functional::controlRollerShutter to L0_Constraints::Electrical::switchingLoad;
    connection : Derivation connect L0_Requirements::Safety::safety to L0_Constraints::Electrical::motorIsolation;
    connection : Derivation connect L0_Requirements::Safety::safety to L0_Constraints::Electrical::inputIsolation;
    connection : Derivation connect SystemObjectives::rollerShutterCompatibility to L0_Constraints::Architectural::noPositionFeedback;
    connection : Derivation connect SystemObjectives::rollerShutterCompatibility to L0_Constraints::Architectural::timeBasedOperation;


    /* Risks are derived from System Idea / System Objectives (threats to the
     * objectives and design choices they embody). */
    connection : Derivation connect SystemIdea::systemIdea to Risks::TechnicalRisks::Risk_PositioningDrift;
    connection : Derivation connect SystemObjectives::reliability to Risks::TechnicalRisks::Risk_MotorRelayWearOut;
    connection : Derivation connect SystemObjectives::rollerShutterCompatibility to Risks::TechnicalRisks::Risk_ShutterMotorTypeIncompatibility;
    connection : Derivation connect SystemObjectives::easeOfUse to Risks::TechnicalRisks::Risk_MisconfigurationDuringInstall;
    connection : Derivation connect SystemObjectives::localControl to Risks::IntegrationRisks::Risk_WallSwitchWiringIncompatibility;
    connection : Derivation connect SystemObjectives::affordability to Risks::BusinessRisks::Risk_CostTargetExceedance;
    /* No formal "safety" system objective existed previously; now resolved (see
     * model_issues.md and ADR-002). The safety risk is still traced to both the
     * new safety objective and to the safety requirement, for full coverage. */
    connection : Derivation connect SystemObjectives::safety     to Risks::SafetyRisks::Risk_InsufficientGalvanicIsolation;
    connection : Derivation connect SystemObjectives::reliability to Risks::SafetyRisks::Risk_InsufficientGalvanicIsolation;
    connection : Derivation connect L0_Requirements::Safety::safety to Risks::SafetyRisks::Risk_InsufficientGalvanicIsolation;

    /* Risks are mitigated by Constraints / Requirements (downstream). */
    connection : Derivation connect Risks::SafetyRisks::Risk_InsufficientGalvanicIsolation to L0_Constraints::Electrical::motorIsolation;
    connection : Derivation connect Risks::SafetyRisks::Risk_InsufficientGalvanicIsolation to L0_Constraints::Electrical::inputIsolation;
    connection : Derivation connect Risks::BusinessRisks::Risk_CostTargetExceedance to L0_Constraints::Business::costEffective;
    connection : Derivation connect Risks::TechnicalRisks::Risk_ShutterMotorTypeIncompatibility to L0_Constraints::Architectural::timeBasedOperation;
    connection : Derivation connect Risks::TechnicalRisks::Risk_ShutterMotorTypeIncompatibility to L0_Requirements::Functional::configurableTimingProfile;
    connection : Derivation connect Risks::TechnicalRisks::Risk_MisconfigurationDuringInstall to L0_Requirements::Quality::easeOfInstallation;
    connection : Derivation connect Risks::TechnicalRisks::Risk_MisconfigurationDuringInstall to L0_Requirements::Functional::configurationMode;
    connection : Derivation connect Risks::TechnicalRisks::Risk_MotorRelayWearOut to L0_Requirements::Quality::reliability;
    connection : Derivation connect Risks::IntegrationRisks::Risk_WallSwitchWiringIncompatibility to L0_Requirements::Interface::wallSwitchWiringCompatibility;

    /* Cross-risk consequence links: RISK-SC-01 arises directly from the effort to
     * mitigate RISK-S-01 and RISK-B-01 (sourcing isolation components that are
     * simultaneously safe and affordable). */
    connection : Derivation connect Risks::SafetyRisks::Risk_InsufficientGalvanicIsolation to Risks::ScheduleRisks::Risk_IsolationComponentSourcingDelay;
    connection : Derivation connect Risks::BusinessRisks::Risk_CostTargetExceedance to Risks::ScheduleRisks::Risk_IsolationComponentSourcingDelay;

    /* CRIT-5 fix (SMRR corrective pass): RISK-SC-01
     * (Risk_IsolationComponentSourcingDelay) previously had zero OUTGOING
     * trace -- a documented mitigation ("arrange a hardware-in-the-loop or
     * bench-test fallback... qualify at least one second-source supplier in
     * parallel", Risks.sysml @RiskMeta.mitigation) with no modeled
     * constraint/architecture/verification path demonstrating it. Closed
     * below by reusing EXISTING model constructs only (no new business
     * process invented):
     * 1. L0_Constraints::Electrical::inputIsolation is the specification any
     *    second-source isolation component must continue to satisfy --
     *    mitigating this risk means qualifying alternate suppliers AGAINST
     *    this already-modeled constraint, not inventing a new one.
     * 2. ProductArchitecture's localRequestInterface/remoteRequestInterface
     *    are two INSTANCES of the same RequestInterfaceCircuit type
     *    (ADR-007's strong-coupling choice) -- this existing "single type,
     *    dual instantiation" sourcing strategy is precisely what makes a
     *    second-source substitution low-risk to integrate: qualifying one
     *    replacement part qualifies both instances simultaneously, and
     *    ADR-001's cost-driven "simplest viable hardware" strategy already
     *    favors commodity, multi-supplier-available component classes for
     *    exactly this reason.
     * 3. SystemTestCases::tc_S_003_accessibleVoltage_SELV (TC_S_003) is the
     *    existing verification hook that any second-sourced isolation
     *    component must pass before being accepted -- the fallback/
     *    qualification path the mitigation text describes is demonstrated
     *    through this pre-existing test case, requiring no new verification
     *    artifact. */
    connection : Derivation connect Risks::ScheduleRisks::Risk_IsolationComponentSourcingDelay to L0_Constraints::Electrical::inputIsolation;
    connection : Derivation connect Risks::ScheduleRisks::Risk_IsolationComponentSourcingDelay to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Derivation connect Risks::ScheduleRisks::Risk_IsolationComponentSourcingDelay to ProductArchitecture::RollerShutterControllerProductComponents::remoteRequestInterface;
    connection : Derivation connect Risks::ScheduleRisks::Risk_IsolationComponentSourcingDelay to SystemTestCases::tc_S_003_accessibleVoltage_SELV;

    /* Use case activities are derived from Use Cases. Variant use cases
     * (UC_01a..d) now trace 1:1 to their matching UseCaseActivities
     * specialization, rather than flatly from the generic controlRollerShutter
     * use case (Use Cases formal review fix, see model_issues.md).
     * UC_01e, UC_04, UC_05 links added to close traceability review gaps. */
    connection : Derivation connect SystemUseCases::openShutterAutomatically to UseCaseActivities::openShutterAutomatically;
    connection : Derivation connect SystemUseCases::closeShutterAutomatically to UseCaseActivities::closeShutterAutomatically;
    connection : Derivation connect SystemUseCases::openShutterManually to UseCaseActivities::openShutterManually;
    connection : Derivation connect SystemUseCases::closeShutterManually to UseCaseActivities::closeShutterManually;
    connection : Derivation connect SystemUseCases::handleConflictingMovementCommands to UseCaseActivities::handleConflictingMovementCommands;
    connection : Derivation connect SystemUseCases::installController to UseCaseActivities::installController;
    connection : Derivation connect SystemUseCases::configureController to UseCaseActivities::configureController;
    connection : Derivation connect SystemUseCases::diagnoseAndRepairController to UseCaseActivities::diagnoseAndRepairController;
    connection : Derivation connect SystemUseCases::disposeController to UseCaseActivities::disposeController;
    /* MAJ-6 fix (SMRR corrective pass): UseCaseActivities::controlRollerShutter
     * (the composite UCA, allocated directly to the top-level FA composite
     * below) had no incoming derivation from its generic parent use case --
     * an orphan at its first hop, even though every one of its concrete
     * variants (UC_01a..e) already traces individually above. Added for
     * consistency with the variant-level pattern this block already
     * establishes. */
    connection : Derivation connect SystemUseCases::controlRollerShutter to UseCaseActivities::controlRollerShutter;

    /* Functional architecture is derived from UseCaseActivities. */
    connection : Derivation connect UseCaseActivities::receiveControlRequest to FunctionalArchitecture::RollerShutterControllerFunctions::requestAcquisitionFunctions;
    connection : Derivation connect UseCaseActivities::monitorUserInterruption to FunctionalArchitecture::RollerShutterControllerFunctions::movementSupervisionFunctions;
    connection : Derivation connect UseCaseActivities::determineMovementRequest to FunctionalArchitecture::RollerShutterControllerFunctions::controlLogicFunctions;
    connection : Derivation connect UseCaseActivities::controlRollerShutter to FunctionalArchitecture::rollerShutterControllerFunctions;
    connection : Derivation connect UseCaseActivities::startShutterMovement to FunctionalArchitecture::RollerShutterControllerFunctions::shutterControlFunctions;
    connection : Derivation connect UseCaseActivities::stopShutterMovement to FunctionalArchitecture::RollerShutterControllerFunctions::shutterControlFunctions;
    connection : Derivation connect UseCaseActivities::countActionTime to FunctionalArchitecture::RollerShutterControllerFunctions::timeCountingFunctions;
    connection : Derivation connect UseCaseActivities::saveCountedTime to FunctionalArchitecture::RollerShutterControllerFunctions::memoryFunctions;
    connection : Derivation connect UseCaseActivities::notifyUserAboutActivationOfConfigurationMode to FunctionalArchitecture::RollerShutterControllerFunctions::userNotificationFunctions;
    connection : Derivation connect UseCaseActivities::notifyUserAboutDeactivationOfConfigurationMode to FunctionalArchitecture::RollerShutterControllerFunctions::userNotificationFunctions;
    connection : Derivation connect UseCaseActivities::monitorStopCondition to FunctionalArchitecture::RollerShutterControllerFunctions::movementSupervisionFunctions;
    connection : Derivation connect UseCaseActivities::activateConfigurationMode to FunctionalArchitecture::RollerShutterControllerFunctions::configurationControlFunctions;
    connection : Derivation connect UseCaseActivities::exitConfigurationMode to FunctionalArchitecture::RollerShutterControllerFunctions::configurationControlFunctions;
    connection : Derivation connect UseCaseActivities::moveShutterToClosePosition to FunctionalArchitecture::RollerShutterControllerFunctions::shutterControlFunctions;
    connection : Derivation connect UseCaseActivities::loadTimingProfile to FunctionalArchitecture::RollerShutterControllerFunctions::memoryFunctions;
    connection : Derivation connect UseCaseActivities::diagnoseAndRepairController to FunctionalArchitecture::RollerShutterControllerFunctions::diagnosticsFunctions;
    /* notifyUserAboutConflict (system model review corrective pass, closes
     * Major finding M2): the new UC_01e conflict-notification sub-action is
     * allocated to userNotificationFunctions, mirroring the pattern used for
     * the two configuration-mode notification actions above. */
    connection : Derivation connect UseCaseActivities::notifyUserAboutConflict to FunctionalArchitecture::RollerShutterControllerFunctions::userNotificationFunctions;

    /* MAJ-5 fix (SMRR corrective pass): five UCA sub-actions were Scenario
     * targets (dead-ending before Functional Architecture) with no outgoing
     * UCA -> FE Derivation link. Closed below by reusing EXISTING Functional
     * Elements only (no new FE created, per instruction): reportInstallationFault
     * and rejectConfigurationModeReentry are both user-facing fault/rejection
     * NOTIFICATIONS, mirroring notifyUserAboutConflict/notifyUserAbout*
     * ConfigurationMode immediately above -> userNotificationFunctions.
     * detectFault/isolateFault/repairOrReplaceUnit are the three UC_04
     * diagnostic sub-steps -> diagnosticsFunctions, mirroring
     * diagnoseAndRepairController's own existing link above. */
    connection : Derivation connect UseCaseActivities::reportInstallationFault to FunctionalArchitecture::RollerShutterControllerFunctions::userNotificationFunctions;
    connection : Derivation connect UseCaseActivities::rejectConfigurationModeReentry to FunctionalArchitecture::RollerShutterControllerFunctions::userNotificationFunctions;
    connection : Derivation connect UseCaseActivities::detectFault to FunctionalArchitecture::RollerShutterControllerFunctions::diagnosticsFunctions;
    connection : Derivation connect UseCaseActivities::isolateFault to FunctionalArchitecture::RollerShutterControllerFunctions::diagnosticsFunctions;
    connection : Derivation connect UseCaseActivities::repairOrReplaceUnit to FunctionalArchitecture::RollerShutterControllerFunctions::diagnosticsFunctions;

    /* MAJ-8 fix (SMRR corrective pass): the new out-of-range calibration
     * guard sub-actions are allocated to the SAME functional elements as
     * the measurement/persistence actions they guard -- checkTravelTimeInRange
     * validates a CountActionTime measurement before SaveCountedTime, so it
     * is allocated to timeCountingFunctions (mirroring countActionTime's own
     * link above); rejectOutOfRangeCalibration is a user-facing rejection
     * notification, mirroring rejectConfigurationModeReentry's link above ->
     * userNotificationFunctions. No new Functional Element created. */
    connection : Derivation connect UseCaseActivities::checkTravelTimeInRange to FunctionalArchitecture::RollerShutterControllerFunctions::timeCountingFunctions;
    connection : Derivation connect UseCaseActivities::rejectOutOfRangeCalibration to FunctionalArchitecture::RollerShutterControllerFunctions::userNotificationFunctions;

    /* Logical architecture is derived from (allocated from) the Functional
     * Architecture (SM-PRD-18 → SM-PRD-20). The authoritative Function-to-
     * Logical-Component mapping is the 'allocation def FunctionToLogicalComponent'
     * in LogicalArchitecture::FunctionalAllocation.sysml (loose coupling per
     * ADR-004); the 'connection : Derivation' links below restate the same
     * mapping at the coarser architectural-layer traceability level, matching
     * the UCA→FE block above and the top-level composite-to-composite link
     * pattern used throughout this file. requestAcquisitionFunctions derives
     * to two Logical components (documented split, ADR-004 / FunctionalAllocation.sysml). */
    connection : Derivation connect FunctionalArchitecture::RollerShutterControllerFunctions::requestAcquisitionFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Derivation connect FunctionalArchitecture::RollerShutterControllerFunctions::requestAcquisitionFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalRemoteRequestInterface;
    connection : Derivation connect FunctionalArchitecture::RollerShutterControllerFunctions::requestAcquisitionFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Derivation connect FunctionalArchitecture::RollerShutterControllerFunctions::controlLogicFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Derivation connect FunctionalArchitecture::RollerShutterControllerFunctions::movementSupervisionFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Derivation connect FunctionalArchitecture::RollerShutterControllerFunctions::shutterControlFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Derivation connect FunctionalArchitecture::RollerShutterControllerFunctions::configurationControlFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Derivation connect FunctionalArchitecture::RollerShutterControllerFunctions::timeCountingFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Derivation connect FunctionalArchitecture::RollerShutterControllerFunctions::memoryFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Derivation connect FunctionalArchitecture::RollerShutterControllerFunctions::userNotificationFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification;
    connection : Derivation connect FunctionalArchitecture::RollerShutterControllerFunctions::diagnosticsFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalDiagnostics;
    connection : Derivation connect FunctionalArchitecture::rollerShutterControllerFunctions to LogicalArchitecture::rollerShutterControllerLogicalComponents;

    /* REQ-S-01 traces to its behavioral use-case counterpart (conflict suppression). */
    connection : Derivation connect L0_Requirements::Safety::safety to SystemUseCases::handleConflictingMovementCommands;
    /* REQ-S-02 traces to the same use case (system model review corrective
     * pass, closes Major finding M2): the conflict-indication behavior is a
     * direct sub-step of UC_01e's activity (notifyUserAboutConflict). */
    connection : Derivation connect L0_Requirements::Safety::conflictIndication to SystemUseCases::handleConflictingMovementCommands;
    /* REQ-Q-04/REQ-Q-05 trace to UC_04 (system model review corrective pass,
     * closes Major finding M3): previously UC_04 traced only to reliability
     * (REQ-Q-03), which does not itself address field diagnosability or
     * field-replaceability. */
    connection : Derivation connect L0_Requirements::Quality::diagnosability to SystemUseCases::diagnoseAndRepairController;
    connection : Derivation connect L0_Requirements::Quality::fieldReplaceability to SystemUseCases::diagnoseAndRepairController;
    /* MAJ-3 fix (SMRR corrective pass): REQ-Q-02 (availability) was
     * previously orphaned at the Use Case layer -- verified by TC_Q_002 and
     * traced to Logical/Product components, but with no explicit UC-layer
     * Derivation link. Availability is measured as "the percentage of time
     * the controller successfully executes a valid control request"
     * (REQ-Q-02's own doc) -- i.e. it is a quality attribute OF
     * controlRollerShutter's existing behavior, not a new use case. Reusing
     * that existing behavior (no new Use Case invented, per instruction). */
    connection : Derivation connect L0_Requirements::Quality::availability to SystemUseCases::controlRollerShutter;

    /* Design-to-requirement satisfaction. BaseArchitecture::shutterController is a
     * package-level part usage (feature) typed by ShutterController — 'satisfy by'
     * requires a feature, not a classifier definition. */
    satisfy L0_Requirements::Functional::controlRollerShutter by BaseArchitecture::shutterController;
    satisfy L0_Requirements::Functional::localControl by BaseArchitecture::shutterController;
    satisfy L0_Requirements::Functional::remoteControl by BaseArchitecture::shutterController;
    satisfy L0_Requirements::Functional::fullShutterMovement by BaseArchitecture::shutterController;
    satisfy L0_Requirements::Functional::manualPositioning by BaseArchitecture::shutterController;
    satisfy L0_Requirements::Functional::stopShutterMovement by BaseArchitecture::shutterController;
    satisfy L0_Requirements::Functional::configurableTimingProfile by BaseArchitecture::shutterController;
    satisfy L0_Requirements::Functional::configurationMode by BaseArchitecture::shutterController;
    satisfy L0_Requirements::Interface::wallSwitchWiringCompatibility by BaseArchitecture::shutterController;
    satisfy L0_Requirements::Interface::remoteControlWiringCompatibility by BaseArchitecture::shutterController;
    satisfy L0_Requirements::Quality::easeOfInstallation by BaseArchitecture::shutterController;
    satisfy L0_Requirements::Quality::availability by BaseArchitecture::shutterController;
    satisfy L0_Requirements::Quality::reliability by BaseArchitecture::shutterController;
    satisfy L0_Requirements::Safety::safety by BaseArchitecture::shutterController;
    satisfy L0_Requirements::Environmental::regulatedDisposal by BaseArchitecture::shutterController;
    /* Added (system model review corrective pass) for the three requirements
     * introduced/split this pass: REQ-S-02 (M2), REQ-Q-04/REQ-Q-05 (M3). */
    satisfy L0_Requirements::Safety::conflictIndication by BaseArchitecture::shutterController;
    satisfy L0_Requirements::Quality::diagnosability by BaseArchitecture::shutterController;
    satisfy L0_Requirements::Quality::fieldReplaceability by BaseArchitecture::shutterController;

    /* Design-to-requirement traceability — Logical Architecture (SM-PRD-20).
     * Closes formal-review finding C2 (Logical Architecture review): previously
     * only BaseArchitecture::shutterController satisfied requirements, leaving
     * Requirements → Logical Elements traceability (KnowledgeSource/integration/
     * crossmapping/logical-architecture.md §4 Traceability Rule 3 / §1 dependency
     * on SM-PRD-10) as an unformalized, multi-hop inference. Each requirement
     * below traces to the specific Logical component(s) most directly
     * responsible for realizing it, per LogicalArchitecture::FunctionalAllocation.
     *
     * NOTE: 'satisfy ... by ...' is NOT used here (unlike the BaseArchitecture
     * block above) because every L0_Requirements usage re-declares its
     * 'subject' as BaseArchitecture::ShutterController (see Requirements.sysml)
     * — 'satisfy by' requires the target's type to conform to that subject
     * type, and no Logical component conforms to ShutterController (Logical →
     * Base is a separate, non-inheritance coupling per ADR_004_LogicalCoupling).
     * 'connection : Derivation' (already used above for Requirements →
     * UseCases/SystemContext links) has no such conformance constraint and is
     * the correct relationship for this kind of cross-layer, non-conforming
     * traceability link. */
    connection : Derivation connect L0_Requirements::Functional::controlRollerShutter to LogicalArchitecture::rollerShutterControllerLogicalComponents;
    connection : Derivation connect L0_Requirements::Functional::localControl to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Derivation connect L0_Requirements::Functional::remoteControl to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalRemoteRequestInterface;
    connection : Derivation connect L0_Requirements::Functional::fullShutterMovement to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Derivation connect L0_Requirements::Functional::fullShutterMovement to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Derivation connect L0_Requirements::Functional::manualPositioning to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Derivation connect L0_Requirements::Functional::manualPositioning to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Derivation connect L0_Requirements::Functional::stopShutterMovement to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Derivation connect L0_Requirements::Functional::stopShutterMovement to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Derivation connect L0_Requirements::Functional::configurableTimingProfile to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Derivation connect L0_Requirements::Functional::configurableTimingProfile to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Derivation connect L0_Requirements::Functional::configurationMode to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Derivation connect L0_Requirements::Functional::configurationMode to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification;
    connection : Derivation connect L0_Requirements::Interface::wallSwitchWiringCompatibility to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Derivation connect L0_Requirements::Interface::remoteControlWiringCompatibility to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalRemoteRequestInterface;
    /* REQ-S-01's conflict-suppression clause (UC_01e) is realized by
     * LogicalControlUnit's arbitration/validation sub-behavior; the electrical
     * isolation clause remains a Base/Physical Architecture concern with no
     * Logical-layer structural counterpart (ADR-004: PowerModule excluded).
     * REVIEWED (formal Logical Architecture review, this pass): confirmed as
     * an intentional, accepted gap rather than a missing allocation -- no
     * Functional Element performs galvanic-isolation/SELV-limiting behavior
     * (it is a physical circuit property of the PowerModule/enclosure, not a
     * logical function), so introducing a placeholder Logical element for it
     * would misrepresent a physical constraint as a logical capability. The
     * isolation clause is verified directly against BaseArchitecture::
     * shutterController (see Verification::Constraints::VerifySupplyVoltageRange/
     * VerifyMaximumSwitchingLoad) and remains correctly out of scope for the
     * Logical Architecture. */
    connection : Derivation connect L0_Requirements::Safety::safety to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    /* REQ-S-02 → Logical Elements (system model review corrective pass,
     * closes Major finding M2): logicalControlUnit detects/raises the
     * conflict (conflictOut port); logicalUserNotification delivers the
     * user-facing indication (conflictEventIn port). Both are linked,
     * mirroring the multi-component pattern already used above for
     * requirements that cross-cut more than one Logical component. */
    connection : Derivation connect L0_Requirements::Safety::conflictIndication to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Derivation connect L0_Requirements::Safety::conflictIndication to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification;

    /* REQ-Q-02/REQ-Q-03 → Logical Elements (formal Logical Architecture review
     * finding, this pass): previously availability/reliability had zero
     * Logical-layer trace, leaving the components most responsible for
     * system-wide uptime and wear-driven failure (logicalControlUnit: highest
     * functional concentration and the single busiest interaction point;
     * logicalMotorDrive: the switching component subject to RISK-T-03 motor
     * relay wear-out) with no explicit accountability link. Both requirements
     * are quality attributes of the whole composite behavior rather than a
     * single FE's output, so both target components are linked, mirroring the
     * fullShutterMovement/manualPositioning/stopShutterMovement pattern above
     * (multiple Logical components per requirement where the requirement
     * cross-cuts more than one). */
    connection : Derivation connect L0_Requirements::Quality::availability to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Derivation connect L0_Requirements::Quality::availability to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Derivation connect L0_Requirements::Quality::reliability to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Derivation connect L0_Requirements::Quality::reliability to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;

    /* REQ-Q-03 (reliability) → diagnosticsFunctions/logicalDiagnostics (formal
     * Logical Architecture review finding, this pass): REQ-Q-03's
     * @RequirementMeta.rationale already informally cites RISK-T-03 (motor
     * relay wear-out) and diagnostic/repair concerns, but no formal Derivation
     * link existed connecting reliability to the diagnostics capability at
     * either the Functional or Logical layer -- an otherwise-intact
     * traceability chain (UCA diagnoseAndRepairController → FA
     * diagnosticsFunctions → LA logicalDiagnostics, see lines below) had no
     * Requirements-layer justification anchor. Both layers are linked here for
     * completeness. */
    connection : Derivation connect L0_Requirements::Quality::reliability to FunctionalArchitecture::RollerShutterControllerFunctions::diagnosticsFunctions;
    connection : Derivation connect L0_Requirements::Quality::reliability to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalDiagnostics;
    /* REQ-Q-04/REQ-Q-05 → diagnosticsFunctions/logicalDiagnostics (system
     * model review corrective pass, closes Major finding M3): mirrors the
     * reliability link immediately above -- diagnosability and field-
     * replaceability are realized by the same diagnostics capability. */
    connection : Derivation connect L0_Requirements::Quality::diagnosability to FunctionalArchitecture::RollerShutterControllerFunctions::diagnosticsFunctions;
    connection : Derivation connect L0_Requirements::Quality::diagnosability to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalDiagnostics;
    connection : Derivation connect L0_Requirements::Quality::fieldReplaceability to FunctionalArchitecture::RollerShutterControllerFunctions::diagnosticsFunctions;
    connection : Derivation connect L0_Requirements::Quality::fieldReplaceability to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalDiagnostics;

    /* System Context traceability (SM-PRD-11). References use package-level
     * feature usages defined in SystemContext (systemContext, wallSwitch, etc.)
     * rather than part def classifiers. */
    connection : Derivation connect SystemIdea::systemIdea to SystemContext::systemContext;
    connection : Derivation connect L0_Requirements::Interface::wallSwitchWiringCompatibility to SystemContext::wallSwitch;
    connection : Derivation connect L0_Requirements::Interface::remoteControlWiringCompatibility to SystemContext::homeAutomationSystem;
    connection : Derivation connect L0_Constraints::Electrical::supplyVoltage to SystemContext::controlPowerSupply;
    connection : Derivation connect L0_Constraints::Electrical::switchingLoad to SystemContext::mainsPowerSupply;
    connection : Derivation connect Risks::IntegrationRisks::Risk_WallSwitchWiringIncompatibility to SystemContext::wallSwitch;
    connection : Derivation connect SystemContext::homeAutomationSystem to SystemUseCases::controlRollerShutter;
    connection : Derivation connect SystemContext::wallSwitch to SystemUseCases::controlRollerShutter;

    /* Maintenance/disposal stakeholder traceability. References use package-level
     * feature usages defined in Stakeholders (maintenanceTechnician, disposalFacility). */
    connection : Derivation connect Stakeholders::maintenanceTechnician to SystemUseCases::diagnoseAndRepairController;
    connection : Derivation connect Stakeholders::disposalFacility to SystemUseCases::disposeController;
    /* Part C-2 fix (SMRR corrective pass): Installer stakeholder previously
     * only had Scenario-level Derivation links (scen10-14/22/23 above); no
     * direct Installer -> Use Case link existed at the UC layer itself,
     * unlike maintenanceTechnician/disposalFacility above. Added here,
     * mirroring that exact pattern, for the two Use Cases the Installer
     * stakeholder actually performs (UC_02_InstallController,
     * UC_03_ConfigureController). */
    connection : Derivation connect Stakeholders::installer to SystemUseCases::installController;
    connection : Derivation connect Stakeholders::installer to SystemUseCases::configureController;

    /* Environmental requirement derivation. */
    connection : Derivation connect SystemObjectives::safety to L0_Requirements::Environmental::regulatedDisposal;

    /* System Processes traceability (SM-PRD-13). Each lifecycle action
     * in ControllerLifecycle is derived from the corresponding Use Case
     * (crossmapping/system-processes.md §4 rule). */
    connection : Derivation connect SystemUseCases::installController        to SystemProcesses::ControllerLifecycle::install;
    connection : Derivation connect SystemUseCases::configureController      to SystemProcesses::ControllerLifecycle::configure;
    connection : Derivation connect SystemUseCases::controlRollerShutter     to SystemProcesses::ControllerLifecycle::operate;
    /* MAJ-7 fix (SMRR corrective pass): ControllerLifecycle previously
     * omitted the maintenance/disposal phases despite UC_04/UC_05 already
     * being fully modeled; these two links complete the same rule applied
     * to the two lifecycle actions added above. */
    connection : Derivation connect SystemUseCases::diagnoseAndRepairController to SystemProcesses::ControllerLifecycle::maintain;
    connection : Derivation connect SystemUseCases::disposeController          to SystemProcesses::ControllerLifecycle::dispose;

    /* =========================================================================
     * Product Architecture traceability (SM-PRD-21).
     * Added when the Product Architecture was created, per
     * KnowledgeSource/integration/crossmapping/product-architecture.md §4.
     * 'satisfy ... by ...' is NOT used for Logical/Product targets, for the
     * same conformance reason already documented above the Requirements →
     * Logical Elements block: no Product component conforms to
     * BaseArchitecture::ShutterController. 'connection : Derivation' is used
     * throughout, consistent with every other cross-layer, non-conforming
     * traceability link in this file.
     * ========================================================================= */

    /* Logical Architecture → Product Architecture (SM-PRD-20 → SM-PRD-21).
     * The authoritative Logical-to-Product-Component mapping is the
     * 'allocation def LogicalToProductComponent' in
     * ProductArchitecture/LogicalToProductAllocation.sysml (loose coupling
     * per ADR-007, except MovementSupervisorSoftware/DiagnosticsSoftware/
     * PowerSupplyModule, which are strong-coupled and therefore have no
     * allocation entry of their own -- see that file's header comment). The
     * 'connection : Derivation' links below restate the same mapping at the
     * coarser architectural-layer traceability level, mirroring the
     * Functional→Logical block above exactly. */
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalRemoteRequestInterface to ProductArchitecture::RollerShutterControllerProductComponents::remoteRequestInterface;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalRemoteRequestInterface to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit to ProductComponents::ControlMCU::movementControlSoftware;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit to ProductComponents::ControlMCU::configurationManagerSoftware;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit to ProductComponents::ControlMCU::memoryManagerSoftware;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification to ProductComponents::ControlMCU::userFeedbackSoftware;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification to ProductArchitecture::RollerShutterControllerProductComponents::userNotificationBuzzer;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalDiagnostics to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalDiagnostics to ProductComponents::ControlMCU::diagnosticsSoftware;
    connection : Derivation connect LogicalArchitecture::rollerShutterControllerLogicalComponents to ProductArchitecture::rollerShutterControllerProductComponents;

    /* Design-to-requirement traceability — Product Architecture (SM-PRD-21).
     * Each requirement traces to the specific Product component(s) most
     * directly responsible for realizing it, per
     * ProductArchitecture/LogicalToProductAllocation.sysml, mirroring the
     * granularity already used in the Requirements → Logical Elements block
     * above (the single/pair of components most directly accountable, not
     * every transitively-hosting element). */
    connection : Derivation connect L0_Requirements::Functional::controlRollerShutter to ProductArchitecture::rollerShutterControllerProductComponents;
    connection : Derivation connect L0_Requirements::Functional::localControl to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Derivation connect L0_Requirements::Functional::localControl to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect L0_Requirements::Functional::remoteControl to ProductArchitecture::RollerShutterControllerProductComponents::remoteRequestInterface;
    connection : Derivation connect L0_Requirements::Functional::remoteControl to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect L0_Requirements::Functional::fullShutterMovement to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Derivation connect L0_Requirements::Functional::fullShutterMovement to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Derivation connect L0_Requirements::Functional::fullShutterMovement to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Derivation connect L0_Requirements::Functional::manualPositioning to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Derivation connect L0_Requirements::Functional::manualPositioning to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Derivation connect L0_Requirements::Functional::manualPositioning to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Derivation connect L0_Requirements::Functional::stopShutterMovement to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Derivation connect L0_Requirements::Functional::stopShutterMovement to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Derivation connect L0_Requirements::Functional::stopShutterMovement to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Derivation connect L0_Requirements::Functional::configurableTimingProfile to ProductComponents::ControlMCU::memoryManagerSoftware;
    connection : Derivation connect L0_Requirements::Functional::configurableTimingProfile to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Derivation connect L0_Requirements::Functional::configurationMode to ProductComponents::ControlMCU::configurationManagerSoftware;
    connection : Derivation connect L0_Requirements::Functional::configurationMode to ProductComponents::ControlMCU::userFeedbackSoftware;
    connection : Derivation connect L0_Requirements::Functional::configurationMode to ProductArchitecture::RollerShutterControllerProductComponents::userNotificationBuzzer;
    connection : Derivation connect L0_Requirements::Interface::wallSwitchWiringCompatibility to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    /* PA-2 fix (Product Architecture Review, model_issues.md item 18):
     * REQ-I-01/RISK-I-01 commit to a wall-switch wiring mode "selectable
     * during installer configuration" (WiringMode enum, ProductComponents.
     * sysml). The prior link above only reached the electrical conditioning
     * circuit (localRequestInterface); this NEW link additionally reaches
     * CommandArbitrationSoftware, which now holds the wiringMode attribute
     * that actually performs the momentary/latching interpretation --
     * closing the gap the repair plan identified (no Product element
     * previously carried the wiring-mode selection/interpretation logic
     * REQ-I-01 requires). */
    connection : Derivation connect L0_Requirements::Interface::wallSwitchWiringCompatibility to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect L0_Requirements::Interface::remoteControlWiringCompatibility to ProductArchitecture::RollerShutterControllerProductComponents::remoteRequestInterface;
    /* REQ-Q-01 (easeOfInstallation): NEW Product-layer trace closing a gap
     * that could not exist earlier -- ease of installation is a physical
     * mounting/wiring concern with no structural counterpart before the
     * enclosure/connectors were introduced at this layer. */
    connection : Derivation connect L0_Requirements::Quality::easeOfInstallation to ProductArchitecture::RollerShutterControllerProductComponents::enclosureAndConnectors;
    connection : Derivation connect L0_Requirements::Quality::availability to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;
    connection : Derivation connect L0_Requirements::Quality::availability to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Derivation connect L0_Requirements::Quality::reliability to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;
    connection : Derivation connect L0_Requirements::Quality::reliability to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    /* PA-1 fix (Product Architecture Review, model_issues.md item 18): the
     * links below previously reached diagnosticsSoftware while it was a
     * structural dead-end (diagnosticStateIn tap only, no output).
     * diagnosticsSoftware now additionally has a commandStateIn tap
     * (from commandArbitrationSoftware.commandRelayOut) and a faultOut
     * port (ProductInterfaces::FaultIndicationPort) consumed by
     * userFeedbackSoftware, giving these existing links a concrete,
     * observable realization mechanism (REQ-Q-04's three named fault
     * classes) rather than an unreachable placeholder. No new Derivation
     * links are required here -- the existing links now resolve against a
     * complete mechanism.
     * CRIT-1/CRIT-2 (SMRR corrective pass): the same diagnostic capability
     * now also has real ports at the Functional (diagnosticsFunctions:
     * diagnosticRequestIn/diagnosticResultOut/faultEventOut) and Logical
     * (logicalDiagnostics: mirrored 1:1) layers -- see FunctionalArchitecture.
     * sysml / LogicalArchitecture.sysml. The FA-derived-from-UCA and
     * Logical-derived-from-Functional links above (lines 165, 191) already
     * connect diagnosticsFunctions/logicalDiagnostics into this same chain,
     * so the full Functional → Logical → Product FaultIndication/diagnostics
     * chain is now unbroken end-to-end; no additional Derivation links were
     * needed beyond the ones already present. */
    connection : Derivation connect L0_Requirements::Quality::reliability to ProductComponents::ControlMCU::diagnosticsSoftware;
    connection : Derivation connect L0_Requirements::Quality::diagnosability to ProductComponents::ControlMCU::diagnosticsSoftware;
    /* REQ-Q-05 (fieldReplaceability): diagnostics identifies the fault;
     * screw-terminal enclosure connectors (no soldering) enable the actual
     * field replacement -- both are linked, mirroring the multi-component
     * pattern already used elsewhere in this file. */
    connection : Derivation connect L0_Requirements::Quality::fieldReplaceability to ProductComponents::ControlMCU::diagnosticsSoftware;
    connection : Derivation connect L0_Requirements::Quality::fieldReplaceability to ProductArchitecture::RollerShutterControllerProductComponents::enclosureAndConnectors;
    connection : Derivation connect L0_Requirements::Safety::safety to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect L0_Requirements::Safety::safety to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Derivation connect L0_Requirements::Safety::conflictIndication to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect L0_Requirements::Safety::conflictIndication to ProductComponents::ControlMCU::userFeedbackSoftware;
    connection : Derivation connect L0_Requirements::Safety::conflictIndication to ProductArchitecture::RollerShutterControllerProductComponents::userNotificationBuzzer;
    /* REQ-E-01 (regulatedDisposal): NEW Product-layer trace -- disposal is a
     * physical-materials concern of the finished enclosure/assembly, with no
     * structural counterpart before this layer. */
    connection : Derivation connect L0_Requirements::Environmental::regulatedDisposal to ProductArchitecture::RollerShutterControllerProductComponents::enclosureAndConnectors;

    /* Constraints → Product Architecture (SM-PRD-21). L0_Constraints have no
     * L0_Requirements usage of their own (see Constraints.sysml/ADR-001) and
     * are managed at the BOM/design level; the Product Architecture is the
     * first layer with concrete hardware to trace them against directly. */
    connection : Derivation connect L0_Constraints::Business::costEffective to ProductArchitecture::rollerShutterControllerProductComponents;
    connection : Derivation connect L0_Constraints::Physical::compactDimensions to ProductArchitecture::RollerShutterControllerProductComponents::enclosureAndConnectors;
    connection : Derivation connect L0_Constraints::Environmental::operatingConditions to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;
    connection : Derivation connect L0_Constraints::Environmental::operatingConditions to ProductArchitecture::RollerShutterControllerProductComponents::enclosureAndConnectors;
    connection : Derivation connect L0_Constraints::Electrical::supplyVoltage to ProductArchitecture::RollerShutterControllerProductComponents::powerSupplyModule;
    connection : Derivation connect L0_Constraints::Electrical::switchingLoad to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Derivation connect L0_Constraints::Electrical::motorIsolation to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Derivation connect L0_Constraints::Electrical::inputIsolation to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Derivation connect L0_Constraints::Electrical::inputIsolation to ProductArchitecture::RollerShutterControllerProductComponents::remoteRequestInterface;
    connection : Derivation connect L0_Constraints::Architectural::noPositionFeedback to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Derivation connect L0_Constraints::Architectural::noPositionFeedback to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Derivation connect L0_Constraints::Architectural::timeBasedOperation to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Derivation connect L0_Constraints::Architectural::timeBasedOperation to ProductComponents::ControlMCU::memoryManagerSoftware;

    /* Risks → Product Architecture (PA-8 fix, Product Architecture Review,
     * model_issues.md item 18). Every Risk previously traced only as far as
     * L0_Requirements/L0_Constraints/SystemContext (see the Risk derivation
     * block above, lines ~95-123); none reached all the way to the concrete
     * Product component that structurally mitigates it, leaving the chain
     * incomplete at its most concrete end. These NEW links close that gap
     * for the three risks with a direct, identifiable Product-layer
     * mitigation, without altering any existing Risk→Requirement/Constraint
     * link above. */
    connection : Derivation connect Risks::IntegrationRisks::Risk_WallSwitchWiringIncompatibility to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect Risks::TechnicalRisks::Risk_MotorRelayWearOut to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Derivation connect Risks::TechnicalRisks::Risk_PositioningDrift to ProductComponents::ControlMCU::memoryManagerSoftware;

    /* =========================================================================
     * Scenarios traceability (SM-PRD-22).
     * Added when the Operational Scenarios were created, per
     * KnowledgeSource/integration/crossmapping/scenarios.md §4 Traceability
     * Rules. Every scenario traces to: the Use Case Activity path it walks
     * (Rule 1), the Use Case it elaborates, and the Logical/Product
     * components exercised along that path (mirroring the Functional→
     * Logical and Logical→Product blocks above). Scenario→Requirement and
     * Scenario→SystemObjectives links are reached transitively via the
     * UseCaseActivities/UseCases links already present in this file; only
     * the NEW Scenario-specific endpoints are added here, consistent with
     * this file's established "closest concrete link" convention (no
     * redundant re-statement of pre-existing chains). 'connection :
     * Derivation' is used throughout, since a Scenario is a distinct
     * usage element and does not 'conform to' its UCA/Logical/Product
     * counterparts. */

    /* Scenario → Use Case Activity (the single UCA path each scenario walks). */
    connection : Derivation connect Scenarios::scen01_AutomaticOpen_NormalPath to UseCaseActivities::openShutterAutomatically;
    connection : Derivation connect Scenarios::scen02_AutomaticClose_NormalPath to UseCaseActivities::closeShutterAutomatically;
    connection : Derivation connect Scenarios::scen03_ManualOpen_UserReleaseStop to UseCaseActivities::openShutterManually;
    connection : Derivation connect Scenarios::scen03_ManualOpen_UserReleaseStop to UseCaseActivities::monitorUserInterruption;
    connection : Derivation connect Scenarios::scen04_ManualClose_UserReleaseStop to UseCaseActivities::closeShutterManually;
    connection : Derivation connect Scenarios::scen04_ManualClose_UserReleaseStop to UseCaseActivities::monitorUserInterruption;
    connection : Derivation connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to UseCaseActivities::openShutterManually;
    connection : Derivation connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to UseCaseActivities::monitorUserInterruption;
    connection : Derivation connect Scenarios::scen06_AutomaticMovement_UserStopOverride to UseCaseActivities::monitorStopCondition;
    connection : Derivation connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to UseCaseActivities::handleConflictingMovementCommands;
    connection : Derivation connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to UseCaseActivities::notifyUserAboutConflict;
    connection : Derivation connect Scenarios::scen08_RemoteCommand_HomeAutomationOpen to UseCaseActivities::openShutterAutomatically;
    connection : Derivation connect Scenarios::scen09_LocalAndRemoteSimultaneous_FirstWinsArbitration to UseCaseActivities::receiveControlRequest;
    connection : Derivation connect Scenarios::scen10_InstallController_SuccessfulFirstAttempt to UseCaseActivities::installController;
    connection : Derivation connect Scenarios::scen11_InstallController_WiringFault_RetrySucceeds to UseCaseActivities::installController;
    connection : Derivation connect Scenarios::scen12_InstallController_RepeatedFault_TerminalReport to UseCaseActivities::installController;
    connection : Derivation connect Scenarios::scen12_InstallController_RepeatedFault_TerminalReport to UseCaseActivities::reportInstallationFault;
    connection : Derivation connect Scenarios::scen13_ConfigureController_TimingCalibration to UseCaseActivities::configureController;
    connection : Derivation connect Scenarios::scen14_ConfigureController_ReentryRejected to UseCaseActivities::rejectConfigurationModeReentry;
    /* SCEN_15/SCEN_16 (power loss/recovery): NO UseCaseActivities link is
     * added here -- confirmed gap (Phase 5/8 of the Scenarios narrative).
     * No action anywhere in UseCaseActivities.sysml models a power-loss or
     * power-recovery event; these two scenarios trace only to
     * ADR_002_Availability's explicit scope decision below. */
    connection : Derivation connect Scenarios::scen17_MechanicalJam_TimeBasedStopWithoutFeedback to UseCaseActivities::monitorStopCondition;
    connection : Derivation connect Scenarios::scen18_DiagnoseAndRepair_NoPowerFault to UseCaseActivities::diagnoseAndRepairController;
    connection : Derivation connect Scenarios::scen18_DiagnoseAndRepair_NoPowerFault to UseCaseActivities::detectFault;
    connection : Derivation connect Scenarios::scen19_DiagnoseAndRepair_NoResponseFault to UseCaseActivities::diagnoseAndRepairController;
    connection : Derivation connect Scenarios::scen19_DiagnoseAndRepair_NoResponseFault to UseCaseActivities::isolateFault;
    connection : Derivation connect Scenarios::scen20_DiagnoseAndRepair_MotorDriveFault to UseCaseActivities::diagnoseAndRepairController;
    connection : Derivation connect Scenarios::scen20_DiagnoseAndRepair_MotorDriveFault to UseCaseActivities::repairOrReplaceUnit;
    connection : Derivation connect Scenarios::scen21_DisposeController_EndOfLife to UseCaseActivities::disposeController;

    /* Scenario Repair Plan (SM-PRD-22, Wave 4): SCEN_22-25 UCA links. */
    connection : Derivation connect Scenarios::scen22_ConfigureController_InvalidCalibrationRejected to UseCaseActivities::configureController;
    /* SCEN_23: closest concrete UCA anchor only -- confirmed gap (see the
     * scenario's own doc header and its trailing '// GAP:' comment). No
     * UseCaseActivities action models wiring-mode mismatch detection
     * specifically; handleConflictingMovementCommands is linked as the
     * nearest existing mechanism (both are cases where a raw signal fails
     * to translate into the intended ControlCommand), mirroring the
     * SCEN_15/16 confirmed-gap pattern already used above. */
    connection : Derivation connect Scenarios::scen23_LocalControl_WiringModeMismatch to UseCaseActivities::handleConflictingMovementCommands;
    connection : Derivation connect Scenarios::scen23_LocalControl_WiringModeMismatch to UseCaseActivities::receiveControlRequest;
    connection : Derivation connect Scenarios::scen24_TimingProfile_PersistenceFailure_FirstPowerOn to UseCaseActivities::loadTimingProfile;
    connection : Derivation connect Scenarios::scen24_TimingProfile_PersistenceFailure_FirstPowerOn to UseCaseActivities::diagnoseAndRepairController;
    connection : Derivation connect Scenarios::scen25_AutomaticOpen_LowTemperatureBoundary to UseCaseActivities::openShutterAutomatically;

    /* Scenario → Logical Architecture (principal components exercised). */
    connection : Derivation connect Scenarios::scen01_AutomaticOpen_NormalPath to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Derivation connect Scenarios::scen01_AutomaticOpen_NormalPath to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Derivation connect Scenarios::scen02_AutomaticClose_NormalPath to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Derivation connect Scenarios::scen02_AutomaticClose_NormalPath to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Derivation connect Scenarios::scen03_ManualOpen_UserReleaseStop to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Derivation connect Scenarios::scen04_ManualClose_UserReleaseStop to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Derivation connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Derivation connect Scenarios::scen06_AutomaticMovement_UserStopOverride to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Derivation connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Derivation connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification;
    connection : Derivation connect Scenarios::scen08_RemoteCommand_HomeAutomationOpen to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalRemoteRequestInterface;
    connection : Derivation connect Scenarios::scen09_LocalAndRemoteSimultaneous_FirstWinsArbitration to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Derivation connect Scenarios::scen13_ConfigureController_TimingCalibration to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Derivation connect Scenarios::scen13_ConfigureController_TimingCalibration to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Derivation connect Scenarios::scen14_ConfigureController_ReentryRejected to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Derivation connect Scenarios::scen15_PowerLoss_DuringMovement to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Derivation connect Scenarios::scen17_MechanicalJam_TimeBasedStopWithoutFeedback to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Derivation connect Scenarios::scen17_MechanicalJam_TimeBasedStopWithoutFeedback to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Derivation connect Scenarios::scen18_DiagnoseAndRepair_NoPowerFault to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalDiagnostics;
    connection : Derivation connect Scenarios::scen19_DiagnoseAndRepair_NoResponseFault to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalDiagnostics;
    connection : Derivation connect Scenarios::scen20_DiagnoseAndRepair_MotorDriveFault to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalDiagnostics;

    /* Scenario Repair Plan (SM-PRD-22, SR-2/C2): logicalLocalRequestInterface
     * is the acting participant explicitly named in SCEN_01/03/04/05/07/09's
     * own doc blocks (local wall-switch channel acquisition) but had no
     * formal Traceability endpoint here -- an asymmetry versus its sibling
     * logicalRemoteRequestInterface (already linked from SCEN_08 above).
     * These 6 links close that orphan finding without altering any existing
     * scenario step, succession, or architecture element. */
    connection : Derivation connect Scenarios::scen01_AutomaticOpen_NormalPath to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Derivation connect Scenarios::scen03_ManualOpen_UserReleaseStop to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Derivation connect Scenarios::scen04_ManualClose_UserReleaseStop to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Derivation connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Derivation connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Derivation connect Scenarios::scen09_LocalAndRemoteSimultaneous_FirstWinsArbitration to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;

    /* Scenario Repair Plan (Wave 4): SCEN_22-25 Logical Architecture links,
     * per the repair plan's "Scenarios → Logical Components" table. */
    connection : Derivation connect Scenarios::scen22_ConfigureController_InvalidCalibrationRejected to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Derivation connect Scenarios::scen22_ConfigureController_InvalidCalibrationRejected to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Derivation connect Scenarios::scen23_LocalControl_WiringModeMismatch to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Derivation connect Scenarios::scen23_LocalControl_WiringModeMismatch to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Derivation connect Scenarios::scen24_TimingProfile_PersistenceFailure_FirstPowerOn to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Derivation connect Scenarios::scen24_TimingProfile_PersistenceFailure_FirstPowerOn to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalDiagnostics;
    connection : Derivation connect Scenarios::scen25_AutomaticOpen_LowTemperatureBoundary to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Derivation connect Scenarios::scen25_AutomaticOpen_LowTemperatureBoundary to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;

    /* Scenario → Product Architecture (principal components exercised). */
    connection : Derivation connect Scenarios::scen01_AutomaticOpen_NormalPath to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Derivation connect Scenarios::scen01_AutomaticOpen_NormalPath to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Derivation connect Scenarios::scen02_AutomaticClose_NormalPath to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Derivation connect Scenarios::scen02_AutomaticClose_NormalPath to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Derivation connect Scenarios::scen03_ManualOpen_UserReleaseStop to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Derivation connect Scenarios::scen04_ManualClose_UserReleaseStop to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Derivation connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Derivation connect Scenarios::scen06_AutomaticMovement_UserStopOverride to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Derivation connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to ProductComponents::ControlMCU::userFeedbackSoftware;
    connection : Derivation connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to ProductArchitecture::RollerShutterControllerProductComponents::userNotificationBuzzer;
    connection : Derivation connect Scenarios::scen08_RemoteCommand_HomeAutomationOpen to ProductArchitecture::RollerShutterControllerProductComponents::remoteRequestInterface;
    connection : Derivation connect Scenarios::scen09_LocalAndRemoteSimultaneous_FirstWinsArbitration to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect Scenarios::scen10_InstallController_SuccessfulFirstAttempt to ProductArchitecture::rollerShutterControllerProductComponents;
    connection : Derivation connect Scenarios::scen10_InstallController_SuccessfulFirstAttempt to ProductArchitecture::RollerShutterControllerProductComponents::enclosureAndConnectors;
    connection : Derivation connect Scenarios::scen11_InstallController_WiringFault_RetrySucceeds to ProductArchitecture::RollerShutterControllerProductComponents::enclosureAndConnectors;
    connection : Derivation connect Scenarios::scen12_InstallController_RepeatedFault_TerminalReport to ProductArchitecture::RollerShutterControllerProductComponents::enclosureAndConnectors;
    connection : Derivation connect Scenarios::scen13_ConfigureController_TimingCalibration to ProductComponents::ControlMCU::configurationManagerSoftware;
    connection : Derivation connect Scenarios::scen13_ConfigureController_TimingCalibration to ProductComponents::ControlMCU::memoryManagerSoftware;
    connection : Derivation connect Scenarios::scen14_ConfigureController_ReentryRejected to ProductComponents::ControlMCU::configurationManagerSoftware;
    /* SCEN_15/SCEN_16: traced only to the passive hardware fail-safe path
     * and to the availability-scope ADR, per the confirmed UCA gap above. */
    connection : Derivation connect Scenarios::scen15_PowerLoss_DuringMovement to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Derivation connect Scenarios::scen15_PowerLoss_DuringMovement to ProductArchitecture::RollerShutterControllerProductComponents::powerSupplyModule;
    connection : Derivation connect Scenarios::scen16_PowerRecovery_AfterOutage to ProductArchitecture::RollerShutterControllerProductComponents::powerSupplyModule;
    connection : Derivation connect Scenarios::scen16_PowerRecovery_AfterOutage to ProductComponents::ControlMCU::memoryManagerSoftware;
    connection : Derivation connect Scenarios::scen17_MechanicalJam_TimeBasedStopWithoutFeedback to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Derivation connect Scenarios::scen17_MechanicalJam_TimeBasedStopWithoutFeedback to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Derivation connect Scenarios::scen18_DiagnoseAndRepair_NoPowerFault to ProductArchitecture::RollerShutterControllerProductComponents::userNotificationBuzzer;
    connection : Derivation connect Scenarios::scen18_DiagnoseAndRepair_NoPowerFault to ProductArchitecture::RollerShutterControllerProductComponents::powerSupplyModule;
    connection : Derivation connect Scenarios::scen19_DiagnoseAndRepair_NoResponseFault to ProductComponents::ControlMCU::diagnosticsSoftware;
    connection : Derivation connect Scenarios::scen20_DiagnoseAndRepair_MotorDriveFault to ProductComponents::ControlMCU::diagnosticsSoftware;
    connection : Derivation connect Scenarios::scen20_DiagnoseAndRepair_MotorDriveFault to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Derivation connect Scenarios::scen21_DisposeController_EndOfLife to ProductArchitecture::RollerShutterControllerProductComponents::enclosureAndConnectors;

    /* Scenario Repair Plan (SM-PRD-22, SR-3/C3): localRequestInterface is
     * the Product-layer hardware realization of logicalLocalRequestInterface
     * (SR-2/C2 above) and was likewise never a Traceability endpoint from
     * the Scenario side, despite being the literal component every local-
     * channel scenario's doc already exercises. Mirrors the C2 endpoint set
     * one layer down. */
    connection : Derivation connect Scenarios::scen01_AutomaticOpen_NormalPath to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Derivation connect Scenarios::scen03_ManualOpen_UserReleaseStop to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Derivation connect Scenarios::scen04_ManualClose_UserReleaseStop to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Derivation connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Derivation connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Derivation connect Scenarios::scen09_LocalAndRemoteSimultaneous_FirstWinsArbitration to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;

    /* Scenario Repair Plan (SR-4/C4b): movementControlSoftware sits directly
     * on SCEN_01/SCEN_02's s3 (validateAndRequestMovement) pipeline -- now
     * explicitly named in those steps' doc (C4a, above) -- but had zero
     * Traceability endpoints anywhere as a Scenario target. */
    connection : Derivation connect Scenarios::scen01_AutomaticOpen_NormalPath to ProductComponents::ControlMCU::movementControlSoftware;
    connection : Derivation connect Scenarios::scen02_AutomaticClose_NormalPath to ProductComponents::ControlMCU::movementControlSoftware;

    /* Scenario Repair Plan (SR-5/C5): commandArbitrationSoftware and
     * motorDriveControlSoftware are traversed by every primary-path local/
     * remote command (arbitration) and every motor energize/de-energize
     * decision (motor drive) respectively, yet were linked from only 1-2
     * scenarios each (SCEN_07/09 for arbitration; SCEN_17 only for motor
     * drive). These additional links make that primary-path exercising
     * formally visible, closing SR-5's "partially exercised" finding. */
    connection : Derivation connect Scenarios::scen01_AutomaticOpen_NormalPath to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect Scenarios::scen02_AutomaticClose_NormalPath to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect Scenarios::scen03_ManualOpen_UserReleaseStop to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect Scenarios::scen04_ManualClose_UserReleaseStop to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect Scenarios::scen06_AutomaticMovement_UserStopOverride to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect Scenarios::scen08_RemoteCommand_HomeAutomationOpen to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect Scenarios::scen01_AutomaticOpen_NormalPath to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Derivation connect Scenarios::scen02_AutomaticClose_NormalPath to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Derivation connect Scenarios::scen03_ManualOpen_UserReleaseStop to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Derivation connect Scenarios::scen04_ManualClose_UserReleaseStop to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Derivation connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Derivation connect Scenarios::scen06_AutomaticMovement_UserStopOverride to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Derivation connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Derivation connect Scenarios::scen08_RemoteCommand_HomeAutomationOpen to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Derivation connect Scenarios::scen09_LocalAndRemoteSimultaneous_FirstWinsArbitration to ProductComponents::ControlMCU::motorDriveControlSoftware;

    /* Scenario Repair Plan (Wave 4): SCEN_22-25 Product Architecture links,
     * per the repair plan's "Scenarios → Product Components" table. */
    connection : Derivation connect Scenarios::scen22_ConfigureController_InvalidCalibrationRejected to ProductComponents::ControlMCU::configurationManagerSoftware;
    connection : Derivation connect Scenarios::scen22_ConfigureController_InvalidCalibrationRejected to ProductComponents::ControlMCU::memoryManagerSoftware;
    connection : Derivation connect Scenarios::scen23_LocalControl_WiringModeMismatch to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Derivation connect Scenarios::scen23_LocalControl_WiringModeMismatch to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Derivation connect Scenarios::scen24_TimingProfile_PersistenceFailure_FirstPowerOn to ProductComponents::ControlMCU::memoryManagerSoftware;
    connection : Derivation connect Scenarios::scen24_TimingProfile_PersistenceFailure_FirstPowerOn to ProductComponents::ControlMCU::diagnosticsSoftware;
    connection : Derivation connect Scenarios::scen25_AutomaticOpen_LowTemperatureBoundary to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Derivation connect Scenarios::scen25_AutomaticOpen_LowTemperatureBoundary to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;

    /* Scenario → Stakeholders.
     * Scenario Repair Plan (SM-PRD-22, SR-6/C6a) closed the previously
     * documented gap here: Stakeholders.sysml now exposes 'installer' and
     * 'manufacturer' as package-level usages (mirroring
     * maintenanceTechnician/disposalFacility), in addition to the two
     * pre-existing reachable usages. The SystemContext actor usages below
     * (wallSwitch, homeAutomationSystem) are retained unchanged as they
     * stand in for non-Stakeholder interaction channels. */
    connection : Derivation connect Scenarios::scen01_AutomaticOpen_NormalPath to SystemContext::wallSwitch;
    connection : Derivation connect Scenarios::scen02_AutomaticClose_NormalPath to SystemContext::homeAutomationSystem;
    connection : Derivation connect Scenarios::scen08_RemoteCommand_HomeAutomationOpen to SystemContext::homeAutomationSystem;
    connection : Derivation connect Scenarios::scen18_DiagnoseAndRepair_NoPowerFault to Stakeholders::maintenanceTechnician;
    connection : Derivation connect Scenarios::scen19_DiagnoseAndRepair_NoResponseFault to Stakeholders::maintenanceTechnician;
    connection : Derivation connect Scenarios::scen20_DiagnoseAndRepair_MotorDriveFault to Stakeholders::maintenanceTechnician;
    connection : Derivation connect Scenarios::scen21_DisposeController_EndOfLife to Stakeholders::disposalFacility;

    /* Scenario Repair Plan (SR-6/C6b): Installer is the explicit narrative
     * trigger/actor for all five Installation/Configuration scenarios below
     * ("Installer begins physical installation" / "Installer explicitly
     * activates configuration mode", etc.) yet had zero Scenario→Stakeholder
     * Traceability links, unlike maintenanceTechnician/disposalFacility
     * above. Closes SR-6. */
    connection : Derivation connect Scenarios::scen10_InstallController_SuccessfulFirstAttempt to Stakeholders::installer;
    connection : Derivation connect Scenarios::scen11_InstallController_WiringFault_RetrySucceeds to Stakeholders::installer;
    connection : Derivation connect Scenarios::scen12_InstallController_RepeatedFault_TerminalReport to Stakeholders::installer;
    connection : Derivation connect Scenarios::scen13_ConfigureController_TimingCalibration to Stakeholders::installer;
    connection : Derivation connect Scenarios::scen14_ConfigureController_ReentryRejected to Stakeholders::installer;

    /* Scenario Repair Plan (Wave 4): SCEN_22-25 Stakeholder links. scen22/
     * scen23 are Installer-triggered (invalid calibration / wiring-mode
     * mismatch, both configuration-time actions); scen25 closes SR-10's
     * stakeholder half via Manufacturer's OperatingConditions concern
     * (Stakeholders.sysml), reachable now via the C6a 'manufacturer'
     * package-level usage. */
    connection : Derivation connect Scenarios::scen22_ConfigureController_InvalidCalibrationRejected to Stakeholders::installer;
    connection : Derivation connect Scenarios::scen23_LocalControl_WiringModeMismatch to Stakeholders::installer;
    connection : Derivation connect Scenarios::scen25_AutomaticOpen_LowTemperatureBoundary to Stakeholders::manufacturer;

    /* MAJ-4 fix (SMRR corrective pass, HIGH priority -- biggest
     * validation-readiness unlock): 'Stakeholders::user' is now a reachable
     * package-level usage (see Stakeholders.sysml). Wiring the 10
     * previously-orphaned scenarios the SMRR identifies by category --
     * manual control (SCEN_03/04/05/06), conflict arbitration (SCEN_07/09),
     * power loss (SCEN_15/16), mechanical jam (SCEN_17), and persistence
     * failure (SCEN_24) -- all of which have User as their direct
     * narrative actor/beneficiary but previously had zero formal
     * Stakeholder trace. Closes MAJ-4. */
    connection : Derivation connect Scenarios::scen03_ManualOpen_UserReleaseStop to Stakeholders::user;
    connection : Derivation connect Scenarios::scen04_ManualClose_UserReleaseStop to Stakeholders::user;
    connection : Derivation connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to Stakeholders::user;
    connection : Derivation connect Scenarios::scen06_AutomaticMovement_UserStopOverride to Stakeholders::user;
    connection : Derivation connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to Stakeholders::user;
    connection : Derivation connect Scenarios::scen09_LocalAndRemoteSimultaneous_FirstWinsArbitration to Stakeholders::user;
    connection : Derivation connect Scenarios::scen15_PowerLoss_DuringMovement to Stakeholders::user;
    connection : Derivation connect Scenarios::scen16_PowerRecovery_AfterOutage to Stakeholders::user;
    connection : Derivation connect Scenarios::scen17_MechanicalJam_TimeBasedStopWithoutFeedback to Stakeholders::user;
    connection : Derivation connect Scenarios::scen24_TimingProfile_PersistenceFailure_FirstPowerOn to Stakeholders::user;

    /* =========================================================================
     * Scenario → Test Case (SM-PRD-22, closes SR-1).
     * NEW category (Scenario Repair Plan C1): completes the fourth of five
     * outgoing-link categories 'crossmapping/scenarios.md §4' mandates for a
     * Scenario ("Completed scenarios are templates for SM-PRD-16 test case
     * specifications"). Eight scenarios already named a
     * SystemTestCases.sysml verification def by qualified name IN PROSE
     * (their own 'doc' blocks -- e.g. SCEN_05 → TC_N_001) without a
     * corresponding formal connection; those are populated first (highest
     * confidence), then extended to the remaining primary-path scenarios
     * using this file's established "closest concrete link" convention.
     * Scenarios with no defensible test-case precedent are recorded with an
     * explicit '// GAP:' comment rather than inventing a redundant new test
     * case, per Traceability Rule 3. 'connection : Derivation' is used
     * throughout, consistent with every other Scenario-sourced block above.
     * ========================================================================= */
    connection : Derivation connect Scenarios::scen01_AutomaticOpen_NormalPath to SystemTestCases::tc_F_006_automaticFullOpen;
    connection : Derivation connect Scenarios::scen02_AutomaticClose_NormalPath to SystemTestCases::tc_F_007_automaticFullClose;
    connection : Derivation connect Scenarios::scen03_ManualOpen_UserReleaseStop to SystemTestCases::tc_F_008_manualPartialOpen;
    connection : Derivation connect Scenarios::scen04_ManualClose_UserReleaseStop to SystemTestCases::tc_F_009_manualPartialClose;
    /* SCEN_05 already names TC_N_001_ManualMode_SafetyTimeout in its own doc
     * (direct precedent) -- formalized here. */
    connection : Derivation connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to SystemTestCases::tc_N_001_manualMode_safetyTimeout;
    connection : Derivation connect Scenarios::scen06_AutomaticMovement_UserStopOverride to SystemTestCases::tc_F_010_stopDuringOpening;
    connection : Derivation connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to SystemTestCases::tc_S_001_conflictSuppression_localUPDOWN;
    connection : Derivation connect Scenarios::scen08_RemoteCommand_HomeAutomationOpen to SystemTestCases::tc_F_004_remoteControl_UP;
    connection : Derivation connect Scenarios::scen09_LocalAndRemoteSimultaneous_FirstWinsArbitration to SystemTestCases::tc_S_002_conflictSuppression_localRemote;
    connection : Derivation connect Scenarios::scen10_InstallController_SuccessfulFirstAttempt to SystemTestCases::tc_Q_001_installationTime;
    /* SCEN_11 already names TC_N_003_Installation_WiringVerifyRetry in its
     * own doc (direct precedent) -- formalized here. */
    connection : Derivation connect Scenarios::scen11_InstallController_WiringFault_RetrySucceeds to SystemTestCases::tc_N_003_installation_wiringRetry;
    // GAP (SMRR CRIT-6 fix, resolved below): SCEN_12 (Repeated Fault, Terminal
    // Report) previously had no existing test case modeling a
    // terminal/unrecoverable installation fault report -- closed by
    // authoring SystemTestCases::tc_N_006_installationFailureTerminalFault
    // (mirrors TC_N_003/004/005's exact style), which directly exercises
    // InstallController's afterRetryVerify == false / reportInstallationFault
    // branch and links to SystemStates::InstallationFault (terminal state).
    connection : Derivation connect Scenarios::scen12_InstallController_RepeatedFault_TerminalReport to SystemTestCases::tc_N_006_installationFailureTerminalFault;
    connection : Derivation connect Scenarios::scen13_ConfigureController_TimingCalibration to SystemTestCases::tc_F_012_configurableTimingProfile_nominal;
    /* SCEN_14 already names TC_N_002_ConfigMode_ReentryRejected in its own
     * doc (direct precedent) -- formalized here. */
    connection : Derivation connect Scenarios::scen14_ConfigureController_ReentryRejected to SystemTestCases::tc_N_002_configMode_reentryRejected;
    connection : Derivation connect Scenarios::scen15_PowerLoss_DuringMovement to SystemTestCases::tc_Q_002_operationalAvailability;
    connection : Derivation connect Scenarios::scen16_PowerRecovery_AfterOutage to SystemTestCases::tc_Q_002_operationalAvailability;
    /* SCEN_17 already names TC_N_004_NoPosiitonFeedback_TimeBased in its own
     * doc (direct precedent) -- formalized here. */
    connection : Derivation connect Scenarios::scen17_MechanicalJam_TimeBasedStopWithoutFeedback to SystemTestCases::tc_N_004_noPositionFeedback_timeBased;
    /* SCEN_18/19/20 already name TC_Q_004_FieldDiagnosis in their own doc
     * (direct precedent) -- formalized here. */
    connection : Derivation connect Scenarios::scen18_DiagnoseAndRepair_NoPowerFault to SystemTestCases::tc_Q_004_fieldDiagnosis;
    connection : Derivation connect Scenarios::scen19_DiagnoseAndRepair_NoResponseFault to SystemTestCases::tc_Q_004_fieldDiagnosis;
    connection : Derivation connect Scenarios::scen20_DiagnoseAndRepair_MotorDriveFault to SystemTestCases::tc_Q_004_fieldDiagnosis;
    connection : Derivation connect Scenarios::scen21_DisposeController_EndOfLife to SystemTestCases::tc_E_001_disposalCompliance;
    /* New scenarios (SCEN_22-25) -- Test Case links per the repair plan's
     * "Scenarios → Test Cases" table. */
    connection : Derivation connect Scenarios::scen22_ConfigureController_InvalidCalibrationRejected to SystemTestCases::tc_B_003_timingProfile_maxBoundary;
    connection : Derivation connect Scenarios::scen23_LocalControl_WiringModeMismatch to SystemTestCases::tc_N_005_wiringModeMismatch_detected;
    connection : Derivation connect Scenarios::scen24_TimingProfile_PersistenceFailure_FirstPowerOn to SystemTestCases::tc_Q_004_fieldDiagnosis;
    connection : Derivation connect Scenarios::scen25_AutomaticOpen_LowTemperatureBoundary to SystemTestCases::tc_B_004_operatingTemp_lowerBoundary;

    /* =========================================================================
     * State Model (SM-PRD-23, SystemStates.sysml) traceability block.
     * Additive only -- no line above this point is modified. Mirrors the
     * "connection : Derivation connect A to B;" convention used throughout
     * this file. Component granularity (connects to the package-level part
     * usage exhibiting the relevant state machine, not to individual nested
     * state features) is used consistently, matching every other
     * Scenario/Requirement → Architecture-component link already present
     * above (e.g. line 188's Functional→Logical composite-to-composite
     * link). The specific state(s)/transition(s) each connection concerns
     * are named in the accompanying doc comment for precision.
     * ========================================================================= */

    // ---- State Model → Scenario (Phase 6: Scenario Mapping) ----------------
    // Every scenario that exercises the top-level lifecycle machine
    // (rollerShutterControllerWithLifecycle.systemLifecycle) or the
    // diagnostics machine (logicalDiagnosticsWithState.diagnosticLifecycle).
    connection : Derivation connect Scenarios::scen01_AutomaticOpen_NormalPath to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingAutomatic -> Idle.
    connection : Derivation connect Scenarios::scen02_AutomaticClose_NormalPath to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingAutomatic -> Idle.
    connection : Derivation connect Scenarios::scen03_ManualOpen_UserReleaseStop to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingManual -> Idle.
    connection : Derivation connect Scenarios::scen04_ManualClose_UserReleaseStop to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingManual -> Idle.
    connection : Derivation connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingManual -> Idle (StopRequest[reason=timeout]).
    // Known gap (Phase 9): the latched-stopped-until-release guard this
    // scenario's own TC_N_001 verifyOutcome describes has no identified
    // structural owner anywhere in the model -- see MovingManual's doc.
    connection : Derivation connect Scenarios::scen06_AutomaticMovement_UserStopOverride to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingAutomatic -> Idle (StopRequest[reason=userRequest]).
    connection : Derivation connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> AssessingSimultaneousHold -> ConflictSuppressed
    // -> Idle (State Model Review corrective pass, MAJOR-1: the short
    // simultaneous-press timeout path through the new explicit
    // discriminator state; calibrationHoldThresholdS elapses with no
    // ConfigModeEvent[activated] confirmation).
    connection : Derivation connect Scenarios::scen08_RemoteCommand_HomeAutomationOpen to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingAutomatic -> Idle (remote-origin ControlCommand).
    connection : Derivation connect Scenarios::scen09_LocalAndRemoteSimultaneous_FirstWinsArbitration to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingAutomatic -> Idle (arbitration resolved upstream of ControlCommand).
    connection : Derivation connect Scenarios::scen10_InstallController_SuccessfulFirstAttempt to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Uninstalled -> Installing -> Idle.
    connection : Derivation connect Scenarios::scen11_InstallController_WiringFault_RetrySucceeds to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Uninstalled -> Installing -> Idle (single bounded retry inside InstallController).
    connection : Derivation connect Scenarios::scen12_InstallController_RepeatedFault_TerminalReport to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Uninstalled -> Installing -> InstallationFault (TERMINAL).
    connection : Derivation connect Scenarios::scen13_ConfigureController_TimingCalibration to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> AssessingSimultaneousHold -> ConfigurationMode
    // -> Idle (State Model Review corrective pass, MAJOR-1: the sustained
    // simultaneous-hold path through the new explicit discriminator state;
    // ConfigModeEvent[activated] confirms the hold before
    // calibrationHoldThresholdS elapses).
    connection : Derivation connect Scenarios::scen14_ConfigureController_ReentryRejected to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> ConfigurationMode -> ConfigurationMode (reentry self-transition) -> Idle.
    connection : Derivation connect Scenarios::scen15_PowerLoss_DuringMovement to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: MovingAutomatic/MovingManual -> Unpowered (gap-derived PowerLost trigger; see Unpowered's doc).
    connection : Derivation connect Scenarios::scen16_PowerRecovery_AfterOutage to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Unpowered -> Idle (gap-derived PowerRestored trigger; see Unpowered's doc).
    connection : Derivation connect Scenarios::scen17_MechanicalJam_TimeBasedStopWithoutFeedback to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingAutomatic -> Idle -- indistinguishable from
    // scen01's normal-completion path at this state granularity (RISK-T-01/
    // ADR-003 accepted residual risk; no separate "Jammed" state is modeled
    // because no component can structurally detect the difference).
    connection : Derivation connect Scenarios::scen18_DiagnoseAndRepair_NoPowerFault to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Unpowered (passively observed by the technician; see
    // Unpowered's doc -- deliberately has no corresponding DiagnosticState
    // "NoPowerFault" member, since LogicalDiagnostics itself is unpowered).
    connection : Derivation connect Scenarios::scen19_DiagnoseAndRepair_NoResponseFault to SystemStates::logicalDiagnosticsWithState;
    // states entered: Nominal -> ClassifyingFault -> NoResponseFault -> Repairing -> Nominal.
    connection : Derivation connect Scenarios::scen20_DiagnoseAndRepair_MotorDriveFault to SystemStates::logicalDiagnosticsWithState;
    // states entered: Nominal -> ClassifyingFault -> MotorDriveFault -> Repairing -> Nominal.
    connection : Derivation connect Scenarios::scen21_DisposeController_EndOfLife to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> Disposed (TERMINAL).
    connection : Derivation connect Scenarios::scen22_ConfigureController_InvalidCalibrationRejected to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> AssessingSimultaneousHold -> ConfigurationMode
    // -> Idle (path updated per the State Model Review corrective pass,
    // MAJOR-1). MAJ-8 fix (SMRR corrective pass): the invalid-calibration
    // rejection now HAS an identified structural guard owner --
    // UseCaseActivities::ConfigureController's checkOpenTimeInRange /
    // checkCloseTimeInRange + openRangeGuard/closeRangeGuard decides
    // (CheckTravelTimeInRange, RejectOutOfRangeCalibration) -- executed
    // entirely inside ConfigurationMode's existing
    // 'do action configureController' composite behavior; no new State
    // Model state is required because the guard is a sub-action branch of
    // an already-modeled do-action, not a new externally-observable mode.
    // SR-7 is CLOSED by this pass.
    connection : Derivation connect Scenarios::scen23_LocalControl_WiringModeMismatch to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> AssessingSimultaneousHold -> ConflictSuppressed
    // -> Idle (path updated per the State Model Review corrective pass,
    // MAJOR-1) -- closest existing structural anchor
    // (HandleConflictingMovementCommands); no dedicated wiring-mode-mismatch
    // detection state exists (SR-8 gap, per ConflictSuppressed's precedent
    // and Scenarios::SCEN_23's own doc). SR-8 remains an OPEN gap; NOT
    // addressed by this pass.
    connection : Derivation connect Scenarios::scen24_TimingProfile_PersistenceFailure_FirstPowerOn to SystemStates::logicalDiagnosticsWithState;
    // states entered: Nominal -> ConfigurationRequiredFault (gap-derived
    // TimingProfileReadFailure trigger, SR-9) -> Nominal (via ConfigureController re-run).
    connection : Derivation connect Scenarios::scen25_AutomaticOpen_LowTemperatureBoundary to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingAutomatic -> Idle (no distinct
    // temperature-related state; REQ-B-xx boundary is a Product Architecture
    // physical-limit concern orthogonal to the lifecycle state machine).

    // ---- State Model → Requirement (Phase 7: Requirement Mapping) ---------
    connection : Derivation connect L0_Requirements::Quality::easeOfInstallation to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: Uninstalled, Installing, InstallationFault.
    connection : Derivation connect L0_Requirements::Functional::fullShutterMovement to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: MovingAutomatic.
    connection : Derivation connect L0_Requirements::Functional::manualPositioning to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: MovingManual.
    connection : Derivation connect L0_Requirements::Functional::stopShutterMovement to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: the StopRequest-triggered transitions out of MovingAutomatic/MovingManual.
    connection : Derivation connect L0_Requirements::Functional::configurableTimingProfile to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: ConfigurationMode; also traces to ConfigurationRequiredFault (diagnostic machine, below).
    connection : Derivation connect L0_Requirements::Functional::configurationMode to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: ConfigurationMode, including its reentry-guard self-transition;
    // also AssessingSimultaneousHold (State Model Review corrective pass,
    // MAJOR-1 discriminator gating entry into ConfigurationMode).
    connection : Derivation connect L0_Requirements::Safety::safety to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: ConflictSuppressed (safety-relevant state, Traceability Rule 5);
    // also AssessingSimultaneousHold (State Model Review corrective pass,
    // MAJOR-1 discriminator gating entry into ConflictSuppressed).
    connection : Derivation connect L0_Requirements::Safety::conflictIndication to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: ConflictSuppressed's entry action (notifyUserAboutConflict).
    connection : Derivation connect L0_Requirements::Quality::availability to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: Unpowered -- but only as a structural placeholder; ADR_002_Availability
    // explicitly scopes out any self-healing/failover/watchdog behavior, so this
    // requirement remains only PARTIALLY represented by the state model (Phase 10 gap).
    connection : Derivation connect L0_Requirements::Environmental::regulatedDisposal to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: Disposed (TERMINAL).
    connection : Derivation connect L0_Requirements::Quality::diagnosability to SystemStates::logicalDiagnosticsWithState;
    // covers: Nominal, ClassifyingFault, NoResponseFault, MotorDriveFault, ConfigurationRequiredFault.
    connection : Derivation connect L0_Requirements::Quality::fieldReplaceability to SystemStates::logicalDiagnosticsWithState;
    // covers: Repairing.
    // GAP (Phase 7): REQ-Q-03 (reliability) and REQ-I-01/REQ-I-02 (interface
    // compatibility) have no dedicated state -- they are non-functional/
    // interface-electrical requirements verified structurally (Product
    // Architecture attributes, MTBF) rather than through any observable
    // runtime state, so no state-model connection is recorded for them.

    // ---- State Model → Architecture (Phase 8: Architecture Mapping) -------
    // The ':>' specializations on RollerShutterControllerWithLifecycle and
    // LogicalDiagnosticsWithState (SystemStates.sysml) already constitute a
    // structural Redefinition/specialization link to their Logical
    // Architecture superclasses; the explicit Derivation connections below
    // additionally record the Functional and Product Architecture owners of
    // the actions each state's entry/do/exit references, completing the
    // three-layer (Functional/Logical/Product) architecture-to-state
    // mapping Phase 8 requires.
    connection : Derivation connect LogicalArchitecture::rollerShutterControllerLogicalComponents to SystemStates::rollerShutterControllerWithLifecycle;
    connection : Derivation connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalDiagnostics to SystemStates::logicalDiagnosticsWithState;
    connection : Derivation connect FunctionalArchitecture::RollerShutterControllerFunctions::diagnosticsFunctions to SystemStates::logicalDiagnosticsWithState;
    connection : Derivation connect ProductComponents::ControlMCU::diagnosticsSoftware to SystemStates::logicalDiagnosticsWithState;
    connection : Derivation connect ProductComponents::ControlMCU::memoryManagerSoftware to SystemStates::logicalDiagnosticsWithState;
    // memoryManagerSoftware is the component whose EEPROM read failure the
    // gap-derived TimingProfileReadFailure event / ConfigurationRequiredFault
    // state structurally represents (SCEN_24).
    // CRIT-4 fix (SMRR corrective pass): memoryManagerSoftware.lastReadValid
    // is now the explicit, named producer signal for TimingProfileReadFailure
    // (see SystemStates::TimingProfileReadFailure and
    // ProductComponents::MemoryManagerSoftware doc), closing the "no
    // architectural producer" finding and making the ConfigurationRequiredFault
    // transition testable (force lastReadValid = false, observe the transition).
    connection : Derivation connect ProductArchitecture::RollerShutterControllerProductComponents::powerSupplyModule to SystemStates::rollerShutterControllerWithLifecycle;
    // CRIT-4 fix (SMRR corrective pass): PowerSupplyModule.supplyPresent is
    // now the explicit, named producer signal for PowerLost (true->false) and
    // PowerRestored (false->true) (see SystemStates::PowerLost/PowerRestored
    // and ProductComponents::PowerSupplyModule doc), closing the "no
    // architectural producer" finding and making the Unpowered transitions
    // testable (force supplyPresent to the target value, observe the
    // transition). No new self-healing/failover/watchdog behavior is
    // introduced; ADR-002's explicit scope is unchanged.
    connection : Derivation connect ProductArchitecture::rollerShutterControllerProductComponents to SystemStates::rollerShutterControllerWithLifecycle;
    connection : Derivation connect SystemProcesses::controllerLifecycle to SystemStates::rollerShutterControllerWithLifecycle;
    // ControllerLifecycle's authoritative install->configure->operate (looped)
    // ordering is the direct source of the top-level state machine's
    // Uninstalled->Installing->Idle backbone and the Idle<->ConfigurationMode cycle.

    // ---- State Model → Architecture: Cross-lifecycle event routing --------
    // (State Model Review corrective pass, MAJOR-2). CrossLifecycleEventRelay
    // (SystemStates.sysml) is the explicit, additive routing element closing
    // the previously-undefined cross-state-machine event delivery between
    // rollerShutterControllerWithLifecycle.systemLifecycle and
    // logicalDiagnosticsWithState.diagnosticLifecycle. It does not
    // redesign LogicalArchitecture or Product Architecture; both
    // connections below link it back to the two state-machine-bearing part
    // usages it routes between, preserving the "keep the two state
    // machines independent, but make event delivery explicit" instruction.
    connection : Derivation connect SystemStates::crossLifecycleEventRelay to SystemStates::rollerShutterControllerWithLifecycle;
    // routes (systemLifecycle side): PowerLost (Idle/MovingAutomatic/
    // MovingManual/ConfigurationMode -> Unpowered), PowerRestored
    // (Unpowered -> Idle).
    connection : Derivation connect SystemStates::crossLifecycleEventRelay to SystemStates::logicalDiagnosticsWithState;
    // routes (diagnosticLifecycle side): FaultReported and
    // TimingProfileReadFailure (both consumed by Nominal), and the
    // cross-machine-only use of ConfigModeEvent[deactivated] (consumed by
    // ConfigurationRequiredFault; produced by systemLifecycle's
    // ConfigurationMode). See CrossLifecycleEventRelay's own doc for the
    // complete per-event ownership/producer/consumer table.
}