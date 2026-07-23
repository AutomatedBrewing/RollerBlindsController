package L0_Requirements {
    private import ScalarValues::*;
    private import ISQ::*;
    private import SI::*;
    private import Stakeholders::*;
    private import BaseArchitecture::*;
    private import ProblemStatement::*;
    private import SystemObjectives::*;

    /* Category templates (Layer 1): reusable `requirement def` types that bind the
     * requirement subject to the system under design, per the two-layer
     * definition/usage pattern (see KnowledgeSource/integration/crossmapping/requirements.md §2).
     * Concrete requirements (Layer 2) are `requirement` usages typed by these
     * templates, each carrying its own doc text, @RequirementMeta annotation,
     * and a short-name Requirement ID for traceability/verification cross-reference.
     */
    requirement def FunctionalReq {
        subject controller : BaseArchitecture::ShutterController;
    }

    requirement def QualityReq {
        subject controller : BaseArchitecture::ShutterController;
    }

    requirement def SafetyReq {
        subject controller : BaseArchitecture::ShutterController;
    }

    requirement def InterfaceReq {
        subject controller : BaseArchitecture::ShutterController;
    }

    requirement def EnvironmentalReq {
        subject controller : BaseArchitecture::ShutterController;
    }

    package Functional {
        requirement <'REQ-F-01'> controlRollerShutter : FunctionalReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder manufacturer : Stakeholders::Manufacturer;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall control the movement of window roller shutters. */

            frame user.controllerNeed;
            frame ProblemStatement::NeedForConvenientShutterOperation;

            @RequirementMeta {
                source             = "SystemIdea::systemIdea";
                priority           = RequirementPriority::mandatory;
                verificationMethod = "Functional verification via integration test exercising all control paths (wall switch, remote interface).";
                rationale          = "Top-level umbrella requirement decomposed by REQ-F-02..REQ-F-06 (see Traceability::Traceability for the derivation links).";
            }
        }

        requirement <'REQ-F-02'> localControl : FunctionalReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall support local control of the shutter. */

            frame user.controllerNeed;

            @RequirementMeta {
                source             = "SystemObjectives::localControl";
                priority           = RequirementPriority::mandatory;
                verificationMethod = "Functional verification via wall-switch test scenarios (Verification::Functional::VerifyLocalControl).";
                rationale          = "Refines REQ-F-01 to the local-control capability derived from the localControl system objective.";
            }
        }

        requirement <'REQ-F-03'> remoteControl : FunctionalReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall support remote control of the shutter. */

            frame user.controllerNeed;

            @RequirementMeta {
                source             = "SystemObjectives::remoteControl";
                priority           = RequirementPriority::mandatory;
                verificationMethod = "Integration test with a representative home automation system (Verification::Functional::VerifyRemoteControl).";
                rationale          = "Refines REQ-F-01 to the remote-control capability derived from the remoteControl system objective.";
            }
        }

        requirement <'REQ-F-04'> fullShutterMovement : FunctionalReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall allow automatic movement of the shutter to a fully open or fully closed position. */

            frame user.controllerNeed;

            @RequirementMeta {
                source             = "SystemObjectives::shutterMovementControl";
                priority           = RequirementPriority::mandatory;
                verificationMethod = "Functional verification (Verification::Functional::VerifyAutomaticOpening / VerifyAutomaticClosing).";
                rationale          = "Refines REQ-F-01; full-travel automatic movement is the primary convenience capability over manual operation. Source updated from 'easeOfUse' to 'shutterMovementControl' (system model review corrective pass, closes Major finding M1): this is a core movement capability, not a usability attribute.";
            }
        }

        requirement <'REQ-F-05'> manualPositioning : FunctionalReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall allow positioning of the shutter between the fully open and fully closed positions. */

            frame user.controllerNeed;

            @RequirementMeta {
                source             = "SystemObjectives::shutterMovementControl";
                priority           = RequirementPriority::recommended;
                verificationMethod = "Functional verification (Verification::Functional::VerifyManualPositioning).";
                rationale          = "Refines REQ-F-01; intermediate positioning improves usability beyond binary open/close. Source updated from 'easeOfUse' to 'shutterMovementControl' (system model review corrective pass, closes Major finding M1): this is a core movement capability, not a usability attribute.";
            }
        }

        requirement <'REQ-F-06'> stopShutterMovement : FunctionalReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall stop the shutter movement upon user or external system request. */

            frame user.controllerNeed;

            @RequirementMeta {
                source             = "SystemObjectives::shutterMovementControl";
                priority           = RequirementPriority::mandatory;
                verificationMethod = "Functional verification (Verification::Functional::VerifyMovementStop).";
                rationale          = "Refines REQ-F-01; the ability to interrupt movement is a basic safety and usability expectation. Source updated from 'easeOfUse' to 'shutterMovementControl' (system model review corrective pass, closes Major finding M1): this is a core movement capability, not a usability attribute.";
            }
        }

        requirement <'REQ-F-07'> configurableTimingProfile : FunctionalReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder installer : Stakeholders::Installer;
            stakeholder manufacturer : Stakeholders::Manufacturer;
            doc
            /* The controller shall allow the shutter opening and closing movement
             * times to be independently configured per installation, to
             * accommodate shutter motors with differing speed and torque
             * characteristics.
             */

            attribute maxConfigurableTravelTime subsets ISQ::duration;
            require constraint {
                maxConfigurableTravelTime <= 120 [SI::s]
            }

            frame installer.easeOfConfiguration;

            @RequirementMeta {
                source             = "Risks::TechnicalRisks::Risk_ShutterMotorTypeIncompatibility";
                priority           = RequirementPriority::mandatory;
                verificationMethod = "Compatibility test with a representative range of standard roller shutter motor types (Verification::Constraints::VerifyTimeBasedOperation).";
                rationale          = "Risk-driven requirement mitigating RISK-T-04 (shutter motor type incompatibility) and supporting the rollerShutterCompatibility system objective. Manufacturer stakeholder added (system model review corrective pass) alongside installer: the requirement's mandatory priority is justified primarily by RISK-T-04's major severity, not solely by the parent objective's 'recommended' priority -- rollerShutterCompatibility (recommended) reflects the manufacturer's overall market-reach ambition, while this requirement is independently mandated by the identified major technical risk. This priority relationship (recommended objective → mandatory requirement) is intentional and risk-justified, not an unexplained escalation.";
            }
        }

        requirement <'REQ-F-08'> configurationMode : FunctionalReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder installer : Stakeholders::Installer;
            doc
            /* The controller shall provide a distinct configuration mode,
             * activated and deactivated only through an explicit installer
             * action and clearly signaled to the user, during which movement
             * timing parameters can be calibrated without disassembling the
             * device.
             */

            frame installer.easeOfConfiguration;

            @RequirementMeta {
                source             = "Risks::TechnicalRisks::Risk_MisconfigurationDuringInstall";
                priority           = RequirementPriority::mandatory;
                verificationMethod = "Guided procedure walkthrough with a first-time installer (Verification::Quality::VerifyEaseOfInstallation).";
                rationale          = "Risk-driven requirement mitigating RISK-T-05 (misconfiguration during install) and supporting the easeOfUse system objective.";
            }
        }
    } // package Functional

    package Interface {
        requirement <'REQ-I-01'> wallSwitchWiringCompatibility : InterfaceReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder installer : Stakeholders::Installer;
            doc
            /* The controller's wall switch interface shall support both
             * momentary and latching wall switch wiring topologies,
             * selectable during installer configuration, to accommodate
             * existing residential wiring conventions.
             */

            frame installer.easeOfConfiguration;

            @RequirementMeta {
                source             = "Risks::IntegrationRisks::Risk_WallSwitchWiringIncompatibility";
                priority           = RequirementPriority::mandatory;
                verificationMethod = "Functional verification via wall-switch test scenarios (Verification::Functional::VerifyLocalControl).";
                rationale          = "Risk-driven requirement mitigating RISK-I-01 (wall switch wiring incompatibility) and supporting the localControl system objective.";
            }
        }

        requirement <'REQ-I-02'> remoteControlWiringCompatibility : InterfaceReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller's remote interface shall provide UP and DOWN
             * dry-contact style inputs that are electrically and behaviorally
             * equivalent to the local wall switch interface (voltage present
             * on an input asserts the corresponding movement direction). No
             * home automation protocol (e.g., Zigbee, Z-Wave, MQTT) is
             * implemented or required; any external system driving these
             * inputs is treated as a simple dry-contact/relay source.
             */

            frame user.controllerNeed;

            @RequirementMeta {
                source             = "SystemObjectives::remoteControl";
                priority           = RequirementPriority::mandatory;
                verificationMethod = "Functional verification exercising the UP/DOWN remote inputs with a dry-contact/relay test fixture, confirming identical behaviour to the local interface (Verification::Functional::VerifyRemoteControl).";
                rationale          = "Reflects the actual controller hardware interface (UP REMOTE / DOWN REMOTE dry-contact inputs, no protocol stack) and supersedes the previous protocol-integration framing, which did not match the implemented electrical interface.";
            }
        }
    } // package Interface

    package Quality {
        requirement <'REQ-Q-01'> easeOfInstallation : QualityReq {
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

            @RequirementMeta {
                source             = "SystemObjectives::easeOfUse";
                priority           = RequirementPriority::mandatory;
                verificationMethod = "Timed installation trial with a representative first-time installer (Verification::Quality::VerifyEaseOfInstallation).";
                rationale          = "Quantifies the easeOfUse system objective for the installer stakeholder.";
            }
        }

        requirement <'REQ-Q-02'> availability : QualityReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall achieve at least 99.8% operational
             * availability, measured as the percentage of time the
             * controller successfully executes a valid control request,
             * over a rolling 12-month operational period.
             */

            // Part C-1 fix (SMRR corrective pass): explicit frame binding,
            // closing the missing-frame minor finding for this requirement.
            frame user.availabilityConcern;

            attribute upTime : ScalarValues::Real;
            require constraint {
                upTime >= 99.8
            }

            @RequirementMeta {
                source             = "SystemObjectives::reliability";
                priority           = RequirementPriority::mandatory;
                verificationMethod = "Field/bench availability measurement over a rolling 12-month period (Verification::Quality::VerifyAvailability).";
                rationale          = "Quantifies the reliability system objective in terms of operational uptime.";
            }
        }

        requirement <'REQ-Q-03'> reliability : QualityReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall perform at least 10,000 shutter operation
             * cycles without failure, under the environmental operating
             * conditions and switching load defined in
             * L0_Constraints::Environmental::operatingConditions and
             * L0_Constraints::Electrical::switchingLoad.
             */

            // Part C-1 fix (SMRR corrective pass): explicit frame binding,
            // closing the missing-frame minor finding for this requirement.
            frame user.reliabilityConcern;

            attribute successfulOperations : ScalarValues::Natural;
            require constraint {
                successfulOperations >= 10000
            }

            @RequirementMeta {
                source             = "SystemObjectives::reliability";
                priority           = RequirementPriority::mandatory;
                verificationMethod = "Cycle endurance test at rated switching load and operating temperature extremes (Verification::Quality::VerifyReliability).";
                rationale          = "Quantifies the reliability system objective in terms of cycle-count durability; also mitigates RISK-T-03 (motor relay wear-out).";
            }
        }

        requirement <'REQ-Q-04'> diagnosability : QualityReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder maintenanceTechnician : Stakeholders::MaintenanceTechnician;
            doc
            /* A failed or malfunctioning controller shall be diagnosable in
             * the field, without specialized lab equipment, sufficiently to
             * distinguish at least the following fault classes: no power, no
             * response to any control input, and motor-drive fault (no
             * movement despite an accepted command).
             */

            frame maintenanceTechnician.diagnosability;

            @RequirementMeta {
                source             = "Stakeholders::MaintenanceTechnician";
                priority           = RequirementPriority::recommended;
                verificationMethod = "Guided field-diagnosis trial with a representative maintenance technician, injecting each fault class and confirming correct classification without lab equipment (Verification::Quality::VerifyDiagnosability).";
                rationale          = "Closes the requirement gap identified in the system model review (Major finding M3): Stakeholders::MaintenanceTechnician::Diagnosability previously had no L0_Requirements usage, and UC_04 traced only to reliability (REQ-Q-03), which does not itself address field diagnosability. Directly supports UC_04_DiagnoseAndRepairController and mitigates the field-triage aspect of RISK-T-01/RISK-T-03.";
            }
        }

        requirement <'REQ-Q-05'> fieldReplaceability : QualityReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder maintenanceTechnician : Stakeholders::MaintenanceTechnician;
            doc
            /* A failed controller shall be repairable or replaceable on-site
             * using the existing installation wiring (12V DC, GND, UP/DOWN
             * LOCAL, UP/DOWN REMOTE, 230V AC, ROLLER UP/DOWN), without
             * modifying the existing installation.
             */

            frame maintenanceTechnician.fieldReplaceability;

            @RequirementMeta {
                source             = "Stakeholders::MaintenanceTechnician";
                priority           = RequirementPriority::recommended;
                verificationMethod = "Timed field-replacement trial confirming the replacement unit operates correctly using the unmodified existing wiring (Verification::Quality::VerifyFieldReplaceability).";
                rationale          = "Closes the requirement gap identified in the system model review (Major finding M3): Stakeholders::MaintenanceTechnician::FieldReplaceability previously had no L0_Requirements usage. Directly supports UC_04_DiagnoseAndRepairController's postcondition ('faulty unit repaired or replaced ... using the existing wiring').";
            }
        }
    } // package Quality

    package Safety {
        requirement <'REQ-S-01'> safety : SafetyReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall limit any user- or installer-accessible
             * voltage on external interfaces to SELV levels (<= 50 V AC)
             * and shall not expose mains-referenced motor switching
             * circuitry to direct contact, consistent with the galvanic
             * isolation constraints in L0_Constraints::Electrical.
             */

            // Part C-1 fix (SMRR corrective pass): explicit frame binding,
            // closing the missing-frame minor finding for this requirement.
            frame user.safetyConcern;

            attribute maxAccessibleVoltage = 50 [SI::V];
            require constraint {
                maxAccessibleVoltage <= 50 [SI::V]
            }

            @RequirementMeta {
                source             = "SystemObjectives::safety";
                priority           = RequirementPriority::mandatory;
                verificationMethod = "Electrical safety test (touch-voltage and isolation measurement) per Verification::Constraints::VerifySupplyVoltageRange/VerifyMaximumSwitchingLoad.";
                rationale          = "Derived from the safety system objective (added in this fix pass); covers galvanic isolation of mains-voltage switching circuitry (physical constraint) and conflict-suppression behavior (UC_01e). The previous proxy source (reliability) is retained as a secondary trace in Traceability.sysml. NOTE (system model review corrective pass): this requirement's electrical/SELV clause is intentionally atomic; the behavioral conflict-suppression counterpart previously only informally referenced here is now a separate, independently verifiable requirement, REQ-S-02 conflictIndication, addressing the user-feedback aspect of UC_01e.";
            }
        }

        requirement <'REQ-S-02'> conflictIndication : SafetyReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* When a simultaneous UP+DOWN command conflict is detected and
             * motor activation is suppressed (UC_01e), the controller shall
             * raise a distinct, user-perceivable indication (e.g. a
             * dedicated LED/buzzer pattern) so that the suppressed-movement
             * state is observable rather than silent.
             */

            // Part C-1 fix (SMRR corrective pass): explicit frame binding,
            // closing the missing-frame minor finding for this requirement.
            frame user.conflictIndicationConcern;

            @RequirementMeta {
                source             = "SystemObjectives::safety";
                priority           = RequirementPriority::mandatory;
                verificationMethod = "Functional verification asserting simultaneous UP+DOWN inputs and confirming the distinct conflict indication activates while the motor remains de-energized (Verification::Constraints::VerifyConflictNotification).";
                rationale          = "Closes Major finding M2 from the system model review: previously the UC_01e conflict-suppression state was entirely silent -- the motor de-energizes with zero user-facing feedback, indistinguishable from an idle/at-rest controller. This is a genuine safety/transparency gap (a user cannot tell a real conflict/fault from normal idle behavior). Split out of REQ-S-01 to keep both requirements atomic and independently verifiable.";
            }
        }
    } // package Safety

    package Environmental {
        requirement <'REQ-E-01'> regulatedDisposal : EnvironmentalReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder disposalFacility : Stakeholders::DisposalFacility;
            doc
            /* The controller shall be disposable in compliance with applicable
             * electronic-waste and hazardous-substance regulation (WEEE, RoHS),
             * given that it switches 230V AC mains power and contains
             * potentially hazardous materials. The controller shall be designed
             * to allow disassembly and material separation without specialist
             * equipment.
             */

            // Part C-1 fix (SMRR corrective pass): explicit frame binding,
            // closing the missing-frame minor finding for this requirement.
            frame disposalFacility.regulatedDisposability;

            @RequirementMeta {
                source             = "Stakeholders::DisposalFacility";
                priority           = RequirementPriority::mandatory;
                verificationMethod = "Material compliance declaration (RoHS) and recycling-pathway review per WEEE directive; confirmed during product design review.";
                rationale          = "Closes the disposal-requirement gap identified in the traceability review: DisposalFacility stakeholder concern RegulatedDisposability had no L0_Requirements usage and UC_05 had no require link. Mains-switching electronics are subject to WEEE/RoHS regulation; non-compliance risks import/sale prohibition in regulated markets.";
            }
        }
    } // package Environmental
} // package L0_Requirements
