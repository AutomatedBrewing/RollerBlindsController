# arc42 Documentation Review Report (RollerBlindsController)

**System:** Window Roller Shutter Controller (WRSC) — `BaseArchitecture::ShutterController`

**Scope:** All 12 files in `Project/Documentation/arc42/`, reviewed against
every `.sysml` file under `Project/Model/**` (including
`Architecture/software/`), per `.github/prompts/generate-arc42-docs.prompt.md`.

**Method:** Adversarial re-read of each `arc42/*.md` file against its cited
model source, reading `.sysml` files directly (not trusting prior review
docs) and checking: (1) **Traceability** — every ID/name/value cited resolves
to a real model element; (2) **Completeness** — every requirement,
constraint, ADR, risk, verification def, and test case in the model is
represented somewhere in `arc42/`; (3) **Consistency** — no section
contradicts another section or the model.

This review supersedes the previous (now-stale) version of this report,
which predated both the `model/` → `Project/Model/` folder reorganization
and the entire Software Architecture (`Architecture/software/`) addition.

---

# Executive Summary

## Overall Assessment

An earlier design iteration included several model elements — a
`MaintenanceTechnician` stakeholder, `REQ-S-02`/`REQ-Q-04`/`REQ-Q-05`,
`UC_04`, a `DiagnosticsSoftware`/`LogicalDiagnostics` component, and a
standalone `Verification.sysml` file — that were later removed or folded
into other files during model baseline cleanup. The arc42 documentation set
had not been regenerated to match, and had accumulated other independent
drift (wrong counts, a fabricated runtime scenario, stale attribute values,
and an orphaned finding-ID citation scheme matching none of this repo's
three real tracking logs). This pass found and corrected that drift across
all 12 files.

**Verdict: ACCEPTED. Zero Critical, zero Major findings remain.**

## Current Model Counts (verified against `.sysml` sources)

| Model artifact | Count | Notes |
|---|---|---|
| Requirements | 17 | REQ-F-01..10, REQ-I-01/02, REQ-Q-01..03, REQ-S-01, REQ-E-01 |
| Constraint usages (`L0_Constraints`) | 9 | CNST-B-01, CNST-P-01, CNST-E-01, CNST-EL-01..04, CNST-A-01/02 |
| Architecture Decisions | 11 | 8 base (ADR-001..008) + 3 software (ADR-SW-009..011) |
| Risks | 7 | RISK-T-01/03/04/05, RISK-S-01, RISK-B-01, RISK-I-01 (no `RISK-T-02`, gap in numbering only) |
| Stakeholders | 4 | Manufacturer, User, Installer, DisposalFacility |
| Use Cases | UC_01 (5 variants a–e), UC_02, UC_03, UC_05 | UC_04 not assigned |
| Functional Elements | 8 | `FunctionalArchitecture::RollerShutterControllerFunctions` |
| Logical components | 6 | `LogicalArchitecture` |
| Product components (top-level) | 7 | `ProductArchitecture::RollerShutterControllerProductComponents` |
| Firmware modules | 7 | Hosted on `ControlMCU` |
| Scenarios | 21 | `SCEN_01`–`17`, `21`–`23`, `25` (`SCEN_18`–`20`, `SCEN_24` not assigned) |
| State machines | 1 (dual-hosted) | `ControllerLifecycleState`, exhibited at both Logical and Product/Software layers |
| Test cases (`SystemTestCases`) | 37 | Functional 14, Safety 6, Quality 3, Environmental 1, Boundary 7, Negative 6 |
| Component-scoped (white-box) verification defs | 8 | 5 `Logical`, 3 `Product` |
| Domain item/flow/enum defs | 19 | 5 enums, 7 item defs, 7 flow defs |

---

## Findings Table (this pass)

| ID | Severity | Files | Finding | Resolution |
|---|---|---|---|---|
| DOC-01 | Critical | All 12 (except this file) | 42 occurrences of the stale `` `model/... ` `` path prefix, predating the `Project/Model/` folder reorganization. | Mechanical, verified find/replace to `` `Project/Model/... ` ``. |
| DOC-02 | Critical | `01`, `03`, `10` | Fabricated `MaintenanceTechnician` stakeholder and `REQ-Q-04`/`REQ-Q-05`/`REQ-S-02` requirements — none exist in `Stakeholders.sysml`/`Requirements.sysml`. | Removed the stakeholder row, requirement rows, and every dependent reference (quality-goal table, verification tables, test-case counts). |
| DOC-03 | Critical | `04`, `05`, `08`, `09`, `12` | Wrong element counts throughout: 9→8 Functional Elements, 7→6 Logical components, 8→7 firmware modules, 9-FE→8-FE. | Corrected every occurrence; cross-checked against `FunctionalArchitecture.sysml`, `LogicalArchitecture.sysml`, `ProductComponents.sysml`. |
| DOC-04 | Critical | `05` | Fabricated action `DetermineMovementRequestFE`, fabricated `conflictOut` port, fabricated `MoveShutterToClosePosition` action, and a `timeCountingFunctions` realization (`CheckTravelTimeInRange`) not actually present in `FunctionalArchitecture.sysml`. | Removed/corrected all four; fixed the `movementSupervisionFunctions` and `memoryFunctions` port lists to match the real model. |
| DOC-05 | Critical | `06` | An entire fabricated "Scenario 9" (`SCEN_24`/`TimingProfileReadFailure`) — `SCEN_24` is not assigned in `Scenarios.sysml`. | Removed the scenario and renumbered the subsequent two; rebuilt the header's scenario-range citation (25→21 scenarios) and the "Documented Open Gaps" section from the real `// GAP:` comments. |
| DOC-06 | Major | `06`, `08` | Stale attribute values: `arbitrationWindowMs` (50ms, real value 100ms), `calibrationHoldThresholdS` (3.0s, real value 5.0s), and state name `AssessingSimultaneousHoldState` (real name `AssessingSimultaneousHold`). | Corrected all three throughout. |
| DOC-07 | Major | `06` | Wrong gate name `openRangeGuard` — the real gate in `Scenarios.sysml`/`UCActivities.sysml` is `checkOpenTimeInRange`. | Corrected. |
| DOC-08 | Major | `07`, `08`, `09` | Buzzer described as "passive" in three files; the real `AudibleNotificationBuzzer` is an active, self-oscillating piezo buzzer (ADR-008). A matching "passive piezo buzzer" comment was also found in `ProductArchitecture.sysml` itself (model-side, comment-only). | Corrected all doc occurrences and the model comment. |
| DOC-09 | Major | `08`, `09` | ADR-008 rendered with two fabricated buzzer purposes ("conflict indication" REQ-S-02, "fault indication" REQ-Q-04) that don't exist; the buzzer's only real purpose is configuration-mode activation/deactivation (REQ-F-08). | Corrected in both files. |
| DOC-10 | Major | `07` | `SWResourceBudget.sysml`'s own GPIO-accounting comment was internally inconsistent (stated math implying 7 GPIOs remained after quoting a sum of 3 used, then said "leaving 3"). Model-side comment bug, not a doc-staleness issue. | Fixed the comment in `SWResourceBudget.sysml` (no structural/constraint change) and the doc passage that faithfully rendered the same error. |
| DOC-11 | Major | `10`, `11` | The entire "Verified by" / mitigation columns cited a `Verification.sysml` file and verification-def names (`VerifyReliability`, `VerifySupplyVoltageRange`, `VerifyDiagnosability`, `VerifyConflictNotification`, etc.) that no longer exist — `Verification.sysml` was folded into `SystemTestCases.sysml` during a prior baseline pass. | Replaced every citation with the real `SystemTestCases::TC_*` names; rewrote the Quality Requirements, Quality Scenarios, and Test Case Register tables; fixed a genuine test-case misattribution (`TC_S_004` verifies REQ-F-08's local-only config gate, not a fabricated `conflictSuppressionBeepCount` conflict-indication attribute). |
| DOC-12 | Major | `07`, `11` | `RISK-SC-01` (a Schedule-category risk) does not exist in `Risks.sysml` — only 7 risks are modeled. | Removed the risk row/reference from both files; corrected risk-count claims from 8 to 7. |
| DOC-13 | Major | `11` | The Technical Debt / Documented Open Gaps table misattributed a `// GAP:` comment to `SCEN_07` (no gap exists there) and to the nonexistent `SCEN_24`; it omitted the three real gaps at `SCEN_15`, `SCEN_16`, `SCEN_17`; and it under-counted `SCEN_23`'s gap (recorded three times in the model, not twice). | Rebuilt the table from the actual `// GAP:` comments in `Scenarios.sysml`. |
| DOC-14 | Minor | `01`, `05`, `08`, `09`, `10`, `11`, `12` | Orphaned finding-ID tags (`M2`, `M3`, `MAJ-8`, `PA-2`, `PA-4`, `PA-6`, `PA-9`, `MAJOR-2`, `SR-8`, `CRIT-4`, `C8`) cited throughout, matching none of this repo's three real tracking schemes (`review-report.md`'s own IDs, `Project/Model/REVIEW_FINDINGS.md`'s `MR-*`, `Architecture/software/REVIEW_FINDINGS.md`'s `SWR-*`). | Removed all instances; kept the underlying factual content plainly stated. Real, verifiable `SWR-*` citations (e.g. `SWR-037`, `SWR-027`) were left in place. |
| DOC-15 | Minor | `01`, `12` | Missing content: `REQ-F-09`/`REQ-F-10` were absent from the requirements table; `ChannelSource` enum and `ControlCommand.source` attribute were absent from the glossary. | Added both. |
| DOC-16 | Minor | `08` | Concepts 9–11 (Single Shared Timing Source, Event-Dispatcher Execution, Single-Owner EEPROM) omitted their checkable `@metadata` marker names. | Added `SharedTimingSourceMeta`/`EventDispatcherExecutionMeta`/`SingleOwnerEepromMeta` mentions, each with its real applied-to component list. |
| DOC-17 | Minor | `11` | The deferred ADR prose-tightening item (`SWR-027`, explicitly deferred per `Architecture/software/REMEDIATION_PLAN.md` item 17) had zero representation in the Technical Debt section. | Added a "Software Architecture Technical Debt" entry. |

---

## Phase-by-Phase Findings

### Phase 1 — Traceability

Every requirement, constraint, ADR, risk, verification-def, and test-case ID
cited across all 12 files was checked directly against its `.sysml` source
(`grep`/`Select-String`, cross-checked with direct file reads where the
search tooling returned inconsistent results on some files). All citations
now resolve to real model elements; the previously-fabricated IDs and names
listed in the Findings Table above were the only discrepancies found.

### Phase 2 — Completeness

Every requirement, constraint, ADR, risk, and test case in the model is now
represented in `arc42/` (see the Current Model Counts table above for exact
figures cross-referenced to the relevant section). `REQ-F-09`/`REQ-F-10`
(previously omitted) and the software-side technical-debt item (previously
unrepresented) were the two completeness gaps found and closed.

### Phase 3 — Consistency

- ADR-001/ADR-006/ADR-008 supersede language is stated identically across
  `02`, `04`, `05`, `09` — consistent.
- Buzzer active/passive characterization is now consistent across `07`, `08`,
  `09`, and the model itself (`ProductComponents.sysml`,
  `ProductArchitecture.sysml`).
- `arbitrationWindowMs`/`calibrationHoldThresholdS` values are now consistent
  across `06` and `08`.
- The `noPositionFeedback`/`timeBasedOperation` architectural principle is
  described consistently across `02`, `04`, `06` (SCEN_17), `08` (Concept 2),
  and `11` (RISK-T-01), with no conflicting framing.
- No section describes a removed/superseded element (`DiagnosticsSoftware`,
  `LogicalDiagnostics`, `Verification.sysml`, `RISK-SC-01`, `SCEN_24`) as
  currently existing — every remaining mention is an explicit "this no
  longer exists" clarification.

---

## Conclusion

Seventeen findings (5 Critical, 8 Major, 4 Minor) were identified during this
adversarial review pass and corrected directly in the 12 `arc42/*.md` files.
Two of these findings also required a comment-only fix to the underlying
`.sysml` model (`SWResourceBudget.sysml`'s GPIO-accounting comment,
`ProductArchitecture.sysml`'s buzzer-characterization comment) — in both
cases the model's actual structure/constraints were already correct; only
the prose explanation was wrong. No requirement, constraint, ADR, risk, or
test case was added, removed, or reinterpreted in the model itself.

With all findings resolved and zero Critical/Major findings remaining, the
arc42 documentation set is:

**VERDICT: ACCEPTED**
