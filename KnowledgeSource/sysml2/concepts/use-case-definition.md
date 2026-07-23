---
type: SysML v2 Concept
title: Use Case Definition
description: A use case definition is a kind of case definition that specifies the required behavior of a subject relative to one or more external actors, typically as a sequence of interactions, with an objective to provide a result of value to the actors.
timestamp: 2026-07-01T00:00:00Z
---

A use case definition is declared with the keywords `use case def`. It specializes case definition (§7.22) and is the primary way to model system behavioral requirements from a user/actor perspective. A use case definition specifies:

- A **subject** (the system or entity providing the behavior)
- One or more **actor** parameters (external entities interacting with the subject)
- An **objective** (what result of value the actors should receive)
- Optionally, a sequence of **messages** between the subject and actors

The base library element is `UseCase` from the `UseCases` model library.

# Syntax

```sysml
use case def 'Provide Transportation' {
  subject vehicle     : Vehicle {
    event occurrence driverEnters    [1];
    then event occurrence passengerEnters [0..*];
    then event occurrence startsDrive    [1];
    then event occurrence endsDrive      [1];
    then event occurrence passengerExits [0..*];
    then event occurrence driverExits    [1];
  }
  actor driver      : Person {
    event occurrence entersVehicle [1];
    then event occurrence exitsVehicle [1];
  }
  actor passengers  : Person[0..4] {
    event occurrence entersVehicle [1];
    then event occurrence exitsVehicle [1];
  }
  actor environment : Environment {
    event occurrence vehicleDrives [1];
  }

  objective {
    doc /* Transport driver and passengers from starting to ending location. */
  }

  message of Enter from driver.entersVehicle    to vehicle.driverEnters;
  then message of Enter from passengers.entersVehicle to vehicle.passengerEnters;
  then message of Drive from vehicle.drives      to environment.vehicleDrives;
  then message of Exit  from passengers.exitsVehicle to vehicle.passengerExits;
  then message of Exit  from driver.exitsVehicle to vehicle.driverExits;
}
```

# Semantics

- Declared with `use case def`.
- Specializes case definition; subject and actors are part usages.
- Interactions are modeled using messages (§7.13) or events (§7.9).
- The objective requirement captures what observable value the use case delivers.
- A design realizes the use case if its internal structure produces behavior consistent with the use case.

# Rules

- Declared with `use case def`.
- Subject declared with `subject`; actors declared with `actor`.
- A use case usage must be typed by exactly one use case definition.
- Include use case usages incorporate the behavior of other use cases.

# Examples

```sysml
use case def EmergencyBraking {
  subject vehicle     : Vehicle;
  actor   driver      : Person;
  actor   environment : Environment;

  objective {
    doc /* Vehicle shall bring itself to a safe stop in an emergency. */
  }
}
```

# Relationships

- [use-case.md](use-case.md) — general use case concept
- [use-case-usage.md](use-case-usage.md) — usage of a use case definition
- [include-use-case.md](include-use-case.md) — include use case usages within this definition
- [case-definition.md](case-definition.md) — supertype

# Citations

[1] OMG SysML v2 Specification, §7.25.2
