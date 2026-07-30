package L0_Requirements {
    private import ScalarValues::*;
    private import ISQ::*;
    private import SI::*;
    private import Stakeholders::*;
    private import BaseArchitecture::*;
    private import ProblemStatement::*;
    private import SystemObjectives::*;

    /* Category templates (Layer 1): reusable `requirement def` types binding the subject to ShutterController.
     * Concrete requirements (Layer 2) are `requirement` usages typed by these templates, each with doc, @RequirementMeta, and a traceability ID.
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
            frame ProblemStatement::needForConvenientShutterOperation;

            @RequirementMeta {
                source = "SystemIdea::systemIdea";
                priority = RequirementPriority::mandatory;
                verificationMethod =
                    "Functional verification via integration test exercising all control paths (wall switch, remote interface).";
                rationale =
                    "Top-level umbrella requirement decomposed by REQ-F-02..REQ-F-06 (see Traceability::Traceability for the derivation links).";
            }
        }

        requirement <'REQ-F-02'> localControl : FunctionalReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall support local control of the shutter. */

            frame user.controllerNeed;

            @RequirementMeta {
                source = "SystemObjectives::localControl";
                priority = RequirementPriority::mandatory;
                verificationMethod =
                    "Functional verification via wall-switch test scenarios (SystemTestCases::Functional::TC_F_002_LocalControl_MomentarySwitch / TC_F_003_LocalControl_LatchingSwitch).";
                rationale =
                    "Refines REQ-F-01 to the local-control capability derived from the localControl system objective.";
            }
        }

        requirement <'REQ-F-03'> remoteControl : FunctionalReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall support remote control of the shutter. */

            frame user.controllerNeed;

            @RequirementMeta {
                source = "SystemObjectives::remoteControl";
                priority = RequirementPriority::mandatory;
                verificationMethod =
                    "Integration test with a representative home automation system (SystemTestCases::Functional::TC_F_004_RemoteControl_UP / TC_F_005_RemoteControl_DOWN).";
                rationale =
                    "Refines REQ-F-01 to the remote-control capability derived from the remoteControl system objective.";
            }
        }

        requirement <'REQ-F-04'> fullShutterMovement : FunctionalReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall allow automatic movement of the shutter to a fully open or fully closed position. */

            frame user.controllerNeed;

            @RequirementMeta {
                source = "SystemObjectives::shutterMovementControl";
                priority = RequirementPriority::mandatory;
                verificationMethod =
                    "Functional verification (SystemTestCases::Functional::TC_F_006_AutomaticFullOpen / TC_F_007_AutomaticFullClose).";
                rationale =
                    "Refines REQ-F-01; full-travel automatic movement is the primary convenience capability over manual operation.";
            }
        }

        requirement <'REQ-F-05'> manualPositioning : FunctionalReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall allow positioning of the shutter between the fully open and fully closed positions. */

            frame user.controllerNeed;

            @RequirementMeta {
                source = "SystemObjectives::shutterMovementControl";
                priority = RequirementPriority::recommended;
                verificationMethod =
                    "Functional verification (SystemTestCases::Functional::TC_F_008_ManualPartialOpen / TC_F_009_ManualPartialClose).";
                rationale =
                    "Refines REQ-F-01; intermediate positioning improves usability beyond binary open/close.";
            }
        }

        requirement <'REQ-F-06'> stopShutterMovement : FunctionalReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall stop the shutter movement upon user or external system request.
             * During normal operation, local and remote channels have equal priority: any UP or DOWN
             * assertion on either channel shall stop an in-progress movement.
             */

            frame user.controllerNeed;

            @RequirementMeta {
                source = "SystemObjectives::shutterMovementControl";
                priority = RequirementPriority::mandatory;
                verificationMethod =
                    "Functional verification (SystemTestCases::Functional::TC_F_010_StopDuringOpening / TC_F_011_StopDuringClosing) and equal-priority arbitration test exercising local-start/remote-stop and vice versa (SystemTestCases::Safety::TC_S_005_EqualPriorityStopArbitration_LocalStartRemoteStop / TC_S_006_EqualPriorityStopArbitration_RemoteStartLocalStop).";
                rationale =
                    "Refines REQ-F-01; local and remote channels are treated symmetrically for stopping an in-progress movement.";
            }
        }

        requirement <'REQ-F-07'> configurableTimingProfile : FunctionalReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder installer : Stakeholders::Installer;
            stakeholder manufacturer : Stakeholders::Manufacturer;
            doc
            /* The controller shall allow the shutter opening/closing movement
             * time to be configured per installation, to enable full open/close 
             * of roller shutter in automatic mode.
             */

            attribute maxConfigurableTravelTime subsets ISQ::duration;
            require constraint {
                maxConfigurableTravelTime <= 120 [SI::s]
            }

            frame installer.easeOfConfiguration;

            @RequirementMeta {
                source = "Risks::TechnicalRisks::Risk_ShutterMotorTypeIncompatibility";
                priority = RequirementPriority::mandatory;
                verificationMethod =
                    "Compatibility test with a representative range of standard roller shutter motor types (SystemTestCases::Functional::TC_F_012_ConfigurableTimingProfile_Nominal).";
                rationale =
                    "Mitigates RISK-T-04 (shutter motor type incompatibility); mandatory priority is justified by RISK-T-04's major severity, independent of the parent objective's 'recommended' priority.";
            }
        }

        requirement <'REQ-F-08'> configurationMode : FunctionalReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder installer : Stakeholders::Installer;
            doc
            /* The controller shall provide a configuration mode, activated and deactivated only by a
             * sustained simultaneous local-only UP+DOWN hold beyond a calibration threshold
             * (defined in ProductComponents::ConfigurationManagerSoftware), during which timing
             * parameters can be calibrated without disassembly.
             */

            frame installer.easeOfConfiguration;

            @RequirementMeta {
                source = "Risks::TechnicalRisks::Risk_MisconfigurationDuringInstall";
                priority = RequirementPriority::mandatory;
                verificationMethod =
                    "Installer walkthrough (SystemTestCases::Quality::TC_Q_001_InstallationTime); remote UP+DOWN hold verified to NOT activate configuration mode (SystemTestCases::Safety::TC_S_004_LocalOnlyConfigGating_RemoteHoldRejected).";
                rationale =
                    "Mitigates RISK-T-05 (misconfiguration during install); local-only activation gating ensures a remote fault or erroneous signal cannot enter configuration mode.";
            }
        }

        requirement <'REQ-F-09'> pressDurationModeDiscrimination : FunctionalReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall discriminate automatic mode (REQ-F-04) from manual hold-to-run mode
             * (REQ-F-05) by UP/DOWN assertion duration: below threshold is a short press (automatic);
             * at/above threshold is a sustained hold (manual). Applies identically to local and remote
             * channels; threshold defined in ProductComponents::CommandArbitrationSoftware.
             */

            frame user.controllerNeed;

            @RequirementMeta {
                source = "SystemObjectives::shutterMovementControl";
                priority = RequirementPriority::mandatory;
                verificationMethod =
                    "Functional test asserting commands below and at/above the press-duration threshold, confirming automatic vs. manual mode selection (SystemTestCases::Functional::TC_F_014_PressDurationModeDiscrimination).";
                rationale =
                    "Makes explicit the short-press/long-press discrimination that REQ-F-04 and REQ-F-05 depend on but do not themselves specify.";
            }
        }

        requirement <'REQ-F-10'> timingDriftMargin : FunctionalReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller shall run each movement 5 seconds longer than its configured
             * travel time, to compensate for cumulative positioning drift (RISK-T-01).
             */

            attribute timingMarginS subsets ISQ::duration;
            require constraint {
                timingMarginS >= 5 [SI::s]
            }

            frame user.controllerNeed;

            @RequirementMeta {
                source = "Risks::TechnicalRisks::Risk_PositioningDrift";
                priority = RequirementPriority::mandatory;
                verificationMethod =
                    "Confirm configured travel time exceeds the last measured travel time by >= 5 s (SystemTestCases::Functional::TC_F_012_ConfigurableTimingProfile_Nominal).";
                rationale =
                    "Mitigates RISK-T-01 (positioning drift); makes the existing timing-margin mitigation a verifiable requirement instead of only a product attribute.";
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
                source = "Risks::IntegrationRisks::Risk_WallSwitchWiringIncompatibility";
                priority = RequirementPriority::mandatory;
                verificationMethod =
                    "Functional verification via wall-switch test scenarios (SystemTestCases::Functional::TC_F_002_LocalControl_MomentarySwitch / TC_F_003_LocalControl_LatchingSwitch).";
                rationale =
                    "Risk-driven requirement mitigating RISK-I-01 (wall switch wiring incompatibility) and supporting the localControl system objective.";
            }
        }

        requirement <'REQ-I-02'> remoteControlWiringCompatibility : InterfaceReq {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;
            doc
            /* The controller's remote interface shall provide UP and DOWN dry-contact inputs
             * electrically equivalent to the local wall switch (voltage present asserts the direction).
             * No home automation protocol is implemented; any external system is treated as a dry-contact source.
             */

            frame user.controllerNeed;

            @RequirementMeta {
                source = "SystemObjectives::remoteControl";
                priority = RequirementPriority::mandatory;
                verificationMethod =
                    "Functional verification exercising the UP/DOWN remote inputs with a dry-contact/relay test fixture, confirming identical behaviour to the local interface (SystemTestCases::Functional::TC_F_004_RemoteControl_UP / TC_F_005_RemoteControl_DOWN).";
                rationale =
                    "Reflects the actual hardware interface (UP REMOTE / DOWN REMOTE dry-contact inputs, no protocol stack).";
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
                source = "SystemObjectives::easeOfUse";
                priority = RequirementPriority::mandatory;
                verificationMethod =
                    "Timed installation trial with a representative first-time installer (SystemTestCases::Quality::TC_Q_001_InstallationTime).";
                rationale =
                    "Quantifies the easeOfUse system objective for the installer stakeholder.";
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

            frame user.availabilityConcern;

            attribute upTime : ScalarValues::Real;
            require constraint {
                upTime >= 99.8
            }

            @RequirementMeta {
                source = "SystemObjectives::reliability";
                priority = RequirementPriority::mandatory;
                verificationMethod =
                    "Field/bench availability measurement over a rolling 12-month period (SystemTestCases::Quality::TC_Q_002_OperationalAvailability).";
                rationale =
                    "Quantifies the reliability system objective in terms of operational uptime.";
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

            frame user.reliabilityConcern;

            attribute successfulOperations : ScalarValues::Natural;
            require constraint {
                successfulOperations >= 10000
            }

            @RequirementMeta {
                source = "SystemObjectives::reliability";
                priority = RequirementPriority::mandatory;
                verificationMethod =
                    "Cycle endurance test at rated switching load and operating temperature extremes (SystemTestCases::Quality::TC_Q_003_ReliabilityEndurance).";
                rationale =
                    "Quantifies the reliability system objective in terms of cycle-count durability; also mitigates RISK-T-03 (motor relay wear-out).";
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

            frame user.safetyConcern;

            attribute maxAccessibleVoltage = 50 [SI::V];
            require constraint {
                maxAccessibleVoltage <= 50 [SI::V]
            }

            @RequirementMeta {
                source = "SystemObjectives::safety";
                priority = RequirementPriority::mandatory;
                verificationMethod =
                    "Electrical safety test (touch-voltage and isolation measurement) per SystemTestCases::Boundary::TC_B_001_SupplyVoltage_LowerBoundary/TC_B_002_SupplyVoltage_UpperBoundary/TC_B_006_SwitchingLoad_Maximum.";
                rationale =
                    "Derived from the safety system objective; covers galvanic isolation of mains-voltage switching circuitry. UP+DOWN conflict suppression (UC_01e) is a mandatory safety behavior verified as motor-drive suppression.";
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

            frame disposalFacility.regulatedDisposability;

            @RequirementMeta {
                source = "Stakeholders::DisposalFacility";
                priority = RequirementPriority::mandatory;
                verificationMethod =
                    "Material compliance declaration (RoHS) and recycling-pathway review per WEEE directive; confirmed during product design review.";
                rationale =
                    "Mains-switching electronics are subject to WEEE/RoHS regulation; non-compliance risks import/sale prohibition in regulated markets.";
            }
        }
    } // package Environmental
} // package L0_Requirements
