---
type: SYSMOD Product
title: System States
description: The System States describe the relevant conditions of the system or parts of the system, acting as pre- and postconditions of functions that control behavior when events are received.
timestamp: 2026-07-01T00:00:00Z
---

Product 5.23 in SYSMOD. The System States are pre- and postconditions of functions and control the behavior of the system and system parts when events are received.

# Purpose

The System States are pre- and postconditions of functions and control the behavior of the system and system parts when events are received.

# Description

The System States described in this section are part of an architecture. In the context of System Use Cases, the modeling of states is part of a System Process.

The System States are used to specify the behavior of system parts, including the whole system. A state represents a condition and specifies the reaction when an event is received. A reaction could be the execution of a function, the transition to another state, or both.

# Relationships

**Responsibility:** [System Architect](../roles/system-architect.md)

**Output of Methods:**
- [4.21 Define System States](../methods/define-system-states.md)

**Input of Methods:** None

**Representation:** SysML state machine diagram.

**Related Guidance:** [7.18 How to Model System States](../guidances/model-system-states.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 5.23.
