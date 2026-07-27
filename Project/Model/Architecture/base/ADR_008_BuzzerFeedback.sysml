/* Architecture Decision Record: ADR-008 — User Feedback Modality: Buzzer Only
 *
 * Supersedes ADR-006 sub-decision (6) (LED user feedback), which was accepted
 * on the assumption that a bi-color LED would be user-observable. The physical
 * mounting reality invalidates that assumption: the controller is flush-mounted
 * inside a ⌀60 mm wall box, sealed behind the wall-switch plate (REQ-Q-01,
 * EnclosureAndConnectors). The LED is not visible during any normal or
 * installer interaction; it cannot satisfy REQ-F-08's "clearly signaled to the
 * user" mandate or REQ-S-02's "user-perceivable indication" mandate.
 *
 * arc42 section: ARC-09 Architecture Decisions.
 */
package ADR_008_BuzzerFeedback {
    private import BaseArchitecture::*;
    private import LogicalArchitecture::*;
    private import ADR_006_ProductRealizationStrategy::*;
    // Top-20 fix #17 (finalReviewReport.md corrective pass): 'ArchDecisionMeta'
    // is now declared once in ADR_Common and imported here instead of being
    // re-declared locally -- see that file's header for rationale.
    private import ADR_Common::*;

    package ADR_008 {
        @ArchDecisionMeta {
            decisionId   = "ADR-008";
            title        = "User feedback realized by an active buzzer; bi-color LED removed";
            status       = "accepted";
            supersedes   = "ADR-006 sub-decision (6) only: 'User feedback is realized with a single bi-color (red/green) LED indicator'. All other ADR-006 decisions (single MCU, software modularization, relay switching, dry-contact I/O, internal EEPROM) remain in force.";
            context      = "ADR-006 sub-decision (6) chose a bi-color LED as the user feedback indicator, explicitly rejecting an audible buzzer on residential-noise grounds. This was modeled before the physical mounting was fully evaluated. The controller is flush-mounted inside a standard ⌀60 mm wall box behind the wall-switch plate (EnclosureAndConnectors, REQ-Q-01: 'Flush-mounted ⌀60mm wall box, compatible with standard residential wall-switch installations'). The wall-switch plate is opaque; the LED is entirely hidden from the installer or user standing at the switch. REQ-F-08 requires the controller to be 'clearly signaled to the user' on configuration-mode entry/exit; REQ-S-02 requires a 'distinct, user-perceivable indication' on conflict suppression. A hidden LED satisfies neither. The buzzer is audible through the wall-switch plate without requiring line-of-sight access and without opening the installation.";
            decision     = "Replace the bi-color LED (UserNotificationIndicator, ProductComponents.sysml) with a single active buzzer driven by one MCU GPIO via BuzzerControlPort. The buzzer is the SOLE user feedback channel; no LED is retained. Firmware (UserFeedbackSoftware) generates event-driven beep patterns distinguishing: (a) configuration-mode activation (REQ-F-08), (b) configuration-mode deactivation (REQ-F-08), (c) simultaneous UP+DOWN conflict suppression (REQ-S-02), and (d) DiagnosticsSoftware fault classifications (REQ-Q-04). For REQ-Q-04 'no power' fault class: when the controller has no supply, the buzzer is silent and produces no power-on acknowledgment beep -- a passive audible consequence of powerIn having no supply, requiring no software involvement, and directly analogous to the former 'LED entirely dark' approach. A maintenance technician can also verify supply voltage with a multimeter as a supplementary passive check. The active buzzer (self-oscillating, 3.3V, ~85 dBSPL) requires one MCU GPIO and a small-signal transistor driver; BOM cost is comparable to the LED (~0.5 PLN). The BOM net impact is neutral; the 50 PLN cost target (ADR-001) is not affected.";
            consequences = "1. BuzzerControlPort (ProductInterfaces.sysml) replaces IndicatorControlPort; the port now carries a single 'buzzerOn : Boolean' drive line rather than two separate color lines. UserFeedbackSoftware.indicatorOut port is renamed buzzerOut. ControlMCU saves one GPIO versus the two-GPIO LED scheme, creating additional headroom on the STM8S003F3P6's 15 usable GPIOs. 2. All test cases previously requiring visual observation of an LED indicator must be updated to audible observation of buzzer beep patterns (TC_F_013, TC_S_004, TC_Q_004). The pass/fail criterion structure is unchanged -- only the observation modality changes from visual to auditory. 3. The 'no power' field-diagnosis criterion changes from 'indicator entirely dark' to 'buzzer entirely silent / no power-on acknowledgment beep'. The diagnostic reliability is comparable. 4. UserFeedbackSoftware firmware complexity is slightly reduced (single on/off GPIO vs. two-channel blink pattern encoding), improving the flash/RAM estimate headroom already confirmed by the PA-9 fix. 5. ADR-006's 'D. Audible buzzer' alternative transitions from 'rejected' to 'adopted'.";
            alternatives = "A. Retain the bi-color LED and add a buzzer (combined modality): considered before this ADR and rejected by the product owner -- the LED adds cost (~0.5 PLN), board area, and wiring complexity for zero user-observable benefit given the in-wall mounting, and the buzzer already fully satisfies REQ-F-08/REQ-S-02/REQ-Q-04 alone. B. Retain LED only (no change from ADR-006): rejected -- LED is not observable through an opaque wall-switch plate; cannot satisfy REQ-F-08/REQ-S-02 'user-perceivable' mandate in the production mounting scenario. C. No user feedback hardware (firmware-only status via the existing wall-switch input debounce): rejected -- REQ-F-08 and REQ-S-02 both mandate a positive, distinct observable indication; absence of indication is not compliant.";
            rationale    = "An active buzzer is the simplest, cheapest modification that makes user feedback actually perceivable in the production deployment context. The 'residential noise nuisance' concern cited in ADR-006 alternative D applies to continuous or unprompted noise; event-driven beeps on installer actions and fault conditions are a well-understood and user-accepted feedback pattern in residential appliances (smoke detectors, doorbells, HVAC controllers). The controller is an installer-facing device during configuration; a brief beep sequence on configuration-mode enter/exit is a normal installer workflow cue.";
        }
    }
} // package ADR_008_BuzzerFeedback
