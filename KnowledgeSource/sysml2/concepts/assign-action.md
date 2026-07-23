---
type: SysML v2 Concept
title: Assign Action
description: An assign action usage is an action usage that changes the value of a referent feature of a target occurrence to a new assigned value.
timestamp: 2026-07-01T00:00:00Z
---

An assignment action usage is declared as an action usage implicitly defined by the action definition `AssignmentAction` from the `Actions` model. An `AssignmentAction` sets a referent feature of a target occurrence to a new assigned value.

The assignment part consists of:
- The keyword `assign`
- An expression that evaluates to the **target** (must be an occurrence)
- A **feature chain** identifying the referent (relative to the target), separated by `.`
- The symbol `:=`
- An expression whose result is the **assigned value**

When the assignment action completes, the referent feature has the new assigned value for the target occurrence. If the target expression is omitted, the target is implicitly the occurrence owning the assignment action usage.

# Syntax

```sysml
// Named assignment action
action updatePos assign sim.vehicle.position :=
    sim.vehicle.position + sim.vehicle.velocity * deltaT;

// Unnamed assignment (keyword can be omitted)
assign count := count + 1;

// Implicit target (the containing occurrence)
assign count := count + 1;
```

# Semantics

The target must be an occurrence because the values of features of attributes do not change over time. If the referent feature has a multiplicity upper bound other than 1, an assignment action can assign multiple values atomically.

An **initializing feature value** can be used as shorthand for assigning an initial value to a usage at the point of declaration:
- **Fixed feature value** (`:=`): evaluates and assigns immediately; cannot be overridden in a redefinition.
- **Default feature value** (`= expression`): assignment is delayed until instantiation; can be overridden by a redefinition.

# Rules

- An assignment action usage must be an owned feature of an action definition/usage, the entry/do/exit action of a state, or the owned effect of a transition usage.
- The target expression must evaluate to an occurrence.
- The last feature in the referent feature chain must be allowed to have values that vary over time.
- Values are assigned atomically when multiplicity > 1.
- Declared using `assign` (plus optional `action` keyword when unnamed).
- The base assignment action usage is `assignmentActions` from the `Actions` library model.

# Examples

```sysml
action def UpdateVehiclePosition {
    in part sim : Simulation;
    in attribute deltaT : TimeDurationValue;
    assign sim.vehicle.position :=
        sim.vehicle.position + sim.vehicle.velocity * deltaT;
}

action counter {
    attribute count : Natural := 0;
    assign count := count + 1;
}
```

# Relationships

- [action-usage.md](action-usage.md) — assign action is a kind of action usage
- [action.md](action.md) — assign actions appear within action bodies
- [if-action.md](if-action.md) — assignments often appear in then/else clauses

# Citations

[1] OMG SysML v2 Specification, §7.17.9
