/* Architecture Decision Record: ADR-005 — Security Scope Exclusion
 *
 * Documents why no dedicated security requirement, use case, or architectural
 * element exists for the Window Roller Shutter Controller, and the explicit
 * trigger condition under which this exclusion must be re-evaluated. Added to
 * close a Phase 12 (Model Completeness) gap identified in the system model
 * review: "security concerns" had no corresponding artifact anywhere in the
 * model, and no ADR previously stated whether this was an intentional scope
 * decision or an unaddressed gap.
 *
 * arc42 section: ARC-09 Architecture Decisions.
 */
package ADR_005_SecurityScope {
    private import BaseArchitecture::*;
    private import SystemContext::*;
    // Top-20 fix #17 (finalReviewReport.md corrective pass): 'ArchDecisionMeta'
    // is now declared once in ADR_Common and imported here instead of being
    // re-declared locally -- see that file's header for rationale.
    private import ADR_Common::*;

    package ADR_005 {
        @ArchDecisionMeta {
            decisionId   = "ADR-005";
            title        = "No dedicated cybersecurity requirement/architecture: all system interfaces are dry-contact/relay-based with no protocol stack";
            status       = "accepted";
            context      = "System model review (Phase 12, Model Completeness) flagged 'security concerns' as an uncovered completeness dimension, with no requirement, use case, constraint, or ADR anywhere in the model addressing it. SystemContext defines exactly three external interfaces: WallSwitch (dry-contact, local), HomeAutomationSystem (dry-contact/relay, remote per L0_Requirements::Interface::remoteControlWiringCompatibility), and PowerSupply (electrical, not data). None of these interfaces carries a data protocol, network stack, addressable identity, or remotely-exploitable command surface -- HomeAutomationSystem integration is a simple dry-contact relay closure, functionally indistinguishable from a physical switch (see Requirements.sysml REQ-F-02/remoteControl and Context.sysml). There is therefore no attack surface in the conventional cybersecurity sense (no authentication, no network stack, no firmware update channel, no data at rest/in transit).";
            decision     = "No dedicated SecurityReq requirement category, no security use case, and no security-specific architectural element are introduced. The absence of a data/network interface is treated as an architectural constraint satisfied by the existing L0_Constraints::Architectural scope (dry-contact-only, no position feedback, time-based operation) rather than requiring a new, separate security-scoped artifact chain. This decision is EXPLICITLY DOCUMENTED (rather than left as a silent omission) precisely so that future reviewers do not need to re-derive whether the omission was intentional.";
            consequences = "1. No security requirement, use case, activity, function, logical/product component, or test case exists or is expected at any layer of this model as currently scoped. 2. This decision is NOT permanent: it is strictly coupled to the dry-contact-only interface assumption. 3. Documentation burden: every future SystemContext or Requirements.sysml change touching HomeAutomationSystem or introducing any new external interface MUST re-open this ADR before being accepted.";
            alternatives = "A. Introduce a placeholder SecurityReq category now, pending a future networked interface -- rejected as speculative/over-engineered: SYSMOD discourages introducing requirement categories with no current subject matter, and a template with no concrete usage would itself be flagged as an unjustified element in a future review (mirroring the EnvironmentalReq precedent, which was introduced only once a concrete requirement, REQ-E-01, existed to populate it). B. Silently leave the gap undocumented (the prior state) -- rejected: this is exactly the completeness gap the system model review identified as a finding, since a reviewer cannot distinguish 'intentionally out of scope' from 'overlooked'.";
            rationale    = "Recording an explicit, falsifiable trigger condition (any networked/addressable/remotely-programmable interface) for revisiting this decision converts an implicit assumption into an auditable architectural decision, consistent with how ADR-001 through ADR-004 already document similarly load-bearing, revisitable assumptions (cost constraint, availability target, time-based operation, logical coupling strategy) for this project.";
        }
    }

    /* TRIGGER FOR RE-EVALUATION (explicit, falsifiable):
     * This ADR MUST be revisited -- and a SecurityReq requirement category,
     * corresponding use case(s), and architecture elements introduced -- the
     * moment ANY of the following becomes true:
     *   1. HomeAutomationSystem integration is extended beyond a dry-contact
     *      relay closure to any addressable network protocol (e.g., IP, BLE,
     *      Zigbee, Wi-Fi, Matter).
     *   2. A remote/over-the-air firmware update mechanism is introduced.
     *   3. Any data-at-rest (e.g., stored credentials, usage logs sent
     *      off-device) or data-in-transit capability is introduced.
     *   4. A remote diagnostic/configuration interface (beyond the existing
     *      physical wall-switch-based UC_03 ConfigureController) is
     *      introduced.
     */
} // package ADR_005_SecurityScope
