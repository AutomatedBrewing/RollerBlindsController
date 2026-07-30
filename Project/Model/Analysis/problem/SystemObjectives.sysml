package SystemObjectives {
    private import ScalarValues::*;
    private import Stakeholders::*;
    private import Base::Anything;

    enum def RequirementPriority { mandatory; recommended; optional; }

    metadata def RequirementMeta {
        attribute source              : String;
        attribute priority            : RequirementPriority;
        attribute verificationMethod  : String;
        attribute rationale           : String;
    }

    comment
    /* Priority vocabularies differ per layer: RequirementMeta.priority
     * (enum: mandatory/recommended/optional), UseCaseMeta.priority and
     * TestCaseMeta.priority (String: mandatory/high/medium/low and
     * critical/high/medium/low respectively) follow one consistent
     * importance ordering across layers.
     */

    requirement def BusinessObjective {
        subject : Anything;
        doc /* Goal owned by the vendor/manufacturer —
             * expressed as a business or market outcome. */
    }

    requirement def CapabilityObjective {
        subject : Anything;
        doc /* High-level system capability the system must offer —
             * a feature the user can directly exercise. */
    }

    requirement def QualityObjective {
        subject : Anything;
        doc /* Quality-of-experience or dependability goal
             * that applies across the system's operation. */
    }

    comment
    /* The System Objectives represent the main objectives of the
     * vendor or owner of the system.
     */

    requirement affordability : BusinessObjective {
        subject : Anything;
        stakeholder user : Stakeholders::User;

        doc
        /* The controller is affordable for any end user. */

        @RequirementMeta {
            source             = "ProblemStatement::needForConvenientShutterOperation";
            priority           = RequirementPriority::mandatory;
            verificationMethod = "Market price analysis against comparable products at system acceptance.";
            rationale          = "Addresses the cost barrier to adoption identified in the ProblemStatement; the specific target is a BOM-level design constraint, not a testable property of a finished unit.";
        }
    }

    requirement shutterMovementControl : CapabilityObjective {
        subject : Anything;
        stakeholder user : Stakeholders::User;

        doc
        /* Provide the core shutter-movement capabilities users need for
         * day-to-day operation: automatic full-travel open/close, manual
         * intermediate positioning, and the ability to stop movement on
         * demand. */

        @RequirementMeta {
            source             = "SystemIdea::systemIdea";
            priority           = RequirementPriority::mandatory;
            verificationMethod = "Functional verification via the full-movement, manual-positioning, and stop test cases (SystemTestCases::Functional).";
            rationale          = "Core movement capabilities (open/close/stop/positioning) of the WRSC system idea, distinct from usability attributes covered by easeOfUse.";
        }
    }

    requirement easeOfUse : QualityObjective {
        subject : Anything;
        stakeholder user : Stakeholders::User;

        doc
        /* Usage of the controller should be intuitive for all users. */

        @RequirementMeta {
            source             = "Stakeholders::User";
            priority           = RequirementPriority::mandatory;
            verificationMethod = "Usability review with representative end users; measurable criteria elaborated in quality requirements.";
            rationale          = "The controller must be more convenient than the manual operation it replaces. Justifies usability/configuration-ergonomics requirements (REQ-F-08, REQ-Q-01); core movement capabilities are justified by shutterMovementControl instead.";
        }
    }

    requirement localControl : CapabilityObjective {
        subject : Anything;
        stakeholder user : Stakeholders::User;

        doc
        /* Provide local operability. */

        @RequirementMeta {
            source             = "SystemIdea::systemIdea";
            priority           = RequirementPriority::mandatory;
            verificationMethod = "Functional verification via wall-switch test scenarios in system integration test.";
            rationale          = "Core capability of the WRSC system idea: enables control without physical access to the shutter mechanism.";
        }
    }

    requirement remoteControl : CapabilityObjective {
        subject : Anything;
        stakeholder user : Stakeholders::User;

        doc
        /* Enable integration with home automation systems via dry-contact
         * UP/DOWN inputs electrically equivalent to the local wall switch
         * interface (no home automation protocol stack is implemented).
         */

        @RequirementMeta {
            source             = "SystemIdea::systemIdea";
            priority           = RequirementPriority::mandatory;
            verificationMethod = "Integration test driving the UP/DOWN remote inputs from a representative home automation system's dry-contact/relay output.";
            rationale          = "Addresses ProblemStatement gap: existing installations lack a way to trigger shutter movement from a home automation system; integration is achieved at the dry-contact/relay level, not via a shared communication protocol.";
        }
    }

    requirement rollerShutterCompatibility : BusinessObjective {
        subject : Anything;
        stakeholder manufacturer : Stakeholders::Manufacturer;

        doc
        /* Support a wide range of roller shutter systems. */

        @RequirementMeta {
            source             = "Stakeholders::Manufacturer";
            priority           = RequirementPriority::recommended;
            verificationMethod = "Compatibility test with a representative range of standard roller shutter motor types.";
            rationale          = "Manufacturer objective: broad compatibility maximises addressable market without requiring product variants.";
        }
    }

    requirement reliability : QualityObjective {
        subject : Anything;
        stakeholder manufacturer : Stakeholders::Manufacturer;

        doc
        /* Provide a highly reliable controller. */

        @RequirementMeta {
            source             = "Stakeholders::Manufacturer";
            priority           = RequirementPriority::mandatory;
            verificationMethod = "Cycle endurance test; MTBF and availability measurements; numeric thresholds elaborated in quality requirements.";
            rationale          = "Unreliable operation creates safety risk and erodes user trust; reliability is a prerequisite for market acceptance.";
        }
    }

    requirement safety : QualityObjective {
        subject : Anything;
        stakeholder user : Stakeholders::User;
        stakeholder manufacturer : Stakeholders::Manufacturer;

        doc
        /* The controller shall not expose users or installers to unsafe
         * voltages or hazardous mechanical conditions during normal
         * operation or installation, and shall not enter a hazardous
         * motor drive state in response to conflicting or erroneous
         * control inputs.
         */

        @RequirementMeta {
            source             = "SystemIdea::systemIdea";
            priority           = RequirementPriority::mandatory;
            verificationMethod = "Electrical safety test (touch-voltage and isolation measurement); functional safety scenario test for simultaneous UP+DOWN input.";
            rationale          = "Independent of reliability: covers galvanic isolation of mains-voltage circuitry and conflict-suppression behavior (UC_01e). Remains mandatory even if reliability targets are relaxed.";
        }
    }
} // package SystemObjectives
