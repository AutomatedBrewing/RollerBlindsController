---
type: SysML v2 Diagram
title: Action Flow Diagram
description: An Action Flow Diagram shows action definitions and usages, control flow between actions using successions, data flow between actions using flows, and the decomposition of actions into nested sub-actions.
timestamp: 2026-07-01T00:00:00Z
---

The Action Flow Diagram is the SysML v2 diagram type for modeling behavioral flows. It captures the performance of actions, the sequencing between actions via successions, data and item transfers via flows, and control structures such as fork, join, decision, and merge nodes. It is analogous to the Activity Diagram of UML/SysML v1.

An action definition classifies action performances. An action usage is a kind of occurrence usage that is a usage of one or more action definitions.

# Purpose

Action flow diagrams are used to:
- Decompose system or component behavior into hierarchies of action usages.
- Show the sequencing and ordering of actions using succession relationships.
- Show transfers of items/data between action parameters using flows.
- Model control structures: fork (parallel split), join (parallel synchronize), decision (conditional branch), and merge (conditional rejoin) nodes.
- Show parameters (in, out, inout) of actions and bindings between them.
- Model send and accept actions for event-based transfers.

# Notation

## Action Symbol

An action definition or usage is shown as a rounded rectangle:

```
«action def»
ActionDef1
```

```
«action»
action1 : ActionDef1
```

Parameters are shown as features with direction keywords:
```
«action»
action1 : ActionDef1
  in param1 : Type1
  out result1 : Type2
```

## Succession (Control Flow)

A succession between action usages shows ordering: the source action must complete (or start) before the target action. It is shown as a directed solid arrow from source to target. A guarded succession has a Boolean guard condition displayed on the arrow.

Textual notation:
```
first focus then shoot;
then timeslice postflight[1];
```

## Flow (Data Flow)

A streaming flow is shown as a directed dashed arrow from the output parameter of the source action to the input parameter of the target action, with an optional payload type label:

```
flow action1.outputParam to action2.inputParam;
```

A succession flow combines a flow and a succession arrow.

## Control Nodes

Control nodes are special action usages shown with specific symbols:
- **Fork node**: Splits one incoming succession into multiple parallel outgoing successions.
- **Join node**: Waits for all incoming successions before allowing the single outgoing succession.
- **Decision node**: Routes one incoming succession to exactly one of multiple guarded outgoing successions.
- **Merge node**: Allows the outgoing succession when any one of multiple incoming successions completes.

# Frame and Header

The diagram frame header for an action flow diagram typically uses the identifier `act` (for action).

# Compartments

Action definition and usage symbols may include compartments:
- **actions** — nested action usages.
- **flows** — flow usages between actions.
- Succession relationships shown inline between action compartment entries using `then`.

# Examples

```
action def TakePicture {
    in subject : Scene;
    out photo : Image;

    action focus : Focus {
        in sceneFocus : Scene;
        out image : Image;
    }
    action shoot : Shoot {
        in image : Image;
        out photo : Image;
    }

    bind focus.sceneFocus = subject;
    succession flow focus.image to shoot.image;
    bind shoot.photo = photo;
}
```

Structured control:
```
action def ControlledAction {
    action init;
    then action process;
    then action finalize;
}
```

# Related Concepts

- [Feature Direction](../rules/feature-direction.md)
- [Flow Typing Rules](../rules/flow-typing-rules.md)
- [Definition-Usage Pattern](../rules/definition-usage-pattern.md)

# Citations

[1] OMG SysML v2 Specification, §7.17.1 (Actions Overview)
[2] OMG SysML v2 Specification, §7.16.1 (Flows and Messages Overview)
[3] OMG SysML v2 Specification, §7.13.5 (Successions as Usages)
[4] OMG SysML v2 Specification, Table 15 (Actions – Representative Notation)
