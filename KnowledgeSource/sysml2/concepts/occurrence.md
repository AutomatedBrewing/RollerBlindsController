---
type: SysML v2 Concept
title: Occurrence
description: An occurrence in SysML v2 is an entity that has an extent in time (and possibly space), maintained over a lifetime from creation to destruction, and may serve as the basis for items, parts, actions, and other temporal entities.
timestamp: 2026-07-01T00:00:00Z
---

An **occurrence** in SysML v2 is an entity that exists over a period of time called its **lifetime**. The lifetime spans from the establishment of the occurrence's identity to its loss. An occurrence maintains its identity throughout its lifetime, while the values of its features may vary over time.

Occurrences encompass both structural entities (such as physical objects) and behavioral entities (such as the performance of an action). Items, parts, actions, states, and connections are all specialized kinds of occurrences.

An occurrence definition defines a class of occurrences. An occurrence usage is a usage of an occurrence definition. Occurrences can have **time slices** (portions of their lifetime), **snapshots** (zero-duration instants), and can be declared as **individuals** (representing a unique, specific entity).

# Syntax

```sysml
// Occurrence definition
occurrence def Flight {
    ref part aircraft : Aircraft;
    timeslice preflight;
    timeslice inflight;
    timeslice postflight;
}

// Occurrence usage
occurrence flight1 : Flight;

// Individual occurrence
individual def Flight_248 :> Flight;
individual flightRecord : Flight_248;
```

# Semantics

- An occurrence has a lifetime over which its feature values may change.
- Composite features of an occurrence must also be occurrences (items, parts, actions, etc.).
- When an occurrence is destroyed, any composite sub-occurrences that have not been removed are also destroyed.
- Time slices represent portions of an occurrence's lifetime; snapshots represent zero-duration instants.
- An individual occurrence definition represents a single unique real or perceived object.
- Events are references from one occurrence to another that represent relevant happenings during a lifetime.
- The base definition is `Occurrence` from the KerML `Occurrences` library model.

# Rules

- If an occurrence definition or usage has nested composite features, those features must be occurrence usages (of any kind).
- Composite values of one occurrence cannot simultaneously be composite values of another occurrence.
- A feature that would otherwise vary over time may be declared `constant` to have a fixed value throughout a lifetime.
- Occurrence usages may be declared with `timeslice`, `snapshot`, or `individual` modifiers.

# Examples

```sysml
occurrence def ApprovedFlight :> Flight {
    // Aircraft stays constant for the entire approved flight
    constant ref part approvedAircraft redefines aircraft;
}

// Event occurrence usage
part client {
    event occurrence request[1] references subscriptionMessage.source;
}
```

# Relationships

- [individual.md](individual.md) — individual declarations of occurrences
- [snapshot.md](snapshot.md) — zero-duration portions of an occurrence
- [timeslice.md](timeslice.md) — time-duration portions of an occurrence
- [item.md](item.md) — specialized kind of occurrence
- [part.md](part.md) — specialized kind of item/occurrence

# Citations

[1] OMG SysML v2 Specification, §7.9
