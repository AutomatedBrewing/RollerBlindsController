/* Architecture Decision Record: ADR-006 — Product Realization Strategy
 * (Control Platform, Software Modularization, Memory, Motor Drive, Feedback)
 *
 * Documents the concretization decisions made while deriving the Product
 * Architecture (SM-PRD-21) from the validated Logical Architecture
 * (SM-PRD-20), per KnowledgeSource/integration/crossmapping/
 * product-architecture.md §5 step 1. PARTIALLY SUPERSEDES
 * ADR_001_CostConstraint's "no microcontroller" sub-decision -- all other
 * ADR-001 decisions (relay-based motor switching, dry-contact-only I/O,
 * compact single-PCB form factor, 50 PLN BOM target) remain in force and are
 * reaffirmed here.
 *
 * arc42 section: ARC-09 Architecture Decisions.
 */
package ADR_006_ProductRealizationStrategy {
    private import BaseArchitecture::*;
    private import LogicalArchitecture::*;
    private import ADR_001_CostConstraint::*;
    // Top-20 fix #17 (finalReviewReport.md corrective pass): 'ArchDecisionMeta'
    // is now declared once in ADR_Common and imported here instead of being
    // re-declared locally -- see that file's header for rationale. The
    // 'supersedes'/'supersededBy' bookkeeping below (MAJ-11 fix) is
    // unaffected: partial supersession -- mirrors 'supersedes' so a reader
    // of the superseded ADR can find its (partial) successor without having
    // to grep every other ADR file for a 'supersedes' reference back to it.
    private import ADR_Common::*;

    package ADR_006 {
        @ArchDecisionMeta {
            decisionId   = "ADR-006";
            // MAJ-11 fix: "seven" corrected to "eight" -- the decision text below
            // lists CommandArbitrationSoftware, MovementControlSoftware,
            // MotorDriveControlSoftware, ConfigurationManagerSoftware,
            // MemoryManagerSoftware, DiagnosticsSoftware, UserFeedbackSoftware
            // (7) PLUS MovementSupervisorSoftware (8) = eight firmware components,
            // matching ProductComponents.sysml's actual part defs.
            title        = "Product Architecture realized with a single low-cost 8-bit microcontroller hosting eight modular firmware components; relay-based motor switching and dry-contact-only I/O (ADR-001) reaffirmed unchanged";
            status       = "accepted";
            supersedes   = "ADR-001's 'no microcontroller — timer IC or discrete RC circuit' clause only; all other ADR-001 decisions (relay switching, dry-contact I/O, compact single-PCB form factor, 50 PLN BOM target) remain in force.";
            // MAJ-11 fix: reciprocal supersededBy bookkeeping -- ADR-006's own
            // sub-decision (6) (LED feedback) is itself partially superseded by
            // ADR-008, exactly as already narrated in prose in 'decision' below
            // and in ADR-008's 'supersedes' field; this attribute makes that
            // relationship queryable metadata instead of prose-only.
            supersededBy = "ADR-008 (partial: sub-decision (6) 'bi-color LED user feedback' only; all other ADR-006 decisions -- single MCU, eight-module software modularization, relay switching, dry-contact I/O, internal EEPROM -- remain in force and are unaffected by ADR-008).";
            context      = "LogicalArchitecture.sysml's formal review (FIRM PRODUCT-ARCHITECTURE FOLLOW-UP note on LogicalControlUnit) requires Product Architecture to explicitly re-evaluate whether LogicalControlUnit's four concentrated Functional Elements (requestAcquisitionFunctions arbitration sub-behavior, controlLogicFunctions, configurationControlFunctions, memoryFunctions) should be split into separately replaceable/testable product components before the design is finalized -- this is a mandatory design-review checkpoint, not optional. Realizing arbitration, UP+DOWN conflict detection, configuration-mode state management (REQ-F-08), persisted timing-profile storage/retrieval (REQ-F-07), timer-based movement supervision (ADR-003), and field diagnostics (REQ-Q-04) purely with discrete timer ICs (555-class) and RC networks, as ADR-001 originally proposed, would require a large, fragile, hard-to-verify discrete part count and cannot practically support configuration-mode calibration or fault classification. Ultra-low-cost 8-bit MCUs suitable for this class of product (e.g., STM8S003F3P6-class, TSSOP-20, ~15 usable GPIOs, 16 KB flash, internal EEPROM) are now available at price points (~1-2 PLN in volume) far below the ~5-8 PLN increment ADR-001 originally estimated for MCU adoption, materially changing the cost trade-off ADR-001 was based on.";
            decision     = "(1) Adopt ONE low-cost 8-bit microcontroller (ProductComponents::ControlMCU, representative part STM8S003F3P6-class) as the single shared compute platform for all non-electromechanical logical behavior. (2) Address the LogicalControlUnit concentration concern NOT by fragmenting the hardware BOM (which would add cost and connectors) but by SOFTWARE modularization: eight independently-designed, independently-testable firmware components run on the one MCU — CommandArbitrationSoftware, MovementControlSoftware, MotorDriveControlSoftware, ConfigurationManagerSoftware, MemoryManagerSoftware, DiagnosticsSoftware, UserFeedbackSoftware, and MovementSupervisorSoftware (see ProductComponents.sysml for full responsibilities and ports). This achieves the replaceability/testability goal the Logical Architecture review demanded, at the unit level of firmware modules rather than physical parts, while keeping the hardware BOM at its simplest (a single MCU package). (3) The persisted TravelTime (REQ-F-07) is stored in the MCU's own internal EEPROM (emulated or native), eliminating the need for a discrete external EEPROM/FRAM chip. (4) Motor switching remains strictly relay-based (reaffirms ADR-001): the MCU only issues low-voltage relay-coil drive signals; it never switches mains power directly. (5) All external interfaces remain dry-contact/relay-only (reaffirms ADR-001 and ADR-005): the MCU adds no protocol stack, no network interface, and no remote firmware-update channel. (6) User feedback is realized with a single bi-color (red/green) LED indicator driven by two MCU GPIOs with software-generated blink patterns, rather than an audible buzzer, to avoid residential noise nuisance while still providing the distinct, user-perceivable indication required by REQ-S-02 and the two REQ-F-08 configuration-mode transition notifications. NOTE: this sub-decision (6) is superseded by ADR-008 (ADR_008_BuzzerFeedback.sysml), which replaces the LED with an active buzzer after determining that the in-wall flush mounting makes the LED entirely non-observable.";
            consequences = "1. Firmware verification (unit + integration test of the eight software components) becomes a required, additional verification activity not previously anticipated by ADR-001 — Test Architecture (SM-PRD-24) must account for this. 2. BOM impact is small and remains within the 50 PLN target: representative delta is approximately +1.5-3 PLN versus the original discrete-timer concept (MCU + supporting passives), offset by removing the discrete timer IC, counter ICs, and any external EEPROM that a discrete design would otherwise require — net BOM impact assessed as neutral-to-favorable; final confirmation remains a BOM review action per ADR-001. 3. In-circuit programming/debug access (ProductInterfaces::ProgrammingPort) must be provided as a production test point, per manufacturability. 4. This ADR does not reopen ADR-005 (Security Scope Exclusion): the MCU firmware has no data/network interface, no addressable identity, and no remote update channel, so the ADR-005 trigger conditions remain unmet. 5. Any future proposal to add a position sensor, communication protocol stack, or over-the-air firmware update must reopen ADR-003 and/or ADR-005 respectively, independent of this ADR.";
            alternatives = "A. Retain ADR-001's original discrete timer-IC/RC-network approach: rejected — cannot practically realize configuration-mode state management, persisted multi-parameter timing profiles, first-wins arbitration with conflict detection, and field-fault classification without an impractical discrete part count and near-zero testability. B. Leave LogicalControlUnit's four-FE concentration unaddressed (no re-split of any kind): rejected — directly contradicts the mandatory Logical Architecture review checkpoint. C. Physically split LogicalControlUnit's responsibilities across multiple separate MCU packages (one per FE cluster): rejected — adds BOM cost, board area, and inter-chip communication complexity with no corresponding safety or reliability benefit at this product's scale and criticality level. D. Audible buzzer instead of / in addition to LED feedback: NOW ADOPTED (buzzer only, LED removed) — see ADR-008 (ADR_008_BuzzerFeedback.sysml) for full rationale. The original rejection reasoning (residential nuisance-noise) applied to continuous noise; event-driven beeps are user-accepted. The LED was subsequently found to be non-observable from outside the flush in-wall enclosure, making it unsuitable as the sole feedback channel.";
            rationale    = "A single low-cost MCU with clearly separated firmware modules is the most cost-effective way to satisfy the Logical Architecture's explicit, mandatory re-evaluation requirement: it delivers separately verifiable/replaceable software units (addressing the testability concern) without the added connector, board-area, and BOM cost of physically fragmenting the control hardware. This is consistent with how real low-cost residential shutter-timer products are commonly realized today, and preserves every other ADR-001 decision (relay switching, dry-contact I/O, compact form factor, cost target) unchanged.";
        }
    }
} // package ADR_006_ProductRealizationStrategy
