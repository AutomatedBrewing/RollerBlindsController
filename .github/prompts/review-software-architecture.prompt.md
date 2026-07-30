---
description: "Pedantic, exhaustive review of the firmware software architecture (layering, drivers/HAL, event catalog & signal flow, hierarchical state machine) under Project/Model/Architecture/software. Logs every finding, then produces a prioritized remediation plan. Read-only — never edits any .sysml file."
---

# Review Software Architecture (Pedantic)

Act as an extremely pedantic senior firmware/systems architecture reviewer.
**Read-only review** — do not modify any `.sysml` file. The only files you
write are the two reports in Step 3 and Step 4.

## Why this review exists

The current software architecture model
(`Project/Model/Architecture/software/`) stops short on four points:
1. No explicit software **layering** (Application/Service vs. Driver/HAL vs.
   hardware).
2. No explicit inventory of low-level **drivers** that must be written
   (HAL only — driver API/method signatures are SDD-level, out of scope here).
3. No single, readable **event catalog** and signal flow — events are only
   mentioned in ADR prose, never enumerated as first-class elements.
4. No confirmed-complete **hierarchical state machine** — states/transitions
   must all be explicit, unambiguous, and traceable.

Every finding and every remediation item must be short and concrete —
engineers reading this have no time for long paragraphs.

## Step 1 — Load context (read only)

Read, in order:
1. `Project/Model/README.md`, `Architecture/software/PLAN.md`.
2. `Architecture/base/BaseArchitecture.sysml`, `ADR_001`…`ADR_008`, `Constraints.sysml`, `SystemArchitecture_Taxonomy.sysml`.
3. `Architecture/product/ProductComponents.sysml`, `ProductInterfaces.sysml`, `LogicalToProductAllocation.sysml`.
4. `Architecture/states/SystemStates.sysml`.
5. Everything under `Architecture/software/`: `architecture_decisions/ADR_009_*`, `ADR_010_*`; `architecture_constraints/SWConstraints.sysml`; `building_block_view/SWBuildingBlocks.sysml`; `runtime_view/SWRuntimeScenarios.sysml`; `deployment_view/SWResourceBudget.sysml`; `cross_cutting_concepts/SWCrossCuttingConcepts.sysml`; `solution_strategy/SWSolutionStrategy.sysml`.
6. `KnowledgeSource/integration/crossmapping/physical-architecture.md`, `logical-architecture.md`, `product-architecture.md`, `system-states.md`.
7. `.github/instructions/sysml-modeling.instructions.md`.

## Step 2 — Review checklist (log EVERY finding — do not silently skip)

For each finding record: `ID` (`SWR-NNN`), `Severity`, `Area`,
`File:Element`, one-line `Finding`, one-line `Impact`.

**Severity**: `Critical` = blocks SDD handoff / structurally wrong or
missing; `Major` = real gap that must close before implementation starts;
`Minor` = wording/consistency/style nit.

### A. Software Layering
- Is there an explicit layered architecture (Application/Service ↔
  Driver/HAL ↔ hardware) modeled as packages/`part def`s with a documented
  boundary? (Expect: not yet — flag.)
- Does any firmware module (`CommandArbitrationSoftware`,
  `MovementControlSoftware`, `MotorDriveControlSoftware`,
  `MovementSupervisorSoftware`, `ConfigurationManagerSoftware`,
  `MemoryManagerSoftware`, `UserFeedbackSoftware`) reference hardware
  directly instead of through a driver abstraction? Flag every skipped
  layer.

### B. Driver Inventory (HAL only — NOT the API/SDD layer)
- Cross-reference every hardware peripheral implied by `ControlMCU` /
  `ProductInterfaces` / the ADRs: 4× debounced dry-contact GPIO inputs,
  motor output (relay/triac, up/down), timer peripheral (10 ms tick),
  internal EEPROM, buzzer output (ADR-008), any others found.
- For each peripheral, check whether a named driver building block exists
  anywhere in the model. Flag every missing one by the name it should have
  (e.g. `GpioInputDriver`, `MotorOutputDriver`, `TimerDriver`,
  `EepromDriver`, `BuzzerDriver`).
- State explicitly in the finding: only existence/responsibility/layer
  placement is in scope — method signatures belong to the SDD.

### C. Block Structure / Building Block View
- Is there one coherent block structure spanning Product → Software →
  Driver/HAL → Hardware, every connector traceable, no orphan modules, no
  layer-skipping connections?
- Is every module's responsibility non-overlapping with a single clear
  owner?

### D. Event Catalog & Signal Flow
- Extract every event referenced anywhere (debounced input-changed events,
  periodic timer tick, EEPROM access completion, buzzer trigger,
  state-machine triggers).
- Is there one authoritative, enumerated event catalog (name, producer,
  payload, consumer(s), trigger condition)? (Expect: not yet — flag.)
- For each event, trace producer → dispatcher → consumer → state-machine
  trigger (if any); flag inconsistent naming, events only in prose and
  never modeled, and events modeled but never produced/consumed.

### E. Hierarchical State Machine Completeness
- List every state and sub-state in `SystemStates.sysml` with its
  entry/do/exit.
- Verify every transition has an explicit trigger event + guard + effect;
  guards mutually exclusive; no orphan/unreachable state; no transition
  referencing an undefined event.
- Verify the state-machine host (`exhibit state` in
  `SWBuildingBlocks.sysml`) is consistent with `SystemStates.sysml` and
  that no other module partially re-implements state logic (cross-check
  Cross-cutting Concept 3).

### F. Traceability & SysML v2 Compliance
- Explicit imports present; no SysML v1 constructs; requirement
  def/usage pattern respected; proxy ports only; every ID traced in
  `Traceability/Traceability.sysml`.

### G. Documentation Conciseness
- Flag every `doc` block that is verbose/repetitive rather than short and
  information-dense. Note file/element only — the rewrite belongs in the
  remediation plan, not here.

## Step 3 — Findings Log

Write `Project/Model/Architecture/software/REVIEW_FINDINGS.md`:
- Summary counts (Critical/Major/Minor) at the top.
- One table, columns: `ID | Severity | Area | File:Element | Finding | Impact`.
- One row per finding — no prose paragraphs.
- Sorted by Severity, then Area.

## Step 4 — Remediation Plan

Write `Project/Model/Architecture/software/REMEDIATION_PLAN.md`:
- Numbered, ordered action items (group into phases only where a real
  dependency exists).
- Each item ≤ 3 lines: **What** to add/change, **Where** (exact file/package
  to create or edit), **Resolves** (finding IDs).
- Must include at least one item for each of: (1) layered architecture
  packages, (2) every missing driver named in Step 2B, (3) the single event
  catalog element wired into existing ADRs/cross-cutting concepts, (4) every
  HSM completeness gap, (5) rewriting every flagged verbose `doc` block.
- Bullet points and imperative mood only — no paragraphs.
- End with one line: `<N> Critical / <N> Major / <N> Minor open — NOT READY
  for SDD handoff until Critical+Major close` (or `READY` if none remain).

## Style rules (apply everywhere in both reports)

- Short, information-dense sentences. No filler, no repeated context.
- Bullets/tables over prose, always.
- Every finding and every action item must stand alone — understandable
  without reading the rest of the file.
