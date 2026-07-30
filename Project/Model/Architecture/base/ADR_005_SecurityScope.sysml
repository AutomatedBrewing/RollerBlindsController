/* Architecture Decision Record: ADR-005 — Security Scope Exclusion
 * No dedicated security requirement or architectural element is introduced because
 * all system interfaces are dry-contact/relay-based with no protocol stack or attack surface.
 * arc42 section: ARC-09 Architecture Decisions.
 */
package ADR_005_SecurityScope {
    private import BaseArchitecture::*;
    private import SystemContext::*;
    private import ADR_Common::*;

    package ADR_005 {
        @ArchDecisionMeta {
            decisionId   = "ADR-005";
            title        = "No dedicated cybersecurity requirement/architecture: all system interfaces are dry-contact/relay-based with no protocol stack";
            status       = "accepted";
            context      = "All three SystemContext external interfaces (WallSwitch, HomeAutomationSystem via dry-contact/relay, PowerSupply) carry no data protocol, network stack, or remotely-exploitable command surface, so no attack surface exists in the conventional cybersecurity sense.";
            decision     = "No SecurityReq category, security use case, or security-specific architectural element is introduced; the absence of a data/network interface is treated as an architectural constraint within L0_Constraints::Architectural scope. This exclusion is explicitly documented so future reviewers can distinguish an intentional scope decision from an oversight.";
            consequences = "No security artifact exists at any model layer; this exclusion is strictly coupled to the dry-contact-only interface assumption and must be revisited if any networked or remotely-addressable interface is introduced.";
            alternatives = "A. Placeholder SecurityReq category: rejected — no current subject matter and an empty template would itself be a reviewable gap (per EnvironmentalReq precedent). B. Undocumented omission: rejected — indistinguishable from an overlooked gap.";
            rationale    = "An explicit, falsifiable trigger condition (any networked/addressable interface) converts an implicit assumption into an auditable architectural decision, consistent with ADR-001 through ADR-004.";
        }
    }

    /* TRIGGER FOR RE-EVALUATION: This ADR must be revisited if any external interface
     * is extended beyond dry-contact/relay to any addressable protocol (network, BLE,
     * OTA firmware update, data-at-rest, or remote configuration channel).
     */
} // package ADR_005_SecurityScope
