---
type: SYSMOD Guidance
title: How to Revise an Architecture with Scenarios
description: A step-by-step guide for creating scenarios in the SysML model using SysML Interaction and sequence diagrams to validate architecture against use case activity paths.
timestamp: 2026-07-01T00:00:00Z
---

Guidance 7.17 in SYSMOD. This guidance describes how to revise an architecture with scenarios in the SysML system model.

# Context

- **SYSMOD Method:** [4.20 Revise an Architecture with Scenarios](../methods/revise-architecture-scenarios.md)
- **SYSMOD Product:** [5.22 Scenarios](../products/scenarios.md)
- **SYSMOD Role:** [System Architect](../roles/system-architect.md)

# Description

A Scenario maps one path through a Use Case Activity to the architecture. Creating a scenario forces the modeler to check whether all necessary parts and connections exist.

# How to Model

1. Select the context element of the scenario. Typically, it is either the System Context or the root element of an architecture, but it can be any block of the system.
2. Create a SysML Interaction and a SysML sequence diagram with the name of the scenario.
3. Model a SysML Trace relationship from the interaction model element to the Use Case Activity that specifies the behavior of the scenario.
4. Place the part and reference properties that are the interaction partners of the scenario as lifelines on the sequence diagram.
5. Model the messages between the lifelines based on a single path in the related Use Case Activity.

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 7.17.
