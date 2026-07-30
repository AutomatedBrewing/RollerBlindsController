/* Software Event Catalog (SWA-06 extension) — the single enumerated catalog of every
 * event in the system, naming the two previously prose-only events
 * (DebouncedInputChanged, TimerTick) and the structural home for
 * ADR-SW-009's "event dispatcher". arc42 section: ARC-08 Cross-cutting
 * Concepts.
 *
 * Production/consumption for DebouncedInputChanged and EventDispatcher's
 * producer/consumer wiring are realized via real `flow` statements in
 * `SWBuildingBlocks.sysml` (co-located there to avoid a circular import back
 * into this package) — see each event's doc below for the exact statements.
 * TimerTick's production is likewise flow-realized; its state-machine
 * *consumption* deliberately stays on SysML's native `accept after` (see
 * TimerTick's doc below).
 */
package SWEventCatalog {
    private import SystemStates::*;

    // =========================================================================
    // New events (previously prose-only)
    // =========================================================================

    attribute def DebouncedInputChanged {
        doc
        /* Producer: CommandArbitrationSoftwareInternal's 4 ConfirmInputDebounce
         * instances (`out changed`). Consumer: eventDispatcher.pendingIn/
         * dispatchedOut (proxy-port mediated) routes it to
         * arbitrateChannels (`in dispatchedChange`). Realized end-to-end via
         * `flow` in SWBuildingBlocks.sysml — the raw confirmedLevel booleans
         * also flow there directly as arbitration data, distinct from this
         * event's dispatcher/wake-up role. */
    }

    attribute def TimerTick {
        doc
        /* Producer: TimerDriver (`out producedEvent`), flowed to
         * eventDispatcher.pendingIn.timerTick in SWBuildingBlocks.sysml (port
         * mediation). Consumption: deliberately NOT a second, parallel
         * `accept TimerTick` path -- SystemStates.sysml's already
         * Rule-6-verified `accept after <duration>` remains the sole,
         * authoritative movement-timeout/hold-to-run/debounce-bookkeeping
         * timing mechanism (avoids a redundant dispatch route). */
    }

    // =========================================================================
    // Event catalog table (EventCatalogMeta), covering all 8 events: the 6 already
    // formalized in SystemStates.sysml plus the 2 new ones above. Mirrors
    // SWResourceBudget::ExecutionContext's existing metadata-table pattern.
    // =========================================================================

    metadata def EventCatalogMeta {
        attribute producer : String;
        attribute consumer : String;
        attribute trigger : String;
    }

    metadata EventCatalogMeta about SystemStates::BeginInstallation {
        producer = "Installer (external actor, UC_02_InstallController)";
        consumer = "ControllerLifecycleState::Uninstalled (-> Installing)";
        trigger = "Installer begins physical installation";
    }

    metadata EventCatalogMeta about SystemStates::InstallationVerified {
        producer = "UseCaseActivities::InstallController (verifyWorking/retryVerifyWorking)";
        consumer = "ControllerLifecycleState::Installing (-> Operational, entering at Idle)";
        trigger = "verifyWorking.success == true or retryVerifyWorking.success == true";
    }

    metadata EventCatalogMeta about SystemStates::InstallationFaultReported {
        producer = "UseCaseActivities::InstallController (retryVerifyWorking)";
        consumer = "ControllerLifecycleState::Installing (-> InstallationFault)";
        trigger = "retryVerifyWorking.success == false";
    }

    metadata EventCatalogMeta about SystemStates::DecommissionRequest {
        producer = "User/Manufacturer (external actor, UC_05_DisposeController)";
        consumer = "ControllerLifecycleState::{Idle, Unpowered} (-> Disposed)";
        trigger = "Controller retired at end of life";
    }

    metadata EventCatalogMeta about SystemStates::PowerLost {
        producer = "ProductComponents::PowerSupplyModule (supplyPresent true->false)";
        consumer =
            "ControllerLifecycleState::{Operational, Installing} (-> Unpowered),
            routed via crossLifecycleEventRelay";
        trigger = "supplyPresent transitions false";
    }

    metadata EventCatalogMeta about SystemStates::PowerRestored {
        producer = "ProductComponents::PowerSupplyModule (supplyPresent false->true)";
        consumer =
            "ControllerLifecycleState::Unpowered (-> Operational, entering at Idle, via
            loadTimingProfile), routed via crossLifecycleEventRelay";
        trigger = "supplyPresent transitions true";
    }

    metadata EventCatalogMeta about DebouncedInputChanged {
        producer = "CommandArbitrationSoftwareInternal.confirmLocalUp/Down, confirmRemoteUp/Down (out changed)";
        consumer = "eventDispatcher.pendingIn/dispatchedOut (proxy-port mediated) -> CommandArbitrationSoftwareInternal.arbitrateChannels (in dispatchedChange), flow-realized";
        trigger = "ConfirmInputDebounce.confirmedLevel becomes stable (debounceConfirmMs)";
    }

    metadata EventCatalogMeta about TimerTick {
        producer = "TimerDriver (nested under MovementSupervisorSoftwareInternal), flow-realized to eventDispatcher.pendingIn.timerTick";
        consumer =
            "None modeled as a discrete accept -- SystemStates::ControllerLifecycleState's
            native 'accept after <duration>' (Rule 6, already verified deterministic)
            remains the sole timeout/hold-to-run/debounce-bookkeeping mechanism, by
            deliberate choice (avoids a redundant parallel dispatch route)";
        trigger = "periodic tick every timerResolutionMs (10ms)";
    }

    // =========================================================================
    // Event dispatcher — structural home for ADR-SW-009's "dispatcher".
    // Mirrors SystemStates::CrossLifecycleEventRelay's explicit event-routing pattern.
    // =========================================================================

    port def EventDispatcherInPort {
        doc
        /* Fan-in: each producer flows its event instance to the matching item
         * (0..1 -- dispatcher holds at most one pending instance per type,
         * never queued/batched). Replaces the earlier bare
         * part-attribute flow target with proxy-port mediation. */

        in item debouncedChange : DebouncedInputChanged[0..1];
        in item timerTick : TimerTick[0..1];
    }

    port def EventDispatcherOutPort {
        doc
        /* Routes a dispatched DebouncedInputChanged back out to its consumer
         * (arbitrateChannels). TimerTick has no consumer leg here by design
         * (see TimerTick's doc above -- SystemStates' native 'accept after'
         * remains the sole timing mechanism). */

        out item dispatchedChange : DebouncedInputChanged[0..1];
    }

    part def EventDispatcher {
        doc
        /* Structural home for ADR-SW-009's superloop "event dispatcher";
         * mirrors CrossLifecycleEventRelay's explicit event-routing pattern
         * one layer down. Proxy-port mediated -- pendingIn/
         * dispatchedOut replace the former bare pendingDebouncedInputChanged/
         * pendingTimerTick attributes as `flow` targets in SWBuildingBlocks.sysml. */

        port pendingIn : EventDispatcherInPort;
        port dispatchedOut : EventDispatcherOutPort;
    }

    /* Named routing endpoint, mirroring SystemStates::crossLifecycleEventRelay's usage pattern. */
    part eventDispatcher : EventDispatcher;
} // package SWEventCatalog
