package Risks {
    private import ScalarValues::String;
    private import BaseArchitecture::*;

    /* The Risks product captures and structures all identified threats
     * that could prevent the system from meeting its objectives,
     * satisfying safety requirements, or being delivered on time and
     * within budget.
     *
     * Risks are organized into five categories: TechnicalRisks,
     * SafetyRisks, BusinessRisks, ScheduleRisks, and IntegrationRisks.
     * Upstream (System Idea / System Objectives) and downstream
     * (mitigating Requirement / Constraint) traceability links are
     * modeled as `connection : Derivation` entries in
     * Traceability::Traceability, following the same pattern used for
     * every other analysis product in this model.
     */

    enum def RiskLevel { low; medium; high; }
    enum def RiskSeverity { minor; major; critical; }
    enum def RiskStatus { open; mitigated; closed; }

    metadata def RiskMeta {
        attribute probability : RiskLevel;
        attribute impact      : RiskLevel;
        attribute severity    : RiskSeverity;
        attribute mitigation  : String;
        attribute rationale   : String;   // Justifies probability/impact assessment and any
                                           // deviation from the standard probability x impact
                                           // severity matrix (see rationale text per risk below).
        attribute status      : RiskStatus;
        attribute riskOwner   : String;   // Free-text role/person name. Risk ownership is tracked
                                           // as a lightweight in-model proxy per SYSMOD guidance
                                           // (KnowledgeSource/sysmod/products/risks.md) rather than
                                           // a modeled Stakeholder — no formal organizational role
                                           // type (e.g., "Hardware Engineer") exists in this
                                           // project's Stakeholders package, which models only the
                                           // external Manufacturer/User/Installer stakeholders.
    }

    /* Category templates (Layer 1): reusable `requirement def` types that bind the
     * risk subject to the system under design. Concrete risks (Layer 2) are
     * `requirement` usages typed by these templates, carrying their own doc text,
     * @RiskMeta annotation, and a short-name Risk ID for ARC-11 / ADR cross-reference.
     */
    requirement def TechnicalRisk {
        subject controller : BaseArchitecture::ShutterController;
    }

    requirement def SafetyRisk {
        subject controller : BaseArchitecture::ShutterController;
    }

    requirement def BusinessRisk {
        subject controller : BaseArchitecture::ShutterController;
    }

    requirement def ScheduleRisk {
        subject controller : BaseArchitecture::ShutterController;
    }

    requirement def IntegrationRisk {
        subject controller : BaseArchitecture::ShutterController;
    }

    package TechnicalRisks {
        requirement <'RISK-T-01'> Risk_PositioningDrift : TechnicalRisk {
            subject controller : BaseArchitecture::ShutterController;
            doc
            /* Without position feedback, cumulative timing error across many
             * shutter movement cycles may cause the shutter to no longer
             * reach the fully open or fully closed position, leading to
             * degraded user experience and potential mechanical strain.
             */
            @RiskMeta {
                probability = RiskLevel::medium;
                impact      = RiskLevel::medium;
                severity    = RiskSeverity::major;
                mitigation  = "RollerShutter shall be configured to open/close for 5s longer than actual closing/opening time.";
                rationale   = "Medium probability (timing drift accumulates gradually across normal use) and medium impact (degrades usability but is user-recoverable via reconfiguration) combine to a major severity per the project risk matrix; directly threatens the no-position-feedback design choice recorded in SystemIdea.";
                status      = RiskStatus::open;
                riskOwner   = "System Architect";
            }
        }

        requirement <'RISK-T-03'> Risk_MotorRelayWearOut : TechnicalRisk {
            subject controller : BaseArchitecture::ShutterController;
            doc
            /* Repeated switching of the motor relay/triac contacts over the
             * required operational lifetime may cause contact wear or triac
             * degradation, resulting in intermittent or failed shutter
             * movement before the targeted cycle count is reached.
             */
            @RiskMeta {
                probability = RiskLevel::medium;
                impact      = RiskLevel::medium;
                severity    = RiskSeverity::major;
                mitigation  = "Select relay/triac switching components rated for at least 10,000 switching cycles at the rated 8 A / 230 VAC load; validate via the VerifyReliability cycle endurance test case.";
                rationale   = "Medium probability (component wear is a well-understood failure mode over the required duty cycle) and medium impact (degrades reliability but is not immediately safety-critical) combine to a major severity per the project risk matrix; directly threatens the reliability system objective.";
                status      = RiskStatus::open;
                riskOwner   = "Hardware Engineer";
            }
        }

        requirement <'RISK-T-04'> Risk_ShutterMotorTypeIncompatibility : TechnicalRisk {
            subject controller : BaseArchitecture::ShutterController;
            doc
            /* Timing-based, position-sensorless control relies on consistent
             * motor speed and travel time. Shutter motors from different
             * manufacturers may exhibit sufficiently different speed/torque
             * characteristics that a single timing profile cannot reliably
             * position all supported motor types, limiting the range of
             * compatible shutter systems.
             */
            @RiskMeta {
                probability = RiskLevel::medium;
                impact      = RiskLevel::medium;
                severity    = RiskSeverity::major;
                mitigation  = "Provide a per-installation configurable timing profile; document a validated range of compatible motor types; verify via the VerifyTimeBasedOperation test case.";
                rationale   = "Medium probability (the shutter-motor market includes a wide range of speed/torque characteristics) and medium impact (reduces, but does not eliminate, addressable market) combine to a major severity per the project risk matrix; directly threatens the rollerShutterCompatibility system objective.";
                status      = RiskStatus::open;
                riskOwner   = "System Architect";
            }
        }

        requirement <'RISK-T-05'> Risk_MisconfigurationDuringInstall : TechnicalRisk {
            subject controller : BaseArchitecture::ShutterController;
            doc
            /* If the timing-calibration configuration procedure is not
             * completed correctly by a first-time installer, the shutter
             * may fail to fully open or close, or stop in an unintended
             * in-between position, degrading perceived reliability and
             * ease of use.
             */
            @RiskMeta {
                probability = RiskLevel::medium;
                impact      = RiskLevel::low;
                severity    = RiskSeverity::minor;
                mitigation  = "Provide a clear, guided configuration-mode procedure with explicit user notification of activation/deactivation; validate configuration procedure duration and correctness via the VerifyEaseOfInstallation test case. MAJ-8 fix (SMRR corrective pass): the procedure now also includes an explicit out-of-range calibration guard (UseCaseActivities::ConfigureController's checkOpenTimeInRange/checkCloseTimeInRange + RejectOutOfRangeCalibration, REQ-F-07's maxConfigurableTravelTime <= 120 s boundary), rejecting a miscalibrated measurement instead of persisting it, per Scenarios::SCEN_22.";
                rationale   = "Medium probability (first-time installers are the primary target per the easeOfInstallation requirement) but low impact (correctable via re-entering configuration mode, no permanent damage) combine to a minor severity per the project risk matrix; directly threatens the easeOfUse system objective.";
                status      = RiskStatus::open;
                riskOwner   = "System Architect";
            }
        }
    } // package TechnicalRisks

    package SafetyRisks {
        requirement <'RISK-S-01'> Risk_InsufficientGalvanicIsolation : SafetyRisk {
            subject controller : BaseArchitecture::ShutterController;
            doc
            /* Insufficient galvanic isolation between the motor switching
             * circuitry and low-voltage control logic or external input
             * interfaces may expose users or installers to electric shock
             * hazards.
             */
            @RiskMeta {
                probability = RiskLevel::low;
                impact      = RiskLevel::high;
                severity    = RiskSeverity::critical;
                mitigation  = "Mandate galvanic isolation for motor and input interfaces per L0_Constraints::Electrical::motorIsolation and inputIsolation; verify via the VerifySupplyVoltageRange/VerifyMaximumSwitchingLoad test cases (Verification::Constraints).";
                rationale   = "Per the standard probability x impact matrix, low probability + high impact would default to major. Severity is escalated to critical because the impact category is electric shock to a user or installer — a safety-of-life hazard — which by project convention is always escalated one level above the matrix default regardless of probability, consistent with an ALARP-style treatment of safety-critical hazards.";
                status      = RiskStatus::open;
                riskOwner   = "Safety Engineer";
            }
        }
    } // package SafetyRisks

    package BusinessRisks {
        requirement <'RISK-B-01'> Risk_CostTargetExceedance : BusinessRisk {
            subject controller : BaseArchitecture::ShutterController;
            doc
            /* Meeting the galvanic isolation and switching-load constraints
             * may require components that push manufacturing cost above the
             * 50 PLN per unit target, eroding the affordability objective
             * and the controller's competitiveness against manually
             * operated alternatives.
             */
            @RiskMeta {
                probability = RiskLevel::medium;
                impact      = RiskLevel::medium;
                severity    = RiskSeverity::major;
                mitigation  = "Engage component sourcing early; prototype cost-down isolation designs in parallel with functional development; track projected unit cost against L0_Constraints::Business::costEffective.";
                rationale   = "Medium probability (isolation-capable components carry a known cost premium) and medium impact (threatens, but does not by itself eliminate, affordability) combine to a major severity per the project risk matrix; this is a business/cost risk rather than a schedule risk — see the related schedule consequence in RISK-SC-01.";
                status      = RiskStatus::open;
                riskOwner   = "Project Manager";
            }
        }
    } // package BusinessRisks

    package ScheduleRisks {
        requirement <'RISK-SC-01'> Risk_IsolationComponentSourcingDelay : ScheduleRisk {
            subject controller : BaseArchitecture::ShutterController;
            doc
            /* Sourcing galvanic-isolation components that simultaneously
             * satisfy the safety isolation requirement and the cost target
             * may take longer than planned, delaying integration testing
             * and the overall project schedule while cheaper or
             * alternative-supplier components are qualified.
             */
            @RiskMeta {
                probability = RiskLevel::medium;
                impact      = RiskLevel::medium;
                severity    = RiskSeverity::major;
                mitigation  = "Arrange a hardware-in-the-loop or bench-test fallback for integration testing while isolation component sourcing is finalized; qualify at least one second-source supplier in parallel.";
                rationale   = "Medium probability (component qualification lead times are a common source of schedule slip) and medium impact (delays integration testing but does not block it entirely given a fallback) combine to a major severity per the project risk matrix; this schedule risk is a direct consequence of mitigating RISK-S-01 and RISK-B-01.";
                status      = RiskStatus::open;
                riskOwner   = "Project Manager";
            }
        }
    } // package ScheduleRisks

    package IntegrationRisks {
        requirement <'RISK-I-01'> Risk_WallSwitchWiringIncompatibility : IntegrationRisk {
            subject controller : BaseArchitecture::ShutterController;
            doc
            /* Existing wall switch wiring conventions vary across
             * installations (e.g., number of wires, momentary vs. latching
             * switch behavior), and the controller's WallSwitchInterface
             * may not support all variants encountered during installation,
             * limiting compatibility with existing residential wiring.
             */
            @RiskMeta {
                probability = RiskLevel::medium;
                impact      = RiskLevel::medium;
                severity    = RiskSeverity::major;
                mitigation  = "Document supported wall switch wiring topologies; provide a configurable input mode (momentary/latching) validated during installer configuration; verify via the VerifyLocalControl test case.";
                rationale   = "Medium probability (residential wall switch wiring is not standardized across markets) and medium impact (limits, but does not eliminate, addressable installations) combine to a major severity per the project risk matrix; directly threatens the localControl system objective.";
                status      = RiskStatus::open;
                riskOwner   = "System Architect";
            }
        }
    } // package IntegrationRisks
} // package Risks
