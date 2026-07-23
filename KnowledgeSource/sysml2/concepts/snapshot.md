---
type: SysML v2 Concept
title: Snapshot
description: A snapshot is a zero-duration portion of an occurrence's lifetime that represents a specific instant in time, capturing the condition of the occurrence at that moment.
timestamp: 2026-07-01T00:00:00Z
---

A **snapshot** is a time slice with zero duration. It represents a specific instant in time within the lifetime of an occurrence. Snapshots are used to capture the state or condition of an occurrence at a particular point in time, such as at the start or end of a phase, or at any significant moment.

A snapshot is declared using the `snapshot` keyword, optionally placed before the kind keyword of an occurrence usage declaration. Snapshots must be declared within the body of an occurrence definition or usage.

A start snapshot and an end snapshot can be defined for any time slice. For example, the start snapshot of one ownership time slice of a car corresponds to its sale to a new owner, which is the same instant as the end snapshot of the previous ownership time slice.

# Syntax

```sysml
// Snapshots declared in the body of an occurrence definition
part aircraft : Aircraft {
    snapshot part aircraftTakeOff;
    snapshot part aircraftLanding;
}

// Snapshot in a timeslice context
individual part individual1 : Individual1 {
    timeslice timeslice1 {
        snapshot snapshot1;
        snapshot snapshot2;
    }
}

// Shorthand: 'snapshot' used in place of kind keyword
snapshot snapshot1;  // equivalent to: snapshot occurrence snapshot1;
```

# Semantics

- A snapshot has zero duration; it represents a single instant.
- A snapshot is a kind of occurrence usage (a zero-duration portion of its containing occurrence).
- If declared in the body of an occurrence definition, a snapshot represents a portion of instances of that definition.
- If declared in the body of an occurrence usage, it represents a portion of the instances of the definition(s) of that usage.
- It is generally not useful to declare a snapshot within another snapshot (since a snapshot has no duration).

# Rules

- A snapshot must be declared in the body of an occurrence definition or usage.
- The `snapshot` keyword is placed immediately before the kind keyword (or used in place of the kind keyword, defaulting to `occurrence`).
- After any usage property keywords and before the kind keyword.

# Examples

```sysml
occurrence def FlightSegment {
    snapshot departureInstant;
    snapshot arrivalInstant;
}

part def Machine {
    timeslice startupPhase {
        snapshot machineReady;
    }
    timeslice operatingPhase;
    snapshot shutdown;
}
```

# Relationships

- [occurrence.md](occurrence.md) — the containing occurrence concept
- [timeslice.md](timeslice.md) — time slices that may contain snapshots
- [individual.md](individual.md) — individuals can have snapshots of their lifetime

# Citations

[1] OMG SysML v2 Specification, §7.9
