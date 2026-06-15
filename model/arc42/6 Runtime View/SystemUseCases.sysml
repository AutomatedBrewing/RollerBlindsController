package SystemUseCases
{
    private import BaseArchitecture::*;
    private import Stakeholders::*;

    /* Users use cases. */

    use case openShutter
    {
        subject controller : BaseArchitecture::ShutterController;
        actor user : Stakeholders::User;
        actor externalSystem : SystemContext::ExternalSystem;

        objective
        {
            doc /* Open the window roller shutter. */
            //require L0_Requirements::Functional::fullShutterMovement;
        }

    }
}