---
type: SYSMOD Method
title: Describe the Base Architecture
description: Define the given physical architecture at the project start that constrains the solution space and sets the abstraction level for system requirements.
timestamp: 2026-07-01T00:00:00Z
---

Method 4.7 in SYSMOD. Most Requirements already include some technical decisions. The Base Architecture defines the technical decisions that are already fixed at the beginning of a project.

# Purpose

The Base Architecture defines the level of abstraction of the Requirements and provides the scope for innovation and architectural and technical decisions.

# Description

The Base Architecture represents the system architecture that is already fixed before the project starts. A car has four wheels, an aircraft two wings—these are typically set at project start and the engineers do not consider different solutions.

If the Base Architecture is more abstract, the solution space opens. If it is more concrete, there is little space for innovation. A manufacturer releasing a new product version annually has a concrete Base Architecture (based on the predecessor). A company developing an entirely new product needs a very abstract Base Architecture.

The Base Architecture description can be reused for projects of similar systems.

Furthermore, the Base Architecture is an excellent source to spot potential for disruptive innovations: it covers concepts like "We have always done it that way?" and you can ask "What if we change our common architectural approaches?".

# Relationships

**Primary Performer:** [System Architect](../roles/system-architect.md)

**Inputs:**
- [5.5 System Idea](../products/system-idea.md)
- [5.6 System Objectives](../products/system-objectives.md)

**Outputs:**
- [5.7 Base Architecture](../products/base-architecture.md)

**ISO 15288 Process:** Business Mission Analysis

**Guidance:**
- [7.5 How to Model the Base Architecture](../guidances/model-base-architecture.md)

**Part of Process:**
- [SYSMOD Analysis Process](../processes/analysis-process.md)

**Related Tools:**
- [Zigzag Pattern](../tools/zigzag-pattern.md)
- [Coupling of System Architectures](../tools/coupling-system-architectures.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 4.7.
