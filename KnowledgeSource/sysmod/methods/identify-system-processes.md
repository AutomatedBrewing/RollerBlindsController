---
type: SYSMOD Method
title: Identify System Processes
description: Describe the logical order of execution of the System Use Cases to make dependencies and valid execution sequences explicit.
timestamp: 2026-07-01T00:00:00Z
---

Method 4.13 in SYSMOD. The System Processes specify the valid logical orders of execution of the System Use Cases.

# Purpose

The System Processes specify the valid logical orders of execution of the System Use Cases.

# Description

Some System Use Cases can only be performed if another use case was performed before, or if the system is in a specific state. Such dependencies can be defined by the pre- and postconditions of the use cases: a postcondition of one use case can satisfy the precondition of another.

A System Process makes such dependencies explicit. It can be a flow-oriented or a state-oriented description that specifies the execution order of use cases. A System Process is a special use case with flow- or event-oriented behavior.

# Relationships

**Primary Performer:** [Requirements Engineer](../roles/requirements-engineer.md)

**Inputs:**
- [5.12 System Use Cases](../products/system-use-cases.md)

**Outputs:**
- [5.13 System Processes](../products/system-processes.md)

**ISO 15288 Process:** Stakeholder Needs and Requirements Definition; System Requirements Definition

**Guidance:**
- [7.11 How to Model System Processes](../guidances/model-system-processes.md)

**Part of Process:**
- [SYSMOD Analysis Process](../processes/analysis-process.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 4.13.
