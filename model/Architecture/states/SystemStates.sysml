/* System States (SM-PRD-23) -- Controller Lifecycle and Diagnostic State
 * Model.
 *
 * Describes the behavioral states of the ShutterController (top-level
 * lifecycle) and of LogicalDiagnostics (component-level fault-handling
 * lifecycle), derived strictly from already-validated model elements:
 * Requirements (SM-PRD-10), Use Cases (SM-PRD-12), Use Case Activities
 * (SM-PRD-14, UseCaseActivities.sysml), Logical Architecture (SM-PRD-20),
 * Product Architecture (SM-PRD-21), and Scenarios (SM-PRD-22). No new
 * functionality is invented: every state's entry/do/exit action references
 * an existing action def; every transition's trigger event either reuses an
 * existing DomainKnowledge/ProductInterfaces item/enum type directly, or is
 * a minimal new 'attribute def' explicitly classified below as either a
 * documented-trigger formalization (mirrors an existing UseCaseMeta.trigger
 * string verbatim) or a gap-derived placeholder (mirrors an existing
 * Scenarios.sysml '// GAP:' comment -- structural placeholder only, not an
 * invented resolution).
 *
 * Two state machines, per KnowledgeSource/integration/crossmapping/
 * system-states.md's own two-tier worked example:
 *   1. Top-level 'systemLifecycle' (ControllerLifecycleState), exhibited on
 *      a new part def specializing LogicalArchitecture::
 *      RollerShutterControllerLogicalComponents.
 *   2. Component-level 'diagnosticLifecycle' (DiagnosticState), exhibited on
 *      a new part def specializing LogicalArchitecture::LogicalDiagnostics.
 * Both new part defs use ':>' specialization (the same non-invasive-
 * extension pattern ProductComponents.sysml already uses, e.g.
 * 'MovementSupervisorSoftware :> LogicalMovementSupervisor'), so no existing
 * validated file is modified.
 *
 * Kept at the Logical Architecture layer (technology-independent), per the
 * user's explicit instruction that the State Model "shall remain
 * technology-independent where possible".
 *
 * Traceability Rules applied throughout (crossmapping/system-states.md §4):
 *  1. Every state def is exhibited on a Logical Architecture part def.
 *  2. Every Use Case Activity referenced below is cited by its exact name.
 *  3. Every transition has a named trigger event (no guard-only transitions),
 *     EXCEPT completion transitions (SysML v2 'then <target>;' with no
 *     'accept', triggered implicitly by completion of the source state's
 *     own entry/do action rather than an external event) -- used exactly
 *     once below, on ConflictSuppressed, where it is the most accurate
 *     representation because no external event ends that state.
 *  4. Every reachable non-terminal state has >= 1 outgoing transition;
 *     terminal states (InstallationFault, Disposed) are explicitly marked.
 *  5. Safety-relevant states (ConflictSuppressed) trace to REQ-S-01/REQ-S-02.
 *  6. Deterministic: guards sharing a trigger are mutually exclusive
 *     (verified per-state in the doc comments below).
 *
 * State Model Review corrective pass (formal SysMod State Model Review,
 * findings MAJOR-1/MAJOR-2/MAJOR-3) -- additive only, no state removed or
 * renamed, no scenario mapping broken:
 *  MAJOR-1: Idle's two competing triggers on the shared UP+DOWN gesture
 *     (ControlCommand[direction==none] vs. ConfigModeEvent[activated])
 *     raced with no timing discriminator. Fixed by introducing
 *     'AssessingSimultaneousHold' between Idle and {ConflictSuppressed,
 *     ConfigurationMode}, using ProductComponents::
 *     ConfigurationManagerSoftware.calibrationHoldThresholdS (3.0s,
 *     mirrored by doc reference, not re-imported -- this file remains
 *     Logical-layer/technology-independent) as the discriminator.
 *  MAJOR-2: cross-state-machine event delivery between 'systemLifecycle'
 *     and 'diagnosticLifecycle' was undefined (bare 'accept' defaults its
 *     receiver to "the containing part" -- accept-action.md -- which is
 *     structurally meaningless when producer and consumer sit on
 *     different, unconnected parts). Fixed additively via 'part def
 *     CrossLifecycleEventRelay' (explicit event-routing element, Option B)
 *     and explicit 'via crossLifecycleEventRelay' clauses on every accept
 *     of the five affected event types (FaultReported,
 *     TimingProfileReadFailure, ConfigModeEvent, PowerLost, PowerRestored).
 *  MAJOR-3: two transitions used non-canonical grammar (an extra 'then'
 *     preceding 'do action'). Rewritten to the canonical order documented
 *     in KnowledgeSource/sysml2/concepts/transition.md ('accept ... do
 *     action ...; then Target;', no 'then' before 'do action'); semantics
 *     unchanged.
 * SR-7 (invalid calibration rejection) is CLOSED (MAJ-8 fix, SMRR
 *     corrective pass): UseCaseActivities::ConfigureController's
 *     do-action now includes an explicit out-of-range guard
 *     (checkOpenTimeInRange/checkCloseTimeInRange +
 *     openRangeGuard/closeRangeGuard), executed inside ConfigurationMode's
 *     existing 'do action configureController' -- see ConfigurationMode's
 *     doc below. SR-8 (wiring-mode mismatch) remains an OPEN gap by
 *     explicit instruction -- not addressed by this pass, not silently
 *     closed; see ConflictSuppressed's doc, and Traceability.sysml's
 *     scen23 comment.
 */
package SystemStates {
    private import LogicalArchitecture::*;
    private import UseCaseActivities::*;
    private import DomainKnowledge::*;
    private import ProductInterfaces::*;
    private import SI::*;
    // SI added by the State Model Review corrective pass (MAJOR-1) solely to
    // express AssessingSimultaneousHold's 'accept after' literal duration
    // ([SI::s]), mirroring Requirements.sysml's own '<= 120 [SI::s]' precedent.
    // ProductComponents.sysml itself remains unimported: this file stays at
    // the Logical Architecture layer (technology-independent).

    // =========================================================================
    // Trigger events
    // =========================================================================

    // ---- Documented-trigger formalizations ---------------------------------
    // Mirror an existing UseCaseMeta.trigger string (UseCases.sysml) or an
    // existing UCActivities.sysml decision-branch outcome verbatim; no new
    // behavior is introduced, only a typed event for the already-documented
    // trigger/outcome.

    attribute def BeginInstallation {
        doc
        /* Documented-trigger formalization of UC_02_InstallController's
         * trigger ("Installer begins physical installation of the
         * controller", UseCases.sysml). No payload -- the trigger carries
         * no data at the Use Case layer. */
    }

    attribute def InstallationVerified {
        doc
        /* Documented-trigger formalization of UseCaseActivities::
         * InstallController's happy-path/retry-success outcome
         * (verifyWorking.success == true OR retryVerifyWorking.success ==
         * true), both leading to assembleWallswitch -- UC_02's
         * postcondition ("controller connected and verified working"). */
    }

    attribute def InstallationFaultReported {
        doc
        /* Documented-trigger formalization of UseCaseActivities::
         * InstallController's terminal branch (retryVerifyWorking.success
         * == false -> reportInstallationFault). */
    }

    attribute def RepairCommenced {
        doc
        /* Documented-trigger formalization of the sequential transition
         * from UseCaseActivities::DiagnoseAndRepairController's
         * isolateFault to repairOrReplaceUnit: the maintenance technician
         * begins on-site repair/replacement (REQ-Q-05) after the fault has
         * been isolated. */
    }

    attribute def RepairVerified {
        doc
        /* Documented-trigger formalization of UC_04_DiagnoseAndRepairController's
         * postcondition ("controller diagnosed; faulty unit repaired or
         * replaced; normal operation restored"). */
    }

    attribute def DecommissionRequest {
        doc
        /* Documented-trigger formalization of UC_05_DisposeController's
         * trigger ("Controller retired at end of life", UseCases.sysml). */
    }

    attribute def FaultReported {
        doc
        /* Documented-trigger formalization of UC_04_DiagnoseAndRepairController's
         * trigger ("Reported shutter malfunction (no movement, wrong
         * direction, or intermittent operation)", UseCases.sysml). */
    }

    // ---- Gap-derived placeholders -------------------------------------------
    // Each mirrors an existing Scenarios.sysml '// GAP:' comment verbatim in
    // its doc. These are STRUCTURAL PLACEHOLDERS only: no component in the
    // validated model today actually raises these signals. Recorded per
    // Traceability Rule 3 / the user's "do not invent functionality"
    // instruction -- NOT a proposed fix for the underlying gap.

    attribute def PowerLost {
        doc
        /* GAP-derived (Scenarios::SCEN_15_PowerLoss_DuringMovement): "no
         * UseCaseActivities action, Logical component, or Product firmware
         * component observes, logs, or reacts to a controlPower
         * interruption" (ADR_002_Availability's explicit scope: no
         * self-healing, failover, or watchdog architecture is planned).
         * This event was previously a pure structural placeholder for the
         * electrically passive relay de-energization SCEN_15 describes.
         *
         * Ownership (CRIT-4 fix, SMRR corrective pass -- supersedes the
         * State Model Review's original "Producer = none" note below):
         * Producer = ProductComponents::PowerSupplyModule, the sole
         * component whose controlPowerIn directly reflects the 12VDC
         * control supply's presence/absence (see PowerSupplyModule.
         * supplyPresent). A true->false transition of supplyPresent IS this
         * event, physically originating from PowerSupplyModule. This closes
         * the "no architectural producer" finding without introducing any
         * new self-healing/failover/watchdog behavior -- ADR-002's explicit
         * scope is unchanged; only the existing, always-true physical fact
         * (the supply either has voltage or it doesn't) is now named and
         * owned by the component that observes it.
         * Consumer = systemLifecycle's Idle, MovingAutomatic, MovingManual,
         * ConfigurationMode (all -> Unpowered). Routed cross-machine-safe
         * via CrossLifecycleEventRelay (MAJOR-2) even though today's only
         * consumers sit within systemLifecycle itself, for routing
         * uniformity and future-proofing should a diagnosticLifecycle
         * consumer be added. */
    }

    attribute def PowerRestored {
        doc
        /* GAP-derived (Scenarios::SCEN_16_PowerRecovery_AfterOutage): pairs
         * with PowerLost. "Firmware boot/re-init itself is not represented
         * as a named action anywhere in the model."
         *
         * Ownership (CRIT-4 fix, SMRR corrective pass -- supersedes the
         * State Model Review's original "Producer = none" note below):
         * Producer = ProductComponents::PowerSupplyModule (see PowerLost's
         * doc above for the shared rationale): a false->true transition of
         * PowerSupplyModule.supplyPresent IS this event. Consumer =
         * systemLifecycle's Unpowered (-> Idle, via loadTimingProfile).
         * Routed via CrossLifecycleEventRelay (MAJOR-2). */
    }

    attribute def TimingProfileReadFailure {
        doc
        /* GAP-derived (Scenarios::SCEN_24_TimingProfile_PersistenceFailure_
         * FirstPowerOn, SR-9): "UseCaseActivities::LoadTimingProfile has no
         * explicit default-value or fault-signaling behavior for a
         * missing/invalid EEPROM read."
         *
         * Ownership (CRIT-4 fix, SMRR corrective pass -- supersedes the
         * State Model Review's original "Producer = GAP-derived placeholder"
         * note below): Producer = ProductComponents::MemoryManagerSoftware,
         * the sole component that performs the EEPROM TimingProfile read
         * (LoadTimingProfile). A read yielding MemoryManagerSoftware.
         * lastReadValid == false IS this event, physically originating from
         * that component's EEPROM read path (first power-on before any
         * calibration, or a corrupted record). This closes the "no
         * architectural producer" finding without inventing a new fallback
         * or recovery behavior -- only the existing read outcome is now
         * named and owned by the component that performs the read.
         * Consumer = diagnosticLifecycle::Nominal (-> ConfigurationRequiredFault)
         * -- a genuine cross-state-machine delivery (systemLifecycle's
         * LoadTimingProfile action site to diagnosticLifecycle), routed
         * via CrossLifecycleEventRelay (MAJOR-2). */
    }


    // =========================================================================
    // State def taxonomy -- top-level controller lifecycle (SM-PRD-23)
    // =========================================================================

    state def ControllerLifecycleState {
        doc
        /* Root state for the ShutterController's operational lifecycle.
         * Mirrors SystemProcesses::ControllerLifecycle's authoritative
         * ordering (install -> configure -> operate, looped), refined here
         * into individually observable states and events. */
    }
    state def UninstalledState        :> ControllerLifecycleState;
    state def InstallingState         :> ControllerLifecycleState;
    state def InstallationFaultState  :> ControllerLifecycleState;
    state def IdleState               :> ControllerLifecycleState;
    state def AssessingSimultaneousHoldState :> ControllerLifecycleState;
    // Added by the State Model Review corrective pass (MAJOR-1): the explicit
    // discriminator state resolving the Idle race between ConflictSuppressed
    // and ConfigurationMode (see AssessingSimultaneousHold's own doc below).
    state def MovingAutomaticState    :> ControllerLifecycleState;
    state def MovingManualState       :> ControllerLifecycleState;
    state def ConflictSuppressedState :> ControllerLifecycleState;
    state def ConfigurationModeState  :> ControllerLifecycleState;
    state def UnpoweredState          :> ControllerLifecycleState;
    state def DisposedState           :> ControllerLifecycleState;

    // =========================================================================
    // State def taxonomy -- component-level diagnostics (LogicalDiagnostics)
    // =========================================================================

    state def DiagnosticState {
        doc
        /* Root state for LogicalDiagnostics' fault-classification and
         * repair lifecycle. Realizes REQ-Q-04 (diagnosability) and REQ-Q-05
         * (fieldReplaceability) as an observable state machine. */
    }
    state def NominalState                    :> DiagnosticState;
    state def ClassifyingFaultState           :> DiagnosticState;
    state def NoResponseFaultState            :> DiagnosticState;
    state def MotorDriveFaultState            :> DiagnosticState;
    state def ConfigurationRequiredFaultState :> DiagnosticState;
    state def RepairingState                  :> DiagnosticState;

    // =========================================================================
    // Cross-state-machine event relay (State Model Review corrective pass,
    // MAJOR-2) -- explicit event-routing element (Option B).
    // =========================================================================

    part def CrossLifecycleEventRelay {
        doc
        /* Closes Major finding MAJOR-2: 'systemLifecycle' (exhibited on
         * RollerShutterControllerWithLifecycle) and 'diagnosticLifecycle'
         * (exhibited on LogicalDiagnosticsWithState) are two independent,
         * unconnected state machines (per LogicalArchitecture: no port or
         * connection joins RollerShutterControllerLogicalComponents and
         * LogicalDiagnostics for these five signals). A bare 'accept X;'
         * defaults its receiver to "the containing part"
         * (accept-action.md) -- structurally meaningless across that
         * boundary. This part def is an explicit, additive event-routing
         * element (Option B: "explicit event relay element"), referenced by
         * every affected 'accept ... via crossLifecycleEventRelay;' clause
         * below. It does NOT redesign LogicalArchitecture or Product
         * Architecture, and introduces no new behavior/action -- it only
         * makes existing, previously-implicit event delivery observable
         * and verifiable, per the Review's explicit instruction ("keep the
         * two state machines independent, but make event delivery
         * explicit").
         *
         * Per-event ownership/producer/consumer documentation (all five
         * events routed by this relay):
         *
         * - FaultReported: Owner/producer = the fault-reporting path
         *   realizing UC_04_DiagnoseAndRepairController's trigger (see this
         *   attribute def's own doc above); today this is a documented
         *   trigger with no explicit Logical/Product component named as
         *   the originating signal source (recorded gap, not invented
         *   here). Consumer = diagnosticLifecycle::Nominal (-> 
         *   ClassifyingFault).
         *
         * - TimingProfileReadFailure: Owner/producer (CRIT-4 fix, SMRR
         *   corrective pass) = ProductComponents::MemoryManagerSoftware,
         *   the sole component performing the EEPROM TimingProfile read
         *   (LoadTimingProfile); a read yielding lastReadValid == false IS
         *   this event (see this attribute def's own doc above -- now
         *   resolved by an explicit producer, superseding the prior
         *   "GAP-derived placeholder" note). Consumer =
         *   diagnosticLifecycle::Nominal (-> ConfigurationRequiredFault).
         *
         * - ConfigModeEvent: Owner/producer = systemLifecycle's
         *   ConfigurationMode state (realizing UseCaseActivities::
         *   ActivateConfigurationMode / ExitConfigurationMode, produced by
         *   LogicalArchitecture::LogicalControlUnit per
         *   Scenarios::SCEN_13 s3/s8). Consumer (cross-machine) =
         *   diagnosticLifecycle::ConfigurationRequiredFault (kind ==
         *   deactivated only -- the reentry-guard use of this same event
         *   type, entirely inside systemLifecycle's own ConfigurationMode
         *   self-transition, is NOT cross-machine and does not use this
         *   relay).
         *
         * - PowerLost: Owner/producer (CRIT-4 fix, SMRR corrective pass) =
         *   ProductComponents::PowerSupplyModule, the sole component whose
         *   controlPowerIn directly reflects the 12VDC control supply's
         *   presence/absence; a true->false transition of
         *   PowerSupplyModule.supplyPresent IS this event (see this
         *   attribute def's own doc above -- now resolved by an explicit
         *   producer, superseding the prior "Producer = none" note).
         *   Consumer (cross-machine) = systemLifecycle's Idle/
         *   MovingAutomatic/MovingManual/ConfigurationMode (-> Unpowered).
         *
         * - PowerRestored: Owner/producer (CRIT-4 fix, SMRR corrective pass)
         *   = ProductComponents::PowerSupplyModule (see PowerLost above); a
         *   false->true transition of supplyPresent IS this event (see this
         *   attribute def's own doc above -- now resolved by an explicit
         *   producer). Consumer = systemLifecycle's Unpowered (-> Idle).
         *
         * Verifiability: every transition listed above now has an explicit,
         * named receiver ('via crossLifecycleEventRelay') instead of a
         * defaulted, structurally-meaningless one, so black-box/white-box
         * test harnesses can target a single, well-known routing point when
         * injecting or observing these five events (Phase 13 Verification
         * Readiness). CRIT-4 (SMRR corrective pass) additionally closes the
         * "no architectural producer" finding for PowerLost, PowerRestored,
         * and TimingProfileReadFailure: each now has an explicit, named
         * Product-layer producer (PowerSupplyModule.supplyPresent;
         * MemoryManagerSoftware.lastReadValid) making the affected
         * transitions testable (a test harness can force
         * supplyPresent/lastReadValid to the failing value and observe the
         * resulting state transition), without introducing any new
         * self-healing/failover/watchdog/recovery behavior -- ADR-002's
         * explicit "no such architecture is planned" scope remains
         * unchanged; only the pre-existing physical/data fact each producer
         * already holds is now named and owned. FaultReported remains a
         * documented gap with no named producer (out of CRIT-4's scope; SR-7/
         * SR-8 remain open for that event only). */
    }

    /* Package-level usage providing the single, named routing endpoint
     * referenced by every 'via crossLifecycleEventRelay' accept clause
     * below (mirrors the existing package-level part usage pattern used
     * for rollerShutterControllerWithLifecycle / logicalDiagnosticsWithState). */
    part crossLifecycleEventRelay : CrossLifecycleEventRelay;

    // =========================================================================
    // Top-level state machine -- exhibited on a new part def specializing
    // LogicalArchitecture::RollerShutterControllerLogicalComponents.
    // =========================================================================

    part def RollerShutterControllerWithLifecycle :> RollerShutterControllerLogicalComponents {
        doc
        /* Additive specialization (no existing file modified) giving the
         * validated Logical Architecture composite an exhibited lifecycle
         * state machine. Mirrors ProductComponents.sysml's own established
         * strong-coupling pattern (e.g. 'DiagnosticsSoftware :>
         * LogicalDiagnostics') for non-invasive extension. */

        exhibit state systemLifecycle : ControllerLifecycleState {

            entry; then Uninstalled;

            state Uninstalled : UninstalledState {
                doc
                /* Purpose: pre-installation state; the controller has not
                 * yet been physically installed. Entry: initial pseudostate
                 * (system model instantiation). Exit: BeginInstallation.
                 * Requirements: UC_02_InstallController precondition
                 * ("Power supply to the shutter circuit isolated/off").
                 * Components: none allocated yet (pre-installation). */
                accept BeginInstallation then Installing;
            }

            state Installing : InstallingState {
                doc
                /* Purpose: realizes UC_02_InstallController end to end
                 * (turnOffPowerSupplyForShutters -> disassembleWallswitch ->
                 * connectController -> verifyWorking -> assembleWallswitch,
                 * with the bounded single retry -- retryConnectController /
                 * retryVerifyWorking -- modeled inside InstallController
                 * itself, not as separate top-level states, per "prefer
                 * simple and deterministic state structures"). Entry:
                 * BeginInstallation (from Uninstalled). Exit:
                 * InstallationVerified (-> Idle) or
                 * InstallationFaultReported (-> InstallationFault).
                 * Requirements: REQ-Q-01 (easeOfInstallation).
                 * Components: Installer (Stakeholders); every Logical
                 * component (being wired for the first time). */
                entry action installController : InstallController;
                accept InstallationVerified      then Idle;
                accept InstallationFaultReported then InstallationFault;
            }

            state InstallationFault : InstallationFaultState {
                doc
                /* Purpose: terminal fault state realizing
                 * UseCaseActivities::ReportInstallationFault -- a second
                 * consecutive wiring/power-supply verification attempt
                 * still failed; repair is out of scope for the controller
                 * itself and requires external intervention (SCEN_12).
                 * Entry: InstallationFaultReported. Exit: NONE -- this is a
                 * TERMINAL state (Traceability Rule 4 exception, explicitly
                 * documented). Requirements: REQ-Q-01 (bounded-retry safety
                 * net). Components: Installer; external repair party
                 * (out of controller scope). */
                entry action reportInstallationFault : ReportInstallationFault;
            }

            state Idle : IdleState {
                doc
                /* Purpose: controller powered, installed, and at rest --
                 * awaiting the next command, configuration request, power
                 * event, or decommission request. Entry: InstallationVerified
                 * (from Installing), StopRequest (from MovingAutomatic/
                 * MovingManual), completion of ConflictSuppressed,
                 * ConfigModeEvent[deactivated] (from ConfigurationMode), or
                 * PowerRestored (from Unpowered). Exit: see transitions
                 * below. Requirements: UC_01_ControlRollerShutter
                 * precondition ("Controller powered from control and mains
                 * supply; no conflicting simultaneous UP+DOWN signal
                 * active"). Components: LogicalArchitecture::
                 * LogicalLocalRequestInterface/LogicalRemoteRequestInterface
                 * (awaiting the next acquireControlRequest).
                 *
                 * Determinism (Rule 6): the 'accept ControlCommand' guards
                 * below partition exhaustively and mutually exclusively on
                 * (direction==none) vs. (mode==automatic & direction!=none)
                 * vs. (mode==manual & direction!=none), mirroring
                 * UseCaseActivities::DetermineMovementRequest's own
                 * suppressMovement/passThrough decide.
                 *
                 * State Model Review corrective pass (MAJOR-1): Idle
                 * previously had a SECOND, directly competing trigger here
                 * -- 'accept ConfigModeEvent[activated] then
                 * ConfigurationMode' -- racing against the
                 * ControlCommand[direction==none] transition below with no
                 * timing discriminator, even though both are raised by the
                 * SAME physical simultaneous UP+DOWN gesture (arbitration's
                 * immediate direction:=none suppression vs.
                 * ConfigurationManagerSoftware's later, hold-threshold-gated
                 * activation). That direct ConfigModeEvent[activated]
                 * trigger is REMOVED from Idle; ControlCommand[direction==
                 * none] now leads to the new explicit discriminator state
                 * AssessingSimultaneousHold (not directly to
                 * ConflictSuppressed), and ConfigModeEvent[activated]'s
                 * confirmation role is realized inside
                 * AssessingSimultaneousHold itself (see its doc, including
                 * the cross-machine-routing footnote). Idle's
                 * outgoing targets are therefore now unambiguous: exactly
                 * one deterministic target per received event/guard
                 * combination. */
                accept ControlCommand [direction == MovementDirection::none]
                    then AssessingSimultaneousHold;
                accept ControlCommand [mode == MovementMode::automatic and direction != MovementDirection::none]
                    then MovingAutomatic;
                accept ControlCommand [mode == MovementMode::manual and direction != MovementDirection::none]
                    then MovingManual;
                accept PowerLost via crossLifecycleEventRelay then Unpowered;
                accept DecommissionRequest then Disposed;
            }

            state AssessingSimultaneousHold : AssessingSimultaneousHoldState {
                doc
                /* Purpose: State Model Review corrective pass, MAJOR-1 --
                 * explicit discriminator interposed between Idle and its two
                 * previously-racing successors, {ConflictSuppressed,
                 * ConfigurationMode}. Both are ultimately caused by the same
                 * physical simultaneous UP+DOWN gesture, but the model has
                 * no way to know at the instant of arbitration's immediate
                 * conflict detection (ControlCommand[direction==none],
                 * within CommandArbitrationSoftware.arbitrationWindowMs,
                 * Scenarios::SCEN_07 s3) whether the gesture is a brief
                 * conflicting command (SCEN_07) or the first ~50ms of a
                 * deliberate sustained calibration hold (SCEN_13) -- that
                 * can only be known once
                 * ProductComponents::ConfigurationManagerSoftware.
                 * calibrationHoldThresholdS (3.0s) has either elapsed
                 * (confirming a short gesture) or been reached while the
                 * hold is still asserted (confirming a deliberate hold,
                 * signaled cross-machine* by ConfigModeEvent[activated]).
                 * This state represents exactly that already-existing
                 * product-level waiting/discrimination window, made
                 * observable at the Logical/state-model layer for the first
                 * time; no new product behavior is invented, only surfaced.
                 * Entry: ControlCommand[direction==none] from Idle. Exit:
                 * see transitions below. Requirements: REQ-S-01, REQ-S-02
                 * (ConflictSuppressed path), REQ-F-07/REQ-F-08
                 * (ConfigurationMode path). Components: LogicalArchitecture::
                 * LogicalControlUnit (arbitration + configuration-manager
                 * responsibilities); Product::ControlMCU::
                 * configurationManagerSoftware (calibrationHoldThresholdS
                 * owner).
                 *
                 * * Cross-machine note: ConfigModeEvent is produced entirely
                 * within systemLifecycle's own scope (LogicalControlUnit),
                 * so this particular accept does NOT route through
                 * CrossLifecycleEventRelay (MAJOR-2) -- the relay is only
                 * needed where the producer and consumer sit on DIFFERENT
                 * state machines (systemLifecycle vs. diagnosticLifecycle);
                 * see CrossLifecycleEventRelay's doc for the full per-event
                 * routing table.
                 *
                 * Determinism (Rule 6): the two transitions below race
                 * exactly one timed accept against one event accept -- the
                 * same first-wins pattern already established by
                 * UseCaseActivities::MonitorStopCondition/
                 * MonitorUserInterruption's fork/merge (accept X vs. accept
                 * after timeout). Exactly one of the two is guaranteed to
                 * fire within calibrationHoldThresholdS of entry: either
                 * ConfigModeEvent[activated] arrives first (hold confirmed
                 * sustained to the threshold -> ConfigurationMode), or the
                 * threshold elapses first with no confirmation (short
                 * gesture -> ConflictSuppressed). No third outcome and no
                 * simultaneous double-firing are possible, closing the
                 * MAJOR-1 race. SCEN_07 (short simultaneous press) executes
                 * the second transition; SCEN_13 (sustained calibration
                 * hold >= calibrationHoldThresholdS) executes the first. */
                accept ConfigModeEvent [kind == ConfigModeTransition::activated]
                    then ConfigurationMode;
                accept after 3.0 [SI::s] // mirrors ProductComponents::ConfigurationManagerSoftware.calibrationHoldThresholdS
                    then ConflictSuppressed;
            }

            state MovingAutomatic : MovingAutomaticState {
                doc
                /* Purpose: realizes UseCaseActivities::
                 * OpenShutterAutomatically/CloseShutterAutomatically
                 * (UC_01a/UC_01b) -- automatic-mode movement, stopped only
                 * by the configured timeout or an explicit user stop
                 * command (SCEN_01/02/06). Entry: ControlCommand
                 * (mode=automatic, direction != none) from Idle. Do:
                 * MonitorStopCondition (fork/merge race: listenForStopCommand
                 * vs. monitorTimeout). Exit: StopRequest (either reason) ->
                 * Idle; PowerLost -> Unpowered. Requirements: REQ-F-04
                 * (fullShutterMovement). Components:
                 * LogicalArchitecture::LogicalMotorDrive,
                 * LogicalMovementSupervisor.
                 *
                 * Optional improvement (State Model Review corrective pass):
                 * the single 'accept StopRequest then Idle' transition is
                 * split into two StopRequest.reason-guarded transitions
                 * below, exposing MonitorStopCondition's own
                 * listenForStopCommand/monitorTimeout race
                 * (UCActivities.sysml) at the state-model layer for
                 * white-box verification, with identical resulting
                 * behavior (both guards target Idle). StopReason has
                 * exactly two members (timeout, userRequest), so the two
                 * guards remain exhaustive and mutually exclusive
                 * (Rule 6). PowerLost is now explicitly routed via
                 * CrossLifecycleEventRelay (MAJOR-2). */
                entry action startShutterMovement  : StartShutterMovement;
                do    action monitorStopCondition  : MonitorStopCondition;
                exit  action stopShutterMovement   : StopShutterMovement;
                accept StopRequest [reason == StopReason::timeout]     then Idle;
                accept StopRequest [reason == StopReason::userRequest] then Idle;
                accept PowerLost via crossLifecycleEventRelay then Unpowered;
            }

            state MovingManual : MovingManualState {
                doc
                /* Purpose: realizes UseCaseActivities::
                 * OpenShutterManually/CloseShutterManually (UC_01c/UC_01d) --
                 * hold-to-run manual-mode movement, stopped by user release
                 * or the manual safety timeout (SCEN_03/04/05). Entry:
                 * ControlCommand (mode=manual, direction != none) from Idle.
                 * Do: MonitorUserInterruption (fork/merge race:
                 * listenForRelease vs. monitorTimeout). Exit: StopRequest
                 * (either reason) -> Idle; PowerLost -> Unpowered.
                 * Requirements: REQ-F-05 (manualPositioning). Components:
                 * LogicalArchitecture::LogicalMotorDrive,
                 * LogicalMovementSupervisor.
                 *
                 * Known gap (SCEN_05, Phase 9): TC_N_001's own verifyOutcome
                 * asserts "motor does not re-start while command remains
                 * asserted" after a safety-timeout stop, but no
                 * UseCaseActivities action or Logical component doc
                 * explicitly states a latched-stopped-until-release guard.
                 * This state's 'accept StopRequest ... then Idle'
                 * transitions do not themselves re-trigger movement (Idle
                 * requires a fresh ControlCommand), so the modeled
                 * structure is consistent with the observed behavior, but
                 * the guard's structural OWNER remains unidentified --
                 * recorded, not resolved, per Traceability Rule 3.
                 *
                 * Optional improvement (State Model Review corrective pass):
                 * the single 'accept StopRequest then Idle' transition is
                 * split into two StopRequest.reason-guarded transitions
                 * below, exposing MonitorUserInterruption's own
                 * listenForRelease/monitorTimeout race (UCActivities.sysml)
                 * at the state-model layer for white-box verification, with
                 * identical resulting behavior (both guards target Idle).
                 * PowerLost is now explicitly routed via
                 * CrossLifecycleEventRelay (MAJOR-2). */
                entry action startShutterMovement    : StartShutterMovement;
                do    action monitorUserInterruption : MonitorUserInterruption;
                exit  action stopShutterMovement     : StopShutterMovement;
                accept StopRequest [reason == StopReason::timeout]     then Idle;
                accept StopRequest [reason == StopReason::userRequest] then Idle;
                accept PowerLost via crossLifecycleEventRelay then Unpowered;
            }

            state ConflictSuppressed : ConflictSuppressedState {
                doc
                /* Purpose: realizes UseCaseActivities::
                 * HandleConflictingMovementCommands (UC_01e) -- a
                 * simultaneous UP+DOWN conflict was already resolved
                 * upstream (DetermineMovementRequest's suppressMovement /
                 * StartShutterMovement's suppressMotor branches, direction
                 * := none) before this state is entered; the motor is
                 * already de-energized. This state models the observable
                 * user-notification window that makes the suppressed-
                 * movement state distinguishable from ordinary idle
                 * (REQ-S-02, closes Major finding M2). Entry: (since the
                 * State Model Review corrective pass, MAJOR-1)
                 * AssessingSimultaneousHold's calibrationHoldThresholdS
                 * timeout (short gesture, no ConfigModeEvent[activated]
                 * confirmation) -- previously directly from Idle via
                 * ControlCommand[direction==none], now via the explicit
                 * discriminator state. Do/exit: none additional --
                 * completes unconditionally back to Idle once notification
                 * finishes (mirrors UCActivities::
                 * HandleConflictingMovementCommands' own
                 * 'first stopShutterMovement then notifyUserAboutConflict'
                 * composition, which awaits no further event).
                 * Requirements: REQ-S-01 (safety), REQ-S-02
                 * (conflictIndication) -- safety-relevant state per
                 * Traceability Rule 5. Components:
                 * LogicalArchitecture::LogicalUserNotification. */
                entry action notifyUserAboutConflict : NotifyUserAboutConflict;
                then Idle;
            }

            state ConfigurationMode : ConfigurationModeState {
                doc
                /* Purpose: realizes UseCaseActivities::ConfigureController
                 * (UC_03) -- travel-time calibration (REQ-F-07) and, per the
                 * Product Architecture PA-2 fix, wiring-mode selection.
                 * Entry: ConfigModeEvent[activated], confirmed via
                 * AssessingSimultaneousHold (State Model Review corrective
                 * pass, MAJOR-1) rather than directly from Idle. Do: the
                 * complete ConfigureController composition (fork/join
                 * open-travel and close-travel measurement, reentry guard,
                 * and -- MAJ-8 fix, SMRR corrective pass -- the
                 * out-of-range calibration guard: checkOpenTimeInRange/
                 * checkCloseTimeInRange evaluate REQ-F-07's
                 * maxConfigurableTravelTime <= 120 [SI::s] boundary and the
                 * openRangeGuard/closeRangeGuard decides route a failing
                 * measurement to RejectOutOfRangeCalibration instead of
                 * SaveCountedTime -- closes SR-7, Scenarios::SCEN_22).
                 * Exit: ConfigModeEvent[deactivated] -> Idle; PowerLost ->
                 * Unpowered. Requirements: REQ-F-07
                 * (configurableTimingProfile), REQ-F-08 (configurationMode).
                 * Components: LogicalArchitecture::LogicalControlUnit,
                 * LogicalMovementSupervisor, LogicalUserNotification.
                 *
                 * Determinism (Rule 6) / reentry guard: the self-transition
                 * below realizes UseCaseActivities::
                 * CheckConfigurationModeState.alreadyActive == true ->
                 * RejectConfigurationModeReentry exactly (TC_N_002/SCEN_14):
                 * a second ConfigModeEvent[activated] received while already
                 * in ConfigurationMode does not change state, it only
                 * executes the reject action, so the in-progress session
                 * continues unaffected. The two ConfigModeEvent guards
                 * (kind==activated vs. kind==deactivated) are mutually
                 * exclusive by construction (ConfigModeTransition has
                 * exactly these two enum members).
                 *
                 * State Model Review corrective pass (MAJOR-3): the
                 * self-transition below previously used a non-canonical
                 * 'accept ... then do action ... then ConfigurationMode;'
                 * grammar (an extra 'then' preceding 'do action', which
                 * KnowledgeSource/sysml2/concepts/transition.md's canonical
                 * order does not include). Rewritten below to 'accept ...
                 * do action ...; then ConfigurationMode;' -- identical
                 * semantics (trigger, guard, effect action, and target are
                 * all unchanged), canonical grammar only. PowerLost is now
                 * explicitly routed via CrossLifecycleEventRelay
                 * (MAJOR-2). */
                do action configureController : ConfigureController;
                accept ConfigModeEvent [kind == ConfigModeTransition::activated]
                    do action rejectConfigurationModeReentry : RejectConfigurationModeReentry;
                    then ConfigurationMode;
                accept ConfigModeEvent [kind == ConfigModeTransition::deactivated]
                    then Idle;
                accept PowerLost via crossLifecycleEventRelay then Unpowered;
            }

            state Unpowered : UnpoweredState {
                doc
                /* Purpose: unifies Scenarios::SCEN_15_PowerLoss_DuringMovement
                 * and SCEN_16_PowerRecovery_AfterOutage's "no power" episode
                 * into a single observable state, reachable from every
                 * powered operational state (Idle, MovingAutomatic,
                 * MovingManual, ConfigurationMode) via the gap-derived
                 * PowerLost event. Entry: PowerLost (from any powered
                 * state). Exit: PowerRestored -> Idle, or DecommissionRequest
                 * -> Disposed (a controller that never recovers may be
                 * decommissioned while unpowered). Requirements: REQ-Q-02
                 * (availability), ADR_002_Availability (explicit
                 * no-self-healing/failover/watchdog scope). Components:
                 * none -- passively observable only (buzzer silent, per
                 * SCEN_18's "no power" field-diagnosis criterion); no
                 * software component is powered while in this state.
                 *
                 * Known gap (SCEN_15/16, Phase 9): no entry action is
                 * modeled -- the transition into this state is an
                 * electrically passive consequence (relay de-energization),
                 * NOT a controlled/observed transition, exactly as SCEN_15's
                 * GAP records. The exact shutter position at the moment
                 * power is lost is NOT re-established or verified by any
                 * modeled function; PowerRestored's do action
                 * (loadTimingProfile) reloads the persisted TimingProfile
                 * only, not the physical shutter position (SCEN_16 GAP).
                 *
                 * State Model Review corrective pass (MAJOR-3): the
                 * recovery transition below previously used the same
                 * non-canonical 'accept ... then do action ... then Idle;'
                 * grammar flagged on ConfigurationMode's self-transition
                 * above. Rewritten to 'accept ... do action ...; then
                 * Idle;' -- identical semantics, canonical grammar only.
                 * PowerRestored is now explicitly routed via
                 * CrossLifecycleEventRelay (MAJOR-2); ownership: see
                 * CrossLifecycleEventRelay's doc (producer = GAP-derived
                 * firmware boot/re-init placeholder, SCEN_16 -- still not
                 * resolved by this pass). */
                accept PowerRestored via crossLifecycleEventRelay
                    do action loadTimingProfile : LoadTimingProfile;
                    then Idle;
                accept DecommissionRequest then Disposed;
            }

            state Disposed : DisposedState {
                doc
                /* Purpose: terminal state realizing UC_05_DisposeController
                 * -- controller decommissioned, removed from installation,
                 * and disposed of/recycled in compliance with WEEE/RoHS
                 * regulation. Entry: DecommissionRequest (from Idle or
                 * Unpowered). Exit: NONE -- this is a TERMINAL state
                 * (Traceability Rule 4 exception, explicitly documented).
                 * Requirements: REQ-E-01 (regulatedDisposal). Components:
                 * Stakeholders::DisposalFacility. */
                entry action disposeController : DisposeController;
            }
        }
    }

    /* Package-level usage providing a named feature endpoint for
     * traceability links (SysML v2 connection ends must reference
     * features, not classifiers -- mirrors every existing architecture
     * layer's package-level part usage). */
    part rollerShutterControllerWithLifecycle : RollerShutterControllerWithLifecycle;

    // =========================================================================
    // Component-level state machine -- exhibited on a new part def
    // specializing LogicalArchitecture::LogicalDiagnostics.
    // =========================================================================

    part def LogicalDiagnosticsWithState :> LogicalDiagnostics {
        doc
        /* Additive specialization (no existing file modified) giving the
         * validated LogicalDiagnostics component an exhibited fault-
         * classification/repair state machine. Mirrors ProductComponents::
         * DiagnosticsSoftware's own ':> LogicalDiagnostics' strong-coupling
         * pattern for non-invasive extension. */

        exhibit state diagnosticLifecycle : DiagnosticState {

            entry; then Nominal;

            state Nominal : NominalState {
                doc
                /* Purpose: normal operation; no fault classified. Entry:
                 * initial pseudostate, or RepairVerified (from Repairing),
                 * or ConfigModeEvent[deactivated] (from
                 * ConfigurationRequiredFault). Exit: FaultReported ->
                 * ClassifyingFault; TimingProfileReadFailure ->
                 * ConfigurationRequiredFault. Requirements: REQ-Q-04
                 * (diagnosability). Components:
                 * LogicalArchitecture::LogicalDiagnostics (passive
                 * commandStateIn/diagnosticStateIn monitoring; no explicit
                 * do action is documented for the nominal/monitoring
                 * condition at any architecture layer -- none is invented
                 * here either).
                 *
                 * State Model Review corrective pass (MAJOR-2): both
                 * triggers below are now explicitly routed via
                 * CrossLifecycleEventRelay. Ownership: see
                 * CrossLifecycleEventRelay's doc for FaultReported and
                 * TimingProfileReadFailure producer/consumer detail. */
                accept FaultReported            via crossLifecycleEventRelay then ClassifyingFault;
                accept TimingProfileReadFailure via crossLifecycleEventRelay then ConfigurationRequiredFault;
            }

            state ClassifyingFault : ClassifyingFaultState {
                doc
                /* Purpose: realizes UseCaseActivities::DetectFault --
                 * classifies the reported malfunction using
                 * DiagnosticsSoftware's commandStateIn/diagnosticStateIn
                 * taps (Product Architecture PA-1 fix). Entry: FaultReported.
                 * Exit: FaultIndication, discriminated by
                 * ProductInterfaces::FaultClass (SCEN_19/SCEN_20).
                 * Requirements: REQ-Q-04. Components:
                 * LogicalArchitecture::LogicalDiagnostics /
                 * Product::ControlMCU::diagnosticsSoftware.
                 *
                 * Determinism (Rule 6): the two FaultIndication guards
                 * below partition exhaustively and mutually exclusively --
                 * ProductInterfaces::FaultClass has exactly two members
                 * (noResponseToControlInput, motorDriveFault); "no power"
                 * is deliberately NOT a member (passively,
                 * acoustically observable only, per SCEN_18/ADR-008 -- it
                 * never reaches this component at all, since
                 * LogicalDiagnostics itself has no power in that case,
                 * consistent with this state machine having no
                 * "NoPowerFault" state). */
                entry action detectFault : DetectFault;
                accept FaultIndication [faultClass == FaultClass::noResponseToControlInput]
                    then NoResponseFault;
                accept FaultIndication [faultClass == FaultClass::motorDriveFault]
                    then MotorDriveFault;
            }

            state NoResponseFault : NoResponseFaultState {
                doc
                /* Purpose: realizes SCEN_19_DiagnoseAndRepair_NoResponseFault
                 * -- fault classified as "no response to any control
                 * input". Entry: FaultIndication[noResponseToControlInput].
                 * Do: IsolateFault. Exit: RepairCommenced -> Repairing.
                 * Requirements: REQ-Q-04, REQ-Q-05 (fieldReplaceability).
                 * Components: Stakeholders::MaintenanceTechnician. */
                entry action isolateFault : IsolateFault;
                accept RepairCommenced then Repairing;
            }

            state MotorDriveFault : MotorDriveFaultState {
                doc
                /* Purpose: realizes SCEN_20_DiagnoseAndRepair_MotorDriveFault
                 * -- fault classified as "motor-drive fault". Entry:
                 * FaultIndication[motorDriveFault]. Do: IsolateFault. Exit:
                 * RepairCommenced -> Repairing. Requirements: REQ-Q-04,
                 * REQ-Q-05. Components: Stakeholders::
                 * MaintenanceTechnician; Product::MotorDriveRelayModule
                 * (typical isolation target, per SCEN_20 s5). */
                entry action isolateFault : IsolateFault;
                accept RepairCommenced then Repairing;
            }

            state ConfigurationRequiredFault : ConfigurationRequiredFaultState {
                doc
                /* Purpose: GAP-derived (Scenarios::SCEN_24_TimingProfile_
                 * PersistenceFailure_FirstPowerOn, SR-9) -- represents the
                 * "configuration required" indication diagnosticsSoftware
                 * reuses its existing fault-classification port pattern to
                 * flag when no valid TimingProfile can be read (first
                 * power-on or corrupted EEPROM). Entry:
                 * TimingProfileReadFailure (from Nominal). Exit: the ONLY
                 * modeled recovery path is re-running UseCaseActivities::
                 * ConfigureController to persist a valid TimingProfile
                 * (ConfigModeEvent[deactivated]) -- no dedicated repair
                 * action is invented; this exit condition is the same one
                 * SCEN_24's own doc identifies as the closest-fit recovery
                 * mechanism. Requirements: REQ-F-07
                 * (configurableTimingProfile), RISK-T-01 (mitigation
                 * dependency). Components: Product::ControlMCU::
                 * memoryManagerSoftware (the failing read),
                 * diagnosticsSoftware (the signaling reuse).
                 *
                 * State Model Review corrective pass (MAJOR-2): the exit
                 * trigger below is produced by systemLifecycle::
                 * ConfigurationMode (ConfigModeEvent[deactivated]) and
                 * consumed here in diagnosticLifecycle -- a genuine
                 * cross-state-machine delivery, now explicitly routed via
                 * CrossLifecycleEventRelay (contrast with
                 * AssessingSimultaneousHold's ConfigModeEvent[activated],
                 * which stays within systemLifecycle and does NOT use the
                 * relay -- see CrossLifecycleEventRelay's doc). */
                accept ConfigModeEvent [kind == ConfigModeTransition::deactivated]
                    via crossLifecycleEventRelay then Nominal;
            }

            state Repairing : RepairingState {
                doc
                /* Purpose: realizes UseCaseActivities::RepairOrReplaceUnit --
                 * the maintenance technician repairs or replaces the faulty
                 * unit on-site using the existing wiring. Entry:
                 * RepairCommenced (from NoResponseFault or MotorDriveFault).
                 * Exit: RepairVerified -> Nominal. Requirements: REQ-Q-05
                 * (fieldReplaceability). Components: Stakeholders::
                 * MaintenanceTechnician. */
                entry action repairOrReplaceUnit : RepairOrReplaceUnit;
                accept RepairVerified then Nominal;
            }
        }
    }

    /* Package-level usage providing a named feature endpoint for
     * traceability links. */
    part logicalDiagnosticsWithState : LogicalDiagnosticsWithState;
} // package SystemStates
