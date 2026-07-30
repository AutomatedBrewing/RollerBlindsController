/* Shared Architecture Decision Record metadata definition.
 * Centralised here (DRY) so all ADR_0xx packages import a single consistent definition.
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
