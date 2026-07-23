---
type: SysML v2 Concept
title: Connection Usage
description: A connection usage is a part usage that is a usage of a connection definition, connecting specific usage elements such as parts and items by associating the connection ends with those specific usages.
timestamp: 2026-07-01T00:00:00Z
---

A **connection usage** is a part usage that is a usage of a connection definition. It connects specific usage elements (parts, items, etc.) by associating the connection ends with specific feature values. A connection usage redefines the connection ends from its definition, associating them with the specific usage elements to be connected.

Connection usages may be logical (abstract), representing a conceptual link without specifying implementation details, or physical, with the connection itself having composite structure (e.g., a pipe connecting a pump to a tank).

Connection usages have several shorthand notations:
- **`connect (...)`** – lists the related features in parentheses
- **`connect ... to ...`** – binary shorthand with source and target
- Omitting `connection` when the declaration part is empty

# Syntax

```sysml
// Full connection usage
connection connection1 : DeviceConnection {
    end part hub ::> mainSwitch[1];
    end part device ::> sensorFeed[1];
}

// Binary shorthand
connection connection1 : DeviceConnection
    connect mainSwitch to sensorFeed;

// Anonymous connection (keyword 'connection' may be omitted)
connect leftWheel to leftHalfAxle;

// N-ary connection
connect (axle, wheel1, wheel2);

// Connection with cross multiplicity on ends
connection networkConnections : DeviceConnection {
    end [1] part hub references networkHubs;
    end [0..4] part device references networkDevices;
}
```

# Semantics

- A connection usage is a part usage; the connection itself is a part that can change its non-end features over time.
- The connection ends (the related elements) do not change over time.
- A binary connection usage connects the single values of the two ends.
- The base connection usage is `connections` (or `binaryConnections`) from the `Connections` library.

# Rules

- A connection usage must only be defined by connection definitions (of any kind) or KerML association structures.
- Unless abstract, it must have at least two end features.
- End feature default multiplicity is `[1..1]`.
- End features are always referential.
- The `connection` keyword may be omitted when using `connect` shorthand with an empty declaration part.

# Examples

```sysml
part def NetworkConfiguration {
    part networkHubs[*] : Hub;
    part networkDevices[*] : Device;
    connection networkConnections : DeviceConnection {
        end [1] part hub references networkHubs;
        end [0..4] part device references networkDevices;
    }
}

// Binding connection (special kind)
bind part2.part4R = part3.part4;

// Succession connection (special kind)
first focus then shoot;
```

# Relationships

- [connection-definition.md](connection-definition.md) — the definition that types this connection usage
- [connection.md](connection.md) — general connection concept
- [part-usage.md](part-usage.md) — connection usages are a kind of part usage
- [interface-usage.md](interface-usage.md) — interface usages are connection usages whose ends are ports
- [allocation-usage.md](allocation-usage.md) — allocation usages are a specialized kind of connection usage

# Citations

[1] OMG SysML v2 Specification, §7.13
