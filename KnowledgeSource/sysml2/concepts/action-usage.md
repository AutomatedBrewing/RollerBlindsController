---
type: SysML v2 Concept
title: Action Usage
description: An action usage is a kind of occurrence usage that is typed by one or more action definitions and specifies the performance of an action within a containing context.
timestamp: 2026-07-01T00:00:00Z
---

An action usage is a kind of occurrence usage that is a usage of one or more action definitions. An action usage inherits the parameters of its definitions and can also define its own parameters to augment or redefine those of its definitions.

Action usages are occurrences over time that coordinate the performance of other (sub-)actions. The features of an action usage that are themselves action usages specify the performance of the action in terms of the performances of each sub-action.

Action usages can be decomposed into lower-level action usages to create an action tree. An action usage can be subsetted or redefined. Action usages within a containing action are sequenced using successions and controlled using control nodes.

# Syntax

```sysml
action action1 : ActionDef1;

action action1 : ActionDef1 {
    /* members */
}

// With redefined parameters
action focus : Focus {
    in scene;
    out image;
}

action refocus subsets focus; // Parameters are inherited.
```

# Semantics

An action usage may have any type of specialization relationship (feature typing, subsetting, or redefinition) with an action definition or usage. The rules for parameter redefinition are the same as for action definitions. Binding connection usages and flow usages can be used to connect sub-actions within the body of an action usage.

# Rules

- An action usage must only be defined by action definitions (of any kind) or KerML behaviors.
- Directed features in the body of an action usage are owned parameters.
- Declared using the kind keyword `action`.
- The base action usage is `actions` from the `Actions` library model.

# Examples

```sysml
action action1 : ActionDef1 [1..*] ordered nonunique;

action action1 : Action1 {
    in input1;
    bind input1 = action2.input2;
    action action2 : Action2 { in input2; out output2; }
    flow action2.output2 to action3.input3;
    action action3 : Action3 { in input3; out output3; }
    bind action3.output3 = output1;
    out output1;
}
```

# Relationships

- [action-definition.md](action-definition.md) — the definition that types this action usage
- [action.md](action.md) — general concept of an action
- [perform-action.md](perform-action.md) — referential action usage
- [succession.md](succession.md) — sequences action usages in time

# Citations

[1] OMG SysML v2 Specification, §7.17
