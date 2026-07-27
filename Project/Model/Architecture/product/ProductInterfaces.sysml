/* Product Architecture (SM-PRD-21) — New Interface (Port) Definitions.
 *
 * Introduces ONLY the technology-specific port defs that have no counterpart
 * at any earlier architecture layer, per ADR_006_ProductRealizationStrategy
 * (single-MCU realization) and ADR_007_ProductCoupling. Every other internal
 * interface reuses FunctionalArchitecture's and SystemContext's existing port
 * defs unchanged (ControlCommandPort, MovementRequestPort, StopRequestPort,
 * ShutterStatePort, TravelTimePort, TimingProfilePort, ConfigModeEventPort,
 * ConflictEventPort, DryContactControlPort, ControlPowerPort, MainsPowerPort,
 * ShutterDrivePort) — see ProductComponents.sysml header comment for the
 * full DRY port-reuse rationale (mirrors the same decision already made at
 * the Logical Architecture layer).
 *
 * arc42 section: ARC-05 Building Block View (Product Architecture).
 */
package ProductInterfaces {
    private import SI::*;
    private import ScalarValues::Boolean;

    port def RelayControlPort {
        doc
        /* Carries the two independent, mutually-exclusive low-voltage
         * relay-coil drive signals (UP coil, DOWN coil) from
         * MotorDriveControlSoftware to MotorDriveRelayModule's coil driver
         * stage. Firmware enforces break-before-make (never both true
         * simultaneously) to protect the relay contacts and avoid a
         * momentary mains short; this is a firmware responsibility, not a
         * property of the port type itself. */

        out attribute upCoil : Boolean;
        out attribute downCoil : Boolean;
    }

    port def BuzzerControlPort {
        doc
        /* Carries the single GPIO drive line for the audible buzzer user-
         * feedback element, from UserFeedbackSoftware to
         * AudibleNotificationBuzzer. Software-generated timing (short
         * pulse, repeated pulse, or sustained on patterns) distinguishes
         * configuration-mode activation/deactivation (REQ-F-08) from
         * conflict indication (REQ-S-02) and fault indication (REQ-Q-04);
         * the pattern encoding itself is a firmware concern, not modeled
         * at the port-type level (mirrors how LogicalArchitecture left
         * 'feedbackModality' as a qualitative attribute rather than
         * encoding indication semantics into the port shape).
         * Replaces the former IndicatorControlPort (bi-color LED), per
         * ADR-008 (ADR_008_BuzzerFeedback.sysml). */

        out attribute buzzerOn : Boolean;
    }

    port def LogicPowerRailPort {
        doc
        /* Regulated low-voltage logic supply rail distributed by
         * PowerSupplyModule to every logic-level Product component
         * (ControlMCU, both RequestInterfaceCircuit instances,
         * AudibleNotificationBuzzer, and MotorDriveRelayModule's coil-driver
         * stage). Realizes the "anticipated future ownership" note left in
         * LogicalArchitecture.sysml (controlPower expected to power all
         * seven Logical components) now made concrete at Product
         * Architecture. */

        attribute nominalVoltage = 3.3 [SI::V];
    }

    port def ProgrammingPort {
        doc
        /* In-circuit serial programming/debug connector (e.g., a
         * SWIM/UART-bootloader style single-wire interface) used exclusively
         * during manufacturing test and firmware flashing. Not connected to
         * any other Product component in normal operation -- a documented,
         * intentional gap mirroring the LogicalArchitecture boundary-port
         * "no internal connection" pattern (see ControlMCU.progPort in
         * ProductComponents.sysml). Included to support manufacturability
         * (REQ-Q-01, REQ-Q-05) and production/verification readiness. */

        attribute enabled : Boolean;
    }

    // =========================================================================
    // PA-1 fix (Product Architecture Review, model_issues.md item 18): closes
    // the DiagnosticsSoftware dead-end -- a genuinely new Product-layer-only
    // signal shape (a fault classification result), with no counterpart at
    // any earlier architecture layer, so it is introduced here rather than in
    // DomainKnowledge.sysml (kept untouched, per repair-plan scope: Use Cases/
    // Use Case Activities/Functional/Logical Architecture are NOT modified).
    // =========================================================================

    enum def FaultClass {
        doc
        /* The fault classes DiagnosticsSoftware can structurally distinguish
         * via its input taps. "No power" (REQ-Q-04's first named fault
         * class) is deliberately NOT a member here -- it requires no
         * software classification at all, being inherently and passively
         * observable by the technician as "buzzer entirely silent / no
         * power-on acknowledgment beep" (ADR-008: buzzer replaces former
         * LED; former signal was "indicator entirely dark"). */

        noResponseToControlInput; // commandStateIn reports no arbitrated command observed at all.
        motorDriveFault;          // commandStateIn reports a command WAS received, but diagnosticStateIn
                                   // (inherited ShutterState tap) reports no resulting movement.
    }

    item def FaultIndication {
        doc
        /* Fault classification result produced by DiagnosticsSoftware and
         * consumed by UserFeedbackSoftware, which arbitrates a distinct
         * buzzer beep pattern on the shared active-buzzer indicator alongside
         * normal configuration-mode/conflict feedback (time-multiplexed on
         * the single physical buzzer rather than adding new hardware). Closes
         * the PA-1 Diagnostics dead-end finding. (ADR-008: buzzer replaces
         * former bi-color LED.)
         *
         * CRIT-2 fix (SMRR corrective pass): this is now the Product-layer,
         * technology-committed concretization of DomainKnowledge::
         * FaultIndicationEvent, carried through FunctionalArchitecture::
         * diagnosticsFunctions.faultEventOut and LogicalArchitecture::
         * logicalDiagnostics.faultEventOut/logicalUserNotification.faultEventIn.
         * Previously this item def had no counterpart at any earlier
         * architecture layer; the FA/LA precursor now exists, restoring the
         * top-down Functional → Logical → Product consistency the SMRR
         * required, while this attribute-bearing FaultClass detail remains
         * exclusively a Product-layer concern (no premature technology
         * commitment upstream). */

        attribute faultClass : FaultClass;
    }

    flow def FaultIndicationFlow {
        doc
        /* Carries a FaultIndication from DiagnosticsSoftware to
         * UserFeedbackSoftware (PA-1 fix). */

        end src;
        end tgt;
        ref item :>> payload : FaultIndication;
    }

    port def FaultIndicationPort {
        doc
        /* Carries a typed FaultIndication from DiagnosticsSoftware to
         * UserFeedbackSoftware (PA-1 fix, closes the Diagnostics dead-end
         * finding: model_issues.md item 18 / productArchitectureRepairPlan.md
         * PA-1). UserFeedbackSoftware renders a distinct buzzer beep pattern
         * per FaultClass (ADR-008: buzzer replaces former bi-color LED). */

        out item faultEvent : FaultIndication;
    }
} // package ProductInterfaces
