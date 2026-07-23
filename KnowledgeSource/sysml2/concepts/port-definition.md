---
type: SysML v2 Concept
title: Port Definition
description: A port definition is a kind of occurrence definition that defines a connection point enabling interactions between occurrences, specifying what can be exchanged via directed and non-directed features.
timestamp: 2026-07-01T00:00:00Z
---

A **port definition** is a kind of occurrence definition that classifies connection points used to enable interactions between occurrences (most commonly parts). The features of a port definition specify what can be exchanged at that connection point—items, attributes, and nested port usages.

Port definition features may be directed (`in`, `out`, or `inout`). Directed features specify the direction of flow at the connection point. Every port definition also implicitly declares a single, nested **conjugated port definition** that has the same features but with reversed directions for directed features (`in` ↔ `out`, `inout` unchanged).

# Syntax

```sysml
port def FuelingPort {
    attribute flowRate : Real;
    out fuelOut : Fuel;
    in fuelReturn : Fuel;
}

// Port definition with nested ports
port def CompositePort {
    port dataPort : DataPort;
    port powerPort : PowerPort;
}

// Access to conjugated port definition (implicit name)
// FuelingPort::'~FuelingPort' is the conjugated port definition
```

# Semantics

- A port definition is a kind of occurrence definition; ports have lifetimes.
- All non-port features of a port definition must be referential (non-composite).
- Each port definition implicitly declares a nested conjugated port definition named `'~<PortName>'`.
- The conjugated port definition has directed features with reversed directions.
- Two ports conform if each feature of one has a matching feature (conforming type and conjugate direction) on the other.
- The base port definition is `Port` from the `Ports` library model.

# Rules

- A port definition is declared using the kind keyword `port` with the `def` suffix.
- All features other than nested port usages must be referential.
- A conjugated port definition is automatically created for every port definition.
- Port usages must only be defined by port definitions.

# Examples

```sysml
port def PowerPort {
    in power : Watt;
    out powerReturn : Watt;
}

port def MechanicalPort {
    inout torque : NewtonMeter;
    inout angularVelocity : RadiansPerSecond;
}

port def CommunicationPort {
    in request : Message;
    out response : Message;
    port nested : DataPort;
}
```

# Relationships

- [port-usage.md](port-usage.md) — usages typed by this port definition
- [port.md](port.md) — general port concept
- [conjugated-port.md](conjugated-port.md) — the implicit conjugate of this port definition
- [interface-definition.md](interface-definition.md) — interfaces connect port definitions

# Citations

[1] OMG SysML v2 Specification, §7.12
