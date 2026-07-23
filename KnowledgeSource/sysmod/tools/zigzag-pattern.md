---
type: SYSMOD Tool
title: Zigzag Pattern
description: The Zigzag Pattern describes the iterative what/how relationship between requirements and architectures across multiple abstraction levels, showing that requirements always contain implicit solution aspects.
timestamp: 2026-07-01T00:00:00Z
---

Tool 11.6 in SYSMOD. Requirements should not anticipate the solution, yet in practice requirements always contain some solution aspects.

# Purpose

The Zigzag Pattern helps engineers understand and manage the iterative nature of requirements and architecture derivation across multiple abstraction levels.

# Description

Requirements describe the What, and the system architecture describes the How. However, once you derive a Logical Architecture that satisfies the Requirements, the solution itself leads to new Requirements about aspects of the solution.

For example, Requirements about a transportation system lead to a Logical Architecture specifying a car. The car solution leads to new Requirements about car features like the engine. These engine requirements are solution-free from the viewpoint of this level, but they contain solution aspects from the previous level.

All the steps represent a zigzag pattern: Requirements → Architecture → Requirements → Architecture. This iterative zigzag continues through multiple levels of abstraction.

Requirements in practice always contain some solution aspects, often implicit. These implicit assumptions are one of the causes why Requirements are a sore spot of many projects. You should always describe the architecture that lies behind your Requirements—this architecture is the Base Architecture.

# Relationships

**Related Products:**
- [5.7 Base Architecture](../products/base-architecture.md)
- [5.10 Requirements](../products/requirements.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 11.6.
