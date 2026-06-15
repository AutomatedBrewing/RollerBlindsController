package Stakeholders {
    private import Requirements::*;
    private import BaseArchitecture::*;

    part def Stakeholder {
        concern concerns [*];
    }

    /* --------------------------------------    MANUFACTURER */
    part def Manufacturer specializes Stakeholder {
        doc
        /* Entity responsible for producing the roller blind controllers. */

        concern costConcern : CostConcern [1] subsets concerns;
        concern operatingConditionsConcern : OperatingConditions [1] subsets concerns;
    }

    concern def CostConcern {
        subject controller : BaseArchitecture::ShutterController;

        attribute cost;
        require constraint {
            doc
            /* The controller shall be as cheap as possible. */
        }
    }

    concern def OperatingConditions {
        subject controller : BaseArchitecture::ShutterController;

        attribute minimalWorkingTemperature subsets ISQ::thermodynamicTemperature;
        attribute maximumWorkingTemperature subsets ISQ::thermodynamicTemperature;

        require constraint {
            doc
            /* The controller shall operate in typical outdoor conditions without malfunction. */
        }
    }

    /* --------------------------------------    USER */

    part def User specializes Stakeholder {
        doc
        /* Primary user who operates the blinds via wall switch. */

        concern controllerNeed : ShutterControllerExistance [1] subsets concerns;
        concern miminalSize : MimimalSize [1] subsets concerns;
    }

    concern def ShutterControllerExistance {
        subject controller : BaseArchitecture::ShutterController;

        require constraint {
            doc
            /* User wants a controller that controls the window shutters in convenient way 
             * from wallswitch and external system.
             */
        }
    }

    concern def MimimalSize {
        subject controller : BaseArchitecture::ShutterController;

        attribute width subsets ISQ::length;
        attribute length subsets ISQ::length;

        require constraint {
            doc
            /* Controller shall fit into typical flush-mounted junction box. */
        }
    }

    /* --------------------------------------    INSTALLER */

    part def Installer specializes Stakeholder {
        doc
        /* Professional installer who:
         * - connects controller to wallswitch, external system and power supply.
         * - configures the system during setup.
         */

        concern durationOfInstallation : DurationOfInstallation [1] subsets concerns;
        concern easeOfConfiguration : EaseOfConfiguration [1] subsets concerns;
    }

    concern def DurationOfInstallation {
        subject controller : BaseArchitecture::ShutterController;

        attribute durationOfInstallation subsets ISQ::duration;

        require constraint {
            doc
            /* Installation shall be easy and not consume a lot of time. */
        }
    }

    concern def EaseOfConfiguration {
        subject controller : BaseArchitecture::ShutterController;

        require constraint {
            doc
            /* If controller require reconfiguration, it shall be possible to perform it without diassemblying
             * the device.
             */
        }
    }
} // package Stakeholders
