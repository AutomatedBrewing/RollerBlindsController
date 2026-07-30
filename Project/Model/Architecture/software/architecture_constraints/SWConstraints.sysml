/* Software Architecture Constraints (SWA-01) — non-negotiable resource,
 * execution-model, timing, and toolchain conditions that bound the internal
 * firmware design space, derived from ProductComponents::ControlMCU's
 * attribute values and from Base Architecture constraints that also bind
 * the software. Mirrors the Architecture/base/Constraints.sysml pattern
 * (requirement usages with subject/doc/require constraint), NOT the generic
 * constraint def + @ConstraintMeta pattern used elsewhere.
 * arc42 section: ARC-02 Architecture Constraints (software-specific sub-section).
 */
package SWConstraints {
    private import ProductComponents::*;
    private import Stakeholders::*;
    private import L0_Constraints::*;
    private import SystemStates::*;

    package Resource {
        requirement flashBudget {
            subject mcu : ProductComponents::ControlMCU;
            stakeholder manufacturer : Stakeholders::Manufacturer;

            doc
            /* Aggregate estimatedFlashBytes of the seven firmware modules
             * must stay within mcu.flashSizeKB, minus flashSafetyMarginFraction
             * for bootloader/toolchain overhead. Preview check only —
             * authoritative footprint check is the Deployment View (SWA-05).
             */

            attribute flashSafetyMarginFraction : Real = 0.10;

            require constraint {
                mcu.commandArbitrationSoftware.estimatedFlashBytes
                + mcu.movementControlSoftware.estimatedFlashBytes
                + mcu.configurationManagerSoftware.estimatedFlashBytes
                + mcu.memoryManagerSoftware.estimatedFlashBytes
                + mcu.movementSupervisorSoftware.estimatedFlashBytes
                + mcu.motorDriveControlSoftware.estimatedFlashBytes
                + mcu.userFeedbackSoftware.estimatedFlashBytes
                <= mcu.flashSizeKB * 1024 * (1.0 - flashSafetyMarginFraction)
            }

            frame manufacturer.costConcern;
        }

        requirement ramBudget {
            subject mcu : ProductComponents::ControlMCU;
            stakeholder manufacturer : Stakeholders::Manufacturer;

            doc
            /* Aggregate estimatedRamBytes of the seven firmware modules must
             * stay within mcu.internalRamBytes, minus ramSafetyMarginFraction
             * for call stack/toolchain overhead. Preview check only —
             * authoritative footprint check is the Deployment View (SWA-05).
             */

            attribute ramSafetyMarginFraction : Real = 0.10;

            require constraint {
                mcu.commandArbitrationSoftware.estimatedRamBytes
                + mcu.movementControlSoftware.estimatedRamBytes
                + mcu.configurationManagerSoftware.estimatedRamBytes
                + mcu.memoryManagerSoftware.estimatedRamBytes
                + mcu.movementSupervisorSoftware.estimatedRamBytes
                + mcu.motorDriveControlSoftware.estimatedRamBytes
                + mcu.userFeedbackSoftware.estimatedRamBytes
                <= mcu.internalRamBytes * (1.0 - ramSafetyMarginFraction)
            }

            frame manufacturer.costConcern;
        }

        requirement memoryDiscipline {
            subject mcu : ProductComponents::ControlMCU;
            stakeholder manufacturer : Stakeholders::Manufacturer;

            doc
            /* No dynamic (heap) allocation; call-stack depth must be bounded
             * by design (no unbounded/data-dependent recursion) — verified
             * by static analysis, since mcu has no MMU/stack-guard hardware
             * or runtime stack monitoring.
             */
        }
    } // package Resource

    package ExecutionModel {
        requirement noRtosAvailable {
            subject mcu : ProductComponents::ControlMCU;
            stakeholder manufacturer : Stakeholders::Manufacturer;

            doc
            /* costEffective (ADR-001) already rules out an RTOS-capable MCU
             * upgrade; no RTOS/scheduler is available on mcu.mcuFamily.
             * Execution model is therefore restricted to bare-metal designs
             * (see ADR-SW-009).
             */

            frame manufacturer.costConcern;
        }

        requirement dispatcherDeterminism {
            subject mcu : ProductComponents::ControlMCU;
            stakeholder user : Stakeholders::User;

            doc
            /* The event dispatcher (ADR-SW-009) must preserve the
             * determinism already established by SystemStates::
             * ControllerLifecycleState (Rule 6 — mutually exclusive guards
             * per triggering event): at most one transition may fire for a
             * given state/event.
             */

            frame user.reliabilityConcern;
        }
    } // package ExecutionModel

    package Timing {
        requirement isrLatencyBudget {
            subject mcu : ProductComponents::ControlMCU;
            stakeholder user : Stakeholders::User;

            doc
            /* Fixes the ISR execution-time budget as a fraction of the tick
             * period (design target only — the former
             * `isrExecutionBudgetMs < timerResolutionMs` check was tautological
             * for any fraction < 1, since isrExecutionBudgetMs is *derived from*
             * timerResolutionMs by the same multiplication; no measured/estimated
             * ISR execution-time attribute exists in this model to check against
             * — that measurement is SDD/implementation-verification scope). ISR
             * bodies stay flag/timestamp-only (ADR-SW-009/010) to make meeting
             * this budget plausible by construction.
             */

            attribute isrBudgetFraction : Real = 0.10;
            attribute isrExecutionBudgetMs : Real =
                mcu.movementSupervisorSoftware.timerResolutionMs * isrBudgetFraction;

            // Checks the fraction itself is a genuine budget (open interval),
            // not a tautology about the derived attribute.
            require constraint {
                isrBudgetFraction > 0.0 and isrBudgetFraction < 1.0
            }

            frame user.reliabilityConcern;
        }
    } // package Timing

    package Toolchain {
        requirement codingStandardConstraint {
            subject mcu : ProductComponents::ControlMCU;
            stakeholder manufacturer : Stakeholders::Manufacturer;

            doc
            /* Coding standard/subset (e.g. MISRA-C) not yet selected for
             * firmware on mcu — placeholder open item, to be resolved in
             * SWA-02 or a dedicated ADR before Phase 4 (internal
             * decomposition) produces implementation-level detail.
             */
        }
    } // package Toolchain
} // package SWConstraints
