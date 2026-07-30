---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Software Cross-cutting Concepts
description: Full SysML v2 and arc42 mapping for Software Architecture artifact Cross-cutting Concepts (SWA-06).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Software Cross-cutting Concepts (SWA-06)

Software Cross-cutting Concepts document firmware-wide principles that apply
across multiple firmware building blocks (SWA-03) rather than belonging to
any single one — error handling, persistence conventions, timing/debounce
conventions, and state-binding naming — the software-discipline continuation
of arc42's Cross-cutting Concepts (ARC-08).

## §1 SysMod Definition

**Artifact ID:** SWA-06
**Not a SYSMOD product** — no direct SYSMOD precedent; System States (SM-PRD-23) already touches on system-wide behavioural conventions (its own crossmapping documents ARC-08 as a mandatory target), and SWA-06 is where the firmware-specific elaboration of that lives.
**Continues:** Recurring patterns observed while producing the Software Building Block View (SWA-03).
**Responsible Role:** Software Architect (project role).

### Purpose

To avoid inconsistent, ad-hoc solutions to the same recurring problem
scattered across firmware modules (e.g. every module inventing its own
debounce timing convention) by documenting the agreed convention once and
requiring all modules to follow it.

### Role in Process

Performed iteratively as SWA-03 (Building Block View) proceeds: whenever a
pattern recurs across two or more firmware components (e.g. how faults reach
an observable outcome such as a fault state or a signal attribute, how
EEPROM access is serialized), it is promoted from a per-component detail to
a documented cross-cutting concept here.

### Inputs (table)

| # | Input Artifact | ID | Description |
|---|---|---|---|
| 1 | Software Building Block View | SWA-03 | Recurring internal patterns are the source material for promotion to a cross-cutting concept |
| 2 | Software Architecture Constraints | SWA-01 | Resource constraints often *cause* a cross-cutting concept (e.g. "no dynamic allocation") |
| 3 | System States | SM-PRD-23 | State-machine naming/guard conventions that should be applied consistently across all `exhibit state` hosts |

### Outputs / Dependent Artifacts (table)

| # | Dependent Artifact | ID | Relationship |
|---|---|---|---|
| 1 | Software Building Block View | SWA-03 | Every firmware component's internal design must conform to the documented concepts |
| 2 | Software Architecture Decisions | SWA-07 | Cross-cutting concepts are often the direct consequence of a recorded decision |

### Dependencies

- **SWA-03:** A cross-cutting concept MUST be backed by at least one concrete instance already present in the Building Block View — this artifact documents recurring patterns, it does not invent speculative ones.

---

## §2 SysML v2 Mapping

### Mapping Table

| SW Architecture Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| Cross-cutting concept narrative | `doc` on a dedicated package | [SML-DEF-Package](../../sysml2/concepts/package.md) | Narrative explanation, consistent with how other cross-cutting narratives are captured in this project |
| Checkable convention marker | `metadata def <ConceptName>Meta { ... }` applied to conforming `part def`s | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Makes a convention traceable/queryable (e.g. which modules were checked for "no dynamic allocation") rather than purely narrative |

### Modeling Pattern

```sysml
package SWA_CrossCuttingConcepts {
    private import ProductComponents::*;

    metadata def NoDynamicAllocationMeta {
        attribute verified : Boolean;
    }

    doc
    /* Concept: No Dynamic Memory Allocation.
     * Given the 1KB RAM budget (SWA-01::ramBudget), no firmware module may
     * use dynamic (heap) allocation; all buffers are fixed-size and
     * statically allocated. */

    // Applied to each firmware part def already defined in ProductComponents.
    @NoDynamicAllocationMeta { verified = true; } // applied per part def, illustrative
}
```

### Recommended Package Structure

```
<System>_Architecture/
  software/
    cross_cutting_concepts/
      <System>_SWCrossCuttingConcepts.sysml   ← doc narratives + metadata def markers
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Relationship | Content Contributed |
|---|---|---|---|
| [Cross-cutting Concepts](../../arc42/sections/cross-cutting-concepts.md) | ARC-08 | **Mandatory** | Firmware-wide conventions: error handling, persistence, timing/debounce, state-binding naming |
| [Architecture Decisions](../../arc42/sections/architecture-decisions.md) | ARC-09 | Recommended | Cross-reference to the decisions that originated each concept |

---

## §4 Traceability

### Incoming Links (table)

| Source ID | Source Name | Link Type | Description |
|---|---|---|---|
| SWA-03 | Software Building Block View | `depends_on` | Recurring internal patterns motivate each documented concept |
| SWA-01 | Software Architecture Constraints | `depends_on` | Resource constraints often cause a cross-cutting concept |
| SM-PRD-23 | System States | `depends_on` | State-machine conventions apply across every `exhibit state` host |

### Outgoing Links (table)

| Target ID | Target Name | Link Type | Description |
|---|---|---|---|
| SWA-03 | Software Building Block View | `enables` | Every firmware component's design must conform to the documented concepts |
| SWA-07 | Software Architecture Decisions | `implements` | Concepts trace back to the decision(s) that caused them |
| ARC-08 | Cross-cutting Concepts | `documents` | Rendered as the firmware-wide concept catalogue |

### Traceability Rules

1. Every documented concept MUST cite at least one concrete SWA-03 instance where it already applies.
2. Every concept that constrains firmware design (e.g. "no dynamic allocation") SHOULD have a corresponding checkable `metadata def` marker, not just prose.
3. Every concept SHOULD trace back to the SWA-07 decision (or SWA-01 constraint) that caused it.

---

## §5 Modeling Procedure

1. **Scan for recurring patterns.** While or after producing SWA-03, note any pattern (timing convention, error-propagation approach, persistence access style, state-binding naming) that appears in two or more firmware components.

2. **Promote each pattern to a named concept.** Write a `doc` narrative explaining the concept's intent, scope, and rationale.

3. **Add a checkable marker where useful.** For constraint-driven concepts (e.g. no dynamic allocation), define a `metadata def` and apply it to conforming `part def`s so conformance is queryable, not just asserted in prose.

4. **Cross-reference the originating decision.** Link each concept back to the SWA-07 ADR or SWA-01 constraint that caused it.

5. **Document in arc42.** Add each concept as a numbered Concept slot under ARC-08, following the arc42 template's own numbered-concept-slot convention.
