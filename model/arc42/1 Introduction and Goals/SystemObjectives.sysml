package SystemObjectives {
    private import Requirements::*;

    comment
    /* The System Objectives represent the main objectives of the
     * vendor or owner of the system.
     */

    requirement affordability {
        subject controller : BaseArchitecture::ShutterController;

        doc
        /* The controller is affordable for any end user. */
    }

    requirement easeOfUse {
        subject controller : BaseArchitecture::ShutterController;

        doc
        /* Usage of the controller should be intuitive for all users. */
    }

    requirement localControl {
        subject controller : BaseArchitecture::ShutterController;

        doc
        /* Provide local operability. */
    }

    requirement remoteControl {
        subject controller : BaseArchitecture::ShutterController;

        doc
        /* Enable integration with smart home ecosystems. */
    }

    requirement rollerShutterCompatibility {
        subject controller : BaseArchitecture::ShutterController;
        stakeholder manufacturer : Stakeholders::Manufacturer;

        doc
        /* Support a wide range of roller shutter systems. */
    }

    requirement reliability {
        subject controller : BaseArchitecture::ShutterController;
        stakeholder manufacturer : Stakeholders::Manufacturer;

        doc
        /* Provide a highly reliable controller. */
    }
} // package SystemObjectives
