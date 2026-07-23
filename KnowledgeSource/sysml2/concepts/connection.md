---
type: SysML v2 Concept
title: Connection
description: A connection in SysML v2 is the general concept covering both connection definitions and connection usages, representing relationships between related things such as items and parts that classify connections between them.
timestamp: 2026-07-01T00:00:00Z
---

A **connection** in SysML v2 covers both connection definitions and connection usages. A connection definition is both a relationship and a kind of part definition that classifies connections between related things (items, parts, etc.). A connection usage is a part usage that is a usage of a connection definition, connecting specific usage elements.

Connections have **end features** (connection ends) that identify the participants in the connection. Binary connections have exactly two ends; n-ary connections have more. Connections may have additional non-end features that characterize the connection itself (e.g., bandwidth, protocol).

Special kinds of connections include **bindings** (asserting two features have the same values) and **successions** (asserting temporal ordering between occurrences).

# Syntax

```sysml
connection def DeviceConnection {
    end part hub : Hub;
    end part device : Device;
    attribute bandwidth : Real;
}

connection connection1 : DeviceConnection
    connect hub ::> mainSwitch to device ::> sensorFeed;

// Shorthand binary connection
connect leftWheel to leftHalfAxle;

// Binding connection
bind fuelTank.fuelFlowOut = engine.fuelFlowIn;

// Succession connection
first focus then shoot;
```

# Semantics

- A connection definition is a relationship and a kind of part definition.
- Connection ends are always referential (non-composite).
- The values of connection ends do not change over time.
- Non-end features of a connection can potentially change over its lifetime.
- The base connection definition is `Connection` and usage is `connections` from the `Connections` library.
- Binary connections also have base `BinaryConnection` / `binaryConnections`.

# Rules

- Unless abstract, a connection definition or usage must have at least two end features.
- End features have default multiplicity `[1..1]` regardless of the usual conditions.
- End features are always referential (the `ref` keyword is implied).
- Binary connections must remain binary throughout specialization.

# Examples

```sysml
// Logical (abstract) connection
connect pump to tank;

// Typed connection with cross features
connection def HubDeviceConnection {
    end [0..1] part hub : Hub;
    end [1..*] ordered part device : Device;
    attribute bandwidth : Real;
}

// Binding and succession (special connections)
bind steering.wheel = interior.steeringWheel;
first assembly then test;
```

# Relationships

- [connection-definition.md](connection-definition.md) — the definition side of connections
- [connection-usage.md](connection-usage.md) — the usage side of connections
- [interface.md](interface.md) — interfaces are connections whose ends are ports
- [allocation.md](allocation.md) — allocations are a specialized kind of connection
- [part.md](part.md) — connection definitions are a kind of part definition

# Citations

[1] OMG SysML v2 Specification, §7.13
