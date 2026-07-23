---
type: SysML v2 Concept
title: Use Case Usage
description: A use case usage is a kind of case usage that is a usage of a use case definition, instantiating the use case in a specific context by binding the subject and actors and optionally specifying include use case usages.
timestamp: 2026-07-01T00:00:00Z
---

A use case usage is declared with the keywords `use case` (without `def`). It is typed by exactly one use case definition and specializes case usage (§7.22). A use case usage can:

- Redefine the **subject** to bind it to a specific system instance
- Bind **actor** parameters to specific actor instances
- Contain **include use case usages** that specify the behavioral steps
- Add objective constraints or interaction details

The base library element is `useCases` (usage) from the `UseCases` model library.

# Syntax

```sysml
use case 'provide transportation' : 'Provide Transportation' {
  subject redefines vehicle = myVehicle;

  first start;
  then include 'enter vehicle' {
    actor :>> driver     = 'provide transportation'::driver;
    actor :>> passengers = 'provide transportation'::passengers;
  }
  then include 'drive vehicle' {
    actor :>> driver      = 'provide transportation'::driver;
    actor :>> environment = 'provide transportation'::environment;
  }
  then include 'exit vehicle' {
    actor :>> driver     = 'provide transportation'::driver;
    actor :>> passengers = 'provide transportation'::passengers;
  }
  then done;
}
```

# Semantics

- A use case usage is a case usage typed by exactly one use case definition.
- Actor parameters of included use cases should be explicitly bound to actors of the containing use case.
- Include use case usages specify sub-behaviors that together constitute the use case behavior.

# Rules

- Declared with `use case`.
- Must be typed by exactly one use case definition.
- Subject and actor bindings use `redefines` / `:>>`.
- Include use case usages declared with `include use case` or shorthand `include`.

# Examples

```sysml
use case emergencyBraking1 : EmergencyBraking {
  subject :>> vehicle = productionCar;
  actor   :>> driver  = testDriver;
}
```

# Relationships

- [use-case.md](use-case.md) — general concept
- [use-case-definition.md](use-case-definition.md) — the definition being instantiated
- [include-use-case.md](include-use-case.md) — including sub-use-case behavior
- [case-usage.md](case-usage.md) — supertype

# Citations

[1] OMG SysML v2 Specification, §7.25.2
