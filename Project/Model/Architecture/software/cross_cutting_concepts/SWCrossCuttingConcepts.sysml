/* Software Cross-cutting Concepts (SWA-06) — firmware-wide conventions that
 * apply across multiple Software Building Block View (SWA-03) components
 * rather than belonging to any single one. Each concept below is backed by
 * at least one concrete SWA-03 instance already present in SWBuildingBlocks.sysml
 * (crossmapping Traceability Rule 1) and traces back to the SWA-01 constraint
 * or SWA-07 ADR that caused it (Rule 3). arc42 section: ARC-08 Cross-cutting
 * Concepts.
 */
package SWCrossCuttingConcepts {
    private import ProductComponents::*;
    private import SWBuildingBlocks::*;
    private import SWConstraints::*;
    private import SystemStates::*;

    // =========================================================================
    // Concept 1 -- No Dynamic Memory Allocation
    // =========================================================================
    doc
    /* Concept: No Dynamic Memory Allocation.
     * Origin: SWConstraints::Resource::memoryDiscipline (SWA-01) -- with only
     * ControlMCU.internalRamBytes (1024 bytes) and no MMU/stack-guard
     * hardware, no firmware module may use heap/dynamic allocation; every
     * buffer and internal data item is fixed-size and statically allocated.
     * Concrete SWA-03 instance: CommandArbitrationSoftwareInternal's internal
     * data (lastLocalEdgeMs, lastRemoteEdgeMs, SWBuildingBlocks.sysml) are
     * plain statically-declared attributes, not dynamically allocated
     * buffers -- the pattern every further internal-decomposition addition
     * must follow.
     */

    metadata def NoDynamicAllocationMeta {
        attribute verified : Boolean;
    }

    // Applied to every firmware part def already defined in Product Architecture
    // (SM-PRD-21); marks each as checked against this concept (Rule 2).
    metadata NoDynamicAllocationMeta about CommandArbitrationSoftware { verified = true; }
    metadata NoDynamicAllocationMeta about MovementControlSoftware { verified = true; }
    metadata NoDynamicAllocationMeta about ConfigurationManagerSoftware { verified = true; }
    metadata NoDynamicAllocationMeta about MemoryManagerSoftware { verified = true; }
    metadata NoDynamicAllocationMeta about MovementSupervisorSoftware { verified = true; }
    metadata NoDynamicAllocationMeta about MotorDriveControlSoftware { verified = true; }
    metadata NoDynamicAllocationMeta about UserFeedbackSoftware { verified = true; }

    // =========================================================================
    // Concept 2 -- Single Shared Timing Source
    // =========================================================================
    doc
    /* Concept: Single Shared Timing Source.
     * Origin: ADR-003 (timer-based movement supervision) and ADR-SW-009
     * (single periodic timer tick as the only non-GPIO interrupt source);
     * reinforced by SWResourceBudget::timerPeripheralUsage (SWA-05), which
     * confirms no second timer peripheral exists. No firmware module may
     * introduce its own independent timing source -- every elapsed-time
     * measurement (movement timeout, hold-to-run duration, ADR-SW-010's
     * debounce stableDurationMs bookkeeping) is derived from counting the
     * SAME MovementSupervisorSoftware.timerResolutionMs (10ms) tick.
     * Concrete SWA-03 instance: CommandArbitrationSoftwareInternal's four
     * ConfirmInputDebounce instances (confirmLocalUp/Down, confirmRemoteUp/Down,
     * SWBuildingBlocks.sysml) all consume stableDurationMs measured against
     * this same shared tick, rather than each line running its own timer.
     */

    // Checkable marker, mirroring Concept 1's NoDynamicAllocationMeta pattern.
    metadata def SharedTimingSourceMeta {
        attribute verified : Boolean;
    }

    // Applied to the two modules that concretely consume the shared tick
    // (doc above): CommandArbitrationSoftware's debounce bookkeeping and
    // MovementSupervisorSoftware, the tick's own owning module.
    metadata SharedTimingSourceMeta about CommandArbitrationSoftware { verified = true; }
    metadata SharedTimingSourceMeta about MovementSupervisorSoftware { verified = true; }

    // =========================================================================
    // Concept 3 -- Event-Dispatcher State-Machine Execution
    // =========================================================================
    doc
    /* Concept: Event-Dispatcher State-Machine Execution.
     * Origin: ADR-SW-009 -- the superloop is framed as an event dispatcher,
     * not a flat polling loop; every firmware module is a non-blocking event
     * handler invoked from that single dispatch point, and the exhibited
     * SystemStates::ControllerLifecycleState machine (SM-PRD-23) is driven by
     * the SAME dispatcher, never by its own separate scheduling mechanism.
     * Concrete SWA-03/SWA-04 instances: MovementSupervisorSoftwareInternal's
     * `exhibit state lifecycle : ControllerLifecycleState;` (SWBuildingBlocks.sysml)
     * is the sole structural host of the whole-system lifecycle machine, and
     * SWRuntimeScenarios::RSCEN_02/RSCEN_03 both walk this machine's
     * transitions strictly through dispatcher-context steps (arbitrateChannels,
     * translateCommand, the timer-tick-driven monitorStopCondition), never
     * from inside an ISR (consistent with ADR-SW-009's ISR-minimalism, also
     * reflected in SWResourceBudget's ExecutionContext = "main-loop" tags).
     * This is the uniform application, across every module, of the single
     * execution-model decision made once in ADR-SW-009 -- no module invents
     * its own scheduling or state-dispatch mechanism.
     */

    // Checkable marker, applied to all 7 firmware part defs (mirrors Concept 1's coverage).
    metadata def EventDispatcherExecutionMeta {
        attribute verified : Boolean;
    }

    metadata EventDispatcherExecutionMeta about CommandArbitrationSoftware { verified = true; }
    metadata EventDispatcherExecutionMeta about MovementControlSoftware { verified = true; }
    metadata EventDispatcherExecutionMeta about ConfigurationManagerSoftware { verified = true; }
    metadata EventDispatcherExecutionMeta about MemoryManagerSoftware { verified = true; }
    metadata EventDispatcherExecutionMeta about MovementSupervisorSoftware { verified = true; }
    metadata EventDispatcherExecutionMeta about MotorDriveControlSoftware { verified = true; }
    metadata EventDispatcherExecutionMeta about UserFeedbackSoftware { verified = true; }

    // =========================================================================
    // Concept 4 -- Single-Owner EEPROM Persistence Access
    // =========================================================================
    doc
    /* Concept: Single-Owner EEPROM Persistence Access.
     * Origin: ProductComponents::MemoryManagerSoftware is the sole firmware
     * module with ports (durationIn/timingOut) touching
     * ControlMCU.internalEepromBytes (ADR-006); no other of the seven
     * firmware modules accesses EEPROM directly. On an 8-bit MCU with no
     * OS-level locking or wear-levelling hardware, funnelling every
     * persistence access through one module avoids concurrent/interleaved
     * EEPROM writes and keeps the wear-levelling/retry policy (if any is
     * later needed) in exactly one place rather than duplicated per caller.
     * Concrete SWA-03 instance: every other module that needs TravelTime data
     * (MovementSupervisorSoftware) goes through MemoryManagerSoftware's
     * durationOut/timingIn flow connections (ProductComponents.sysml,
     * connections 10/11) rather than declaring its own EEPROM-facing port.
     */

    // Checkable marker, applied to the sole owning module (doc above).
    metadata def SingleOwnerEepromMeta {
        attribute verified : Boolean;
    }

    metadata SingleOwnerEepromMeta about MemoryManagerSoftware { verified = true; }
} // package SWCrossCuttingConcepts
