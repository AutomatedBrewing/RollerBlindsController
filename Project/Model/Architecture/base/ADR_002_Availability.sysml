/* Architecture Decision Record: ADR-002 — Availability Mechanism.
 * Documents how REQ-Q-02 (≥99.8% availability) is realized by hardware MTBF rather than a behavioral sub-system.
 * arc42 section: ARC-09 Architecture Decisions.
 */
package ADR_002_Availability {
    private import BaseArchitecture::*;
    private import L0_Requirements::*;
    private import ADR_Common::*;

    /* REQ-Q-02 (≥99.8% availability) is an emergent hardware property realized at the Physical
     * Architecture layer by component selection, not by a dedicated functional element. */
    package ADR_002 {
        @ArchDecisionMeta {
            decisionId   = "ADR-002";
            title        = "Availability realized by relay-hardware MTBF, not by a behavioral sub-system";
            status       = "accepted";
            context      = "REQ-Q-02 mandates ≥99.8% availability over 12 months; the controller has no OS, firmware scheduler, or software parts, and its primary failure mode is relay wear-out (RISK-T-03), bounded by REQ-Q-03 (≥10000 cycle endurance).";
            decision     = "Availability is satisfied passively by selecting relays and passive components with MTBF ratings implying <0.2% downtime at the expected cycle rate (≤3650 cycles/year, well within the 10000-cycle endurance of REQ-Q-03); no dedicated 'availabilityFunctions' FE is introduced — the requirement is allocated to Physical Architecture component selection.";
            consequences = "No behavioral trace exists from REQ-Q-02 through functional architecture (intentional, documented here); Physical Architecture review must verify component MTBF against the 99.8% target, and a new ADR shall be raised if a self-test or watchdog mechanism is later introduced.";
            alternatives = "A. 'selfTestFunctions' FE with power-on diagnostics (deferred until a concrete circuit is designed). B. Express availability as a product-level MTBF constraint (loses the time-window semantics of REQ-Q-02).";
            rationale    = "The controller's availability is dominated by relay contact life, not software fault management; introducing a behavioral FE without a concrete circuit design would be premature, and REQ-Q-03's 10000-cycle endurance provides the primary life-budget baseline.";
        }

        /* Satisfy the requirement at the system level per Traceability.sysml convention
         * (canonical satisfy statement is in Traceability::Traceability to preserve the import hierarchy). */
        comment
        /* REQ-Q-02 is satisfied by BaseArchitecture::ShutterController via component MTBF
         * selection; see Traceability::Traceability for the canonical satisfy statement. */
    }
} // package ADR_002_Availability
