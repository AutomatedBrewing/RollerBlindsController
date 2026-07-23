---
type: SysML v2 Rule
title: Multiplicity Bounds
description: The multiplicity of a usage constrains the allowed number of values it may have for any instance of its featuring definition or usage, expressed as a range with lower and upper bounds that must be natural numbers.
timestamp: 2026-07-01T00:00:00Z
---

A usage may have a multiplicity that constrains its cardinality — that is, the allowed number of values it may have for any instance of its featuring definition or usage. The multiplicity is specified as a range, giving the lower and upper bound expressions evaluated to determine the lower and upper bounds.

# Rule Statement

A multiplicity range is written in the form `[lowerBound..upperBound]`, where each of `lowerBound` and `upperBound` is either a literal or the identification of a usage. The following rules apply:

1. The bounds must be natural numbers.
2. The lower bound must be finite; the upper bound may also be the infinite value `*`.
3. An upper bound value of `*` indicates that the range is unbounded (includes all numbers ≥ the lower bound).
4. If only a single bound is given, the value of that bound is used as both the lower and upper bound, **unless** the result is the infinite value `*`, in which case the lower bound is taken to be `0`.
5. If two bounds are given and the value of the first bound is `*`, the meaning of the multiplicity range is not defined.
6. If a multiplicity is not declared for a usage, then the usage inherits multiplicity constraints from any other usages it subsets or redefines. If no tighter constraint is inherited, the effective default is `[0..*]`.
7. A tighter default of `[1..1]` is implicitly declared if **all** of the following hold:
   - The usage is an attribute usage, an item usage (including a part usage, except a connection usage), or a port usage.
   - The usage is owned by a definition or another usage (not a package).
   - The usage does not have any explicit owned subsettings or owned redefinitions.

A multiplicity may be followed by one or both optional ordering keywords:
- `nonunique` — the same value may appear more than once. The default is unique.
- `ordered` — values can be placed in order, indexed from 1. The default is unordered.

# Rationale

Multiplicity bounds constrain the number of values a feature can hold, which is essential for validating structural models. Subsetting and redefinition relationships allow multiplicity to be further restricted in specialized contexts.

# Examples

```
item def Person {
    ref item parent[2] : Person;
    ref item mother : Person[1..1] subsets parent;
    attribute numberOfChildren : Natural;
    ref item children[0..numberOfChildren] : Person;
}

item def ChildlessPerson specializes Person {
    ref item redefines children[0];
}

part def Vehicle {
    // Each Vehicle has exactly four wheels
    part wheels : Wheel[4];
    // Or a range: 4 to 8 wheels
    part alternateWheels : Wheel[4..8];
}
```

# Violations

- Specifying a lower bound greater than the upper bound (e.g., `[3..1]`).
- Using `*` as the first (lower) bound in a two-bound range.
- Using a non-natural number (negative or non-integer) as a bound.
- In a redefinition, widening the multiplicity beyond the bounds established by the redefined usage.

# Related Concepts

- [Definition-Usage Pattern](definition-usage-pattern.md)
- [Specialization Rules](specialization-rules.md)

# Citations

[1] OMG SysML v2 Specification, §7.6.1 (Definition and Usage Overview), multiplicity
[2] OMG SysML v2 Specification, §7.6.3 (Usages), multiplicity range syntax
