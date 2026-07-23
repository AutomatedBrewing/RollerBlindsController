/* Architecture Decision Record: ADR-001 — Cost Constraint Realization
 *
 * Documents how the affordability system objective and the L0_Constraints
 * cost constraint are realized at the architecture level.
 * arc42 section: ARC-09 Architecture Decisions.
 */
package ADR_001_CostConstraint {
    private import BaseArchitecture::*;
    private import L0_Constraints::*;
    private import SystemObjectives::*;
    // Top-20 fix #17 (finalReviewReport.md corrective pass): 'ArchDecisionMeta'
    // is now declared once in ADR_Common and imported here, instead of being
    // re-declared locally -- see that file's header for rationale. The
    // 'supersededBy' bookkeeping below (MAJ-11 fix) is unaffected: ADR-001's
    // own "no microcontroller" sub-decision is partially superseded by
    // ADR-006 (see that file's 'supersedes' field and prose below); recorded
    // here so ADR-001 is not silently left looking un-superseded when read
    // in isolation.
    private import ADR_Common::*;

    package ADR_001 {
        @ArchDecisionMeta {
            decisionId   = "ADR-001";
            title        = "Cost target (< 50 PLN BOM) driven by architectural simplicity: no MCU, relay-based switching, dry-contact interfaces";
            status       = "accepted";
            // MAJ-11 fix: only the "no microcontroller" clause of this decision is
            // superseded; relay-based switching, dry-contact-only I/O, compact
            // form factor, and the 50 PLN BOM target itself all remain in force
            // per ADR-006's own 'supersedes' text -- kept consistent with that
            // wording rather than duplicating/rewriting the rationale here.
            supersededBy = "ADR-006 (partial: 'no microcontroller — timer IC or discrete RC circuit' clause only; all other decisions in this ADR -- relay-based motor switching, dry-contact I/O, compact single-PCB form factor, 50 PLN BOM target -- remain in force and are unaffected by ADR-006).";
            context      = "SystemObjectives::affordability mandates that the controller be affordable for any end user. L0_Constraints::Business::costEffective caps manufacturing cost at 50 PLN per unit. The cost constraint has no L0_Requirements usage and therefore does not appear in the standard satisfy/verify chain; it is managed as a design constraint at the BOM level.";
            decision     = "Achieve the 50 PLN BOM target by selecting the simplest viable hardware architecture: (1) No microcontroller — time-based movement control is implemented with a timer IC or discrete RC circuit; (2) Relay-based motor switching — avoids expensive power MOSFETs or thyristors; (3) Dry-contact I/O only — eliminates protocol-stack ICs (Zigbee, Z-Wave, etc.) and their licensing costs; (4) Compact single-PCB form factor fitting a ⌀60 flush-mounted box — minimizes PCB area and enclosure cost. This directly enables the 'no position sensor' architectural constraint (ADR-003) which further reduces BOM.";
            consequences = "1. BOM must be reviewed at each prototype iteration against the 50 PLN target. 2. Any MCU, protocol chip, or position sensor added in future iterations must be justified against the cost constraint and may require this ADR to be revised or superseded. 3. L0_Constraints::Physical::compactDimensions (40×40×20 mm) is a derived constraint of the same cost-driven decision.";
            alternatives = "A. Use a low-cost MCU (e.g., STM32G0 ~2 PLN): adds flexibility but increases BOM by ~5–8 PLN and requires firmware development. B. Use thyristor switching: cheaper at volume but requires snubber design and increases PCB area. Selected approach deferred to Physical Architecture phase.";
            rationale    = "Relay + timer IC is the lowest-cost architecture that satisfies all functional requirements (REQ-F-01..08) without protocol complexity. The 50 PLN target was set based on comparable residential shutter controller retail prices; this architecture achieves it with margin.";
        }

        comment
        /* L0_Constraints::Business::costEffective is verified by BOM cost review
         * during Physical Architecture / product design review. No formal
         * verification def is required by the methodology for cost constraints
         * (cost is not testable on a finished device; it is verified at procurement). */
    }
} // package ADR_001_CostConstraint
