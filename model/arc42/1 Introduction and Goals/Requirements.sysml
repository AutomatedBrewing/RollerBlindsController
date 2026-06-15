package L0_Requirements {
    private import Stakeholders::*;
    private import BaseArchitecture::*;

    requirement def Functional {
        requirement def coreFunction {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder manufacturer : Stakeholders::Manufacturer;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall control window roller shutters. */

            frame user.controllerNeed;
            frame ProblemStatement::NeedOfWindowRollerShutterController;
        }

        requirement def fullShutterMovement specializes SystemObjectives::easeOfUse {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* Short press of the wallswitch moves shutter to end position - up or down, depending on
             * what button was pressed.
             */

            frame user.controllerNeed;
        }

        requirement def partialShutterMovement specializes SystemObjectives::easeOfUse {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* Long press of the wallswitch moves shutter as long as user holds the button in direction
             * of end position - up or down, depending on what button was pressed.
             */
            frame user.controllerNeed;
        }

        requirement def controlledByWallswitch specializes SystemObjectives::localControl {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The user shall be able to control the controller using wallswitch. */

            frame user.controllerNeed;
        }

        requirement def controlledByExternalSystem specializes SystemObjectives::remoteControl {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The external system shall be able to control the controller. */

            frame user.controllerNeed;
        }
    }

    requirement def Quality {
        requirement def easeOfInstallation specializes SystemObjectives::easeOfUse {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder installer : Stakeholders::Installer;
            doc
            /* The system shall enable installation and configuration by non-technical users within 30 minutes, achieving 90% success rate. */

            attribute maximumInstallationTime subsets ISQ::duration;
            require constraint {
                maximumInstallationTime <= 30 [SI::min]
            }

            frame installer.durationOfInstallation {
                redefines durationOfInstallation = maximumInstallationTime;
            }
        }

        requirement def availability specializes SystemObjectives::reliability{
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The system shall achieve 99.8% uptime. */

            attribute upTime;

            require constraint {
                upTime >= 98.8
            }
        }

        requirement def reliability specializes SystemObjectives::reliability{
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The system shall handle 10,000 operation cycles without failure. */

            attribute succesfulOperations;

            require constraint {
                succesfulOperations > 10000
            }
        }
    }
} // package L0_Requirements
