---
type: SYSMOD Guidance
title: How to Model System States
description: A step-by-step guide for modeling system states in the SysML model using SysML StateMachine and state machine diagrams with states, transitions, and use case activity effects.
timestamp: 2026-07-01T00:00:00Z
---

Guidance 7.18 in SYSMOD. This guidance describes how to model System States in the SysML system model.

# Context

- **SYSMOD Method:** [4.21 Define System States](../methods/define-system-states.md)
- **SYSMOD Product:** [5.23 System States](../products/system-states.md)
- **SYSMOD Role:** [System Architect](../roles/system-architect.md)

# Description

State machines model the conditions of the system and the reactions when events are received. A transition can call a Use Case Activity as its effect—the transition must own the effect behavior (not the Use Case Activity itself), so an intermediate activity with a CallBehaviorAction is used.

# How to Model

1. Select the context element (owner) of the state machine, for example, the root element of an architecture.
2. Create a SysML StateMachine and a SysML state machine diagram with the name of the state machine.
3. Model the states and transitions as needed.

Note: A transition between `<state 1>` and `<state 2>` triggered by a System Use Case trigger has the appropriate Use Case Activity as its effect via a CallBehaviorAction. The effect activity calls the Use Case Activity. `<state 1>` fulfills the precondition of the System Use Case, and `<state 2>` is a postcondition.

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 7.18.
