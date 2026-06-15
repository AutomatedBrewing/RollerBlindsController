package L1_Solution_Requirements {
    // SysML 2.0 Standard Library Imports
    private import Requirements::*;
    private import L0_Stakeholders::*;
    private import L0_System_Context::*;
    private import L0_Business_Requirements::*;

    // REQUIREMENTS

    requirement functionalRequirements
    {
        requirement wallSwitchCooperation
        {
            requirement wallSwitchControl 
            {
                doc /* The system shall respond to wall switch button presses for blind control. */
                subject controller : L0_System_Context::ShutterControllerSystem;
                refinement : L0_Business_Requirements::coreFunction;
            }

            requirement shortWallSwitchButtonPress 
            {
                doc /* The system shall move blind to fully open or closed position when button is pressed briefly. */
                subject controller : L0_System_Context::ShutterControllerSystem;
                refinement :  L0_Business_Requirements::coreFunction;
            }

            requirement longWallSwitchButtonPress 
            {
                doc /* The system shall move blind continuously while button is held and stop when button is released */
                subject controller : L0_System_Context::ShutterControllerSystem;
                refinement :  L0_Business_Requirements::coreFunction;
            }

            requirement bothWallSwitchButtonPress 
            {
                doc /* The system shall enter configuration mode when both UP and DOWN buttons are pressed simultaneously for longer than 5 seconds */
                subject controller : L0_System_Context::ShutterControllerSystem;
                refinement :  L0_Business_Requirements::easeOfInstallation;
                refinement :  L0_Business_Requirements::coreFunction;
            }
        }


        requirement externalSystemCooperation
        {
            requirement externalSystemControl 
            {
                doc /* The system shall respond to external systems for blind control. */
                subject controller : L0_System_Context::ShutterControllerSystem;
                refinement :  L0_Business_Requirements::coreFunction;
            }

            requirement shortActivityOfExternalSignal
            {
                doc /* The system shall move blind to fully open or closed position when external signal is active shortly (less than 0.5 seconds). */
                subject controller : L0_System_Context::ShutterControllerSystem;
                refinement :  L0_Business_Requirements::coreFunction;
            }

            requirement longActivityOfExternalSignal 
            {
                doc /* The system shall move blind continuously while external signal is active long (more than 0.5 seconds) and stop when signal changes to inactive. */
                subject controller : L0_System_Context::ShutterControllerSystem;
                refinement :  L0_Business_Requirements::coreFunction;
            }
        }

        requirement signalSourcePrioritization
        {
            doc /* The system shall prioritize local wall switch commands over external system commands. */
            subject controller : L0_System_Context::ShutterControllerSystem;
            refinement :  L0_Business_Requirements::coreFunction;
        }


        requirement blindCooperation
        {
            requirement motorControl
            {
                doc /* The system shall control AC/DC motor direction for blind movement. */
                subject controller : L0_System_Context::ShutterControllerSystem;
                refinement :  L0_Business_Requirements::coreFunction;
            }    

            requirement supportedBlindTypes
            {
                doc /* The system shall operate without feedback from blind position sensors. */
                subject controller : L0_System_Context::ShutterControllerSystem;
                refinement :  L0_Business_Requirements::coreFunction;
            }    
        }

        requirement configuration
        {
            requirement timeMeasurement
            {
                doc /* The system shall measure and store the time required for full UP and DOWN blind movement during configuration. */
                subject controller : L0_System_Context::ShutterControllerSystem;
                refinement :  L0_Business_Requirements::easeOfInstallation;
                refinement :  L0_Business_Requirements::coreFunction;
            }
        }

        requirement operatingEnvironment
        {
            requirement operatingTemperature
            {
                doc /* The system shall operate continously in temperature range of -20 - 40°C. */
                subject controller : L0_System_Context::ShutterControllerSystem;
                refinement :  L0_Business_Requirements::operatingEnvironment;
            }   

            requirement operatingHumidity
            {
                doc /* The system shall operate continously in relative humidity range of 0-90%RH. */
                subject controller : L0_System_Context::ShutterControllerSystem;
                refinement :  L0_Business_Requirements::operatingEnvironment;
            }   
        }
    }



    /* NON-FUNCTIONAL REQUIREMENTS */
    requirement nonFunctionalRequirements 
    {
        requirement installation 
        {
            requirement terminalDescription
            {
                doc /* The system shall have briefly and clearly described terminals for wires. */
                subject controller : L0_System_Context::ShutterControllerSystem;
                refinement :  L0_Business_Requirements::easeOfInstallation;
            }   

            requirement supportedWireDiameters
            {
                doc /* The system shall have terminals suited for wires of diamater in range of 0.5mm - 1.5mm. */
                subject controller : L0_System_Context::ShutterControllerSystem;
                refinement :  L0_Business_Requirements::easeOfInstallation;
            }   

            requirement compactSize
            {
                doc /* The system fully assembled with connected terminals shall fit into typical Ø60mm electrical junction box.  */
                subject controller : L0_System_Context::ShutterControllerSystem;
                refinement :  L0_Business_Requirements::easeOfInstallation;
            }   
        }
    }
}