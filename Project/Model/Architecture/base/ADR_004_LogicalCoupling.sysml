/* Architecture Decision Record: ADR-004 — Logical Architecture Coupling Strategy.
 * Documents SYSMOD Tool 11.7 coupling decisions: FA→LA loose (allocation), LA→BA strong specialization for 1:1 counterparts.
 * arc42 section: ARC-09 Architecture Decisions.
 */
package ADR_004_LogicalCoupling {
    private import BaseArchitecture::*;
    private import FunctionalArchitecture::*;
    private import ADR_Common::*;

    package ADR_004 {
        @ArchDecisionMeta {
            decisionId   = "ADR-004";
            title        = "Loose coupling (allocation) between Functional and Logical Architecture; strong coupling (specialization) between Logical and Base Architecture where a 1:1 counterpart exists";
            status       = "accepted";
            context      = "SYSMOD Tool 11.7 requires an explicit coupling decision before Logical Architecture modeling begins; FA-LA coupling is fixed as loose (allocation), while LA-BA coupling is a project choice given that BaseArchitecture::ShutterController already defines five candidate parts established before the functional decomposition.";
            decision     = "(1) FA→LA: loose coupling via allocation def in FunctionalAllocation.sysml. (2) LA→BA: strong coupling (':>') for the four unambiguous 1:1 counterparts (LogicalControlUnit, LogicalMotorDrive, LogicalLocalRequestInterface, LogicalRemoteRequestInterface). (3) BaseArchitecture::PowerModule has no Logical counterpart (physical/product-layer concern only). (4) LogicalMovementSupervisor and LogicalUserNotification are plain 'part def' with no Base counterpart. (5) requestAcquisitionFunctions is split across two Logical components (LogicalLocalRequestInterface + LogicalRemoteRequestInterface), reflecting the Base Architecture's already-separate local/remote parts.";
            consequences = "Changes to the four strongly-coupled Base parts propagate automatically to their Logical counterparts; Functional Architecture changes do not (loose-coupling trade-off requiring manual allocation review). The coupling strategy MUST be re-checked whenever Base or Functional Architecture changes materially.";
            alternatives = "A. Strong-couple every Logical component to a Base part (requires artificial sub-part splits in Base Architecture, which must remain stable — rejected). B. Loose-couple Logical to Base for all components — rejected for the four clear 1:1 cases where strong coupling preserves established design intent.";
            rationale    = "Following Tool 11.7 exactly for the fixed FA-LA loose-coupling rule, while making deliberate per-component LA-BA choices that maximize reuse of the stable Base Architecture and avoid forced specialization for components (movement supervision, notification) that have no Base Architecture precedent.";
        }
    }
} // package ADR_004_LogicalCoupling
