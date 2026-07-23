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
    /* PRIORITY TAXONOMY CROSS-MAP (closes Major finding M5, system model
     * review corrective pass): this project intentionally uses three
     * distinct priority vocabularies, one per artifact layer, each idiomatic
     * to that layer's own metadata def (RequirementMeta.priority is the only
     * one typed by an enum; SystemUseCases::UseCaseMeta.priority and
     * SystemTestCases::TestCaseMeta.priority remain plain String per their
     * own package's convention, and are NOT converted to this enum, to avoid
     * a broad, high-risk mechanical retype of every existing Use Case/Test
     * Case usage for a clarity-only fix). They are related by one consistent
     * importance ordering, mapped here as descriptive guidance rather than a
     * shared enumeration:
     *
     *   RequirementPriority   UseCaseMeta.priority   TestCaseMeta.priority   Meaning
     *   --------------------  ---------------------  ----------------------  ------------------------------------------
     *   mandatory             mandatory              critical                Must be realized/verified for baseline acceptance.
     *   recommended           high                   high                    Strongly desired; may slip one release without blocking baseline.
     *   optional              medium                 medium                 Nice-to-have; no acceptance impact if deferred.
     *   (n/a)                 low                    low                     Exploratory/aspirational only (no requirement backs it).
     *
     * Use this table when reasoning about relative importance across
     * Requirements / Use Cases / Test Cases. See also
     * SystemUseCases::UseCaseMeta and SystemTestCases::TestCaseMeta, which
     * each carry a one-line pointer back to this table.
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
            source             = "ProblemStatement::NeedForConvenientShutterOperation";
            priority           = RequirementPriority::mandatory;
            verificationMethod = "Market price analysis; validated against comparable products at system acceptance.";
            rationale          = "Addresses the cost barrier identified in the ProblemStatement: high cost of automated shutter control limits adoption in residential environments. NOTE (system model review corrective pass): this objective intentionally terminates at L0_Constraints::Business::costEffective / ADR_001_CostConstraint and does NOT produce an L0_Requirements usage, Use Case, Activity, Function, or Test Case -- cost is a BOM-level design constraint verified by procurement/design review (see ADR-001), not a testable property of a finished unit. This single-layer realization path is an intentional, documented exception to the otherwise-uniform objective→requirement→...→test chain used by every other objective in this package.";
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
            verificationMethod = "Functional verification via the full-movement, manual-positioning, and stop test scenarios (Verification::Functional).";
            rationale          = "Introduced to relieve 'easeOfUse' of functional-capability justification duties (closes Major finding M1, system model review corrective pass): full/manual movement and the ability to stop are core movement capabilities of the WRSC system idea, not usability/intuitiveness attributes. 'easeOfUse' now justifies only genuinely usability-related requirements (REQ-F-08 configurationMode, REQ-Q-01 easeOfInstallation).";
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
            rationale          = "Addresses ProblemStatement gap: the system must be more convenient than the existing manual operation it replaces. Scope narrowed (system model review corrective pass, closes Major finding M1): now justifies only usability/configuration-ergonomics requirements (REQ-F-08 configurationMode, REQ-Q-01 easeOfInstallation); core movement capabilities are justified by the new shutterMovementControl objective instead.";
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
            rationale          = "Independent safety objective distinct from reliability: covers galvanic isolation of mains-voltage switching circuitry (physical design property) and conflict-suppression behavior (UC_01e). Safety remains mandatory even if reliability targets are relaxed. Closes the safety-objective gap documented in model_issues.md.";
        }
    }
} // package SystemObjectives
