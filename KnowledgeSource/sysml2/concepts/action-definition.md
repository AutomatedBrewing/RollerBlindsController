---
type: SysML v2 Concept
title: Action Definition
description: An action definition is a kind of occurrence definition that classifies action performances and may declare directed parameters and sub-action usages.
timestamp: 2026-07-01T00:00:00Z
---

An action definition is a kind of occurrence definition (see §7.9) that classifies action performances. It may have features with directions `in`, `out`, or `inout` that act as the parameters of the action. Features with direction `in` or `inout` are input parameters; features with direction `out` or `inout` are output parameters.

An action definition may contain nested action usages that specify the performance of the action in terms of sub-actions, connected by binding connections and flow usages. An action definition can be subclassified by another action definition, with parameter redefinition rules applied to maintain consistency of parameter sequences.

# Syntax

```sysml
action def ActionDef1;

action def ActionDef1 {
    /* members */
}

// With parameters
action def TakePicture {
    in scene : Scene;
    out picture : Picture;
    // sub-actions and flows...
}

// Specialization
action def A { in a1; out a2; }
action def B { in b1; out b2; }
action def C specializes A, B {
    in c1 redefines a1 redefines b1;
    out c2 redefines a2 redefines b2;
}
```

# Semantics

An action definition is the classifier for action usages. It specifies the behavioral type of an action, including what parameters it takes and produces, and how its sub-actions are organized. Each owned parameter of a specialized action definition must redefine, in order, the parameter at the same position in each of the general action definitions being specialized.

# Rules

- Declared using the kind keyword `action def`.
- Directed features in the body are owned parameters.
- If an action definition has a single superclassification, it may declare fewer owned parameters than the general, inheriting additional parameters.
- If there is more than one superclassification, every parameter from every general action definition must be redefined by an owned parameter.
- Redefining parameters must have the same direction as the redefined parameters.
- The base action definition is `Action` from the `Actions` library model.

# Examples

```sysml
action def ProvidePower {
    in fuelCmd : FuelCmd;
    action generatePower : GeneratePower {
        in fuelCmd : FuelCmd = providePower::fuelCmd;
        out generatedTorque : Torque;
    }
    flow generatePower.generatedTorque to transmitPower.generatedTorque;
    action transmitPower : TransmitPower {
        in generatedTorque : Torque;
        out transmittedTorque;
    }
}
```

# Relationships

- [action.md](action.md) — general concept of an action
- [action-usage.md](action-usage.md) — usage typed by an action definition
- [occurrence.md](occurrence.md) — action definition is a kind of occurrence definition

# Citations

[1] OMG SysML v2 Specification, §7.17
