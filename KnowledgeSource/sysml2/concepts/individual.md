---
type: SysML v2 Concept
title: Individual
description: An individual is an occurrence definition or usage that represents a single, unique real or perceived object with a unique identity, distinguished from general class definitions that classify many instances.
timestamp: 2026-07-01T00:00:00Z
---

An **individual** in SysML v2 restricts an occurrence definition or usage to represent a single, uniquely identifiable real or perceived object. Whereas a regular occurrence definition classifies a whole class of similar occurrences, an individual occurrence definition classifies exactly one specific entity.

Individual occurrence definitions are declared using the `individual` keyword placed before the kind keyword. An individual can represent a specific car (e.g., `Car1`), a specific aircraft (`TestPlane_1`), or any other uniquely identified entity. An individual definition inherits all features of its general parent definition but has individual values for each.

An individual occurrence usage is used to model a role that an individual plays within a specific context.

# Syntax

```sysml
// Individual occurrence definition
individual def Flight_248 :> Flight;

// Individual part definition
individual part def TestPlane_1 :> Aircraft;

// Individual occurrence usage
individual flightRecord : Flight_248 {
    individual part redefines aircraft : TestPlane_1;
    individual timeslice redefines preflight;
    individual timeslice redefines inflight;
    individual timeslice redefines postflight;
}

// Shorthand: 'individual' used in place of kind keyword
individual occurrence1 : OccurrenceDef1;
```

# Semantics

- An individual occurrence definition classifies exactly one specific object in the world.
- An individual occurrence definition may include time slices and snapshots to model different phases and points in the lifetime of the individual.
- An individual occurrence usage must have at most one definition that is an individual definition.
- An occurrence usage is implicitly individual if it has a definition that is an individual definition.
- Lifetimes of individuals and their time slices can be actual or projected.

# Rules

- An individual occurrence definition is declared with `individual` placed immediately before the kind keyword (e.g., `individual def`, `individual part def`).
- An individual occurrence usage is declared with `individual` placed after other usage property keywords but before any `timeslice` or `snapshot` keyword.
- An occurrence usage must not have more than one definition that is an individual definition.
- If `individual` is used in place of the kind keyword, it is equivalent to `individual occurrence`.

# Examples

```sysml
// Model a specific car
part def Car {
    part engine : Engine;
    part wheels[4] : Wheel;
}
individual part def Car1 :> Car;

// Model a specific flight
individual def Flight_248 :> Flight;
individual flightRecord : Flight_248;
```

# Relationships

- [occurrence.md](occurrence.md) — general occurrence concept
- [timeslice.md](timeslice.md) — time slices of individuals
- [snapshot.md](snapshot.md) — snapshots of individuals

# Citations

[1] OMG SysML v2 Specification, §7.9
