---
description: "Generate concise arc42 architecture documentation from the model/ SysML v2 source into /Doc, then review the generated docs for accuracy and consistency against the model."
---

# Generate arc42 Documentation from the Model

Generate the arc42 architecture documentation for this project into `Doc/arc42/`,
rendered strictly from `model/**/*.sysml`. The model is the single source of
truth — arc42 is a **rendered view**, not a hand-authored document. Do not
invent content that has no corresponding model element.

## Step 1 — Load the mapping rules

Before writing anything, read:
1. `KnowledgeSource/integration/index.md` — "arc42 Section → Model Source Mapping" table (§ authoritative section→model mapping).
2. `KnowledgeSource/arc42/sections/<section>.md` for **each** of the 12 sections — defines the required subsections/schema for that section.
3. `KnowledgeSource/integration/crossmapping/<artifact>.md §3` for every SYSMOD artifact referenced by a section — defines exactly which model elements populate it.
4. `model/README.md` — current model folder structure, so you know where each artifact actually lives.

## Step 2 — Extract content from the model, not from memory

For every claim you write, locate the concrete model element backing it
(package, `part def`, `requirement <'ID'>`, `ADR_NNN`, `verification def`,
`concern`, etc.) in the actual `.sysml` files under `model/`. Cite the
element's stable ID or qualified name inline (e.g. `REQ-S-02`, `ADR-008`,
`RISK-T-01`) so every sentence is traceable back to its source.

If a section's model source doesn't exist yet (e.g. `Analysis/domain` is
"not yet modelled" per `model/README.md`), state that explicitly as
**"Not yet modelled"** — never fabricate content to fill a gap.

## Step 3 — Write the 12 arc42 sections

Create these files in `Doc/arc42/` (numbering matches
`KnowledgeSource/integration/okf-ontology.md §6.1`):

```
Doc/arc42/
  01-introduction-and-goals.md
  02-architecture-constraints.md
  03-context-and-scope.md
  04-solution-strategy.md
  05-building-block-view.md
  06-runtime-view.md
  07-deployment-view.md
  08-cross-cutting-concepts.md
  09-architecture-decisions.md
  10-quality-requirements.md
  11-risks-and-technical-debts.md
  12-glossary.md
```

**Writing rules — be concise, not exhaustive:**
- Follow the "Schema" subsection structure from the matching
  `KnowledgeSource/arc42/sections/<section>.md` file exactly — same
  subsection headings, same table shapes.
- Prefer tables and bullet points over prose. No filler paragraphs
  explaining what arc42 or SYSMOD is — the reader knows the framework;
  document *this system*, not the methodology.
- Every requirement, decision, risk, or component mentioned carries its
  model ID (`REQ-F-01`, `ADR-006`, `RISK-S-01`, part def name, etc.).
- Do not duplicate full `doc` text verbatim across sections — summarize;
  link back to the `.sysml` file/package for the full text instead.
- Skip a subsection with one line ("Not yet modelled — see
  `model/Analysis/domain/`.") rather than padding it.

## Step 4 — Review pass (mandatory, after all 12 files exist)

Re-read every file you just wrote against the model, adversarially:
1. **Traceability** — every ID/claim in `Doc/arc42/*.md` resolves to a real
   element in `model/**/*.sysml`. Flag anything that doesn't.
2. **Completeness** — every requirement, ADR, risk, and verification def in
   the model has a corresponding mention somewhere in `Doc/arc42/`. Flag
   any model element that's missing from the docs.
3. **Consistency** — no section contradicts another or the model (e.g. a
   superseded ADR still described as current).

Fix every Critical/Major finding directly in the `Doc/arc42/` files, then
write `Doc/arc42/review-report.md` summarizing the review: methodology,
findings table (Critical/Major/Minor, same style as
`playground/ButtonLedIndicator/model/reviewReport.md`), and a final
verdict (`ACCEPTED` only once zero Critical/Major findings remain).
