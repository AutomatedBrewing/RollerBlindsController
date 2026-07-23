---
type: SysML v2 Rule
title: Flow Typing Rules
description: A flow usage must be defined by a flow definition or KerML interaction, may carry a typed payload, and connects a source output feature to a target input feature with the constraint that the payload type must be consistent with both endpoint features.
timestamp: 2026-07-01T00:00:00Z
---

A flow definition is both a relationship and a kind of action definition that classifies transfers of some payload between interacting occurrences such as parts and actions. Flow usages represent the performance of a transfer, as classified by the flow definition.

# Rule Statement

## Flow Kinds

There are three kinds of flows:

1. **Message** (`message`): Specifies that some transfer happens between source and target ends. Defines the payload to be transferred but does not specify how the payload is obtained from the source or delivered to the target. A message is always abstract.

2. **Streaming flow** (`flow`): Specifies the source output feature (after the keyword `from`) and the target input feature (after the keyword `to`). The payload flows continuously while both source and target are performing.

3. **Succession flow** (`succession flow`): A flow usage that is also a succession. Adds the constraint that the transfer source must complete before the transfer starts, and the transfer must complete before the target can start.

## Typing Rules

- A flow usage must only be defined by **flow definitions** or KerML interactions.
- A non-abstract flow definition is always **binary**, having exactly two end features.
- The **payload** of a flow definition can be constrained by redefining the `payload` feature.
- A streaming flow declaration includes the **output feature of the source** (from which the payload is obtained) and the **input feature of the target** (to which the payload is delivered), specified using a feature chain with at least two features.
- The source feature of a streaming flow must be an **output** (`out` or `inout`) feature; the target feature must be an **input** (`in` or `inout`) feature.
- The payload type declared on the flow must be consistent with the types of the connected source output and target input features.

## Base Definitions

The base flow definition is `MessageAction` from the `Flows` library model. The base flow usages are also from the `Flows` library:
- `messages` for a message
- `flows` for a streaming flow
- `successionFlows` for a succession flow

# Rationale

Flow typing rules ensure that transfers are well-typed, meaning the kind of payload transferred is consistent with what the source can produce and the target can consume. The three flow kinds allow different levels of behavioral constraint: messages are purely declarative, streaming flows add structural constraints on endpoints, and succession flows additionally impose temporal ordering.

# Examples

```
// Flow definition with typed payload
flow def FuelFlow {
    ref item :>> payload : Fuel;
    end tank : FuelTank;
    end eng : Engine;
}

// Streaming flow usage
part def Vehicle {
    part fuelTank : FuelTank {
        out fuelOut : Fuel;
    }
    part engine : Engine {
        in fuelIn : Fuel;
    }
    flow fuelFlow : FuelFlow of flowingFuel : Fuel
        from fuelTank.fuelOut to engine.fuelIn;
}

// Succession flow usage (adds ordering constraint)
action def TakePicture {
    action focus : Focus {
        out image : Image;
    }
    action shoot : Shoot {
        in image : Image;
    }
    succession flow focus.image to shoot.image;
}

// Message (abstract)
part def Vehicle {
    attribute def ControlSignal;
    part controller { event occurrence sendControl; }
    part engine { event occurrence receiveControl; }
    message of ControlSignal
        from controller.sendControl to engine.receiveControl;
}
```

# Violations

- Declaring a non-abstract flow definition with fewer or more than two end features.
- Declaring a flow usage defined by a non-flow definition.
- Specifying a source feature that is not an output (`out` or `inout`) feature.
- Specifying a target feature that is not an input (`in` or `inout`) feature.
- Specifying a payload type that is incompatible with the source output or target input feature types.

# Related Concepts

- [Feature Direction](feature-direction.md)
- [Conjugation Rules](conjugation-rules.md)
- [Definition-Usage Pattern](definition-usage-pattern.md)

# Citations

[1] OMG SysML v2 Specification, §7.16.1 (Flows and Messages Overview)
[2] OMG SysML v2 Specification, §7.16.2 (Flow Definitions and Usages)
