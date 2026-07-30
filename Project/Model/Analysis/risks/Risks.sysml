package Risks {
    private import ScalarValues::String;
    private import BaseArchitecture::*;

    /* Captures identified threats to system objectives, safety, and delivery.
     * Traceability to mitigating Requirements/Constraints is modeled in Traceability::Traceability.
     */

    enum def RiskLevel { low; medium; high; }
    enum def RiskSeverity { minor; major; critical; }
    enum def RiskStatus { open; mitigated; closed; }

    metadata def RiskMeta {
        attribute probability : RiskLevel;
        attribute impact      : RiskLevel;
        attribute severity    : RiskSeverity;
        attribute mitigation  : String;
        attribute rationale   : String;   // Justifies probability/impact assessment and any severity-matrix deviation.
        attribute status      : RiskStatus;
        attribute riskOwner   : String;   // Free-text role name; no formal organizational role type exists in this model's Stakeholders package.
    }

    /* Layer 1 requirement def templates binding the risk subject to the system under design.
     * Layer 2 requirement usages carry doc text, @RiskMeta, and a Risk ID for cross-reference.
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
                rationale   = "Timing drift accumulates gradually (medium probability) but is user-recoverable via reconfiguration (medium impact), combining to major severity; threatens the no-position-feedback design choice.";
                status      = RiskStatus::open;
                riskOwner   = "System Architect";
            }
        }

        // Note: RISK-T-02 is not assigned in this register; numbering continues at RISK-T-03.

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
                mitigation  = "Select relay/triac switching components rated for at least 10,000 switching cycles at the rated 8 A / 230 VAC load; validate via TC_Q_003_ReliabilityEndurance.";
                rationale   = "Component wear is a well-understood failure mode over the required duty cycle (medium probability/impact), combining to major severity; threatens the reliability system objective.";
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
                mitigation  = "Provide a per-installation configurable timing profile; document a validated range of compatible motor types; verify via TC_F_012_ConfigurableTimingProfile_Nominal.";
                rationale   = "Motor speed/torque variation across manufacturers (medium probability) limits addressable market (medium impact), combining to major severity; threatens the rollerShutterCompatibility objective.";
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
                mitigation  = "Provide a guided configuration-mode procedure with an out-of-range calibration guard (maxConfigurableTravelTime <= 120 s) that rejects invalid measurements; validate via TC_Q_001_InstallationTime.";
                rationale   = "First-time installer misconfiguration is likely (medium probability) but easily corrected by re-entering configuration mode (low impact), combining to minor severity; threatens the easeOfUse objective.";
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
                mitigation  = "Mandate galvanic isolation for motor and input interfaces per L0_Constraints::Electrical::motorIsolation and inputIsolation; verify via TC_B_001/TC_B_002 (supply voltage) and TC_B_006 (switching load) in SystemTestCases::Boundary.";
                rationale   = "Severity escalated from matrix default (major) to critical because electric shock is a safety-of-life hazard, consistent with ALARP treatment of safety-critical hazards.";
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
                rationale   = "Isolation-capable components carry a known cost premium (medium probability/impact), combining to major severity.";
                status      = RiskStatus::open;
                riskOwner   = "Project Manager";
            }
        }
    } // package BusinessRisks

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
                mitigation  = "Document supported wall switch wiring topologies; provide a configurable input mode (momentary/latching) validated during installer configuration; verify via TC_F_002/TC_F_003 (local control, momentary/latching).";
                rationale   = "Non-standardized wiring conventions (medium probability) limit but do not eliminate compatible installations (medium impact), combining to major severity; threatens the localControl objective.";
                status      = RiskStatus::open;
                riskOwner   = "System Architect";
            }
        }
    } // package IntegrationRisks
} // package Risks
