---
type: SYSMOD Method
title: Model Use Case Activities
description: Model the behavior of the System Use Cases by specifying their functional decomposition, sequence of execution, and object flow between system functions.
timestamp: 2026-07-01T00:00:00Z
---

Method 4.14 in SYSMOD. The Use Case Activities specify the functional decomposition of the System Use Cases and, thus, the overall system in the problem space. They define the sequence of execution and object flow between the system functions.

# Purpose

The Use Case Activities specify the functional decomposition of the System Use Cases and, thus, the overall system in the problem space. They define the sequence of execution and object flow between the system functions.

# Description

A System Use Case specifies a name, a trigger, and a result. The Use Case Activity specifies the behavior of a System Use Case. The specification can be a rough description or an unambiguous and detailed specification of the included use case steps. The level of detail depends on the needs of your project.

Each step of a Use Case Activity is again specified with a Use Case Activity. The Use Case Activities that need no further refinements have no included steps. A use case step can also be called a system function.

A Use Case Activity includes the description of the input and output objects of the steps. The relationship of an output object of a step to an input of another step is called object flow.

It is good practice to separate the use case steps responsible for the input and output of objects from and to the system actors from all the other steps. These I/O steps depend on interface technologies, which are typically more unstable than the core steps.

# Relationships

**Primary Performer:** [Requirements Engineer](../roles/requirements-engineer.md)

**Inputs:**
- [5.12 System Use Cases](../products/system-use-cases.md)
- [5.10 Requirements](../products/requirements.md)

**Outputs:**
- [5.14 Use Case Activities](../products/use-case-activities.md)

**ISO 15288 Process:** Stakeholder Needs and Requirements Definition; System Requirements Definition

**Guidance:**
- [7.12 How to Model Use Case Activities](../guidances/model-use-case-activities.md)

**Part of Process:**
- [SYSMOD Analysis Process](../processes/analysis-process.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 4.14.
