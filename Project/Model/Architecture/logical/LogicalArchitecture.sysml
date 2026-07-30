package LogicalArchitecture {
    // Imports only the abstract root — SystemArchitecture_Taxonomy has no other public types.
    private import SystemArchitecture_Taxonomy::SystemArchitecture;
    private import FunctionalArchitecture::*;
    private import BaseArchitecture::*;
    private import DomainKnowledge::*;
    private import SystemContext::*;
    private import ScalarValues::String;

    /* Logical Architecture (SM-PRD-20): technology-independent structural realization of
     * FunctionalArchitecture (SM-PRD-18), per SYSMOD Tool 4.18.
     * - Coupling: Functional→Logical loose (allocation def, ADR_004); Logical→Base strong (':>')
     *   for the 4 components with a direct Base Architecture counterpart.
     * - Port-def reuse: internal interfaces reuse FunctionalArchitecture's port defs; new port defs
     *   only at the system boundary (SystemContext parity, Traceability Rule 3).
     * - requestAcquisitionFunctions split: translation allocates to LogicalLocalRequestInterface /
     *   LogicalRemoteRequestInterface; arbitration allocates to LogicalControlUnit.
     * - ShutterStatePort is internal-only; MotorState is abstracted to ShutterDrivePort at the boundary.
     * - LogicalControlUnit aggregates 4 FEs (highest concentration); Product Architecture MUST
     *   re-evaluate splitting memoryFunctions/configurationControlFunctions.
     */

    // =========================================================================
    // No new port defs: boundary reuses SystemContext port defs; internal
    // interfaces reuse FunctionalArchitecture's port defs.
    // =========================================================================

    // =========================================================================
    // Logical Components
    // =========================================================================

    part def LogicalLocalRequestInterface :> WallSwitchInterface {
        doc
        /* Translates the local wall-switch dry-contact signal into a typed ControlCommand,
         * stamping source == ChannelSource::local (REQ-F-08). Strongly coupled to
         * BaseArchitecture::WallSwitchInterface (ADR-004). */

        attribute signalInterpretation : String {
            doc
            /* Qualitative mapping of local dry-contact voltage state to direction/mode; same method as
             * the remote interface (REQ-I-01). */
        }

        port ctrlIn : ~DryContactControlPort;
        port commandOut : ControlCommandPort;
    }

    part def LogicalRemoteRequestInterface :> RemoteInterface {
        doc
        /* Translates the remote home-automation dry-contact signal into a typed ControlCommand,
         * stamping source == ChannelSource::remote (REQ-F-08). Strongly coupled to
         * BaseArchitecture::RemoteInterface (ADR-004). */

        attribute signalInterpretation : String {
            doc
            /* Qualitative mapping of remote dry-contact voltage state to direction/mode (equivalent to local per REQ-I-02). */
        }

        port ctrlIn : ~DryContactControlPort;
        port commandOut : ControlCommandPort;
    }

    part def LogicalControlUnit :> ControlUnit {
        doc
        /* Arbitrates local/remote commands, validates ControlCommands, manages configuration-mode
         * state, and persists the timing profile. Realizes controlLogicFunctions,
         * configurationControlFunctions, memoryFunctions, and the requestAcquisitionFunctions
         * arbitration sub-behavior. Strongly coupled to BaseArchitecture::ControlUnit (ADR-004). */

        attribute commandArbitrationPolicy : String {
            doc
            /* First-accepted-wins arbitration between local and remote channels; equal-priority
             * stop arbitration (REQ-F-06) is handled separately by LogicalMovementSupervisor. */
        }

        port localCommandIn : ~ControlCommandPort;
        port remoteCommandIn : ~ControlCommandPort;
        port requestOut : MovementRequestPort;
        port modeEventOut : ConfigModeEventPort;
        port durationIn : ~TravelTimePort;
        port timingOut : TravelTimePort;
        port commandRelayOut : ControlCommandPort;
    }

    part def LogicalMovementSupervisor {
        doc
        /* Timer-based supervision of in-progress shutter movement (ADR-003, no position feedback)
         * and elapsed travel-time measurement during calibration. Realizes movementSupervisionFunctions
         * and timeCountingFunctions; no Base Architecture counterpart (ADR-004). */

        attribute supervisionPrinciple : String {
            doc
            /* Time-based movement supervision using the configured travel time, with no physical
             * position sensing (ADR-003). */
        }

        port commandIn : ~ControlCommandPort;
        port requestIn : ~MovementRequestPort;
        port timingIn : ~TravelTimePort;
        port stopOut : StopRequestPort;
        port shutterStateIn : ~ShutterStatePort;
        port durationOut : TravelTimePort;
        // ConfigModeEvent has a real port
        // path down to Product/Software, not just implicit same-scope reasoning.
        port modeEventIn : ~ConfigModeEventPort;
    }

    part def LogicalMotorDrive :> MotorDriver {
        doc
        /* Energizes/de-energizes the shutter motor relay in response to movement and stop requests,
         * exposing the drive state at the system boundary. Realizes shutterControlFunctions;
         * strongly coupled to BaseArchitecture::MotorDriver (ADR-004). */

        attribute driveSwitchingPrinciple : String {
            doc
            /* Relay-based motor energizing/de-energizing, one relay per direction (ADR-001). */
        }

        port requestIn : ~MovementRequestPort;
        port stopIn : ~StopRequestPort;
        port shutterStateOut : ShutterStatePort;
        port driveOut : ShutterDrivePort;
    }

    part def LogicalUserNotification {
        doc
        /* Delivers user-visible feedback for configuration-mode transitions (activation/deactivation)
         * from the typed ConfigModeEvent (REQ-F-08). Realizes userNotificationFunctions;
         * no Base Architecture counterpart (ADR-004). */

        attribute feedbackModality : String {
            doc
            /* Feedback channel is an audible buzzer only; the previously considered LED
             * alternative was removed (ADR-008). */
        }

        port modeEventIn : ~ConfigModeEventPort;
    }

    // =========================================================================
    // Composite Logical Architecture
    // =========================================================================

    part def RollerShutterControllerLogicalComponents :> SystemArchitecture {
        doc
        /* Top-level Logical Architecture composite: technology-independent structural realization of
         * FunctionalArchitecture::RollerShutterControllerFunctions (see FunctionalAllocation.sysml).
         * Boundary ports mirror SystemContext::shutterController (Traceability Rule 3). */

        // ── System boundary ports (mirrors SystemContext::shutterController) ──
        port localCtrl : ~DryContactControlPort;
        port remoteCtrl : ~DryContactControlPort;
        port controlPower : ~ControlPowerPort;
        port mainsPower : ~MainsPowerPort;
        port shutterDrive : ShutterDrivePort;

        // ── Logical Components ──────────────────────────────────────────────
        part logicalLocalRequestInterface : LogicalLocalRequestInterface;
        part logicalRemoteRequestInterface : LogicalRemoteRequestInterface;
        part logicalControlUnit : LogicalControlUnit;
        part logicalMovementSupervisor : LogicalMovementSupervisor;
        part logicalMotorDrive : LogicalMotorDrive;
        part logicalUserNotification : LogicalUserNotification;

        // ── Boundary delegations ────────────────────────────────────────────
        // 1. System boundary → LogicalLocalRequestInterface  [port delegation]
        connect localCtrl to logicalLocalRequestInterface.ctrlIn;

        // 2. System boundary → LogicalRemoteRequestInterface  [port delegation]
        connect remoteCtrl to logicalRemoteRequestInterface.ctrlIn;

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
        // Relays the arbitrated ControlCommand so LogicalMovementSupervisor can realize
        // stop/release trigger sources (UC_01c/d/e).
        flow : ControlCommandFlow
            from logicalControlUnit.commandRelayOut to logicalMovementSupervisor.commandIn;

        // 6. LogicalControlUnit → LogicalMovementSupervisor  [MovementRequest]
        // Fan-out leg 1 of 2 (mirrors FA connections 3/4; two independent concurrent consumers).
        flow : MovementRequestFlow
            from logicalControlUnit.requestOut to logicalMovementSupervisor.requestIn;

        // 7. LogicalControlUnit → LogicalMotorDrive  [MovementRequest]
        // Fan-out leg 2 of 2.
        flow : MovementRequestFlow
            from logicalControlUnit.requestOut to logicalMotorDrive.requestIn;

        // 8. LogicalMovementSupervisor → LogicalMotorDrive  [StopRequest]
        flow : StopRequestFlow from logicalMovementSupervisor.stopOut to logicalMotorDrive.stopIn;

        // 9. LogicalMotorDrive → LogicalMovementSupervisor  [ShutterState, UC_03 only]
        flow : ShutterStateFlow
            from logicalMotorDrive.shutterStateOut to logicalMovementSupervisor.shutterStateIn;

        // 10. LogicalMovementSupervisor → LogicalControlUnit  [TravelTime]
        flow : TravelTimeFlow
            from logicalMovementSupervisor.durationOut to logicalControlUnit.durationIn;

        // 11. LogicalControlUnit → LogicalMovementSupervisor  [TravelTime, runtime timeout]
        flow : TravelTimeFlow
            from logicalControlUnit.timingOut to logicalMovementSupervisor.timingIn;

        // 12. LogicalControlUnit → LogicalUserNotification  [ConfigModeEvent]
        flow : ConfigModeEventFlow
            from logicalControlUnit.modeEventOut to logicalUserNotification.modeEventIn;

        // 12b. LogicalControlUnit → LogicalMovementSupervisor  [ConfigModeEvent]
        // Fan-out sibling of connection 12.
        flow : ConfigModeEventFlow
            from logicalControlUnit.modeEventOut to logicalMovementSupervisor.modeEventIn;
    }

    /* Package-level usage providing a named feature endpoint for traceability
     * links (SysML v2 connection ends must reference features, not classifiers).
     */
    part rollerShutterControllerLogicalComponents : RollerShutterControllerLogicalComponents;
} // package LogicalArchitecture
