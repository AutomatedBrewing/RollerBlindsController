package SystemTestCases {
    private import VerificationCases::*;
    private import BaseArchitecture::*;
    private import L0_Requirements::*;
    private import L0_Constraints::*;
    private import DomainKnowledge::*;
    private import ScalarValues::*;

    /* Metadata annotation applied to every verification def in this package.
     * Captures test classification for use in requirement traceability matrices and
     * test execution planning (SM-PRD-16, cross-mapping §2). */
    metadata def TestCaseMeta {
        attribute testType           : String;   // systemTestCase | modelTestCase
        attribute verificationMethod : String;   // test | analysis | inspection | demonstration
        attribute priority           : String;   // critical | high | medium | low
        attribute category           : String;   // Functional | Safety | Quality | Environmental | Boundary | Negative
    }

    // =========================================================================
    // Functional Test Cases — TC-F-001 … TC-F-013
    // Verify required system behavior, user interactions, and nominal workflows.
    // =========================================================================
    package Functional {

        verification def TC_F_001_SystemControlIntegration {
            doc /* End-to-end integration: verify the complete shutter control pipeline
                 * (local + remote command reception → movement → stop) satisfies the
                 * top-level control requirement REQ-F-01. */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::controlRollerShutter;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "critical";
                category           = "Functional";
            }
            action setup {
                doc /* Power controller from 12 V DC supply. Connect representative shutter motor load.
                     * Confirm no motor current at rest. Confirm wall-switch and remote inputs both idle. */
            }
            action execute {
                doc /* 1. Assert local UP. Confirm motor energizes in UP direction.
                     * 2. Assert STOP. Confirm motor de-energizes.
                     * 3. Assert local DOWN. Confirm motor energizes in DOWN direction.
                     * 4. Assert STOP. Confirm motor de-energizes.
                     * 5. Assert remote UP. Confirm motor energizes in UP direction.
                     * 6. Allow run to configured timeout. Confirm motor de-energizes automatically. */
            }
            action verifyOutcome {
                doc /* PASS if: every directional command energizes motor in correct direction;
                     * explicit STOP de-energizes motor within 200 ms;
                     * timeout de-energizes motor autonomously;
                     * no spurious motor activation occurs between commands. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_F_002_LocalControl_MomentarySwitch {
            doc /* Verify local wall-switch control using a momentary-contact topology.
                 * Covers REQ-F-02 (local control) and REQ-I-01 (momentary topology variant). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::localControl;
                verify L0_Requirements::Interface::wallSwitchWiringCompatibility;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "critical";
                category           = "Functional";
            }
            action setup {
                doc /* Configure controller for momentary wall-switch topology via installer
                     * configuration procedure. Connect momentary push-buttons to local UP and
                     * DOWN inputs. Remote inputs unasserted. Controller powered and idle.
                     * Concretely (PA-2 fix, ProductComponents.sysml): the installer selection
                     * sets ConfigurationManagerSoftware.wiringMode = WiringMode::momentary,
                     * persisted by MemoryManagerSoftware.persistedWiringMode and interpreted by
                     * CommandArbitrationSoftware.wiringMode when translating the raw dry-contact
                     * signal into a ControlCommand -- exercised by
                     * Verification::Product::VerifyWiringModeConfiguration. */
            }
            action execute {
                doc /* 1. Briefly press UP push-button (< 500 ms pulse) and release.
                     * 2. Observe motor activation direction.
                     * 3. Allow movement to complete (timeout) or issue STOP.
                     * 4. Briefly press DOWN push-button (< 500 ms) and release.
                     * 5. Observe motor activation direction.
                     * 6. Allow movement to complete. */
            }
            action verifyOutcome {
                doc /* PASS if: brief UP press activates motor in up direction;
                     * brief DOWN press activates motor in down direction;
                     * behavior matches configured momentary-topology semantics. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_F_003_LocalControl_LatchingSwitch {
            doc /* Verify local wall-switch control using a latching (toggle) contact topology.
                 * Covers REQ-F-02 (local control) and REQ-I-01 (latching topology variant). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::localControl;
                verify L0_Requirements::Interface::wallSwitchWiringCompatibility;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "critical";
                category           = "Functional";
            }
            action setup {
                doc /* Configure controller for latching wall-switch topology. Connect latching
                     * toggle switches to local UP and DOWN inputs. Remote inputs unasserted.
                     * Concretely (PA-2 fix, ProductComponents.sysml): the installer selection
                     * sets ConfigurationManagerSoftware.wiringMode = WiringMode::latching,
                     * persisted by MemoryManagerSoftware.persistedWiringMode and interpreted by
                     * CommandArbitrationSoftware.wiringMode when translating the raw dry-contact
                     * signal into a ControlCommand -- exercised by
                     * Verification::Product::VerifyWiringModeConfiguration. */
            }
            action execute {
                doc /* 1. Toggle UP switch to ON (latched closed). Observe motor.
                     * 2. Toggle UP switch to OFF (latched open). Observe motor response.
                     * 3. Toggle DOWN switch to ON. Observe motor.
                     * 4. Toggle DOWN switch to OFF. Observe motor response. */
            }
            action verifyOutcome {
                doc /* PASS if: toggling UP ON activates motor in up direction;
                     * toggling DOWN ON activates motor in down direction;
                     * toggling OFF applies configured stop semantics;
                     * no cross-activation observed when only one switch is toggled. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_F_004_RemoteControl_UP {
            doc /* Verify that asserting the UP dry-contact remote input triggers upward
                 * shutter movement identical to local switch behavior (REQ-F-03, REQ-I-02). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::remoteControl;
                verify L0_Requirements::Interface::remoteControlWiringCompatibility;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "critical";
                category           = "Functional";
            }
            action setup {
                doc /* Connect relay/dry-contact test fixture to REMOTE UP input.
                     * Local switch inputs idle. Controller powered and idle. Current meter on motor output. */
            }
            action execute {
                doc /* 1. Close REMOTE UP dry-contact (assert voltage-present).
                     * 2. Observe motor current direction.
                     * 3. Open REMOTE UP contact (release). Observe motor response.
                     * 4. Repeat three times to confirm consistency. */
            }
            action verifyOutcome {
                doc /* PASS if: asserting REMOTE UP energizes motor in UP direction;
                     * behavior is electrically and behaviorally identical to local UP input;
                     * consistent results across all three repetitions. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_F_005_RemoteControl_DOWN {
            doc /* Verify that asserting the DOWN dry-contact remote input triggers downward
                 * shutter movement (REQ-F-03, REQ-I-02). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::remoteControl;
                verify L0_Requirements::Interface::remoteControlWiringCompatibility;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "critical";
                category           = "Functional";
            }
            action setup {
                doc /* Connect relay/dry-contact fixture to REMOTE DOWN input.
                     * Local switch inputs idle. Controller powered and idle. */
            }
            action execute {
                doc /* 1. Close REMOTE DOWN dry-contact. Observe motor current direction.
                     * 2. Open REMOTE DOWN contact. Observe motor response.
                     * 3. Repeat three times. */
            }
            action verifyOutcome {
                doc /* PASS if: asserting REMOTE DOWN energizes motor in DOWN direction;
                     * identical behavior to local DOWN input;
                     * consistent across all three repetitions. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_F_006_AutomaticFullOpen {
            doc /* Verify that a brief UP command causes automatic full-travel to the open
                 * position, stopping autonomously on timeout (REQ-F-04, UC-01a,
                 * ACT-OpenShutterAutomatically, ACT-MonitorStopCondition). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::fullShutterMovement;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "critical";
                category           = "Functional";
            }
            action setup {
                doc /* Position shutter at fully closed. Configure timing profile with known
                     * open travel time T_open (e.g., 30 s). Controller powered and idle.
                     * Reference stopwatch ready. */
            }
            action execute {
                doc /* 1. Assert UP command briefly (< 500 ms momentary press) and release.
                     * 2. Start stopwatch at command release.
                     * 3. Observe motor until it de-energizes without further input.
                     * 4. Stop stopwatch. Record elapsed time. Confirm shutter position. */
            }
            action verifyOutcome {
                doc /* PASS if: motor runs in UP direction autonomously after command release;
                     * motor de-energizes after T_open ± 5% seconds without a second command;
                     * shutter reaches fully open position;
                     * ShutterState.moving == false after stop; StopRequest.reason == timeout. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_F_007_AutomaticFullClose {
            doc /* Verify that a brief DOWN command triggers automatic full-travel to the
                 * closed position, stopping autonomously on timeout (REQ-F-04, UC-01b,
                 * ACT-CloseShutterAutomatically). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::fullShutterMovement;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "critical";
                category           = "Functional";
            }
            action setup {
                doc /* Position shutter at fully open. Configure timing profile with known
                     * close travel time T_close. Controller powered and idle. Stopwatch ready. */
            }
            action execute {
                doc /* 1. Assert DOWN command briefly. Release. Start stopwatch.
                     * 2. Observe motor until autonomous de-energization.
                     * 3. Stop stopwatch. Record elapsed time. Confirm shutter fully closed. */
            }
            action verifyOutcome {
                doc /* PASS if: motor runs in DOWN direction autonomously after release;
                     * de-energizes after T_close ± 5%; shutter fully closed; no manual stop required. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_F_008_ManualPartialOpen {
            doc /* Verify hold-to-run upward movement: shutter moves up only while UP is held
                 * and stops on release at an intermediate position (REQ-F-05, UC-01c,
                 * ACT-OpenShutterManually, ACT-MonitorUserInterruption). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::manualPositioning;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "high";
                category           = "Functional";
            }
            action setup {
                doc /* Set shutter to an intermediate position (approx. 50% travel).
                     * Activate manual (hold-to-run) mode per the applicable activation procedure.
                     * Controller powered. */
            }
            action execute {
                doc /* 1. Hold UP command asserted continuously for 3 seconds.
                     * 2. Confirm motor energized in UP direction throughout hold.
                     * 3. Release UP command. Measure time from release to motor de-energization.
                     * 4. Confirm shutter stopped at an intermediate position. */
            }
            action verifyOutcome {
                doc /* PASS if: motor energizes in UP direction while UP is held;
                     * motor de-energizes within 200 ms of UP release;
                     * shutter stops at intermediate position (not fully open);
                     * StopRequest.reason == userRequest. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_F_009_ManualPartialClose {
            doc /* Verify hold-to-run downward movement: shutter moves down only while DOWN
                 * is held and stops on release (REQ-F-05, UC-01d, ACT-CloseShutterManually). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::manualPositioning;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "high";
                category           = "Functional";
            }
            action setup {
                doc /* Set shutter to intermediate position. Activate manual mode. Controller powered. */
            }
            action execute {
                doc /* 1. Hold DOWN command for 3 seconds. Confirm motor energized in DOWN direction.
                     * 2. Release DOWN. Measure time to de-energization.
                     * 3. Confirm shutter at intermediate position. */
            }
            action verifyOutcome {
                doc /* PASS if: motor energizes in DOWN direction while held;
                     * de-energizes within 200 ms of release;
                     * shutter stops at intermediate position. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_F_010_StopDuringOpening {
            doc /* Verify that a stop command issued during automatic opening immediately
                 * de-energizes the motor (REQ-F-06, UC-01, ACT-MonitorStopCondition,
                 * ACT-StopShutterMovement). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::stopShutterMovement;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "critical";
                category           = "Functional";
            }
            action setup {
                doc /* Initiate automatic full-open sequence (brief UP press).
                     * Confirm motor is energized and shutter is mid-travel. Stopwatch ready. */
            }
            action execute {
                doc /* While motor is running (mid-travel), assert STOP command
                     * (second brief UP press per configured stop-command convention).
                     * Start stopwatch at STOP assertion. Observe motor. Stop stopwatch on de-energization. */
            }
            action verifyOutcome {
                doc /* PASS if: motor de-energizes within 200 ms of STOP assertion;
                     * ShutterState.moving transitions to false;
                     * shutter stops at intermediate position;
                     * StopRequest.reason == userRequest. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_F_011_StopDuringClosing {
            doc /* Verify that a stop command during automatic closing immediately de-energizes
                 * the motor (REQ-F-06, UC-01, ACT-StopShutterMovement). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::stopShutterMovement;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "critical";
                category           = "Functional";
            }
            action setup {
                doc /* Initiate automatic full-close sequence. Confirm motor energized in DOWN
                     * direction and shutter mid-travel. */
            }
            action execute {
                doc /* While motor is running, assert STOP command. Measure time to de-energization. */
            }
            action verifyOutcome {
                doc /* PASS if: motor de-energizes within 200 ms of STOP;
                     * ShutterState.moving becomes false; shutter stops mid-travel. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_F_012_ConfigurableTimingProfile_Nominal {
            doc /* Verify the full configuration workflow: open and close travel times are
                 * independently measured, saved, and used as the automatic-mode timeout
                 * (REQ-F-07, REQ-F-08, UC-03, ACT-ConfigureController, ACT-CountActionTime,
                 * ACT-SaveCountedTime, ACT-LoadTimingProfile). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::configurableTimingProfile;
                verify L0_Requirements::Functional::configurationMode;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "critical";
                category           = "Functional";
            }
            action setup {
                doc /* Move shutter to fully closed. Controller powered. Configuration mode not active.
                     * Reference stopwatch available for independent time measurement. */
            }
            action execute {
                doc /* 1. Activate configuration mode via installer action.
                     * 2. Confirm activation user-notification signal is present.
                     * 3. Hold UP in manual mode; measure independent T_open_ref with stopwatch until fully open.
                     * 4. System records T_open internally.
                     * 5. Hold DOWN in manual mode; measure T_close_ref until fully closed.
                     * 6. System records T_close internally.
                     * 7. Exit configuration mode. Confirm deactivation notification.
                     * 8. Run automatic full-open command. Measure actual motor run time T_open_act.
                     * 9. Run automatic full-close command. Measure T_close_act. */
            }
            action verifyOutcome {
                doc /* PASS if: activation notification is exactly
                     * ProductComponents::UserFeedbackSoftware.configModeActivationBeepCount == 1
                     * pulse and deactivation notification is exactly
                     * configModeDeactivationBeepCount == 2 pulses (MAJ-9 fix: measurable
                     * pulse-count criterion, see TC_F_013 for full acoustic detail);
                     * T_open_act is within T_open_ref ± 5%;
                     * T_close_act is within T_close_ref ± 5%;
                     * open and close times are independently configurable and retained. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_F_013_ConfigurationMode_Notification {
            doc /* Verify that distinct user-visible notifications are produced on both
                 * configuration mode activation and deactivation (REQ-F-08, UC-03,
                 * ACT-ActivateConfigurationMode, ACT-NotifyUserAboutActivationOfConfigurationMode,
                 * ACT-ExitConfigurationMode, ACT-NotifyUserAboutDeactivationOfConfigurationMode).
                 * MAJ-9 fix (SMRR corrective pass): pass criteria below now
                 * cite ProductComponents::UserFeedbackSoftware's measurable
                 * beep-pattern attributes (pulse count + duration) instead of
                 * the previous qualitative "clearly distinguishable" wording;
                 * same test intent (activation/deactivation/silent states
                 * must remain audibly distinct), objective threshold. */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::configurationMode;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "demonstration";
                priority           = "high";
                category           = "Functional";
            }
            action setup {
                doc /* Controller powered in normal operation mode. No movement in progress.
                     * User/installer present with a stopwatch to time/count buzzer pulses
                     * (beep pattern). */
            }
            action execute {
                doc /* 1. Perform installer activation action. Observe/count audible buzzer pulses immediately.
                     * 2. Record buzzer pattern during configuration mode.
                     * 3. Perform installer deactivation action. Observe/count buzzer pulses immediately. */
            }
            action verifyOutcome {
                doc /* PASS if: activation produces exactly
                     * configModeActivationBeepCount == 1 pulse of
                     * configModeActivationBeepMs == 200 ms (single short beep);
                     * buzzer is silent (0 pulses) throughout configuration mode itself;
                     * deactivation produces exactly
                     * configModeDeactivationBeepCount == 2 pulses of
                     * configModeDeactivationBeepMs == 200 ms each, separated by
                     * configModeBeepGapMs == 150 ms (double short beep, pulse-count
                     * distinct from activation's single beep);
                     * normal-operation buzzer state (silent, 0 pulses) is restored
                     * after deactivation. */
            }
            return verdict : VerdictKind;
        }

    } // package Functional

    // =========================================================================
    // Safety Test Cases — TC-S-001 … TC-S-003
    // Verify conflict suppression and SELV isolation (REQ-S-01, UC-01e).
    // =========================================================================
    package Safety {

        verification def TC_S_001_ConflictSuppression_LocalUPDOWN {
            doc /* Verify that simultaneously asserting local UP and DOWN keeps the motor
                 * de-energized in both directions (REQ-S-01, UC-01e,
                 * ACT-HandleConflictingMovementCommands, ACT-DetermineMovementRequest). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Safety::safety;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "critical";
                category           = "Safety";
            }
            action setup {
                doc /* Controller powered and shutter stationary. Motor current-monitoring instrument
                     * connected to both UP and DOWN motor output terminals.
                     * No prior movement in progress. */
            }
            action execute {
                doc /* Simultaneously assert both local UP and local DOWN switch inputs.
                     * Hold both asserted for 2 seconds. Monitor motor terminals for current or voltage
                     * in either direction throughout the 2-second period. */
            }
            action verifyOutcome {
                doc /* PASS if: zero motor current in UP direction throughout 2-second test;
                     * zero motor current in DOWN direction throughout 2-second test;
                     * ShutterState.moving remains false;
                     * MotorState.enable remains false. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_S_002_ConflictSuppression_LocalRemoteCross {
            doc /* Verify that a cross-source conflict (local UP + remote DOWN, or remote UP +
                 * local DOWN) also keeps the motor de-energized (REQ-S-01, UC-01e). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Safety::safety;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "critical";
                category           = "Safety";
            }
            action setup {
                doc /* Controller powered and idle. Motor current monitor on both output terminals.
                     * Local switch inputs and remote dry-contact fixture both accessible. */
            }
            action execute {
                doc /* Scenario A: simultaneously assert local UP + remote DOWN dry-contact.
                     * Hold 2 seconds. Monitor motor terminals.
                     * Scenario B: simultaneously assert remote UP dry-contact + local DOWN.
                     * Hold 2 seconds. Monitor motor terminals. */
            }
            action verifyOutcome {
                doc /* PASS if: zero motor current in both directions for Scenario A and Scenario B;
                     * no shutter movement observed in either scenario. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_S_003_AccessibleVoltage_SELV {
            doc /* Verify that no user- or installer-accessible interface point exceeds the
                 * 50 V AC SELV limit, and that galvanic isolation is intact between the
                 * mains-switching motor circuit and the low-voltage control circuit
                 * (REQ-S-01, L0_Constraints::Electrical::motorIsolation,
                 *  L0_Constraints::Electrical::inputIsolation). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Safety::safety;
                verify L0_Constraints::Electrical::motorIsolation;
                verify L0_Constraints::Electrical::inputIsolation;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "critical";
                category           = "Safety";
            }
            action setup {
                doc /* Install controller in representative enclosure with 12 V DC control supply
                     * and 230 V AC motor switching supply connected. Calibrated high-impedance
                     * voltmeter and insulation resistance tester available. */
            }
            action execute {
                doc /* 1. With motor idle: measure voltage between each accessible terminal
                     *    (wall-switch inputs, remote inputs, control supply terminals) and
                     *    mains earth reference.
                     * 2. With motor running: repeat all voltage measurements.
                     * 3. De-energize all supplies. Measure insulation resistance between
                     *    motor circuit conductors and control-circuit conductors. */
            }
            action verifyOutcome {
                doc /* PASS if: all terminal-to-earth voltage measurements ≤ 50 V AC (SELV limit);
                     * no accessible point references mains potential in idle or running state;
                     * insulation resistance between motor circuit and control circuit ≥ 1 MΩ
                     * (confirming galvanic isolation). */
            }
            return verdict : VerdictKind;
        }

        verification def TC_S_004_ConflictNotification_UserFeedback {
            doc
            /* Added to close Major finding M2 (system model review corrective
             * pass): verifies REQ-S-02 (conflictIndication). Previously the
             * suppressed-conflict state (TC_S_001/TC_S_002) had no
             * corresponding user-feedback test -- a user could not
             * distinguish a suppressed conflict from normal idle behavior.
             * MAJ-9 fix (SMRR corrective pass): pass criterion below now
             * cites ProductComponents::UserFeedbackSoftware's measurable
             * conflictSuppressionBeepCount/Ms attributes instead of the
             * previous qualitative "clearly distinguishable" wording; same
             * test intent, objective threshold. */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Safety::conflictIndication;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "high";
                category           = "Safety";
            }
            action setup {
                doc /* Controller powered and idle. Audible conflict-indication channel
                     * (distinct buzzer beep pattern) audible to the tester, who is
                     * equipped with a stopwatch to time/count buzzer pulses. */
            }
            action execute {
                doc /* Simultaneously assert local UP + local DOWN (mirrors TC_S_001).
                     * Observe the conflict-indication channel for 5 seconds; count
                     * pulses and measure each pulse's duration. */
            }
            action verifyOutcome {
                doc /* PASS if: within the 5 s observation window the buzzer emits
                     * exactly conflictSuppressionBeepCount == 3 pulses of
                     * conflictSuppressionBeepMs == 100 ms each while the motor
                     * remains de-energized (per TC_S_001); this 3-pulse pattern is
                     * pulse-count-distinct from both configuration-mode patterns
                     * (1 and 2 pulses, TC_F_013) and from the controller's normal
                     * idle (0-pulse, silent) state. */
            }
            return verdict : VerdictKind;
        }

    } // package Safety

    // =========================================================================
    // Quality Test Cases — TC-Q-001 … TC-Q-003
    // Verify ease-of-installation, availability, and endurance.
    // =========================================================================
    package Quality {

        verification def TC_Q_001_InstallationTime {
            doc /* Verify that a representative first-time installer completes full controller
                 * installation and basic functional verification within 30 minutes
                 * (REQ-Q-01, UC-02, ACT-InstallController). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Quality::easeOfInstallation;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "demonstration";
                priority           = "high";
                category           = "Quality";
            }
            action setup {
                doc /* Provide: one uninstalled controller, pre-existing wall-switch wiring in a
                     * wall box, 12 V DC control supply, shutter motor wired to junction box,
                     * installation instructions. Start stopwatch the moment the installer
                     * picks up the controller. */
            }
            action execute {
                doc /* Installer performs (unaided): mains isolation, wall-switch disassembly,
                     * controller wiring and connection, supply restoration, open/close functional
                     * verification, wall-switch reassembly. Stopwatch stops when installer
                     * declares installation complete and functional. */
            }
            action verifyOutcome {
                doc /* PASS if: total elapsed time ≤ 30 minutes (1800 s);
                     * final open/close verification cycle succeeds;
                     * only standard residential hand tools used (no specialist equipment). */
            }
            return verdict : VerdictKind;
        }

        verification def TC_Q_002_OperationalAvailability {
            doc /* Verify ≥ 99.8% operational availability: the proportion of valid control
                 * requests that the controller successfully executes (REQ-Q-02).
                 *
                 * MAJ-10 fix (SMRR corrective pass): this test case was self-declared
                 * "partially covered" with no explicit statement of (a) what evidence
                 * this test case *does* provide today and (b) what residual evidence
                 * is still needed to fully close REQ-Q-02. Both are now stated
                 * explicitly below, formalizing the residual gap rather than leaving
                 * it as a bare, undocumented "partial" note (option b in the SMRR
                 * closure instructions -- no fabricated field-data evidence is
                 * invented; the accelerated proxy result stands as current coverage).
                 *
                 * CURRENT VERIFICATION COVERAGE (provided by this test case):
                 * - 1 000-request accelerated bench proxy (≈ 30-day equivalent duty
                 *   cycle at 30-min request intervals), executed under controlled/
                 *   representative conditions with the harness described below.
                 * - Demonstrates the ≥ 99.8% pass-rate threshold is met (or not) under
                 *   that accelerated proxy -- i.e., functional-availability evidence
                 *   at bench scale, aligned with ADR-002's passive-MTBF sourcing
                 *   strategy (no active health-monitoring hardware added).
                 *
                 * REMAINING EVIDENCE NEEDED (residual gap, not yet closed):
                 * - A full 12-month field-deployment measurement across a
                 *   representative install-base sample, to confirm the bench proxy's
                 *   accelerated duty cycle is representative of real seasonal/
                 *   environmental usage patterns (temperature cycling, mains-supply
                 *   variability) not exercised on the bench.
                 * - Until that field campaign completes, REQ-Q-02 remains Partially
                 *   Realized at the requirement-realization layer (see Traceability.sysml)
                 *   -- this is a residual verification gap, not a defect, and is
                 *   explicitly tracked rather than silently assumed closed. */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Quality::availability;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "analysis";
                priority           = "high";
                category           = "Quality";
            }
            action setup {
                doc /* Install controller in a representative residential environment.
                     * Configure automated test harness to issue one valid control request every
                     * 30 minutes and log each result as pass (motor responds correctly) or
                     * fail (no response, wrong direction, or no stop). Run for 1 000 requests
                     * minimum (≈ 30-day accelerated period). */
            }
            action execute {
                doc /* Harness issues 1 000 sequential UP or DOWN commands at 30-minute intervals.
                     * Each result (success / failure) logged with timestamp.
                     * Count total successful executions at end of run. */
            }
            action verifyOutcome {
                doc /* PASS if: (successful_requests / 1000) × 100 ≥ 99.8%
                     * (i.e., ≤ 2 failures in 1 000 requests) -- this closes the
                     * bench-scale accelerated-proxy evidence described above.
                     * NOTE (MAJ-10, residual gap formalized, not fabricated): a PASS
                     * here provides accelerated-proxy coverage only; the full 12-month
                     * field campaign remains the outstanding evidence required before
                     * REQ-Q-02 can be marked Fully Realized (see doc header). */
            }
            return verdict : VerdictKind;
        }

        verification def TC_Q_003_ReliabilityEndurance {
            doc /* Verify ≥ 10 000 shutter operation cycles without functional failure under
                 * rated conditions (REQ-Q-03, L0_Constraints::Environmental::operatingConditions,
                 * L0_Constraints::Electrical::switchingLoad). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Quality::reliability;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "high";
                category           = "Quality";
            }
            action setup {
                doc /* Mount controller on endurance bench with: 12 V DC supply, 230 V AC /
                     * 8 A resistive load (rated motor simulation), automated cycle controller,
                     * ambient 23 ± 5 °C. */
            }
            action execute {
                doc /* Execute automated open/close cycle loop:
                     * UP command (automatic) → wait for timeout → DOWN command (automatic)
                     * → wait for timeout → repeat. Log cumulative successful cycles and any failure.
                     * Run to 10 000 completed cycles. */
            }
            action verifyOutcome {
                doc /* PASS if: 10 000 cycles completed with zero functional failures
                     * (motor not energized on command; wrong direction; relay weld;
                     * failure to de-energize on command);
                     * no physical degradation (burning odor, relay contact damage,
                     * connector failure) observed at inspection after completion. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_Q_004_FieldDiagnosis {
            doc
            /* Added to close Major finding M3 (system model review corrective
             * pass): verifies REQ-Q-04 (diagnosability), previously
             * unrepresented anywhere in the Test Cases model -- UC_04 had no
             * test-level realization at all.
             * MAJ-9 fix (SMRR corrective pass): verifyOutcome below now cites
             * ProductComponents::UserFeedbackSoftware's measurable
             * faultNoResponseBeepCount/Ms and faultMotorDriveBeepCount/Ms
             * attributes instead of the previous qualitative "distinct buzzer
             * beep pattern" wording; same test intent, objective threshold. */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Quality::diagnosability;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "medium";
                category           = "Quality";
            }
            action setup {
                doc /* Install controller in representative environment. Recruit a
                     * maintenance technician with no prior product-specific training
                     * and no specialized lab equipment. */
            }
            action execute {
                doc /* Inject each supported fault class in turn (no power, no response
                     * to any control input, motor-drive fault). For each, ask the
                     * technician to observe the controller's field diagnostic
                     * indication and classify the fault.
                     * Concretely (PA-1 fix, ProductComponents.sysml/ProductInterfaces.sysml):
                     * "no power" requires no software involvement -- it is passively
                     * observable as the buzzer emitting no startup confirmation beep
                     * when control power is applied (see doc note on AudibleNotificationBuzzer, ADR-008). The other two fault classes are
                     * distinguished by DiagnosticsSoftware using its commandStateIn
                     * (CommandArbitrationSoftware.commandRelayOut tap) and diagnosticStateIn
                     * (MotorDriveControlSoftware.shutterStateOut tap) inputs, classified per
                     * ProductInterfaces::FaultClass, and reported on faultOut to
                     * UserFeedbackSoftware, which renders a distinct buzzer beep pattern
                     * (faultIndicationIn) -- exercised by
                     * Verification::Product::VerifyDiagnosticFaultClassification. */
            }
            action verifyOutcome {
                doc /* PASS if: the technician correctly classifies each injected fault
                     * class using only the field diagnostic indication, without
                     * specialized lab equipment;
                     * "no power" is correctly read from the buzzer emitting no startup beep;
                     * "no response to any control input" is correctly read from exactly
                     * faultNoResponseBeepCount == 1 pulse of faultNoResponseBeepMs == 600 ms
                     * (single LONG beep);
                     * "motor-drive fault" is correctly read from exactly
                     * faultMotorDriveBeepCount == 2 pulses of faultMotorDriveBeepMs == 600 ms
                     * each (double LONG beep, pulse-count distinct from the single-pulse
                     * no-response fault and from both configuration-mode/conflict patterns,
                     * TC_F_013/TC_S_004), produced by
                     * DiagnosticsSoftware.faultOut → UserFeedbackSoftware.faultIndicationIn. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_Q_005_FieldReplacement {
            doc
            /* Added to close Major finding M3 (system model review corrective
             * pass): verifies REQ-Q-05 (fieldReplaceability), previously
             * unrepresented anywhere in the Test Cases model.
             *
             * Top-20 fix #15 (finalReviewReport.md corrective pass): this test
             * case previously had no time-bound in verifyOutcome, inconsistent
             * with TC_Q_001's explicit <=30 min (1800 s) pass criterion. The
             * same <=30-minute bound is adopted here: field replacement swaps
             * only the controller unit via the existing screw-terminal wiring
             * (EnclosureAndConnectors, REQ-Q-05) with no wall-switch
             * disassembly or rewiring step, so it is bounded by the same
             * installer-facing budget REQ-Q-01/TC_Q_001 already establishes
             * for a full first-time installation, not a separate target. */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Quality::fieldReplaceability;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "medium";
                category           = "Quality";
            }
            action setup {
                doc /* Controller installed and wired per standard installation.
                     * Replacement controller unit available. Start stopwatch
                     * the moment the technician begins removing the faulty
                     * unit. */
            }
            action execute {
                doc /* Technician removes the faulty controller and installs the
                     * replacement unit using only the existing, unmodified wiring.
                     * Time the replacement. Exercise local and remote control after
                     * replacement. Stopwatch stops when the technician declares
                     * the replacement complete and functional. */
            }
            action verifyOutcome {
                doc /* PASS if: total elapsed time <= 30 minutes (1800 s), the
                     * same bound as TC_Q_001's full-installation criterion;
                     * the replacement unit is installed using only the
                     * existing wiring (no rewiring); normal operation (local
                     * and remote control) is confirmed after replacement. */
            }
            return verdict : VerdictKind;
        }

    } // package Quality

    // =========================================================================
    // Environmental Test Cases — TC-E-001
    // Verify WEEE/RoHS disposal compliance (REQ-E-01, UC-05).
    // =========================================================================
    package Environmental {

        verification def TC_E_001_DisposalCompliance {
            doc /* Verify that the controller can be manually disassembled for material
                 * separation without specialist equipment, and that its materials comply
                 * with RoHS restricted-substance limits (REQ-E-01, UC-05,
                 * ACT-DisposeController). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Environmental::regulatedDisposal;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "inspection";
                priority           = "medium";
                category           = "Environmental";
            }
            action setup {
                doc /* Obtain a representative production sample (decommissioned unit).
                     * Collect: RoHS material compliance declarations from all component suppliers,
                     * WEEE recycling category classification, standard hand tools only
                     * (screwdriver, pliers). */
            }
            action execute {
                doc /* 1. Review RoHS declarations for all components against EU Directive
                     *    2011/65/EU restricted substance limits (Pb, Hg, Cd, Cr VI, PBB, PBDE).
                     * 2. Disassemble controller using only standard hand tools.
                     *    Record tools required and time.
                     * 3. Separate assembly into material streams: PCB, plastic enclosure,
                     *    metallic contacts/terminals, wiring. */
            }
            action verifyOutcome {
                doc /* PASS if: all components have valid RoHS compliance declarations;
                     * disassembly completes using only standard hand tools (no power tools,
                     * no specialist equipment);
                     * PCB, plastics, metals, and wiring are physically separable into
                     * distinct WEEE-recyclable material streams. */
            }
            return verdict : VerdictKind;
        }

    } // package Environmental

    // =========================================================================
    // Boundary Test Cases — TC-B-001 … TC-B-007
    // Verify limit conditions, minimum/maximum values, and dimensional constraints.
    // =========================================================================
    package Boundary {

        verification def TC_B_001_SupplyVoltage_LowerBoundary {
            doc /* Verify correct operation at the minimum specified control supply voltage
                 * of 10.0 V DC (12 V − 10 %), per L0_Constraints::Electrical::supplyVoltage. */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::controlRollerShutter;
                verify L0_Constraints::Electrical::supplyVoltage;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "high";
                category           = "Boundary";
            }
            action setup {
                doc /* Connect controller to a laboratory power supply. Set output to 10.0 V DC ± 0.05 V.
                     * Confirm voltage with calibrated DMM before proceeding. */
            }
            action execute {
                doc /* With supply at 10.0 V: issue UP command → confirm motor energizes;
                     * issue STOP → confirm motor de-energizes;
                     * issue DOWN command → confirm motor energizes;
                     * issue STOP → confirm motor de-energizes. */
            }
            action verifyOutcome {
                doc /* PASS if: all four commands produce correct motor responses at 10.0 V;
                     * no reset, lockup, or erratic behavior observed during the sequence. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_B_002_SupplyVoltage_UpperBoundary {
            doc /* Verify correct operation at the maximum specified supply voltage of
                 * 14.0 V DC (12 V + 10 %), per L0_Constraints::Electrical::supplyVoltage. */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::controlRollerShutter;
                verify L0_Constraints::Electrical::supplyVoltage;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "high";
                category           = "Boundary";
            }
            action setup {
                doc /* Set laboratory supply to 14.0 V DC ± 0.05 V. Confirm with calibrated DMM. */
            }
            action execute {
                doc /* With supply at 14.0 V: issue UP, STOP, DOWN, STOP commands and
                     * observe motor responses. Check for thermal shutdown or component warning signs. */
            }
            action verifyOutcome {
                doc /* PASS if: all commands produce correct motor responses at 14.0 V;
                     * no thermal shutdown, reset, over-voltage protection trip, or component
                     * damage observed. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_B_003_TimingProfile_MaxBoundary {
            doc /* Verify that a travel time of exactly 120 s (the maximum configurable value
                 * per REQ-F-07) is accepted, stored, and used correctly as the automatic-mode
                 * timeout without overflow or truncation. */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::configurableTimingProfile;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "high";
                category           = "Boundary";
            }
            action setup {
                doc /* Enter configuration mode. Reference stopwatch calibrated to ± 1 s
                     * accuracy over 120 s available. */
            }
            action execute {
                doc /* 1. Enter configuration mode.
                     * 2. Hold UP command for exactly 120 s (measured by reference stopwatch). Release.
                     * 3. System records T_open = 120 s.
                     * 4. Hold DOWN command for exactly 120 s. Release.
                     * 5. System records T_close = 120 s.
                     * 6. Exit configuration mode.
                     * 7. Issue automatic open command. Measure actual motor run time T_open_act.
                     * 8. Issue automatic close command. Measure T_close_act. */
            }
            action verifyOutcome {
                doc /* PASS if: 120-second times accepted and stored without error or rejection;
                     * T_open_act and T_close_act each within 120 s ± 3 s (2.5% tolerance);
                     * no overflow, premature stop, or lockup at the 120 s boundary. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_B_004_OperatingTemp_LowerBoundary {
            doc /* Verify correct operation at the minimum specified ambient temperature
                 * of 0 °C, per L0_Constraints::Environmental::operatingConditions. */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Quality::reliability;
                verify L0_Constraints::Environmental::operatingConditions;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "high";
                category           = "Boundary";
            }
            action setup {
                doc /* Place controller in temperature chamber. Set to 0 °C ± 1 °C.
                     * Allow 30-minute thermal soak. Connect rated switching load and 12 V DC supply. */
            }
            action execute {
                doc /* At 0 °C steady-state, exercise:
                     * (1) automatic open, (2) automatic close,
                     * (3) manual partial open (hold-to-run), (4) manual partial close,
                     * (5) stop command during movement,
                     * (6) conflict suppression (simultaneous UP+DOWN). */
            }
            action verifyOutcome {
                doc /* PASS if: all six functions respond correctly at 0 °C;
                     * no cold-start failure, component timing drift causing malfunction,
                     * or relay non-activation observed. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_B_005_OperatingTemp_UpperBoundary {
            doc /* Verify correct operation at the maximum specified ambient temperature
                 * of 40 °C under rated switching load,
                 * per L0_Constraints::Environmental::operatingConditions. */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Quality::reliability;
                verify L0_Constraints::Environmental::operatingConditions;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "high";
                category           = "Boundary";
            }
            action setup {
                doc /* Place controller in chamber at 40 °C ± 1 °C with rated switching load
                     * (8 A / 230 V AC resistive) energized. Allow 60-minute thermal soak under
                     * load to reach thermal equilibrium. */
            }
            action execute {
                doc /* At 40 °C steady-state, execute 50 consecutive automatic open/close cycles
                     * at rated load. Monitor for thermal shutdown, relay failure, or timing drift. */
            }
            action verifyOutcome {
                doc /* PASS if: 50 cycles completed correctly;
                     * timing drift ≤ ± 10% of configured value;
                     * no thermal protection activation or component failure. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_B_006_SwitchingLoad_Maximum {
            doc /* Verify that the controller correctly switches the rated maximum motor load
                 * of 8 A at 230 V AC without malfunction or damage
                 * (L0_Constraints::Electrical::switchingLoad). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Safety::safety;
                verify L0_Constraints::Electrical::switchingLoad;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "high";
                category           = "Boundary";
            }
            action setup {
                doc /* Connect controller to: 12 V DC control supply, 230 V AC source through
                     * 8 A resistive load (28.75 Ω at 230 V). Current clamp on motor output. */
            }
            action execute {
                doc /* Issue UP command. Confirm 8 A load switched. Allow full automatic travel time.
                     * Issue DOWN command. Confirm 8 A load switched.
                     * Repeat for 20 open/close cycles. Inspect relay contacts after completion. */
            }
            action verifyOutcome {
                doc /* PASS if: 8 A load switched correctly for all 20 cycles;
                     * no relay contact welding, excessive contact temperature rise (> 25 °C above
                     * ambient at relay case), or false stop events from contact bounce;
                     * motor circuit remains isolated from control circuit throughout. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_B_007_PhysicalDimensions {
            doc /* Verify that the fully assembled controller fits within the maximum allowable
                 * envelope of 40 × 40 × 20 mm
                 * (L0_Constraints::Physical::compactDimensions). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Constraints::Physical::compactDimensions;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "inspection";
                priority           = "medium";
                category           = "Boundary";
            }
            action setup {
                doc /* Obtain a representative production sample (PCB + enclosure + connectors, fully
                     * assembled). Calibrated digital calipers (± 0.05 mm resolution) available. */
            }
            action execute {
                doc /* Measure width, length, and height of the fully assembled controller
                     * including all protruding connectors and mounting features.
                     * Record each dimension to the nearest 0.1 mm. */
            }
            action verifyOutcome {
                doc /* PASS if: width ≤ 40 mm AND length ≤ 40 mm AND height ≤ 20 mm
                     * (all three conditions must hold simultaneously);
                     * measurement uncertainty acknowledged at < 0.5 mm. */
            }
            return verdict : VerdictKind;
        }

    } // package Boundary

    // =========================================================================
    // Negative Test Cases — TC-N-001 … TC-N-004
    // Verify invalid inputs, exception paths, and failure-mode handling.
    // =========================================================================
    package Negative {

        verification def TC_N_001_ManualMode_SafetyTimeout {
            doc /* Verify that in manual mode the motor stops automatically when the
                 * configured travel-time timeout expires even while the command is still
                 * held (failsafe, REQ-F-05, REQ-F-06, UC-01c/d,
                 * ACT-MonitorUserInterruption). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::manualPositioning;
                verify L0_Requirements::Functional::stopShutterMovement;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "high";
                category           = "Negative";
            }
            action setup {
                doc /* Configure a known travel-time timeout T_manual (e.g., 30 s via calibration).
                     * Position shutter so that continuous hold will reach end-of-travel well
                     * after T_manual. Activate manual (hold-to-run) mode. */
            }
            action execute {
                doc /* Continuously hold UP command without releasing.
                     * Measure elapsed time until motor de-energizes.
                     * Continue holding after motor stops to confirm motor does not re-start. */
            }
            action verifyOutcome {
                doc /* PASS if: motor de-energizes after T_manual ± 5% even though command is
                     * still held (failsafe timeout fires);
                     * motor does not re-energize while command remains asserted;
                     * StopRequest.reason == timeout. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_N_002_ConfigMode_ReentryRejected {
            doc /* Verify graceful handling when configuration mode is activated a second time
                 * while already active — no double-notification, lockup, or loss of state
                 * (REQ-F-08, UC-03, ACT-ActivateConfigurationMode). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::configurationMode;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "medium";
                category           = "Negative";
            }
            action setup {
                doc /* Activate configuration mode. Confirm activation notification is active
                     * and configuration mode is in progress. */
            }
            action execute {
                doc /* 1. Attempt to activate configuration mode a second time
                     *    (repeat the activation action while already in config mode).
                     * 2. Observe system response (notification, state, motor behavior).
                     * 3. Complete a normal configuration flow (open + close measurement).
                     * 4. Exit configuration mode normally.
                     * 5. Confirm deactivation notification and return to normal operation. */
            }
            action verifyOutcome {
                doc /* PASS if: second activation attempt does not produce a spurious double
                     * notification, system lockup, or reset;
                     * controller remains functional in configuration mode (or gracefully ignores
                     * the second activation);
                     * normal configuration and exit restores correct operation. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_N_003_Installation_WiringVerifyRetry {
            doc /* Verify the installation retry path: when the initial post-connection
                 * functional verification fails, the installer can correct wiring and
                 * re-verify successfully (REQ-Q-01, UC-02,
                 * ACT-InstallController → VerifyWorking retry branch). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Quality::easeOfInstallation;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "demonstration";
                priority           = "medium";
                category           = "Negative";
            }
            action setup {
                doc /* Prepare controller with deliberately incorrect wiring
                     * (e.g., UP and DOWN motor phases swapped). Installation instructions and
                     * retry guidance available. Start overall stopwatch. */
            }
            action execute {
                doc /* 1. Power on with incorrect wiring.
                     * 2. Perform functional verification (issue UP command).
                     * 3. Observe failure (motor runs in wrong direction).
                     * 4. Power off. Correct wiring per installation instructions.
                     * 5. Power on. Re-perform functional verification (UP, DOWN, STOP). */
            }
            action verifyOutcome {
                doc /* PASS if: initial failure is clearly detectable by installer via
                     * functional verification (wrong direction or no movement);
                     * retry sequence leads to correct operation after wiring correction;
                     * total elapsed time including retry ≤ 30 minutes. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_N_004_NoPosiitonFeedback_TimeBased {
            doc /* Verify that the controller operates entirely on time-based logic with no
                 * position sensor, confirming the architectural no-position-feedback constraint
                 * (REQ-F-07, L0_Constraints::Architectural::noPositionFeedback,
                 *  L0_Constraints::Architectural::timeBasedOperation). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Functional::configurableTimingProfile;
                verify L0_Constraints::Architectural::noPositionFeedback;
                verify L0_Constraints::Architectural::timeBasedOperation;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "inspection";
                priority           = "medium";
                category           = "Negative";
            }
            action setup {
                doc /* Install controller connected to motor load only — no position sensor
                     * wired. Inspect hardware interface and firmware configuration
                     * for absence of any encoder, limit-switch, or position-feedback input. */
            }
            action execute {
                doc /* 1. Hardware inspection: confirm no encoder, limit switch, or position
                     *    sensor input is present on the controller interface.
                     * 2. Run automatic open — observe shutter stops by timeout only.
                     * 3. Run automatic close — observe shutter stops by timeout only.
                     * 4. Mechanically block shutter mid-travel (simulate jam).
                     * 5. Issue movement command. Confirm controller times out and stops without
                     *    any feedback from the mechanical system. */
            }
            action verifyOutcome {
                doc /* PASS if: hardware inspection confirms no position-feedback interface present;
                     * automatic movements stop exclusively on timeout in all three scenarios;
                     * no error mode, lockup, or exception when motor is mechanically blocked
                     * (controller relies solely on configured timer). */
            }
            return verdict : VerdictKind;
        }

        verification def TC_N_005_WiringModeMismatch_Detected {
            doc /* Verify that a mismatch between the installer-selected wiringMode
                 * (momentary/latching) and the physically wired wall-switch hardware
                 * produces observably incorrect behavior that is detectable via
                 * functional verification, and that reconfiguring wiringMode resolves it
                 * (REQ-I-01, RISK-I-01, Scenarios::SCEN_23_LocalControl_WiringModeMismatch,
                 * white-box hook: Verification::Product::VerifyWiringModeConfiguration). */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Interface::wallSwitchWiringCompatibility;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "high";
                category           = "Negative";
            }
            action setup {
                doc /* Configure controller with ConfigurationManagerSoftware.wiringMode :=
                     * WiringMode::momentary via installer configuration procedure, but wire a
                     * latching (toggle) switch to the local UP/DOWN inputs (deliberate
                     * mismatch, mirrors TC_N_003's deliberate-defect setup pattern). Remote
                     * inputs unasserted. Controller powered and idle. */
            }
            action execute {
                doc /* 1. Toggle the (physically latching) UP switch to ON and observe motor
                     *    behavior against the configured momentary-mode expectation.
                     * 2. Toggle the UP switch to OFF and observe motor response.
                     * 3. Perform functional verification (issue UP, DOWN, STOP) and observe
                     *    whether motor behavior matches momentary-mode semantics.
                     * 4. Re-enter configuration mode; set wiringMode := WiringMode::latching.
                     * 5. Re-perform functional verification (UP, DOWN, STOP). */
            }
            action verifyOutcome {
                doc /* PASS if: the mismatch (step 1-3) is clearly detectable via functional
                     * verification (motor starts then stops unexpectedly, or runs past the
                     * intended release point) rather than silently accepted;
                     * reconfiguring wiringMode to latching (step 4) resolves the mismatch;
                     * post-reconfiguration functional verification (step 5) succeeds with no
                     * further hardware changes. */
            }
            return verdict : VerdictKind;
        }

        verification def TC_N_006_InstallationFailureTerminalFault {
            doc /* Verify the bounded-retry-exhausted installation failure path: when a
                 * SECOND consecutive functional-verification attempt still fails (root
                 * cause NOT resolvable by a wiring correction -- e.g. a genuinely faulty
                 * external power supply or motor), the controller surfaces an explicit,
                 * observable terminal fault report and does NOT attempt any further
                 * automatic retry, requiring external intervention before installation can
                 * proceed (REQ-Q-01, UC_02_InstallController's bounded-retry decision
                 * graph, UseCaseActivities::reportInstallationFault,
                 * Scenarios::SCEN_12_InstallController_RepeatedFault_TerminalReport,
                 * SystemStates::InstallationFault -- the model's only non-disposal
                 * TERMINAL failure state). Closes CRIT-6 (SMRR corrective pass): SCEN_12
                 * previously had zero associated test case. */
            subject sut : BaseArchitecture::ShutterController;
            objective {
                verify L0_Requirements::Quality::easeOfInstallation;
            }
            @TestCaseMeta {
                testType           = "systemTestCase";
                verificationMethod = "test";
                priority           = "medium";
                category           = "Negative";
            }
            action setup {
                doc /* Prepare controller with a non-wiring, non-correctable defect on the
                     * first attempt (e.g., a genuinely faulty external power supply or
                     * motor) -- distinct from TC_N_003's correctable wiring-swap defect.
                     * Installation instructions and retry guidance available. */
            }
            action execute {
                doc /* 1. Installer wiring attempt #1 (defect present). Perform functional
                     *    verification (issue UP command). Observe failure.
                     *    verifyWorking.success == false.
                     * 2. Installer's corrective attempt (retryConnectController) --
                     *    inspects/reseats wiring but the root cause is NOT a wiring
                     *    fault, so the correction cannot resolve it.
                     * 3. Re-perform functional verification (retryVerifyWorking).
                     *    Observe failure persists a second consecutive time.
                     *    retryVerifyWorking.success == false.
                     * 4. Observe controller's response: no further automatic retry is
                     *    attempted; an explicit terminal fault indication is surfaced
                     *    (UseCaseActivities::reportInstallationFault). */
            }
            action verifyOutcome {
                doc /* PASS if: after the second consecutive functional-verification
                     * failure, the controller surfaces an explicit, observable terminal
                     * fault report (SystemStates::InstallationFault entry action
                     * reportInstallationFault) rather than silently stopping or looping;
                     * no third automatic retry attempt occurs (bounded-retry graph
                     * terminates, per UC_02's afterRetryVerify decision);
                     * the reported terminal state persists (InstallationFault has no
                     * exit transition) until external intervention (e.g. repair/
                     * replacement of the faulty power supply or motor) resolves the
                     * root cause outside the controller's own scope. */
            }
            return verdict : VerdictKind;
        }

    } // package Negative


    // =========================================================================
    // Verification case usages — package-level instances for traceability
    // (mirrors the action-usage pattern in UseCaseActivities.sysml)
    // =========================================================================
    verification tc_F_001_systemControlIntegration         : Functional::TC_F_001_SystemControlIntegration;
    verification tc_F_002_localControl_momentarySwitch      : Functional::TC_F_002_LocalControl_MomentarySwitch;
    verification tc_F_003_localControl_latchingSwitch       : Functional::TC_F_003_LocalControl_LatchingSwitch;
    verification tc_F_004_remoteControl_UP                  : Functional::TC_F_004_RemoteControl_UP;
    verification tc_F_005_remoteControl_DOWN                : Functional::TC_F_005_RemoteControl_DOWN;
    verification tc_F_006_automaticFullOpen                 : Functional::TC_F_006_AutomaticFullOpen;
    verification tc_F_007_automaticFullClose                : Functional::TC_F_007_AutomaticFullClose;
    verification tc_F_008_manualPartialOpen                 : Functional::TC_F_008_ManualPartialOpen;
    verification tc_F_009_manualPartialClose                : Functional::TC_F_009_ManualPartialClose;
    verification tc_F_010_stopDuringOpening                 : Functional::TC_F_010_StopDuringOpening;
    verification tc_F_011_stopDuringClosing                 : Functional::TC_F_011_StopDuringClosing;
    verification tc_F_012_configurableTimingProfile_nominal : Functional::TC_F_012_ConfigurableTimingProfile_Nominal;
    verification tc_F_013_configurationMode_notification    : Functional::TC_F_013_ConfigurationMode_Notification;
    verification tc_S_001_conflictSuppression_localUPDOWN  : Safety::TC_S_001_ConflictSuppression_LocalUPDOWN;
    verification tc_S_002_conflictSuppression_localRemote  : Safety::TC_S_002_ConflictSuppression_LocalRemoteCross;
    verification tc_S_003_accessibleVoltage_SELV           : Safety::TC_S_003_AccessibleVoltage_SELV;
    verification tc_S_004_conflictNotification_userFeedback : Safety::TC_S_004_ConflictNotification_UserFeedback;
    verification tc_Q_001_installationTime                  : Quality::TC_Q_001_InstallationTime;
    verification tc_Q_002_operationalAvailability           : Quality::TC_Q_002_OperationalAvailability;
    verification tc_Q_003_reliabilityEndurance              : Quality::TC_Q_003_ReliabilityEndurance;
    verification tc_Q_004_fieldDiagnosis                    : Quality::TC_Q_004_FieldDiagnosis;
    verification tc_Q_005_fieldReplacement                  : Quality::TC_Q_005_FieldReplacement;
    verification tc_E_001_disposalCompliance                : Environmental::TC_E_001_DisposalCompliance;
    verification tc_B_001_supplyVoltage_lowerBoundary       : Boundary::TC_B_001_SupplyVoltage_LowerBoundary;
    verification tc_B_002_supplyVoltage_upperBoundary       : Boundary::TC_B_002_SupplyVoltage_UpperBoundary;
    verification tc_B_003_timingProfile_maxBoundary         : Boundary::TC_B_003_TimingProfile_MaxBoundary;
    verification tc_B_004_operatingTemp_lowerBoundary       : Boundary::TC_B_004_OperatingTemp_LowerBoundary;
    verification tc_B_005_operatingTemp_upperBoundary       : Boundary::TC_B_005_OperatingTemp_UpperBoundary;
    verification tc_B_006_switchingLoad_maximum             : Boundary::TC_B_006_SwitchingLoad_Maximum;
    verification tc_B_007_physicalDimensions                : Boundary::TC_B_007_PhysicalDimensions;
    verification tc_N_001_manualMode_safetyTimeout          : Negative::TC_N_001_ManualMode_SafetyTimeout;
    verification tc_N_002_configMode_reentryRejected        : Negative::TC_N_002_ConfigMode_ReentryRejected;
    verification tc_N_003_installation_wiringRetry          : Negative::TC_N_003_Installation_WiringVerifyRetry;
    verification tc_N_004_noPositionFeedback_timeBased      : Negative::TC_N_004_NoPosiitonFeedback_TimeBased;
    verification tc_N_005_wiringModeMismatch_detected       : Negative::TC_N_005_WiringModeMismatch_Detected;
    verification tc_N_006_installationFailureTerminalFault  : Negative::TC_N_006_InstallationFailureTerminalFault;

} // package SystemTestCases
