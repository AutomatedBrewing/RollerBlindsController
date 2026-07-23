---
type: SYSMOD Product
title: System Processes
description: The System Processes specify the logical order of execution of the System Use Cases, describing uses of the system on a higher level than the individual use cases.
timestamp: 2026-07-01T00:00:00Z
---

Product 5.13 in SYSMOD. The System Processes describe the uses of the system on a higher level than the System Use Cases.

# Purpose

The System Processes describe the uses of the system on a higher level than the System Use Cases.

# Description

The System Process is a process description on a higher level than the System Use Cases. For example, the process starting with the installation and initial setup of the system via some operational functions to shutdown and deinstallation.

Typically, a System Process is a flow-oriented behavior describing the logical order of the System Use Cases. Alternatively, a System Process can describe event-oriented behavior in the form of a state machine.

A System Process is a special use case with a flow- or event-oriented behavior.

# Relationships

**Responsibility:** [Requirements Engineer](../roles/requirements-engineer.md)

**Output of Methods:**
- [4.13 Identify System Processes](../methods/identify-system-processes.md)

**Input of Methods:** None

**Representation:**
- SysML use case diagrams with SYSMOD stereotype «systemProcess»
- SysML activity diagram or state machine diagram

**Related Guidance:** [7.11 How to Model System Processes](../guidances/model-system-processes.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 5.13.
