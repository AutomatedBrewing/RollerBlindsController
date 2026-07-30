---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Software Solution Strategy
description: Full SysML v2 and arc42 mapping for Software Architecture artifact Solution Strategy (SWA-02).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Software Solution Strategy (SWA-02)

The Software Solution Strategy summarises the fundamental technology and
decomposition decisions for the firmware — execution model, concurrency
approach, and module-boundary rationale — bridging the Product Architecture
(SM-PRD-21) to the deeper Software Building Block View (SWA-03).

## §1 SysMod Definition

**Artifact ID:** SWA-02
**Not a SYSMOD product** — no direct SYSMOD precedent; closest analogue is the rationale text SYSMOD expects alongside any Architecture product, made explicit here as its own artifact because arc42 treats Solution Strategy as a first-class section (ARC-04).
**Continues:** [Product Architecture](../../sysmod/products/product-architecture.md) (SM-PRD-21) coupling decisions (`ADR_006`, `ADR_007`, `ADR_008`).
**Responsible Role:** Software Architect (project role).

### Purpose

To record, at an executive-summary level, *why* the firmware will be
structured the way SWA-03 (Building Block View) subsequently details — so
that the detailed decomposition has a stated rationale rather than being an
unexplained fait accompli.

### Role in Process

Performed once Software Architecture Constraints (SWA-01) are in place. The
Software Architect chooses: (1) the execution model (superloop, cooperative
scheduler, RTOS) against the resource ceiling; (2) how interrupts and the
main loop share state; (3) whether/how firmware `part def` boundaries already
fixed by the Product Architecture need internal sub-decomposition; (4)
which firmware component(s) will host (`exhibit state`) the existing System
States (SM-PRD-23) state machines.

### Inputs (table)

| # | Input Artifact | ID | Description |
|---|---|---|---|
| 1 | Software Architecture Constraints | SWA-01 | Resource ceiling and execution-model availability bound the strategy space |
| 2 | Product Architecture | SM-PRD-21 | Firmware `part def` components and their coupling decisions are the strategy's starting structure |
| 3 | System States | SM-PRD-23 | Existing state machines that must be bound to a concrete firmware host |

### Outputs / Dependent Artifacts (table)

| # | Dependent Artifact | ID | Relationship |
|---|---|---|---|
| 1 | Software Building Block View | SWA-03 | Internal module decomposition follows the strategy's decomposition rationale |
| 2 | Software Deployment View | SWA-05 | Resource-budget allocation follows the execution-model choice |
| 3 | Software Architecture Decisions | SWA-07 | Each strategic choice is elaborated as one or more ADRs |

### Dependencies

- **SWA-01:** Every strategic choice MUST respect the resource/execution constraints already fixed.
- **SM-PRD-23:** The strategy MUST explicitly state which firmware `part def` will `exhibit state` each system-level state machine — this is currently an open gap in the project (state machines exist only on Logical-layer specializations).

---

## §2 SysML v2 Mapping

### Mapping Table

| SW Architecture Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| Strategy narrative | `doc` on the top-level software package | [SML-DEF-Package](../../sysml2/concepts/package.md) | Executive-summary text, consistent with how `ADR_Common`-style packages carry narrative `doc` |
| Strategic decision | `package ADR_NNN { @ArchDecisionMeta {...} }` | N/A (project convention) | Reuses the exact ADR pattern already established for Base/Product Architecture; no new metadata definition |
| State-machine hosting assignment | `exhibit state` (declared here, elaborated in SWA-03) | [SML-USG-StateUSG](../../sysml2/concepts/state-usage.md) | The strategy names which `part def` will host each state machine; SWA-03 supplies the full body |

### Modeling Pattern

```sysml
package SWA_SolutionStrategy {
    private import ADR_Common::*;
    private import ProductComponents::*;
    private import SystemStates::*;

    doc
    /* Software Solution Strategy: bare-metal superloop execution model
     * (no RTOS available per SWA-01::noRtosAvailable). Interrupts are used
     * only for the two dry-contact input channels (debounce edge capture);
     * all supervision and arbitration logic runs in the main loop.
     * ControllerLifecycleState is exhibited on MovementSupervisorSoftware
     * (elaborated in SWA-03) — diagnostics is out of scope for this project
     * (behavior-clarification pass; see PLAN.md), so no diagnostics-related
     * execution-model concern applies.
     */

    package ADR_009_SWExecutionModel {
        @ArchDecisionMeta {
            decisionId = "ADR-009";
            title      = "Bare-metal superloop execution model";
            status     = "accepted";
            context    = "SWA-01::noRtosAvailable rules out an RTOS; cost constraint (ADR-001) rules out MCU upgrade.";
            decision   = "Firmware runs a single bare-metal superloop; the two dry-contact inputs use interrupt-driven edge capture only, feeding a debounce buffer read by the main loop.";
            alternatives = "Cooperative round-robin scheduler: rejected, adds RAM overhead for task control blocks with no concurrency benefit for this simple I/O profile.";
            consequences = "All firmware modules must be designed as non-blocking, cooperatively-polled state machines/functions callable once per superloop iteration.";
            rationale  = "Simplest model that fits the 1KB RAM / 16KB flash budget and the project's I/O profile (2 digital inputs, timer-based supervision, 1 relay, 1 buzzer).";
        }
    }
}
```

### Recommended Package Structure

```
<System>_Architecture/
  software/
    solution_strategy/
      <System>_SWSolutionStrategy.sysml   ← doc narrative + ADR_0NN packages
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Relationship | Content Contributed |
|---|---|---|---|
| [Solution Strategy](../../arc42/sections/solution-strategy.md) | ARC-04 | **Mandatory** | Execution model, concurrency approach, decomposition rationale, state-machine hosting assignment |
| [Architecture Decisions](../../arc42/sections/architecture-decisions.md) | ARC-09 | **Mandatory** | Each strategic choice recorded as a full ADR |

---

## §4 Traceability

### Incoming Links (table)

| Source ID | Source Name | Link Type | Description |
|---|---|---|---|
| SWA-01 | Software Architecture Constraints | `depends_on` | Strategy choices must respect the resource/execution ceiling |
| SM-PRD-21 | Product Architecture | `depends_on` | Firmware `part def` boundaries and coupling decisions are the strategy's starting point |
| SM-PRD-23 | System States | `depends_on` | Existing state machines must be assigned a concrete firmware host |

### Outgoing Links (table)

| Target ID | Target Name | Link Type | Description |
|---|---|---|---|
| SWA-03 | Software Building Block View | `enables` | Decomposition rationale guides the detailed internal breakdown |
| SWA-05 | Software Deployment View | `enables` | Execution-model choice determines whether task/interrupt placement needs documentation |
| SWA-07 | Software Architecture Decisions | `implements` | Every strategic choice is recorded as an ADR |
| ARC-04 | Solution Strategy | `documents` | Rendered as the software-specific solution strategy narrative |

### Traceability Rules

1. Every strategic choice stated in the SWA-02 narrative MUST have a corresponding `package ADR_NNN` in SWA-07.
2. Every state machine in System States (SM-PRD-23) MUST be assigned to exactly one firmware `part def` host in the SWA-02 narrative before SWA-03 elaborates it.
3. The execution-model decision MUST cite the specific SWA-01 constraint(s) it respects.

---

## §5 Modeling Procedure

1. **Confirm the constraint ceiling.** Re-read SWA-01's resource and execution-model constraints before proposing any strategy.

2. **Choose the execution model.** Decide superloop vs. cooperative scheduler vs. RTOS; document the choice and rejected alternatives directly as an ADR (do not defer this to SWA-07 as an afterthought — draft the ADR *while* deciding).

3. **Assign state-machine hosts.** For each `state def` root in `SystemStates.sysml` currently exhibited only on a Logical-layer specialization, decide which firmware `part def` (from `ProductComponents.sysml`) will `exhibit state` it going forward. Record this explicitly in the strategy `doc`.

4. **State the decomposition rationale.** Briefly justify, at a strategy level, why the existing firmware `part def` boundaries (already fixed by the Product Architecture) are the right internal seams — this sets up SWA-03's detailed work.

5. **Write the ADRs.** Create one `package ADR_NNN` per strategic decision, continuing the existing numbering sequence from `ADR_008`, reusing `ADR_Common::ArchDecisionMeta`.

6. **Document in arc42.** Write the software-specific paragraph(s) under ARC-04 (Solution Strategy), and ensure each ADR is discoverable under ARC-09.
