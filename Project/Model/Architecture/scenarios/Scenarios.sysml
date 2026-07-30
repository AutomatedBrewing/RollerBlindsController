/* Scenarios (SM-PRD-22): verify Logical/Product Architecture by tracing named participants
 * through one execution path of a Use Case Activity, detecting architectural gaps.
 * Traceability Rules (crossmapping/scenarios.md §4):
 *  1. Scenario doc cites exactly one UseCaseActivities path.
 *  2. Each step names its responsible participant and port.
 *  3. Every discovered gap is documented as a '// GAP:' comment.
 *  4. Every key UCA has >= 1 primary-path scenario.
 *  5. Every scenario is a candidate arc42 ARC-06 Runtime View entry.
 *  6. Every scenario declares precondition/postcondition in its doc.
 */
package Scenarios {
    private import LogicalArchitecture::*;
    private import ProductArchitecture::*;
    private import ProductComponents::*;
    private import ProductInterfaces::*;
    private import UseCaseActivities::*;
    private import DomainKnowledge::*;
    private import SystemContext::*;
    private import Stakeholders::*;

    // Reuses top-level Logical/Product composite usages; individual participants referenced by
    // qualified name in each scenario's action docs (e.g. 'sut.logical.logicalControlUnit').
    part sut {
        part logical : LogicalArchitecture::RollerShutterControllerLogicalComponents = LogicalArchitecture::rollerShutterControllerLogicalComponents;
        part product : ProductArchitecture::RollerShutterControllerProductComponents = ProductArchitecture::rollerShutterControllerProductComponents;
    }

    // =========================================================================
    // Category 1 -- Primary Operational Scenarios
    // =========================================================================

    // ---- SCEN_01: Automatic Open -- Normal Path ---------------------------
    action def SCEN_01_AutomaticOpen_NormalPath {
        doc
        /* UCA: OpenShutterAutomatically (UC_01a). Primary Operational Scenario; mission-critical.
         * Pre: controller powered, supervisor idle, shutter not fully open.
         * Trigger: User presses UP on wall switch (automatic-mode gesture).
         * Post: shutter fully open; motor de-energized; moving==false, direction==none. */

        action s1 {
            doc /* logicalLocalRequestInterface.ctrlIn observes the UP assertion from wallSwitch and emits ControlCommand(direction=up, mode=automatic) on commandOut. */
        }
        action s2 {
            doc /* logicalControlUnit.localCommandIn receives the ControlCommand (connection 4); no remote/conflicting signal present. */
        }
        action s3 {
            doc /* logicalControlUnit produces a validated MovementRequest(direction=up, mode=automatic) on requestOut (determineMovementRequest, passThrough branch). */
        }
        action s4 {
            doc /* logicalMotorDrive.requestIn energizes the motor UP via driveOut → shutterDrive → windowRollerShutter (startShutterMovement, activateMotor). */
        }
        action s5 {
            doc /* logicalControlUnit.timingIn ← logicalMovementSupervisor supplies the persisted openTime from memoryFunctions (loadTimingProfile). */
        }
        action s6 {
            doc /* logicalMovementSupervisor monitors elapsed time against openTime; monitorTimeout branch fires when timeout elapses (monitorStopCondition). */
        }
        action s7 {
            doc /* logicalMovementSupervisor.stopOut → logicalMotorDrive.stopIn de-energizes the motor (stopShutterMovement). */
        }

        succession s1 then s2 then s3 then s4 then s5 then s6 then s7;
    }

    // ---- SCEN_02: Automatic Close -- Normal Path ---------------------------
    action def SCEN_02_AutomaticClose_NormalPath {
        doc
        /* UCA: CloseShutterAutomatically (UC_01b). Primary Operational Scenario; mission-critical.
         * Pre: controller powered, supervisor idle, shutter not fully closed.
         * Trigger: HomeAutomationSystem asserts DOWN via remote channel.
         * Post: shutter fully closed; motor de-energized. */

        action s1 {
            doc /* logicalRemoteRequestInterface.ctrlIn observes DOWN from homeAutomationSystem and emits ControlCommand(direction=down, mode=automatic) (receiveControlRequest). */
        }
        action s2 {
            doc /* logicalControlUnit.remoteCommandIn receives the command (connection 5); no local signal present. */
        }
        action s3 {
            doc /* logicalControlUnit produces MovementRequest(direction=down, mode=automatic) via determineMovementRequest passThrough branch. */
        }
        action s4 {
            doc /* logicalMotorDrive energizes DOWN via driveOut → shutterDrive (startShutterMovement, activateMotor). */
        }
        action s5 {
            doc /* logicalMovementSupervisor monitors elapsed time against closeTime (monitorStopCondition, monitorTimeout branch). */
        }
        action s6 {
            doc /* logicalMovementSupervisor.stopOut → logicalMotorDrive.stopIn de-energizes the motor (stopShutterMovement). */
        }

        succession s1 then s2 then s3 then s4 then s5 then s6;
    }

    // ---- SCEN_03: Manual Open -- User Release Stop -------------------------
    action def SCEN_03_ManualOpen_UserReleaseStop {
        doc
        /* UCA: OpenShutterManually (UC_01c), MonitorUserInterruption, listenForRelease branch.
         * Primary Operational Scenario; mission-critical.
         * Pre: controller powered; UP command asserted and held (hold-to-run gesture).
         * Trigger: User releases UP before the manual safety timeout.
         * Post: shutter stopped at intermediate/fully-open position; motor de-energized; StopRequest.reason==userRequest. */

        action s1 {
            doc /* logicalLocalRequestInterface.ctrlIn observes UP held and emits ControlCommand(direction=up, mode=manual) (receiveControlRequest). */
        }
        action s2 {
            doc /* logicalMotorDrive energizes UP (startShutterMovement, activateMotor, mode=manual). */
        }
        action s3 {
            doc /* logicalMovementSupervisor.commandIn observes the in-progress command stream; listenForRelease/monitorTimeout fork-merge race begins (MonitorUserInterruption). */
        }
        action s4 {
            doc /* User releases UP before timeout; listenForRelease wins the fork-merge race; StopRequest.reason := userRequest. */
        }
        action s5 {
            doc /* logicalMovementSupervisor.stopOut → logicalMotorDrive.stopIn de-energizes the motor (stopShutterMovement). */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // =========================================================================
    // Category 2 -- Alternative Scenarios
    // =========================================================================

    // ---- SCEN_04: Manual Close -- User Release Stop ------------------------
    action def SCEN_04_ManualClose_UserReleaseStop {
        doc
        /* UCA: CloseShutterManually (UC_01d), MonitorUserInterruption, listenForRelease branch.
         * Alternative Scenario (directional mirror of SCEN_03).
         * Pre: controller powered; DOWN command held.
         * Trigger: User releases DOWN before the safety timeout.
         * Post: shutter stopped; motor de-energized. */

        action s1 {
            doc /* logicalLocalRequestInterface emits ControlCommand(direction=down, mode=manual). */
        }
        action s2 {
            doc /* logicalMotorDrive energizes DOWN (startShutterMovement, activateMotor). */
        }
        action s3 {
            doc /* logicalMovementSupervisor fork-merge race begins (listenForRelease vs. monitorTimeout). */
        }
        action s4 {
            doc /* User releases before timeout; StopRequest.reason := userRequest. */
        }
        action s5 {
            doc /* logicalMovementSupervisor.stopOut → logicalMotorDrive.stopIn de-energizes the motor. */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // ---- SCEN_05: Manual Hold -- Safety Timeout Stop -----------------------
    action def SCEN_05_ManualHold_SafetyTimeoutStop {
        doc
        /* UCA: OpenShutterManually / MonitorUserInterruption, monitorTimeout branch.
         * Failure/Recovery Scenario; mission-critical (failsafe bounding an unreleased/stuck manual command).
         * Pre: controller powered; UP command asserted and held past the configured manual safety timeout.
         * Trigger: manual safety timeout elapses while command still held.
         * Post: motor de-energized; shutter does not re-start while command remains asserted; StopRequest.reason==timeout. */

        action s1 {
            doc /* logicalLocalRequestInterface emits ControlCommand(direction=up, mode=manual), continuously reasserted. */
        }
        action s2 {
            doc /* logicalMotorDrive energizes UP (startShutterMovement). */
        }
        action s3 {
            doc /* logicalMovementSupervisor's monitorTimeout branch wins the fork-merge race (no release ever received); StopRequest.reason := timeout. */
        }
        action s4 {
            doc /* logicalMovementSupervisor.stopOut → logicalMotorDrive.stopIn de-energizes the motor as a failsafe, despite the command remaining asserted. */
        }
        action s5 {
            doc /* Motor remains de-energized while command is still held.
                 * Structural owner is
                 * ProductComponents::CommandArbitrationSoftware — it reports only a genuine, debounce-confirmed
                 * edge (ADR-SW-010), so the still-asserted input does not re-trigger ControlCommand. */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // ---- SCEN_06: Automatic Movement -- User Stop Override -----------------
    action def SCEN_06_AutomaticMovement_UserStopOverride {
        doc
        /* UCA: MonitorStopCondition, listenForStopCommand branch (user stop during automatic mode).
         * Alternative Scenario.
         * Pre: automatic-mode movement in progress.
         * Trigger: user asserts an explicit stop command before the automatic timeout.
         * Post: motor de-energized at intermediate position; StopRequest.reason==userRequest. */

        action s1 {
            doc /* Precondition state: logicalMotorDrive energized (direction up or down, mode=automatic). */
        }
        action s2 {
            doc /* logicalMovementSupervisor.commandIn observes the in-progress command stream; listenForStopCommand/monitorTimeout fork-merge race begins (MonitorStopCondition). */
        }
        action s3 {
            doc /* Explicit stop command is asserted and accepted by listenForStopCommand before monitorTimeout fires; StopRequest.reason := userRequest. */
        }
        action s4 {
            doc /* logicalMovementSupervisor.stopOut → logicalMotorDrive.stopIn de-energizes the motor ahead of the automatic timeout. */
        }

        succession s1 then s2 then s3 then s4;
    }

    // ---- SCEN_07: Conflicting Up/Down Command -- Suppressed ----------------
    action def SCEN_07_ConflictingUpDownCommand_Suppressed {
        doc
        /* UCA: HandleConflictingMovementCommands (UC_01e), suppressMovement branch.
         * Failure Scenario (safety-relevant); mission-critical (REQ-S-01).
         * Pre: controller powered; no movement in progress.
         * Trigger: simultaneous UP (local) + DOWN (remote) assertion, held < calibrationHoldThresholdS=5.0s;
         *   cross-channel source means ConfigModeEvent[activated] can never be emitted for this trigger.
         * State path: Idle → AssessingSimultaneousHold → ConflictSuppressed.
         * Post: motor remains de-energized; conflict silently suppressed (no buzzer — buzzer scope is config-mode only per REQ-F-08). */

        action s1 {
            doc /* logicalLocalRequestInterface emits ControlCommand(direction=up, source=local). */
        }
        action s2 {
            doc /* logicalRemoteRequestInterface emits ControlCommand(direction=down, source=remote) concurrently. */
        }
        action s3 {
            doc /* logicalControlUnit detects both channels asserted; determineMovementRequest suppressMovement branch fires (request.direction=none); state transitions Idle → AssessingSimultaneousHold. */
        }
        action s4 {
            doc /* startShutterMovement suppressMotor branch: motorState.enable=false, direction=none; logicalMotorDrive never energizes. */
        }
        action s5 {
            doc /* Cross-channel source means ConfigModeEvent[activated] can never arrive; AssessingSimultaneousHoldState 'accept after 5.0s' fires → ConflictSuppressed. */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }


    // ---- SCEN_08: Remote Command -- Home Automation Open -------------------
    action def SCEN_08_RemoteCommand_HomeAutomationOpen {
        doc
        /* UCA: OpenShutterAutomatically (UC_01a), remote channel variant.
         * Alternative Scenario; verifies remote channel parity with SCEN_01.
         * Pre: controller powered; supervisor idle.
         * Trigger: HomeAutomationSystem asserts UP via remote channel.
         * Post: shutter fully open; motor de-energized. */

        action s1 {
            doc /* logicalRemoteRequestInterface.ctrlIn observes UP from homeAutomationSystem and emits ControlCommand(direction=up, mode=automatic) (receiveControlRequest, acceptRemoteCmd). */
        }
        action s2 {
            doc /* logicalControlUnit.remoteCommandIn receives the command (connection 5). */
        }
        action s3 {
            doc /* logicalMotorDrive energizes UP (startShutterMovement). */
        }
        action s4 {
            doc /* logicalMovementSupervisor times out at openTime; logicalMotorDrive de-energized (monitorStopCondition → stopShutterMovement). */
        }

        succession s1 then s2 then s3 then s4;
    }

    // ---- SCEN_09: Local and Remote -- Equal-Priority Stop Arbitration -----
    action def SCEN_09_LocalAndRemoteSimultaneous_EqualPriorityArbitration {
        doc
        /* UCA: MonitorStopCondition / MonitorUserInterruption, channel-agnostic fork/merge (REQ-F-06).
         * Alternative/edge-case Scenario; mission-critical.
         * Pre: controller powered; supervisor idle.
         * Trigger: local UP starts shutter moving up; remote DOWN is asserted while in progress.
         * Post: shutter stops immediately on the remote DOWN (neither channel has priority over the other). */

        action s1 {
            doc /* logicalLocalRequestInterface emits ControlCommand(direction=up, source=local, mode=automatic) (receiveControlRequest, acceptLocalCmd). */
        }
        action s2 {
            doc /* logicalMotorDrive energizes UP; automatic-mode movement is now in progress. */
        }
        action s3 {
            doc /* logicalRemoteRequestInterface emits ControlCommand(direction=down, source=remote) while upward movement is in progress. */
        }
        action s4 {
            doc /* MonitorStopCondition's channel-agnostic listenForStopCommand accepts the remote DOWN identically to a local stop; StopRequest.reason := userRequest. */
        }
        action s5 {
            doc /* logicalMovementSupervisor.stopOut → logicalMotorDrive.stopIn de-energizes the motor at an intermediate position. */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // =========================================================================
    // Category 3 -- Installation Scenarios
    // =========================================================================

    // ---- SCEN_10: Install Controller -- Successful First Attempt ----------
    action def SCEN_10_InstallController_SuccessfulFirstAttempt {
        doc
        /* UCA: InstallController (UC_02), happy path (verifyWorking.success==true → assembleWallswitch).
         * Installation Scenario; mission-critical (REQ-Q-01 gate).
         * Pre: power isolated; controller, switch, remote interface, and motor wiring available on-site, uninstalled.
         * Trigger: Installer begins physical installation.
         * Post: controller connected and verified working; wall switch reassembled; power restored. */

        action s1 {
            doc /* Installer isolates the shutter circuit power supply (turnOffPowerSupplyForShutters). */
        }
        action s2 {
            doc /* Installer removes the existing wall switch to access wiring (disassembleWallswitch). */
        }
        action s3 {
            doc /* Installer wires all boundary ports (localCtrl, remoteCtrl, controlPower, mainsPower, shutterDrive) via screw-terminal connectors (connectController). */
        }
        action s4 {
            doc /* Installer restores power and issues a functional test command; verifyWorking.success==true on first attempt. */
        }
        action s5 {
            doc /* Installer reassembles the wall switch housing; postcondition state reached (assembleWallswitch). */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // ---- SCEN_11: Install Controller -- Wiring Fault, Retry Succeeds ------
    action def SCEN_11_InstallController_WiringFault_RetrySucceeds {
        doc
        /* UCA: InstallController, retry branch (verifyWorking.success==false → retryConnectController → success).
         * Installation/Recovery Scenario.
         * Pre: same as SCEN_10, with a deliberate wiring defect (e.g. motor phases swapped).
         * Trigger: initial functional verification fails.
         * Post: after correction and retry, controller verified working; wall switch reassembled. */

        action s1 {
            doc /* Installer wires motor phases swapped (deliberate defect, per TC_N_003 setup). */
        }
        action s2 {
            doc /* Functional test issued; motor runs in wrong direction; verifyWorking.success==false. */
        }
        action s3 {
            doc /* Installer powers off and corrects the wiring per installation instructions (retryConnectController). */
        }
        action s4 {
            doc /* Installer powers on and re-issues functional test; motor now runs correctly; retryVerifyWorking.success==true. */
        }
        action s5 {
            doc /* Installer reassembles the wall switch; postcondition state reached. */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // ---- SCEN_12: Install Controller -- Repeated Fault, Terminal Report ---
    action def SCEN_12_InstallController_RepeatedFault_TerminalReport {
        doc
        /* UCA: InstallController, terminal-fault branch (retryVerifyWorking.success==false → reportInstallationFault).
         * Installation/Failure Scenario.
         * Pre: same as SCEN_11, but defect is not a controller-side wiring issue (e.g. faulty external supply or motor).
         * Trigger: second consecutive functional-verification attempt still fails.
         * Post: terminal fault reported; external intervention required; no further automatic retry. */

        action s1 {
            doc /* Installer wiring attempt #1 with defect present (connectController). */
        }
        action s2 {
            doc /* verifyWorking.success==false. */
        }
        action s3 {
            doc /* Installer's corrective attempt does not resolve a non-wiring root cause (retryConnectController). */
        }
        action s4 {
            doc /* retryVerifyWorking.success==false a second time. */
        }
        action s5 {
            doc /* reportInstallationFault fires; the bounded-retry decision graph does not loop further; external intervention required. */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // =========================================================================
    // Category 4 -- Configuration / Primary Operational Scenarios
    // =========================================================================

    // ---- SCEN_13: Configure Controller -- Timing Calibration ---------------
    action def SCEN_13_ConfigureController_TimingCalibration {
        doc
        /* UCA: ConfigureController (UC_03), full happy path.
         * Primary Operational/Installation Scenario; mission-critical (REQ-F-07 configurableTimingProfile, ADR-003).
         * Pre: controller installed and powered; config mode inactive; shutter fully closed (UC_03 precondition).
         * Trigger: Installer activates config mode via local-only UP+DOWN hold >=5.0s (REQ-F-08), then holds UP through full open travel.
         * Post: single TravelTime value persisted (used for both directions); config mode deactivated; user notified via buzzer. */

        action s1 {
            doc /* logicalControlUnit checks whether config mode is already active; alreadyActive==false (checkConfigurationModeState). */
        }
        action s2 {
            doc /* Installer's local-only UP+DOWN hold confirmed (AssessingSimultaneousHold, >=5.0s, source==local); logicalControlUnit emits ConfigModeEvent(activated) → logicalUserNotification → buzzer (short beep, REQ-F-08). */
        }
        action s3 {
            doc /* Installer holds local UP; logicalMotorDrive runs OpenShutterManually while logicalMovementSupervisor.countActionTime measures elapsed duration (runOpenMovement + countOpenTime). */
        }
        action s4 {
            doc /* checkOpenTimeInRange evaluates REQ-F-07's maxConfigurableTravelTime<=120s; inRange==true; measured value persisted by memoryManagerSoftware as TravelTime for both directions (checkOpenTimeInRange + saveOpenTime). */
        }
        action s5 {
            doc /* logicalControlUnit emits ConfigModeEvent(deactivated) → buzzer (second short beep); configuration mode exits (exitConfigurationMode + notifyUserAboutDeactivation). */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // ---- SCEN_14: Configure Controller -- Reentry Rejected -----------------
    action def SCEN_14_ConfigureController_ReentryRejected {
        doc
        /* UCA: ConfigureController, reentryGuard decide, alreadyActive==true → rejectConfigurationModeReentry.
         * Alternative/Failure Scenario.
         * Pre: configuration mode already active (in-progress calibration session).
         * Trigger: Installer attempts to activate configuration mode a second time while already active.
         * Post: second activation rejected; no double notification; in-progress session continues and exits normally. */

        action s1 {
            doc /* Precondition state: logicalControlUnit's configuration session is in progress. */
        }
        action s2 {
            doc /* Installer repeats the simultaneous UP+DOWN hold gesture. */
        }
        action s3 {
            doc /* checkConfigurationModeState.alreadyActive==true. */
        }
        action s4 {
            doc /* rejectConfigurationModeReentry fires; new activation request dropped; in-progress session unaffected. */
        }
        action s5 {
            doc /* Original calibration session (SCEN_13's s3–s5) completes and exits normally. */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // =========================================================================
    // Category 5 -- Failure / Recovery Scenarios (Off-Nominal, Phase 6)
    // =========================================================================

    // ---- SCEN_15: Power Loss During Movement -------------------------------
    action def SCEN_15_PowerLoss_DuringMovement {
        doc
        /* UCA: NONE — traces to ADR_002_Availability and SystemObjectives::reliability.
         * Failure Scenario (off-nominal); mission-critical (safety-relevant: relay energized during power loss).
         * Pre: movement in progress (logicalMotorDrive energized).
         * Trigger: controlPower (12V DC) interrupted while movement is in progress.
         * Post: relay coil de-energizes passively (electrical property of hardware); motor stops without software action. */

        action s1 {
            doc /* Product::ControlMCU::motorDriveControlSoftware has relayOut energized; MotorDriveRelayModule.driveOut is live. */
        }
        action s2 {
            doc /* SystemContext::controlPowerSupply.supply interrupted; Product::PowerSupplyModule.controlPowerIn loses input; logicRailOut collapses. */
        }
        action s3 {
            doc /* MotorDriveRelayModule.coilPowerIn loses power; relay coil de-energizes purely electrically (no firmware action); motor stops as a passive consequence. */
        }

        succession s1 then s2 then s3;

        // GAP: no Logical or Product component observes, logs, or reacts to a controlPower interruption;
        // passive relay de-energization is an electrical property, not a modeled behavior.
        // No position persistence, no power-loss detection, and no distinction between "stopped by timeout"
        // vs. "stopped by power loss" — consistent with ADR-002's explicit scope decision (no watchdog/failover),
        // compounded by the no-position-feedback design (ADR-003, RISK-T-01).
    }

    // ---- SCEN_16: Power Recovery After Outage -------------------------------
    action def SCEN_16_PowerRecovery_AfterOutage {
        doc
        /* UCA: NONE — pairs with SCEN_15; traces to ADR_002_Availability.
         * Recovery Scenario; mission-critical.
         * Pre: controlPower was interrupted (SCEN_15) and is now restored; config mode was not active.
         * Trigger: controlPower (12V DC) restored.
         * Post: ControlMCU reboots; MemoryManagerSoftware reloads persisted TravelTime from EEPROM; controller ready for commands. */

        action s1 {
            doc /* SystemContext::controlPowerSupply.supply resumes; Product::PowerSupplyModule.controlPowerIn regains input; logicRailOut restored. */
        }
        action s2 {
            doc /* ControlMCU's firmware components re-initialize on power restoration (implicit MCU boot behavior). */
        }
        action s3 {
            doc /* Product::ControlMCU::memoryManagerSoftware retrieves persisted TravelTime and wiringMode from internal EEPROM (loadTimingProfile). */
        }
        action s4 {
            doc /* logicalControlUnit / commandArbitrationSoftware resume accepting new local/remote ControlCommand input. */
        }

        succession s1 then s2 then s3 then s4;

        // GAP: no modeled function re-establishes the shutter's physical position after power-loss/recovery
        // (ADR-003's no-position-feedback decision means no sensor exists to query); firmware boot/re-init
        // is inferred generic MCU behavior, not a traceable model element. Consistent with ADR-002's
        // explicit decision (no self-healing, failover, or watchdog architecture).
    }

    // ---- SCEN_17: Mechanical Jam -- Time-Based Stop Without Feedback -------
    action def SCEN_17_MechanicalJam_TimeBasedStopWithoutFeedback {
        doc
        /* UCA: MonitorStopCondition, monitorTimeout branch (the only stop mechanism — no jam detection by design, ADR-003).
         * Failure Scenario; mission-critical (RISK-T-01, ADR_003_TimeBased accepted residual risk).
         * Pre: automatic-mode movement in progress; shutter mechanically jams mid-travel.
         * Trigger: shutter physically stops but controller cannot detect it (no position feedback).
         * Post: motor remains energized (stalled) until timeout, then de-energizes — indistinguishable from normal completion. */

        action s1 {
            doc /* logicalMotorDrive energizes the motor (startShutterMovement, mode=automatic). */
        }
        action s2 {
            doc /* windowRollerShutter physically stops (obstruction) mid-travel; no Logical or Product component observes this — shutterStateOut reports the commanded state, not the physical state (ADR-003). */
        }
        action s3 {
            doc /* Relay/motor remains electrically energized (stalled) for the remainder of the configured timeout, drawing stall current with no controller awareness. */
        }
        action s4 {
            doc /* logicalMovementSupervisor's monitorTimeout fires at the configured timeout; StopRequest.reason:=timeout — structurally identical to a normal end-of-travel stop. */
        }
        action s5 {
            doc /* logicalMovementSupervisor.stopOut → logicalMotorDrive.stopIn de-energizes the motor; shutterState reports moving=false — indistinguishable from successful full-travel completion. */
        }

        succession s1 then s2 then s3 then s4 then s5;

        // GAP: ADR_003_TimeBased explicitly accepts RISK-T-01 (positioning drift) as a residual risk.
        // No fault classification, indication, or recovery mechanism distinguishes a mid-travel jam from
        // normal completion; the only recovery path is user-initiated re-calibration (UC_03).
    }

    // =========================================================================
    // Category 6 -- Disposal Scenario
    // =========================================================================

    // Note: SCEN_18, SCEN_19, SCEN_20 are not assigned in this model; numbering continues at SCEN_21.

    // ---- SCEN_21: Dispose Controller -- End of Life -------------------------
    action def SCEN_21_DisposeController_EndOfLife {
        doc
        /* UCA: DisposeController (UC_05). Disposal Scenario; not mission-critical.
         * Pre: controller decommissioned and removed from installation.
         * Trigger: controller retired at end of life.
         * Post: materials collected, disassembled, and recycled per WEEE/RoHS (REQ-E-01 regulatedDisposal). */

        action s1 {
            doc /* Stakeholders::DisposalFacility collects the decommissioned controller unit. */
        }
        action s2 {
            doc /* DisposalFacility disassembles ProductArchitecture::RollerShutterControllerProductComponents via screw-terminal EnclosureAndConnectors (no soldering required). */
        }
        action s3 {
            doc /* DisposalFacility disposes of/recycles constituent materials per WEEE/RoHS regulation (DisposeController). */
        }

        succession s1 then s2 then s3;

        // GAP: UseCaseActivities::DisposeController is an intentionally underspecified stub (single doc-only action,
        // no sub-steps); this scenario's s1–s3 are inferred from UC_05 metadata and REQ-E-01, not from
        // structural UCA sub-actions.
    }

    // =========================================================================
    // Category 7 -- Configuration/Integrity/Environmental Off-Nominal Scenarios
    // =========================================================================

    // ---- SCEN_22: Configure Controller -- Invalid Calibration Rejected ----
    action def SCEN_22_ConfigureController_InvalidCalibrationRejected {
        doc
        /* UCA: ConfigureController, checkOpenTimeInRange, inRange==false → rejectOutOfRangeCalibration.
         * Configuration/Validation Scenario (off-nominal).
         * Pre: controller installed and powered; config mode inactive; shutter fully closed; REQ-F-07 maxConfigurableTravelTime<=120s in force.
         * Trigger: Installer holds UP for >120s during calibration, producing an out-of-range measurement.
         * Post: out-of-range measurement not persisted; installer prompted to retry; previous TravelTime unchanged. */

        action s1 {
            doc /* Installer performs local-only UP+DOWN hold (>=5.0s); checkConfigurationModeState.alreadyActive==false; config mode activates (mirrors SCEN_13 s1–s2). */
        }
        action s2 {
            doc /* Installer holds UP for >120s; logicalMovementSupervisor.countActionTime measures the elapsed duration (runOpenMovement + countOpenTime). */
        }
        action s3 {
            doc /* checkOpenTimeInRange evaluates REQ-F-07 maxConfigurableTravelTime<=120s; inRange==false. */
        }
        action s4 {
            doc /* rejectOutOfRangeCalibration fires; out-of-range measurement not carried into saveOpenTime; installer notified via userFeedbackSoftware to retry. */
        }
        action s5 {
            doc /* Configuration mode exits (exitConfigurationMode) without an out-of-range measurement reaching memoryManagerSoftware; previous TravelTime remains authoritative. */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // ---- SCEN_23: Local Control -- Wiring Mode Mismatch -------------------
    action def SCEN_23_LocalControl_WiringModeMismatch {
        doc
        /* UCA: ReceiveControlRequest (acceptLocalCmd), reusing UC_02 VerifyWorking retry pattern to surface the mismatch.
         * Local Control/Installation-Adjacent Failure Scenario; mission-critical (RISK-I-01: mismatch failure mode previously had zero scenario coverage).
         * Pre: controller installed; wiringMode=WiringMode::momentary configured but physical wall switch is latching.
         * Trigger: User operates the physically-latching switch; commandArbitrationSoftware misinterprets under momentary-mode assumption.
         * Post: mismatch produces incorrect motor behavior; Installer corrects wiringMode to WiringMode::latching and re-verifies successfully.
         * GAP: no UseCaseActivities action models wiring-mode mismatch detection specifically; closest anchor is handleConflictingMovementCommands (both cases involve a raw signal failing to produce the intended ControlCommand). */

        action s1 {
            doc /* Installer sets configurationManagerSoftware.wiringMode:=WiringMode::momentary (persisted by memoryManagerSoftware), but the physical wall switch is latching. */
        }
        action s2 {
            doc /* User operates the latching switch; LogicalLocalRequestInterface forwards the raw dry-contact level to commandArbitrationSoftware, which misinterprets it under momentary-mode assumption (receiveControlRequest, acceptLocalCmd). */
        }
        action s3 {
            doc /* commandArbitrationSoftware's momentary-mode interpretation of a latching signal produces an incorrect ControlCommand pattern — motor starts/stops unexpectedly.
                 * // GAP: no UseCaseActivities action models wiring-mode mismatch detection specifically (closest anchor: handleConflictingMovementCommands). */
        }
        action s4 {
            doc /* Functional test command issued; resulting motor behavior does not match expected momentary-mode semantics; mismatch is observable rather than silent (RISK-I-01 mitigation). */
        }
        action s5 {
            doc /* Installer re-enters configuration mode, selects WiringMode::latching, and re-verifies successfully (mirrors UC_02 retryConnectController/retryVerifyWorking pattern). */
        }

        succession s1 then s2 then s3 then s4 then s5;

        // GAP: UseCaseActivities.sysml has no action modeling wiring-mode mismatch detection as a distinct
        // mechanism; the closest UCA anchor is handleConflictingMovementCommands (closest-concrete choice,
        // not a precise realization). TC_N_005 and the existing SystemTestCases::Product::VerifyWiringModeConfiguration
        // provide verification readiness without requiring a UCA-level fix.
    }

    // Note: SCEN_24 is not assigned in this model; numbering continues at SCEN_25.

    // ---- SCEN_25: Automatic Open -- Low-Temperature Boundary ---------------
    action def SCEN_25_AutomaticOpen_LowTemperatureBoundary {
        doc
        /* UCA: OpenShutterAutomatically (UC_01a), same path as SCEN_01, at the L0_Constraints::Environmental::operatingConditions minimum boundary (0°C).
         * Environmental Boundary/Primary Operational Scenario variant.
         * Pre: controller at 0°C steady-state (30-min thermal soak per TC_B_004 setup); shutter not fully open; supervisor idle.
         * Trigger: User asserts UP on wall switch (same as SCEN_01 s1) at the cold-temperature boundary.
         * Post: shutter fully open; motor de-energized; no cold-start failure or timing drift observed. */

        action s1 {
            doc /* Precondition state: controller at 0°C steady-state (30-min thermal soak, per TC_B_004 setup); 12V DC control power and rated switching load connected. */
        }
        action s2 {
            doc /* logicalLocalRequestInterface.ctrlIn observes the UP assertion from wallSwitch and emits ControlCommand(direction=up, mode=automatic) (receiveControlRequest, acceptLocalCmd) — identical to SCEN_01 s1. */
        }
        action s3 {
            doc /* logicalMotorDrive / motorDriveControlSoftware energizes UP via Product::MotorDriveRelayModule — relay engages correctly despite cold-temperature contact resistance change (startShutterMovement, activateMotor). */
        }
        action s4 {
            doc /* logicalMovementSupervisor times out at openTime with no temperature-induced timing drift causing malfunction; logicalMotorDrive de-energized (monitorStopCondition → stopShutterMovement). */
        }

        succession s1 then s2 then s3 then s4;
    }

    // Package-level action usages as traceability anchors (SysML v2 connection ends must reference usages, not defs).
    action scen01_AutomaticOpen_NormalPath                              : SCEN_01_AutomaticOpen_NormalPath;
    action scen02_AutomaticClose_NormalPath                             : SCEN_02_AutomaticClose_NormalPath;
    action scen03_ManualOpen_UserReleaseStop                            : SCEN_03_ManualOpen_UserReleaseStop;
    action scen04_ManualClose_UserReleaseStop                           : SCEN_04_ManualClose_UserReleaseStop;
    action scen05_ManualHold_SafetyTimeoutStop                          : SCEN_05_ManualHold_SafetyTimeoutStop;
    action scen06_AutomaticMovement_UserStopOverride                    : SCEN_06_AutomaticMovement_UserStopOverride;
    action scen07_ConflictingUpDownCommand_Suppressed                   : SCEN_07_ConflictingUpDownCommand_Suppressed;
    action scen08_RemoteCommand_HomeAutomationOpen                      : SCEN_08_RemoteCommand_HomeAutomationOpen;
    action scen09_LocalAndRemoteSimultaneous_EqualPriorityArbitration    : SCEN_09_LocalAndRemoteSimultaneous_EqualPriorityArbitration;
    action scen10_InstallController_SuccessfulFirstAttempt              : SCEN_10_InstallController_SuccessfulFirstAttempt;
    action scen11_InstallController_WiringFault_RetrySucceeds           : SCEN_11_InstallController_WiringFault_RetrySucceeds;
    action scen12_InstallController_RepeatedFault_TerminalReport        : SCEN_12_InstallController_RepeatedFault_TerminalReport;
    action scen13_ConfigureController_TimingCalibration                 : SCEN_13_ConfigureController_TimingCalibration;
    action scen14_ConfigureController_ReentryRejected                   : SCEN_14_ConfigureController_ReentryRejected;
    action scen15_PowerLoss_DuringMovement                              : SCEN_15_PowerLoss_DuringMovement;
    action scen16_PowerRecovery_AfterOutage                             : SCEN_16_PowerRecovery_AfterOutage;
    action scen17_MechanicalJam_TimeBasedStopWithoutFeedback            : SCEN_17_MechanicalJam_TimeBasedStopWithoutFeedback;
    action scen21_DisposeController_EndOfLife                          : SCEN_21_DisposeController_EndOfLife;
    action scen22_ConfigureController_InvalidCalibrationRejected       : SCEN_22_ConfigureController_InvalidCalibrationRejected;
    action scen23_LocalControl_WiringModeMismatch                      : SCEN_23_LocalControl_WiringModeMismatch;
    action scen25_AutomaticOpen_LowTemperatureBoundary                 : SCEN_25_AutomaticOpen_LowTemperatureBoundary;
} // package Scenarios
