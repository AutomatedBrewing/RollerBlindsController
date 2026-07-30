---
description: "Picky, exhaustive review of the whole Project/Model/ SysML v2 model (excluding Architecture/software/, which is out of SYSMOD process scope) — checks structural correctness, flags over-engineering, and checks every description is short and easy to understand. Then plans and executes fixes, looping review→fix until the model is simple, compact, and baseline-ready with zero Critical/Major findings. Read-write."
---

# Review Model for Baseline Readiness

Act as an extremely picky senior systems engineer preparing this model for a
baseline release. The goal is a model that is **correct, simple, compact, and
easy to understand** — not a model with maximum ceremony. Prefer removing or
merging elements over adding new ones. Every finding and every fix must be
short and concrete.

## Scope

**In scope** — everything under `Project/Model/` except `Architecture/software/`:
`Analysis/` (problem, stakeholders, risks, requirements, context, use_cases,
processes, use_case_activities, domain), `Architecture/base/`,
`Architecture/functional/`, `Architecture/logical/`, `Architecture/product/`,
`Architecture/states/`, `Architecture/scenarios/`, `Verification/test_cases/`,
`Traceability/`.

**Out of scope** — `Architecture/software/` (all subfolders, all ADR-SW-0xx).
Firmware-internal decomposition is governed separately by
`review-software-architecture.prompt.md` /
`implement-software-architecture-remediation.prompt.md` and is not part of
the core SYSMOD process outputs this baseline covers. Do not read, cite, or
edit anything under `Architecture/software/`.

## Step 0 — Load context (mandatory, in order)

1. `Project/Model/README.md` — folder structure and rationale.
2. `.github/copilot-instructions.md` and
   `.github/instructions/sysml-modeling.instructions.md` — binding modeling
   rules for every edit.
3. `KnowledgeSource/integration/index.md` and
   `KnowledgeSource/integration/okf-ontology.md` — ontology, required import
   matrix (§6.3), decomposition levels (§7).
4. Every in-scope `.sysml` file listed above, in SYSMOD order: problem →
   stakeholders → risks → requirements → context → use_cases → processes →
   use_case_activities → domain → base architecture (+ ADR_001–008,
   Constraints, SystemArchitecture_Taxonomy) → functional → logical
   (+ FunctionalAllocation) → product (+ ProductInterfaces,
   LogicalToProductAllocation) → states → scenarios → verification
   (Verification, SystemTestCases) → traceability.

## Step 1 — Review checklist (log EVERY finding — do not silently skip)

For each finding record: `ID` (`MR-NNN`), `Severity`, `Area`, `File:Element`,
one-line `Finding`, one-line `Impact`.

**Severity**: `Critical` = structurally wrong, unresolved reference, or
SysML v2 rule violation; `Major` = real gap, duplication, or over-engineering
that must simplify before baseline; `Minor` = wording/consistency/style nit.

### A. SysML v2 & Structural Compliance
- Explicit imports present everywhere per the import matrix; no unresolved
  types.
- No SysML v1 constructs (`block`, `actor`, `Association Block`, `IBD`,
  `BDD`); actors modeled as `part def`; proxy ports (`port def`) only.
- Two-layer requirement pattern respected (`requirement def` template vs.
  `requirement` usage); `satisfy`/`verify` target usages only, never bare
  defs.
- `perform action` used to reference use case/action defs, not re-declared
  unnecessarily.
- Every cross-package reference (subject redefinition, allocation,
  `satisfy`, `verify`, `refine`, `derive`) resolves to a real element.

### B. Cross-Artifact Consistency
- Naming stays consistent across the chain: stakeholder concern → risk →
  requirement → use case → activity → logical/product element → test case →
  traceability row. Flag any renamed/duplicated concept.
- No orphan elements: every requirement is allocated somewhere and verified
  by at least one test case; every risk links to a requirement or
  constraint; every use case has at least one activity and one scenario.
- Allocation chain L0→L1→L2→L3 is complete and traceable, no skipped level,
  no dangling `allocation`.

### C. Over-Engineering / Unnecessary Complexity
- Flag any element (package, `part def`, `requirement def` category,
  ADR, state, port, attribute) that exists but is never referenced,
  allocated, satisfied, verified, or cited elsewhere — propose deletion.
- Flag near-duplicate structures that could be merged (e.g. two ADRs
  deciding the same concern, two requirements expressing the same
  constraint, redundant intermediate packages that only pass through to
  one child with no added meaning).
- Flag decomposition deeper than the content justifies (e.g. a package with
  a single trivial child, a state with one sub-state and no distinct
  behavior, an allocation layer that just renames its parent 1:1).
- Flag attributes/parameters carrying invented precision not backed by a
  requirement or ADR (e.g. arbitrary numeric values with no source).
- For every flag, propose the simplest fix: delete, merge, or flatten —
  never "add more structure to compensate."

### D. Description Conciseness & Clarity
- Read every `doc` block and every `@RequirementMeta`/`@ArchDecisionMeta`
  narrative field in scope.
- Flag any `doc` that: exceeds ~3–4 lines of substantive text, repeats
  context already stated elsewhere, uses unexplained jargon where a plain
  word would do, mixes multiple unrelated facts in one block, or could be
  understood by a newcomer only after re-reading.
- Note the plain-language rewrite direction (not the full rewrite) in the
  finding; the actual rewrite happens in the fix step.

### E. Traceability Completeness
- Every requirement, risk, use case, ADR, and test case in scope has a row
  in `Traceability/Traceability.sysml`.
- Every traceability row's source/target elements actually exist.

## Step 2 — Findings Log

Write `Project/Model/REVIEW_FINDINGS.md`:
- Summary counts (Critical/Major/Minor) at the top.
- One table, columns: `ID | Severity | Area | File:Element | Finding | Impact`.
- One row per finding — no prose paragraphs.
- Sorted by Severity, then Area.

## Step 3 — Fix Plan

Write `Project/Model/REMEDIATION_PLAN.md`:
- Numbered, ordered action items (group into phases only where a real
  dependency exists — keep phase count low).
- Each item ≤ 3 lines: **What** to change (prefer *delete*/*merge*/*shorten*
  over *add*), **Where** (exact file/element), **Resolves** (finding IDs).
- Must include at least one item per Critical/Major finding from Step 2.
- Bullet points and imperative mood only — no paragraphs.
- End with one line: `<N> Critical / <N> Major / <N> Minor open — NOT READY
  for baseline` (or `READY` if none remain).

## Step 4 — Execute the Fix Plan

Apply every item from `REMEDIATION_PLAN.md` directly to the `.sysml` files:
- Simplify first: prefer deleting or merging over adding. Only add an
  element when a Critical finding requires a genuinely missing link (e.g. a
  missing traceability row).
- Every edit stays consistent with `.github/instructions/sysml-modeling.instructions.md`
  (imports, requirement pattern, proxy ports, decomposition levels).
- Rewrite every flagged verbose `doc` block to ≤3–4 lines of plain,
  jargon-light language stating just the essential fact(s).
- No invented technical facts — every value/claim must already exist in the
  model or be a direct, citable consequence of an existing ADR/requirement.
- Preserve every element's stable ID (`REQ-...`, `RISK-...`, ADR numbers,
  test case IDs) referenced from `Traceability.sysml` unless the plan item
  explicitly retires that ID (then remove its traceability row too).
- Add a one-line comment at each fix pointing to the finding it resolves
  (e.g. `// resolves MR-014`).

## Step 5 — Re-review loop (repeat until clean)

After applying a pass of fixes, re-run Steps 1–3 from scratch against the
current state of the model (as if reviewing it for the first time):
1. Update `REVIEW_FINDINGS.md` — mark prior findings `Closed` (say how) or
   `Deferred` (say why, and get user confirmation before deferring anything
   Critical), add any *new* finding your own edits introduced with a fresh
   `MR-0NN` ID.
2. Update `REMEDIATION_PLAN.md` with any new action items.
3. Execute the new fix items (Step 4).
4. Repeat until a full pass finds **zero Critical and zero Major** findings.

Do not stop after one pass if any Critical/Major remains — keep looping.
If two consecutive passes fail to reduce the open Critical/Major count,
stop and report the blocker to the user instead of looping indefinitely.

## Step 6 — Final Verdict & Summary

Once a pass finds zero Critical/Major findings, update the final line of
`REMEDIATION_PLAN.md` to `0 Critical / 0 Major / <N> Minor open — READY for
baseline` and report to the user:
- Number of review passes run.
- Findings closed vs. deferred (counts by severity).
- Files created/edited (list).
- Net effect on size/complexity (e.g. elements deleted/merged vs. added).
- Final verdict line.

No long narrative — bullet points only.

## Style rules (apply everywhere, every pass)

- Short, information-dense sentences. No filler, no repeated context.
- Bullets/tables over prose, always.
- Every finding and every fix item must stand alone — understandable
  without reading the rest of the file.
- When in doubt between adding structure and simplifying, simplify.
