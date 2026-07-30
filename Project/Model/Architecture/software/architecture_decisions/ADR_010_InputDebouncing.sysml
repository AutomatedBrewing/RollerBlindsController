/* Architecture Decision Record: ADR-SW-010 — Input Debouncing & GPIO Strategy.
 * Documents how the four dry-contact wall-switch/remote input lines are individually
 * observed and debounced by firmware, complementing the hardware RC glitch filter
 * already in ProductComponents::RequestInterfaceCircuit. Deliberately kept atomic and
 * separate from ADR_009_SWExecutionModel (ADR-SW-009), which only decides HOW the
 * firmware is scheduled, not how a debounced input-changed event is produced.
 * arc42 section: ARC-09 Architecture Decisions.
 */
package ADR_010_InputDebouncing {
    private import ProductComponents::*;
    private import ADR_Common::*;

    package ADR_010 {
        @ArchDecisionMeta {
            decisionId = "ADR-SW-010";
            title =
                "Per-line GPIO change-notification interrupts + software debounce
                confirmation stage for the four dry-contact input lines, complementing
                (not replacing) the existing hardware RC glitch filter";
            status = "accepted";
            context =
                "ProductComponents::RequestInterfaceCircuit performs opto-isolation and
                an RC glitch filter (debounceTimeConstantMs=20.0) on each of the two
                dry-contact channels, but this filters electrical noise/contact
                glitches only — it is NOT sufficient to debounce genuine mechanical
                wall-switch actuation bounce. Reliable input handling therefore
                requires a software debounce confirmation stage, in turn requiring the
                four underlying signal lines (local up/down, remote up/down carried by
                localRawIn/remoteRawIn) to each be individually observable, not just
                sampled as two combined ports.";
            decision =
                "Each of the four input lines (local up, local down, remote up, remote
                down) is wired to its own dedicated GPIO configured for change-
                notification interrupts (ControlMCU.inputChangeNotificationGpioCount=4).
                Each interrupt only timestamps/flags the raw transition;
                CommandArbitrationSoftware then confirms the new level is stable for at
                least debounceConfirmMs (30ms) before raising a debounced input-changed
                event consumed by the ADR-SW-009 dispatcher — this is the software
                debounce stage complementing RequestInterfaceCircuit's RC glitch filter.
                CommandArbitrationSoftware.arbitrationWindowMs is widened from 50ms to
                100ms as part of this decision, so the ~50ms worst-case combined
                RC+software debounce latency stays well below the arbitration window
                instead of consuming it entirely.";
            consequences =
                "ControlMCU must reserve 4 of its 14 GPIOs for change-notification
                interrupts (inputChangeNotificationGpioCount), leaving 10 for
                relayOut/buzzerOut/progPort and margin.
                CommandArbitrationSoftware.debounceConfirmMs (30ms) plus the underlying
                RC time constant (debounceTimeConstantMs=20ms) sum to ~50ms worst-case
                debounce latency; arbitrationWindowMs was raised from 50ms to 100ms
                (this ADR) specifically to keep debounce latency well below the
                arbitration window and pressDurationThresholdMs (500ms), so debounce
                latency cannot itself be misread as a genuine arbitration race.
                The GPIO change-notification interrupts become resources to list
                explicitly in the Phase 6 deployment view (SWA-05).";
            alternatives =
                "A. Hardware RC debounce only, no software confirmation stage (original
                ADR-009 draft): rejected — RC filtering alone suppresses electrical
                glitches, not genuine mechanical wall-switch bounce, and would
                misclassify bounce transitions as separate commands.
                B. Sampling all four input lines each timer tick instead of per-line
                GPIO interrupts: rejected — loses the ability to timestamp individual
                line transitions precisely and would require polling all four lines
                every 10ms regardless of activity, for no resource saving (GPIO change-
                notification is essentially free on this MCU family).
                C. Sampling only the two combined dry-contact ports (2 lines) instead
                of the four individual signal lines: rejected — DryContactControlPort
                carries two independent boolean signals (up/down) per port; treating
                them as one observable unit loses the ability to individually
                timestamp/debounce each physical line.";
            rationale =
                "Dedicated change-notification GPIOs plus a short software debounce-
                confirmation window is the standard, low-cost pattern for debouncing
                mechanical switches on a resource-constrained MCU, and composes cleanly
                with the already-fixed 10ms movement-supervision tick (ADR-003) without
                a second polling loop. Keeping this decision separate from ADR-SW-009
                (execution model) keeps each ADR atomic and independently revisable —
                e.g. a future change to the debounce strategy does not require
                revisiting the scheduling decision, and vice versa.";
        }
    } // package ADR_010
} // package ADR_010_InputDebouncing
