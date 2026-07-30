/* Software Deployment View (SWA-05) — validates the aggregate firmware
 * footprint against ControlMCU's actual resource budget, and enumerates the
 * MCU resources (GPIO pins, timer peripheral) that ADR-SW-009/ADR-SW-010
 * explicitly deferred here. Continues Product Architecture (SM-PRD-21) below
 * the hardware-topology level. arc42 section: ARC-07 Deployment View
 * (software-level "Infrastructure Level 2" detail).
 *
 * Per crossmapping Traceability Rule 1, the flash/RAM totals below are the
 * SAME aggregate-sum formula already declared as a "preview check" in
 * SWConstraints::Resource::flashBudget/ramBudget (SWA-01) — this file
 * promotes that check to authoritative status by reporting the actual
 * computed totals/margins, per SWA-01's own doc ("the authoritative,
 * as-linked footprint check happens in the Software Deployment View,
 * SWA-05"). No figure is independently re-estimated (Rule 1); the 10% margin
 * matches SWA-01's declared fraction exactly (Rule "margin MUST match").
 */
package SWResourceBudget {
    private import ProductComponents::*;
    private import SWBuildingBlocks::*;
    private import Stakeholders::*;

    // ── Execution-context placement (crossmapping §2 mapping table row 3;
    // mandatory here per Traceability Rule 3, since ADR-SW-009's execution
    // model uses five interrupt sources -- one movement-supervision timer
    // plus four GPIO change-notification lines -- not a plain superloop) ──
    metadata def ExecutionContext {
        attribute context : String; // "main-loop" | "isr:timerTick" | "isr:gpioChangeNotification"
    }

    /* ADR-SW-009 deliberately keeps every ISR body minimal (flag/timestamp/
     * counter updates only) and NOT modeled as its own action def -- there is
     * therefore nothing at the SWA-03 internal-action level to tag
     * "isr:timerTick" or "isr:gpioChangeNotification"; those two interrupt
     * sources are enumerated as raw MCU peripheral/pin resources below
     * instead. Every internal action currently modeled in SWBuildingBlocks.sysml
     * (confirmLocalUp/Down, confirmRemoteUp/Down, arbitrateChannels,
     * translateCommand, and the exhibited lifecycle state machine's own
     * entry/do/exit actions) executes in dispatcher (main-loop) context,
     * never inside an ISR (ADR-SW-009's decision). */
    metadata ExecutionContext about commandArbitrationSoftwareInternal {
        context = "main-loop";
    }
    metadata ExecutionContext about movementControlSoftwareInternal {
        context = "main-loop";
    }
    metadata ExecutionContext about movementSupervisorSoftwareInternal {
        context = "main-loop";
    }

    // The 3 driver-owning internals added by the prior remediation pass were left untagged. None of
    // motorRelayOutputDriver/buzzerOutputDriver/eepromDriver is an ISR source --
    // ADR-SW-009's only 2 interrupt sources (movement timer, 4 GPIO change-
    // notification inputs) are both input-side; these 3 are pure outputs/RW
    // access invoked from dispatcher context, never from an ISR.
    metadata ExecutionContext about motorDriveControlSoftwareInternal {
        context = "main-loop";
    }
    metadata ExecutionContext about userFeedbackSoftwareInternal {
        context = "main-loop";
    }
    metadata ExecutionContext about memoryManagerSoftwareInternal {
        context = "main-loop";
    }

    // ── Flash/RAM resource budget (authoritative) ────────────────────────────
    requirement resourceBudgetReport {
        subject mcu : ProductComponents::ControlMCU;
        stakeholder manufacturer : Stakeholders::Manufacturer;

        doc
        /* Authoritative flash/RAM footprint check (SWA-05), computed from the
         * seven firmware part usages' current estimatedFlashBytes/
         * estimatedRamBytes on mcu (ProductComponents.sysml): commandArbitrationSoftware
         * (1200B flash / 48B RAM), movementControlSoftware (400B / 16B),
         * configurationManagerSoftware (700B / 24B), memoryManagerSoftware
         * (900B / 32B), movementSupervisorSoftware (1000B / 40B),
         * motorDriveControlSoftware (600B / 24B), userFeedbackSoftware
         * (800B / 32B). Current totals: 5600B flash of a 14745.6B budget
         * (16KB * 90%, ~9145.6B margin) and 216B RAM of a 921.6B budget
         * (1024B * 90%, ~705.6B margin) -- both comfortably within budget.
         */

        attribute flashSafetyMarginFraction : Real = 0.10;
        attribute ramSafetyMarginFraction : Real = 0.10;

        attribute computedFlashTotalBytes : Natural =
            mcu.commandArbitrationSoftware.estimatedFlashBytes
            + mcu.movementControlSoftware.estimatedFlashBytes
            + mcu.configurationManagerSoftware.estimatedFlashBytes
            + mcu.memoryManagerSoftware.estimatedFlashBytes
            + mcu.movementSupervisorSoftware.estimatedFlashBytes
            + mcu.motorDriveControlSoftware.estimatedFlashBytes
            + mcu.userFeedbackSoftware.estimatedFlashBytes;

        attribute computedRamTotalBytes : Natural =
            mcu.commandArbitrationSoftware.estimatedRamBytes
            + mcu.movementControlSoftware.estimatedRamBytes
            + mcu.configurationManagerSoftware.estimatedRamBytes
            + mcu.memoryManagerSoftware.estimatedRamBytes
            + mcu.movementSupervisorSoftware.estimatedRamBytes
            + mcu.motorDriveControlSoftware.estimatedRamBytes
            + mcu.userFeedbackSoftware.estimatedRamBytes;

        attribute flashBudgetBytes : Real =
            mcu.flashSizeKB * 1024 * (1.0 - flashSafetyMarginFraction);
        attribute ramBudgetBytes : Real =
            mcu.internalRamBytes * (1.0 - ramSafetyMarginFraction);

        require constraint { computedFlashTotalBytes <= flashBudgetBytes }
        require constraint { computedRamTotalBytes <= ramBudgetBytes }

        frame manufacturer.costConcern;
    }

    // ── GPIO pin assignment ──────────────────────────────────────────────────
    requirement gpioPinAssignment {
        subject mcu : ProductComponents::ControlMCU;
        stakeholder manufacturer : Stakeholders::Manufacturer;

        doc
        /* Of mcu.gpioCount (14 pins): 4 are the ADR-SW-010 change-notification
         * inputs (localRawIn.up, localRawIn.down, remoteRawIn.up,
         * remoteRawIn.down -- mcu.inputChangeNotificationGpioCount); 2 drive
         * RelayControlPort's upCoil/downCoil signals (motorDriveControlSoftware.
         * relayOut); 1 drives BuzzerControlPort's buzzerOn signal
         * (userFeedbackSoftware.buzzerOut). That is 3 of the 10 GPIOs
         * outside the change-notification 4, leaving 7 of those 10 for
         * progPort (production-only SWIM/UART bootloader, ADR-006) and
         * design margin.
         */

        require constraint {
            2 + 1 <= mcu.gpioCount - mcu.inputChangeNotificationGpioCount
        }

        frame manufacturer.costConcern;
    }

    // ── Timer / peripheral usage ──────────────────────────────────────────────
    requirement timerPeripheralUsage {
        subject mcu : ProductComponents::ControlMCU;
        stakeholder user : Stakeholders::User;

        doc
        /* A single periodic timer peripheral, ticking at
         * mcu.movementSupervisorSoftware.timerResolutionMs (10ms, ADR-003/
         * ADR-SW-009), is the only timer resource required: it drives both
         * movement-timeout/hold-to-run supervision (MovementSupervisorSoftware)
         * and the superloop's periodic re-check of any pending
         * ConfirmInputDebounce stableDurationMs bookkeeping (ADR-SW-010) --
         * no second timer peripheral is needed. Combined with the four GPIO
         * change-notification interrupts (gpioPinAssignment above), this MCU
         * uses exactly five interrupt sources in total, matching ADR-SW-009's
         * decision that these are the only interrupt sources in the system.
         */

        frame user.reliabilityConcern;
    }
} // package SWResourceBudget
