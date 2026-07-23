---
type: SysML v2 Rule
title: Conjugation Rules for Ports
description: Every port definition implicitly declares a conjugated port definition whose directed features have their directions reversed (in and out are swapped; inout remains inout), and a conjugated port usage automatically conforms to a usage of the corresponding original port definition.
timestamp: 2026-07-01T00:00:00Z
---

Conjugation is a mechanism that automatically generates a counterpart port definition with reversed directions, enabling ports to be connected when one port provides what the other requires.

# Rule Statement

1. **Implicit conjugated port definition**: Every port definition implicitly declares a single, nested conjugated port definition, which has the same features as the original port definition, except that any directed features have conjugated directions:
   - `in` becomes `out`
   - `out` becomes `in`
   - `inout` remains `inout`

2. **Name of the conjugated port definition**: The name of the conjugated port definition is always the name of the original port definition with the character `~` prepended, in the namespace of the original port definition. For example, if a port definition has the name `P`, its conjugated port definition has the qualified name `P::'~P'`.

3. **Conjugated port usage shorthand**: A conjugated port usage is a shorthand for declaring a port usage defined by a conjugated port definition. Rather than using the actual name of the conjugated port definition, the name of the original port definition is used, preceded by the symbol `~`:
   ```
   port p : ~P;
   ```
   This is equivalent to:
   ```
   port p : P::'~P';
   ```

4. **The `~` symbol is not part of the name**: When the `~` symbol is used in a conjugated port usage, it is not considered part of the name. If the original port definition has a lexically unrestricted name (e.g., `'P-1'`), the conjugated port definition has the qualified name `'P-1'::'~P-1'`, and the conjugated port usage is written as `port p1 : ~'P-1'` (the `~` is placed outside the quotes).

5. **Conformance**: A conjugated port usage automatically conforms to a usage of the corresponding original port definition. Two ports conform when each feature of one port has a matching feature on the other port. Features match when they have conforming definitions and either both have no direction or they have conjugate directions.

# Rationale

Conjugation allows one port on a boundary to appear "from the inside" (the owned part's perspective) and "from the outside" (the containing part's perspective) simultaneously. This is the standard mechanism for wiring up provider-consumer port pairs without requiring manual duplication of a port definition with reversed directions.

# Examples

```
port def FuelingPort {
    attribute flowRate : Real;
    out fuelOut : Fuel;
    in fuelReturn : Fuel;
}

part def FuelTank {
    port fuelOutPort : FuelingPort;
}

part def Engine {
    // The conjugated port automatically has:
    //   in fuelOut : Fuel;   (reversed from out)
    //   out fuelReturn : Fuel;  (reversed from in)
    port fuelInPort : ~FuelingPort;
}

interface def FuelingInterface {
    end fuelOutPort : FuelingPort;
    end fuelInPort : ~FuelingPort;
}
```

# Violations

- Manually declaring a port definition that attempts to replicate what conjugation provides automatically (redundant but not an error; however, it breaks the automatic conformance relationship).
- Placing the `~` symbol inside quotes when it is intended as a conjugation operator rather than a literal part of a name.
- Connecting two ports with the same (non-conjugated) port definition when the intent is provider-consumer matching (the ports will have matching directions and cannot form flows between them).

# Related Concepts

- [Feature Direction](feature-direction.md)
- [Flow Typing Rules](flow-typing-rules.md)

# Citations

[1] OMG SysML v2 Specification, §7.12.1 (Ports Overview), conjugation
[2] OMG SysML v2 Specification, §7.12.3 (Conjugated Port Definitions and Usages)
