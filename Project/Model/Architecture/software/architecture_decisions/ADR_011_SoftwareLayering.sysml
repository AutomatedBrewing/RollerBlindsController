/* Architecture Decision Record: ADR-SW-011 — Software Layering.
 * Names the Application / Driver-HAL / Hardware layering that ADR-SW-009 (execution
 * model) and ADR-SW-010 (input debouncing) already assumed implicitly.
 * arc42 section: ARC-09 Architecture Decisions.
 */
package ADR_011_SoftwareLayering {
    private import ADR_Common::*;

    package ADR_011 {
        @ArchDecisionMeta {
            decisionId = "ADR-SW-011";
            title =
                "Three-layer software architecture — Application / Driver-HAL / Hardware —
                enforced by nested part def specialization; no Application module may touch
                a hardware-facing port directly";
            status = "accepted";
            context =
                "No layer boundary was ever recorded, so every firmware
                module was free to reach hardware directly. ADR-SW-009 (execution model) and
                ADR-SW-010 (debouncing) already assume a driver/hardware split implicitly but
                never state it.";
            decision =
                "Three layers: Application (arbitration/translation/supervision/persistence
                logic) -> Driver/HAL (GpioInputDriver, TimerDriver, MotorRelayOutputDriver,
                BuzzerOutputDriver, EepromDriver — nested part defs added in SWA-03 Phase 3,
                SWBuildingBlocks.sysml) -> Hardware (ControlMCU peripherals,
                RequestInterfaceCircuit, MotorDriveRelayModule, AudibleNotificationBuzzer,
                already in ProductComponents.sysml). No Application-level action may
                reference a hardware-facing port; it goes through its module's driver only.";
            consequences =
                "Every hardware-facing port on CommandArbitrationSoftware,
                MovementSupervisorSoftware, MotorDriveControlSoftware, UserFeedbackSoftware,
                MemoryManagerSoftware is reached via a nested driver (SWA-03 Phase 3).";
            alternatives =
                "A. No explicit layering (status quo): rejected — the exact gap this ADR
                closes. B. Runtime-polymorphic HAL abstraction: rejected — RAM/flash overhead
                unjustified on a fixed-peripheral 8-bit MCU (SWConstraints::Resource::
                memoryDiscipline forbids the dynamic dispatch tables such an abstraction
                needs).";
            rationale =
                "Nested part def specialization is the same non-invasive mechanism SWA-03
                already uses for whitebox decomposition (SWBuildingBlocks.sysml); naming the
                layer boundary makes hardware-access ownership explicit and checkable instead
                of an unstated assumption.";
        }
    } // package ADR_011
} // package ADR_011_SoftwareLayering
