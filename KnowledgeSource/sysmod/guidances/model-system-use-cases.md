---
type: SYSMOD Guidance
title: How to Model System Use Cases
description: A step-by-step guide for modeling System Use Cases in the SysML model using SYSMOD systemUseCase and continuousUseCase stereotypes in use case diagrams and tables.
timestamp: 2026-07-01T00:00:00Z
---

Guidance 7.10 in SYSMOD. This guidance describes how to model System Use Cases in the SysML system model.

# Context

- **SYSMOD Method:** [4.12 Identify System Use Cases](../methods/identify-system-use-cases.md)
- **SYSMOD Product:** [5.12 System Use Cases](../products/system-use-cases.md)
- **SYSMOD Role:** [Requirements Engineer](../roles/requirements-engineer.md)

# Description

System Use Cases are depicted in SysML use case diagrams—one diagram per primary system actor. Each use case is assigned the SYSMOD stereotype «systemUseCase» or «continuousUseCase».

# How to Model

1. Select the package `<system>_UseCases`.
2. For each primary system actor, create a SysML use case diagram named `<actor name> Use Cases`.
3. For each identified use case of the primary actor, create a SYSMOD «systemUseCase» or «continuousUseCase» and fill out the properties `name`, `trigger`, and `result`. Use the documentation field for the brief textual description of the use case.
4. Place the actors of the System Use Case on the diagram and model associations between the System Use Cases and their primary and secondary actors.
5. Optionally, create a SysML Signal named `Sig<use case name>` representing the trigger of the use case and place it in the package `Use Case Triggers`. Assign the signal to the property `signalTrigger` of the System Use Cases.

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 7.10.
