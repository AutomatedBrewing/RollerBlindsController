---
type: Software Architecture Artifact
title: Software Runtime View
description: Firmware-level dynamic behaviour — task/loop scheduling, inter-module scenarios, interrupt handling, and state-machine execution traces.
timestamp: 2026-07-01T00:00:00Z
---

Artifact SWA-04. The Software Runtime View shows how the firmware building
blocks (SWA-03) actually execute and interact at runtime, extending the
system-level Scenarios (SM-PRD-22) into the software's own execution
mechanics (superloop iteration, interrupt preemption, timer ticks).

# Purpose

While system-level Scenarios (SM-PRD-22) show *what* collaborates to fulfil
a use case (e.g. "user presses UP, shutter starts moving"), the Software
Runtime View shows *how* that collaboration is actually scheduled and
executed inside the firmware: which function runs in the main loop, which
runs in an interrupt handler, in what order, and with what timing
guarantees. This is essential for an embedded system where there is no
scheduler to hide these details.

# Description

Typical scenarios documented here:

- **Superloop iteration** — one pass through the bare-metal main loop,
  showing which firmware modules' "do" actions are polled each cycle.
- **Interrupt-driven event handling** — e.g. a GPIO-change interrupt
  triggering `CommandArbitrationSoftware`'s debounce logic, and how control
  returns to the interrupted main-loop context.
- **Timer-tick-driven supervision** — `MovementSupervisorSoftware`'s
  timeout countdown, showing the periodic timer tick advancing elapsed
  time and triggering the automatic-mode stop transition (ADR-003).
- **State-machine execution trace** — a concrete walk through
  `ControllerLifecycleState` transitions once they are exhibited on a
  firmware `part def` (SWA-03), showing the triggering events in firmware
  terms (interrupt, timer, or polled flag) rather than abstract
  system-level events.

# Relationships

**Responsibility:** Software Architect (project role).

**Primary Inputs:**
- [Software Building Block View](building-block-view.md) (SWA-03) — internal actions and exhibited states are the participants in these scenarios.
- [Scenarios](../../sysmod/products/scenarios.md) (SM-PRD-22) — system-level scenarios this view elaborates in firmware-execution terms.
- [System States](../../sysmod/products/system-states.md) (SM-PRD-23) — state machines whose transitions are traced here.

**Outputs consumed by:**
- [Software Deployment View](deployment-view.md) (SWA-05) — timing scenarios validate that the chosen execution model (superloop/interrupt mix) meets constraint deadlines.
- [Test Cases](../../sysmod/products/test-cases.md) (SM-PRD-16) — runtime scenarios are natural sources of integration test cases.

**Representation:** Sequence-diagram-style `part` usage lifelines and `perform action` steps (same `SML-DGM-SeqDiag` mechanism as SM-PRD-22 Scenarios), plus `state` transition traces referencing the `exhibit state` machines from SWA-03. No new SysML v2 concepts.

**Cross-mapping:** [crossmapping/runtime-view.md](../crossmapping/runtime-view.md)

# Citations

- arc42 Architecture Documentation Framework, Section 6 (Runtime View).
- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 5.22 (Scenarios — the system-level precedent this artifact elaborates).
