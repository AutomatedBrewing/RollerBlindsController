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
        concern conflictIndicationConcern : ConflictIndicationConcern [1] subsets concerns;
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

    // Part C-1 fix: backs REQ-Q-02 availability's 'frame user.availabilityConcern'.
    concern def Availability {
        subject controller : BaseArchitecture::ShutterController;

        require constraint {
            doc
            /* User wants the controller to be available and successfully
             * execute a valid control request whenever operated, without
             * requiring the user to retry or intervene. */
        }
    }

    // Part C-1 fix: backs REQ-Q-03 reliability's 'frame user.reliabilityConcern'.
    concern def Reliability {
        subject controller : BaseArchitecture::ShutterController;

        require constraint {
            doc
            /* User wants the controller to keep working correctly, without
             * failure, over the many thousands of daily open/close cycles
             * expected over the product's operational lifetime. */
        }
    }

    // Part C-1 fix: backs REQ-S-01 safety's 'frame user.safetyConcern'.
    concern def SafetyConcern {
        subject controller : BaseArchitecture::ShutterController;

        require constraint {
            doc
            /* User wants all user-accessible interfaces of the controller to
             * be safe to touch, with no exposure to hazardous mains-referenced
             * voltage during normal use or installation. */
        }
    }

    // Part C-1 fix: backs REQ-S-02 conflictIndication's 'frame user.conflictIndicationConcern'.
    concern def ConflictIndicationConcern {
        subject controller : BaseArchitecture::ShutterController;

        require constraint {
            doc
            /* User wants a clear, perceivable indication whenever a
             * simultaneous UP+DOWN command conflict suppresses motor
             * movement, so the suppressed state is not mistaken for a
             * silently idle or unresponsive controller. */
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
            /* If controller require reconfiguration, it shall be possible to perform it without disassembling
             * the device.
             */
        }
    }

    /* --------------------------------------    MAINTENANCE TECHNICIAN */

    part def MaintenanceTechnician specializes Stakeholder {
        doc
        /* Professional who diagnoses and repairs a controller that has
         * already been installed, over the operational lifetime of the
         * system (field failures, mains/relay wear, etc.).
         */

        concern diagnosability : Diagnosability [1] subsets concerns;
        concern fieldReplaceability : FieldReplaceability [1] subsets concerns;
    }

    concern def Diagnosability {
        subject controller : BaseArchitecture::ShutterController;

        require constraint {
            doc
            /* A failed controller shall be diagnosable in the field without
             * specialized lab equipment, so that field failures (see
             * RISK-T-01, RISK-T-03) can be triaged quickly.
             */
        }
    }

    concern def FieldReplaceability {
        subject controller : BaseArchitecture::ShutterController;

        require constraint {
            doc
            /* A failed controller shall be replaceable/repairable on site
             * using the same wiring (12V DC, GND, UP/DOWN LOCAL, UP/DOWN
             * REMOTE, 230V AC, ROLLER UP/DOWN) without modifying the
             * existing installation.
             */
        }
    }

    /* --------------------------------------    DISPOSAL FACILITY */

    part def DisposalFacility specializes Stakeholder {
        doc
        /* Entity responsible for the end-of-life collection, disassembly,
         * and disposal/recycling of the controller once it is retired
         * (mains-voltage electronic waste).
         */

        concern regulatedDisposability : RegulatedDisposability [1] subsets concerns;
    }

    concern def RegulatedDisposability {
        subject controller : BaseArchitecture::ShutterController;

        require constraint {
            doc
            /* The controller shall be disposable in compliance with
             * applicable electronic-waste and hazardous-substance
             * regulation (e.g. WEEE, RoHS), given that it switches 230V AC
             * mains power.
             */
        }
    }

    /* Package-level usages providing named feature endpoints for traceability
     * connections (SysML v2 requires features, not classifier definitions). */
    part maintenanceTechnician : MaintenanceTechnician;
    part disposalFacility      : DisposalFacility;
    /* Scenario Repair Plan (SM-PRD-22, SR-6/SR-10): Installer and
     * Manufacturer previously existed only as NESTED parts inside
     * SystemContext::SystemContextDiagram and were not reachable by
     * qualified name as a connection endpoint anywhere in the model.
     * Added here, mirroring the existing maintenanceTechnician/
     * disposalFacility pattern exactly, so Scenarios/Traceability can
     * formally link SCEN_10-14/22/23 (Installer) and SCEN_25
     * (Manufacturer, OperatingConditions concern) to their stakeholders. */
    part installer   : Installer;
    part manufacturer : Manufacturer;
    /* MAJ-4 fix (SMRR corrective pass, HIGH priority -- blocks validation
     * readiness): 'User' part def (see above) existed with concerns
     * (controllerNeed, minimalSize) but had NO package-level usage,
     * making it unreachable by qualified name as a Traceability connection
     * endpoint -- unlike installer/manufacturer/maintenanceTechnician/
     * disposalFacility above. Added here, mirroring that exact pattern, so
     * the 10 manual-control/conflict/power-loss/jam scenarios that
     * involve the end user can now be formally linked (see Traceability.sysml
     * Scenario -> Stakeholder block). */
    part user : User;
} // package Stakeholders
