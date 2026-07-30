# Remediation Plan — Baseline Readiness

**Based on:** REVIEW_FINDINGS.md
**Status:** ✅ READY for baseline (all 24 action items executed; see final line and
`REVIEW_FINDINGS.md` for per-finding Status)

---

## Phase 1 — Structural Fixes (Critical; must be first, no dependency on later phases)

**1. Fix ConfigureController action flow disconnect (MR-001)**
- **What:** Replace the three anonymous inline actions (`action startCountingTime`, `action openRollerShutter`, `action stopCountingTime`) in the `ConfigureController` succession with the already-declared typed usages (`runOpenMovement`, `countOpenTime`). Update the succession chain to flow through `runOpenMovement` and `countOpenTime` so control flow and object flows are connected.
- **Where:** `UCActivities.sysml` : `action def ConfigureController` body (lines ~376–396).
- **Resolves:** MR-001.

**2. Fix ControllerLifecycle fork-vs-choice bug (MR-002)**
- **What:** Replace the two unconditional `first operate then operateLoop` / `first operate then dispose` successors with a `decide` node that either loops (`then operateLoop`) or exits to `dispose` — two mutually exclusive branches, not a fork.
- **Where:** `SystemProcesses.sysml` : `action def ControllerLifecycle` body.
- **Resolves:** MR-002.

**3. Remove out-of-scope SW-arch imports/links from Traceability, and introduce a local `Trace` connection to replace misused `Derivation` (MR-003, MR-027, folds in MR-006)**
- **What:** (a) Delete the 10 `private import` lines for SW-arch packages and all SW-arch `connection : Derivation connect …` statements at the bottom of the file; replace with one `comment` noting SWA-0x traceability lives in `Architecture/software/`, out of this baseline. (b) `DerivationConnections`/`Derivation` (standard library) formally requires `requirement`-typed ends; nearly every connection in this file links non-requirement elements (use cases, activities, functions, logical/product parts, scenarios, states, test cases). Define one small local `connection def Trace { end sourceElement; end targetElement; }` in `Traceability.sysml` and replace **every** `connection : Derivation connect A to B;` with `connection : Trace connect A to B;` uniformly (simpler than classifying which pairs are "real" requirement derivations vs. not — one connection kind, one rule, easy to understand). Drop the now-unneeded `private import DerivationConnections::*;`. (c) While rewriting, drop the 3 false links for `scen07_ConflictingUpDownCommand_Suppressed` → `logicalUserNotification` / `ControlMCU::userFeedbackSoftware` / `userNotificationBuzzer` (MR-006 — SCEN_07 has no buzzer per its own doc).
- **Where:** `Traceability.sysml` : imports block, new `connection def Trace`, all ~200 connection statements, lines ~373/407-408 for the SCEN_07 links.
- **Resolves:** MR-003, MR-006, MR-027 (MR-004 invalidated — no fix needed for the import itself).

**4. Remove stale DerivationConnections import from Constraints (MR-019; MR-004 needs no fix)**
- **What:** Delete `private import DerivationConnections::*;` from `Constraints.sysml` — confirmed unused in that file (no `Derivation`/`Trace` connection appears there).
- **Where:** `Constraints.sysml` line 7.
- **Resolves:** MR-019.

---

## Phase 2 — Major Structural and Consistency Fixes

**5. Add requirement def layer to Constraints (MR-005)**
- **What:** Add 5 `requirement def` category templates (`BusinessConstraint`, `PhysicalConstraint`, `EnvironmentalConstraint`, `ElectricalConstraint`, `ArchitecturalConstraint`) at the top of `L0_Constraints`, each with `subject controller : BaseArchitecture::ShutterController`. Type all 9 bare requirements by their category. Add stable IDs (`<'CNST-B-01'>`, `<'CNST-P-01'>`, etc.). Do NOT add new content — only add the category headers and type existing usages.
- **Where:** `Constraints.sysml` : all 5 sub-packages.
- **Resolves:** MR-005.

**6.** *(folded into item 3 above — same file, same pass.)*

**7. Add factual (non-invented) gap comments for UC-04 and RISK-T-02 (MR-007, MR-008)**
- **What:** No historical record exists in-model for *why* UC-04/RISK-T-02 are missing, so do not invent a reason (rule: no invented facts). Add a neutral, factual comment stating the numbering gap exists and is intentional-by-observation, so a reader isn't left wondering if content was lost: `// Note: UC-04 is not assigned in this model; numbering continues at UC-05.` / `// Note: RISK-T-02 is not assigned in this register; numbering continues at RISK-T-03.`
- **Where:** `SystemUseCases.sysml` (after UC_03 block, before UC_05 comment); `Risks.sysml::TechnicalRisks` (after RISK-T-01 block, before RISK-T-03).
- **Resolves:** MR-007, MR-008.

**8. Add mitigating requirement for RISK-T-01 (MR-009)**
- **What:** Add a new `requirement <'REQ-F-10'> timingDriftMargin : FunctionalReq` in `Requirements.sysml::Functional` (or promote the existing `MemoryManagerSoftware.timingMarginS = 5.0` attribute to a requirement): "The timing profile stored in non-volatile memory shall include a margin of at least 5 s above the measured travel time to compensate for positioning drift (RISK-T-01)." Add a Traceability derivation link from RISK-T-01 to this new requirement.
- **Where:** `Requirements.sysml`; `Traceability.sysml`.
- **Resolves:** MR-009.

**9. Delete 12 dead state def aliases (MR-010)**
- **What:** Delete all 12 `state def XxxState :> ControllerLifecycleState` declarations (lines 259–271). They are never referenced by any `exhibit state`, usage, or external package.
- **Where:** `SystemStates.sysml` : lines 259–271.
- **Resolves:** MR-010.

**10. Resolve Verification.sysml orphaned defs (MR-011)**
- **What:** Option A (preferred for simplicity): Delete `Verification.sysml` entirely; move the 3 white-box defs from sub-packages `Logical` and `Product` into `SystemTestCases.sysml` as new named packages (`Logical` and `Product`) — they carry unique white-box verify links not present in SystemTestCases. The remaining 12 defs in `Functional`, `Quality`, `Constraints`, `Environmental` are fully subsumed by SystemTestCases and can simply be deleted. Update any imports.
- **Where:** `Verification.sysml` (delete or gutted); `SystemTestCases.sysml` (receive the 6 white-box defs if kept).
- **Resolves:** MR-011.

**11. Delete 3 unreferenced UCActivities package-level action usages (MR-012)**
- **What:** Delete `action collectController : CollectController`, `action disassembleController : DisassembleController`, `action transferToAuthorizedDisposal : TransferToAuthorizedDisposal` from the package-level usage list at the bottom of `UCActivities.sysml`. The traceability endpoint for UC_05 is `UseCaseActivities::disposeController` which is already present.
- **Where:** `UCActivities.sysml` : lines 446–448.
- **Resolves:** MR-012.

---

## Phase 3 — Minor Fixes (apply in one pass after Phase 2)

**12. Fix ADR_008 stale REQ-S-02 reference and buzzer-scope contradiction (MR-013)**
- **What:** `REQ-S-02` does not exist, and the ADR's claim that the buzzer signals "(c) UP+DOWN conflict suppression" contradicts `Scenarios.sysml`'s SCEN_07 (which explicitly states no buzzer fires for conflict suppression — buzzer is config-mode only per REQ-F-08). Remove purpose (c) and every "REQ-S-02" mention from `context`/`decision`/`alternatives`, keeping only the two config-mode purposes (a)/(b), consistent with REQ-F-08 and SCEN_07.
- **Where:** `ADR_008_BuzzerFeedback.sysml` : file-header comment, `ADR_008.context`, `.decision`, `.alternatives`.
- **Resolves:** MR-013.

**13. Fix AudibleNotificationBuzzer doc/attribute contradiction (MR-014)**
- **What:** Change the doc block opening from "Passive piezo/electromagnetic buzzer" to "Active piezo buzzer" to match `buzzerType = "Active (self-oscillating) ..."`.
- **Where:** `ProductComponents.sysml` : `part def AudibleNotificationBuzzer` doc first line.
- **Resolves:** MR-014.

**14. Add gap comments for missing SCEN numbers (MR-015)**
- **What:** After SCEN_17 block add: `// NOTE: SCEN_18–SCEN_20 not assigned (reserved / retired).` After SCEN_23 add: `// NOTE: SCEN_24 not assigned (reserved / retired).`
- **Where:** `Scenarios.sysml` : before SCEN_21 block and before SCEN_25 block.
- **Resolves:** MR-015.

**15. Rename conflicting abstract part def in Taxonomy (MR-016)**
- **What:** Rename `abstract part def BaseArchitecture` to `abstract part def SystemBaseArchitecture` inside `SystemArchitecture_Taxonomy.sysml` (confirmed: no other in-scope file references this taxonomy header directly — every concrete package already imports `::SystemArchitecture` only, per the file's own doc — so this is a zero-risk, purely local rename that permanently removes the name collision instead of relying on a comment to prevent it).
- **Where:** `SystemArchitecture_Taxonomy.sysml` : line 12 and its doc.
- **Resolves:** MR-016.

**16. Add concern def type to ProblemStatement (MR-017)**
- **What:** Wrap `concern NeedForConvenientShutterOperation` in a proper `concern def` + typed usage pattern: add `concern def NeedForConvenientShutterOperationConcern { ... }` and change the bare `concern` to `concern needForConvenientShutterOperation : NeedForConvenientShutterOperationConcern`. Update the `frame` reference in `SystemIdea.sysml`.
- **Where:** `ProblemStatement.sysml`; `SystemIdea.sysml` (frame reference).
- **Resolves:** MR-017.

**17. Add comment for missing unit on manufacturingCost (MR-018)**
- **What:** Add an inline comment clarifying the currency: `attribute manufacturingCost; // unit: PLN (Polish Zloty); no SI unit`. Alternatively, define a simple `attribute def CurrencyPLN` in DomainKnowledge and type the attribute — but a comment is sufficient for baseline.
- **Where:** `Constraints.sysml` : `Business::costEffective`.
- **Resolves:** MR-018.

**18. Delete floating duplicate doc block in LogicalArchitecture (MR-020)**
- **What:** Delete the standalone `doc /* Boundary ports reuse SystemContext port defs ... */` block at lines 31–33. The same information is in the multi-line comment above.
- **Where:** `LogicalArchitecture.sysml` : lines 31–33.
- **Resolves:** MR-020.

**19. Move UserFeedbackSoftware.feedbackTechnology rationale to doc (MR-021)**
- **What:** Shorten `feedbackTechnology` to `"Active buzzer, 3.3V, single GPIO (ADR-008)"`. Move the rationale sentence ("Commits the concrete technology …") to the `part def UserFeedbackSoftware` doc block.
- **Where:** `ProductComponents.sysml` : `UserFeedbackSoftware.feedbackTechnology`.
- **Resolves:** MR-021.

**20. Delete trivial enum literal doc blocks (MR-022)**
- **What:** Delete `doc` blocks for the 7 obvious enum literals: `up`, `down`, `none`, `timeout`, `userRequest`, `local`, `remote`. Keep `doc` blocks for `both` (non-obvious simultaneous-press semantics) and `activated`/`deactivated` (context-specific meaning).
- **Where:** `DomainKnowledge.sysml` : `MovementDirection`, `MovementMode`, `StopReason`, `ChannelSource`.
- **Resolves:** MR-022.

**21. Delete or fill boilerplate placeholder attribute docs in LogicalArchitecture (MR-023)**
- **What:** For each of the 5 `attribute : String` with "Qualitative description … deferred to Product Architecture" doc blocks (`signalInterpretation` ×2, `commandArbitrationPolicy`, `supervisionPrinciple`, `driveSwitchingPrinciple`, `feedbackModality`): either delete the attribute entirely (if truly unused downstream) or replace the placeholder doc with a single concrete sentence (e.g., "First-accepted arbitration between local and remote channels; equal-priority stop for either channel (REQ-F-06)."). Do not leave "deferred" placeholders.
- **Where:** `LogicalArchitecture.sysml`.
- **Resolves:** MR-023.

**22. Shorten SystemObjectives affordability rationale (MR-024)**
- **What:** Replace the `rationale` field content: change "Addresses the cost barrier … not a testable property of a finished unit." to "Addresses the cost barrier identified in ProblemStatement; the specific 50 PLN BOM target is a design constraint, not a testable finished-unit property."
- **Where:** `SystemObjectives.sysml` : `requirement affordability @RequirementMeta.rationale`.
- **Resolves:** MR-024.

**23. Add note closing SCEN_15/16 UCA gap (MR-025)**
- **What:** In `Traceability.sysml` replace the bare `// GAP:` comment for SCEN_15/16 with: `// NOTE: SCEN_15/SCEN_16 have no UCA anchor by design — power-loss/recovery is a hardware electrical property (ADR_002) not modeled in UseCaseActivities; these scenarios exercise the reliability objective directly.`
- **Where:** `Traceability.sysml` : line ~353.
- **Resolves:** MR-025.

**24. Delete RISK-SC-01 project-management risk entry (MR-026)**
- **What:** Delete `package ScheduleRisks { requirement <'RISK-SC-01'> Risk_IsolationComponentSourcingDelay ... }` from `Risks.sysml`. Delete the 5 Derivation connection lines referencing `Risks::ScheduleRisks::Risk_IsolationComponentSourcingDelay` in `Traceability.sysml` (lines ~107–118). Project schedule risks do not belong in the system model.
- **Where:** `Risks.sysml`; `Traceability.sysml` (lines ~107–118).
- **Resolves:** MR-026.

---

## Dependency Notes

- Phase 1 items 1–4 must precede all later work (structural integrity).
- Phase 2 item 5 (add constraint def layer) should precede any new satisfy/verify links for constraints.
- Phase 2 item 10 (Verification.sysml decision) should precede Phase 3 items that reference Verification types.
- All other items are independent.

---

## Execution Result (Pass 2)

All 24 planned action items were executed. Self-verification (re-grep across
`Project/Model`, excluding `Architecture/software/`, for every symbol/name
deleted or renamed during execution) found **zero remaining dangling
references**. See `REVIEW_FINDINGS.md` for the per-finding Status column and
the "Fixes applied beyond the original 26 findings" section for a few
tightly-coupled stale-reference cleanups (prose test-case names, collision
comments, concern usage renames) that were fixed alongside their parent finding.

One item was intentionally left open rather than force-closed with a
fabricated fact: MR-025 (SCEN_15/16 have no matching UCA action) — the
comment was reworded from `GAP:` to a factual `Note:`, but no link was
invented.

**0 Critical / 0 Major / 1 Minor (deferred, documented) open — READY for baseline**
