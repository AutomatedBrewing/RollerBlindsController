---
type: SysML v2 Concept
title: Use Case
description: A use case is a kind of case that specifies the required behavior of a subject relative to one or more external actors, where the objective is to provide an observable result of value to the actors through a sequence of subject–actor interactions.
timestamp: 2026-07-01T00:00:00Z
---

A use case encompasses both use case definitions and use case usages. A use case definition specifies the required behavior of its **subject** in relation to one or more **external actors**. The objective is to provide an observable result of value to one or more actors through interactions between the subject and its actors.

A use case is typically specified as a **sequence of interactions** (messages) between the subject and actors. Each interaction can be modeled as a message delivering a payload or signal, with source/target ends modeled as events in the lifetimes of the subject and actor occurrences, or as actions.

A use case definition or usage can contain **include use case usages** to incorporate the behavior of other use cases.

A system is properly designed to satisfy a use case if a legal realization of the use case can be constructed from the internal structure of the subject (i.e., the interactions of internal parts form a specialization of the required behavior).

# Syntax

```sysml
use case def 'Provide Transportation' {
  subject vehicle     : Vehicle;
  actor   driver      : Person;
  actor   passengers  : Person[0..4];
  actor   environment : Environment;

  objective {
    doc /* Transport driver and passengers from start to end location. */
  }

  message of Enter from driver.entersVehicle    to vehicle.driverEnters;
  then message of Enter from passengers.entersVehicle to vehicle.passengerEnters;
  then message of Drive from vehicle.drives      to environment.vehicleDrives;
  then message of Exit  from passengers.exitsVehicle to vehicle.passengerExits;
  then message of Exit  from driver.exitsVehicle to vehicle.driverExits;
}
```

# Semantics

- A use case definition specializes case definition; a use case usage specializes case usage.
- The subject and actors are part usages; their interactions are modeled as messages (§7.13).
- The objective may include requirement constraints the case must satisfy.
- A use case can be realized by a design if there exists a consistent interaction of internal parts.
- Include use case usages (§7.25.3) incorporate the behavior of other use cases.

# Rules

- Declared with `use case def` (definition) or `use case` (usage).
- A use case usage must be typed by exactly one use case definition.
- Subject and actor parameters declared with `subject` and `actor` keywords.
- Include usages declared with `include use case` or shorthand `include`.

# Examples

```sysml
use case 'provide transportation' : 'Provide Transportation' {
  first start;
  then include 'enter vehicle' {
    actor :>> driver      = 'provide transportation'::driver;
    actor :>> passengers  = 'provide transportation'::passengers;
  }
  then include 'drive vehicle' {
    actor :>> driver      = 'provide transportation'::driver;
    actor :>> environment = 'provide transportation'::environment;
  }
  then include 'exit vehicle' {
    actor :>> driver      = 'provide transportation'::driver;
    actor :>> passengers  = 'provide transportation'::passengers;
  }
  then done;
}
```

# Relationships

- [use-case-definition.md](use-case-definition.md) — definition form
- [use-case-usage.md](use-case-usage.md) — usage form
- [include-use-case.md](include-use-case.md) — including behavior of another use case
- [case.md](case.md) — supertype concept

# Citations

[1] OMG SysML v2 Specification, §7.25.1
