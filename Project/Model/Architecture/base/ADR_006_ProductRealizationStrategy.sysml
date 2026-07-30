/* Architecture Decision Record: ADR-006 — Product Realization Strategy
 * Documents Product Architecture concretization from the Logical Architecture (SM-PRD-21 from SM-PRD-20);
 * partially supersedes ADR-001's "no microcontroller" sub-decision; all other ADR-001 decisions remain in force.
 * arc42 section: ARC-09 Architecture Decisions.
 */
package ADR_006_ProductRealizationStrategy {
    private import BaseArchitecture::*;
    private import LogicalArchitecture::*;
    private import ADR_001_CostConstraint::*;
    private import ADR_Common::*;

    package ADR_006 {
        @ArchDecisionMeta {
            decisionId   = "ADR-006";
            title        = "Product Architecture realized with a single low-cost 8-bit microcontroller hosting seven modular firmware components; relay-based motor switching and dry-contact-only I/O (ADR-001) reaffirmed unchanged";
            status       = "accepted";
            supersedes   = "ADR-001's 'no microcontroller — timer IC or discrete RC circuit' clause only; all other ADR-001 decisions remain in force.";
            supersededBy = "ADR-008 (partial: sub-decision (6) 'bi-color LED user feedback' only; all other ADR-006 decisions remain in force).";
            context      = "Realizing arbitration, configuration-mode management, persisted timing profiles, and movement supervision with discrete timer ICs (ADR-001 original proposal) would require an impractically large discrete part count; ultra-low-cost 8-bit MCUs (~1-2 PLN) are now available well below ADR-001's original cost estimate, materially changing the cost trade-off.";
            decision     = "(1) Adopt one low-cost 8-bit MCU (ProductComponents::ControlMCU, STM8S003F3P6-class) as the shared compute platform. (2) Address LogicalControlUnit concentration via software modularization: seven firmware modules — CommandArbitrationSoftware, MovementControlSoftware, MotorDriveControlSoftware, ConfigurationManagerSoftware, MemoryManagerSoftware, UserFeedbackSoftware, MovementSupervisorSoftware. (3) TravelTime (REQ-F-07) stored in MCU internal EEPROM; no discrete external EEPROM needed. (4) Motor switching remains relay-based (ADR-001). (5) All interfaces remain dry-contact/relay-only (ADR-001, ADR-005). (6) User feedback via bi-color LED — superseded by ADR-008 (active buzzer replaces LED after in-wall mounting makes LED non-observable).";
            consequences = "Firmware verification of the seven software modules becomes a required additional activity (Test Architecture SM-PRD-24 must account for this); BOM impact is neutral-to-favorable versus the discrete-timer concept; ProductInterfaces::ProgrammingPort must be provided; ADR-005 is not reopened (MCU adds no network interface or remote update channel).";
            alternatives = "A. Retain discrete timer-IC/RC-network approach: rejected — cannot practically realize configuration-mode management, persisted timing profiles, or arbitration with conflict detection. B. Leave LogicalControlUnit concentration unaddressed: rejected — contradicts the mandatory Logical Architecture review checkpoint. C. Physically split control across multiple MCU packages: rejected — adds BOM cost and inter-chip complexity with no benefit at this product scale. D. Audible buzzer (instead of LED): adopted via ADR-008 — LED was found non-observable in the flush in-wall enclosure.";
            rationale    = "A single low-cost MCU with separated firmware modules satisfies the Logical Architecture's mandatory re-evaluation requirement (separately verifiable software units) without fragmenting hardware, preserving every other ADR-001 decision unchanged.";
        }
    }
} // package ADR_006_ProductRealizationStrategy
