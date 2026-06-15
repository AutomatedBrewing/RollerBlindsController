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

    
}