---
type: SysML v2 Concept
title: Timeslice
description: A timeslice is a portion of an occurrence's lifetime that corresponds to some duration of time, representing a period or phase of that lifetime such as an assembly phase or an operational phase.
timestamp: 2026-07-01T00:00:00Z
---

A **timeslice** is a portion of an occurrence's lifetime that has a non-zero duration. Timeslices represent phases or periods within the lifetime of an occurrence—such as a preflight phase, an operational phase, or an assembly phase. Timeslices can themselves be further partitioned into other timeslices.

A timeslice is declared using the `timeslice` keyword, optionally placed before the kind keyword of an occurrence usage declaration. Timeslices must be declared within the body of an occurrence definition or usage of any kind.

The lifetime of an occurrence can be partitioned into sequential timeslices, which can be ordered using successions. Successions between timeslices can be declared using the shorthand `then` keyword placed before the next timeslice declaration.

# Syntax

```sysml
// Timeslices declared in an occurrence definition
occurrence def Flight {
    ref part aircraft : Aircraft;
    timeslice preflight;
    timeslice inflight;
    timeslice postflight;
}

// Ordered timeslices using succession shorthand
occurrence def Flight {
    timeslice preflight[1];
    then timeslice inflight[1];
    then timeslice postflight[1];
}

// Timeslice of a specialized kind (e.g., part)
individual part individual1 : Individual1 {
    timeslice timeslice1 {
        snapshot snapshot1;
    }
    timeslice timeslice2;
}

// Shorthand: 'timeslice' used in place of kind keyword
timeslice phase1;  // equivalent to: timeslice occurrence phase1;
```

# Semantics

- A timeslice has a positive duration and represents a period within a containing occurrence's lifetime.
- A timeslice is a kind of occurrence usage (a durational portion of its containing occurrence).
- If declared in the body of an occurrence definition, a timeslice represents a portion of instances of that definition.
- If declared in the body of an occurrence usage, it represents a portion of the instances of the definition(s) of that usage.
- Timeslices can be nested within other timeslices but not within snapshots.
- Timeslices do not vary over time in the usual sense; they represent relationships holding across the duration of the containing occurrence.

# Rules

- A timeslice must be declared in the body of an occurrence definition or usage.
- The `timeslice` keyword is placed immediately before the kind keyword (or used in place of the kind keyword, defaulting to `occurrence`).
- Timeslices can be declared as individual using the `individual` keyword.
- Successions between timeslices can be declared explicitly with `first ... then ...` or using the shorthand `then` prepended to the second timeslice declaration.

# Examples

```sysml
occurrence def MissionPhases {
    timeslice launch;
    then timeslice cruise;
    then timeslice arrival;
}

part def SystemLifecycle {
    timeslice development;
    timeslice production;
    timeslice operations {
        timeslice normalOps;
        timeslice maintenance;
    }
    timeslice disposal;
}
```

# Relationships

- [occurrence.md](occurrence.md) — the containing occurrence concept
- [snapshot.md](snapshot.md) — zero-duration instants that can mark timeslice boundaries
- [individual.md](individual.md) — individuals can have timeslices declared as individual

# Citations

[1] OMG SysML v2 Specification, §7.9
