---
type: SYSMOD Guidance
title: How to Model System Processes
description: A step-by-step guide for modeling System Processes in the SysML model using SYSMOD systemProcess stereotype and activity or state machine diagrams.
timestamp: 2026-07-01T00:00:00Z
---

Guidance 7.11 in SYSMOD. This guidance describes how to model System Processes in the SysML system model.

# Context

- **SYSMOD Method:** [4.13 Identify System Processes](../methods/identify-system-processes.md)
- **SYSMOD Product:** [5.13 System Processes](../products/system-processes.md)
- **SYSMOD Role:** [Requirements Engineer](../roles/requirements-engineer.md)

# Description

System Processes are modeled as SYSMOD «systemProcess» elements with associated activity diagrams that call the appropriate Use Case Activities.

# How to Model

1. Select the package `<system>_Processes`.
2. Create a SysML use case diagram named `<system> Processes`.
3. For each identified system process, create a SYSMOD «systemProcess». Use the documentation field or a linked SysML Comment to add a brief textual description.
4. For each System Process, define a SysML Activity with CallBehaviorActions that call the appropriate Use Case Activities of the included System Use Cases. Define the control and object flows as needed.

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 7.11.
