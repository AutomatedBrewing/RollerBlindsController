---
type: SysML v2 Rule
title: Feature Direction
description: A directed usage is declared with one of the keywords in, out, or inout before its kind keyword, which determines what things are allowed to change its values relative to its featuring instance.
timestamp: 2026-07-01T00:00:00Z
---

Feature direction determines the flow of values relative to a featuring instance. Direction is an optional property of a usage and can appear on features of action definitions, port definitions, and other usage kinds. A directed usage is always referential, whether or not the keyword `ref` is also given explicitly in its declaration.

# Rule Statement

The direction of a usage is specified by placing one of the following keywords before the kind keyword in the usage declaration:

- `in` — Things "outside" the featuring instance are allowed to change the feature's values. These usages identify things **input** to an instance.
- `out` — The featuring instance itself or things "inside" it are allowed to change the feature's values. These usages identify things **output** by an instance.
- `inout` — Both things "outside" and "inside" the featuring instance are allowed to change the feature's values. These usages identify things that are both input to and output by an instance.

A directed usage is always referential (non-composite), whether or not the `ref` keyword is explicitly included.

# Rationale

Direction is critical for specifying action parameters, port features, and flow endpoints. For ports in particular, two features match for flow purposes if they have conforming definitions and either both have no direction or they have conjugate directions. The conjugate of `in` is `out` and vice versa, while `inout` is its own conjugate.

An action definition may have features with directions `in`, `out`, or `inout` that act as the parameters of the action. Features with direction `in` or `inout` are input parameters, and features with direction `out` or `inout` are output parameters.

# Examples

```
port def FuelingPort {
    attribute flowRate : Real;
    out fuelOut : Fuel;
    in fuelReturn : Fuel;
}

action def TakePicture {
    in subject : Scene;
    out image : Image;
}
```

For streaming flows, the direction of the feature identifies the source output and target input:

```
part def Vehicle {
    part fuelTank : FuelTank {
        out fuelOut : Fuel;
    }
    part engine : Engine {
        in fuelIn : Fuel;
    }
    flow fuelTank.fuelOut to engine.fuelIn;
}
```

# Violations

- Specifying direction on an attribute usage nested inside an attribute definition (attribute features are always referential and directionality is not meaningful for purely attributive values).
- Declaring a directed usage as composite (a directed usage is always referential by rule).
- Using `in` or `out` in a context where direction is irrelevant, such as a package-level usage without a featuring instance.

# Related Concepts

- [Definition-Usage Pattern](definition-usage-pattern.md)
- [Conjugation Rules](conjugation-rules.md)
- [Flow Typing Rules](flow-typing-rules.md)

# Citations

[1] OMG SysML v2 Specification, §7.6.3 (Usages), direction keywords
[2] OMG SysML v2 Specification, §7.12.1 (Ports Overview), conjugate directions
[3] OMG SysML v2 Specification, §7.17.1 (Actions Overview), action parameters
