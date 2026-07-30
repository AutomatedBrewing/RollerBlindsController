/* Software Building Block View (SWA-03) — Level 4 whitebox decomposition of firmware
 * `part def` components (SM-PRD-21). arc42 section: ARC-05. Phase scope/rationale
 * and per-module decomposition decisions: see `Architecture/software/PLAN.md`. */
package SWBuildingBlocks {
    private import ProductComponents::*;
    private import ProductInterfaces::*;
    private import FunctionalArchitecture::*;
    private import SystemContext::*;
    private import SystemStates::*;
    private import UseCaseActivities::*;
    private import SWEventCatalog::*;

    // MovementSupervisorSoftware hosts the lifecycle state machine — it is
    // the sole firmware module with strong ADR-007 coupling (':>' 1:1
    // realization of LogicalMovementSupervisor), the natural structural host.
    // Hosting does NOT mean it alone executes every entry/do/exit action —
    // other modules still coordinate via the ADR-SW-009 event dispatcher.
    part def MovementSupervisorSoftwareInternal :> ProductComponents::MovementSupervisorSoftware {
        // Ports/attributes inherited unchanged via ':>'.

        // Exhibits the SAME ControllerLifecycleState def already fully
        // elaborated in SystemStates.sysml — no duplication of behavior.
        exhibit state lifecycle : ControllerLifecycleState;

        // Driver/HAL layer (ADR-SW-011): owns the single periodic timer peripheral;
        // Application-layer monitorStopCondition/monitorUserInterruption no longer
        // reads the peripheral directly.
        part def TimerDriver {
            doc
            /* Owns timerResolutionMs's periodic timer peripheral (ADR-003/ADR-SW-009)
             * and produces TimerTick (SWEventCatalog.sysml), routed to consumers via
             * eventDispatcher. ISR body stays flag/counter-only (ADR-SW-009). */

            attribute producedEvent : TimerTick[0..1];
        }

        part timerDriver : TimerDriver;

        // Structural evidence the tick reaches the dispatcher.
        flow from timerDriver.producedEvent to eventDispatcher.pendingIn.timerTick;
    }

    // Package-level usage (mirrors existing convention, e.g.
    // SystemStates::rollerShutterControllerWithLifecycle).
    part movementSupervisorSoftwareInternal : MovementSupervisorSoftwareInternal;

    // ── Phase 4: CommandArbitrationSoftware whitebox ─────────────────────────

    // ADR-SW-010's software debounce-confirmation stage: one instance per raw
    // GPIO change-notification line (4 total). Signature-only, matching the
    // modeling depth of the crossmapping's own illustrative example.
    action def ConfirmInputDebounce {
        doc
        /* Confirms a raw GPIO transition as genuine, stable actuation rather
         * than electrical noise (already filtered by RequestInterfaceCircuit's
         * RC glitch filter). confirmedLevel follows rawLevel once stable for
         * debounceConfirmMs (ADR-SW-010). */

        in rawLevel : Boolean;
        in stableDurationMs : Real;
        out confirmedLevel : Boolean;

        // Raises the SWEventCatalog::DebouncedInputChanged catalog event once
        // the transition is confirmed stable.
        out changed : DebouncedInputChanged;
    }

    // Refines ReceiveControlRequest with UP+DOWN conflict detection
    // (UC_01e / HandleConflictingMovementCommands): if the losing channel
    // asserts an opposite direction within arbitrationWindowMs of the winning
    // edge, direction is forced to MovementDirection::none.
    action def ArbitrateAndDetectConflict specializes ReceiveControlRequest {
        doc
        /* Realizes CommandArbitrationSoftware's arbitration/conflict-detection
         * responsibility, operating on the four debounced lines. */

        // Named, additive inputs for the four debounce-confirmed lines —
        // inherited ReceiveControlRequest members (acceptLocalCmd/acceptRemoteCmd/
        // command) are untouched; these are the concrete per-line signals this
        // firmware realization actually operates on (doc above).
        in confirmedLocalUp : Boolean;
        in confirmedLocalDown : Boolean;
        in confirmedRemoteUp : Boolean;
        in confirmedRemoteDown : Boolean;

        // Dispatcher-routed wake/trigger, distinct from the direct data path
        // above (ADR-SW-009 event-dispatcher style — data flows directly, the
        // event notification that data is ready is routed via eventDispatcher).
        in dispatchedChange : DebouncedInputChanged[0..1];

        // The two edge timestamps the conflict-window comparison operates on,
        // flowed in from the containing part's state.
        in lastLocalEdgeMs : Real;
        in lastRemoteEdgeMs : Real;

        // TODO(SDD): the exact confirmedLocalUp/Down/RemoteUp/Down ->
        // command (direction/mode/source) derivation algorithm (arbitration-
        // window timestamp comparison against lastLocalEdgeMs/lastRemoteEdgeMs,
        // WiringMode momentary/latching interpretation) is SDD-level detail,
        // deliberately not transcribed here (no invented facts) -- already
        // qualitatively covered by CommandArbitrationSoftware's Product
        // Architecture doc and this action's own doc above.
    }

    // Whitebox decomposition of CommandArbitrationSoftware (Product Architecture).
    part def CommandArbitrationSoftwareInternal :> ProductComponents::CommandArbitrationSoftware {
        // Ports/attributes inherited unchanged via ':>'.

        // Driver/HAL layer (ADR-SW-011): owns the four raw GPIO change-notification
        // lines directly; ConfirmInputDebounce (Application layer, below) reads from
        // this driver, never localRawIn/remoteRawIn directly.
        part def GpioInputDriver {
            doc
            /* Owns the four raw GPIO change-notification lines (ADR-SW-010), carried on
             * 2 ports (rawLocalIn/rawRemoteIn), each an up/down pair — "4 lines" means
             * 4 individually-debounced signals, not 4 ports. ConfirmInputDebounce
             * confirms stability; this driver only forwards the raw, unconfirmed level. */

            port rawLocalIn : ~DryContactControlPort;
            port rawRemoteIn : ~DryContactControlPort;
        }

        part gpioInputDriver : GpioInputDriver;

        // ADR-SW-011 layering: raw lines terminate at the driver, not at
        // ConfirmInputDebounce directly.
        connect localRawIn to gpioInputDriver.rawLocalIn;
        connect remoteRawIn to gpioInputDriver.rawRemoteIn;

        // Last confirmed edge timestamp per channel, used by the conflict
        // window comparison; flowed into arbitrateChannels below (the
        // comparison algorithm itself stays SDD-deferred, see arbitrateChannels'
        // own TODO).
        attribute lastLocalEdgeMs : Real;
        attribute lastRemoteEdgeMs : Real;

        // One debounce-confirmation instance per raw GPIO line (ADR-SW-010),
        // reading from gpioInputDriver (Driver/HAL layer, ADR-SW-011).
        perform action confirmLocalUp : ConfirmInputDebounce;
        perform action confirmLocalDown : ConfirmInputDebounce;
        perform action confirmRemoteUp : ConfirmInputDebounce;
        perform action confirmRemoteDown : ConfirmInputDebounce;

        // Arbitration + UP/DOWN conflict detection over the four debounced lines.
        perform action arbitrateChannels : ArbitrateAndDetectConflict;

        // End-to-end data path: raw GPIO -> debounce confirmation ->
        // arbitration -> boundary.
        flow from gpioInputDriver.rawLocalIn.up to confirmLocalUp.rawLevel;
        flow from gpioInputDriver.rawLocalIn.down to confirmLocalDown.rawLevel;
        flow from gpioInputDriver.rawRemoteIn.up to confirmRemoteUp.rawLevel;
        flow from gpioInputDriver.rawRemoteIn.down to confirmRemoteDown.rawLevel;

        flow from confirmLocalUp.confirmedLevel to arbitrateChannels.confirmedLocalUp;
        flow from confirmLocalDown.confirmedLevel to arbitrateChannels.confirmedLocalDown;
        flow from confirmRemoteUp.confirmedLevel to arbitrateChannels.confirmedRemoteUp;
        flow from confirmRemoteDown.confirmedLevel to arbitrateChannels.confirmedRemoteDown;

        // Structural realization of the "used by the conflict window
        // comparison" claim above.
        flow from lastLocalEdgeMs to arbitrateChannels.lastLocalEdgeMs;
        flow from lastRemoteEdgeMs to arbitrateChannels.lastRemoteEdgeMs;

        flow from arbitrateChannels.command to commandOut.command;
        flow from arbitrateChannels.command to commandRelayOut.command;

        // Each confirmation also raises the dispatcher-routed
        // DebouncedInputChanged event (wake/trigger path, distinct from the
        // direct data path above), and the dispatcher routes it back out to
        // arbitrateChannels as its trigger. Proxy-port mediated via
        // pendingIn/dispatchedOut.
        flow from confirmLocalUp.changed to eventDispatcher.pendingIn.debouncedChange;
        flow from confirmLocalDown.changed to eventDispatcher.pendingIn.debouncedChange;
        flow from confirmRemoteUp.changed to eventDispatcher.pendingIn.debouncedChange;
        flow from confirmRemoteDown.changed to eventDispatcher.pendingIn.debouncedChange;

        flow from eventDispatcher.dispatchedOut.dispatchedChange to arbitrateChannels.dispatchedChange;
    }

    part commandArbitrationSoftwareInternal : CommandArbitrationSoftwareInternal;

    // ── Phase 4: MovementControlSoftware whitebox ────────────────────────────

    // Whitebox decomposition of MovementControlSoftware (Product Architecture).
    part def MovementControlSoftwareInternal :> ProductComponents::MovementControlSoftware {
        doc
        /* Command-to-request translation is already fully specified at the Use
         * Case Activities level by DetermineMovementRequest: given an already
         * conflict-resolved ControlCommand, it suppresses movement or passes
         * direction/mode through unchanged — reused directly, not redefined. */

        // Ports inherited unchanged via ':>'.
        perform action translateCommand : DetermineMovementRequest;

        // End-to-end data path binding the sole internal action to both
        // boundary ports.
        flow from commandIn.command to translateCommand.command;
        flow from translateCommand.request to requestOut.request;
    }

    part movementControlSoftwareInternal : MovementControlSoftwareInternal;

    // ConfigurationManagerSoftware intentionally has NO SWBuildingBlocks whitebox
    // here: it owns no hardware-facing port (PLAN.md's deliberate blackbox
    // decision), so ADR-SW-011's driver-layer decomposition doesn't apply to it.
    // Its realization of DetermineConfigurationMode is modeled one layer up, at
    // the Functional layer (FunctionalArchitecture::configurationControlFunctions.
    // determineConfigMode), matching the abstraction level this file's other
    // Application-layer modules use for already-fully-specified UC activities
    // (e.g. MovementControlSoftwareInternal.translateCommand above).

    // ── Driver layer whitebox decomposition ──────────────────────────────────
    // The 3 modules that own a hardware-facing port each get exactly one nested
    // driver (ADR-SW-011); no Application-level logic is added here beyond what
    // Product Architecture already documents.

    part def MotorDriveControlSoftwareInternal :> ProductComponents::MotorDriveControlSoftware {
        // Ports inherited unchanged via ':>'.

        // Driver/HAL layer (ADR-SW-011): sole owner of upCoil/downCoil break-before-make
        // (RelayControlPort doc).
        part def MotorRelayOutputDriver {
            doc
            /* Owns relayOut's upCoil/downCoil signals; enforces break-before-make so
             * both coils are never asserted together (RelayControlPort doc,
             * REQ-S-01-adjacent). */

            port coilOut : RelayControlPort;

            // Structural enforcement, not just prose: both coils asserted together
            // is a modeled invariant violation, checkable independently of the
            // upstream guards in DetermineMovementRequest/StartShutterMovement
            // (defense-in-depth, REQ-S-01).
            assert not constraint { coilOut.upCoil and coilOut.downCoil }
        }

        part motorRelayOutputDriver : MotorRelayOutputDriver;

        // ADR-SW-011 layering: relayOut terminates at the driver.
        connect motorRelayOutputDriver.coilOut to relayOut;
    }

    part motorDriveControlSoftwareInternal : MotorDriveControlSoftwareInternal;

    part def UserFeedbackSoftwareInternal :> ProductComponents::UserFeedbackSoftware {
        // Ports/attributes inherited unchanged via ':>'.

        // Driver/HAL layer (ADR-SW-011): sole owner of the single buzzerOn GPIO
        // drive line (ADR-008).
        part def BuzzerOutputDriver {
            doc
            /* Owns buzzerOut's single buzzerOn drive line (ADR-008); Application-layer
             * beep-pattern attributes (configModeActivationBeepCount/Ms etc.) drive
             * this port, never the hardware pin directly. */

            port driveOut : BuzzerControlPort;
        }

        part buzzerOutputDriver : BuzzerOutputDriver;

        // ADR-SW-011 layering: buzzerOut terminates at the driver.
        connect buzzerOutputDriver.driveOut to buzzerOut;
    }

    part userFeedbackSoftwareInternal : UserFeedbackSoftwareInternal;

    part def MemoryManagerSoftwareInternal :> ProductComponents::MemoryManagerSoftware {
        // Ports/attributes inherited unchanged via ':>'.

        // Driver/HAL layer (ADR-SW-011): sole owner of ControlMCU.internalEepromBytes
        // read/write access, realizing Cross-cutting Concept 4's "single-owner EEPROM
        // access" (SWCrossCuttingConcepts.sysml) structurally.
        part def EepromDriver {
            doc
            /* Sole owner of internalEepromBytes read/write access (ADR-006); no other
             * driver touches EEPROM (Cross-cutting Concept 4). */

            port storeIn : ~TravelTimePort;
            port loadOut : TravelTimePort;
        }

        part eepromDriver : EepromDriver;

        // ADR-SW-011 layering: durationIn/timingOut terminate at the driver.
        connect durationIn to eepromDriver.storeIn;
        connect eepromDriver.loadOut to timingOut;
    }

    part memoryManagerSoftwareInternal : MemoryManagerSoftwareInternal;
} // package SWBuildingBlocks
