/* Architecture Decision Record: ADR-001 — Cost Constraint Realization.
 * Documents architectural decisions that realize the affordability objective and 50 PLN BOM target.
 * arc42 section: ARC-09 Architecture Decisions.
 */
package ADR_001_CostConstraint {
    private import BaseArchitecture::*;
    private import L0_Constraints::*;
    private import SystemObjectives::*;
    private import ADR_Common::*;

    package ADR_001 {
        @ArchDecisionMeta {
            decisionId   = "ADR-001";
            title        = "Cost target (< 50 PLN BOM) driven by architectural simplicity: no MCU, relay-based switching, dry-contact interfaces";
            status       = "accepted";
            // MAJ-11: only the "no microcontroller" clause is superseded; all other decisions remain in force.
            supersededBy = "ADR-006 (partial: 'no microcontroller' clause only; relay switching, dry-contact I/O, PCB form factor, and 50 PLN BOM target remain in force).";
            context      = "SystemObjectives::affordability requires the controller to be affordable; L0_Constraints::Business::costEffective caps manufacturing cost at 50 PLN/unit, managed as a BOM-level design constraint outside the standard satisfy/verify chain.";
            decision     = "Achieve the 50 PLN BOM target via the simplest viable hardware: no microcontroller (timer IC or discrete RC timing), relay-based motor switching, dry-contact-only I/O (no protocol chips), and a compact single-PCB form factor fitting a ⌀60 flush-mounted box.";
            consequences = "BOM must be reviewed at each prototype iteration; any MCU, protocol chip, or position sensor added later must be justified against the cost constraint and may require this ADR to be revised or superseded.";
            alternatives = "A. Low-cost MCU (e.g., STM32G0 ~2 PLN): adds flexibility but raises BOM by ~5–8 PLN and requires firmware. B. Thyristor switching: cheaper at volume but requires snubber design and larger PCB area.";
            rationale    = "Relay + timer IC is the lowest-cost architecture satisfying all functional requirements without protocol complexity; the 50 PLN target is achievable with margin relative to comparable residential shutter controller retail prices.";
        }

        comment
        /* L0_Constraints::Business::costEffective is verified by BOM cost review at the
         * Physical Architecture phase (cost is not testable on a finished device; verified at procurement). */
    }
} // package ADR_001_CostConstraint
