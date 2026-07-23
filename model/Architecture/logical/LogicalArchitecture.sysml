package LogicalArchitecture {
    // Import only the abstract root, NOT the wildcard: SystemArchitecture_Taxonomy
    // also declares a same-named abstract header 'LogicalArchitecture' (see
    // that file's own header comment), which collides with this enclosing
    // package's own name if wildcard-imported, breaking name resolution
    // throughout this file (Syside reference-error fix: WallSwitchInterface,
    // ControlCommandPort, String, etc. all failed to resolve because of this
    // self-name collision).
    //
    // TRACEABILITY RULE 2 DEVIATION (reviewed and accepted, formal Logical
    // Architecture review, this pass): logical-architecture.md §4 Traceability
    // Rule 2 states every logical part def MUST specialize PhysicalArchitecture
    // "directly or transitively via LogicalSystem" -- i.e., via the
    // intermediate 'SystemArchitecture_Taxonomy::LogicalArchitecture' header
    // declared in that file. RollerShutterControllerLogicalComponents instead
    // specializes the abstract root 'SystemArchitecture' directly (see its
    // ':> SystemArchitecture' declaration below), for the same tooling-driven
    // reason as this import: wildcard- or qualified-importing the same-named
    // intermediate header into this identically-named enclosing package would
    // reintroduce the self-name collision described above. SM-PRD-17 taxonomy
    // membership is still preserved -- 'SystemArchitecture' is the common
    // ancestor of every concrete architecture layer -- just one level higher
    // in the hierarchy than the Rule 2 wording anticipates. This deviation is
    // intentional, cosmetic (does not affect allocation, traceability, or
    // structural correctness), and applies identically to BaseArchitecture
    // and FunctionalArchitecture's own top-level composites for the same
    // reason.
    private import SystemArchitecture_Taxonomy::SystemArchitecture;
    private import FunctionalArchitecture::*;
    private import BaseArchitecture::*;
    private import DomainKnowledge::*;
    private import SystemContext::*;
    private import ScalarValues::String;

    /* The Logical Architecture (SM-PRD-20) provides a technology-independent
     * structural realization of the Functional Architecture (SM-PRD-18),
     * identifying logical components, their responsibilities, interfaces, and
     * interactions -- without committing to specific hardware, software,
     * protocols, or vendors (SYSMOD Tool 4.18).
     *
     * COUPLING STRATEGY (SYSMOD Tool 11.7, see ADR_004_LogicalCoupling):
     *   - Functional → Logical: LOOSE coupling via 'allocation def' (see
     *     LogicalArchitecture::FunctionalAllocation.sysml). This is a fixed
     *     SYSMOD rule, not a project choice -- no Logical part def specializes
     *     a Functional Element part def.
     *   - Logical → Base: STRONG coupling (':>') for the four Logical
     *     components with an unambiguous 1:1 Base Architecture counterpart
     *     (LogicalControlUnit, LogicalMotorDrive, LogicalLocalRequestInterface,
     *     LogicalRemoteRequestInterface). BaseArchitecture::PowerModule has NO
     *     Logical counterpart (no Functional Element performs power
     *     conversion/distribution behavior -- see ADR_004). Two Logical
     *     components (LogicalMovementSupervisor, LogicalUserNotification) and
     *     one stub (LogicalDiagnostics) have no Base Architecture precedent and
     *     are modeled as plain 'part def'.
     *
     * PORT-DEF REUSE DECISION: internal logical-to-logical interfaces reuse
     * FunctionalArchitecture's port defs (ControlCommandPort,
     * MovementRequestPort, StopRequestPort, ShutterStatePort, TravelTimePort,
     * TimingProfilePort, ConfigModeEventPort) directly, since these already
     * wrap the technology-independent DomainKnowledge (SM-PRD-15) flow/item
     * types and introducing a parallel, identically-shaped set of Logical-only
     * port defs would violate DRY without adding information. New port defs
     * are introduced in this file ONLY for the outermost system boundary,
     * where the Logical Architecture performs the signal-abstraction step that
     * FunctionalArchitecture.sysml explicitly deferred ("Physical signal
     * mapping (dry-contact signals → ControlCommand) is deferred to Logical
     * Architecture (SM-PRD-20) via port delegation/binding" -- see
     * FunctionalArchitecture.sysml boundary port comment). Those boundary
     * ports are typed by SystemContext's existing port defs
     * (DryContactControlPort, ControlPowerPort, MainsPowerPort,
     * ShutterDrivePort), giving the Logical composite full external-interface
     * parity with SystemContext::SystemContextDiagram::shutterController
     * (Traceability Rule 3 / modeling procedure step 5).
     *
     * requestAcquisitionFunctions ALLOCATION SPLIT: the single FA-level
     * requestAcquisitionFunctions Functional Element is realized by TWO
     * logical components (LogicalLocalRequestInterface,
     * LogicalRemoteRequestInterface) for the physical-signal-to-ControlCommand
     * TRANSLATION sub-behavior (one per physical channel, matching Base
     * Architecture's existing WallSwitchInterface/RemoteInterface split), while
     * the first-wins ARBITRATION/merge sub-behavior (the fork+merge nodes
     * inside UseCaseActivities::ReceiveControlRequest) is allocated to
     * LogicalControlUnit, since arbitration inherently requires simultaneous
     * visibility of both channels and cannot be performed by either interface
     * component in isolation. See FunctionalAllocation.sysml for the full
     * rationale and the Function Allocation Matrix in the accompanying
     * analysis report. NOTE: this 1-FE-to-3-component split is an explicit,
     * documented EXCEPTION to the default one-FE-to-one-logical-component
     * allocation cardinality (KnowledgeSource/integration/crossmapping/
     * logical-architecture.md §4 Traceability Rule 1); it is not a modeling
     * error, and no other Functional Element in this file deviates from the
     * default 1:1 cardinality.
     *
     * BOUNDARY-PORT PARITY NOTE (FA↔LA asymmetry): FunctionalArchitecture's
     * composite additionally exposes 'shutterOutput : ShutterStatePort' at its
     * system boundary (closing FA finding F1). This is intentionally NOT
     * re-exposed as a Logical Architecture boundary port: ShutterState has no
     * corresponding external actor in SystemContext (System Context's
     * shutterController never exposes shutter-position/movement state
     * externally) and remains an internal-only signal, consumed here by
     * logicalMovementSupervisor (see connection 9 below) and, for
     * observability, by logicalDiagnostics. Likewise, shutterControlFunctions'
     * FA-level 'MotorStatePort'/'MotorStateFlow' output has no direct Logical
     * boundary counterpart: LogicalMotorDrive performs the MotorState →
     * ShutterDrivePort abstraction internally (energizing/de-energizing the
     * physical relay circuit), exposing only the resulting ShutterDrivePort at
     * the Logical/System boundary, consistent with DomainKnowledge::
     * MotorStateFlow's own doc anticipating this Logical-layer realization.
     *
     * LogicalControlUnit CONCENTRATION: LogicalControlUnit aggregates four of
     * the nine Functional Elements (requestAcquisitionFunctions' arbitration
     * sub-behavior, controlLogicFunctions, configurationControlFunctions,
     * memoryFunctions) -- the highest allocation concentration of any Logical
     * component in this file. Each grouping is individually justified in
     * FunctionalAllocation.sysml as a cohesive control-plane responsibility,
     * and it mirrors Base Architecture's own broad ControlUnit scope, so this
     * is not treated as a defect here. It is flagged for explicit
     * reconsideration during Product Architecture (SM-PRD-21) -- e.g. whether
     * non-volatile persistence (memoryFunctions) should become a distinct
     * product-level driver for improved testability/replaceability, even if
     * it remains logically grouped in this component.
     *
     * FIRM PRODUCT-ARCHITECTURE FOLLOW-UP (formal Logical Architecture review,
     * this pass -- upgrades the note above from an optional suggestion to a
     * required re-check): this same concentration also makes
     * LogicalControlUnit the de facto architectural bottleneck of the whole
     * composite -- it is the only component connected to four of the other
     * six Logical components (both request interfaces, the movement
     * supervisor via the requestOut/commandRelayOut fan-outs, and the motor
     * drive via requestOut), and it is the sole Logical-layer trace target
     * for REQ-Q-02 (availability) and REQ-Q-03 (reliability) -- see
     * Traceability::Traceability. Any future change to this component
     * therefore has the widest blast radius in the architecture and directly
     * affects the two mandatory quality requirements with the least
     * structural redundancy behind them. Product Architecture (SM-PRD-21)
     * MUST explicitly re-evaluate whether to split LogicalControlUnit's four
     * FEs (at minimum, memoryFunctions and/or configurationControlFunctions)
     * into separately replaceable product components before finalizing the
     * product-level design -- this is no longer optional stretch-goal
     * language, it is a required design-review checkpoint.
     */

    // =========================================================================
    // Logical-only port definitions
    // Introduced ONLY for the outermost boundary (System Context parity).
    // Internal logical-to-logical ports reuse FunctionalArchitecture's port
    // defs directly (see header comment above).
    // =========================================================================

    doc /* No additional port defs are declared in this package: the outer
         * boundary reuses SystemContext::DryContactControlPort,
         * SystemContext::ControlPowerPort, SystemContext::MainsPowerPort, and
         * SystemContext::ShutterDrivePort; internal interfaces reuse
         * FunctionalArchitecture's port defs. This avoids introducing any new
         * technology-specific interface type at the Logical layer. */

    // =========================================================================
    // Logical Components
    // =========================================================================
    // NOTE (per-channel duplication, C7): LogicalLocalRequestInterface and
    // LogicalRemoteRequestInterface intentionally duplicate an identical
    // 'signalInterpretation' attribute and ctrlIn/commandOut port pair. This
    // is a deliberate structural symmetry -- REQ-I-02 requires the remote
    // channel to be "electrically and behaviorally equivalent" to the local
    // channel -- not an accidental copy-paste; the two components are kept
    // distinct (rather than factored into a shared supertype) because they
    // strongly couple to two separate, independently-existing Base
    // Architecture parts (WallSwitchInterface, RemoteInterface, ADR-004).

    part def LogicalLocalRequestInterface :> WallSwitchInterface {
        doc
        /* Translates the raw dry-contact signal state on the local wall-switch
         * channel into a typed ControlCommand. Realizes the local-channel
         * translation sub-behavior of requestAcquisitionFunctions. Strongly
         * coupled to BaseArchitecture::WallSwitchInterface (1:1 Base
         * counterpart, ADR-004). */

        attribute signalInterpretation : String {
            doc /* Qualitative description of how the dry-contact voltage
                 * state is mapped to direction/mode (e.g., press-duration
                 * heuristics for automatic vs. manual mode); no concrete
                 * algorithm or timing value is committed here -- deferred to
                 * Product Architecture. */
        }

        port ctrlIn     : ~DryContactControlPort;
        port commandOut : ControlCommandPort;
    }

    part def LogicalRemoteRequestInterface :> RemoteInterface {
        doc
        /* Translates the raw dry-contact signal state on the remote
         * (home-automation) channel into a typed ControlCommand. Realizes the
         * remote-channel translation sub-behavior of
         * requestAcquisitionFunctions. Strongly coupled to
         * BaseArchitecture::RemoteInterface (1:1 Base counterpart, ADR-004). */

        attribute signalInterpretation : String {
            doc /* Qualitative description of how the remote dry-contact
                 * voltage state is mapped to direction/mode; electrically and
                 * behaviorally equivalent to LogicalLocalRequestInterface per
                 * REQ-I-02. */
        }

        port ctrlIn     : ~DryContactControlPort;
        port commandOut : ControlCommandPort;
    }

    part def LogicalControlUnit :> ControlUnit {
        doc
        /* Arbitrates between simultaneous local/remote command channels
         * (first-wins), validates the resulting ControlCommand and detects
         * UP+DOWN conflicts, manages configuration-mode state transitions, and
         * persists/retrieves the timing profile. Realizes
         * controlLogicFunctions, configurationControlFunctions,
         * memoryFunctions, and the arbitration sub-behavior of
         * requestAcquisitionFunctions. Strongly coupled to
         * BaseArchitecture::ControlUnit (1:1 Base counterpart, ADR-004). */

        attribute commandArbitrationPolicy : String {
            doc /* Qualitative description of the first-wins arbitration
                 * policy between local and remote channels; no concrete
                 * timing value is committed here -- deferred to Product
                 * Architecture. */
        }

        port localCommandIn  : ~ControlCommandPort;
        port remoteCommandIn : ~ControlCommandPort;
        port requestOut      : MovementRequestPort;
        port modeEventOut    : ConfigModeEventPort;
        port durationIn      : ~TravelTimePort;
        port timingOut       : TimingProfilePort;
        // commandRelayOut (Logical Architecture review CRITICAL-1 fix, see
        // model_issues.md): relays the arbitrated ControlCommand (whichever of
        // localCommandIn/remoteCommandIn won first-wins arbitration) onward to
        // LogicalMovementSupervisor, giving MonitorStopCondition.
        // listenForStopCommand / MonitorUserInterruption.listenForRelease a
        // realized trigger source at the Logical layer. Arbitration visibility
        // of both channels is exclusive to this component (see class doc
        // above), so LogicalControlUnit is the only correct source for this
        // relay -- neither request-interface component nor
        // LogicalMovementSupervisor itself has the necessary visibility.
        port commandRelayOut : ControlCommandPort;
        // conflictOut (system model review corrective pass, closes Major
        // finding M2, see model_issues.md): raises the ConflictEvent detected
        // during ControlCommand validation (UP+DOWN conflict) to
        // LogicalUserNotification, mirroring the existing modeEventOut
        // pattern above.
        port conflictOut     : ConflictEventPort;
    }

    part def LogicalMovementSupervisor {
        doc
        /* Timer-based supervision of in-progress shutter movement (automatic
         * timeout-driven end-of-travel and manual hold-to-run release/timeout,
         * per ADR-003 -- no position feedback), and elapsed travel-time
         * measurement during configuration-mode calibration. Realizes
         * movementSupervisionFunctions and timeCountingFunctions. No Base
         * Architecture counterpart exists (ADR-004); modeled as a plain
         * logical component introduced by Functional Architecture analysis. */

        attribute supervisionPrinciple : String {
            doc /* Qualitative description of the timer-based
                 * (non-position-sensing) supervision principle mandated by
                 * ADR-003; no concrete timeout value is committed here --
                 * deferred to Product Architecture. */
        }

        // commandIn (Logical Architecture review CRITICAL-1 fix, see
        // model_issues.md): receives the arbitrated ControlCommand relay from
        // LogicalControlUnit.commandRelayOut (connection 6b below), realizing
        // the trigger source for the stop/release accept actions described on
        // LogicalControlUnit.commandRelayOut.
        port commandIn      : ~ControlCommandPort;
        port requestIn      : ~MovementRequestPort;
        port timingIn       : ~TimingProfilePort;
        port stopOut        : StopRequestPort;
        port shutterStateIn : ~ShutterStatePort;
        port durationOut    : TravelTimePort;
    }

    part def LogicalMotorDrive :> MotorDriver {
        doc
        /* Energizes/de-energizes the shutter motor relay circuit in the
         * commanded direction in response to validated movement and stop
         * requests, and exposes the resulting drive state at the system
         * boundary. Realizes shutterControlFunctions. Strongly coupled to
         * BaseArchitecture::MotorDriver (1:1 Base counterpart, ADR-004). */

        attribute driveSwitchingPrinciple : String {
            doc /* Qualitative description of the motor-switching principle
                 * (e.g., relay-based, per ADR-001 cost constraint); no
                 * concrete component selection is committed here -- deferred
                 * to Product Architecture. */
        }

        port requestIn       : ~MovementRequestPort;
        port stopIn          : ~StopRequestPort;
        port shutterStateOut : ShutterStatePort;
        port driveOut        : ShutterDrivePort;
    }

    part def LogicalUserNotification {
        doc
        /* Delivers user-visible feedback for configuration-mode transitions
         * (activation and deactivation), dispatched from the typed
         * ConfigModeEvent received from LogicalControlUnit. Realizes
         * userNotificationFunctions. No Base Architecture counterpart exists
         * (ADR-004); FunctionalArchitecture.sysml explicitly calls this out as
         * "decoupled from control logic to allow independent Logical
         * Architecture realization (e.g., LED, buzzer, or display
         * indicator)". */

        attribute feedbackModality : String {
            doc /* Qualitative description of the user-feedback channel
                 * (visual, audible, or combined); no concrete indicator
                 * technology is committed here -- deferred to Product
                 * Architecture. */
        }

        port modeEventIn : ~ConfigModeEventPort;
        // conflictEventIn (system model review corrective pass, closes Major
        // finding M2, see model_issues.md): receives the ConflictEvent from
        // LogicalControlUnit.conflictOut, realizing REQ-S-02
        // (conflictIndication) so a suppressed simultaneous UP+DOWN command
        // is surfaced as an observable user indication.
        port conflictEventIn : ~ConflictEventPort;
        // faultEventIn (CRIT-2 fix, SMRR corrective pass): receives the
        // FaultIndicationEvent from LogicalDiagnostics.faultEventOut,
        // restoring the missing Logical-layer precursor of
        // ProductComponents::UserFeedbackSoftware.faultIndicationIn.
        port faultEventIn : ~FaultIndicationEventPort;
    }

    part def LogicalDiagnostics {
        doc
        /* Diagnoses and supports field repair of a failed or malfunctioning
         * controller without modifying existing installation wiring. Realizes
         * diagnosticsFunctions. No Base Architecture counterpart exists
         * (ADR-004). Behavior is currently underspecified, mirroring the same
         * underspecification already documented on
         * FunctionalArchitecture::RollerShutterControllerFunctions::
         * diagnosticsFunctions pending a dedicated UC_04 elaboration pass --
         * introduced here to provide an allocation anchor for Product
         * Architecture and to keep every FA action def covered by exactly one
         * Logical component (Traceability Rule 1).
         *
         * INTERFACE (C3 fix, formal Logical Architecture review; extended by
         * the CRIT-1/CRIT-2 SMRR corrective pass): a passive, read-only
         * diagnosticStateIn port taps the existing ShutterState signal
         * already produced by logicalMotorDrive (see connection 13 below) --
         * no new DomainKnowledge item/port type was introduced for that tap.
         * CRIT-1/CRIT-2 additionally mirror the new FunctionalArchitecture::
         * diagnosticsFunctions ports one-to-one at this layer: a diagnostic-
         * request input, a diagnostic-result output, and a fault-event
         * output routed to LogicalUserNotification (connection 14 below),
         * closing the previously-missing Logical-layer precursor of
         * ProductComponents::DiagnosticsSoftware.faultOut. The concrete
         * diagnostic procedure and fault classes covered remain TBD pending
         * UC_04 elaboration -- only the interface definition is closed here,
         * per SMRR CRIT-1 instruction ("do not redesign responsibilities"). */

        attribute diagnosticCoverage : String {
            doc /* Qualitative placeholder for the eventual diagnostic
                 * coverage (e.g., which fault classes are detectable); no
                 * concrete diagnostic procedure is committed here. */
        }

        port diagnosticStateIn   : ~ShutterStatePort;
        port diagnosticRequestIn : ~DiagnosticRequestPort;
        port diagnosticResultOut : DiagnosticResultPort;
        port faultEventOut       : FaultIndicationEventPort;
    }


    // =========================================================================
    // Composite Logical Architecture
    // =========================================================================

    part def RollerShutterControllerLogicalComponents :> SystemArchitecture {
        doc
        /* Top-level Logical Architecture of the Window Roller Shutter
         * Controller. Technology-independent structural realization of
         * FunctionalArchitecture::RollerShutterControllerFunctions (see
         * FunctionalAllocation.sysml for the complete Function-to-Component
         * allocation). Boundary ports mirror
         * SystemContext::SystemContextDiagram::shutterController exactly (Traceability
         * Rule 3 / modeling procedure step 5), giving full external-interface
         * parity with the System Context. */

        // ── System boundary ports (mirrors SystemContext::shutterController) ──
        port localCtrl    : ~DryContactControlPort;
        port remoteCtrl   : ~DryContactControlPort;
        port controlPower : ~ControlPowerPort;
        port mainsPower   : ~MainsPowerPort;
        port shutterDrive : ShutterDrivePort;

        // ── Logical Components ──────────────────────────────────────────────
        part logicalLocalRequestInterface  : LogicalLocalRequestInterface;
        part logicalRemoteRequestInterface : LogicalRemoteRequestInterface;
        part logicalControlUnit            : LogicalControlUnit;
        part logicalMovementSupervisor     : LogicalMovementSupervisor;
        part logicalMotorDrive             : LogicalMotorDrive;
        part logicalUserNotification       : LogicalUserNotification;
        part logicalDiagnostics            : LogicalDiagnostics;

        // ── Boundary delegations ────────────────────────────────────────────
        // 1. System boundary → LogicalLocalRequestInterface  [port delegation]
        connect localCtrl to logicalLocalRequestInterface.ctrlIn;

        // 2. System boundary → LogicalRemoteRequestInterface  [port delegation]
        connect remoteCtrl to logicalRemoteRequestInterface.ctrlIn;

        // NOTE (C4 fix, formal Logical Architecture review): controlPower and
        // mainsPower are represented at the Logical Architecture boundary for
        // full System Context parity (Traceability Rule 3) but have NO
        // internal logical-component connection: power distribution is a
        // Product/Physical Architecture concern with no corresponding
        // Functional Element (BaseArchitecture::PowerModule has no Logical
        // counterpart -- see ADR_004_LogicalCoupling). This is a documented,
        // intentional gap, not an omission. Anticipated future ownership
        // (informative only, to be confirmed at Product Architecture,
        // SM-PRD-21): controlPower (low-voltage logic supply) is expected to
        // power all seven Logical components; mainsPower (230V AC) is
        // expected to be routed only to logicalMotorDrive, which alone
        // switches it onward via shutterDrive.

        // 3. shutterDrive boundary ← LogicalMotorDrive  [port delegation]
        connect logicalMotorDrive.driveOut to shutterDrive;

        // ── Inter-component connections ─────────────────────────────────────
        // 4. LogicalLocalRequestInterface → LogicalControlUnit  [ControlCommand]
        flow : ControlCommandFlow
            from logicalLocalRequestInterface.commandOut to logicalControlUnit.localCommandIn;

        // 5. LogicalRemoteRequestInterface → LogicalControlUnit  [ControlCommand]
        flow : ControlCommandFlow
            from logicalRemoteRequestInterface.commandOut to logicalControlUnit.remoteCommandIn;

        // 5b. LogicalControlUnit → LogicalMovementSupervisor  [ControlCommand relay]
        // (Logical Architecture review CRITICAL-1 fix, see model_issues.md):
        // relays the arbitrated ControlCommand so LogicalMovementSupervisor can
        // realize the stop/release accept-action trigger source described on
        // LogicalControlUnit.commandRelayOut and LogicalMovementSupervisor.commandIn.
        flow : ControlCommandFlow
            from logicalControlUnit.commandRelayOut to logicalMovementSupervisor.commandIn;

        // 6. LogicalControlUnit → LogicalMovementSupervisor  [MovementRequest]
        // Fan-out leg 1 of 2 (mirrors FA connections 3/4 -- one source port,
        // two independent concurrent consumers; see FunctionalArchitecture.sysml
        // F10 note).
        flow : MovementRequestFlow
            from logicalControlUnit.requestOut to logicalMovementSupervisor.requestIn;

        // 7. LogicalControlUnit → LogicalMotorDrive  [MovementRequest]
        // Fan-out leg 2 of 2.
        flow : MovementRequestFlow
            from logicalControlUnit.requestOut to logicalMotorDrive.requestIn;

        // 8. LogicalMovementSupervisor → LogicalMotorDrive  [StopRequest]
        flow : StopRequestFlow
            from logicalMovementSupervisor.stopOut to logicalMotorDrive.stopIn;

        // 9. LogicalMotorDrive → LogicalMovementSupervisor  [ShutterState, UC_03 only]
        flow : ShutterStateFlow
            from logicalMotorDrive.shutterStateOut to logicalMovementSupervisor.shutterStateIn;

        // 10. LogicalMovementSupervisor → LogicalControlUnit  [TravelTime]
        flow : TravelTimeFlow
            from logicalMovementSupervisor.durationOut to logicalControlUnit.durationIn;

        // 11. LogicalControlUnit → LogicalMovementSupervisor  [TimingProfile, runtime timeout]
        flow : TimingProfileFlow
            from logicalControlUnit.timingOut to logicalMovementSupervisor.timingIn;

        // 12. LogicalControlUnit → LogicalUserNotification  [ConfigModeEvent]
        flow : ConfigModeEventFlow
            from logicalControlUnit.modeEventOut to logicalUserNotification.modeEventIn;

        // 12b. LogicalControlUnit → LogicalUserNotification  [ConflictEvent]
        // Closes Major finding M2 (system model review corrective pass, see
        // model_issues.md). Mirrors connection 12 above.
        flow : ConflictEventFlow
            from logicalControlUnit.conflictOut to logicalUserNotification.conflictEventIn;

        // 13. LogicalMotorDrive → LogicalDiagnostics  [ShutterState, passive tap]
        // (C3 fix: gives logicalDiagnostics its only interface -- a read-only
        // observation of shutter movement state, fanning out from the same
        // source as connection 9. See LogicalDiagnostics doc for scope.)
        flow : ShutterStateFlow
            from logicalMotorDrive.shutterStateOut to logicalDiagnostics.diagnosticStateIn;

        // 14. LogicalDiagnostics → LogicalUserNotification  [FaultIndicationEvent]
        // (CRIT-2 fix, SMRR corrective pass): restores the missing Logical-
        // layer precursor of ProductComponents::DiagnosticsSoftware.faultOut →
        // UserFeedbackSoftware.faultIndicationIn (ControlMCU connection 14),
        // which previously had no counterpart at this layer. Mirrors
        // connection 12b exactly -- typed port-to-port flow between two
        // existing Logical components, no new component introduced. Note:
        // diagnosticRequestIn/diagnosticResultOut (mirroring
        // FunctionalArchitecture::diagnosticsFunctions' new boundary ports)
        // are intentionally left unconnected at this layer, consistent with
        // the existing controlPower/mainsPower "documented, intentional gap"
        // pattern above (connection 2 NOTE) -- no System Context boundary
        // port exists yet for technician-triggered field diagnosis, so the
        // request/result interface remains a defined-but-unwired boundary
        // stub pending a dedicated UC_04 elaboration pass, exactly like
        // ControlMCU.progPort's documented "no internal connection" pattern
        // one layer down.
        flow : FaultIndicationEventFlow
            from logicalDiagnostics.faultEventOut to logicalUserNotification.faultEventIn;
    }

    /* Package-level usage providing a named feature endpoint for traceability
     * links (SysML v2 connection ends must reference features, not classifiers). */
    part rollerShutterControllerLogicalComponents : RollerShutterControllerLogicalComponents;
} // package LogicalArchitecture
