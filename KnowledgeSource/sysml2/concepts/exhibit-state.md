---
type: SysML v2 Concept
title: Exhibit State
description: An exhibit state usage is a state usage that specifies that a state is exhibited by the owner of the exhibit state usage, referencing a state behavior defined in another context.
timestamp: 2026-07-01T00:00:00Z
---

An exhibit state usage is declared using the kind keyword `exhibit state` (or just `exhibit` with a qualified name). It is a kind of perform action usage (see §7.17.6) for which the action usage is a state usage, known as the **exhibited state**.

An exhibit state usage is referential — the exhibited state behavior may be defined in a different context than that of the exhibitor. However, if the owner of the exhibit state usage is an occurrence, then the referenced state performance must be carried out entirely within the lifetime of the exhibiting occurrence.

An exhibit state usage can be a feature of a part definition or usage, specifying that the referenced state is exhibited by the containing part. Typically, the exhibited state and its substates reflect conditions of the exhibiting part, such as the operating states of a vehicle. The values of the exhibit state usage are references to occurrences of the state when the exhibiting part is "in" that state.

# Syntax

```sysml
// In a part definition: part exhibits a named state
partdef Vehicle {
    exhibit state operatingState references VehicleStates::operating;
    abstract exhibit state monitoringState; // Exhibited state is itself.
}

// Short form using just 'exhibit' with a qualified name
part vehicle : Vehicle {
    exhibit VehicleStates::monitoring :> Vehicle::monitoringState;
}

// Owned exhibit state in a part
part part1 : Part1 {
    exhibit state state1 : State1;
}
```

# Semantics

The exhibited state of an exhibit state usage is related to the exhibit state usage by a reference subsetting relationship, specified textually using the keyword `references` or the symbol `::>`. If no such reference subsetting exists, the exhibited state is the exhibit state usage itself.

If an exhibit state usage is in the body of a part definition or usage, the part is the performer of the exhibit state usage.

The `ref` keyword may be used in the declaration, but an exhibit state usage is always referential whether or not `ref` is included.

# Rules

- Declared using `exhibit state` or just `exhibit`.
- An exhibit state usage is always a referential usage.
- The exhibited state must be carried out within the lifetime of the exhibiting occurrence.
- The `ref` keyword may be used but is redundant (exhibit state is always referential).

# Examples

```sysml
state def State1;
state state1 : State1;
part part1 {
    exhibit state1;
}

part part1 : Part1 {
    exhibit state state1 : State1;
}
```

# Relationships

- [state-usage.md](state-usage.md) — exhibit state usage references a state usage
- [perform-action.md](perform-action.md) — exhibit state is a kind of perform action usage
- [state-definition.md](state-definition.md) — the definition of the exhibited state

# Citations

[1] OMG SysML v2 Specification, §7.18.4
