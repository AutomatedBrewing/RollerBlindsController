---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Software Architecture Decisions
description: Full SysML v2 and arc42 mapping for Software Architecture artifact Architecture Decisions (SWA-07).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Software Architecture Decisions (SWA-07)

Software Architecture Decisions record the significant, hard-to-reverse
choices made while designing the firmware internals, reusing the exact same
`package ADR_NNN { @ArchDecisionMeta {...} }` pattern already established in
this project for Base and Product Architecture decisions — the
software-discipline continuation of arc42's Architecture Decisions (ARC-09).

## §1 SysMod Definition

**Artifact ID:** SWA-07
**Not a SYSMOD product** — no SYSMOD precedent; ADRs are an arc42/industry convention already adopted project-wide for SM-PRD-07/SM-PRD-21 decisions (`ADR_003`, `ADR_006`, `ADR_007`, `ADR_008`).
**Continues:** The existing `ADR_NNN` numbering sequence, reusing `ADR_Common::ArchDecisionMeta` unchanged.
**Responsible Role:** Software Architect (project role).

### Purpose

To ensure every non-trivial software-level choice (execution model,
state-machine hosting, decomposition depth) is captured with its context,
alternatives, and consequences — exactly mirroring why `ADR_003_TimeBased`
exists for the "no position sensor" architectural decision.

### Role in Process

Performed continuously alongside SWA-02 (Solution Strategy) and SWA-03
(Building Block View): whenever a strategic or structural choice is made at
the software level, it is captured immediately as a new `ADR_NNN` package,
never deferred to a later "documentation pass".

### Inputs (table)

| # | Input Artifact | ID | Description |
|---|---|---|---|
| 1 | Software Solution Strategy | SWA-02 | Strategic choices (execution model, state hosting) are elaborated in full here |
| 2 | Software Architecture Constraints | SWA-01 | The constraint context each decision must respect and cite |
| 3 | Software Deployment View | SWA-05 | Budget-overrun or tight-margin findings often trigger a mitigating decision |

### Outputs / Dependent Artifacts (table)

| # | Dependent Artifact | ID | Relationship |
|---|---|---|---|
| 1 | Software Cross-cutting Concepts | SWA-06 | Cross-cutting concepts often originate directly from a decision recorded here |
| 2 | All other SWA artifacts | SWA-01..06 | Every non-trivial choice made while producing them should be traceable to an ADR here |

### Dependencies

- **`ADR_Common` (project file):** SWA-07 MUST reuse `ADR_Common::ArchDecisionMeta` unchanged — no new metadata definition is introduced for the software level, preserving the single-source-of-truth fix already applied project-wide (see `ADR_Common.sysml` header comment).
- **Existing ADR numbering:** New software-level ADRs MUST continue the existing sequence (next available number after `ADR_008`, i.e. `ADR_009`), not restart at `ADR_001`.
- **`decisionId` format (resolves SWR-038):** software-level ADRs (`ADR_009` onward) MUST use the `"ADR-SW-0NN"` `decisionId` format (e.g. `"ADR-SW-009"`), not the bare `"ADR-0NN"` format §2's worked example below illustrates for Base/Product-layer ADRs. The `-SW-` infix is intentional and sanctioned: it disambiguates software-level decisions from the `ADR-001`..`ADR-008` Base/Product sequence they numerically continue, and is already used consistently across every `Architecture/software/**` file.

---

## §2 SysML v2 Mapping

### Mapping Table

| SW Architecture Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| Architecture decision record | `package ADR_NNN { @ArchDecisionMeta {...} }` | N/A (project convention, not a distinct SML node — reuses `SML-DEF-MetaDef`) | Identical pattern to `ADR_003`/`ADR_006`/`ADR_007`/`ADR_008`; zero new SysML v2 concepts |
| Decision metadata | `ADR_Common::ArchDecisionMeta` (already declared) | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Reused unchanged — attributes: `decisionId`, `title`, `status`, `supersedes`, `supersededBy`, `context`, `decision`, `consequences`, `alternatives`, `rationale` |

### Modeling Pattern

```sysml
package ADR_009_SWExecutionModel {
    private import ADR_Common::*;

    @ArchDecisionMeta {
        decisionId   = "ADR-SW-009"; // "-SW-" infix sanctioned for software-level ADRs (see Dependencies above)
        title        = "Bare-metal superloop execution model for firmware";
        status       = "accepted";
        context      = "SWA-01::noRtosAvailable rules out an RTOS on the STM8S003F3P6-class MCU; cost constraint (ADR-001) rules out an MCU upgrade.";
        decision     = "Firmware runs a single bare-metal superloop; the two dry-contact inputs use interrupt-driven edge capture only, feeding a debounce buffer read by the main loop.";
        alternatives = "Cooperative round-robin scheduler: rejected, adds RAM overhead for task control blocks with no concurrency benefit given the simple I/O profile.";
        consequences = "All firmware modules must be designed as non-blocking, cooperatively-polled state machines/functions callable once per superloop iteration.";
        rationale    = "Simplest model that fits the 1KB RAM / 16KB flash budget (SWA-01) and the project's I/O profile.";
    }
}
```

### Recommended Package Structure

```
<System>_Architecture/
  software/
    architecture_decisions/
      <System>_ADR_009_SWExecutionModel.sysml   ← one file per decision, continuing existing ADR numbering
      <System>_ADR_010_StateMachineHosting.sysml
      ...
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Relationship | Content Contributed |
|---|---|---|---|
| [Architecture Decisions](../../arc42/sections/architecture-decisions.md) | ARC-09 | **Mandatory** | Full decision record: context, decision, alternatives, consequences |
| [Solution Strategy](../../arc42/sections/solution-strategy.md) | ARC-04 | Recommended | Each decision underpins a statement already summarised in SWA-02's ARC-04 content |

---

## §4 Traceability

### Incoming Links (table)

| Source ID | Source Name | Link Type | Description |
|---|---|---|---|
| SWA-02 | Software Solution Strategy | `depends_on` | Strategic choices are elaborated in full as ADRs here |
| SWA-01 | Software Architecture Constraints | `depends_on` | Every decision must cite the constraint context it respects |

### Outgoing Links (table)

| Target ID | Target Name | Link Type | Description |
|---|---|---|---|
| SWA-06 | Software Cross-cutting Concepts | `enables` | Cross-cutting concepts often originate from a decision recorded here |
| ARC-09 | Architecture Decisions | `documents` | Rendered as full ADR entries |

### Traceability Rules

1. Every SWA-07 ADR MUST reuse `ADR_Common::ArchDecisionMeta` — creating a new, per-ADR metadata definition is the exact anti-pattern already fixed once in this project (see `ADR_Common.sysml` header).
2. Every SWA-07 ADR's `decisionId` MUST continue the existing numeric sequence without gaps or restarts.
3. Every non-trivial choice in SWA-02 (Solution Strategy) MUST have a corresponding ADR here — a strategy statement with no backing ADR is incomplete.
4. If a software-level ADR supersedes an earlier one, both `supersedes`/`supersededBy` fields MUST be set reciprocally (existing project convention).

---

## §5 Modeling Procedure

1. **Identify the decision.** As SWA-02/SWA-03 work proceeds, flag each choice that is hard to reverse or has wide-reaching consequences (execution model, state-machine hosting, decomposition depth, resource-margin mitigation).

2. **Assign the next ADR number.** Check the existing `Project/Model/Architecture/base/` folder for the highest existing `ADR_NNN`, and continue the sequence.

3. **Write the decision record.** Create `package ADR_NNN { @ArchDecisionMeta {...} }`, importing `ADR_Common::*`, and fill every field (`context`, `decision`, `alternatives`, `consequences`, `rationale`) — do not leave any field as a placeholder.

4. **Cross-reference constraints.** Cite the specific SWA-01 constraint(s) the decision respects, by name, in the `context` field.

5. **Update superseded ADRs, if applicable.** If this decision supersedes an earlier one (from any architecture layer), set `supersedes` here and `supersededBy` on the superseded ADR.

6. **Document in arc42.** Ensure the decision is discoverable under ARC-09, and that SWA-02's ARC-04 summary references it.
