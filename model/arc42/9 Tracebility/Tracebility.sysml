package Tracebility
{
    private import Requirements::*;
    private import DerivationConnections::*;

    private import SystemIdea::*;
    private import SystemObjectives::*;

    /* System Objectives are derived from System Idea. */
    connection : Derivation connect SystemIdea::systemIdea to SystemObjectives::affordability;
    connection : Derivation connect SystemIdea::systemIdea to SystemObjectives::easeOfUse;
    connection : Derivation connect SystemIdea::systemIdea to SystemObjectives::localControl;
    connection : Derivation connect SystemIdea::systemIdea to SystemObjectives::remoteControl;
    connection : Derivation connect SystemIdea::systemIdea to SystemObjectives::rollerShutterCompatibility;
    connection : Derivation connect SystemIdea::systemIdea to SystemObjectives::reliability;

    /* Requirements are derived from System Objectives. */
    /* Functional requirements */
    connection : Derivation connect SystemObjectives::localControl to L0_Requirements::Functional::localControl;
    connection : Derivation connect SystemObjectives::remoteControl to L0_Requirements::Functional::remoteControl;
    connection : Derivation connect SystemObjectives::easeOfUse to L0_Requirements::Functional::fullShutterMovement;
    connection : Derivation connect SystemObjectives::easeOfUse to L0_Requirements::Functional::manualPositioning;
    connection : Derivation connect SystemObjectives::easeOfUse to L0_Requirements::Functional::stopShutterMovement;

    /* Quality requirements */
    connection : Derivation connect SystemObjectives::easeOfUse to L0_Requirements::Quality::easeOfInstallation;
    connection : Derivation connect SystemObjectives::reliability to L0_Requirements::Quality::availability;
    connection : Derivation connect SystemObjectives::reliability to L0_Requirements::Quality::reliability;
    connection : Derivation connect SystemObjectives::reliability to L0_Requirements::Quality::safety;


    /* Constraints */
    connection : Derivation connect SystemObjectives::affordability to L0_Constraints::Business::costEffective;
    connection : Derivation connect L0_Requirements::Functional::controlRollerShutter to L0_Constraints::Electrical::supplyVoltage;
    connection : Derivation connect L0_Requirements::Functional::controlRollerShutter to L0_Constraints::Electrical::switchingLoad;
    connection : Derivation connect L0_Requirements::Quality::safety to L0_Constraints::Electrical::motorIsolation;
    connection : Derivation connect L0_Requirements::Quality::safety to L0_Constraints::Electrical::inputIsolation;
    connection : Derivation connect SystemObjectives::rollerShutterCompatibility to L0_Constraints::Architectural::noPositionFeedback;
    connection : Derivation connect SystemObjectives::rollerShutterCompatibility to L0_Constraints::Architectural::timeBasedOperation;


    /* Use case activities are derived from Use Cases. */
    connection : Derivation connect SystemUseCases::controlRollerShutter to UseCaseActivities::openShutterAutomatically;
    connection : Derivation connect SystemUseCases::controlRollerShutter to UseCaseActivities::closeShutterAutomatically;
    connection : Derivation connect SystemUseCases::controlRollerShutter to UseCaseActivities::openShutterManually;
    connection : Derivation connect SystemUseCases::controlRollerShutter to UseCaseActivities::closeShutterManually;
    connection : Derivation connect SystemUseCases::controlRollerShutter to UseCaseActivities::openShutterAutomatically;
    connection : Derivation connect SystemUseCases::controlRollerShutter to UseCaseActivities::closeShutterAutomatically;
    connection : Derivation connect SystemUseCases::controlRollerShutter to UseCaseActivities::openShutterManually;
    connection : Derivation connect SystemUseCases::controlRollerShutter to UseCaseActivities::closeShutterManually;
    connection : Derivation connect SystemUseCases::installController to UseCaseActivities::installController;
    connection : Derivation connect SystemUseCases::configureController to UseCaseActivities::configureController;

    /* Functional architecture is derived from UseCaseActivities. */

}