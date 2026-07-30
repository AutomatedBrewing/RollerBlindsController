---
description: "Implements Project/Model/Architecture/software/REMEDIATION_PLAN.md phase by phase with maximum rigor: edits .sysml model files, self-verifies every change against SysML v2 rules and existing conventions, then runs a final adversarial re-review until zero Critical/Major findings remain. Read-write — the counterpart to review-software-architecture.prompt.md."
---

# Implement Software Architecture Remediation

Act as an extremely meticulous senior firmware/systems architect. This
prompt **modifies `.sysml` files**. Quality bar: every change must be
correct, minimal, consistent with existing model conventions, and never
based on invented facts. When a plan item is ambiguous or requires a
decision the model doesn't already support, **stop and ask the user**
instead of guessing.

## Step 0 — Load context (mandatory, in order)

1. `Project/Model/Architecture/software/REVIEW_FINDINGS.md` and
   `REMEDIATION_PLAN.md` — the exact scope of this work.
2. `.github/instructions/sysml-modeling.instructions.md` — binding rules for
   every edit (imports, requirement pattern, decomposition levels, proxy
   ports, `perform action`, anti-patterns).
3. Every file already under `Architecture/software/` (all subfolders) plus
   `Architecture/product/ProductComponents.sysml`, `ProductInterfaces.sysml`,
   `Architecture/states/SystemStates.sysml`, `Architecture/base/ADR_Common.sysml`,
   `Traceability/Traceability.sysml`.
4. `KnowledgeSource/swarch/crossmapping/building-block-view.md`,
   `cross-cutting-concepts.md`, `architecture-decisions.md` — the modeling
   patterns each new element must follow.
5. `KnowledgeSource/integration/okf-ontology.md §6.3` — required import
   matrix.

## Step 1 — Execute phases in order

Follow `REMEDIATION_PLAN.md` exactly, phase by phase (Phase 4 may run
concurrently with 1–3 since it has no dependency on them; do not reorder
otherwise — later phases depend on earlier decisions):

- **Phase 1** — ADR-SW-011 software layering decision.
- **Phase 2** — Event catalog + `EventDispatcher` element.
- **Phase 3** — Driver layer + inventory (5 new drivers, 3 new `*Internal`
  whitebox specializations, `PLAN.md` scoping update).
- **Phase 4** — Hierarchical state machine fixes (composite `Operational`
  super-state, dedupe `PowerLost` transitions, resolve `MovingManual` gap,
  dual-host summary table).
- **Phase 5** — Traceability wiring (import every `SWA-0x` package into
  `Traceability.sysml`, add `refines`/`depends_on` connections).
- **Phase 6** — Documentation conciseness (split the ~100-line
  `SWSolutionStrategy` doc block, trim `SWBuildingBlocks` header).
- **Phase 7** — Housekeeping (`Project/Model/README.md` folder-tree entry,
  naming-convention decision).

## Step 2 — Non-negotiable quality rules for every edit

- Every new/edited `.sysml` file has explicit `import` statements per the
  matrix in `okf-ontology.md §6.3` — no unresolved-type errors.
- New whitebox modules are added via specialization (`part def X_Internal :>
  ExistingPartDef`) — never by re-declaring an existing definition's name
  (SysML v2 has no reopening mechanism).
- Drivers stay **signature-free**: name, responsibility, owning module,
  layer placement only. No method/API design — that is explicitly SDD scope
  and must stay out.
- No invented technical facts. Every timing figure, attribute value, or
  responsibility statement must already exist in the model or be a direct,
  citable consequence of an existing ADR/constraint. If a genuinely new
  fact is unavoidable (e.g., a driver's resource estimate), mark it as an
  explicit placeholder attribute with a `// TODO` doc note rather than
  fabricating a precise number.
- `doc` blocks are short and information-dense: state the fact, cite the
  ADR/requirement/finding ID that justifies it, stop. No multi-topic essay
  blocks (this was Finding SWR-026 — do not reintroduce it anywhere).
- Every finding ID resolved by an edit gets a one-line comment reference
  (e.g., `// resolves SWR-006`) at the point of the fix, so the connection
  between finding and fix is visible in the diff.
- Proxy ports only, `part def` for structural elements (never SysML v1
  `actor`/`block`), two-layer requirement pattern where requirements are
  touched.
- Preserve every existing element's name, port, and attribute unless the
  plan item explicitly calls for a change — additive, non-invasive edits
  only.

## Step 3 — Self-verification after each phase

Before moving to the next phase, re-read your own edits adversarially
against this checklist (same categories as the review prompt, scoped to
what you just changed):

- **Compiles conceptually**: every referenced type/port/action exists;
  no dangling reference.
- **Layering**: no Application-level module reaches past its driver into
  raw hardware ports.
- **Drivers**: each new driver has exactly one owning module, one clear
  responsibility, no overlap with another driver.
- **Events**: every event in the catalog has a producer and at least one
  consumer; no orphan or unproduced event.
- **State machine**: every state has ≥1 outgoing transition or is
  explicitly terminal; every transition has a named trigger (or is a
  documented completion transition); guards sharing a trigger stay
  mutually exclusive; no duplicated transition logic across sibling states
  after Phase 4.
- **Traceability**: every new package is imported somewhere it should be
  reachable from `Traceability.sysml` by Phase 5's end.
- **Conciseness**: no `doc` block you wrote exceeds ~5 lines of substantive
  text.

Fix anything that fails before proceeding.

## Step 4 — Final acceptance pass (mandatory, after Phase 7)

Re-run the full adversarial review from `review-software-architecture.prompt.md`
Steps 2 (categories A–G) across the entire `Architecture/software/` folder
plus `SystemStates.sysml` and `Traceability.sysml`, as if you had not just
made the changes yourself. For every one of the 28 original findings
(`SWR-001`…`SWR-028`):
- Confirm it is now closed, and how.
- Or, if intentionally deferred (e.g., SWR-027's retroactive ADR-001–010
  tightening), state that explicitly with a reason — never silently drop it.

Update `Project/Model/Architecture/software/REVIEW_FINDINGS.md` in place:
add a `Status` column (`Closed` / `Deferred` + reason) to the existing
table, and update the Summary counts.

Update `REMEDIATION_PLAN.md`'s final line to reflect the new state:
`<N> Critical / <N> Major / <N> Minor open — READY for SDD handoff` (only
write `READY` once zero Critical/Major remain), or list what's still open
and why.

If the re-review surfaces any **new** finding introduced by your own edits,
add it to the findings table with a fresh `SWR-0NN` ID, fix it immediately
(this phase is read-write), and re-verify.

## Step 5 — Summary to user

End with a short report: phases completed, files created/edited (list),
findings closed vs. deferred (counts), and the final verdict line from
Step 4. No long narrative — bullet points only.
