---
type: Software Architecture Artifact
title: Software Architecture Constraints
description: Non-negotiable technical and resource constraints (MCU flash/RAM budget, execution model, timing granularity) that bound the internal software design space, continuing the Base Architecture constraint pattern into the firmware level.
timestamp: 2026-07-01T00:00:00Z
---

Artifact SWA-01. Software Architecture Constraints document the conditions
that are already fixed before internal firmware design begins, in the same
sense that SYSMOD's Base Architecture (SM-PRD-07) documents constraints
before the Logical Architecture is designed — but scoped to the software
discipline and only actionable once concrete hardware is known from the
Product Architecture (SM-PRD-21).

# Purpose

Software Architecture Constraints record the non-negotiable technical
conditions — memory budget, MCU architecture, real-time/timing granularity,
toolchain, absence of an OS/scheduler — that restrict how the firmware
internal to each Product Architecture component may be structured. They
exist because the Product Architecture already fixed the hardware (e.g., an
8-bit MCU with 16 KB flash / 1 KB RAM); the software design has no discretion
to change that, only to work within it.

# Description

Unlike the Base Architecture (SM-PRD-07), which is set **before** any system
model exists, Software Architecture Constraints are derived **from** the
already-modelled Product Architecture: MCU family, clock speed, flash/RAM
capacity, and peripheral counts are read directly from the `part def`
attributes already present on the hardware component (e.g. `ControlMCU`).
They also inherit any relevant Base Architecture constraints that propagate
downward (e.g. a cost constraint that rules out an RTOS license, or a
`noPositionFeedback` constraint that rules out interrupt-driven position
polling).

Typical categories:

| Category | Examples |
|----------|---------|
| Resource constraints | Flash/RAM budget per firmware module, stack depth limits |
| Execution-model constraints | No RTOS/scheduler available (bare-metal superloop only), single core |
| Timing constraints | Minimum timer tick resolution, maximum interrupt latency, debounce windows |
| Toolchain constraints | Fixed compiler/SDK version, no dynamic memory allocation |

# Relationships

**Responsibility:** System Architect / Software Architect (project role).

**Primary Input:** [Product Architecture](../../sysmod/products/product-architecture.md) (SM-PRD-21) — hardware attribute values (flash, RAM, clock speed) become constraint bounds.

**Secondary Input:** [Base Architecture](../../sysmod/products/base-architecture.md) (SM-PRD-07) — project-wide constraints (cost, isolation, no-position-feedback) that also bind the software.

**Output consumed by:** [Software Solution Strategy](solution-strategy.md) (SWA-02), [Software Building Block View](building-block-view.md) (SWA-03).

**Representation:** SysML v2 `requirement` usages with `require constraint` bodies, mirroring the project's existing `L0_Constraints` pattern (see `Project/Model/Architecture/base/Constraints.sysml`) rather than the generic `constraint def` + `@ConstraintMeta` pattern shown in the base-architecture crossmapping example.

**Cross-mapping:** [crossmapping/architecture-constraints.md](../crossmapping/architecture-constraints.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 5.7 (Base Architecture — constraint pattern precedent).
- arc42 Architecture Documentation Framework, Section 2 (Architecture Constraints).
