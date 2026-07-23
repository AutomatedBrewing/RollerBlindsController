---
type: SYSMOD Method
title: Define System States
description: Define the states, state transitions, and state-controlled functions of the system and parts of the system that constrain the execution of functions.
timestamp: 2026-07-01T00:00:00Z
---

Method 4.21 in SYSMOD. The states and transitions of a system specify the conditions of the whole system or parts of the system that constrain the execution of functions.

# Purpose

The states and transitions of a system specify the conditions of the whole system or parts of the system that constrain the execution of functions.

# Description

A state describes a condition of the system or system part—for example, active or maintenance mode. It further specifies which functions can be performed in a state. A transition specifies the trigger and guard condition to switch from one state to another. They are specified by state machines.

State machines can also be used to refine Requirements, for example, as the specification of a System Process.

# Relationships

**Primary Performer:** [System Architect](../roles/system-architect.md)

**Inputs:**
- [5.19 Physical Architecture](../products/physical-architecture.md)

**Outputs:**
- [5.23 System States](../products/system-states.md)

**ISO 15288 Process:** Stakeholder Needs and Requirements Definition; System Requirements Definition; Architecture Definition; Design Definition

**Guidance:**
- [7.18 How to Model System States](../guidances/model-system-states.md)

**Part of Process:**
- [SYSMOD Architecture Process](../processes/architecture-process.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 4.21.
