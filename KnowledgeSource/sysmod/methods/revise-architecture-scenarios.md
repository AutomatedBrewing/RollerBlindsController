---
type: SYSMOD Method
title: Revise an Architecture with Scenarios
description: Revise a system architecture with usage scenarios that map paths through use case activities to architecture elements, verifying all necessary parts and interfaces are correctly defined.
timestamp: 2026-07-01T00:00:00Z
---

Method 4.20 in SYSMOD. A Scenario maps a path through a Use Case Activity to an architecture and thereby tests if all necessary parts, structures, and interfaces are correctly defined.

# Purpose

A Scenario maps a path through a Use Case Activity to an architecture and thereby tests if all necessary parts, structures, and interfaces are correctly defined.

# Description

The Scenarios describe the collaboration of system parts to perform paths through the Use Case Activities. A path is one valid order of execution of the functions of a Use Case Activity. Each function is implemented by one or more parts and connections of the architecture.

The Scenario describes the messages sent from one part to another, which part performs which function, and which connections between the parts are necessary.

When specifying a scenario, you must necessarily check if all necessary parts and connections are correctly defined in the model. The modeler does a virtual tour through the system and checks if everything is in place.

# Relationships

**Primary Performer:** [System Architect](../roles/system-architect.md)

**Inputs:**
- [5.19 Physical Architecture](../products/physical-architecture.md)

**Outputs:**
- [5.22 Scenarios](../products/scenarios.md)

**ISO 15288 Process:** Architecture Definition; Design Definition

**Guidance:**
- [7.17 How to Revise an Architecture with Scenarios](../guidances/revise-architecture-scenarios.md)

**Part of Process:**
- [SYSMOD Architecture Process](../processes/architecture-process.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 4.20.
