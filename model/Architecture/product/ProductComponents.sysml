/* Product Architecture (SM-PRD-21) — Product Components.
 *
 * Technology-specific (Hardware / Software / Electrical / Mechanical)
 * realization of the validated Logical Architecture (SM-PRD-20), per
 * ADR_006_ProductRealizationStrategy (single-MCU platform, software
 * modularization, relay-based motor switching, audible buzzer user feedback (ADR-008)
 * per ADR_008_BuzzerFeedback) and
 * ADR_007_ProductCoupling (per-component strong/loose coupling strategy).
 *
 * COUPLING SUMMARY (full rationale in ADR_007_ProductCoupling):
 *   - STRONG ('):>'): MovementSupervisorSoftware :> LogicalMovementSupervisor;
 *     DiagnosticsSoftware :> LogicalDiagnostics; PowerSupplyModule :>
 *     BaseArchitecture::PowerModule.
 *   - LOOSE (allocation, see LogicalToProductAllocation.sysml): every other
 *     Logical component, because ADR-006 splits LogicalControlUnit,
 *     LogicalMotorDrive, LogicalUserNotification, and the two request
 *     interfaces across more than one Product component (hardware host +
 *     one or more firmware modules), and because ControlMCU itself is the
 *     shared physical host for all eight firmware modules (many-to-one
 *     hosting relationship, not specialization).
 *
 * PORT/FLOW REUSE (DRY, mirrors the same decision already made at the
 * Logical Architecture layer): every internal software-to-software
 * interface below reuses FunctionalArchitecture's existing port defs
 * (ControlCommandPort, MovementRequestPort, StopRequestPort,
 * ShutterStatePort, TravelTimePort, TimingProfilePort, ConfigModeEventPort,
 * ConflictEventPort) and DomainKnowledge's existing flow defs unchanged.
 * Every hardware-to-hardware or hardware-to-boundary interface reuses
 * SystemContext's existing port defs (DryContactControlPort,
 * ControlPowerPort, MainsPowerPort, ShutterDrivePort) unchanged. New port
 * defs (ProductInterfaces.sysml) are introduced ONLY for the genuinely new
 * physical/technology-specific interfaces this layer adds (relay-coil
 * control, buzzer indicator control, the regulated logic power rail, and the
 * production programming/debug interface).
 *
 * SOFTWARE-MODULE / LogicalControlUnit PORT SPLIT (closes the FIRM
 * PRODUCT-ARCHITECTURE FOLLOW-UP mandated in LogicalArchitecture.sysml):
 * LogicalControlUnit's eight ports are redistributed across four firmware
 * modules as follows, preserving every external signal exactly:
 *   - localCommandIn/remoteCommandIn (now raw, pre-translation signals) +
 *     commandRelayOut + conflictOut  -> CommandArbitrationSoftware
 *     (requestAcquisitionFunctions translation+arbitration sub-behavior,
 *     plus UP+DOWN conflict detection, which -- like arbitration --
 *     requires simultaneous visibility of both channels and therefore
 *     cannot be realized downstream of the single-command arbitration
 *     result).
 *   - requestOut                     -> MovementControlSoftware
 *     (remaining controlLogicFunctions: turns the arbitrated, conflict-
 *     resolved ControlCommand into the final MovementRequest).
 *   - modeEventOut                   -> ConfigurationManagerSoftware
 *     (configurationControlFunctions).
 *   - durationIn/timingOut           -> MemoryManagerSoftware
 *     (memoryFunctions: persists/retrieves the TravelTime).
 * This directly answers the mandatory re-check: memoryFunctions and
 * configurationControlFunctions are now separately replaceable/testable
 * firmware components, as required, without fragmenting the hardware BOM
 * (ADR-006).
 */
package ProductComponents {
    private import ScalarValues::*;
    private import LogicalArchitecture::*;
    private import BaseArchitecture::*;
    private import DomainKnowledge::*;
    private import FunctionalArchitecture::*;
    private import SystemContext::*;
    private import ProductInterfaces::*;

    // =========================================================================
    // PA-2 fix (Product Architecture Review, model_issues.md item 18): the
    // second half of the signalInterpretation decision LogicalLocalRequestInterface/
    // LogicalRemoteRequestInterface both explicitly deferred to Product
    // Architecture. REQ-I-01/RISK-I-01 commit to a wall-switch wiring mode
    // "selectable during installer configuration"; this enum is the concrete
    // value both CommandArbitrationSoftware (interpretation) and
    // ConfigurationManagerSoftware (selection)/MemoryManagerSoftware
    // (persistence) now share. Modeled as additional configuration data
    // within the existing UC_03 envelope (RECOMMENDED, low-churn path
    // explicitly selected per productArchitectureRepairPlan.md PA-2 decision
    // point) -- no Use Case, Use Case Activities, Functional Architecture, or
    // Logical Architecture element is modified.
    // =========================================================================
    enum def WiringMode {
        momentary; // Edge-triggered/hold-to-run semantics: a brief press starts movement,
        // release (or timeout) stops it (push-button wall switch).
        latching; // Level-triggered/toggle semantics: the input level itself represents
        // the commanded state (toggle switch wall switch).
    }

    // =========================================================================
    // Software Components (hosted on ControlMCU)
    // =========================================================================

    part def CommandArbitrationSoftware {
        doc
        /* Realizes requestAcquisitionFunctions' per-channel translation
         * (raw dry-contact signal -> typed ControlCommand, for BOTH the
         * local and remote channels) and its first-wins arbitration
         * sub-behavior, plus the UP+DOWN conflict-detection portion of
         * controlLogicFunctions (both require simultaneous visibility of
         * the local and remote channels, so both are co-located here).
         * Loosely allocated from LogicalLocalRequestInterface,
         * LogicalRemoteRequestInterface, and LogicalControlUnit (ADR-007) --
         * NOT strongly coupled, since this single firmware module realizes
         * behavior split across three Logical components.
         */

        // First-wins arbitration/debounce-coincidence window: a channel
        // asserting a valid command more than this many milliseconds before
        // the other channel wins outright; concurrent assertions within the
        // window and requesting opposite directions raise a UP+DOWN
        // conflict. Commits the concrete value LogicalControlUnit's
        // 'commandArbitrationPolicy' attribute explicitly deferred to
        // Product Architecture.
        attribute arbitrationWindowMs : Real = 50.0;

        attribute wiringMode : WiringMode = WiringMode::momentary;

        attribute estimatedFlashBytes : Natural = 1200;
        attribute estimatedRamBytes : Natural = 48;

        port localRawIn : ~DryContactControlPort;
        port remoteRawIn : ~DryContactControlPort;
        // Arbitrated, conflict-resolved ControlCommand. Fanned out (2 flows,
        // see ControlMCU body) to MovementControlSoftware (normal command
        // processing) and ConfigurationManagerSoftware (mode-trigger
        // detection tap), mirroring the fan-out pattern already established
        // by logicalControlUnit.requestOut in LogicalArchitecture.sysml.
        port commandOut : ControlCommandPort;
        // Relays the same arbitrated command onward to
        // MovementSupervisorSoftware AND DiagnosticsSoftware (PA-1 fix,
        // 2 flows), mirroring LogicalControlUnit.commandRelayOut.
        port commandRelayOut : ControlCommandPort;
    }

    part def MovementControlSoftware {
        doc
        /* Realizes the remainder of controlLogicFunctions: consumes the
         * arbitrated, conflict-resolved ControlCommand and produces the
         * validated MovementRequest consumed by motor-drive and
         * movement-supervision firmware. Loosely allocated from
         * LogicalControlUnit (ADR-007).
         */

        // PA-9 fix: illustrative firmware resource estimate (see
        // ControlMCU's rollup doc note).
        attribute estimatedFlashBytes : Natural = 400;
        attribute estimatedRamBytes : Natural = 16;

        port commandIn : ~ControlCommandPort;
        // Fanned out (2 flows) to MotorDriveControlSoftware and
        // MovementSupervisorSoftware, mirroring
        // logicalControlUnit.requestOut's fan-out in LogicalArchitecture.sysml.
        port requestOut : MovementRequestPort;
    }

    part def ConfigurationManagerSoftware {
        doc
        /* Realizes configurationControlFunctions: detects the
         * configuration-mode entry/exit gesture (a sustained simultaneous
         * UP+DOWN assertion held beyond the calibration threshold -- the
         * same dual-channel condition CommandArbitrationSoftware observes
         * for conflict detection, distinguished purely by hold duration) and
         * emits the corresponding ConfigModeEvent (REQ-F-08). Loosely
         * allocated from LogicalControlUnit (ADR-007).
         */

        // Minimum simultaneous UP+DOWN hold duration, in seconds,
        // distinguishing a configuration-mode entry/exit gesture from a
        // transient conflict. Commits the concrete value LogicalControlUnit
        // left as a qualitative placeholder.
        attribute calibrationHoldThresholdS : Real = 3.0;

        // Default 'momentary' reflects the more
        // common residential push-button wall-switch topology; the
        // installer can select 'latching' for toggle-switch installations.
        attribute wiringMode : WiringMode = WiringMode::momentary;

        attribute estimatedFlashBytes : Natural = 700;
        attribute estimatedRamBytes : Natural = 24;

        port commandIn : ~ControlCommandPort;
        port modeEventOut : ConfigModeEventPort;
    }

    part def MemoryManagerSoftware {
        doc
        /* Realizes memoryFunctions: persists the measured TravelTime
         * (openTime/closeTime, REQ-F-07) to the MCU's internal EEPROM during
         * calibration (UC_03, SaveCountedTime) and retrieves it at runtime to
         * supply MovementSupervisorSoftware's timeout. Loosely allocated
         * from LogicalControlUnit (ADR-007). Storage medium is the
         * ControlMCU's own internal EEPROM (ADR-006) -- no discrete external
         * memory component is required.
         */

        attribute storageMedium : String =
            "ControlMCU internal EEPROM (emulated or native), no external memory IC required (ADR-006)";

        // PA-6 fix (RISK-T-01_PositioningDrift mitigation, model_issues.md
        // item 18): additional margin applied on top of the measured
        // open/close travel time before MovementSupervisorSoftware's
        // timeout expires, compensating for cumulative timing drift in this
        // no-position-feedback design. Concretizes RISK-T-01's mitigation
        // text ("+5s margin on open/close timeout"), previously
        // documentation-only with no structural counterpart.
        attribute timingMarginS : Real = 5.0;

        // CRIT-4 fix (SMRR corrective pass): minimal producer signal for
        // SystemStates::TimingProfileReadFailure (see doc above). Reflects
        // whether the most recent EEPROM TravelTime read (LoadTimingProfile)
        // returned a valid, previously-saved record; false on first power-on
        // before any calibration, or on a corrupted record.
        attribute lastReadValid : Boolean = true;

        // PA-9 fix: illustrative firmware resource estimate (see
        // ControlMCU's rollup doc note).
        attribute estimatedFlashBytes : Natural = 900;
        attribute estimatedRamBytes : Natural = 32;

        port durationIn : ~TravelTimePort;
        port timingOut : TravelTimePort;
    }

    part def MovementSupervisorSoftware :> LogicalMovementSupervisor {
        doc
        /* Firmware realization of movementSupervisionFunctions and
         * timeCountingFunctions: timer-based supervision of in-progress
         * shutter movement (automatic timeout-driven end-of-travel and
         * manual hold-to-run release/timeout, ADR-003 -- no position
         * feedback) and elapsed travel-time measurement during
         * configuration-mode calibration. Strongly coupled to
         * LogicalMovementSupervisor (ADR-007): identical scope and identical
         * port set, an unambiguous 1:1 realization.
         */

        // Software timer tick resolution used for both the automatic-mode
        // end-of-travel timeout and the manual-mode hold-to-run safety
        // timeout. Commits the concrete value LogicalMovementSupervisor's
        // 'supervisionPrinciple' attribute left as a qualitative placeholder.
        attribute timerResolutionMs : Real = 10.0;

        attribute estimatedFlashBytes : Natural = 1000;
        attribute estimatedRamBytes : Natural = 40;
    }

    part def MotorDriveControlSoftware {
        doc
        /* Firmware half of LogicalMotorDrive's realization: decides motor
         * energize/de-energize direction in response to validated
         * MovementRequest and StopRequest, drives the low-voltage relay
         * coil-control signals, and self-reports the resulting ShutterState
         * (no external position sensor is consulted, ADR-003 -- the state
         * reported is the state MotorDriveControlSoftware itself just
         * commanded). The mains-side switching itself is realized by the
         * companion hardware component, MotorDriveRelayModule. Loosely
         * allocated from LogicalMotorDrive (ADR-007).
         */

        port requestIn : ~MovementRequestPort;
        port stopIn : ~StopRequestPort;
        port shutterStateOut : ShutterStatePort;
        port relayOut : RelayControlPort;

        // PA-9 fix: illustrative firmware resource estimate (see
        // ControlMCU's rollup doc note).
        attribute estimatedFlashBytes : Natural = 600;
        attribute estimatedRamBytes : Natural = 24;
    }

    part def UserFeedbackSoftware {
        doc
        /* Firmware half of LogicalUserNotification's realization: dispatches
         * audible user feedback for configuration-mode transitions
         * (REQ-F-08), simultaneous UP+DOWN conflict indication (REQ-S-02),
         * and (PA-1 fix) DiagnosticsSoftware's fault classification
         * (REQ-Q-04) as software-generated GPIO beep patterns on an active
         * buzzer. All three event sources are arbitrated/time-multiplexed
         * onto the single physical buzzer via buzzerOut — no new hardware
         * is added. Loosely allocated from LogicalUserNotification (ADR-007).
         * LED indicator replaced by buzzer per ADR-008.
         *
         * MAJ-9 fix (SMRR corrective pass): the beep patterns below commit
         * concrete, measurable pulse-count/duration values for each event
         * source, replacing the previously qualitative "clearly
         * distinguishable" pass criterion used by TC_F_013/TC_S_004/TC_Q_004
         * with an objective acoustic threshold each test case can check with
         * a stopwatch/count, while preserving the same test intent (each
         * event source must remain audibly distinct from the others). No new
         * hardware or notification channel is introduced -- these are
         * concrete values for the existing buzzerOut GPIO drive pattern.
         */

        attribute feedbackTechnology : String =
            "Active buzzer (self-oscillating, 3.3V logic-level drive, single GPIO), software-generated beep patterns (ADR-008). Commits the concrete technology LogicalUserNotification's 'feedbackModality' attribute left as a qualitative placeholder.";

        // MAJ-9 fix: measurable beep-pattern specification, one attribute
        // per event source, each expressed as (pulse count, pulse duration).
        // Distinguishability is by pulse COUNT first (1 vs. 2 vs. 3 pulses),
        // an unambiguous, easily verified acoustic signal.
        attribute configModeActivationBeepCount : Natural = 1; // REQ-F-08 activation: single short beep
        attribute configModeActivationBeepMs : Natural = 200;
        attribute configModeDeactivationBeepCount : Natural = 2; // REQ-F-08 deactivation: double short beep
        attribute configModeDeactivationBeepMs : Natural = 200;
        attribute configModeBeepGapMs : Natural = 150; // silence between pulses within a pattern
        attribute conflictSuppressionBeepCount : Natural = 3; // REQ-S-02: triple short beep (distinct pulse count from both config-mode patterns)
        attribute conflictSuppressionBeepMs : Natural = 100;
        attribute faultNoResponseBeepCount : Natural = 1; // REQ-Q-04 noResponseToControlInput: single LONG beep
        attribute faultNoResponseBeepMs : Natural = 600;
        attribute faultMotorDriveBeepCount : Natural = 2; // REQ-Q-04 motorDriveFault: double LONG beep
        attribute faultMotorDriveBeepMs : Natural = 600;

        port modeEventIn : ~ConfigModeEventPort;
        // PA-1 fix: consumes DiagnosticsSoftware's fault classification and
        // arbitrates a distinct beep pattern (e.g., a fault-specific
        // short/long beep code) on the same shared buzzer used for
        // configuration-mode and conflict feedback.
        port faultIndicationIn : ~FaultIndicationPort;
        port buzzerOut : BuzzerControlPort;

        // PA-9 fix: illustrative firmware resource estimate (see
        // ControlMCU's rollup doc note).
        attribute estimatedFlashBytes : Natural = 800;
        attribute estimatedRamBytes : Natural = 32;
    }

    part def DiagnosticsSoftware :> LogicalDiagnostics {
        doc
        /* Firmware realization of diagnosticsFunctions: classifies the
         * controller's operating state into the field-diagnosable fault
         * classes required by REQ-Q-04, observable without specialized lab
         * equipment (REQ-Q-05):
         *   - "No power": requires NO software/port involvement at all --
         *     inherently, passively observable by the technician as
         *     "buzzer silent at startup / no power-on acknowledgment beep"
         *     (ADR-008: buzzer replaced the LED; see doc note on
         *     AudibleNotificationBuzzer/PowerSupplyModule). Not classified
         *     by this component; listed here only for completeness against
         *     REQ-Q-04's three named fault classes.
         *   - "No response to any control input": commandStateIn (new PA-1
         *     tap on CommandArbitrationSoftware.commandRelayOut) reports no
         *     arbitrated command observed despite a technician-asserted test
         *     input.
         *   - "Motor-drive fault": commandStateIn confirms a command WAS
         *     received and arbitrated, but diagnosticStateIn (the
         *     pre-existing, inherited ShutterState tap) reports no
         *     resulting movement.
         * The classification result is emitted on faultOut
         * (ProductInterfaces::FaultIndicationPort) to UserFeedbackSoftware,
         * which arbitrates a distinct buzzer beep pattern on the existing
         * shared audible buzzer (PA-1 fix, model_issues.md item 18 /
         * productArchitectureRepairPlan.md PA-1) -- this replaces the
         * previous "behavior remains underspecified" placeholder inherited
         * verbatim from LogicalDiagnostics, which remains correctly, and
         * intentionally, underspecified AT THAT LAYER (a legitimate SYSMOD
         * deferral, not a defect there -- Product Architecture is the last
         * technology-committing layer and is where this concretization
         * belongs). Strongly coupled to LogicalDiagnostics (ADR-007): same
         * scope, additively extended interface -- the original
         * diagnosticStateIn tap is unchanged; only new ports were added.
         */

        port commandStateIn : ~ControlCommandPort;
        port faultOut : FaultIndicationPort;

        attribute estimatedFlashBytes : Natural = 700;
        attribute estimatedRamBytes : Natural = 24;
    }

    // =========================================================================
    // Hardware / Electrical / Mechanical Components
    // =========================================================================

    part def RequestInterfaceCircuit {
        doc
        /* Shared electrical circuit type performing ONLY raw dry-contact
         * signal conditioning: opto-isolation (satisfies
         * L0_Constraints::Electrical::inputIsolation), RC debounce, and
         * 3.3V logic-level shifting of the external UP/DOWN dry-contact
         * signal pair.
         * Instantiated TWICE in the top-level Product composite
         * (localRequestInterface, remoteRequestInterface) rather than
         * declared as two near-duplicate types -- this directly GUARANTEES
         * REQ-I-02 ("electrically and behaviorally equivalent") by
         * construction, improving on the Logical layer's necessarily
         * distinct LogicalLocalRequestInterface/LogicalRemoteRequestInterface
         * types (ADR-007). ControlCommand INTERPRETATION (direction/mode
         * inference) is deliberately NOT performed here -- it is realized by
         * CommandArbitrationSoftware, which already inspects both channels
         * for arbitration and is the natural place to decode them without
         * duplicating interpretation logic per channel. Loosely allocated
         * from LogicalLocalRequestInterface / LogicalRemoteRequestInterface
         * (ADR-007).
         */

        attribute isolationTechnology : String =
            "Opto-isolator per channel, galvanically isolating the external dry-contact loop from the 3.3V logic domain";
        attribute debounceTimeConstantMs : Real = 20.0;
        attribute unitCostPLN : Real = 1.5;

        port ctrlIn : ~DryContactControlPort;
        // Conditioned (isolated, debounced, level-shifted) signal, reusing
        // DryContactControlPort's identical two-line (up/down) shape rather
        // than introducing a parallel port type for the same signal
        // topology -- the conditioning changes the signal's electrical
        // domain, not its logical shape.
        port digitalOut : DryContactControlPort;
        port powerIn : ~LogicPowerRailPort;
    }

    part def ControlMCU {
        doc
        /* Single shared low-cost 8-bit microcontroller (ADR-006) hosting all
         * eight firmware components. Realizes (hosts) LogicalControlUnit,
         * LogicalMotorDrive, LogicalUserNotification,
         * LogicalMovementSupervisor, and LogicalDiagnostics -- a many-to-one
         * hosting relationship modeled via allocation, not specialization
         * (ADR-007), since no single Logical component maps 1:1 to this
         * hardware element.
         */

        attribute mcuFamily : String = "Ultra-low-cost 8-bit MCU, STM8S003F3P6-class";
        attribute packageType : String = "TSSOP-20";
        attribute gpioCount : Natural = 14;
        attribute flashSizeKB : Natural = 16;
        attribute internalEepromBytes : Natural = 128;
        // PA-9 fix: STM8S003F3P6-class RAM capacity, needed to check the
        // hosted firmware modules' aggregate 'estimatedRamBytes' against an
        // actual budget (previously no RAM attribute existed at all).
        attribute internalRamBytes : Natural = 1024;
        attribute clockSpeedMHz : Natural = 16;
        attribute unitCostPLN : Real = 2.0;

        attribute mtbfHours : Real = 500000.0;

        port localRawIn : ~DryContactControlPort;
        port remoteRawIn : ~DryContactControlPort;
        port relayOut : RelayControlPort;
        port buzzerOut : BuzzerControlPort;
        port powerIn : ~LogicPowerRailPort;
        // Production-only in-circuit programming/debug interface (ADR-006).
        // Deliberately left unconnected to any other Product component in
        // normal operation -- a documented, intentional gap mirroring the
        // LogicalArchitecture controlPower/mainsPower boundary-port pattern
        // (see LogicalArchitecture.sysml note 'C4 fix').
        port progPort : ProgrammingPort;

        // ── Firmware components ─────────────────────────────────────────────
        part commandArbitrationSoftware : CommandArbitrationSoftware;
        part movementControlSoftware : MovementControlSoftware;
        part configurationManagerSoftware : ConfigurationManagerSoftware;
        part memoryManagerSoftware : MemoryManagerSoftware;
        part movementSupervisorSoftware : MovementSupervisorSoftware;
        part motorDriveControlSoftware : MotorDriveControlSoftware;
        part userFeedbackSoftware : UserFeedbackSoftware;
        part diagnosticsSoftware : DiagnosticsSoftware;

        // ── Boundary delegations ─────────────────────────────────────────────
        connect localRawIn to commandArbitrationSoftware.localRawIn;
        connect remoteRawIn to commandArbitrationSoftware.remoteRawIn;
        connect motorDriveControlSoftware.relayOut to relayOut;
        connect userFeedbackSoftware.buzzerOut to buzzerOut;
        // powerIn/progPort: no internal connection modeled -- power reaches
        // every firmware component implicitly via the shared MCU die (not a
        // discrete software-level port); progPort is production-only (see
        // doc above).

        // ── Internal firmware-to-firmware connections ───────────────────────
        // 1. CommandArbitrationSoftware -> MovementControlSoftware [ControlCommand]
        flow : ControlCommandFlow
            from commandArbitrationSoftware.commandOut to movementControlSoftware.commandIn;

        // 2. CommandArbitrationSoftware -> ConfigurationManagerSoftware [ControlCommand]
        // Fan-out leg 2 of 2 (mode-trigger detection tap).
        flow : ControlCommandFlow
            from commandArbitrationSoftware.commandOut to configurationManagerSoftware.commandIn;

        // 3. CommandArbitrationSoftware -> MovementSupervisorSoftware [ControlCommand relay]
        // Fan-out leg 1 of 2 (PA-1 fix added leg 2 -> DiagnosticsSoftware, see connection 13).
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
        // Fan-out leg 1 of 2.
        flow : ShutterStateFlow
            from motorDriveControlSoftware.shutterStateOut
            to movementSupervisorSoftware.shutterStateIn;

        // 9. MotorDriveControlSoftware -> DiagnosticsSoftware [ShutterState, passive tap]
        // Fan-out leg 2 of 2.
        flow : ShutterStateFlow
            from motorDriveControlSoftware.shutterStateOut to diagnosticsSoftware.diagnosticStateIn;

        // 10. MovementSupervisorSoftware -> MemoryManagerSoftware [TravelTime]
        flow : TravelTimeFlow
            from movementSupervisorSoftware.durationOut to memoryManagerSoftware.durationIn;

        // 11. MemoryManagerSoftware -> MovementSupervisorSoftware [TravelTime]
        flow : TravelTimeFlow
            from memoryManagerSoftware.timingOut to movementSupervisorSoftware.timingIn;

        // 12. ConfigurationManagerSoftware -> UserFeedbackSoftware [ConfigModeEvent]
        flow : ConfigModeEventFlow
            from configurationManagerSoftware.modeEventOut to userFeedbackSoftware.modeEventIn;

        // ── PA-1 fix connections (Diagnostics dead-end closure) ─────────────
        // 13. CommandArbitrationSoftware -> DiagnosticsSoftware [ControlCommand relay]
        // Fan-out leg 2 of 2 (see connection 3): gives DiagnosticsSoftware
        // command-visibility, needed to distinguish "no response to any
        // control input" from "motor-drive fault" (both otherwise look
        // identical to the pre-existing diagnosticStateIn-only tap).
        flow : ControlCommandFlow
            from commandArbitrationSoftware.commandRelayOut to diagnosticsSoftware.commandStateIn;

        // 14. DiagnosticsSoftware -> UserFeedbackSoftware [FaultIndication]
        // Carries DiagnosticsSoftware's fault classification result to be
        // arbitrated onto the shared buzzer alongside configuration-
        // mode/conflict feedback (closes the Diagnostics dead-end: this is
        // the first, and only, DiagnosticsSoftware OUTPUT connection).
        flow : FaultIndicationFlow
            from diagnosticsSoftware.faultOut to userFeedbackSoftware.faultIndicationIn;
    }

    part def MotorDriveRelayModule {
        doc
        /* Hardware half of LogicalMotorDrive's realization: a relay-based
         * (ADR-001, reaffirmed ADR-006) motor switching module. Its coil is
         * driven at low voltage by MotorDriveControlSoftware; its contacts
         * switch mains power (up to 8A/230VAC, L0_Constraints::Electrical::
         * switchingLoad) onward to the shutter motor via ShutterDrivePort.
         * Provides the galvanic isolation between the low-voltage control
         * domain and the mains-switching domain required by
         * L0_Constraints::Electrical::motorIsolation. Loosely allocated from
         * LogicalMotorDrive (ADR-007).
         */

        attribute relaySwitchingCurrentA : Real = 8.0;
        attribute relaySwitchingVoltageV : Real = 230.0;
        attribute contactConfiguration : String =
            "Two SPDT relays (UP/DOWN), interlocked to prevent simultaneous energization";
        attribute unitCostPLN : Real = 3.5;

        // PA-3 fix (RISK-T-03_MotorRelayWearOut mitigation, REQ-Q-03):
        // minimum switching-cycle rating the sourced relay/triac component
        // must meet; directly concretizes RISK-T-03's mitigation text
        // ("rated for at least 10,000 switching cycles") and REQ-Q-03's
        // 'successfulOperations >= 10000' constraint as an explicit,
        // checkable Product-layer attribute rather than free text only.
        attribute ratedCycleCount : Natural = 10000;
        // PA-3 fix (ADR-002 availability rationale, REQ-Q-02): illustrative
        // MTBF estimate for this component class; to be refined once a
        // specific relay/triac part is sourced. ADR-002 commits the 99.8%
        // availability target to component-selection MTBF ratings rather
        // than a behavioral sub-system -- this attribute gives that
        // commitment an explicit, in-model target.
        attribute mtbfHours : Real = 100000.0;

        port coilIn : ~RelayControlPort;
        port coilPowerIn : ~LogicPowerRailPort;
        port mainsIn : ~MainsPowerPort;
        port driveOut : ShutterDrivePort;
    }

    part def AudibleNotificationBuzzer {
        doc
        /* Hardware half of LogicalUserNotification's realization: a passive
         * piezo or electromagnetic buzzer, driven directly by
         * UserFeedbackSoftware via a single GPIO on BuzzerControlPort
         * (ADR-008, supersedes ADR-006 point (6)). Loosely allocated from
         * LogicalUserNotification (ADR-007).
         *
         * REQ-Q-04 "no power" fault class: when the controller has no
         * control power, the buzzer emits no startup confirmation beep --
         * a passive acoustic consequence of powerIn having no supply,
         * requiring NO software/port involvement and NO DiagnosticsSoftware
         * classification. This startup-silence is the field-observable
         * acoustic signature of the "no power" fault class REQ-Q-04 names;
         * the other two named fault classes ARE actively classified by
         * DiagnosticsSoftware (see its doc) and reported via distinct beep
         * patterns emitted by this buzzer.
         */

        attribute buzzerType : String =
            "Active (self-oscillating) buzzer, 3.3V logic-level drive, single MCU GPIO (ADR-008)";
        attribute unitCostPLN : Real = 0.5;

        port driveIn : ~BuzzerControlPort;
        port powerIn : ~LogicPowerRailPort;
    }

    part def PowerSupplyModule :> BaseArchitecture::PowerModule {
        doc
        /* Converts the 12VDC±10% control power input
         * (L0_Constraints::Electrical::supplyVoltage) to the regulated 3.3V
         * logic rail distributed to every logic-level Product component.
         * Strongly coupled to BaseArchitecture::PowerModule (ADR-007) -- the
         * first architecture layer at which PowerModule reappears, since it
         * has no Logical Architecture counterpart (ADR-004: no Functional
         * Element performs power conversion/distribution behavior). Realizes
         * the "anticipated future ownership" note in LogicalArchitecture.sysml.
         *
         * EVENT OWNERSHIP (CRIT-4 fix, SMRR corrective pass): this component
         * is the explicit architectural producer of SystemStates::PowerLost
         * and SystemStates::PowerRestored, closing the "no architectural
         * producer" finding. Ownership rationale: PowerSupplyModule is the
         * SOLE component whose input (controlPowerIn) directly reflects the
         * presence/absence of the 12VDC control supply -- it is the only
         * physically correct place in the architecture for this event to
         * originate. supplyPresent is the minimal structural signal that
         * makes this ownership explicit: a false->true edge is the physical
         * event source for PowerRestored; a true->false edge is the physical
         * event source for PowerLost. This is a passive, minimal producer
         * model (an observable state attribute on the existing component),
         * NOT a new self-healing/watchdog/failover behavior -- ADR-002's
         * explicit "no self-healing architecture is planned" scope is
         * unchanged. Routed cross-machine-safe via SystemStates::
         * crossLifecycleEventRelay exactly as before; only the producer's
         * identity was previously undocumented.
         */

        attribute regulatorTopology : String =
            "Linear (LDO) regulator, 12V -> 3.3V, adequate for this product's low aggregate logic-level current draw";
        attribute unitCostPLN : Real = 1.5;

        // PA-3 fix (ADR-002 availability rationale, REQ-Q-02): illustrative
        // MTBF estimate for this component class; to be refined once a
        // specific regulator part is sourced. Linear regulators are a
        // well-understood, high-MTBF component class relative to the
        // relay/motor-drive path.
        attribute mtbfHours : Real = 200000.0;

        // CRIT-4 fix (SMRR corrective pass): minimal producer signal for
        // SystemStates::PowerLost/PowerRestored (see doc above). Reflects
        // whether controlPowerIn currently has a valid 12VDC supply present;
        // a transition of this attribute IS the PowerLost/PowerRestored
        // event, physically originating from this component.
        attribute supplyPresent : Boolean = true;

        port controlPowerIn : ~ControlPowerPort;
        // Fanned out (4 connects, see ProductArchitecture.sysml) to
        // ControlMCU, both RequestInterfaceCircuit instances,
        // AudibleNotificationBuzzer, and MotorDriveRelayModule's coil-driver
        // stage.
        port logicRailOut : LogicPowerRailPort;
    }

    part def EnclosureAndConnectors {
        doc
        /* Mechanical housing and wiring connectors. Has NO Logical or Base
         * Architecture counterpart at any earlier layer -- a genuinely new
         * Product-layer element introduced to satisfy physical/mechanical
         * constraints that have no structural representation at any earlier
         * architecture layer (ADR-007), traced directly to
         * L0_Constraints::Physical::compactDimensions,
         * L0_Constraints::Environmental::operatingConditions, REQ-Q-01
         * (easeOfInstallation), and REQ-Q-05 (fieldReplaceability) rather
         * than through a Logical intermediate.
         *
         * PA-7 fix (model_issues.md item 18): width/length/height are set
         * BELOW L0_Constraints::Physical::compactDimensions' 40x40x20mm
         * ceiling (rather than exactly at it), creating genuine fabrication/
         * assembly tolerance margin -- a value sitting exactly at a hard
         * constraint boundary provides no protection against ordinary
         * manufacturing variance. (compactDimensions' own width/length/height
         * attributes remain a separate, unbound requirement-layer declaration
         * -- see Constraints.sysml -- a pre-existing gap outside this
         * repair's scope; this fix only concretizes the Product-layer value
         * these dimensions are checked against by inspection/review.)
         */

        attribute width subsets ISQ::length = 38 [SI::mm];
        attribute length subsets ISQ::length = 38 [SI::mm];
        attribute height subsets ISQ::length = 18 [SI::mm];
        attribute mountingType : String =
            "Flush-mounted ⌀60mm wall box, compatible with standard residential wall-switch installations (REQ-Q-01)";
        attribute connectorType : String =
            "Screw-terminal blocks for all external wiring (wall switch, remote, control power, mains, motor) -- no soldering required for field replacement (REQ-Q-05)";
        attribute unitCostPLN : Real = 4.0;
    }
} // package ProductComponents
