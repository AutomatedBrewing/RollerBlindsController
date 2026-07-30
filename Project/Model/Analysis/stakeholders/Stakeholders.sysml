package Stakeholders {
    private import BaseArchitecture::*;
    private import ISQ::*;

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

        concern controllerNeed : ShutterControllerExistence [1] subsets concerns;
        concern minimalSize : MinimalSize [1] subsets concerns;
        concern availabilityConcern : Availability [1] subsets concerns;
        concern reliabilityConcern : Reliability [1] subsets concerns;
        concern safetyConcern : SafetyConcern [1] subsets concerns;
    }

    concern def ShutterControllerExistence {
        subject controller : BaseArchitecture::ShutterController;

        require constraint {
            doc
            /* User wants a controller that controls the window shutters in convenient way 
             * from wallswitch and external system.
             */
        }
    }

    concern def MinimalSize {
        subject controller : BaseArchitecture::ShutterController;

        attribute width subsets ISQ::length;
        attribute length subsets ISQ::length;
        attribute height subsets ISQ::length;

        require constraint {
            doc
            /* Controller shall fit into typical ⌀60 flush-mounted junction box. */
        }
    }

    concern def Availability {
        subject controller : BaseArchitecture::ShutterController;

        require constraint {
            doc
            /* The controller shall execute any valid control request without requiring the user to retry or intervene. */
        }
    }

    concern def Reliability {
        subject controller : BaseArchitecture::ShutterController;

        require constraint {
            doc
            /* The controller shall operate correctly across the thousands of open/close cycles expected over its operational lifetime. */
        }
    }

    concern def SafetyConcern {
        subject controller : BaseArchitecture::ShutterController;

        require constraint {
            doc
            /* All user-accessible interfaces shall be safe to touch, with no exposure to hazardous mains-referenced voltage. */
        }
    }

    /* --------------------------------------    INSTALLER */

    part def Installer specializes Stakeholder {
        doc
        /* Professional installer who connects and configures the controller during setup. */

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
            /* If controller require reconfiguration, it shall be possible to perform it without disassembling
             * the device.
             */
        }
    }

    /* --------------------------------------    DISPOSAL FACILITY */

    part def DisposalFacility specializes Stakeholder {
        doc
        /* Entity responsible for end-of-life disposal/recycling of the controller (mains-voltage electronic waste). */

        concern regulatedDisposability : RegulatedDisposability [1] subsets concerns;
    }

    concern def RegulatedDisposability {
        subject controller : BaseArchitecture::ShutterController;

        require constraint {
            doc
            /* The controller shall comply with applicable electronic-waste and hazardous-substance regulations (e.g. WEEE, RoHS). */
        }
    }

    /* Package-level usages providing named feature endpoints for traceability
     * connections (SysML v2 requires features, not classifier definitions). */
    part disposalFacility      : DisposalFacility;
    part installer   : Installer;
    part manufacturer : Manufacturer;
    part user : User;
} // package Stakeholders
