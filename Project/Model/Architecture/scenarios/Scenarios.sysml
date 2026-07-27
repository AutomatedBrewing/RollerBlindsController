/* Scenarios (SM-PRD-22) -- Operational Scenario Verification of the
 * Logical (SM-PRD-20) and Product (SM-PRD-21) Architectures.
 *
 * A Scenario performs a "virtual tour" through the architecture: named
 * participant instances (reused from LogicalArchitecture::
 * RollerShutterControllerLogicalComponents and ProductArchitecture::
 * RollerShutterControllerProductComponents) are traced step by step
 * through exactly one execution path of one Use Case Activity
 * (UseCaseActivities, SM-PRD-14), verifying that every required part,
 * port, and connection already exists. Scenarios are the primary
 * mechanism for detecting architectural gaps (KnowledgeSource/integration/
 * crossmapping/scenarios.md).
 *
 * No self-name collision risk: SystemArchitecture_Taxonomy declares no
 * "Scenarios" header, so every dependency below is wildcard-imported
 * directly (no abstract-root workaround needed, unlike BaseArchitecture/
 * FunctionalArchitecture/LogicalArchitecture/ProductArchitecture).
 *
 * Traceability Rules applied throughout (crossmapping/scenarios.md §4):
 *  1. Every scenario's doc cites exactly one UseCaseActivities path.
 *  2. Every action step names its responsible participant and port.
 *  3. Every discovered gap is documented as a '// GAP:' comment, not
 *     silently invented into an earlier architecture layer.
 *  4. Every key UCA has >= 1 primary-path scenario.
 *  5. Every scenario is a candidate arc42 ARC-06 Runtime View entry.
 *  6. Every scenario declares precondition/postcondition state in its doc.
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

    // =========================================================================
    // Scenario participant context.
    // Reuses the existing top-level Logical/Product composite usages rather
    // than re-declaring new part defs (modeling procedure step 2). Individual
    // Logical/Product component participants are referenced by qualified
    // name in each scenario's action docs (e.g.
    // 'sut.logical.logicalControlUnit'), matching the level of granularity
    // already established by Traceability::Traceability's connection style.
    // =========================================================================
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
        /* UCA path: UseCaseActivities::OpenShutterAutomatically (UC_01a).
         * Category: Primary Operational Scenario. Mission-critical: YES
         * (core movement capability, SystemObjectives::shutterMovementControl).
         * Precondition: shutterController powered (controlPower + mainsPower
         * present); logicalMovementSupervisor idle (no in-progress movement);
         * shutter not already fully open.
         * Trigger: User asserts UP on the wall switch (momentary press,
         * automatic-mode gesture).
         * Postcondition: shutter fully open; logicalMotorDrive de-energized;
         * shutterState.moving == false, direction == none. */

        action s1 {
            doc /* Step: acquireLocalUp -- logicalLocalRequestInterface.ctrlIn observes the UP dry-contact
                 * assertion from SystemContext::wallSwitch; emits ControlCommand
                 * (direction=up, mode=automatic) on commandOut.
                 * Participant: LogicalArchitecture::LogicalLocalRequestInterface.
                 * Realizes UseCaseActivities::receiveControlRequest (acceptLocalCmd). */
        }
        action s2 {
            doc /* Step: arbitrateCommand -- logicalControlUnit.localCommandIn receives the ControlCommand
                 * (LogicalArchitecture connection 4); no remote/conflicting signal
                 * present, so first-wins arbitration passes the command through.
                 * Participant: LogicalArchitecture::LogicalControlUnit. */
        }
        action s3 {
            doc /* Step: validateAndRequestMovement -- logicalControlUnit produces a validated MovementRequest
                 * (direction=up, mode=automatic) on requestOut, realizing
                 * UseCaseActivities::determineMovementRequest (passThrough branch).
                 * At Product layer: Product::ControlMCU::movementControlSoftware
                 * (Scenario Repair Plan C4a) is the firmware module that turns
                 * the arbitrated ControlCommand into this validated
                 * MovementRequest. */
        }
        action s4 {
            doc /* Step: startMotor -- logicalMotorDrive.requestIn (LogicalArchitecture connection 7)
                 * energizes the motor UP via driveOut → shutterDrive boundary port
                 * → SystemContext::windowRollerShutter. Realizes
                 * UseCaseActivities::startShutterMovement (activateMotor branch).
                 * Participant: LogicalArchitecture::LogicalMotorDrive. */
        }
        action s5 {
            doc /* Step: loadTimingProfile -- logicalControlUnit.timingIn ← logicalMovementSupervisor (via
                 * LogicalArchitecture connection 11) supplies the persisted
                 * openTime from memoryFunctions. Realizes
                 * UseCaseActivities::loadTimingProfile. */
        }
        action s6 {
            doc /* Step: superviseAutomaticTimeout -- logicalMovementSupervisor.requestIn/timingIn (LogicalArchitecture
                 * connections 6, 11) monitors elapsed time against openTime;
                 * realizes UseCaseActivities::monitorStopCondition
                 * (monitorTimeout branch -- automatic mode, no user stop asserted).
                 * Participant: LogicalArchitecture::LogicalMovementSupervisor. */
        }
        action s7 {
            doc /* Step: stopMotor -- logicalMovementSupervisor.stopOut → logicalMotorDrive.stopIn
                 * (LogicalArchitecture connection 8) de-energizes the motor.
                 * Realizes UseCaseActivities::stopShutterMovement. */
        }

        succession s1 then s2 then s3 then s4 then s5 then s6 then s7;
    }

    // ---- SCEN_02: Automatic Close -- Normal Path ---------------------------
    action def SCEN_02_AutomaticClose_NormalPath {
        doc
        /* UCA path: UseCaseActivities::CloseShutterAutomatically (UC_01b).
         * Category: Primary Operational Scenario. Mission-critical: YES.
         * Precondition: shutterController powered; shutter not already fully
         * closed; supervisor idle.
         * Trigger: HomeAutomationSystem asserts DOWN via remote channel.
         * Postcondition: shutter fully closed; motor de-energized. */

        action s1 {
            doc /* Step: acquireRemoteDown -- logicalRemoteRequestInterface.ctrlIn observes the DOWN
                 * dry-contact assertion from SystemContext::homeAutomationSystem;
                 * emits ControlCommand (direction=down, mode=automatic) on
                 * commandOut. Participant: LogicalRemoteRequestInterface.
                 * Realizes receiveControlRequest (acceptRemoteCmd). */
        }
        action s2 {
            doc /* Step: arbitrateCommand -- logicalControlUnit.remoteCommandIn receives the command
                 * (LogicalArchitecture connection 5); no local signal present. */
        }
        action s3 {
            doc /* Step: validateAndRequestMovement -- determineMovementRequest passThrough branch: MovementRequest
                 * (direction=down, mode=automatic) produced. At Product layer:
                 * Product::ControlMCU::movementControlSoftware (Scenario
                 * Repair Plan C4a) is the firmware module responsible. */
        }
        action s4 {
            doc /* Step: startMotor -- logicalMotorDrive energizes DOWN via driveOut → shutterDrive.
                 * Realizes startShutterMovement (activateMotor). */
        }
        action s5 {
            doc /* Step: superviseAutomaticTimeout -- logicalMovementSupervisor monitors elapsed time against the
                 * persisted closeTime (monitorStopCondition, monitorTimeout branch). */
        }
        action s6 {
            doc /* Step: stopMotor -- stopOut → logicalMotorDrive.stopIn de-energizes the motor
                 * (stopShutterMovement). */
        }

        succession s1 then s2 then s3 then s4 then s5 then s6;
    }

    // ---- SCEN_03: Manual Open -- User Release Stop -------------------------
    action def SCEN_03_ManualOpen_UserReleaseStop {
        doc
        /* UCA path: UseCaseActivities::OpenShutterManually (UC_01c),
         * waitForStopCondition = MonitorUserInterruption, listenForRelease branch.
         * Category: Primary Operational Scenario. Mission-critical: YES.
         * Precondition: shutterController powered; UP command asserted and
         * held (hold-to-run gesture).
         * Trigger: User releases the UP command before the safety timeout.
         * Postcondition: shutter stopped at an intermediate/fully-open
         * position; motor de-energized; StopRequest.reason == userRequest. */

        action s1 {
            doc /* Step: acquireLocalUpHeld -- logicalLocalRequestInterface.ctrlIn observes the UP assertion
                 * held continuously; emits ControlCommand (direction=up,
                 * mode=manual). Realizes receiveControlRequest. */
        }
        action s2 {
            doc /* Step: startMotor -- logicalMotorDrive energizes UP (startShutterMovement,
                 * activateMotor branch), mode=manual. */
        }
        action s3 {
            doc /* Step: monitorUserInterruption -- logicalMovementSupervisor.commandIn (LogicalArchitecture
                 * connection 5b, fed from logicalControlUnit.commandRelayOut)
                 * observes the in-progress command stream, realizing
                 * MonitorUserInterruption's listenForRelease/monitorTimeout
                 * fork-merge (first-wins). */
        }
        action s4 {
            doc /* Step: releaseDetected -- User releases the UP command before the manual safety
                 * timeout elapses; listenForRelease wins the fork-merge race;
                 * StopRequest.reason := userRequest. */
        }
        action s5 {
            doc /* Step: stopMotor -- logicalMovementSupervisor.stopOut → logicalMotorDrive.stopIn
                 * de-energizes the motor (stopShutterMovement). */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // =========================================================================
    // Category 2 -- Alternative Scenarios
    // =========================================================================

    // ---- SCEN_04: Manual Close -- User Release Stop ------------------------
    action def SCEN_04_ManualClose_UserReleaseStop {
        doc
        /* UCA path: UseCaseActivities::CloseShutterManually (UC_01d),
         * waitForStopCondition = MonitorUserInterruption, listenForRelease branch.
         * Category: Alternative Scenario (directional mirror of SCEN_03).
         * Mission-critical: NO (redundant coverage of the same mechanism).
         * Precondition: shutterController powered; DOWN command held.
         * Trigger: User releases DOWN before the safety timeout.
         * Postcondition: shutter stopped at an intermediate/fully-closed
         * position; motor de-energized. */

        action s1 {
            doc /* Step: acquireLocalDownHeld -- logicalLocalRequestInterface emits ControlCommand
                 * (direction=down, mode=manual). */
        }
        action s2 {
            doc /* Step: startMotor -- logicalMotorDrive energizes DOWN (activateMotor). */
        }
        action s3 {
            doc /* Step: monitorUserInterruption -- logicalMovementSupervisor fork-merge race (listenForRelease
                 * vs. monitorTimeout). */
        }
        action s4 {
            doc /* Step: releaseDetected -- User releases before timeout; StopRequest.reason := userRequest. */
        }
        action s5 {
            doc /* Step: stopMotor -- Motor de-energized via stopOut → stopIn. */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // ---- SCEN_05: Manual Hold -- Safety Timeout Stop -----------------------
    action def SCEN_05_ManualHold_SafetyTimeoutStop {
        doc
        /* UCA path: UseCaseActivities::OpenShutterManually /
         * MonitorUserInterruption, monitorTimeout branch.
         * Direct precedent: Verification::SystemTestCases::TC_N_001_
         * ManualMode_SafetyTimeout.
         * Category: Failure / Recovery Scenario. Mission-critical: YES
         * (the failsafe that bounds an unreleased/stuck manual command).
         * Precondition: shutterController powered; UP command asserted and
         * held continuously past the configured manual safety timeout
         * (e.g. stuck switch, or user simply forgets to release).
         * Trigger: manual safety timeout elapses while command still held.
         * Postcondition: motor de-energized; shutter does NOT re-start while
         * the command remains asserted; StopRequest.reason == timeout. */

        action s1 {
            doc /* Step: acquireLocalUpHeldContinuously -- logicalLocalRequestInterface emits ControlCommand
                 * (direction=up, mode=manual), continuously reasserted. */
        }
        action s2 {
            doc /* Step: startMotor -- logicalMotorDrive energizes UP. */
        }
        action s3 {
            doc /* Step: monitorUserInterruption -- logicalMovementSupervisor's fork-merge race: no release
                 * signal is ever accepted (command remains held), so
                 * monitorTimeout wins after the configured manual timeout
                 * elapses. StopRequest.reason := timeout. */
        }
        action s4 {
            doc /* Step: stopMotor -- stopOut → stopIn de-energizes the motor as a failsafe,
                 * despite the command remaining asserted. */
        }
        action s5 {
            doc /* Step: suppressReStart -- Motor remains de-energized while the command is still
                 * held. GAP: neither UseCaseActivities::MonitorUserInterruption
                 * nor LogicalMovementSupervisor's doc explicitly states a
                 * "latched-stopped-until-release" guard preventing an
                 * immediate re-trigger; TC_N_001's own verifyOutcome asserts
                 * this behavior ("motor does not re-start while command
                 * remains asserted") without an identified structural owner.
                 * Recorded as a minor architecture gap (Phase 5/8), not
                 * silently fixed here per Traceability Rule 3. */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // ---- SCEN_06: Automatic Movement -- User Stop Override -----------------
    action def SCEN_06_AutomaticMovement_UserStopOverride {
        doc
        /* UCA path: UseCaseActivities::MonitorStopCondition,
         * listenForStopCommand branch (user-initiated stop during automatic
         * mode, before timeout).
         * Category: Alternative Scenario. Mission-critical: NO.
         * Precondition: automatic-mode movement in progress (e.g. following
         * SCEN_01's s1-s4).
         * Trigger: user asserts an explicit stop command (e.g. a second
         * brief UP press) before the automatic timeout elapses.
         * Postcondition: motor de-energized at an intermediate position;
         * StopRequest.reason == userRequest. */

        action s1 {
            doc /* Step: automaticMovementInProgress -- Precondition state: logicalMotorDrive energized (direction
                 * up or down, mode=automatic), following SCEN_01/SCEN_02's
                 * startMotor step. */
        }
        action s2 {
            doc /* Step: monitorStopCondition -- logicalMovementSupervisor.commandIn (LogicalArchitecture
                 * connection 5b) observes the in-progress command stream;
                 * realizes MonitorStopCondition's listenForStopCommand /
                 * monitorTimeout fork-merge. */
        }
        action s3 {
            doc /* Step: userStopCommandDetected -- An explicit stop command is asserted and accepted by
                 * listenForStopCommand before monitorTimeout fires;
                 * StopRequest.reason := userRequest. */
        }
        action s4 {
            doc /* Step: stopMotor -- stopOut → stopIn de-energizes the motor ahead of the
                 * automatic timeout. */
        }

        succession s1 then s2 then s3 then s4;
    }

    // ---- SCEN_07: Conflicting Up/Down Command -- Suppressed ----------------
    action def SCEN_07_ConflictingUpDownCommand_Suppressed {
        doc
        /* UCA path: UseCaseActivities::HandleConflictingMovementCommands
         * (UC_01e) -- receiveControlRequest → determineMovementRequest
         * (suppressMovement branch) → startShutterMovement (suppressMotor
         * branch) → stopShutterMovement → notifyUserAboutConflict.
         * Category: Failure Scenario (safety-relevant). Mission-critical:
         * YES (REQ-S-01/REQ-S-02, L0_Constraints::Electrical::motorIsolation
         * behavioral counterpart).
         * Precondition: shutterController powered; no movement in progress.
         * Trigger: simultaneous UP (local) and DOWN (remote) assertion,
         * e.g. wiring fault, stuck switch, or conflicting local/remote intent,
         * held for LESS than calibrationHoldThresholdS = 3.0 [s]
         * (ProductComponents::ConfigurationManagerSoftware.
         * calibrationHoldThresholdS). Postcondition: motor remains
         * de-energized in both directions; a distinct user-perceivable
         * conflict indication is raised (ConflictEvent → buzzer).
         *
         * STATE MODEL CONSISTENCY (CRIT-3 fix, SMRR corrective pass): this
         * scenario now explicitly names the SystemStates.sysml
         * discriminator state it exercises. Detecting the simultaneous
         * UP+DOWN condition (s3 below) does NOT go directly from Idle to
         * ConflictSuppressed -- it first enters the intermediate
         * discriminator state AssessingSimultaneousHold (SystemStates::
         * AssessingSimultaneousHoldState), because the controller cannot
         * yet distinguish a brief conflicting command (this scenario) from
         * the first ~50ms of a deliberate sustained calibration hold
         * (SCEN_13_ConfigureController_TimingCalibration). Exactly two
         * outcomes are possible from AssessingSimultaneousHold, racing one
         * timed accept against one event accept (first-wins, no third
         * outcome):
         *   - simultaneous press SHORTER than calibrationHoldThresholdS
         *     (3.0s) -- the 'accept after 3.0 [SI::s]' fires with no
         *     ConfigModeEvent[activated] confirmation -> ConflictSuppressed.
         *     This is the path SCEN_07 (this scenario) exercises.
         *   - simultaneous press LONGER than/equal to calibrationHoldThresholdS
         *     (3.0s), sustained -- ConfigModeEvent[activated] arrives first,
         *     confirming a deliberate calibration hold -> ConfigurationMode.
         *     This alternative path is exercised by SCEN_13, not by SCEN_07.
         * State path exercised here: Idle -> AssessingSimultaneousHold ->
         * ConflictSuppressed (-> Idle on ControlCommand[direction==none]
         * release, per ConflictSuppressedState's own transition). This
         * matches Traceability::Traceability's existing State Model →
         * Scenario documentation for SCEN_07 exactly (no Traceability
         * change required). */

        action s1 {
            doc /* Step: acquireLocalUp -- logicalLocalRequestInterface emits ControlCommand
                 * (direction=up). Participant: LogicalLocalRequestInterface. */
        }
        action s2 {
            doc /* Step: acquireRemoteDown -- logicalRemoteRequestInterface emits ControlCommand
                 * (direction=down), concurrently. Participant:
                 * LogicalRemoteRequestInterface. */
        }
        action s3 {
            doc /* Step: detectConflict -- logicalControlUnit's arbitration observes both channels
                 * asserted within the arbitration window (Product-layer
                 * CommandArbitrationSoftware.arbitrationWindowMs=50ms
                 * concretizes this); determineMovementRequest's
                 * suppressMovement branch fires: request.direction := none.
                 * State model: this ControlCommand[direction==none] event is
                 * the entry trigger for SystemStates::AssessingSimultaneousHold
                 * (Idle -> AssessingSimultaneousHold), NOT a direct transition
                 * to ConflictSuppressed -- see the scenario-level doc above. */
        }
        action s4 {
            doc /* Step: suppressMotor -- startShutterMovement's suppressMotor branch: motorState.
                 * enable := false, direction := none. logicalMotorDrive
                 * never energizes. */
        }
        action s5 {
            doc /* Step: thresholdElapsesShort -- the simultaneous press releases (or simply
                 * persists) for LESS than calibrationHoldThresholdS = 3.0 [s]
                 * with no ConfigModeEvent[activated] confirmation ever
                 * arriving; AssessingSimultaneousHoldState's
                 * 'accept after 3.0 [SI::s]' transition fires ->
                 * ConflictSuppressed. This is the discriminator outcome that
                 * distinguishes this scenario from SCEN_13's sustained-hold
                 * path (see scenario-level doc). */
        }
        action s6 {
            doc /* Step: notifyConflict -- logicalControlUnit.conflictOut → logicalUserNotification.
                 * conflictEventIn (LogicalArchitecture connection 12b);
                 * realizes UseCaseActivities::notifyUserAboutConflict (REQ-S-02).
                 * At Product layer: ControlMCU::commandArbitrationSoftware.
                 * conflictOut → ControlMCU::userFeedbackSoftware.
                 * conflictEventIn → buzzerOut → AudibleNotificationBuzzer.
                 * Realized while the state machine is in ConflictSuppressed
                 * (SystemStates::ConflictSuppressedState). */
        }

        succession s1 then s2 then s3 then s4 then s5 then s6;
    }


    // ---- SCEN_08: Remote Command -- Home Automation Open -------------------
    action def SCEN_08_RemoteCommand_HomeAutomationOpen {
        doc
        /* UCA path: UseCaseActivities::OpenShutterAutomatically, remote
         * channel variant (same UCA as SCEN_01, different acquisition path).
         * Category: Alternative Scenario (channel variant). Mission-critical:
         * NO (redundant mechanism coverage; remote channel parity with
         * SCEN_01's local channel is the point being verified).
         * Precondition: shutterController powered; supervisor idle.
         * Trigger: HomeAutomationSystem asserts UP via remote channel.
         * Postcondition: shutter fully open; motor de-energized. */

        action s1 {
            doc /* Step: acquireRemoteUp -- logicalRemoteRequestInterface.ctrlIn observes UP from
                 * SystemContext::homeAutomationSystem; emits ControlCommand
                 * (direction=up, mode=automatic) on commandOut. Realizes
                 * receiveControlRequest (acceptRemoteCmd). */
        }
        action s2 {
            doc /* Step: arbitrateCommand -- logicalControlUnit.remoteCommandIn receives the command
                 * (LogicalArchitecture connection 5). */
        }
        action s3 {
            doc /* Step: startMotor -- logicalMotorDrive energizes UP (startShutterMovement). */
        }
        action s4 {
            doc /* Step: superviseAndStop -- logicalMovementSupervisor times out at openTime;
                 * logicalMotorDrive de-energized (monitorStopCondition →
                 * stopShutterMovement). */
        }

        succession s1 then s2 then s3 then s4;
    }

    // ---- SCEN_09: Local and Remote Simultaneous -- First-Wins Arbitration --
    action def SCEN_09_LocalAndRemoteSimultaneous_FirstWinsArbitration {
        doc
        /* UCA path: UseCaseActivities::ReceiveControlRequest's fork
         * (acceptFork) / merge (acceptMerge) race -- same-direction case
         * (non-conflicting), distinguishing this from SCEN_07's opposite-
         * direction conflict case.
         * Category: Alternative / edge-case Scenario. Mission-critical: NO.
         * Precondition: shutterController powered; supervisor idle.
         * Trigger: local wall switch and remote home-automation system both
         * assert UP within the arbitration window (CommandArbitrationSoftware.
         * arbitrationWindowMs=50ms), agreeing on direction.
         * Postcondition: exactly one ControlCommand is arbitrated through
         * (first-wins, whichever accept fires first); shutter opens normally;
         * no conflict is raised (both channels agree on direction). */

        action s1 {
            doc /* Step: acquireLocalUp -- logicalLocalRequestInterface emits ControlCommand
                 * (direction=up), acceptLocalCmd branch of the fork. */
        }
        action s2 {
            doc /* Step: acquireRemoteUpConcurrently -- logicalRemoteRequestInterface emits ControlCommand
                 * (direction=up), acceptRemoteCmd branch of the fork,
                 * within the same arbitration window. */
        }
        action s3 {
            doc /* Step: firstWinsMerge -- ReceiveControlRequest's acceptFork/acceptMerge: whichever
                 * accept action's flow reaches 'command' first is used; the
                 * second, later-arriving assertion of the SAME direction is
                 * a no-op (no conflict, since both agree). Participant:
                 * LogicalArchitecture::LogicalControlUnit (arbitration
                 * realized by Product::CommandArbitrationSoftware). */
        }
        action s4 {
            doc /* Step: startMotor -- logicalMotorDrive energizes UP once, from the single
                 * arbitrated MovementRequest. */
        }

        succession s1 then s2 then s3 then s4;

        // GAP: UseCaseActivities::ReceiveControlRequest's fork/merge models
        // "whichever fires first" but does not explicitly address the
        // same-direction-non-conflicting case distinctly from the opposite-
        // direction conflicting case (SCEN_07) -- both are structurally the
        // same fork/merge race, with the direction-comparison guard living
        // one action downstream, in DetermineMovementRequest. This scenario
        // confirms the architecture handles it correctly by composition
        // (no separate mechanism is required), but the UCA-level doc does
        // not call out this distinction explicitly. Recorded as a minor
        // documentation gap (Phase 5/8), not a structural gap.
    }

    // =========================================================================
    // Category 3 -- Installation Scenarios
    // =========================================================================

    // ---- SCEN_10: Install Controller -- Successful First Attempt ----------
    action def SCEN_10_InstallController_SuccessfulFirstAttempt {
        doc
        /* UCA path: UseCaseActivities::InstallController, happy path
         * (verifyWorking.success == true → assembleWallswitch).
         * Category: Installation Scenario. Mission-critical: YES (UC_02,
         * REQ-Q-01 easeOfInstallation gate for every subsequent scenario).
         * Precondition: shutter circuit power supply isolated/off; shutter
         * controller, wall switch, remote interface wiring, and motor
         * wiring available on-site, uninstalled.
         * Trigger: Installer begins physical installation.
         * Postcondition: controller connected and verified working; wall
         * switch reassembled; power restored. */

        action s1 {
            doc /* Step: turnOffPowerSupply -- Installer isolates the shutter circuit power supply.
                 * Realizes UseCaseActivities::turnOffPowerSupplyForShutters.
                 * Participant: Stakeholders::Installer (via SystemContext). */
        }
        action s2 {
            doc /* Step: disassembleWallswitch -- Installer removes the existing wall switch to access
                 * wiring. Realizes disassembleWallswitch. */
        }
        action s3 {
            doc /* Step: connectController -- Installer wires sut.product's boundary ports: localCtrl
                 * (wall switch), remoteCtrl (home automation), controlPower
                 * (12V DC), mainsPower (230V AC), shutterDrive (motor) via
                 * ProductArchitecture::RollerShutterControllerProductComponents'
                 * screw-terminal connectors (EnclosureAndConnectors). Realizes
                 * connectController. */
        }
        action s4 {
            doc /* Step: verifyWorking -- Installer restores power and issues a functional test
                 * command (e.g. UP); observes correct motor direction.
                 * verifyWorking.success == true on first attempt. Realizes
                 * verifyWorking. */
        }
        action s5 {
            doc /* Step: assembleWallswitch -- Installer reassembles the wall switch housing. Realizes
                 * assembleWallswitch. Postcondition state reached. */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // ---- SCEN_11: Install Controller -- Wiring Fault, Retry Succeeds ------
    action def SCEN_11_InstallController_WiringFault_RetrySucceeds {
        doc
        /* UCA path: UseCaseActivities::InstallController, retry branch
         * (verifyWorking.success == false → retryConnectController →
         * retryVerifyWorking.success == true → assembleWallswitch).
         * Direct precedent: Verification::SystemTestCases::TC_N_003_
         * Installation_WiringVerifyRetry.
         * Category: Installation / Recovery Scenario. Mission-critical: NO.
         * Precondition: same as SCEN_10, but with a deliberate wiring
         * defect (e.g. UP/DOWN motor phases swapped).
         * Trigger: initial functional verification fails.
         * Postcondition: after correction and retry, controller connected
         * and verified working; wall switch reassembled. */

        action s1 {
            doc /* Step: connectControllerIncorrectly -- Installer wires the motor phases swapped (deliberate
                 * defect, per TC_N_003 setup). Realizes connectController. */
        }
        action s2 {
            doc /* Step: verifyWorkingFails -- Functional test issued; motor runs in the wrong
                 * direction. verifyWorking.success == false. */
        }
        action s3 {
            doc /* Step: retryConnectController -- Installer powers off, corrects the wiring per
                 * installation instructions. Realizes
                 * UseCaseActivities::retryConnectController. */
        }
        action s4 {
            doc /* Step: retryVerifyWorkingSucceeds -- Installer powers on and re-issues the functional test;
                 * motor now runs in the correct direction.
                 * retryVerifyWorking.success == true. */
        }
        action s5 {
            doc /* Step: assembleWallswitch -- Installer reassembles the wall switch. Postcondition
                 * state reached (same as SCEN_10). */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // ---- SCEN_12: Install Controller -- Repeated Fault, Terminal Report ---
    action def SCEN_12_InstallController_RepeatedFault_TerminalReport {
        doc
        /* UCA path: UseCaseActivities::InstallController, terminal-fault
         * branch (retryVerifyWorking.success == false →
         * reportInstallationFault).
         * Category: Installation / Failure Scenario. Mission-critical: NO
         * (bounded-retry safety net, not a core movement path).
         * Precondition: same as SCEN_11, but the underlying defect is NOT
         * a controller-side wiring issue (e.g. a genuinely faulty external
         * power supply or motor).
         * Trigger: second consecutive functional-verification attempt
         * still fails.
         * Postcondition: an explicit terminal fault is reported; repair of
         * the fault is out of scope for the controller itself and requires
         * external intervention before installation can proceed (no
         * further automatic retry). */

        action s1 {
            doc /* Step: connectControllerIncorrectly -- Installer wiring attempt #1 (defect present). */
        }
        action s2 {
            doc /* Step: verifyWorkingFails -- verifyWorking.success == false. */
        }
        action s3 {
            doc /* Step: retryConnectController -- Installer's corrective attempt does not resolve a
                 * non-wiring root cause (external power supply/motor
                 * defect). */
        }
        action s4 {
            doc /* Step: retryVerifyWorkingFails -- retryVerifyWorking.success == false a second time. */
        }
        action s5 {
            doc /* Step: reportInstallationFault -- UseCaseActivities::reportInstallationFault surfaces the
                 * terminal fault signal; InstallController's bounded-retry
                 * decision graph (afterRetryVerify) does not loop further.
                 * External intervention required (out of controller scope). */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // =========================================================================
    // Category 4 -- Configuration / Primary Operational Scenarios
    // =========================================================================

    // ---- SCEN_13: Configure Controller -- Timing Calibration ---------------
    action def SCEN_13_ConfigureController_TimingCalibration {
        doc
        /* UCA path: UseCaseActivities::ConfigureController, full happy path
         * (checkConfigurationModeState → moveShutterToClosePosition →
         * activateConfigurationMode → notify → openFork/openJoin →
         * saveOpenTime → closeFork/closeJoin → saveCloseTime →
         * exitConfigurationMode → notify).
         * Category: Primary Operational / Installation Scenario.
         * Mission-critical: YES (REQ-F-07 configurableTimingProfile is the
         * foundation of the entire no-position-feedback, time-based
         * architecture -- ADR-003).
         * Precondition: controller installed and powered; configuration
         * mode not already active.
         * Trigger: Installer explicitly activates configuration mode
         * (sustained simultaneous UP+DOWN hold >= calibrationHoldThresholdS).
         * Postcondition: TravelTime (openTime, closeTime) measured and
         * persisted; configuration mode deactivated; user notified of both
         * activation and deactivation. */

        action s1 {
            doc /* Step: checkConfigurationModeState -- logicalControlUnit checks whether configuration mode is
                 * already active; alreadyActive == false. Realizes
                 * checkConfigurationModeState (reentryGuard decide). */
        }
        action s2 {
            doc /* Step: moveToClosePosition -- logicalMotorDrive drives the shutter to the fully-closed
                 * reference position. Realizes moveShutterToClosePosition. */
        }
        action s3 {
            doc /* Step: activateConfigMode -- logicalControlUnit.modeEventOut emits ConfigModeEvent
                 * (kind=activated) → logicalUserNotification.modeEventIn
                 * (LogicalArchitecture connection 12). Realizes
                 * activateConfigurationMode +
                 * notifyUserAboutActivationOfConfigurationMode. At Product
                 * layer: ConfigurationManagerSoftware.modeEventOut →
                 * UserFeedbackSoftware.modeEventIn → buzzerOut. */
        }
        action s4 {
            doc /* Step: measureOpenTime -- Fork+join: logicalMotorDrive runs OpenShutterManually
                 * while logicalMovementSupervisor's countActionTime observes
                 * the ShutterState stream (LogicalArchitecture connection 9)
                 * to measure elapsed openTime. Realizes runOpenMovement +
                 * countOpenTime (openFork/openJoin). */
        }
        action s5 {
            doc /* Step: saveOpenTime -- logicalMovementSupervisor.durationOut → logicalControlUnit.
                 * durationIn (LogicalArchitecture connection 10); persisted
                 * by Product::ControlMCU::memoryManagerSoftware. Realizes
                 * saveOpenTime. */
        }
        action s6 {
            doc /* Step: measureCloseTime -- Fork+join, closing direction: analogous to s4. Realizes
                 * runCloseMovement + countCloseTime (closeFork/closeJoin). */
        }
        action s7 {
            doc /* Step: saveCloseTime -- Persisted analogous to s5. Realizes saveCloseTime. */
        }
        action s8 {
            doc /* Step: exitConfigMode -- logicalControlUnit.modeEventOut emits ConfigModeEvent
                 * (kind=deactivated). Realizes exitConfigurationMode +
                 * notifyUserAboutDeactivationOfConfigurationMode. */
        }

        succession s1 then s2 then s3 then s4 then s5 then s6 then s7 then s8;
    }

    // ---- SCEN_14: Configure Controller -- Reentry Rejected -----------------
    action def SCEN_14_ConfigureController_ReentryRejected {
        doc
        /* UCA path: UseCaseActivities::ConfigureController, reentryGuard
         * decide, alreadyActive == true → rejectConfigurationModeReentry.
         * Direct precedent: Verification::SystemTestCases::TC_N_002_
         * ConfigMode_ReentryRejected.
         * Category: Alternative / Failure Scenario. Mission-critical: NO.
         * Precondition: configuration mode already active (an in-progress
         * calibration session, e.g. SCEN_13's s1-s3 completed).
         * Trigger: Installer attempts to activate configuration mode a
         * second time while already active.
         * Postcondition: second activation request rejected, no double
         * notification, no lockup; in-progress session continues
         * unaffected; normal configuration completion and exit still
         * succeed afterward. */

        action s1 {
            doc /* Step: configurationModeAlreadyActive -- Precondition state: logicalControlUnit's configuration
                 * session is in progress (post SCEN_13 s3). */
        }
        action s2 {
            doc /* Step: secondActivationAttempted -- Installer repeats the simultaneous UP+DOWN hold gesture. */
        }
        action s3 {
            doc /* Step: checkConfigurationModeStateDetectsActive -- checkConfigurationModeState.alreadyActive == true. */
        }
        action s4 {
            doc /* Step: rejectReentry -- rejectConfigurationModeReentry fires: the new activation
                 * request is dropped; the in-progress session continues
                 * unaffected -- no double notification is raised. */
        }
        action s5 {
            doc /* Step: sessionCompletesNormally -- The original in-progress calibration session (SCEN_13's
                 * s4-s8) completes and exits normally, unaffected by the
                 * rejected reentry attempt. */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // =========================================================================
    // Category 5 -- Failure / Recovery Scenarios (Off-Nominal, Phase 6)
    // =========================================================================

    // ---- SCEN_15: Power Loss During Movement -------------------------------
    action def SCEN_15_PowerLoss_DuringMovement {
        doc
        /* UCA path: NONE -- no UseCaseActivities action models a power-loss
         * event; this scenario traces only to ADR_002_Availability's
         * explicit decision ("availability realized via hardware MTBF
         * selection; no self-healing, failover, or watchdog architecture is
         * planned") and to SystemObjectives::reliability /
         * L0_Requirements::Quality::availability.
         * Category: Failure Scenario (off-nominal). Mission-critical: YES
         * (safety-relevant: an uncontrolled loss of control power while the
         * motor relay is energized).
         * Precondition: automatic or manual movement in progress
         * (logicalMotorDrive energized).
         * Trigger: controlPower (12V DC) is interrupted (e.g. upstream
         * breaker trip, supply fault) while movement is in progress.
         * Postcondition (as far as the architecture supports): the relay
         * coil (Product::MotorDriveRelayModule.coilIn, driven from
         * ControlMCU::motorDriveControlSoftware.relayOut) de-energizes
         * passively as soon as its own coilPowerIn (fed from
         * PowerSupplyModule.logicRailOut, itself fed from controlPower) is
         * lost -- an electrically passive fail-safe (no software
         * involvement), NOT an architecturally modeled/observed transition. */

        action s1 {
            doc /* Step: movementInProgress -- Precondition state: Product::ControlMCU::
                 * motorDriveControlSoftware has relayOut energized in some
                 * direction; MotorDriveRelayModule.driveOut is live. */
        }
        action s2 {
            doc /* Step: controlPowerInterrupted -- SystemContext::controlPowerSupply.supply is interrupted;
                 * Product::PowerSupplyModule.controlPowerIn loses input,
                 * so logicRailOut collapses. */
        }
        action s3 {
            doc /* Step: passiveRelayDeEnergization -- MotorDriveRelayModule.coilPowerIn (fed from
                 * logicRailOut) loses power; the relay coil de-energizes
                 * purely electrically (no firmware action, no
                 * ControlMCU involvement -- ControlMCU itself has also
                 * lost power at this point). Motor stops as a passive
                 * consequence, not a controlled StopShutterMovement action. */
        }

        succession s1 then s2 then s3;

        // GAP (Phase 5/8): no UseCaseActivities action, Logical component,
        // or Product firmware component observes, logs, or reacts to a
        // controlPower interruption. The passive relay de-energization is
        // an electrical property of the hardware (MotorDriveRelayModule +
        // PowerSupplyModule), not a modeled behavior -- there is no
        // "last known ShutterState" persistence, no power-loss detection,
        // and no distinction in the model between "motor stopped because
        // timeout/user-stop" vs. "motor stopped because power was lost".
        // This is consistent with ADR-002's explicit scope decision (no
        // watchdog/self-test/failover architecture) but leaves the exact
        // shutter position genuinely unknown after a mid-travel power loss
        // -- a residual consequence of the no-position-feedback design
        // (ADR-003, RISK-T-01) compounded by an unhandled power event.
    }

    // ---- SCEN_16: Power Recovery After Outage -------------------------------
    action def SCEN_16_PowerRecovery_AfterOutage {
        doc
        /* UCA path: NONE -- pairs with SCEN_15; no UseCaseActivities action
         * models a power-on/recovery sequence at the system-level (only
         * UseCaseActivities::VerifyWorking exists, and only within the
         * InstallController UCA, not for routine power recovery).
         * Category: Recovery Scenario (off-nominal). Mission-critical: YES
         * (determines whether the controller returns to a safe, usable
         * state after an outage without installer intervention).
         * Precondition: controlPower was interrupted (SCEN_15) and is now
         * restored; controller was NOT already in configuration mode at
         * the time of the outage.
         * Trigger: controlPower (12V DC) is restored.
         * Postcondition (as far as the architecture supports): ControlMCU
         * re-boots and firmware re-initializes; MemoryManagerSoftware
         * reloads the persisted TravelTime (and wiringMode) from
         * internal EEPROM (survives power cycles by construction, per
         * ProductComponents::MemoryManagerSoftware doc); the controller is
         * ready to accept new commands. The shutter's PHYSICAL position at
         * the moment of restart is NOT re-established or verified by any
         * modeled function. */

        action s1 {
            doc /* Step: controlPowerRestored -- SystemContext::controlPowerSupply.supply resumes;
                 * Product::PowerSupplyModule.controlPowerIn regains input;
                 * logicRailOut is restored to ControlMCU.powerIn and to
                 * every other logic-level Product component. */
        }
        action s2 {
            doc /* Step: firmwareReinitializes -- ControlMCU's eight firmware components re-initialize
                 * (implicit boot behavior of any MCU regaining power --
                 * not itself a named action in any architecture layer). */
        }
        action s3 {
            doc /* Step: timingProfileReloaded -- Product::ControlMCU::memoryManagerSoftware retrieves the
                 * persisted TravelTime and wiringMode from internal
                 * EEPROM (storageMedium attribute; survives power cycles by
                 * construction). Realizes UseCaseActivities::loadTimingProfile,
                 * the one UCA action that IS reused here (it is not
                 * power-loss-specific; it is the generic runtime timing-
                 * profile retrieval already used at the start of every
                 * automatic-mode movement). */
        }
        action s4 {
            doc /* Step: controllerReadyForNewCommands -- logicalControlUnit / commandArbitrationSoftware resume
                 * accepting new local/remote ControlCommand input. */
        }

        succession s1 then s2 then s3 then s4;

        // GAP (Phase 5/8): identical root cause to SCEN_15 -- no modeled
        // function re-establishes or even queries the shutter's actual
        // physical position after a power-loss/recovery cycle (ADR-003's
        // no-position-feedback decision means the architecture has no
        // sensor to query even if it tried). Firmware boot/re-init itself
        // is not represented as a named action anywhere in the model
        // (UseCaseActivities, FunctionalArchitecture, LogicalArchitecture,
        // or ProductComponents) -- s2 above is inferred generic MCU
        // behavior, not a traceable model element. ADR-002 explicitly
        // scopes this out ("no self-healing, failover, or watchdog
        // architecture is planned"); recorded here as the direct
        // operational consequence of that accepted architectural decision,
        // per the methodology's instruction to identify (not silently
        // invent a fix for) this gap.
    }

    // ---- SCEN_17: Mechanical Jam -- Time-Based Stop Without Feedback -------
    action def SCEN_17_MechanicalJam_TimeBasedStopWithoutFeedback {
        doc
        /* UCA path: UseCaseActivities::MonitorStopCondition, monitorTimeout
         * branch (the ONLY stop mechanism available -- no jam-specific
         * branch exists, by design, per ADR-003).
         * Direct precedent: Verification::SystemTestCases::TC_N_004_
         * NoPosiitonFeedback_TimeBased (step 4: "mechanically block
         * shutter mid-travel").
         * Category: Failure Scenario. Mission-critical: YES
         * (RISK-T-01_PositioningDrift, ADR_003_TimeBased's explicitly
         * "accepted residual risk").
         * Precondition: automatic-mode movement in progress; the shutter
         * mechanically jams (obstruction, track binding) partway through
         * travel.
         * Trigger: shutter physically stops moving before the configured
         * timeout elapses, but the controller has no way to detect this.
         * Postcondition: motor remains energized (in a stalled/jammed
         * state) until the configured timeout expires, then de-energizes
         * exactly as if the movement had completed normally -- NO fault is
         * raised, and no distinction is made between "reached end of
         * travel" and "jammed mid-travel". */

        action s1 {
            doc /* Step: automaticMovementStarts -- logicalMotorDrive energizes the motor (startShutterMovement),
                 * mode=automatic, per SCEN_01/02. */
        }
        action s2 {
            doc /* Step: mechanicalJamOccurs -- SystemContext::windowRollerShutter physically stops
                 * moving (obstruction) partway through travel. No Logical
                 * or Product component observes this: shutterStateOut
                 * (LogicalMotorDrive/MotorDriveControlSoftware) reports
                 * the COMMANDED state (moving=true, direction=up/down), not
                 * an OBSERVED physical state -- per ADR-003's explicit "no
                 * position feedback" decision. */
        }
        action s3 {
            doc /* Step: motorRemainsEnergizedStalled -- The relay/motor remains electrically energized (stalled)
                 * for the remainder of the configured openTime/closeTime
                 * timeout, drawing stall current with no controller
                 * awareness. */
        }
        action s4 {
            doc /* Step: timeoutFiresAsIfNormal -- logicalMovementSupervisor's monitorTimeout branch fires
                 * at the configured timeout, exactly as in the non-jammed
                 * case (SCEN_01 s6). StopRequest.reason := timeout --
                 * structurally IDENTICAL to a normal end-of-travel stop. */
        }
        action s5 {
            doc /* Step: stopMotor -- stopOut → stopIn de-energizes the motor. shutterState
                 * reports moving=false, direction=none -- indistinguishable
                 * from a successful full-travel completion. */
        }

        succession s1 then s2 then s3 then s4 then s5;

        // GAP (Phase 5/8, NOT newly discovered -- pre-existing, accepted):
        // ADR_003_TimeBased explicitly names RISK-T-01 (positioning drift)
        // as an accepted residual risk of the no-position-feedback
        // architecture. This scenario confirms the architecture executes
        // this path without error/exception (per TC_N_004's own
        // verifyOutcome: "no error mode, lockup, or exception when motor
        // is mechanically blocked"), but ALSO confirms there is no fault
        // classification, indication, or recovery mechanism for a
        // mid-travel jam distinct from normal completion -- the only
        // recovery path is a user-initiated re-calibration (UC_03) if
        // timing has drifted enough to become noticeable, or a
        // maintenance-technician-diagnosed motor-drive fault (SCEN_20) if
        // the jam is severe/persistent enough to look like "no movement at
        // all" on a subsequent command.
    }

    // =========================================================================
    // Category 6 -- Maintenance Scenarios
    // =========================================================================

    // ---- SCEN_18: Diagnose and Repair -- No Power Fault --------------------
    action def SCEN_18_DiagnoseAndRepair_NoPowerFault {
        doc
        /* UCA path: UseCaseActivities::DiagnoseAndRepairController
         * (detectFault → isolateFault → repairOrReplaceUnit), "no power"
         * fault class (REQ-Q-04, ProductInterfaces::FaultClass -- note "no
         * power" is deliberately NOT an enum member, being passively
         * observable rather than software-classified).
         * Direct precedent: Verification::SystemTestCases::TC_Q_004_
         * FieldDiagnosis.
         * Category: Maintenance Scenario. Mission-critical: NO (field
         * support process, not core operation).
         * Precondition: reported shutter malfunction ("nothing happens at
         * all"); MaintenanceTechnician on-site with no specialized lab
         * equipment (REQ-Q-05).
         * Trigger: technician applies control power and observes the
         * buzzer's startup behavior.
         * Postcondition: fault correctly classified as "no power" purely
         * acoustically; faulty power supply/wiring repaired or the
         * controller unit replaced on-site using existing wiring; normal
         * operation restored. */

        action s1 {
            doc /* Step: technicianAppliesPower -- Participant: Stakeholders::MaintenanceTechnician. Applies
                 * control power and listens for the buzzer's startup
                 * confirmation beep. Realizes detectFault. */
        }
        action s2 {
            doc /* Step: buzzerSilentAtStartup -- Product::AudibleNotificationBuzzer.powerIn (fed from
                 * PowerSupplyModule.logicRailOut, fed from controlPower) has
                 * no supply, so NO startup beep is emitted -- a purely
                 * passive acoustic consequence requiring zero software/
                 * DiagnosticsSoftware involvement (per AudibleNotification
                 * Buzzer's doc). This IS the "no power" fault classification
                 * itself, not a signal consumed by any component. */
        }
        action s3 {
            doc /* Step: isolateFault -- Technician isolates the fault to the controller's power
                 * input path (controlPower wiring or PowerSupplyModule)
                 * using the existing installation wiring, without
                 * modification (REQ-Q-05). Realizes isolateFault. */
        }
        action s4 {
            doc /* Step: repairOrReplace -- Technician repairs the power-supply wiring or replaces
                 * the controller unit on-site via EnclosureAndConnectors'
                 * screw-terminal blocks (no soldering). Realizes
                 * repairOrReplaceUnit. */
        }

        succession s1 then s2 then s3 then s4;
    }

    // ---- SCEN_19: Diagnose and Repair -- No Response Fault ------------------
    action def SCEN_19_DiagnoseAndRepair_NoResponseFault {
        doc
        /* UCA path: UseCaseActivities::DiagnoseAndRepairController,
         * "noResponseToControlInput" fault class (ProductInterfaces::
         * FaultClass).
         * Direct precedent: TC_Q_004_FieldDiagnosis.
         * Category: Maintenance Scenario. Mission-critical: NO.
         * Precondition: reported malfunction ("shutter does not respond to
         * any command"); control power confirmed present (buzzer beeps
         * normally at startup, ruling out SCEN_18).
         * Trigger: technician asserts a test UP/DOWN command and observes
         * the controller's diagnostic beep pattern.
         * Postcondition: fault correctly classified as "no response to any
         * control input"; faulty wall-switch/remote wiring repaired or
         * controller replaced on-site; normal operation restored. */

        action s1 {
            doc /* Step: technicianAssertsTestCommand -- Participant: Stakeholders::MaintenanceTechnician. Asserts
                 * a test UP command on the local or remote channel. */
        }
        action s2 {
            doc /* Step: diagnosticsObservesNoCommand -- Product::ControlMCU::diagnosticsSoftware.commandStateIn
                 * (tapped from commandArbitrationSoftware.commandRelayOut,
                 * PA-1 fix) observes NO arbitrated command despite the
                 * technician-asserted test input -- indicating the fault
                 * lies upstream of arbitration (wiring, RequestInterface
                 * Circuit, or the CommandArbitrationSoftware itself).
                 * Realizes detectFault. */
        }
        action s3 {
            doc /* Step: faultClassifiedAndIndicated -- diagnosticsSoftware.faultOut emits FaultIndication
                 * (faultClass=noResponseToControlInput) →
                 * userFeedbackSoftware.faultIndicationIn → a distinct
                 * buzzer beep pattern on buzzerOut. */
        }
        action s4 {
            doc /* Step: isolateFault -- Technician isolates the fault to the wall-switch/remote
                 * wiring or the RequestInterfaceCircuit/ControlMCU input
                 * path, using existing wiring (REQ-Q-05). */
        }
        action s5 {
            doc /* Step: repairOrReplace -- Technician repairs the wiring or replaces the controller
                 * unit on-site. Normal operation restored. */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // ---- SCEN_20: Diagnose and Repair -- Motor Drive Fault ------------------
    action def SCEN_20_DiagnoseAndRepair_MotorDriveFault {
        doc
        /* UCA path: UseCaseActivities::DiagnoseAndRepairController,
         * "motorDriveFault" fault class (ProductInterfaces::FaultClass).
         * Direct precedent: TC_Q_004_FieldDiagnosis.
         * Category: Maintenance Scenario. Mission-critical: NO.
         * Precondition: reported malfunction ("controller acknowledges
         * commands but shutter does not move"); control power and
         * command-reception both confirmed functioning.
         * Trigger: technician asserts a test UP/DOWN command; command IS
         * arbitrated, but no resulting motor movement occurs.
         * Postcondition: fault correctly classified as "motor-drive
         * fault"; faulty MotorDriveRelayModule or motor wiring repaired or
         * replaced on-site; normal operation restored. */

        action s1 {
            doc /* Step: technicianAssertsTestCommand -- Participant: Stakeholders::MaintenanceTechnician. */
        }
        action s2 {
            doc /* Step: diagnosticsConfirmsCommandReceived -- diagnosticsSoftware.commandStateIn confirms a command WAS
                 * received and arbitrated (distinguishing this case from
                 * SCEN_19). */
        }
        action s3 {
            doc /* Step: diagnosticsObservesNoMovement -- diagnosticsSoftware.diagnosticStateIn (inherited
                 * LogicalDiagnostics tap, fed from
                 * motorDriveControlSoftware.shutterStateOut) reports no
                 * resulting movement despite the confirmed command. */
        }
        action s4 {
            doc /* Step: faultClassifiedAndIndicated -- faultOut emits FaultIndication (faultClass=
                 * motorDriveFault) → userFeedbackSoftware → distinct buzzer
                 * beep pattern. */
        }
        action s5 {
            doc /* Step: isolateFault -- Technician isolates the fault to MotorDriveRelayModule
                 * (relay/triac, coil circuit) or the motor wiring, using
                 * existing wiring (REQ-Q-05). */
        }
        action s6 {
            doc /* Step: repairOrReplace -- Technician repairs/replaces MotorDriveRelayModule or the
                 * controller unit on-site. Normal operation restored. */
        }

        succession s1 then s2 then s3 then s4 then s5 then s6;
    }

    // =========================================================================
    // Category 7 -- Disposal Scenario
    // =========================================================================

    // ---- SCEN_21: Dispose Controller -- End of Life -------------------------
    action def SCEN_21_DisposeController_EndOfLife {
        doc
        /* UCA path: UseCaseActivities::DisposeController (UC_05).
         * Category: Disposal Scenario. Mission-critical: NO (end-of-life
         * regulatory process, not operational behavior).
         * Precondition: controller decommissioned and removed from
         * installation.
         * Trigger: controller retired at end of life.
         * Postcondition: controller materials collected, disassembled, and
         * disposed of/recycled in compliance with WEEE/RoHS regulation
         * (REQ-E-01 regulatedDisposal). */

        action s1 {
            doc /* Step: collectRetiredController -- Participant: Stakeholders::DisposalFacility. Collects the
                 * decommissioned controller unit. */
        }
        action s2 {
            doc /* Step: disassembleController -- DisposalFacility disassembles ProductArchitecture::
                 * RollerShutterControllerProductComponents via
                 * EnclosureAndConnectors' screw-terminal construction (no
                 * soldering, REQ-Q-05's field-replaceability property also
                 * simplifies end-of-life disassembly). */
        }
        action s3 {
            doc /* Step: disposeOrRecycleMaterials -- DisposalFacility disposes of/recycles the constituent
                 * materials (mains-voltage relay module, MCU/PCB, buzzer,
                 * enclosure plastics) per WEEE/RoHS regulation. Realizes
                 * UseCaseActivities::DisposeController. */
        }

        succession s1 then s2 then s3;

        // GAP: UseCaseActivities::DisposeController remains an
        // intentionally underspecified stub (single doc-only action, no
        // sub-steps) at the Use Case Activities layer itself -- this
        // scenario's s1-s3 decomposition is inferred from UC_05's
        // trigger/result/postcondition metadata and L0_Requirements::
        // Environmental::regulatedDisposal, not from any structural
        // UCA sub-action. Consistent with the model's own documented
        // scope (disposal is a low-priority, low-elaboration use case);
        // recorded here as a minor traceability-depth gap, not a defect.
    }

    // =========================================================================
    // Category 8 -- Configuration/Integrity/Environmental Off-Nominal
    // Scenarios (Scenario Repair Plan, SM-PRD-22, closes SR-7...SR-10)
    // =========================================================================

    // ---- SCEN_22: Configure Controller -- Invalid Calibration Rejected ----
    action def SCEN_22_ConfigureController_InvalidCalibrationRejected {
        doc
        /* UCA path: UseCaseActivities::ConfigureController, measurement
         * sub-path (checkConfigurationModeState → moveShutterToClosePosition
         * → activateConfigurationMode → openFork/runOpenMovement/countOpenTime
         * → openJoin → checkOpenTimeInRange), diverted by the openRangeGuard
         * decide into rejectOutOfRangeCalibration (MAJ-8 fix, SMRR
         * corrective pass: the guard is now structurally modeled, closing
         * the previously-documented GAP at s3).
         * Direct precedent: Verification::SystemTestCases::TC_B_003_
         * TimingProfile_MaxBoundary (boundary-adjacent -- exercises the
         * accepted 120 s boundary value; this scenario exercises a value
         * that EXCEEDS it and must be rejected).
         * Category: Configuration / Validation-Readiness Scenario (off-
         * nominal). Mission-critical: NO (installer-facing calibration
         * safeguard, not a core movement path).
         * Named participants: Installer (Stakeholders::installer);
         * LogicalArchitecture::LogicalControlUnit (config-mode state);
         * LogicalArchitecture::LogicalMovementSupervisor (countActionTime);
         * Product::ControlMCU::configurationManagerSoftware;
         * Product::ControlMCU::memoryManagerSoftware (would-be persistence
         * target); Product::ControlMCU::movementSupervisorSoftware.
         * Precondition: controller installed and powered; configuration
         * mode not already active; REQ-F-07's
         * maxConfigurableTravelTime <= 120 [SI::s] constraint in force.
         * Trigger: Installer activates configuration mode and, during the
         * open-travel-time calibration step, holds UP for longer than
         * 120 s (e.g. 150 s), producing an out-of-range measured value.
         * Postcondition: the out-of-range measurement is NOT persisted as
         * the openTime; the installer is prompted to retry the
         * measurement; configuration mode exits without saving an invalid
         * TravelTime value.
         * Success criteria: the previously-persisted (or default) timing
         * profile remains unchanged; no out-of-range value ever reaches
         * memoryManagerSoftware's persisted store; the installer receives
         * an observable retry prompt distinct from a successful save.
         * Traceability rationale: closes SR-7 (missing invalid-
         * configuration scenario) by walking REQ-F-07's own hard boundary
         * (<= 120 [SI::s]) from the "value exceeds the boundary" side,
         * complementing TC_B_003's "value exactly at the boundary,
         * accepted" case; supports RISK-T-05's mitigation (misconfiguration
         * during install) by giving the installer-facing calibration path
         * an explicit rejection outcome, not just a successful one. */

        action s1 {
            doc /* Step: activateConfigMode -- Installer performs the sustained simultaneous UP+DOWN
                 * hold gesture; checkConfigurationModeState.alreadyActive
                 * == false; logicalControlUnit / Product::ControlMCU::
                 * configurationManagerSoftware activates configuration
                 * mode, mirroring SCEN_13 s1-s3. Realizes
                 * checkConfigurationModeState + activateConfigurationMode. */
        }
        action s2 {
            doc /* Step: measureOpenTimeOutOfRange -- Installer holds the UP command for longer than the
                 * REQ-F-07 maximum (e.g. 150 s, versus the 120 s boundary
                 * TC_B_003 exercises at the accepted value). logicalMotorDrive
                 * runs OpenShutterManually while logicalMovementSupervisor's
                 * countActionTime (Product::ControlMCU::
                 * movementSupervisorSoftware) measures the elapsed
                 * duration, exactly as SCEN_13 s4 -- but the measured
                 * value now exceeds maxConfigurableTravelTime. Realizes
                 * runOpenMovement + countOpenTime (openFork/openJoin). */
        }
        action s3 {
            doc /* Step: detectOutOfRangeMeasurement -- MAJ-8 fix (SMRR corrective pass): now has an explicit
                 * structural owner -- UseCaseActivities::
                 * ConfigureController::checkOpenTimeInRange
                 * (CheckTravelTimeInRange), which evaluates REQ-F-07's
                 * 'require constraint { maxConfigurableTravelTime <= 120
                 * [SI::s] }' boundary against the measured value and sets
                 * inRange == false. Previously this step recorded a GAP
                 * ("no current structural owner"); the guard is now
                 * additively modeled in UCActivities.sysml (no redesign of
                 * ConfigureController's existing measurement path, only an
                 * inserted validation branch). */
        }
        action s4 {
            doc /* Step: rejectAndPromptRetry -- The openRangeGuard decide (ConfigureController) routes
                 * checkOpenTimeInRange.inRange == false into
                 * rejectOutOfRangeCalibration: the out-of-range measurement
                 * is not carried into saveOpenTime, and the installer is
                 * prompted (via Product::ControlMCU::userFeedbackSoftware,
                 * the same notification path SCEN_13 s3/s8 already use,
                 * reached through ExitConfigurationMode +
                 * NotifyUserAboutDeactivationOfConfigurationMode) to retry
                 * the measurement. No new notification function was
                 * introduced -- this is the scenario's success criterion,
                 * now satisfied structurally by the MAJ-8 guard. */
        }
        action s5 {
            doc /* Step: exitConfigModeWithoutSaving -- Configuration mode exits (ExitConfigurationMode,
                 * mirroring SCEN_13 s8) without an out-of-range openTime
                 * having reached memoryManagerSoftware's persisted store;
                 * the previously-persisted (or default) TravelTime
                 * value remains authoritative. */
        }

        succession s1 then s2 then s3 then s4 then s5;
    }

    // ---- SCEN_23: Local Control -- Wiring Mode Mismatch -------------------
    action def SCEN_23_LocalControl_WiringModeMismatch {
        doc
        /* UCA path: UseCaseActivities::ReceiveControlRequest (acceptLocalCmd
         * branch), reusing UC_02_InstallController's VerifyWorking retry
         * pattern (same structural precedent as SCEN_11) to surface the
         * mismatch. GAP: no existing UseCaseActivities action models
         * wiring-mode mismatch DETECTION specifically -- the closest
         * concrete anchor is UseCaseActivities::
         * handleConflictingMovementCommands (HandleConflictingMovementCommands),
         * because both are cases where the raw dry-contact signal does not
         * translate into the installer's intended ControlCommand; this is
         * a "closest concrete" link, not a precise realization, and is
         * recorded here explicitly (mirrors the SCEN_15/16 confirmed-gap
         * precedent already used in this file). No Use Case or Use Case
         * Activity is modified.
         * Direct precedent: Verification::SystemTestCases::TC_N_005_
         * WiringModeMismatch_Detected (new, Scenario Repair Plan C8);
         * white-box hook: Verification::Product::
         * VerifyWiringModeConfiguration (existing).
         * Category: Local Control / Installation-Adjacent Failure Scenario
         * (off-nominal). Mission-critical: YES -- closes the single
         * highest-priority gap in the Scenario Repair Plan: RISK-I-01
         * (Risk_WallSwitchWiringIncompatibility, major severity, mandatory
         * priority) previously had zero scenario or test coverage of its
         * actual failure mode, only of the correctly-configured cases
         * (TC_F_002/TC_F_003).
         * Named participants: Installer (Stakeholders::installer,
         * configuration); User (Stakeholders::user, subsequent operation);
         * LogicalArchitecture::LogicalLocalRequestInterface;
         * LogicalArchitecture::LogicalControlUnit;
         * Product::RequestInterfaceCircuit (localRequestInterface);
         * Product::ControlMCU::commandArbitrationSoftware (wiringMode
         * interpretation -- the exact mismatch point).
         * Precondition: controller installed; installer has selected
         * ConfigurationManagerSoftware.wiringMode = WiringMode::momentary
         * during configuration (REQ-I-01/RISK-I-01 selection step), but
         * the wall switch physically wired on-site is actually a latching
         * (toggle) switch.
         * Trigger: User operates the physically-latching wall switch,
         * which CommandArbitrationSoftware misinterprets under the
         * momentary-mode assumption.
         * Postcondition: the mismatch produces observably incorrect motor
         * behavior; Installer re-enters configuration mode, corrects the
         * wiringMode selection to WiringMode::latching, and re-verifies
         * successfully.
         * Success criteria: the mismatch is detectable/observable via a
         * functional verification step (per RISK-I-01's mitigation text,
         * "validated during installer configuration"), not silent;
         * correcting wiringMode resolves the misbehavior with no further
         * hardware changes.
         * Traceability rationale: closes SR-8 by giving REQ-I-01/RISK-I-01
         * a scenario and test case ( TC_N_005) for the mismatch failure
         * mode itself, complementing the existing correct-configuration
         * pairs (TC_F_002/TC_F_003); reinforces SR-5 by adding another
         * primary exercising path through commandArbitrationSoftware. */

        action s1 {
            doc /* Step: installerSelectsMomentary -- Installer, during configuration mode (UC_03 envelope,
                 * PA-2 fix), sets Product::ControlMCU::
                 * configurationManagerSoftware.wiringMode :=
                 * WiringMode::momentary and it is persisted by
                 * memoryManagerSoftware.persistedWiringMode -- but the
                 * actual wall-switch hardware wired on-site is latching. */
        }
        action s2 {
            doc /* Step: acquireLocalUpMismatched -- User holds the (physically latching) UP switch ON.
                 * LogicalLocalRequestInterface / Product::
                 * RequestInterfaceCircuit (localRequestInterface) forwards
                 * the raw dry-contact level to commandArbitrationSoftware,
                 * which interprets it per its configured (momentary)
                 * wiringMode -- an edge-triggered assumption applied to a
                 * level-triggered signal. Realizes receiveControlRequest
                 * (acceptLocalCmd), analogous to SCEN_01 s1. */
        }
        action s3 {
            doc /* Step: misinterpretedCommand -- commandArbitrationSoftware's momentary-mode
                 * interpretation of a latching signal produces an
                 * incorrect ControlCommand pattern -- e.g. the motor
                 * starts then stops unexpectedly, or continues running
                 * past the point the user intended to release. GAP: no
                 * UseCaseActivities action models wiring-mode mismatch
                 * DETECTION specifically (closest concrete anchor:
                 * handleConflictingMovementCommands, per this scenario's
                 * doc header above) -- recorded as an explicit gap, not
                 * silently fixed. */
        }
        action s4 {
            doc /* Step: verifyWorkingFails -- Reuses UC_02_InstallController's VerifyWorking retry
                 * pattern, same structural precedent as SCEN_11 s2: a
                 * functional test command is issued and the resulting
                 * motor behavior does not match the expected momentary-
                 * mode semantics, making the mismatch observable/
                 * detectable rather than silent (RISK-I-01's mitigation
                 * text requirement). */
        }
        action s5 {
            doc /* Step: installerReconfiguresWiringMode -- Installer re-enters configuration mode (checkConfiguration
                 * ModeState.alreadyActive == false), selects
                 * WiringMode::latching, and re-verifies successfully --
                 * reusing UC_02's retryConnectController/retryVerifyWorking
                 * structural pattern (SCEN_11 s3-s4) at the wiring-mode
                 * configuration level instead of the physical-wiring level. */
        }

        succession s1 then s2 then s3 then s4 then s5;

        // GAP (Scenario Repair Plan SR-8): UseCaseActivities.sysml has no
        // action modeling wiring-mode mismatch DETECTION as a distinct
        // mechanism from ReceiveControlRequest's normal acceptance path.
        // The closest concrete UCA anchor is
        // UseCaseActivities::handleConflictingMovementCommands (both cases
        // share the property that a raw signal fails to translate into the
        // installer's/user's intended ControlCommand), but this is a
        // "closest concrete" choice, not a precise realization -- recorded
        // explicitly per Traceability Rule 3, mirroring the SCEN_15/16
        // confirmed-gap precedent. Neither Use Cases nor Use Case
        // Activities are modified to close this gap; the new Negative test
        // case TC_N_005_WiringModeMismatch_Detected and the existing
        // Verification::Product::VerifyWiringModeConfiguration white-box
        // hook give this scenario its verification readiness without
        // requiring the UCA-level fix.
    }

    // ---- SCEN_24: Timing Profile -- Persistence Failure at First Power-On -
    action def SCEN_24_TimingProfile_PersistenceFailure_FirstPowerOn {
        doc
        /* UCA path: UseCaseActivities::LoadTimingProfile (no explicit
         * invalid/blank-read behavior documented -- see GAP at s2 below),
         * followed by the DiagnoseAndRepairController fault-classification
         * pattern (detectFault/isolateFault) reused from SCEN_18/19/20 as
         * the closest-fit signaling mechanism.
         * Direct precedent: Verification::SystemTestCases::TC_Q_004_
         * FieldDiagnosis (closest existing precedent for a first-power-on/
         * no-profile diagnostic classification).
         * Category: Data-Integrity / Recovery Scenario (off-nominal).
         * Mission-critical: YES (RISK-T-01_PositioningDrift's EEPROM-margin
         * mitigation depends on the profile being readable at all).
         * Named participants: User (first-power-on experience);
         * MaintenanceTechnician (field diagnosis, Stakeholders::
         * maintenanceTechnician); LogicalArchitecture::
         * LogicalMovementSupervisor; LogicalArchitecture::LogicalDiagnostics;
         * Product::ControlMCU::memoryManagerSoftware (the failing read);
         * Product::ControlMCU::movementSupervisorSoftware;
         * Product::ControlMCU::diagnosticsSoftware.
         * Precondition: controller powered for the first time ever (blank
         * EEPROM, no calibration has ever been performed), OR a worn/
         * corrupted EEPROM cell on a previously-configured unit.
         * Trigger: an automatic-mode movement is requested before any
         * valid TravelTime has ever been persisted, or the persisted
         * read returns corrupted/blank data.
         * Postcondition: LogicalMovementSupervisor has no valid
         * TravelTime to compute an automatic-mode timeout from;
         * automatic-mode movement is unavailable or behaves with an
         * undefined timeout (behavior currently underspecified -- recorded,
         * not invented, per the GAP below); diagnosticsSoftware flags that
         * configuration is required, reusing its existing fault-
         * classification port pattern.
         * Success criteria (as far as the architecture currently
         * supports): the absence of a readable profile is distinguishable
         * from a normal timeout-based stop via diagnosticsSoftware's
         * existing signaling mechanism, giving a MaintenanceTechnician (or
         * the Installer performing first-time setup) an observable
         * "configuration required" indication rather than silent
         * malfunction.
         * Traceability rationale: closes SR-9 -- MemoryManagerSoftware's
         * persistence mechanism (the sole means of keeping TravelTime/
         * wiringMode alive across power cycles, per RISK-T-01's mitigation)
         * had no scenario testing loss/corruption/absence of that
         * persisted state; SCEN_16 already establishes that persisted
         * state SURVIVES a power cycle -- this scenario is the first to
         * exercise the READ-FAILURE case, distinct from SCEN_15/16's
         * power-continuity failure mode. */

        action s1 {
            doc /* Step: firstPowerOnNoProfile -- Product::ControlMCU::memoryManagerSoftware's EEPROM read
                 * (storageMedium attribute) returns blank/invalid data --
                 * either because this is the controller's first-ever power-
                 * on (no calibration performed yet, distinct from SCEN_16's
                 * "already-calibrated unit recovering from an outage") or
                 * because of a worn/corrupted EEPROM cell. */
        }
        action s2 {
            doc /* Step: loadTimingProfileFails -- GAP: UseCaseActivities::LoadTimingProfile's doc (lines
                 * 361-368) specifies retrieving "the stored timing profile
                 * ... for use by movement-supervision functions" but does
                 * not document a default-value or fault-signaling behavior
                 * for a missing/invalid read -- unlike
                 * CheckConfigurationModeState's explicit alreadyActive
                 * guard. This step records that finding for a future UCA
                 * revision (per Traceability Rule 3); UCActivities.sysml is
                 * NOT modified, and no new fallback behavior is invented
                 * here. */
        }
        action s3 {
            doc /* Step: automaticModeUnavailableOrUsesUndefinedTimeout -- Direct consequence of the s2 gap: LogicalMovementSupervisor
                 * / Product::ControlMCU::movementSupervisorSoftware has no
                 * valid TravelTime to compute an automatic-mode timeout
                 * from. The resulting behavior (movement refused outright,
                 * versus proceeding with an undefined/zero timeout) is
                 * currently underspecified at every architecture layer --
                 * recorded here, not resolved, consistent with the s2 GAP. */
        }
        action s4 {
            doc /* Step: diagnosticsFlagsConfigurationRequired -- Product::ControlMCU::diagnosticsSoftware reuses its
                 * existing fault-classification port pattern (commandStateIn/
                 * diagnosticStateIn taps, faultOut → userFeedbackSoftware),
                 * the same mechanism SCEN_18/19/20 already exercise, as the
                 * closest-fit signaling mechanism to flag "configuration
                 * required" to a MaintenanceTechnician or Installer,
                 * realizing the closest available fit to
                 * DiagnoseAndRepairController's detectFault/isolateFault
                 * pattern for this data-integrity fault class. */
        }

        succession s1 then s2 then s3 then s4;

        // GAP (Scenario Repair Plan SR-9): UseCaseActivities::
        // LoadTimingProfile has no explicit default-value or fault-
        // signaling behavior for a missing/invalid EEPROM read, and no
        // requirement, use case activity, or test case currently addresses
        // "what happens if the persisted timing profile is absent or
        // invalid" at the UCA layer. This is a distinct failure mode from
        // SCEN_15/16's power-continuity failure: it is a data-integrity/
        // availability failure of the persistence mechanism itself. This
        // gap is recorded per Traceability Rule 3 -- UCActivities.sysml is
        // NOT modified, and no new fallback behavior is fabricated at any
        // architecture layer; s4's diagnosticsSoftware signaling reuses an
        // EXISTING port pattern only.
    }

    // ---- SCEN_25: Automatic Open -- Low-Temperature Boundary ---------------
    action def SCEN_25_AutomaticOpen_LowTemperatureBoundary {
        doc
        /* UCA path: identical to SCEN_01 (UseCaseActivities::
         * OpenShutterAutomatically, UC_01a) -- receiveControlRequest →
         * determineMovementRequest → startShutterMovement →
         * loadTimingProfile → monitorStopCondition → stopShutterMovement --
         * performed at the L0_Constraints::Environmental::
         * operatingConditions minimum boundary (0 degC) rather than at
         * nominal ambient conditions. This scenario's contribution is the
         * environmental precondition, not a new UCA path or component.
         * Direct precedent: Verification::SystemTestCases::TC_B_004_
         * OperatingTemp_LowerBoundary (direct 1:1 -- this scenario is that
         * test case's Runtime-View narrative counterpart).
         * Category: Environmental Boundary / Primary Operational Scenario
         * variant (off-nominal precondition). Mission-critical: NO
         * (documentation-completeness closure -- TC_B_004 already passes
         * today per the model's own test-case text; no architecture change
         * is needed or proposed).
         * Named participants: User (Stakeholders::user, wall-switch
         * operation); Manufacturer (Stakeholders::manufacturer,
         * OperatingConditions concern); LogicalArchitecture::
         * LogicalMotorDrive; LogicalArchitecture::LogicalMovementSupervisor;
         * Product::ControlMCU::motorDriveControlSoftware;
         * Product::ControlMCU::movementSupervisorSoftware;
         * Product::MotorDriveRelayModule (relay engagement at cold
         * temperature is the physically distinct risk versus SCEN_01).
         * Precondition: controller at 0 degC steady-state (30-minute
         * thermal soak, per TC_B_004's setup); shutter not already fully
         * open; supervisor idle.
         * Trigger: User asserts UP on the wall switch (same momentary-
         * press automatic-mode gesture as SCEN_01 s1), at the cold-
         * temperature boundary.
         * Postcondition: shutter fully open; logicalMotorDrive
         * de-energized; no cold-start failure, relay non-activation, or
         * timing-drift-induced malfunction observed (per TC_B_004's own
         * verifyOutcome).
         * Success criteria: relay engages correctly despite cold-
         * temperature contact resistance change; timeout-based stop fires
         * at the configured openTime with no temperature-induced drift
         * severe enough to cause malfunction.
         * Traceability rationale: closes SR-10 -- gives
         * L0_Constraints::Environmental::operatingConditions its first
         * Scenario-layer presence (previously requirement-verified via
         * TC_B_004/TC_B_005 but scenario-silent), reusing TC_B_004 as its
         * direct Test Case link; Manufacturer's OperatingConditions
         * concern (Stakeholders.sysml) is the stakeholder link this
         * scenario closes, via the package-level 'manufacturer' usage
         * added by the Scenario Repair Plan (C6a). */

        action s1 {
            doc /* Step: preconditionColdSoak -- Precondition state: controller at 0 degC steady-state
                 * (per TC_B_004's setup -- temperature chamber, 30-minute
                 * thermal soak), 12 V DC control power and rated switching
                 * load connected, same as SCEN_01's power-present
                 * precondition but at the environmental boundary. */
        }
        action s2 {
            doc /* Step: acquireLocalUp -- Identical to SCEN_01 s1: LogicalLocalRequestInterface.
                 * ctrlIn observes the UP dry-contact assertion from
                 * SystemContext::wallSwitch; emits ControlCommand
                 * (direction=up, mode=automatic). Realizes
                 * receiveControlRequest (acceptLocalCmd). */
        }
        action s3 {
            doc /* Step: startMotorColdRelay -- logicalMotorDrive / Product::ControlMCU::
                 * motorDriveControlSoftware energizes the motor UP via
                 * Product::MotorDriveRelayModule -- the relay engages
                 * correctly despite the cold-temperature contact
                 * resistance change, the one cold-specific physical risk
                 * named in TC_B_004's verifyOutcome (distinguishing this
                 * step from SCEN_01 s4's nominal-temperature equivalent).
                 * Realizes startShutterMovement (activateMotor branch). */
        }
        action s4 {
            doc /* Step: superviseAndStop -- logicalMovementSupervisor / Product::ControlMCU::
                 * movementSupervisorSoftware times out at the configured
                 * openTime with no temperature-induced timing drift severe
                 * enough to cause malfunction (per TC_B_004's verifyOutcome
                 * tolerance); logicalMotorDrive de-energized. Realizes
                 * monitorStopCondition (monitorTimeout branch) +
                 * stopShutterMovement, structurally identical to
                 * SCEN_01 s6-s7 but confirming correct operation at the
                 * environmental boundary. */
        }

        succession s1 then s2 then s3 then s4;
    }

    // =========================================================================
    // Package-level scenario usages (traceability anchor features).
    // SysML v2 connection ends must reference features (usages), not
    // classifier definitions (action def) -- mirrors the identical pattern
    // already used throughout UseCaseActivities.sysml (package-level action
    // usages) and every architecture layer's package-level part usage.
    // =========================================================================
    action scen01_AutomaticOpen_NormalPath                              : SCEN_01_AutomaticOpen_NormalPath;
    action scen02_AutomaticClose_NormalPath                             : SCEN_02_AutomaticClose_NormalPath;
    action scen03_ManualOpen_UserReleaseStop                            : SCEN_03_ManualOpen_UserReleaseStop;
    action scen04_ManualClose_UserReleaseStop                           : SCEN_04_ManualClose_UserReleaseStop;
    action scen05_ManualHold_SafetyTimeoutStop                          : SCEN_05_ManualHold_SafetyTimeoutStop;
    action scen06_AutomaticMovement_UserStopOverride                    : SCEN_06_AutomaticMovement_UserStopOverride;
    action scen07_ConflictingUpDownCommand_Suppressed                   : SCEN_07_ConflictingUpDownCommand_Suppressed;
    action scen08_RemoteCommand_HomeAutomationOpen                      : SCEN_08_RemoteCommand_HomeAutomationOpen;
    action scen09_LocalAndRemoteSimultaneous_FirstWinsArbitration       : SCEN_09_LocalAndRemoteSimultaneous_FirstWinsArbitration;
    action scen10_InstallController_SuccessfulFirstAttempt              : SCEN_10_InstallController_SuccessfulFirstAttempt;
    action scen11_InstallController_WiringFault_RetrySucceeds           : SCEN_11_InstallController_WiringFault_RetrySucceeds;
    action scen12_InstallController_RepeatedFault_TerminalReport        : SCEN_12_InstallController_RepeatedFault_TerminalReport;
    action scen13_ConfigureController_TimingCalibration                 : SCEN_13_ConfigureController_TimingCalibration;
    action scen14_ConfigureController_ReentryRejected                   : SCEN_14_ConfigureController_ReentryRejected;
    action scen15_PowerLoss_DuringMovement                              : SCEN_15_PowerLoss_DuringMovement;
    action scen16_PowerRecovery_AfterOutage                             : SCEN_16_PowerRecovery_AfterOutage;
    action scen17_MechanicalJam_TimeBasedStopWithoutFeedback            : SCEN_17_MechanicalJam_TimeBasedStopWithoutFeedback;
    action scen18_DiagnoseAndRepair_NoPowerFault                        : SCEN_18_DiagnoseAndRepair_NoPowerFault;
    action scen19_DiagnoseAndRepair_NoResponseFault                     : SCEN_19_DiagnoseAndRepair_NoResponseFault;
    action scen20_DiagnoseAndRepair_MotorDriveFault                     : SCEN_20_DiagnoseAndRepair_MotorDriveFault;
    action scen21_DisposeController_EndOfLife                          : SCEN_21_DisposeController_EndOfLife;
    action scen22_ConfigureController_InvalidCalibrationRejected       : SCEN_22_ConfigureController_InvalidCalibrationRejected;
    action scen23_LocalControl_WiringModeMismatch                      : SCEN_23_LocalControl_WiringModeMismatch;
    action scen24_TimingProfile_PersistenceFailure_FirstPowerOn        : SCEN_24_TimingProfile_PersistenceFailure_FirstPowerOn;
    action scen25_AutomaticOpen_LowTemperatureBoundary                 : SCEN_25_AutomaticOpen_LowTemperatureBoundary;
} // package Scenarios
