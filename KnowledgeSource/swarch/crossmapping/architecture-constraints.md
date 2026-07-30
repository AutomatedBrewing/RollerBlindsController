---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Software Architecture Constraints
description: Full SysML v2 and arc42 mapping for Software Architecture artifact Architecture Constraints (SWA-01).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Software Architecture Constraints (SWA-01)

Software Architecture Constraints are the non-negotiable technical and
resource conditions — MCU flash/RAM budget, execution model, timing
granularity — that bound the internal firmware design space. They are
derived directly from attribute values already present on the Product
Architecture's `ControlMCU` `part def` (SM-PRD-21), any Base
Architecture (SM-PRD-07) constraints that also bind the software, and any
explicit software-relevant non-functional Requirement (SM-PRD-10, e.g. a
timing-accuracy requirement) that constrains the firmware beyond what the
hardware attributes alone imply.

## §1 SysMod Definition

**Artifact ID:** SWA-01
**Not a SYSMOD product** — SYSMOD's Base Architecture (SM-PRD-07) is the closest precedent, but it is fixed *before* any system model exists; SWA-01 is derived *from* the already-modelled Product Architecture.
**Continues:** [Product Architecture](../../sysmod/products/product-architecture.md) (SM-PRD-21), specifically the hardware attribute values already on `ControlMCU`.
**Responsible Role:** Software Architect (project role; not a formal SYSMOD role).

### Purpose

To make the software design space's boundaries explicit and checkable before
any internal decomposition (SWA-03) or execution-model decision (SWA-02) is
made. Without this artifact, resource overruns are discovered late (at
compile/link time) rather than during architecture review.

### Role in Process

Performed once the Product Architecture's hardware `part def` (`ControlMCU`)
has stable attribute values. The Software Architect reads
`flashSizeKB`/`internalRamBytes`/`internalEepromBytes`/`clockSpeedMHz` from
`ControlMCU`, reads any propagating Base Architecture constraints (e.g.
`L0_Constraints::Business::costEffective`, which rules out expensive
RTOS-capable silicon), and expresses each as a `requirement` with a
`require constraint` body — mirroring the existing `L0_Constraints` pattern.

### Inputs (table)

| # | Input Artifact | ID | Description |
|---|---|---|---|
| 1 | Product Architecture | SM-PRD-21 | `ControlMCU`'s hardware attribute values (flash, RAM, EEPROM, clock, GPIO count) are the primary constraint values |
| 2 | Base Architecture | SM-PRD-07 | Project-wide constraints (cost, no-position-feedback, isolation) that also restrict the software |
| 3 | Requirements | SM-PRD-10 | Any explicit software-relevant non-functional requirement (e.g. timing accuracy) |

### Outputs / Dependent Artifacts (table)

| # | Dependent Artifact | ID | Relationship |
|---|---|---|---|
| 1 | Software Solution Strategy | SWA-02 | The execution-model choice must respect the resource ceiling defined here |
| 2 | Software Deployment View | SWA-05 | Validates the aggregate firmware footprint against this ceiling |

### Dependencies

- **SM-PRD-21 (Product Architecture):** Primary source of constraint *values*. SWA-01 constraint attributes MUST reference (not duplicate as magic numbers) `ControlMCU`'s attributes where possible, or restate them with an explicit comment citing the source.
- **SM-PRD-07 (Base Architecture):** Any Base Architecture requirement that also binds the software MUST be referenced via `satisfy` or `require constraint`, not silently re-derived.
- **SM-PRD-10 (Requirements):** Any explicit software-relevant non-functional requirement (e.g. a timing-accuracy requirement) MUST be cited by reference when it shapes a SWA-01 constraint, not restated as an independent, untraceable number.

---

## §2 SysML v2 Mapping

### Mapping Table

| SW Architecture Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| Resource budget constraint | `requirement` with `require constraint` | [SML-USG-ReqUSG](../../sysml2/concepts/requirement-usage.md) | Matches the project's existing `L0_Constraints` pattern (not the generic `constraint def` + metadata pattern) |
| Constraint subject | `subject controlMcu : ControlMCU` | [SML-USG-PartUSG](../../sysml2/concepts/part-usage.md) | Binds the constraint to the concrete hardware part already modelled |
| Reused hardware value | Direct attribute reference (`controlMcu.internalRamBytes`) | [SML-USG-AttrUSG](../../sysml2/concepts/attribute-usage.md) | Avoids duplicating magic numbers; single source of truth stays on `ControlMCU` |
| Execution-model constraint | `requirement` with `doc` (qualitative, non-numeric) | [SML-USG-ReqUSG](../../sysml2/concepts/requirement-usage.md) | Some constraints (e.g. "no RTOS available") are boolean/qualitative, not numeric bounds |

### Modeling Pattern

```sysml
package SWA_Constraints {
    private import ProductComponents::*;
    private import L0_Constraints::*;

    requirement flashBudget {
        subject mcu : ControlMCU;
        doc
        /* The aggregate estimatedFlashBytes of all firmware part usages
         * hosted on ControlMCU shall not exceed its flashSizeKB, minus a
         * 10% safety margin for bootloader and toolchain overhead. */

        require constraint {
            // Illustrative; actual aggregate sum is computed/validated in SWA-05.
            mcu.flashSizeKB * 1024 * 0.9 >= 0 [SI::'']
        }
    }

    requirement ramBudget {
        subject mcu : ControlMCU;
        doc
        /* The aggregate estimatedRamBytes of all firmware part usages
         * hosted on ControlMCU shall not exceed its internalRamBytes. */
    }

    requirement noRtosAvailable {
        subject mcu : ControlMCU;
        doc
        /* No RTOS/scheduler is available on this MCU family; the Software
         * Solution Strategy (SWA-02) execution-model choice is restricted
         * to bare-metal superloop and/or interrupt handlers. */
    }
}
```

### Recommended Package Structure

```
<System>_Architecture/
  software/
    architecture_constraints/
      <System>_SWConstraints.sysml   ← requirement usages, subject = ControlMCU
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Relationship | Content Contributed |
|---|---|---|---|
| [Architecture Constraints](../../arc42/sections/architecture-constraints.md) | ARC-02 | **Mandatory** | Software-specific resource/execution constraints, as a sub-section beneath the project-wide constraints already documented from SM-PRD-07 |
| [Solution Strategy](../../arc42/sections/solution-strategy.md) | ARC-04 | Recommended | Constraint adherence rationale once SWA-02 is written |

---

## §4 Traceability

### Incoming Links (table)

| Source ID | Source Name | Link Type | Description |
|---|---|---|---|
| SM-PRD-21 | Product Architecture | `depends_on` | Constraint values are read from `ControlMCU`'s attributes |
| SM-PRD-07 | Base Architecture | `depends_on` | Project-wide constraints propagate into the software level |
| SM-PRD-10 | Requirements | `depends_on` | Software-relevant non-functional requirements are cited when they shape a constraint |

### Outgoing Links (table)

| Target ID | Target Name | Link Type | Description |
|---|---|---|---|
| SWA-02 | Software Solution Strategy | `enables` | The execution-model decision must fit within these constraints |
| SWA-05 | Software Deployment View | `enables` | Budget validation checks the aggregate footprint against these ceilings |
| ARC-02 | Architecture Constraints | `documents` | Rendered as the software-specific constraint sub-section |

### Traceability Rules

1. Every numeric constraint bound MUST reference the source `ControlMCU` attribute it is derived from (via comment or direct attribute reference), never a hard-coded duplicate value.
2. Every Base Architecture constraint (SM-PRD-07) that restricts the software MUST have a corresponding SWA-01 requirement, even if only a `doc`-only qualitative restatement.
3. Every SWA-01 requirement MUST be referenced by at least one decision in Software Architecture Decisions (SWA-07) once the corresponding strategic choice is made.

---

## §5 Modeling Procedure

1. **Read the hardware ceiling.** Open `ProductComponents.sysml`, locate `ControlMCU`, and note `flashSizeKB`, `internalRamBytes`, `internalEepromBytes`, `clockSpeedMHz`, `gpioCount`.

2. **Identify propagating Base Architecture constraints.** Review `L0_Constraints.sysml` for any constraint (cost, isolation, no-position-feedback) that also restricts software design freedom (e.g. cost rules out an RTOS-capable MCU upgrade).

3. **Express each constraint as a `requirement`.** Create one `requirement` per constraint category (flash budget, RAM budget, execution-model availability, timing resolution), with `subject` bound to `ControlMCU`, following the exact style of `Project/Model/Architecture/base/Constraints.sysml`.

4. **Add a safety margin.** For resource-budget requirements, do not use the raw hardware maximum — apply an explicit margin (e.g. 10%) to leave headroom for toolchain overhead and future maintenance.

5. **Validate against current firmware components.** Cross-check the constraint bounds against the resource-estimate attributes already present on the 7 firmware `part def`s in `ProductComponents.sysml` — this is a preview of the full validation performed in SWA-05.

6. **Document in arc42.** Add the software-specific constraints as a clearly labelled sub-section under ARC-02, distinct from the project-wide constraints already documented from SM-PRD-07.
