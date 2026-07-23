---
type: SysML v2 Concept
title: Connection Definition
description: A connection definition is both a relationship and a kind of part definition that classifies connections between related things, specifying connection ends that identify the participants and optional non-end features that characterize the connection itself.
timestamp: 2026-07-01T00:00:00Z
---

A **connection definition** is both a relationship and a kind of part definition. It classifies connections between related things such as items, parts, or other occurrences. A connection definition has **end features** (connection ends) that identify the participants in the connections it classifies.

Unless abstract, a non-abstract connection definition must have at least two end features. Binary connection definitions have exactly two ends and classify binary connections. N-ary connection definitions have more than two ends.

Connection definitions can use **cross features** to constrain navigation from one connection end to instances of the other related type. Cross features are specified using cross subsetting (`crosses` or `=>` notation) or as owned cross features declared within the end feature declaration.

# Syntax

```sysml
// Basic binary connection definition
connection def DeviceConnection {
    end part hub : Hub;
    end part device : Device;
    attribute bandwidth : Real;
}

// Connection definition with cross features (multiplicity constraints)
connection def HubDeviceConnection {
    end [0..1] part hub : Hub;        // each device has at most one hub
    end [1..*] ordered part device : Device;  // each hub has one or more devices
    attribute bandwidth : Real;
}

// Connection definition with explicit cross subsetting
connection def AssetOwnership {
    end [1..*] item owner : LegalEntity;
    end [*] item ownedAsset : Asset;
}
```

# Semantics

- A connection definition is a relationship and a kind of part definition.
- Connection ends identify the related types; their definitions specify which types participate.
- End features have default multiplicity `[1..1]` (as participants in a specific connection instance).
- Cross multiplicity on an end constrains navigation from one end to the other.
- Cross ordering and uniqueness apply to navigated collections.
- Non-end features characterize the connection separately from its participants and can vary over time.
- The base connection definition is `Connection` (or `BinaryConnection` for binary) from the `Connections` library.

# Rules

- Unless abstract, must have at least two end features (owned or inherited).
- End features are always referential.
- End feature default multiplicity is `[1..1]` unless cross multiplicity is given.
- A specialization of a binary connection definition must also be binary.
- If a connection definition has a single superclassification, owned end features implicitly redefine the corresponding end features of the superclassification in order.

# Examples

```sysml
connection def PipeConnection {
    end part inlet : FluidPort;
    end part outlet : FluidPort;
    attribute flowRate : Real;
    attribute pressure : Real;
}

// N-ary connection
connection def ProtocolDeviceConnection {
    end [*] part hub : Hub;
    end [*] ordered part device : Device;
    end [0..1] item protocol : Protocol;
}
```

# Relationships

- [connection-usage.md](connection-usage.md) — usages of this connection definition
- [connection.md](connection.md) — general connection concept
- [part-definition.md](part-definition.md) — connection definitions are a kind of part definition
- [interface-definition.md](interface-definition.md) — interface definitions are connection definitions whose ends are ports
- [allocation-definition.md](allocation-definition.md) — allocation definitions are a specialized kind of connection definition

# Citations

[1] OMG SysML v2 Specification, §7.13
