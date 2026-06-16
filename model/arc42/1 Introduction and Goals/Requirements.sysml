package L0_Requirements {
    private import Stakeholders::*;
    private import BaseArchitecture::*;
    private import DerivationConnections::*;
    private import SystemObjectives::*;

    requirement Functional {
        requirement controlRollerShutter {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder manufacturer : Stakeholders::Manufacturer;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall control the movement of window roller shutters. */

            frame user.controllerNeed;
            frame ProblemStatement::NeedOfWindowRollerShutterController;
        }

        requirement localControl {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall support local control of the shutter. */

            frame user.controllerNeed;
        }

        requirement remoteControl {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall support remote control of the shutter. */

            frame user.controllerNeed;
        }

        requirement fullShutterMovement {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall allow automatic movement of the shutter to a fully open or fully closed position. */

            frame user.controllerNeed;
        }

        requirement manualPositioning {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall allow positioning of the shutter between the fully open and fully closed positions. */

            frame user.controllerNeed;
        }

        requirement stopShutterMovement {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall stop the shutter movement upon user or external system request. */

            frame user.controllerNeed;
        }
    }

    requirement Quality {
        requirement easeOfInstallation {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder installer : Stakeholders::Installer;
            doc
            /* A first-time installer shall be able to install and configure the controller within 30 minutes. */

            attribute maximumInstallationTime subsets ISQ::duration;
            require constraint {
                maximumInstallationTime <= 30 [SI::min]
            }

            frame installer.durationOfInstallation {
                redefines durationOfInstallation = maximumInstallationTime;
            }
        }

        requirement availability {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall achieve at least 99.8% operational availability. */

            attribute upTime;

            require constraint {
                upTime >= 99.8
            }
        }

        requirement reliability {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall perform at least 10,000 shutter operation cycles without failure. */

            attribute succesfulOperations;

            require constraint {
                succesfulOperations >= 10000
            }
        }

        requirement safety {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall not cause any harm to the user or controlled window roller shutter. */
        }
    }
} // package L0_Requirements
