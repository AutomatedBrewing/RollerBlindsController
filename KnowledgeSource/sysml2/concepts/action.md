---
type: SysML v2 Concept
title: Action
description: An action is an occurrence over time that coordinates the performance of sub-actions and generates effects on items and parts involved in the performance.
timestamp: 2026-07-01T00:00:00Z
---

Actions are occurrences over time that can coordinate the performance of other actions and generate effects on items and parts involved in the performance, including those items' existence and relation to other things. An action is classified by an action definition and may have parameters with directions `in`, `out`, or `inout`.

The features of an action definition or usage that are themselves action usages specify the performance of the action in terms of the performances of each sub-action. If an action has parameters, it may also transform the values of its input parameters into values of its output parameters.

Actions can be decomposed into lower-level action usages to create an action tree, and action usages can be referenced by other actions. The sequencing of action usages may be specified using successions, and further controlled using control nodes (fork, join, decision, merge).

# Syntax

```sysml
action def ActionDef1;

action def ActionDef1 {
    /* members */
}

action action1 : ActionDef1;

action action1 : ActionDef1 {
    /* members */
}

// Action with parameters
action action1 {
    inout param1 : ItemDef1;
    out param2 : ItemDef2;
}
```

# Semantics

Actions are occurrences over time. An action definition classifies action performances; an action usage is a usage of one or more action definitions that inherits the definitions' parameters. The sub-actions of an action are specified as action usages within its body and their ordering is controlled via successions and control nodes.

# Rules

- An action usage must only be defined by action definitions (of any kind) or KerML behaviors.
- Directed features in the body of an action definition or usage are owned parameters: `in` = input, `out` = output, `inout` = both.
- If an action definition has multiple superclassifications, every parameter from every general definition must be redefined by an owned parameter.
- Every action inherits `start` and `done` features from `Actions::Action`.
- The base action definition and usage are `Action` and `actions` from the `Actions` library model.

# Examples

```sysml
action def TakePicture {
    in scene : Scene;
    out picture : Picture;

    bind focus.scene = scene;
    action focus : Focus { in scene; out image; }
    first focus then shoot;
    flow focus.image to shoot.image;
    action shoot : Shoot { in image; out picture; }
    bind picture = shoot.picture;
}
```

# Relationships

- [action-definition.md](action-definition.md) — defines the type of an action
- [action-usage.md](action-usage.md) — usage of an action definition
- [perform-action.md](perform-action.md) — referential usage specifying a part performs an action
- [succession.md](succession.md) — sequences action usages in time
- [fork-node.md](fork-node.md) — splits control flow to concurrent actions
- [join-node.md](join-node.md) — synchronizes concurrent actions
- [decision-node.md](decision-node.md) — selects one of multiple outgoing actions
- [merge-node.md](merge-node.md) — merges multiple incoming flows into one

# Citations

[1] OMG SysML v2 Specification, §7.17
