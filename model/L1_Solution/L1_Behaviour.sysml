// SysML 2.0 Standard Library Imports
private import L0_System_Context::*;
private import L1_Solution_Requirements::*;


package L1_Behaviour {
    use case blindControl 
    {
        actor ShutterOperator; /* Super-user */
        actor WallSwitch :> ShutterOperator;
        actor ExternalSystem :> ShutterOperator;
        

        use case def MoveShutter 
        {
            subject controller : L0_System_Context::ShutterControllerSystem;
            actor operator : ShutterOperator;
            actor shutter : L0_System_Context::Blind;

            objective 
            {
                doc /* Moves blind to desired position. */
            }
        }   

        /* Specialized use cases */
        use case def MoveToLimit :> MoveShutter
        {
            objective 
            {
                doc /* Move to final position (fully opened or fully closed). */
                
            }
        }        
        use case def MoveToSpecificPosition :> MoveShutter
        {
            objective 
            {
                doc /* Move partially. */
            }
        }
        

        /* Usage */
        part controller : L0_System_Context::ShutterControllerSystem;
        actor user : WallSwitch;
        actor externalSystem : ExternalSystem;
        actor blind : L0_System_Context::Blind;

        // Konkretne wystąpienie przypadku użycia
        use case moveFull : MoveToLimit {
            subject = controller;
            operator = L1_Behaviour::blindControl::user;
            shutter = L1_Behaviour::blindControl::blind;
        }

        use case movePartial : MoveToSpecificPosition {
            subject = controller;
            operator = L1_Behaviour::blindControl::externalSystem;
            shutter = L1_Behaviour::blindControl::blind;
        }
    }
}