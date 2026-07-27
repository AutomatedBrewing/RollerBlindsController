package Verification {
    private import VerificationCases::*;
    private import BaseArchitecture::*;
    private import L0_Requirements::*;
    private import L0_Constraints::*;
    private import LogicalArchitecture::*;
    private import ProductComponents::*;

    package Functional {
        verification def VerifyLocalControl {
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::controlRollerShutter;
                verify L0_Requirements::Functional::localControl;
                verify L0_Requirements::Interface::wallSwitchWiringCompatibility;
            }
        }
        verification def VerifyRemoteControl {
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::controlRollerShutter;
                verify L0_Requirements::Functional::remoteControl;
                verify L0_Requirements::Interface::remoteControlWiringCompatibility;
            }
        }
        verification def VerifyAutomaticOpening {
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::fullShutterMovement;
            }
        }
        verification def VerifyAutomaticClosing {
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::fullShutterMovement;
            }
        }
        verification def VerifyManualPositioning {
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::manualPositioning;
            }
        }
        verification def VerifyMovementStop {
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::stopShutterMovement;
            }
        }
    } // package Functional

    package Quality {
        verification def VerifyEaseOfInstallation {
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Quality::easeOfInstallation;
                verify L0_Requirements::Functional::configurationMode;
            }
        }
        verification def VerifyReliability {
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Quality::reliability;
            }
        }
        verification def VerifyAvailability {
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Quality::availability;
            }
        }
        verification def VerifyDiagnosability {
            doc
            /* Added to close Major finding M3 (system model review corrective
             * pass): verifies REQ-Q-04, previously unrepresented anywhere in
             * the Verification model. */
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Quality::diagnosability;
            }
        }
        verification def VerifyFieldReplaceability {
            doc
            /* Added to close Major finding M3 (system model review corrective
             * pass): verifies REQ-Q-05, previously unrepresented anywhere in
             * the Verification model. */
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Quality::fieldReplaceability;
            }
        }
    } // package Quality

    package Constraints {
        verification def VerifySupplyVoltageRange {
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Safety::safety;
            }
        }
        verification def VerifyMaximumSwitchingLoad {
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Safety::safety;
            }
        }
        verification def VerifyDimensions {
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Constraints::Physical::compactDimensions;
            }
        }
        verification def VerifyOperatingTemperatureRange {
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Constraints::Environmental::operatingConditions;
            }
        }
        verification def VerifyTimeBasedOperation {
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::configurableTimingProfile;
            }
        }
        verification def VerifyNoPositionFeedbackDependency {
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Constraints::Architectural::noPositionFeedback;
            }
        }
        verification def VerifyConflictNotification {
            doc
            /* Added to close Major finding M2 (system model review corrective
             * pass): verifies REQ-S-02, previously unrepresented anywhere in
             * the Verification model (the prior silent-conflict behavior had
             * no requirement, and therefore no verification, at all). */
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Safety::conflictIndication;
            }
        }
    } // package Constraints

    package Environmental {
        verification def VerifyDisposal {
            subject controller : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Environmental::regulatedDisposal;
            }
        }
    } // package Environmental

    /* Component-scoped (white-box) verification cases — Logical Architecture.
     * Closes formal-review finding C8: previously every verification def
     * subject was BaseArchitecture::ShutterController (black-box only), giving
     * individual Logical responsibilities (arbitration, configuration-mode
     * state management) no dedicated verification hook distinct from
     * system-level testing. Subjects are typed by the Logical component
     * CLASSIFIERS themselves (part defs), not by their package-level feature
     * usages: a usage (e.g. logicalControlUnit) cannot type another usage in
     * SysML v2 -- only a classifier/definition can (Syside "usage-feature-
     * typing" rule fix). LogicalControlUnit/LogicalUserNotification are
     * already in unqualified scope via the 'private import LogicalArchitecture::*;'
     * above. */
    package Logical {
        verification def VerifyCommandArbitration {
            doc
            /* White-box confirmation of LogicalControlUnit's first-wins
             * local/remote arbitration policy and UP+DOWN conflict detection
             * (UC_01e), independent of the black-box VerifyLocalControl /
             * VerifyRemoteControl system tests. */
            subject controlUnit : LogicalControlUnit;
            objective {
                verify L0_Requirements::Safety::safety;
                verify L0_Requirements::Functional::controlRollerShutter;
            }
        }
        verification def VerifyConfigurationModeTransitions {
            doc
            /* White-box confirmation that LogicalControlUnit's configuration-
             * mode state transitions correctly emit a typed ConfigModeEvent
             * consumed by LogicalUserNotification (UC_03). */
            subject controlUnit : LogicalControlUnit;
            objective {
                verify L0_Requirements::Functional::configurationMode;
            }
        }
        verification def VerifyUserNotificationDispatch {
            doc
            /* White-box confirmation that LogicalUserNotification dispatches
             * user-visible feedback for both configuration-mode transition
             * kinds (activated / deactivated). */
            subject notifier : LogicalUserNotification;
            objective {
                verify L0_Requirements::Functional::configurationMode;
            }
        }

        // The two verification defs below close the formal Logical
        // Architecture review's testability finding (this pass):
        // LogicalMotorDrive and LogicalMovementSupervisor previously had no
        // white-box verification hook distinct from system-level testing,
        // even though both carry the primary structural responsibility for
        // REQ-Q-02/REQ-Q-03 (availability/reliability, alongside
        // LogicalControlUnit -- see Traceability::Traceability) and for the
        // CRITICAL-1 stop/release interface fix added in this same review
        // pass.
        verification def VerifyMotorDriveEndurance {
            doc
            /* White-box confirmation that LogicalMotorDrive correctly
             * energizes/de-energizes the motor relay circuit in response to
             * validated movement and stop requests across repeated cycles,
             * independent of the black-box VerifyReliability system test.
             * Directly targets the component most exposed to RISK-T-03
             * (motor relay wear-out). */
            subject motorDrive : LogicalMotorDrive;
            objective {
                verify L0_Requirements::Quality::reliability;
                verify L0_Requirements::Quality::availability;
            }
        }
        verification def VerifyMovementSupervisionTiming {
            doc
            /* White-box confirmation that LogicalMovementSupervisor correctly
             * selects and applies the direction-specific timeout from the
             * received TravelTime (automatic mode) and correctly reacts to
             * the relayed ControlCommand stream for release/repeated-press
             * stop detection (manual mode, CRITICAL-1 fix), independent of
             * the black-box VerifyAutomaticOpening/VerifyAutomaticClosing/
             * VerifyManualPositioning/VerifyMovementStop system tests. */
            subject supervisor : LogicalMovementSupervisor;
            objective {
                verify L0_Requirements::Functional::fullShutterMovement;
                verify L0_Requirements::Functional::manualPositioning;
                verify L0_Requirements::Functional::stopShutterMovement;
                verify L0_Requirements::Functional::configurableTimingProfile;
            }
        }
    } // package Logical

    /* Component-scoped (white-box) verification cases — Product Architecture.
     * PA-4 fix (Product Architecture Review, model_issues.md item 18): closes
     * the previously MISSING Product-layer verification package (the Product
     * Architecture Review found no verification def anywhere referenced a
     * Product component -- every existing verification def's subject was
     * either BaseArchitecture::ShutterController (black-box) or a Logical
     * component (white-box one layer up)). Mirrors the exact 'package Logical'
     * pattern immediately above: subjects are typed by Product component
     * CLASSIFIERS themselves (part defs, already in unqualified scope via
     * 'private import ProductComponents::*;' above), not by their
     * package-level feature usages, since a usage cannot type another usage
     * in SysML v2. These verification defs give TC_F_002, TC_F_003, and
     * TC_Q_004 (SystemTestCases.sysml) a Product-layer verification hook to
     * satisfy, closing PA-4's "dangling test case" finding. */
    package Product {
        verification def VerifyWiringModeConfiguration {
            doc
            /* White-box confirmation that CommandArbitrationSoftware
             * correctly interprets the installer-selected wiringMode
             * (WiringMode::momentary / WiringMode::latching,
             * ProductComponents.sysml PA-2 fix) when translating the raw
             * local/remote dry-contact signal into a ControlCommand.
             * Directly exercised by TC_F_002 (momentary) and TC_F_003
             * (latching). */
            subject arbiter : CommandArbitrationSoftware;
            objective {
                verify L0_Requirements::Interface::wallSwitchWiringCompatibility;
                verify L0_Requirements::Functional::controlRollerShutter;
            }
        }
        verification def VerifyDiagnosticFaultClassification {
            doc
            /* White-box confirmation that DiagnosticsSoftware correctly
             * classifies "no response to any control input" versus
             * "motor-drive fault" using its commandStateIn/diagnosticStateIn
             * taps, and emits the result on faultOut to UserFeedbackSoftware
             * (ProductComponents.sysml PA-1 fix, closing the Diagnostics
             * dead-end). Directly exercised by TC_Q_004. */
            subject diag : DiagnosticsSoftware;
            objective {
                verify L0_Requirements::Quality::diagnosability;
                verify L0_Requirements::Quality::fieldReplaceability;
            }
        }
        verification def VerifyMotorRelayEnduranceRating {
            doc
            /* White-box confirmation that MotorDriveRelayModule's rated
             * mechanical switching endurance (ratedCycleCount) and MTBF
             * (mtbfHours) estimate, added by the PA-3 fix, meet the
             * reliability/availability targets driven by
             * RISK-T-03_MotorRelayWearOut. Complements (does not replace)
             * Verification::Logical::VerifyMotorDriveEndurance, which
             * verifies LogicalMotorDrive's behavioral switching logic one
             * layer up. */
            subject relay : MotorDriveRelayModule;
            objective {
                verify L0_Requirements::Quality::reliability;
                verify L0_Requirements::Quality::availability;
            }
        }
        verification def VerifyRequestInterfaceIsolation {
            doc
            /* White-box confirmation that RequestInterfaceCircuit's
             * opto-isolation stage satisfies both the safety requirement and
             * the Electrical constraint it is designed to close -- a
             * requirement usage (L0_Requirements::Safety::safety) and a
             * constraint usage (L0_Constraints::Electrical::inputIsolation)
             * are both valid 'verify' targets (both are 'requirement'
             * usages in SysML v2, per sysml-modeling.instructions.md). */
            subject reqIf : RequestInterfaceCircuit;
            objective {
                verify L0_Requirements::Safety::safety;
                verify L0_Constraints::Electrical::inputIsolation;
            }
        }
    } // package Product
} // package Verification
