---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Software Runtime View
description: Full SysML v2 and arc42 mapping for Software Architecture artifact Runtime View (SWA-04).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Software Runtime View (SWA-04)

The Software Runtime View shows how the firmware building blocks (SWA-03)
actually execute: superloop iteration order, interrupt preemption, and
timer-driven state-machine transitions — the software-discipline
continuation of System Processes/Scenarios (SM-PRD-13/SM-PRD-22) into
firmware execution mechanics.

## §1 SysMod Definition

**Artifact ID:** SWA-04
**Not a SYSMOD product** — closest precedent is [Scenarios](../../sysmod/products/scenarios.md) (SM-PRD-22), which SWA-04 elaborates in firmware-execution terms.
**Continues:** Scenarios (SM-PRD-22) and System Processes (SM-PRD-13), applied to the firmware building blocks from SWA-03.
**Responsible Role:** Software Architect (project role).

### Purpose

To make explicit *how* the firmware schedules and interleaves its internal
actions — information that does not exist at the system-scenario level
(SM-PRD-22), where interactions are shown between logical/product parts
without regard to whether execution happens in an interrupt handler or the
main loop.

### Role in Process

Performed once SWA-03 has defined the internal actions and exhibited state
machines. The Software Architect selects the runtime scenarios most
architecturally significant for this project (per arc42's own selectivity
guidance) — typically: one superloop iteration, the debounce/arbitration
interrupt path, and the timeout-driven automatic-stop transition (ADR-003).

### Inputs (table)

| # | Input Artifact | ID | Description |
|---|---|---|---|
| 1 | Software Building Block View | SWA-03 | Internal actions and exhibited state machines are the scenario participants |
| 2 | Scenarios | SM-PRD-22 | System-level scenarios this view elaborates in firmware-execution terms |
| 3 | System States | SM-PRD-23 | State machines whose transitions are traced in firmware-execution terms |
| 4 | Software Solution Strategy | SWA-02 | Execution model (superloop/interrupt split) determines which scenario types are even possible |

### Outputs / Dependent Artifacts (table)

| # | Dependent Artifact | ID | Relationship |
|---|---|---|---|
| 1 | Software Deployment View | SWA-05 | Timing scenarios validate the execution model meets constraint deadlines |
| 2 | Test Cases | SM-PRD-16 | Runtime scenarios are natural integration test-case sources |

### Dependencies

- **SWA-03:** Every SWA-04 scenario participant MUST already exist as an internal action or exhibited state defined there.
- **SM-PRD-22:** SWA-04 scenarios SHOULD reference the system-level scenario they elaborate, to keep both views consistent.

---

## §2 SysML v2 Mapping

### Mapping Table

| SW Architecture Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| Runtime scenario | Sequence-diagram-style `part` lifelines + `perform action` steps | [SML-DGM-SeqDiag](../../sysml2/diagrams/sequence-diagram.md) | Same mechanism already used for SM-PRD-22 Scenarios, applied to firmware-internal parts |
| Interrupt-triggered step | `perform action` inside an `accept` clause | [SML-USG-ActUSG](../../sysml2/concepts/action-usage.md) | Mirrors the `accept <EventDef>` pattern already used in `exhibit state` bodies |
| State transition trace | Reference to `exhibit state` transitions from SWA-03 | [SML-USG-StateUSG](../../sysml2/concepts/state-usage.md) | Runtime scenario walks an existing state machine rather than redefining it |
| Timing annotation | `doc` note or `attribute` duration value on a scenario step | [SML-USG-AttrUSG](../../sysml2/concepts/attribute-usage.md) | Captures timing figures (e.g. debounce window, timer tick) relevant to the scenario |

### Modeling Pattern

```sysml
package SWA_RuntimeView {
    private import ProductComponents::*;

    // Runtime scenario: one automatic-mode movement-timeout tick,
    // elaborating SM-PRD-22's system-level "Automatic Stop" scenario in
    // firmware-execution terms (superloop poll of the timer-tick countdown).
    action superloopTick {
        part supervisor : MovementSupervisorSoftware;

        perform action tick : supervisor::RunSupervisionTick {
            in elapsedMs = 10.0; // one superloop iteration's tick resolution
        }

        // If timedOut, the exhibited ControllerLifecycleState machine
        // (defined in SWA-03) transitions from Moving to Stopped.
    }
}
```

### Recommended Package Structure

```
<System>_Architecture/
  software/
    runtime_view/
      <System>_SWRuntimeScenarios.sysml   ← one action/sequence per selected runtime scenario
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Relationship | Content Contributed |
|---|---|---|---|
| [Runtime View](../../arc42/sections/runtime-view.md) | ARC-06 | **Mandatory** | Firmware-execution-level runtime scenarios (superloop, interrupt, timer-driven) |
| [Deployment View](../../arc42/sections/deployment-view.md) | ARC-07 | Recommended | Timing scenarios validate execution-context placement |

---

## §4 Traceability

### Incoming Links (table)

| Source ID | Source Name | Link Type | Description |
|---|---|---|---|
| SWA-03 | Software Building Block View | `depends_on` | Scenario participants must already exist as internal actions/states |
| SM-PRD-22 | Scenarios | `refines` | SWA-04 elaborates system-level scenarios in firmware-execution terms |
| SM-PRD-23 | System States | `depends_on` | State transitions traced here are defined there |

### Outgoing Links (table)

| Target ID | Target Name | Link Type | Description |
|---|---|---|---|
| SWA-05 | Software Deployment View | `enables` | Timing scenarios validate execution-context placement decisions |
| SM-PRD-16 | Test Cases | `enables` | Runtime scenarios are natural sources of integration test cases |
| ARC-06 | Runtime View | `documents` | Rendered as firmware-execution-level runtime scenarios |

### Traceability Rules

1. Every SWA-04 scenario participant MUST already be defined in SWA-03 — no new internal actions/states are introduced here.
2. Scenarios exercising a system-level scenario from SM-PRD-22 SHOULD explicitly reference it (e.g. via `doc` cross-reference), so both views stay traceable to each other.
3. Any timing figure used in a scenario MUST match the corresponding attribute value already defined in the Product/Software Architecture (no independently invented numbers).

---

## §5 Modeling Procedure

1. **Select architecturally significant scenarios.** From SWA-03's internal actions/states and the existing SM-PRD-22 scenarios, pick the few runtime scenarios that most need explicit documentation (e.g. those exercising timing-critical or safety-relevant paths).

2. **Model each scenario.** Use `part` lifelines for the participating firmware sub-modules and `perform action` steps for each internal action invoked, in execution order.

3. **Annotate timing.** Add relevant timing attributes/durations to each step, sourced from existing attributes (`arbitrationWindowMs`, `timerResolutionMs`, etc.) — never invent new figures here.

4. **Trace state transitions.** Where a scenario causes a state transition, reference the specific `exhibit state` transition from SWA-03 rather than re-describing it.

5. **Cross-reference the system-level scenario.** Add a `doc` note linking back to the corresponding SM-PRD-22 scenario, if one exists.

6. **Document in arc42.** Add each selected scenario as a numbered Runtime Scenario under ARC-06, following the existing arc42 numbered-scenario-slot convention.
