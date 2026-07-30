/* Architecture Decision Record: ADR-008 — User Feedback Modality: Buzzer Only
 * Supersedes ADR-006 sub-decision (6): the controller is flush-mounted inside a ⌀60 mm wall box
 * behind an opaque plate, making the LED non-observable and unable to satisfy REQ-F-08.
 * arc42 section: ARC-09 Architecture Decisions.
 */
package ADR_008_BuzzerFeedback {
    private import BaseArchitecture::*;
    private import LogicalArchitecture::*;
    private import ADR_006_ProductRealizationStrategy::*;
    private import ADR_Common::*;

    package ADR_008 {
        @ArchDecisionMeta {
            decisionId   = "ADR-008";
            title        = "User feedback realized by an active buzzer; bi-color LED removed";
            status       = "accepted";
            supersedes   = "ADR-006 sub-decision (6) only: 'User feedback is realized with a single bi-color (red/green) LED indicator'. All other ADR-006 decisions (single MCU, software modularization, relay switching, dry-contact I/O, internal EEPROM) remain in force.";
            context      = "ADR-006 sub-decision (6) chose a bi-color LED before the physical mounting was fully evaluated; the controller is flush-mounted inside a ⌀60 mm wall box (REQ-Q-01) behind an opaque plate, hiding the LED entirely, so it cannot satisfy REQ-F-08 ('clearly signaled to the user').";
            decision     = "Replace the bi-color LED with a single active buzzer (self-oscillating, 3.3V, ~85 dBSPL, one MCU GPIO via BuzzerControlPort) as the sole user feedback channel. UserFeedbackSoftware generates event-driven beep patterns for: (a) configuration-mode activation (REQ-F-08), (b) configuration-mode deactivation (REQ-F-08). BOM cost is comparable to the LED (~0.5 PLN); the 50 PLN target (ADR-001) is not affected.";
            consequences = "BuzzerControlPort replaces IndicatorControlPort (single 'buzzerOn : Boolean' line; ControlMCU saves one GPIO); test case TC_F_013 updates observation modality from visual to auditory.";
            alternatives = "A. Retain LED and add buzzer: rejected — LED provides zero user-observable benefit in-wall; buzzer alone satisfies REQ-F-08. B. Retain LED only: rejected — not observable through opaque wall-switch plate. C. No feedback hardware: rejected — REQ-F-08 mandates a positive, distinct observable indication of configuration-mode activation/deactivation.";
            rationale    = "An active buzzer is the simplest, cheapest change making feedback perceivable in the production mounting context; event-driven beeps on installer/fault events are a well-accepted pattern in residential appliances (smoke detectors, doorbells, HVAC controllers).";
        }
    }
} // package ADR_008_BuzzerFeedback
