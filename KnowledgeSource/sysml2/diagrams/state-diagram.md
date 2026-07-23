---
type: SysML v2 Diagram
title: State Machine Diagram
description: A State Machine Diagram shows state definitions and usages, transitions between states with optional trigger, guard, and effect specifications, and the hierarchical decomposition of states into sub-states.
timestamp: 2026-07-01T00:00:00Z
---

The State Machine Diagram is the SysML v2 diagram type for modeling the discrete behavioral states of a system or component. It captures the states an occurrence can be in, the transitions that cause changes between states, and the entry, do, and exit actions associated with states.

A state definition is a kind of action definition that classifies the state-based behavior of an occurrence. A state usage is a kind of action usage that is a usage of a state definition.

# Purpose

State machine diagrams are used to:
- Model the discrete states of a part, item, or other occurrence.
- Show transitions between states, including trigger events, guard conditions, and effect actions.
- Decompose states into sub-states (hierarchical state machines).
- Show entry, do, and exit actions for each state.
- Show initial and final pseudostates.

# Notation

## State Symbol

A state definition or usage is shown as a rounded rectangle with the stereotype label:

```
«state def»
StateDef1
```

```
«state»
state1 : StateDef1
```

States may have compartments showing:
- **entry**: Entry action(s) performed when the state is entered.
- **do**: Do action(s) performed while in the state.
- **exit**: Exit action(s) performed when the state is exited.

## Transition

A transition is shown as a directed arrow from the source state to the target state. The transition label has the form:

```
trigger [guard] / effect
```

Where:
- **trigger**: An event or accepted occurrence that causes the transition.
- **guard**: An optional Boolean expression that must be true for the transition to fire.
- **effect**: An optional action performed when the transition fires.

In textual notation, transitions are declared using the `transition` keyword:
```
transition
    first StateA
    accept EventTrigger
    if guardCondition
    do effectAction
    then StateB;
```

## Initial and Final States

- The initial pseudostate is shown as a filled circle.
- The final state is shown as a filled circle inside a larger circle (bull's-eye).

## Hierarchical States

Sub-states are shown nested inside their containing state symbol. The state decomposition follows the same nesting rules as action usages.

# Frame and Header

The diagram frame header for a state machine diagram typically uses the identifier `state`.

# Compartments

State definition and usage symbols may include compartments for:
- **states** — nested state usages.
- **transitions** — transition usages.
- **entry**, **do**, **exit** — action usages for state lifecycle.
- **exhibit states** — states exhibited by a part.

# Examples

```
state def TrafficLight {
    entry; then Red;

    state Red {
        entry action stopVehicles;
    }
    transition Red then Green;

    state Green {
        entry action allowVehicles;
    }
    transition Green then Yellow;

    state Yellow {
        entry action cautionVehicles;
    }
    transition Yellow then Red;
}
```

State with guard and effect:
```
transition
    first Idle
    accept StartRequest [systemReady]
    do initializeSystem
    then Running;
```

# Related Concepts

- [Definition-Usage Pattern](../rules/definition-usage-pattern.md)
- [Feature Direction](../rules/feature-direction.md)
- [Action Flow Diagram](action-flow-diagram.md)

# Citations

[1] OMG SysML v2 Specification, §7.18 (States)
[2] OMG SysML v2 Specification, §7.17.1 (Actions Overview)
