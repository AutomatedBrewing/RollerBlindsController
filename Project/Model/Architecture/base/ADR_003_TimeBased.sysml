/* Architecture Decision Record: ADR-003 — Time-Based Positioning (No Position Sensor)
 *
 * Documents the fundamental architectural decision that the controller
 * operates without position feedback from the shutter, using configured
 * travel-time timeouts instead of a position sensor.
 * arc42 section: ARC-09 Architecture Decisions.
 */
package ADR_003_TimeBased {
    private import BaseArchitecture::*;
    private import L0_Constraints::*;
    private import L0_Requirements::*;
    // Top-20 fix #17 (finalReviewReport.md corrective pass): 'ArchDecisionMeta'
    // is now declared once in ADR_Common and imported here instead of being
    // re-declared locally -- see that file's header for rationale.
    private import ADR_Common::*;

    package ADR_003 {
        @ArchDecisionMeta {
            decisionId   = "ADR-003";
            title        = "Time-based shutter positioning with no position sensor";
            status       = "accepted";
            context      = "SystemObjectives::rollerShutterCompatibility requires support for a wide range of roller shutter motors. Adding a position sensor (reed switch, encoder, or limit-switch) would require per-motor mechanical adaptation, increasing installation complexity and cost. L0_Constraints::Architectural::noPositionFeedback and timeBasedOperation formalize this constraint. RISK-T-01 (positioning drift) is an accepted residual risk under this architecture.";
            decision     = "The controller shall determine shutter position solely by timing motor run duration. Two independently configurable travel times — opening time and closing time — are calibrated during installation (REQ-F-07 configurableTimingProfile, UC_03 ConfigureController) and stored in non-volatile memory (memoryFunctions FE). At runtime, movementSupervisionFunctions uses the stored timing profile as the automatic-mode movement timeout (via SuperviseMovementStop / loadTimingProfile). The controller makes no assumption about absolute shutter position between power cycles.";
            consequences = "1. Position accuracy degrades if the motor stalls, the power is interrupted mid-travel, or the shutter is manually overridden — residual risk RISK-T-01 (positioning drift) is accepted and documented in Risks.sysml. 2. All movement-stop logic (MonitorStopCondition, SuperviseMovementStop) relies exclusively on the stored timeout; no hardware limit-switch or torque-overload detection is required or expected. 3. REQ-F-05 (manualPositioning) provides a user-initiated partial-travel capability as a mitigation for the absence of position feedback. 4. Future introduction of a position sensor would require this ADR to be superseded and a new FE added to FunctionalArchitecture.";
            alternatives = "A. Reed-switch end-stop sensors: low-cost, binary (open/closed only), requires per-installation mechanical mounting. B. Motor-current stall detection: detects end-of-travel without a sensor, but adds current-sensing circuitry and firmware. C. Encoder-based absolute positioning: highest accuracy, incompatible with the cost constraint (ADR-001). All alternatives deferred pending field data on drift rates.";
            rationale    = "Time-based operation is the established low-cost standard for residential roller shutter controllers. It eliminates all sensor wiring, reduces installation time (supports REQ-Q-01 easeOfInstallation ≤30 min), and makes the controller compatible with any standard AC-motor shutter type (SystemObjectives::rollerShutterCompatibility). The positioning-drift risk is acceptable given the residential use case (the user can trivially correct drift by performing a full-travel calibration run).";
        }
    }
} // package ADR_003_TimeBased
