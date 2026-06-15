package SystemObjectives {
    private import Requirements::*;

    requirement def affordability specializes SystemIdea::WindowRollerShutterControllerIdea
    {
        subject controller : BaseArchitecture::ShutterController;

        doc
        /* The controller is affordable for any end user. */
    }

    requirement def easeOfUse specializes SystemIdea::WindowRollerShutterControllerIdea
    {
        subject controller : BaseArchitecture::ShutterController;

        doc
        /* Usage of the controller should be intuitive for all users. */
    }

    requirement def localControl specializes SystemIdea::WindowRollerShutterControllerIdea
    {
        subject controller : BaseArchitecture::ShutterController;

        doc
        /* Enable user to control roller shutter using wall switch. */
    }

    requirement def remoteControl specializes SystemIdea::WindowRollerShutterControllerIdea
    {
        subject controller : BaseArchitecture::ShutterController;

        doc
        /* Enable external system to control roller shutter. */
    }

    requirement def cooperationWithRollerShutterTypes specializes SystemIdea::WindowRollerShutterControllerIdea
    {
        subject controller : BaseArchitecture::ShutterController;
        stakeholder manufacturer : Stakeholders::Manufacturer;

        doc
        /* The controller shall support roller shutters with built in position tracking. */
    }

    requirement def reliability specializes SystemIdea::WindowRollerShutterControllerIdea
    {
        subject controller : BaseArchitecture::ShutterController;
        stakeholder manufacturer : Stakeholders::Manufacturer;

        doc
        /* The controller shall be reliable and work without any issues. */
    }
} // package SystemObjectives
