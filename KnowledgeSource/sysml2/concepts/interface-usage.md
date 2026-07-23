---
type: SysML v2 Concept
title: Interface Usage
description: An interface usage is a kind of connection usage that is a usage of an interface definition, connecting specific port usages and enabling the automatic routing of transfers between those ports.
timestamp: 2026-07-01T00:00:00Z
---

An **interface usage** is a kind of connection usage that is a usage of an interface definition. Its ends must be port usages. An interface usage connects specific port usages on parts or occurrences, enabling interactions and automatic transfer routing between those ports.

When a send action sends a transfer via a port at one end of a binary interface usage, the port at the other end automatically becomes the target of the transfer. This automatic targeting works in either direction.

Interface usages support the same shorthand notations as connection usages, but if the declaration part is empty, the `interface` keyword is still included (the `connect` keyword may be omitted).

# Syntax

```sysml
// Named interface usage
interface fuelLine : FuelingInterface
    connect fuelTank.fuelingPort to engine.fuelingPort;

// Anonymous interface usage (shorthand)
interface fuelTank.fuelingPort to engine.fuelingPort;

// Interface with explicit ends
interface interface1 : InterfaceDef1 {
    end port1 :> pa;
    end port2 :> pb;
}

// Interface usage in a system context
part def DistributedSystem {
    part client {
        port clientPort;
    }
    part server {
        port serverPort;
    }
    interface client.clientPort to server.serverPort;
}
```

# Semantics

- An interface usage is a connection usage whose ends must be port usages.
- For a binary interface usage, a transfer from one port automatically targets the port at the other end.
- If a port is connected by multiple interfaces, an outgoing transfer targets exactly one other-end port (which one is not determined by interface semantics).
- Transfers via ports happen across interfaces only, not other kinds of connections.
- The base interface usage is `interfaces` (or `binaryInterfaces`) from the `Interfaces` library.

# Rules

- An interface usage must only be defined by interface definitions.
- All end features must be port usages.
- When using shorthand notation with an empty declaration part, `interface` is retained but `connect` may be omitted.
- The `port` keyword is optional on interface usage ends (when no owned cross feature is declared).

# Examples

```sysml
part part1 : Part1 {
    port pa : Pa;
}
part part2 : Part2 {
    port pb : ~Pa;
}

interface interface2 : InterfaceDef2
    connect source ::> part1.pa to target ::> part2.pb {
        interface source.p1 to target.p1;
        interface source.p2 to target.p2;
    }

// Shorthand for multiple interfaces between nested ports
interface part1.pa to part2.pb;
```

# Relationships

- [interface-definition.md](interface-definition.md) — the definition that types this interface usage
- [interface.md](interface.md) — general interface concept
- [connection-usage.md](connection-usage.md) — interface usages are a specialized kind of connection usage
- [port-usage.md](port-usage.md) — interface usage ends are port usages

# Citations

[1] OMG SysML v2 Specification, §7.14
