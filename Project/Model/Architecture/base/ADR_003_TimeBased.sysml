/* Architecture Decision Record: ADR-003 — Time-Based Positioning (No Position Sensor).
 * Documents the decision to determine shutter position by motor run-time timing rather than a position sensor.
 * arc42 section: ARC-09 Architecture Decisions.
 */
package ADR_003_TimeBased {
    private import BaseArchitecture::*;
    private import L0_Constraints::*;
    private import L0_Requirements::*;
    private import ADR_Common::*;

    package ADR_003 {
        @ArchDecisionMeta {
            decisionId   = "ADR-003";
            title        = "Time-based shutter positioning with no position sensor";
            status       = "accepted";
            context      = "SystemObjectives::rollerShutterCompatibility requires support for a wide range of motors; adding a position sensor would require per-motor mechanical adaptation, increasing cost and complexity. L0_Constraints::Architectural::noPositionFeedback and timeBasedOperation formalize this, with RISK-T-01 (positioning drift) accepted as residual.";
            decision     = "Shutter position is determined solely by timing motor run duration; two configurable travel times (opening/closing, REQ-F-07, UC_03) are stored in non-volatile memory and used by movementSupervisionFunctions as the movement timeout at runtime, with no assumption about absolute shutter position between power cycles.";
            consequences = "Position accuracy degrades on motor stall, mid-travel power interruption, or manual override (RISK-T-01 accepted); REQ-F-05 (manualPositioning) mitigates the absence of feedback, and future introduction of a position sensor would require a superseding ADR and a new FE in FunctionalArchitecture.";
            alternatives = "A. Reed-switch end-stop sensors: low-cost, binary, requires per-installation mechanical mounting. B. Motor-current stall detection: no sensor but adds current-sensing circuitry and firmware. C. Encoder-based absolute positioning: highest accuracy but incompatible with ADR-001 cost constraint.";
            rationale    = "Time-based operation is the established low-cost residential standard: it eliminates sensor wiring, supports REQ-Q-01 (installation ≤30 min), and is compatible with any standard AC-motor shutter; positioning-drift risk is acceptable and trivially corrected by a full-travel calibration run.";
        }
    }
} // package ADR_003_TimeBased
