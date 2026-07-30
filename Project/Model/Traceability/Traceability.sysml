package Traceability
{
    private import L0_Requirements::*;
    private import L0_Constraints::*;

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
    private import SystemTestCases::*;
    private import SystemStates::*;

    // Generic cross-artifact trace link: connects any two model elements
    // (requirement, use case, action, part, state, scenario, test case, ...).
    // A single, simple relation for the whole traceability matrix below.
    connection def Trace {
        end sourceElement;
        end targetElement;
    }

    /* System Objectives are derived from System Idea. */
    connection : Trace connect SystemIdea::systemIdea to SystemObjectives::affordability;
    connection : Trace connect SystemIdea::systemIdea to SystemObjectives::easeOfUse;
    connection : Trace connect SystemIdea::systemIdea to SystemObjectives::localControl;
    connection : Trace connect SystemIdea::systemIdea to SystemObjectives::remoteControl;
    connection : Trace connect SystemIdea::systemIdea to SystemObjectives::rollerShutterCompatibility;
    connection : Trace connect SystemIdea::systemIdea to SystemObjectives::reliability;
    connection : Trace connect SystemIdea::systemIdea to SystemObjectives::safety;
    /* shutterMovementControl is split from easeOfUse to give core movement capability its own objective. */
    connection : Trace connect SystemIdea::systemIdea to SystemObjectives::shutterMovementControl;

    /* Requirements are derived from System Objectives. */
    /* Functional requirements */
    connection : Trace connect SystemIdea::systemIdea to L0_Requirements::Functional::controlRollerShutter;
    connection : Trace connect SystemObjectives::localControl to L0_Requirements::Functional::localControl;
    connection : Trace connect SystemObjectives::remoteControl to L0_Requirements::Functional::remoteControl;
    connection : Trace connect SystemObjectives::shutterMovementControl to L0_Requirements::Functional::fullShutterMovement;
    connection : Trace connect SystemObjectives::shutterMovementControl to L0_Requirements::Functional::manualPositioning;
    connection : Trace connect SystemObjectives::shutterMovementControl to L0_Requirements::Functional::stopShutterMovement;
    connection : Trace connect SystemObjectives::rollerShutterCompatibility to L0_Requirements::Functional::configurableTimingProfile;
    connection : Trace connect SystemObjectives::easeOfUse to L0_Requirements::Functional::configurationMode;

    /* Interface requirements */
    connection : Trace connect SystemObjectives::localControl to L0_Requirements::Interface::wallSwitchWiringCompatibility;
    connection : Trace connect SystemObjectives::remoteControl to L0_Requirements::Interface::remoteControlWiringCompatibility;

    /* Quality requirements */
    connection : Trace connect SystemObjectives::easeOfUse to L0_Requirements::Quality::easeOfInstallation;
    connection : Trace connect SystemObjectives::reliability to L0_Requirements::Quality::availability;
    connection : Trace connect SystemObjectives::reliability to L0_Requirements::Quality::reliability;
    /* Safety requirement derives primarily from the safety objective; the reliability link is retained for backward-compatibility. */
    connection : Trace connect SystemObjectives::safety     to L0_Requirements::Safety::safety;
    connection : Trace connect SystemObjectives::reliability to L0_Requirements::Safety::safety;


    /* Constraints */
    connection : Trace connect SystemObjectives::affordability to L0_Constraints::Business::costEffective;
    connection : Trace connect SystemObjectives::affordability to L0_Constraints::Physical::compactDimensions;
    connection : Trace connect SystemObjectives::reliability   to L0_Constraints::Environmental::operatingConditions;
    connection : Trace connect L0_Requirements::Functional::controlRollerShutter to L0_Constraints::Electrical::supplyVoltage;
    connection : Trace connect L0_Requirements::Functional::controlRollerShutter to L0_Constraints::Electrical::switchingLoad;
    connection : Trace connect L0_Requirements::Safety::safety to L0_Constraints::Electrical::motorIsolation;
    connection : Trace connect L0_Requirements::Safety::safety to L0_Constraints::Electrical::inputIsolation;
    connection : Trace connect SystemObjectives::rollerShutterCompatibility to L0_Constraints::Architectural::noPositionFeedback;
    connection : Trace connect SystemObjectives::rollerShutterCompatibility to L0_Constraints::Architectural::timeBasedOperation;


    /* Risks are derived from System Idea / System Objectives (threats to the
     * objectives and design choices they embody). */
    connection : Trace connect SystemIdea::systemIdea to Risks::TechnicalRisks::Risk_PositioningDrift;
    connection : Trace connect SystemObjectives::reliability to Risks::TechnicalRisks::Risk_MotorRelayWearOut;
    connection : Trace connect SystemObjectives::rollerShutterCompatibility to Risks::TechnicalRisks::Risk_ShutterMotorTypeIncompatibility;
    connection : Trace connect SystemObjectives::easeOfUse to Risks::TechnicalRisks::Risk_MisconfigurationDuringInstall;
    connection : Trace connect SystemObjectives::localControl to Risks::IntegrationRisks::Risk_WallSwitchWiringIncompatibility;
    connection : Trace connect SystemObjectives::affordability to Risks::BusinessRisks::Risk_CostTargetExceedance;
    /* Safety risk traces to both the safety objective and the safety requirement for full coverage. */
    connection : Trace connect SystemObjectives::safety     to Risks::SafetyRisks::Risk_InsufficientGalvanicIsolation;
    connection : Trace connect SystemObjectives::reliability to Risks::SafetyRisks::Risk_InsufficientGalvanicIsolation;
    connection : Trace connect L0_Requirements::Safety::safety to Risks::SafetyRisks::Risk_InsufficientGalvanicIsolation;

    /* Risks are mitigated by Constraints / Requirements (downstream). */
    connection : Trace connect Risks::SafetyRisks::Risk_InsufficientGalvanicIsolation to L0_Constraints::Electrical::motorIsolation;
    connection : Trace connect Risks::SafetyRisks::Risk_InsufficientGalvanicIsolation to L0_Constraints::Electrical::inputIsolation;
    connection : Trace connect Risks::BusinessRisks::Risk_CostTargetExceedance to L0_Constraints::Business::costEffective;
    connection : Trace connect Risks::TechnicalRisks::Risk_ShutterMotorTypeIncompatibility to L0_Constraints::Architectural::timeBasedOperation;
    connection : Trace connect Risks::TechnicalRisks::Risk_ShutterMotorTypeIncompatibility to L0_Requirements::Functional::configurableTimingProfile;
    connection : Trace connect Risks::TechnicalRisks::Risk_MisconfigurationDuringInstall to L0_Requirements::Quality::easeOfInstallation;
    connection : Trace connect Risks::TechnicalRisks::Risk_MisconfigurationDuringInstall to L0_Requirements::Functional::configurationMode;
    connection : Trace connect Risks::TechnicalRisks::Risk_MotorRelayWearOut to L0_Requirements::Quality::reliability;
    connection : Trace connect Risks::IntegrationRisks::Risk_WallSwitchWiringIncompatibility to L0_Requirements::Interface::wallSwitchWiringCompatibility;
    connection : Trace connect Risks::TechnicalRisks::Risk_PositioningDrift to L0_Requirements::Functional::timingDriftMargin;

    /* Use case activities are derived from Use Cases; each UC_01 variant traces 1:1 to its UseCaseActivities specialization. */
    connection : Trace connect SystemUseCases::openShutterAutomatically to UseCaseActivities::openShutterAutomatically;
    connection : Trace connect SystemUseCases::closeShutterAutomatically to UseCaseActivities::closeShutterAutomatically;
    connection : Trace connect SystemUseCases::openShutterManually to UseCaseActivities::openShutterManually;
    connection : Trace connect SystemUseCases::closeShutterManually to UseCaseActivities::closeShutterManually;
    connection : Trace connect SystemUseCases::handleConflictingMovementCommands to UseCaseActivities::handleConflictingMovementCommands;
    connection : Trace connect SystemUseCases::installController to UseCaseActivities::installController;
    connection : Trace connect SystemUseCases::configureController to UseCaseActivities::configureController;
    connection : Trace connect SystemUseCases::disposeController to UseCaseActivities::disposeController;
    connection : Trace connect SystemUseCases::controlRollerShutter to UseCaseActivities::controlRollerShutter;

    /* Functional architecture is derived from UseCaseActivities. */
    connection : Trace connect UseCaseActivities::receiveControlRequest to FunctionalArchitecture::RollerShutterControllerFunctions::requestAcquisitionFunctions;
    connection : Trace connect UseCaseActivities::monitorUserInterruption to FunctionalArchitecture::RollerShutterControllerFunctions::movementSupervisionFunctions;
    connection : Trace connect UseCaseActivities::determineMovementRequest to FunctionalArchitecture::RollerShutterControllerFunctions::controlLogicFunctions;
    connection : Trace connect UseCaseActivities::controlRollerShutter to FunctionalArchitecture::rollerShutterControllerFunctions;
    connection : Trace connect UseCaseActivities::startShutterMovement to FunctionalArchitecture::RollerShutterControllerFunctions::shutterControlFunctions;
    connection : Trace connect UseCaseActivities::stopShutterMovement to FunctionalArchitecture::RollerShutterControllerFunctions::shutterControlFunctions;
    connection : Trace connect UseCaseActivities::countActionTime to FunctionalArchitecture::RollerShutterControllerFunctions::timeCountingFunctions;
    connection : Trace connect UseCaseActivities::saveCountedTime to FunctionalArchitecture::RollerShutterControllerFunctions::memoryFunctions;
    connection : Trace connect UseCaseActivities::notifyUserAboutActivationOfConfigurationMode to FunctionalArchitecture::RollerShutterControllerFunctions::userNotificationFunctions;
    connection : Trace connect UseCaseActivities::notifyUserAboutDeactivationOfConfigurationMode to FunctionalArchitecture::RollerShutterControllerFunctions::userNotificationFunctions;
    connection : Trace connect UseCaseActivities::monitorStopCondition to FunctionalArchitecture::RollerShutterControllerFunctions::movementSupervisionFunctions;
    connection : Trace connect UseCaseActivities::activateConfigurationMode to FunctionalArchitecture::RollerShutterControllerFunctions::configurationControlFunctions;
    connection : Trace connect UseCaseActivities::exitConfigurationMode to FunctionalArchitecture::RollerShutterControllerFunctions::configurationControlFunctions;
    connection : Trace connect UseCaseActivities::loadTimingProfile to FunctionalArchitecture::RollerShutterControllerFunctions::memoryFunctions;

    connection : Trace connect UseCaseActivities::rejectConfigurationModeReentry to FunctionalArchitecture::RollerShutterControllerFunctions::userNotificationFunctions;

    connection : Trace connect UseCaseActivities::checkTravelTimeInRange to FunctionalArchitecture::RollerShutterControllerFunctions::timeCountingFunctions;
    connection : Trace connect UseCaseActivities::rejectOutOfRangeCalibration to FunctionalArchitecture::RollerShutterControllerFunctions::userNotificationFunctions;

    /* Logical architecture is derived from (allocated from) the Functional Architecture.
     * requestAcquisitionFunctions derives to two Logical components (documented split, ADR-004). */
    connection : Trace connect FunctionalArchitecture::RollerShutterControllerFunctions::requestAcquisitionFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Trace connect FunctionalArchitecture::RollerShutterControllerFunctions::requestAcquisitionFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalRemoteRequestInterface;
    connection : Trace connect FunctionalArchitecture::RollerShutterControllerFunctions::requestAcquisitionFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Trace connect FunctionalArchitecture::RollerShutterControllerFunctions::controlLogicFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Trace connect FunctionalArchitecture::RollerShutterControllerFunctions::movementSupervisionFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Trace connect FunctionalArchitecture::RollerShutterControllerFunctions::shutterControlFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Trace connect FunctionalArchitecture::RollerShutterControllerFunctions::configurationControlFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Trace connect FunctionalArchitecture::RollerShutterControllerFunctions::timeCountingFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Trace connect FunctionalArchitecture::RollerShutterControllerFunctions::memoryFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Trace connect FunctionalArchitecture::RollerShutterControllerFunctions::userNotificationFunctions to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification;
    connection : Trace connect FunctionalArchitecture::rollerShutterControllerFunctions to LogicalArchitecture::rollerShutterControllerLogicalComponents;

    /* REQ-S-01 traces to its behavioral use-case counterpart (conflict suppression). */
    connection : Trace connect L0_Requirements::Safety::safety to SystemUseCases::handleConflictingMovementCommands;
    connection : Trace connect L0_Requirements::Quality::availability to SystemUseCases::controlRollerShutter;

    /* Design-to-requirement satisfaction; 'satisfy by' targets the package-level part usage, not the classifier. */
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
    /* REQ-F-09: the short/long-press threshold that REQ-F-04/REQ-F-05 both depend on. */
    satisfy L0_Requirements::Functional::pressDurationModeDiscrimination by BaseArchitecture::shutterController;
    /* REQ-F-10: timing margin mitigating RISK-T-01 (positioning drift). */
    satisfy L0_Requirements::Functional::timingDriftMargin by BaseArchitecture::shutterController;

    /* Design-to-requirement traceability — Logical Architecture (SM-PRD-20).
     * connection : Trace is used instead of satisfy because Logical components
     * don't conform to ShutterController's subject type. */
    connection : Trace connect L0_Requirements::Functional::controlRollerShutter to LogicalArchitecture::rollerShutterControllerLogicalComponents;
    connection : Trace connect L0_Requirements::Functional::localControl to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Trace connect L0_Requirements::Functional::remoteControl to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalRemoteRequestInterface;
    connection : Trace connect L0_Requirements::Functional::fullShutterMovement to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Trace connect L0_Requirements::Functional::fullShutterMovement to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Trace connect L0_Requirements::Functional::manualPositioning to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Trace connect L0_Requirements::Functional::manualPositioning to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Trace connect L0_Requirements::Functional::stopShutterMovement to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Trace connect L0_Requirements::Functional::stopShutterMovement to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Trace connect L0_Requirements::Functional::configurableTimingProfile to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Trace connect L0_Requirements::Functional::configurableTimingProfile to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Trace connect L0_Requirements::Functional::configurationMode to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Trace connect L0_Requirements::Functional::configurationMode to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification;
    connection : Trace connect L0_Requirements::Interface::wallSwitchWiringCompatibility to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Trace connect L0_Requirements::Interface::remoteControlWiringCompatibility to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalRemoteRequestInterface;
    /* REQ-F-09: short/long-press discrimination is performed identically on both request-acquisition channels. */
    connection : Trace connect L0_Requirements::Functional::pressDurationModeDiscrimination to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Trace connect L0_Requirements::Functional::pressDurationModeDiscrimination to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalRemoteRequestInterface;
    /* REQ-S-01's conflict-suppression clause is realized by logicalControlUnit's arbitration behavior;
     * galvanic isolation is a physical circuit property (not a logical function) with no Logical-layer structural counterpart. */
    connection : Trace connect L0_Requirements::Safety::safety to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;


    /* REQ-Q-02/REQ-Q-03 cross-cut both logicalControlUnit and logicalMotorDrive,
     * as availability/reliability are composite quality attributes of both components. */
    connection : Trace connect L0_Requirements::Quality::availability to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Trace connect L0_Requirements::Quality::availability to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Trace connect L0_Requirements::Quality::reliability to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Trace connect L0_Requirements::Quality::reliability to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    /* System Context traceability (SM-PRD-11). */
    connection : Trace connect SystemIdea::systemIdea to SystemContext::systemContext;
    connection : Trace connect L0_Requirements::Interface::wallSwitchWiringCompatibility to SystemContext::wallSwitch;
    connection : Trace connect L0_Requirements::Interface::remoteControlWiringCompatibility to SystemContext::homeAutomationSystem;
    connection : Trace connect L0_Constraints::Electrical::supplyVoltage to SystemContext::controlPowerSupply;
    connection : Trace connect L0_Constraints::Electrical::switchingLoad to SystemContext::mainsPowerSupply;
    connection : Trace connect Risks::IntegrationRisks::Risk_WallSwitchWiringIncompatibility to SystemContext::wallSwitch;
    connection : Trace connect SystemContext::homeAutomationSystem to SystemUseCases::controlRollerShutter;
    connection : Trace connect SystemContext::wallSwitch to SystemUseCases::controlRollerShutter;

    /* Disposal stakeholder traceability. */
    connection : Trace connect Stakeholders::disposalFacility to SystemUseCases::disposeController;
    connection : Trace connect Stakeholders::installer to SystemUseCases::installController;
    connection : Trace connect Stakeholders::installer to SystemUseCases::configureController;

    /* Environmental requirement derivation. */
    connection : Trace connect SystemObjectives::safety to L0_Requirements::Environmental::regulatedDisposal;

    /* System Processes traceability (SM-PRD-13). Each lifecycle action
     * in ControllerLifecycle is derived from the corresponding Use Case
     * (crossmapping/system-processes.md §4 rule). */
    connection : Trace connect SystemUseCases::installController        to SystemProcesses::ControllerLifecycle::install;
    connection : Trace connect SystemUseCases::configureController      to SystemProcesses::ControllerLifecycle::configure;
    connection : Trace connect SystemUseCases::controlRollerShutter     to SystemProcesses::ControllerLifecycle::operate;
    connection : Trace connect SystemUseCases::disposeController          to SystemProcesses::ControllerLifecycle::dispose;

    /* =========================================================================
     * Product Architecture traceability (SM-PRD-21).
     * connection : Trace used throughout (same reason as Logical Architecture block).
     * ========================================================================= */

    /* Logical Architecture → Product Architecture; restates LogicalToProductAllocation.sysml at the coarser traceability level. */
    connection : Trace connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Trace connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Trace connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalRemoteRequestInterface to ProductArchitecture::RollerShutterControllerProductComponents::remoteRequestInterface;
    connection : Trace connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalRemoteRequestInterface to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Trace connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;
    connection : Trace connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Trace connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit to ProductComponents::ControlMCU::movementControlSoftware;
    connection : Trace connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit to ProductComponents::ControlMCU::configurationManagerSoftware;
    connection : Trace connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit to ProductComponents::ControlMCU::memoryManagerSoftware;
    connection : Trace connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;
    connection : Trace connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Trace connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;
    connection : Trace connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Trace connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Trace connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;
    connection : Trace connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification to ProductComponents::ControlMCU::userFeedbackSoftware;
    connection : Trace connect LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalUserNotification to ProductArchitecture::RollerShutterControllerProductComponents::userNotificationBuzzer;
    connection : Trace connect LogicalArchitecture::rollerShutterControllerLogicalComponents to ProductArchitecture::rollerShutterControllerProductComponents;

    /* Design-to-requirement traceability — Product Architecture (SM-PRD-21); each requirement traces to the most directly responsible Product component(s). */
    connection : Trace connect L0_Requirements::Functional::controlRollerShutter to ProductArchitecture::rollerShutterControllerProductComponents;
    connection : Trace connect L0_Requirements::Functional::localControl to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Trace connect L0_Requirements::Functional::localControl to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Trace connect L0_Requirements::Functional::remoteControl to ProductArchitecture::RollerShutterControllerProductComponents::remoteRequestInterface;
    connection : Trace connect L0_Requirements::Functional::remoteControl to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Trace connect L0_Requirements::Functional::fullShutterMovement to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Trace connect L0_Requirements::Functional::fullShutterMovement to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Trace connect L0_Requirements::Functional::fullShutterMovement to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Trace connect L0_Requirements::Functional::manualPositioning to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Trace connect L0_Requirements::Functional::manualPositioning to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Trace connect L0_Requirements::Functional::manualPositioning to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Trace connect L0_Requirements::Functional::stopShutterMovement to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Trace connect L0_Requirements::Functional::stopShutterMovement to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Trace connect L0_Requirements::Functional::stopShutterMovement to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Trace connect L0_Requirements::Functional::configurableTimingProfile to ProductComponents::ControlMCU::memoryManagerSoftware;
    connection : Trace connect L0_Requirements::Functional::configurableTimingProfile to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Trace connect L0_Requirements::Functional::configurationMode to ProductComponents::ControlMCU::configurationManagerSoftware;
    connection : Trace connect L0_Requirements::Functional::configurationMode to ProductComponents::ControlMCU::userFeedbackSoftware;
    connection : Trace connect L0_Requirements::Functional::configurationMode to ProductArchitecture::RollerShutterControllerProductComponents::userNotificationBuzzer;
    connection : Trace connect L0_Requirements::Interface::wallSwitchWiringCompatibility to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    /* commandArbitrationSoftware holds the wiringMode attribute that performs the momentary/latching interpretation required by REQ-I-01. */
    connection : Trace connect L0_Requirements::Interface::wallSwitchWiringCompatibility to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Trace connect L0_Requirements::Interface::remoteControlWiringCompatibility to ProductArchitecture::RollerShutterControllerProductComponents::remoteRequestInterface;
    /* REQ-Q-01: ease of installation is a physical mounting/wiring concern, first traceable at the Product layer. */
    connection : Trace connect L0_Requirements::Quality::easeOfInstallation to ProductArchitecture::RollerShutterControllerProductComponents::enclosureAndConnectors;
    connection : Trace connect L0_Requirements::Quality::availability to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;
    connection : Trace connect L0_Requirements::Quality::availability to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Trace connect L0_Requirements::Quality::reliability to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;
    connection : Trace connect L0_Requirements::Quality::reliability to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    /* REQ-F-09: the 500ms short/long-press threshold is enforced by CommandArbitrationSoftware on both channels. */
    connection : Trace connect L0_Requirements::Functional::pressDurationModeDiscrimination to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Trace connect L0_Requirements::Safety::safety to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Trace connect L0_Requirements::Safety::safety to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;

    /* REQ-E-01: disposal is a physical-materials concern, first traceable to enclosureAndConnectors at the Product layer. */
    connection : Trace connect L0_Requirements::Environmental::regulatedDisposal to ProductArchitecture::RollerShutterControllerProductComponents::enclosureAndConnectors;

    /* Constraints → Product Architecture; Product Architecture is the first layer with concrete hardware for direct constraint tracing. */
    connection : Trace connect L0_Constraints::Business::costEffective to ProductArchitecture::rollerShutterControllerProductComponents;
    connection : Trace connect L0_Constraints::Physical::compactDimensions to ProductArchitecture::RollerShutterControllerProductComponents::enclosureAndConnectors;
    connection : Trace connect L0_Constraints::Environmental::operatingConditions to ProductArchitecture::RollerShutterControllerProductComponents::controlMCU;
    connection : Trace connect L0_Constraints::Environmental::operatingConditions to ProductArchitecture::RollerShutterControllerProductComponents::enclosureAndConnectors;
    connection : Trace connect L0_Constraints::Electrical::supplyVoltage to ProductArchitecture::RollerShutterControllerProductComponents::powerSupplyModule;
    connection : Trace connect L0_Constraints::Electrical::switchingLoad to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Trace connect L0_Constraints::Electrical::motorIsolation to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Trace connect L0_Constraints::Electrical::inputIsolation to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Trace connect L0_Constraints::Electrical::inputIsolation to ProductArchitecture::RollerShutterControllerProductComponents::remoteRequestInterface;
    connection : Trace connect L0_Constraints::Architectural::noPositionFeedback to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Trace connect L0_Constraints::Architectural::noPositionFeedback to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Trace connect L0_Constraints::Architectural::timeBasedOperation to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Trace connect L0_Constraints::Architectural::timeBasedOperation to ProductComponents::ControlMCU::memoryManagerSoftware;

    /* Risks → Product Architecture: direct links to the concrete Product component that structurally mitigates each risk. */
    connection : Trace connect Risks::IntegrationRisks::Risk_WallSwitchWiringIncompatibility to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Trace connect Risks::TechnicalRisks::Risk_MotorRelayWearOut to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Trace connect Risks::TechnicalRisks::Risk_PositioningDrift to ProductComponents::ControlMCU::memoryManagerSoftware;

    /* =========================================================================
     * Scenarios traceability (SM-PRD-22). Each scenario traces to its UCA path,
     * Use Case, and the Logical/Product components it exercises.
     * ========================================================================= */

    /* Scenario → Use Case Activity (the single UCA path each scenario walks). */
    connection : Trace connect Scenarios::scen01_AutomaticOpen_NormalPath to UseCaseActivities::openShutterAutomatically;
    connection : Trace connect Scenarios::scen02_AutomaticClose_NormalPath to UseCaseActivities::closeShutterAutomatically;
    connection : Trace connect Scenarios::scen03_ManualOpen_UserReleaseStop to UseCaseActivities::openShutterManually;
    connection : Trace connect Scenarios::scen03_ManualOpen_UserReleaseStop to UseCaseActivities::monitorUserInterruption;
    connection : Trace connect Scenarios::scen04_ManualClose_UserReleaseStop to UseCaseActivities::closeShutterManually;
    connection : Trace connect Scenarios::scen04_ManualClose_UserReleaseStop to UseCaseActivities::monitorUserInterruption;
    connection : Trace connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to UseCaseActivities::openShutterManually;
    connection : Trace connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to UseCaseActivities::monitorUserInterruption;
    connection : Trace connect Scenarios::scen06_AutomaticMovement_UserStopOverride to UseCaseActivities::monitorStopCondition;
    connection : Trace connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to UseCaseActivities::handleConflictingMovementCommands;
    connection : Trace connect Scenarios::scen08_RemoteCommand_HomeAutomationOpen to UseCaseActivities::openShutterAutomatically;
    connection : Trace connect Scenarios::scen09_LocalAndRemoteSimultaneous_EqualPriorityArbitration to UseCaseActivities::receiveControlRequest;
    connection : Trace connect Scenarios::scen10_InstallController_SuccessfulFirstAttempt to UseCaseActivities::installController;
    connection : Trace connect Scenarios::scen11_InstallController_WiringFault_RetrySucceeds to UseCaseActivities::installController;
    connection : Trace connect Scenarios::scen12_InstallController_RepeatedFault_TerminalReport to UseCaseActivities::installController;
    connection : Trace connect Scenarios::scen13_ConfigureController_TimingCalibration to UseCaseActivities::configureController;
    connection : Trace connect Scenarios::scen14_ConfigureController_ReentryRejected to UseCaseActivities::rejectConfigurationModeReentry;
    /* Note: no UseCaseActivities action models power-loss/recovery, so SCEN_15/16 have no UCA
     * link below (by design — power-loss/recovery is a hardware/electrical concern, ADR_002). */
    connection : Trace connect Scenarios::scen17_MechanicalJam_TimeBasedStopWithoutFeedback to UseCaseActivities::monitorStopCondition;
    connection : Trace connect Scenarios::scen21_DisposeController_EndOfLife to UseCaseActivities::disposeController;

    connection : Trace connect Scenarios::scen22_ConfigureController_InvalidCalibrationRejected to UseCaseActivities::configureController;
    /* GAP: no UseCaseActivities action models wiring-mode mismatch; handleConflictingMovementCommands is the nearest existing mechanism. */
    connection : Trace connect Scenarios::scen23_LocalControl_WiringModeMismatch to UseCaseActivities::handleConflictingMovementCommands;
    connection : Trace connect Scenarios::scen23_LocalControl_WiringModeMismatch to UseCaseActivities::receiveControlRequest;
    connection : Trace connect Scenarios::scen25_AutomaticOpen_LowTemperatureBoundary to UseCaseActivities::openShutterAutomatically;

    /* Scenario → Logical Architecture (principal components exercised). */
    connection : Trace connect Scenarios::scen01_AutomaticOpen_NormalPath to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Trace connect Scenarios::scen01_AutomaticOpen_NormalPath to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Trace connect Scenarios::scen02_AutomaticClose_NormalPath to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Trace connect Scenarios::scen02_AutomaticClose_NormalPath to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Trace connect Scenarios::scen03_ManualOpen_UserReleaseStop to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Trace connect Scenarios::scen04_ManualClose_UserReleaseStop to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Trace connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Trace connect Scenarios::scen06_AutomaticMovement_UserStopOverride to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Trace connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    // Note: no link to logicalUserNotification here — SCEN_07 fires no buzzer (buzzer scope is config-mode only, REQ-F-08).
    connection : Trace connect Scenarios::scen08_RemoteCommand_HomeAutomationOpen to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalRemoteRequestInterface;
    connection : Trace connect Scenarios::scen09_LocalAndRemoteSimultaneous_EqualPriorityArbitration to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Trace connect Scenarios::scen13_ConfigureController_TimingCalibration to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Trace connect Scenarios::scen13_ConfigureController_TimingCalibration to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Trace connect Scenarios::scen14_ConfigureController_ReentryRejected to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Trace connect Scenarios::scen15_PowerLoss_DuringMovement to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Trace connect Scenarios::scen17_MechanicalJam_TimeBasedStopWithoutFeedback to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Trace connect Scenarios::scen17_MechanicalJam_TimeBasedStopWithoutFeedback to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;

    connection : Trace connect Scenarios::scen01_AutomaticOpen_NormalPath to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Trace connect Scenarios::scen03_ManualOpen_UserReleaseStop to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Trace connect Scenarios::scen04_ManualClose_UserReleaseStop to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Trace connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Trace connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Trace connect Scenarios::scen09_LocalAndRemoteSimultaneous_EqualPriorityArbitration to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;

    connection : Trace connect Scenarios::scen22_ConfigureController_InvalidCalibrationRejected to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Trace connect Scenarios::scen22_ConfigureController_InvalidCalibrationRejected to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;
    connection : Trace connect Scenarios::scen23_LocalControl_WiringModeMismatch to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalLocalRequestInterface;
    connection : Trace connect Scenarios::scen23_LocalControl_WiringModeMismatch to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalControlUnit;
    connection : Trace connect Scenarios::scen25_AutomaticOpen_LowTemperatureBoundary to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMotorDrive;
    connection : Trace connect Scenarios::scen25_AutomaticOpen_LowTemperatureBoundary to LogicalArchitecture::RollerShutterControllerLogicalComponents::logicalMovementSupervisor;

    /* Scenario → Product Architecture (principal components exercised). */
    connection : Trace connect Scenarios::scen01_AutomaticOpen_NormalPath to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Trace connect Scenarios::scen01_AutomaticOpen_NormalPath to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Trace connect Scenarios::scen02_AutomaticClose_NormalPath to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Trace connect Scenarios::scen02_AutomaticClose_NormalPath to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Trace connect Scenarios::scen03_ManualOpen_UserReleaseStop to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Trace connect Scenarios::scen04_ManualClose_UserReleaseStop to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Trace connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Trace connect Scenarios::scen06_AutomaticMovement_UserStopOverride to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Trace connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to ProductComponents::ControlMCU::commandArbitrationSoftware;
    // Note: no link to userFeedbackSoftware/userNotificationBuzzer — SCEN_07 fires no buzzer.
    connection : Trace connect Scenarios::scen08_RemoteCommand_HomeAutomationOpen to ProductArchitecture::RollerShutterControllerProductComponents::remoteRequestInterface;
    connection : Trace connect Scenarios::scen09_LocalAndRemoteSimultaneous_EqualPriorityArbitration to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Trace connect Scenarios::scen10_InstallController_SuccessfulFirstAttempt to ProductArchitecture::rollerShutterControllerProductComponents;
    connection : Trace connect Scenarios::scen10_InstallController_SuccessfulFirstAttempt to ProductArchitecture::RollerShutterControllerProductComponents::enclosureAndConnectors;
    connection : Trace connect Scenarios::scen11_InstallController_WiringFault_RetrySucceeds to ProductArchitecture::RollerShutterControllerProductComponents::enclosureAndConnectors;
    connection : Trace connect Scenarios::scen12_InstallController_RepeatedFault_TerminalReport to ProductArchitecture::RollerShutterControllerProductComponents::enclosureAndConnectors;
    connection : Trace connect Scenarios::scen13_ConfigureController_TimingCalibration to ProductComponents::ControlMCU::configurationManagerSoftware;
    connection : Trace connect Scenarios::scen13_ConfigureController_TimingCalibration to ProductComponents::ControlMCU::memoryManagerSoftware;
    connection : Trace connect Scenarios::scen14_ConfigureController_ReentryRejected to ProductComponents::ControlMCU::configurationManagerSoftware;
    /* SCEN_15/SCEN_16: traced only to the passive hardware fail-safe path
     * and to the availability-scope ADR, per the confirmed UCA gap above. */
    connection : Trace connect Scenarios::scen15_PowerLoss_DuringMovement to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;
    connection : Trace connect Scenarios::scen15_PowerLoss_DuringMovement to ProductArchitecture::RollerShutterControllerProductComponents::powerSupplyModule;
    connection : Trace connect Scenarios::scen16_PowerRecovery_AfterOutage to ProductArchitecture::RollerShutterControllerProductComponents::powerSupplyModule;
    connection : Trace connect Scenarios::scen16_PowerRecovery_AfterOutage to ProductComponents::ControlMCU::memoryManagerSoftware;
    connection : Trace connect Scenarios::scen17_MechanicalJam_TimeBasedStopWithoutFeedback to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Trace connect Scenarios::scen17_MechanicalJam_TimeBasedStopWithoutFeedback to ProductComponents::ControlMCU::movementSupervisorSoftware;
    connection : Trace connect Scenarios::scen21_DisposeController_EndOfLife to ProductArchitecture::RollerShutterControllerProductComponents::enclosureAndConnectors;

    connection : Trace connect Scenarios::scen01_AutomaticOpen_NormalPath to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Trace connect Scenarios::scen03_ManualOpen_UserReleaseStop to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Trace connect Scenarios::scen04_ManualClose_UserReleaseStop to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Trace connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Trace connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Trace connect Scenarios::scen09_LocalAndRemoteSimultaneous_EqualPriorityArbitration to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;

    /* movementControlSoftware sits on SCEN_01/02's primary movement pipeline but had no Traceability endpoint. */
    connection : Trace connect Scenarios::scen01_AutomaticOpen_NormalPath to ProductComponents::ControlMCU::movementControlSoftware;
    connection : Trace connect Scenarios::scen02_AutomaticClose_NormalPath to ProductComponents::ControlMCU::movementControlSoftware;

    /* commandArbitrationSoftware and motorDriveControlSoftware are traversed by every primary-path command and motor decision. */
    connection : Trace connect Scenarios::scen01_AutomaticOpen_NormalPath to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Trace connect Scenarios::scen02_AutomaticClose_NormalPath to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Trace connect Scenarios::scen03_ManualOpen_UserReleaseStop to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Trace connect Scenarios::scen04_ManualClose_UserReleaseStop to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Trace connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Trace connect Scenarios::scen06_AutomaticMovement_UserStopOverride to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Trace connect Scenarios::scen08_RemoteCommand_HomeAutomationOpen to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Trace connect Scenarios::scen01_AutomaticOpen_NormalPath to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Trace connect Scenarios::scen02_AutomaticClose_NormalPath to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Trace connect Scenarios::scen03_ManualOpen_UserReleaseStop to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Trace connect Scenarios::scen04_ManualClose_UserReleaseStop to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Trace connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Trace connect Scenarios::scen06_AutomaticMovement_UserStopOverride to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Trace connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Trace connect Scenarios::scen08_RemoteCommand_HomeAutomationOpen to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Trace connect Scenarios::scen09_LocalAndRemoteSimultaneous_EqualPriorityArbitration to ProductComponents::ControlMCU::motorDriveControlSoftware;

    connection : Trace connect Scenarios::scen22_ConfigureController_InvalidCalibrationRejected to ProductComponents::ControlMCU::configurationManagerSoftware;
    connection : Trace connect Scenarios::scen22_ConfigureController_InvalidCalibrationRejected to ProductComponents::ControlMCU::memoryManagerSoftware;
    connection : Trace connect Scenarios::scen23_LocalControl_WiringModeMismatch to ProductArchitecture::RollerShutterControllerProductComponents::localRequestInterface;
    connection : Trace connect Scenarios::scen23_LocalControl_WiringModeMismatch to ProductComponents::ControlMCU::commandArbitrationSoftware;
    connection : Trace connect Scenarios::scen25_AutomaticOpen_LowTemperatureBoundary to ProductComponents::ControlMCU::motorDriveControlSoftware;
    connection : Trace connect Scenarios::scen25_AutomaticOpen_LowTemperatureBoundary to ProductArchitecture::RollerShutterControllerProductComponents::motorDriveRelayModule;

    /* Scenario → Stakeholders. */
    connection : Trace connect Scenarios::scen01_AutomaticOpen_NormalPath to SystemContext::wallSwitch;
    connection : Trace connect Scenarios::scen02_AutomaticClose_NormalPath to SystemContext::homeAutomationSystem;
    connection : Trace connect Scenarios::scen08_RemoteCommand_HomeAutomationOpen to SystemContext::homeAutomationSystem;
    connection : Trace connect Scenarios::scen21_DisposeController_EndOfLife to Stakeholders::disposalFacility;

    connection : Trace connect Scenarios::scen10_InstallController_SuccessfulFirstAttempt to Stakeholders::installer;
    connection : Trace connect Scenarios::scen11_InstallController_WiringFault_RetrySucceeds to Stakeholders::installer;
    connection : Trace connect Scenarios::scen12_InstallController_RepeatedFault_TerminalReport to Stakeholders::installer;
    connection : Trace connect Scenarios::scen13_ConfigureController_TimingCalibration to Stakeholders::installer;
    connection : Trace connect Scenarios::scen14_ConfigureController_ReentryRejected to Stakeholders::installer;

    connection : Trace connect Scenarios::scen22_ConfigureController_InvalidCalibrationRejected to Stakeholders::installer;
    connection : Trace connect Scenarios::scen23_LocalControl_WiringModeMismatch to Stakeholders::installer;
    connection : Trace connect Scenarios::scen25_AutomaticOpen_LowTemperatureBoundary to Stakeholders::manufacturer;

    connection : Trace connect Scenarios::scen03_ManualOpen_UserReleaseStop to Stakeholders::user;
    connection : Trace connect Scenarios::scen04_ManualClose_UserReleaseStop to Stakeholders::user;
    connection : Trace connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to Stakeholders::user;
    connection : Trace connect Scenarios::scen06_AutomaticMovement_UserStopOverride to Stakeholders::user;
    connection : Trace connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to Stakeholders::user;
    connection : Trace connect Scenarios::scen09_LocalAndRemoteSimultaneous_EqualPriorityArbitration to Stakeholders::user;
    connection : Trace connect Scenarios::scen15_PowerLoss_DuringMovement to Stakeholders::user;
    connection : Trace connect Scenarios::scen16_PowerRecovery_AfterOutage to Stakeholders::user;
    connection : Trace connect Scenarios::scen17_MechanicalJam_TimeBasedStopWithoutFeedback to Stakeholders::user;

    /* =========================================================================
     * Scenario → Test Case (SM-PRD-22). Each scenario is linked to its
     * corresponding test case; confirmed gaps are noted with '// GAP:'.
     * ========================================================================= */
    connection : Trace connect Scenarios::scen01_AutomaticOpen_NormalPath to SystemTestCases::tc_F_006_automaticFullOpen;
    connection : Trace connect Scenarios::scen02_AutomaticClose_NormalPath to SystemTestCases::tc_F_007_automaticFullClose;
    connection : Trace connect Scenarios::scen03_ManualOpen_UserReleaseStop to SystemTestCases::tc_F_008_manualPartialOpen;
    connection : Trace connect Scenarios::scen04_ManualClose_UserReleaseStop to SystemTestCases::tc_F_009_manualPartialClose;
    connection : Trace connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to SystemTestCases::tc_N_001_manualMode_safetyTimeout;
    connection : Trace connect Scenarios::scen06_AutomaticMovement_UserStopOverride to SystemTestCases::tc_F_010_stopDuringOpening;
    connection : Trace connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to SystemTestCases::tc_S_001_conflictSuppression_localUPDOWN;
    connection : Trace connect Scenarios::scen08_RemoteCommand_HomeAutomationOpen to SystemTestCases::tc_F_004_remoteControl_UP;
    connection : Trace connect Scenarios::scen09_LocalAndRemoteSimultaneous_EqualPriorityArbitration to SystemTestCases::tc_S_002_conflictSuppression_localRemote;
    connection : Trace connect Scenarios::scen10_InstallController_SuccessfulFirstAttempt to SystemTestCases::tc_Q_001_installationTime;
    connection : Trace connect Scenarios::scen11_InstallController_WiringFault_RetrySucceeds to SystemTestCases::tc_N_003_installation_wiringRetry;
    connection : Trace connect Scenarios::scen12_InstallController_RepeatedFault_TerminalReport to SystemTestCases::tc_N_006_installationFailureTerminalFault;
    connection : Trace connect Scenarios::scen13_ConfigureController_TimingCalibration to SystemTestCases::tc_F_012_configurableTimingProfile_nominal;
    connection : Trace connect Scenarios::scen14_ConfigureController_ReentryRejected to SystemTestCases::tc_N_002_configMode_reentryRejected;
    connection : Trace connect Scenarios::scen15_PowerLoss_DuringMovement to SystemTestCases::tc_Q_002_operationalAvailability;
    connection : Trace connect Scenarios::scen16_PowerRecovery_AfterOutage to SystemTestCases::tc_Q_002_operationalAvailability;
    connection : Trace connect Scenarios::scen17_MechanicalJam_TimeBasedStopWithoutFeedback to SystemTestCases::tc_N_004_noPositionFeedback_timeBased;
    connection : Trace connect Scenarios::scen21_DisposeController_EndOfLife to SystemTestCases::tc_E_001_disposalCompliance;
    connection : Trace connect Scenarios::scen22_ConfigureController_InvalidCalibrationRejected to SystemTestCases::tc_B_003_timingProfile_maxBoundary;
    connection : Trace connect Scenarios::scen23_LocalControl_WiringModeMismatch to SystemTestCases::tc_N_005_wiringModeMismatch_detected;
    connection : Trace connect Scenarios::scen25_AutomaticOpen_LowTemperatureBoundary to SystemTestCases::tc_B_004_operatingTemp_lowerBoundary;

    /* =========================================================================
     * State Model (SM-PRD-23) traceability block. Each connection links to the
     * package-level state-machine part; inline comments name the states exercised.
     * ========================================================================= */

    // ---- State Model → Scenario (Phase 6: Scenario Mapping) ----------------
    // Every scenario that exercises the top-level lifecycle machine.
    connection : Trace connect Scenarios::scen01_AutomaticOpen_NormalPath to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingAutomatic -> Idle.
    connection : Trace connect Scenarios::scen02_AutomaticClose_NormalPath to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingAutomatic -> Idle.
    connection : Trace connect Scenarios::scen03_ManualOpen_UserReleaseStop to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingManual -> Idle.
    connection : Trace connect Scenarios::scen04_ManualClose_UserReleaseStop to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingManual -> Idle.
    connection : Trace connect Scenarios::scen05_ManualHold_SafetyTimeoutStop to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingManual -> Idle (StopRequest[reason=timeout]).
    // Guard's structural owner: CommandArbitrationSoftware (TC_N_001; see SystemStates.sysml MovingManual doc).
    connection : Trace connect Scenarios::scen06_AutomaticMovement_UserStopOverride to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingAutomatic -> Idle (StopRequest[reason=userRequest]).
    connection : Trace connect Scenarios::scen07_ConflictingUpDownCommand_Suppressed to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> AssessingSimultaneousHold -> ConflictSuppressed -> Idle.
    connection : Trace connect Scenarios::scen08_RemoteCommand_HomeAutomationOpen to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingAutomatic -> Idle (remote-origin ControlCommand).
    connection : Trace connect Scenarios::scen09_LocalAndRemoteSimultaneous_EqualPriorityArbitration to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingAutomatic -> Idle (equal-priority stop from either channel).
    connection : Trace connect Scenarios::scen10_InstallController_SuccessfulFirstAttempt to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Uninstalled -> Installing -> Idle.
    connection : Trace connect Scenarios::scen11_InstallController_WiringFault_RetrySucceeds to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Uninstalled -> Installing -> Idle (single bounded retry inside InstallController).
    connection : Trace connect Scenarios::scen12_InstallController_RepeatedFault_TerminalReport to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Uninstalled -> Installing -> InstallationFault (TERMINAL).
    connection : Trace connect Scenarios::scen13_ConfigureController_TimingCalibration to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> AssessingSimultaneousHold -> ConfigurationMode -> Idle.
    connection : Trace connect Scenarios::scen14_ConfigureController_ReentryRejected to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> ConfigurationMode -> ConfigurationMode (reentry self-transition) -> Idle.
    connection : Trace connect Scenarios::scen15_PowerLoss_DuringMovement to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: MovingAutomatic/MovingManual -> Unpowered (gap-derived PowerLost trigger; see Unpowered's doc).
    connection : Trace connect Scenarios::scen16_PowerRecovery_AfterOutage to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Unpowered -> Idle (gap-derived PowerRestored trigger; see Unpowered's doc).
    connection : Trace connect Scenarios::scen17_MechanicalJam_TimeBasedStopWithoutFeedback to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingAutomatic -> Idle (indistinguishable from normal-completion; no Jammed state per ADR-003).
    connection : Trace connect Scenarios::scen21_DisposeController_EndOfLife to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> Disposed (TERMINAL).
    connection : Trace connect Scenarios::scen22_ConfigureController_InvalidCalibrationRejected to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> AssessingSimultaneousHold -> ConfigurationMode -> Idle.
    connection : Trace connect Scenarios::scen23_LocalControl_WiringModeMismatch to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> AssessingSimultaneousHold -> ConflictSuppressed -> Idle.
    // GAP: no dedicated wiring-mode-mismatch detection state; ConflictSuppressed is the closest anchor.
    connection : Trace connect Scenarios::scen25_AutomaticOpen_LowTemperatureBoundary to SystemStates::rollerShutterControllerWithLifecycle;
    // states entered: Idle -> MovingAutomatic -> Idle (no temperature-specific state; boundary is a Product Architecture physical concern).

    // ---- State Model → Requirement (Phase 7: Requirement Mapping) ---------
    connection : Trace connect L0_Requirements::Quality::easeOfInstallation to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: Uninstalled, Installing, InstallationFault.
    connection : Trace connect L0_Requirements::Functional::fullShutterMovement to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: MovingAutomatic.
    connection : Trace connect L0_Requirements::Functional::manualPositioning to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: MovingManual.
    connection : Trace connect L0_Requirements::Functional::stopShutterMovement to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: the StopRequest-triggered transitions out of MovingAutomatic/MovingManual.
    connection : Trace connect L0_Requirements::Functional::configurableTimingProfile to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: ConfigurationMode.
    connection : Trace connect L0_Requirements::Functional::configurationMode to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: ConfigurationMode (including reentry-guard self-transition) and AssessingSimultaneousHold.
    connection : Trace connect L0_Requirements::Functional::pressDurationModeDiscrimination to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: AssessingSimultaneousHold and every MovingAutomatic/
    // MovingManual short/long-press discrimination (REQ-F-09).
    connection : Trace connect L0_Requirements::Safety::safety to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: ConflictSuppressed, AssessingSimultaneousHold, and equal-priority stop transitions (REQ-F-06).
    connection : Trace connect L0_Requirements::Quality::availability to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: Unpowered (structural placeholder only; ADR_002 scopes out self-healing behavior).
    connection : Trace connect L0_Requirements::Environmental::regulatedDisposal to SystemStates::rollerShutterControllerWithLifecycle;
    // covers: Disposed (TERMINAL).
    // GAP: REQ-Q-03 and REQ-I-01/02 have no dedicated state; they are verified structurally, not by observable runtime state.

    // ---- State Model → Architecture (Phase 8: Architecture Mapping) -------
    // Trace connections record the Functional, Logical, and Product Architecture
    // owners of the actions each state's entry/do/exit references.
    connection : Trace connect LogicalArchitecture::rollerShutterControllerLogicalComponents to SystemStates::rollerShutterControllerWithLifecycle;
    connection : Trace connect ProductArchitecture::RollerShutterControllerProductComponents::powerSupplyModule to SystemStates::rollerShutterControllerWithLifecycle;
    // PowerSupplyModule.supplyPresent is the named producer for PowerLost/PowerRestored state transitions.
    connection : Trace connect ProductArchitecture::rollerShutterControllerProductComponents to SystemStates::rollerShutterControllerWithLifecycle;
    connection : Trace connect SystemProcesses::controllerLifecycle to SystemStates::rollerShutterControllerWithLifecycle;
    // ControllerLifecycle's install->configure->operate ordering is the source of the Uninstalled->Installing->Idle backbone.

    // ---- State Model → Architecture: Cross-lifecycle event routing --------
    // CrossLifecycleEventRelay routes PowerLost/PowerRestored from powerSupplyModule into the lifecycle state machine.
    connection : Trace connect SystemStates::crossLifecycleEventRelay to SystemStates::rollerShutterControllerWithLifecycle;
    // routes: PowerLost (any active Operational sub-state -> Unpowered), PowerRestored (Unpowered -> Operational).

    // ---- Software Architecture (SWA-0x) traceability -----------------------
    // ADRs/constraints below Product Architecture are cited by ID in prose
    // throughout Architecture/software/ (same convention as ADR_001-008,
    // which are likewise not Trace-connected here); only elements with a
    // genuine, checkable counterpart already traced above are linked below.
    private import SWRuntimeScenarios::*;
    private import SWEventCatalog::*;
    private import SWResourceBudget::*;

    connection : Trace connect SWRuntimeScenarios::RSCEN_01_DebouncedInput_ToArbitratedCommand to Scenarios::scen01_AutomaticOpen_NormalPath;
    connection : Trace connect SWRuntimeScenarios::RSCEN_02_SimultaneousUpDown_ConflictDetectedAndSuppressed to Scenarios::scen07_ConflictingUpDownCommand_Suppressed;
    connection : Trace connect SWRuntimeScenarios::RSCEN_03_SupervisionTimerTick_AutomaticTimeoutStop to Scenarios::scen01_AutomaticOpen_NormalPath;
    // RSCEN_01-03 elaborate the cited Scenarios at firmware-execution detail (superloop/ISR/dispatcher level).

    connection : Trace connect SWEventCatalog::DebouncedInputChanged to SystemStates::rollerShutterControllerWithLifecycle;
    connection : Trace connect SWEventCatalog::TimerTick to SystemStates::rollerShutterControllerWithLifecycle;
    // The 2 firmware-level events extending the 6 already-traced SystemStates events (EventCatalogMeta).

    connection : Trace connect SWResourceBudget::resourceBudgetReport to ProductComponents::ControlMCU;
    // Authoritative flash/RAM footprint check against the same mcu the 7 firmware modules are hosted on.
}