/* Shared Architecture Decision Record metadata definition.
 *
 * Top-20 fix #17 (finalReviewReport.md corrective pass): 'ArchDecisionMeta'
 * was previously declared independently inside each of ADR_001...ADR_008
 * (8 duplicate metadata defs with an inconsistent attribute set -- some
 * carried 'supersedes'/'supersededBy', some did not, purely as an artifact
 * of copy/paste drift rather than any real per-ADR difference in shape).
 * This file is now the single source of truth: every ADR_0xx package
 * imports it instead of re-declaring its own copy. 'supersedes' and
 * 'supersededBy' are included unconditionally (even for ADRs that
 * currently set neither) so that any future partial-supersession
 * relationship between ADRs can be recorded without having to revisit
 * this shared definition again (MAJ-11 fix precedent: reciprocal
 * supersedes/supersededBy bookkeeping, so a reader of a superseded ADR
 * can find its successor without grepping every other ADR file).
 *
 * arc42 section: ARC-09 Architecture Decisions.
 */
package ADR_Common {

    metadata def ArchDecisionMeta {
        attribute decisionId   : String;
        attribute title        : String;
        attribute status       : String;  // proposed | accepted | deprecated | superseded
        attribute supersedes   : String;
        attribute supersededBy : String;
        attribute context      : String;
        attribute decision     : String;
        attribute consequences : String;
        attribute alternatives : String;
        attribute rationale    : String;
    }
} // package ADR_Common
