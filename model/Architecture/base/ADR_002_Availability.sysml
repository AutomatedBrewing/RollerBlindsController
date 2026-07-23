/* Architecture Decision Record: ADR-002 — Availability Mechanism
 *
 * Addresses the traceability review finding that REQ-Q-02 (≥99.8% availability)
 * has no behavioral chain: no use case, no use-case activity, and no functional
 * architecture element realizes it. This ADR documents the architectural decision
 * that achieves the availability target without requiring a dedicated behavioral
 * sub-system.
 *
 * arc42 section: ARC-09 Architecture Decisions.
 */
package ADR_002_Availability {
    private import BaseArchitecture::*;
    private import L0_Requirements::*;
    // Top-20 fix #17 (finalReviewReport.md corrective pass): 'ArchDecisionMeta'
    // is now declared once in ADR_Common and imported here instead of being
    // re-declared locally -- see that file's header for rationale.
    private import ADR_Common::*;

    /* ADR-002: Availability through component selection and relay-based hardware.
     *
     * REQ-Q-02 requires ≥99.8% operational availability over a rolling 12-month
     * period. This requirement is an emergent property of hardware MTBF rather
     * than a behavioral algorithm; it is therefore realized at the Physical
     * Architecture layer (component selection) rather than by a dedicated
     * functional element at the Functional Architecture layer.
     *
     * The decision below documents this explicitly so that:
     * (a) future architects understand why no 'availabilityFunctions' FE exists, and
     * (b) the Physical Architecture / BOM review has a traceable obligation to verify
     *     that selected components support the MTBF target implied by REQ-Q-02.
     */
    package ADR_002 {
        @ArchDecisionMeta {
            decisionId   = "ADR-002";
            title        = "Availability realized by relay-hardware MTBF, not by a behavioral sub-system";
            status       = "accepted";
            context      = "REQ-Q-02 mandates ≥99.8% availability (uptime over 12 months). The ShutterController contains no operating system, no reprogrammable firmware scheduler, and no moving software parts. Its primary failure mode is relay wear-out (RISK-T-03: ≥10000 cycles per REQ-Q-03). No self-healing, failover, or watchdog architecture is planned at this stage.";
            decision     = "Availability (REQ-Q-02) is satisfied passively: by selecting relays and passive components with MTBF ratings that imply <0.2% downtime over 12 months at the expected cycle rate (≤10 cycles/day × 365 days = ≤3650 cycles/year, well within the 10000-cycle endurance of REQ-Q-03). No dedicated 'availabilityFunctions' Functional Element is introduced; the requirement is allocated to the Physical Architecture component-selection activity. A future power-on self-test FE may be introduced in Logical/Product Architecture if field data shows component failure rates above the threshold.";
            consequences = "1. No behavioral trace from REQ-Q-02 through Use Cases / Use Case Activities / Functional Architecture (intentional gap, documented here). 2. Physical Architecture review MUST verify component MTBF against the 99.8% target. 3. If a self-test or watchdog mechanism is added in Logical/Product Architecture, a new ADR shall supersede this one and a 'selfTestFunctions' FE shall be added to FunctionalArchitecture.";
            alternatives = "A. Add a 'selfTestFunctions' FE performing power-on diagnostics (increases model complexity; deferred until a concrete self-test circuit is designed). B. Express availability as a product-level MTBF constraint (loses the time-window semantics of REQ-Q-02).";
            rationale    = "The controller is a simple relay-switching device. Availability is dominated by hardware reliability (relay contact life) rather than software or system-level fault management. Introducing a behavioral FE without a concrete circuit design would be premature and speculative. The 10000-cycle endurance guarantee of REQ-Q-03 provides the primary life-budget baseline.";
        }

        /* Satisfy the requirement at the system level per Traceability.sysml convention
         * (the satisfy statement here is a documentation cross-reference; the canonical
         * satisfy is in Traceability::Traceability so that the import hierarchy is not
         * disturbed). */
        comment
        /* REQ-Q-02 is satisfied by BaseArchitecture::ShutterController via
         * component MTBF selection — see Traceability::Traceability satisfy statement
         * and this ADR for justification. */
    }
} // package ADR_002_Availability
