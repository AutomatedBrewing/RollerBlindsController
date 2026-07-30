---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Software Deployment View
description: Full SysML v2 and arc42 mapping for Software Architecture artifact Deployment View (SWA-05).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Software Deployment View (SWA-05)

The Software Deployment View validates that the aggregate firmware
footprint (flash + RAM across all firmware building blocks) fits within the
single MCU's actual budget, and — if the execution model requires it —
documents task/interrupt placement. It continues arc42's Deployment View
(ARC-07) below the hardware-topology level already covered by the Product
Architecture (SM-PRD-21).

## §1 SysMod Definition

**Artifact ID:** SWA-05
**Not a SYSMOD product** — the Product Architecture (SM-PRD-21) already covers hardware-topology deployment (which node hosts which component); SWA-05 is the software-discipline continuation for a project with a single MCU node, where the interesting question moves from "which node" to "does it fit, and how is it scheduled".
**Continues:** [Product Architecture](../../sysmod/products/product-architecture.md) (SM-PRD-21) — `ControlMCU`'s hardware attributes and each firmware component's `estimatedFlashBytes`/`estimatedRamBytes`.
**Responsible Role:** Software Architect (project role).

### Purpose

To turn the resource constraints declared qualitatively in SWA-01 into a
quantitative, checkable budget: sum every firmware component's resource
estimate, compare against the MCU ceiling with an explicit margin, and
surface any overrun as an early architectural risk rather than a late
compile-time surprise.

### Role in Process

Performed once the resource-estimate attributes are stable on all firmware
`part def` components (they already exist in `ProductComponents.sysml`) and
the execution model (SWA-02) is decided. The Software Architect computes the
aggregate sum, checks it against `ControlMCU`'s budget attributes, and — if
the chosen execution model uses interrupts — documents which logic runs in
which execution context.

### Inputs (table)

| # | Input Artifact | ID | Description |
|---|---|---|---|
| 1 | Product Architecture | SM-PRD-21 | `ControlMCU`'s budget attributes and every firmware component's resource-estimate attributes |
| 2 | Software Architecture Constraints | SWA-01 | The margin policy and hard ceiling to validate against |
| 3 | Software Solution Strategy | SWA-02 | Execution model determines whether interrupt/task placement needs documentation at all |

### Outputs / Dependent Artifacts (table)

| # | Dependent Artifact | ID | Relationship |
|---|---|---|---|
| 1 | Software Architecture Decisions | SWA-07 | A tight margin or overrun is typically recorded as a decision/mitigation |
| 2 | Risks | SM-PRD-09 | Resource-margin risk should be traceable to the risk register |

### Dependencies

- **SM-PRD-21:** The aggregate sum MUST be computed from the actual attribute values already on each firmware `part def` — never re-estimated independently.
- **SWA-01:** The margin percentage applied MUST match the one declared in SWA-01's budget requirements.

---

## §2 SysML v2 Mapping

### Mapping Table

| SW Architecture Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| Resource budget validation | `requirement` with `require constraint` summing attribute references | [SML-USG-ReqUSG](../../sysml2/concepts/requirement-usage.md) | Extends the SWA-01 constraint pattern with an actual aggregate-sum check |
| Per-component footprint table | `doc` table (for arc42 rendering) referencing existing attributes | [SML-USG-AttrUSG](../../sysml2/concepts/attribute-usage.md) | No new attributes — reuses `estimatedFlashBytes`/`estimatedRamBytes` already on each firmware `part def` |
| Execution-context placement | `metadata def ExecutionContext { attribute context : String; }` applied to internal actions from SWA-03 | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Only needed if the execution model uses more than a plain superloop; tags each internal action with `"main-loop"` or `"isr:<name>"` |

### Modeling Pattern

```sysml
package SWA_DeploymentView {
    private import ProductComponents::*;

    metadata def ExecutionContext {
        attribute context : String; // "main-loop" | "isr:<name>"
    }

    requirement flashBudgetCheck {
        subject mcu : ControlMCU;
        doc
        /* Aggregate estimatedFlashBytes across all 7 firmware part usages
         * (commandArbitrationSoftware ... userFeedbackSoftware) shall not
         * exceed mcu.flashSizeKB * 1024 * 0.9 (10% margin per SWA-01). */
    }

    requirement ramBudgetCheck {
        subject mcu : ControlMCU;
        doc
        /* Aggregate estimatedRamBytes across all 7 firmware part usages
         * shall not exceed mcu.internalRamBytes (per SWA-01::ramBudget). */
    }
}
```

### Recommended Package Structure

```
<System>_Architecture/
  software/
    deployment_view/
      <System>_SWResourceBudget.sysml   ← aggregate-sum requirement checks + doc table
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Relationship | Content Contributed |
|---|---|---|---|
| [Deployment View](../../arc42/sections/deployment-view.md) | ARC-07 | **Mandatory** | Software-level infrastructure "Level 2" detail: flash/RAM budget table, execution-context mapping |
| [Risks and Technical Debts](../../arc42/sections/risks-and-technical-debts.md) | ARC-11 | Recommended | Tight-margin or overrun risks |

---

## §4 Traceability

### Incoming Links (table)

| Source ID | Source Name | Link Type | Description |
|---|---|---|---|
| SM-PRD-21 | Product Architecture | `depends_on` | Resource-estimate attributes are the raw data summed here |
| SWA-01 | Software Architecture Constraints | `depends_on` | Ceiling and margin policy validated against |
| SWA-02 | Software Solution Strategy | `depends_on` | Execution model determines whether context-placement documentation is needed |

### Outgoing Links (table)

| Target ID | Target Name | Link Type | Description |
|---|---|---|---|
| SWA-07 | Software Architecture Decisions | `enables` | Overrun/tight-margin findings typically trigger a decision |
| SM-PRD-09 | Risks | `enables` | Resource-margin risk registered here |
| ARC-07 | Deployment View | `documents` | Rendered as the software-level infrastructure detail |

### Traceability Rules

1. The aggregate flash/RAM sum MUST be recomputed whenever any firmware `part def`'s resource-estimate attribute changes — this is a live check, not a one-time snapshot.
2. Any margin below the SWA-01-declared threshold MUST be recorded as a risk in SM-PRD-09 or a decision in SWA-07 — silently accepting a tight budget without documentation is not permitted.
3. Execution-context metadata (`ExecutionContext`) is only mandatory if SWA-02 chose an execution model with more than one context (i.e., any interrupt usage); a pure superloop with no interrupts may omit it.

---

## §5 Modeling Procedure

1. **Collect resource estimates.** List every firmware `part def`'s `estimatedFlashBytes`/`estimatedRamBytes` from `ProductComponents.sysml`.

2. **Sum and compare.** Compute the aggregate sum for each resource type and compare against `ControlMCU`'s `flashSizeKB * 1024` and `internalRamBytes`, applying the margin declared in SWA-01.

3. **Flag any overrun or tight margin.** If the check fails or the margin is below the declared threshold, record it as a risk (SM-PRD-09) and/or a decision (SWA-07) — do not silently proceed.

4. **Document execution-context placement, if applicable.** Only if SWA-02's execution model uses interrupts: tag each relevant internal action from SWA-03 with `@ExecutionContext { context = "isr:<name>"; }` or `"main-loop"`.

5. **Document in arc42.** Add the flash/RAM budget table and, if applicable, the execution-context mapping under ARC-07 as the software-level "Infrastructure Level 2" detail.
