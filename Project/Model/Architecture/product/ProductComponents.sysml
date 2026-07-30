/* Product Architecture (SM-PRD-21) — Product Components.
 * Realizes Logical Architecture (SM-PRD-20) per ADR_006_ProductRealizationStrategy
 * and ADR_007_ProductCoupling.
 *
 * Coupling: strong (':>') for MovementSupervisorSoftware and PowerSupplyModule;
 * loose (allocation) for all other components — see ADR_007_ProductCoupling.
 *
 * Port/flow reuse: internal interfaces reuse FunctionalArchitecture and SystemContext
 * port defs; new defs (RelayControlPort, BuzzerControlPort, LogicPowerRailPort,
 * ProgrammingPort) are in ProductInterfaces.sysml.
 *
 * LogicalControlUnit port split across firmware modules:
 *   localCommandIn/remoteCommandIn + commandRelayOut -> CommandArbitrationSoftware
 *   requestOut                                       -> MovementControlSoftware
 *   modeEventOut                                     -> ConfigurationManagerSoftware
 *   durationIn/timingOut                             -> MemoryManagerSoftware
 */
package ProductComponents {
    private import ScalarValues::*;
    private import LogicalArchitecture::*;
    private import BaseArchitecture::*;
    private import DomainKnowledge::*;
    private import FunctionalArchitecture::*;
    private import SystemContext::*;
    private import ProductInterfaces::*;

    // Wall-switch wiring mode (REQ-I-01): selectable during installer configuration.
    enum def WiringMode {
        momentary; // Edge-triggered: brief press starts movement (push-button).
        latching;  // Level-triggered: input level represents commanded state (toggle-switch).
    }

    // ── Software Components (hosted on ControlMCU) ───────────────────────────

    part def CommandArbitrationSoftware {
        doc
        /* Translates raw dry-contact signals to typed ControlCommands for both channels,
         * arbitrates between local and remote requests, and detects UP+DOWN conflicts.
         * Loosely allocated from LogicalLocalRequestInterface, LogicalRemoteRequestInterface,
         * and LogicalControlUnit (ADR-007). arbitrationWindowMs governs initiation priority only;
         * stop signals from either channel have equal priority (realized downstream).
         * Owns software debounce confirmation for the four wall-switch/remote input lines
         * (localUp, localDown, remoteUp, remoteDown carried by localRawIn/remoteRawIn): each
         * line's dedicated GPIO change-notification interrupt only flags/timestamps a raw
         * transition (ControlMCU); this module confirms the new level is stable for at least
         * debounceConfirmMs before treating it as a genuine edge, since RequestInterfaceCircuit's
         * RC filter alone suppresses electrical noise/glitches only, not genuine mechanical
         * wall-switch bounce (ADR-SW-010). */

        // Channel arbitration window (ms): channel winning by more than this wins initiation;
        // concurrent opposite-direction assertions within window raise UP+DOWN conflict.
        // Sized to stay well above the combined RC+SW debounce latency (~50ms: RC
        // debounceTimeConstantMs=20 + debounceConfirmMs=30), so debounce latency cannot
        // itself be misread as a genuine arbitration race (ADR-SW-010).
        attribute arbitrationWindowMs : Real = 100.0;

        // Short/long-press threshold (ms, REQ-F-09): below → automatic mode; at/above → manual hold-to-run.
        attribute pressDurationThresholdMs : Real = 500.0;

        // Software debounce confirmation window (ms) applied after each GPIO change-notification
        // interrupt on the four input lines, complementing RequestInterfaceCircuit.debounceTimeConstantMs
        // (RC filters high-frequency noise only; this confirms genuine, stable actuation) (ADR-SW-010).
        attribute debounceConfirmMs : Real = 30.0;

        attribute wiringMode : WiringMode = WiringMode::momentary;

        attribute estimatedFlashBytes : Natural = 1200;
        attribute estimatedRamBytes : Natural = 48;

        port localRawIn : ~DryContactControlPort;
        port remoteRawIn : ~DryContactControlPort;
        // Arbitrated, conflict-resolved ControlCommand; fanned out to MovementControlSoftware
        // and ConfigurationManagerSoftware.
        port commandOut : ControlCommandPort;
        // Relays the arbitrated command to MovementSupervisorSoftware.
        port commandRelayOut : ControlCommandPort;
    }

    part def MovementControlSoftware {
        doc
        /* Converts the arbitrated ControlCommand into a validated MovementRequest.
         * Loosely allocated from LogicalControlUnit (ADR-007). */

        // Firmware resource estimates:
        attribute estimatedFlashBytes : Natural = 400;
        attribute estimatedRamBytes : Natural = 16;

        port commandIn : ~ControlCommandPort;
        // Fanned out to MotorDriveControlSoftware and MovementSupervisorSoftware.
        port requestOut : MovementRequestPort;
    }

    part def ConfigurationManagerSoftware {
        doc
        /* Detects the local-only sustained UP+DOWN hold gesture and emits ConfigModeEvent
         * (REQ-F-08). Remote-originated simultaneous assertions never trigger config mode.
         * Loosely allocated from LogicalControlUnit (ADR-007). Realizes
         * UseCaseActivities::DetermineConfigurationMode (perform'ed at the
         * FunctionalArchitecture layer by configurationControlFunctions.
         * determineConfigMode; stays blackbox here per PLAN.md's deliberate
         * no-hardware-port decision, so no further whitebox decomposition is
         * added in SWBuildingBlocks.sysml). */

        // Minimum local-only UP+DOWN hold duration (s) to trigger configuration-mode entry/exit (REQ-F-08).
        attribute calibrationHoldThresholdS : Real = 5.0;

        // Default: momentary (push-button); installer can select latching (toggle-switch).
        attribute wiringMode : WiringMode = WiringMode::momentary;

        attribute estimatedFlashBytes : Natural = 700;
        attribute estimatedRamBytes : Natural = 24;

        // Inspects ControlCommand.source directly for the local-only gate (REQ-F-08).
        port commandIn : ~ControlCommandPort;
        port modeEventOut : ConfigModeEventPort;
    }

    part def MemoryManagerSoftware {
        doc
        /* Persists and retrieves TravelTime (openTime/closeTime, REQ-F-07) to/from the
         * MCU's internal EEPROM (ADR-006). Loosely allocated from LogicalControlUnit (ADR-007). */

        attribute storageMedium : String =
            "ControlMCU internal EEPROM (emulated or native), no external memory IC required (ADR-006)";

        // Timeout margin (s) above measured travel time, compensating for timing drift (RISK-T-01).
        attribute timingMarginS : Real = 5.0;

        // True if last EEPROM TravelTime read returned a valid record; false before calibration or on corruption.
        attribute lastReadValid : Boolean = true;

        // Firmware resource estimates:
        attribute estimatedFlashBytes : Natural = 900;
        attribute estimatedRamBytes : Natural = 32;

        port durationIn : ~TravelTimePort;
        port timingOut : TravelTimePort;
    }

    part def MovementSupervisorSoftware :> LogicalMovementSupervisor {
        doc
        /* Timer-based supervision of shutter movement (automatic timeout, manual hold-to-run, ADR-003)
         * and travel-time measurement during calibration. Strongly coupled to
         * LogicalMovementSupervisor (ADR-007, 1:1 realization). */

        // Timer tick resolution (ms) for automatic end-of-travel and manual hold-to-run timeouts.
        attribute timerResolutionMs : Real = 10.0;

        attribute estimatedFlashBytes : Natural = 1000;
        attribute estimatedRamBytes : Natural = 40;
    }

    part def MotorDriveControlSoftware {
        doc
        /* Firmware half of LogicalMotorDrive: controls relay coil signals and reports ShutterState
         * in response to MovementRequest/StopRequest (ADR-003, no position sensor).
         * Loosely allocated from LogicalMotorDrive (ADR-007). */

        port requestIn : ~MovementRequestPort;
        port stopIn : ~StopRequestPort;
        port shutterStateOut : ShutterStatePort;
        port relayOut : RelayControlPort;

        // Firmware resource estimates:
        attribute estimatedFlashBytes : Natural = 600;
        attribute estimatedRamBytes : Natural = 24;
    }

    part def UserFeedbackSoftware {
        doc
        /* Generates GPIO beep patterns on the buzzer for configuration-mode transitions (REQ-F-08).
         * Loosely allocated from LogicalUserNotification (ADR-007, ADR-008); commits the concrete
         * technology left as a qualitative placeholder by LogicalUserNotification's 'feedbackModality'. */

        attribute feedbackTechnology : String =
            "Active buzzer (self-oscillating, 3.3V logic-level drive, single GPIO), software-generated beep patterns (ADR-008).";

        // Beep-pattern specification per configuration-mode transition (pulse count + duration):
        attribute configModeActivationBeepCount : Natural = 1; // REQ-F-08 activation: single short beep
        attribute configModeActivationBeepMs : Natural = 200;
        attribute configModeDeactivationBeepCount : Natural = 2; // REQ-F-08 deactivation: double short beep
        attribute configModeDeactivationBeepMs : Natural = 200;
        attribute configModeBeepGapMs : Natural = 150; // silence between pulses within a pattern

        port modeEventIn : ~ConfigModeEventPort;
        port buzzerOut : BuzzerControlPort;

        // Firmware resource estimates:
        attribute estimatedFlashBytes : Natural = 800;
        attribute estimatedRamBytes : Natural = 32;
    }

    // ── Hardware / Electrical / Mechanical Components ────────────────────────

    part def RequestInterfaceCircuit {
        doc
        /* Shared hardware type for raw dry-contact signal conditioning: opto-isolation,
         * RC glitch filtering, and 3.3V level-shifting. Instantiated twice (local + remote),
         * guaranteeing REQ-I-02 equivalence by construction. Loosely allocated from
         * LogicalLocalRequestInterface/LogicalRemoteRequestInterface (ADR-007).
         * debounceTimeConstantMs suppresses electrical noise/contact glitches only; it is
         * not sufficient to debounce genuine mechanical wall-switch actuation bounce, which
         * is confirmed in software by CommandArbitrationSoftware.debounceConfirmMs (ADR-SW-010). */

        attribute isolationTechnology : String =
            "Opto-isolator per channel, galvanically isolating the external dry-contact loop from the 3.3V logic domain";
        // RC glitch-filter time constant (electrical noise only — see doc above for the
        // complementary software debounce stage).
        attribute debounceTimeConstantMs : Real = 20.0;
        attribute unitCostPLN : Real = 1.5;

        port ctrlIn : ~DryContactControlPort;
        // Conditioned (isolated, debounced, level-shifted) output; reuses DryContactControlPort shape.
        port digitalOut : DryContactControlPort;
        port powerIn : ~LogicPowerRailPort;
    }

    part def ControlMCU {
        doc
        /* Single low-cost 8-bit MCU (ADR-006) hosting all seven firmware components.
         * Many-to-one hosting modeled via allocation, not specialization (ADR-007).
         * localRawIn/remoteRawIn's four signal lines (local up/down, remote up/down) are each
         * wired to a dedicated GPIO configured for change-notification interrupts (ADR-SW-010);
         * RequestInterfaceCircuit's RC filter removes electrical noise/glitches only — it is
         * not sufficient to debounce genuine mechanical wall-switch actuation, so
         * CommandArbitrationSoftware performs the additional software debounce confirmation. */

        attribute mcuFamily : String = "Ultra-low-cost 8-bit MCU, STM8S003F3P6-class";
        attribute packageType : String = "TSSOP-20";
        attribute gpioCount : Natural = 14;
        // Of gpioCount, four are dedicated to change-notification interrupts on the
        // local/remote up/down dry-contact lines (ADR-SW-010).
        attribute inputChangeNotificationGpioCount : Natural = 4;
        attribute flashSizeKB : Natural = 16;
        attribute internalEepromBytes : Natural = 128;
        // RAM capacity for aggregate firmware estimatedRamBytes budget check.
        attribute internalRamBytes : Natural = 1024;
        attribute clockSpeedMHz : Natural = 16;
        attribute unitCostPLN : Real = 2.0;

        attribute mtbfHours : Real = 500000.0;

        port localRawIn : ~DryContactControlPort;
        port remoteRawIn : ~DryContactControlPort;
        port relayOut : RelayControlPort;
        port buzzerOut : BuzzerControlPort;
        port powerIn : ~LogicPowerRailPort;
        // Production-only in-circuit programming/debug interface (ADR-006); unconnected in normal operation.
        port progPort : ProgrammingPort;

        // ── Firmware components ─────────────────────────────────────────────
        part commandArbitrationSoftware : CommandArbitrationSoftware;
        part movementControlSoftware : MovementControlSoftware;
        part configurationManagerSoftware : ConfigurationManagerSoftware;
        part memoryManagerSoftware : MemoryManagerSoftware;
        part movementSupervisorSoftware : MovementSupervisorSoftware;
        part motorDriveControlSoftware : MotorDriveControlSoftware;
        part userFeedbackSoftware : UserFeedbackSoftware;

        // ── Boundary delegations ─────────────────────────────────────────────
        connect localRawIn to commandArbitrationSoftware.localRawIn;
        connect remoteRawIn to commandArbitrationSoftware.remoteRawIn;
        connect motorDriveControlSoftware.relayOut to relayOut;
        connect userFeedbackSoftware.buzzerOut to buzzerOut;
        // powerIn/progPort: no internal connections — power is implicit via MCU die; progPort is production-only.

        // ── Internal firmware-to-firmware connections ───────────────────────
        // 1. CommandArbitrationSoftware -> MovementControlSoftware [ControlCommand]
        flow : ControlCommandFlow
            from commandArbitrationSoftware.commandOut to movementControlSoftware.commandIn;

        // 2. CommandArbitrationSoftware -> ConfigurationManagerSoftware [ControlCommand]
        // Fan-out leg 2 of 2 (mode-trigger detection tap).
        flow : ControlCommandFlow
            from commandArbitrationSoftware.commandOut to configurationManagerSoftware.commandIn;

        // 3. CommandArbitrationSoftware -> MovementSupervisorSoftware [ControlCommand relay]
        flow : ControlCommandFlow
            from commandArbitrationSoftware.commandRelayOut to movementSupervisorSoftware.commandIn;

        // 5. MovementControlSoftware -> MotorDriveControlSoftware [MovementRequest]
        // Fan-out leg 1 of 2.
        flow : MovementRequestFlow
            from movementControlSoftware.requestOut to motorDriveControlSoftware.requestIn;

        // 6. MovementControlSoftware -> MovementSupervisorSoftware [MovementRequest]
        // Fan-out leg 2 of 2.
        flow : MovementRequestFlow
            from movementControlSoftware.requestOut to movementSupervisorSoftware.requestIn;

        // 7. MovementSupervisorSoftware -> MotorDriveControlSoftware [StopRequest]
        flow : StopRequestFlow
            from movementSupervisorSoftware.stopOut to motorDriveControlSoftware.stopIn;

        // 8. MotorDriveControlSoftware -> MovementSupervisorSoftware [ShutterState]
        flow : ShutterStateFlow
            from motorDriveControlSoftware.shutterStateOut
            to movementSupervisorSoftware.shutterStateIn;

        // 10. MovementSupervisorSoftware -> MemoryManagerSoftware [TravelTime]
        flow : TravelTimeFlow
            from movementSupervisorSoftware.durationOut to memoryManagerSoftware.durationIn;

        // 11. MemoryManagerSoftware -> MovementSupervisorSoftware [TravelTime]
        flow : TravelTimeFlow
            from memoryManagerSoftware.timingOut to movementSupervisorSoftware.timingIn;

        // 12. ConfigurationManagerSoftware -> UserFeedbackSoftware [ConfigModeEvent]
        flow : ConfigModeEventFlow
            from configurationManagerSoftware.modeEventOut to userFeedbackSoftware.modeEventIn;

        // 12b. ConfigurationManagerSoftware -> MovementSupervisorSoftware [ConfigModeEvent]
        // Fan-out sibling of connection 12; modeEventIn is inherited from
        // LogicalMovementSupervisor via the ':>' strong coupling (ADR-007) --
        // the exhibited state machine's host has a real, non-implicit port
        // path for this event.
        flow : ConfigModeEventFlow
            from configurationManagerSoftware.modeEventOut to movementSupervisorSoftware.modeEventIn;
    }

    part def MotorDriveRelayModule {
        doc
        /* Relay-based motor switching module (ADR-001, ADR-006): coil driven by
         * MotorDriveControlSoftware; contacts switch mains power (8A/230VAC) to the shutter motor.
         * Provides galvanic isolation (motorIsolation constraint). Loosely allocated from
         * LogicalMotorDrive (ADR-007). */

        attribute relaySwitchingCurrentA : Real = 8.0;
        attribute relaySwitchingVoltageV : Real = 230.0;
        attribute contactConfiguration : String =
            "Two SPDT relays (UP/DOWN), interlocked to prevent simultaneous energization";
        attribute unitCostPLN : Real = 3.5;

        // Minimum switching-cycle rating required by sourced component (RISK-T-03, REQ-Q-03).
        attribute ratedCycleCount : Natural = 10000;
        // Illustrative MTBF estimate; refine on component selection (ADR-002, REQ-Q-02).
        attribute mtbfHours : Real = 100000.0;

        port coilIn : ~RelayControlPort;
        port coilPowerIn : ~LogicPowerRailPort;
        port mainsIn : ~MainsPowerPort;
        port driveOut : ShutterDrivePort;
    }

    part def AudibleNotificationBuzzer {
        doc
        /* Active (self-oscillating) piezo buzzer driven by UserFeedbackSoftware via BuzzerControlPort
         * (ADR-008). Scope: configuration-mode entry/exit signals only (REQ-F-08).
         * Loosely allocated from LogicalUserNotification (ADR-007). */

        attribute buzzerType : String =
            "Active (self-oscillating) buzzer, 3.3V logic-level drive, single MCU GPIO (ADR-008)";
        attribute unitCostPLN : Real = 0.5;

        port driveIn : ~BuzzerControlPort;
        port powerIn : ~LogicPowerRailPort;
    }

    part def PowerSupplyModule :> BaseArchitecture::PowerModule {
        doc
        /* Converts 12VDC±10% to the regulated 3.3V logic rail (supplyVoltage constraint).
         * Strongly coupled to BaseArchitecture::PowerModule (ADR-007); sole architectural
         * producer of SystemStates::PowerLost/PowerRestored via supplyPresent signal. */

        attribute regulatorTopology : String =
            "Linear (LDO) regulator, 12V -> 3.3V, adequate for this product's low aggregate logic-level current draw";
        attribute unitCostPLN : Real = 1.5;

        // Illustrative MTBF estimate; refine on component selection (ADR-002, REQ-Q-02).
        attribute mtbfHours : Real = 200000.0;

        // True when controlPowerIn has a valid 12VDC supply; transitions signal PowerLost/PowerRestored.
        attribute supplyPresent : Boolean = true;

        port controlPowerIn : ~ControlPowerPort;
        // Fanned out to all logic-level components (see ProductArchitecture.sysml).
        port logicRailOut : LogicPowerRailPort;
    }

    part def EnclosureAndConnectors {
        doc
        /* Mechanical housing and wiring connectors; a new Product-layer element with no Logical
         * counterpart (ADR-007), traced directly to compactDimensions, operatingConditions,
         * and REQ-Q-01. Dimensions set below the 40×40×20mm ceiling to allow fabrication margin. */

        attribute width subsets ISQ::length = 38 [SI::mm];
        attribute length subsets ISQ::length = 38 [SI::mm];
        attribute height subsets ISQ::length = 18 [SI::mm];
        attribute mountingType : String =
            "Flush-mounted ⌀60mm wall box, compatible with standard residential wall-switch installations (REQ-Q-01)";
        attribute connectorType : String =
            "Screw-terminal blocks for all external wiring (wall switch, remote, control power, mains, motor) -- no soldering required for field replacement";
        attribute unitCostPLN : Real = 4.0;
    }
} // package ProductComponents
