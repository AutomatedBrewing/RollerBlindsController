---
type: SysML v2 Concept
title: Redefinition
description: Redefinition is a kind of subsetting where the redefining usage replaces the redefined usage in the context of the redefining usage, rather than adding an additional feature alongside it.
timestamp: 2026-07-01T00:00:00Z
---

**Redefinition** is a specialized kind of subsetting relationship between usages. While a general subsetting usage adds an additional feature alongside the subsetted usage, a **redefining usage** replaces the **redefined usage** in the context of the redefining usage. The redefined usage is no longer visible in that context; only the redefining usage is available.

Redefinition is useful for constraining an inherited feature in a specialized context — for example, restricting the type of a usage to a more specific subclassification, or constraining its multiplicity more tightly.

In textual notation, redefinition is declared using the `redefines` keyword or its shorthand `:>>`.

# Syntax

```sysml
// Redefinition with a new type and multiplicity:
part part1S : Part1S [1]
  :> part1 {
  part part2R : Part2R :>> part2;
}
// or equivalently:
part part1S : Part1S [1]
  subsets part1 {
  part part2R : Part2R redefines part2;
}

// Redefinition without a name (effective name inherited from redefined usage):
part def FourCylinderEngine :> Engine {
  part redefines cylinders[4];
}

part def SixCylinderEngine :> Engine {
  part redefines cylinders[6];
}

// Redefinition with binding:
part part1R : Part1R [m] redefines part1 = part2;
```

# Semantics

- A redefining usage **replaces** the redefined usage in the context of the redefinition's owner.
- Values of the redefining usage must also be values of the redefined usage (it is a kind of subsetting).
- The redefined usage is no longer accessible as an inherited feature in the context of the redefining usage.
- If the redefining usage has no declared name, its **effective name** is taken from the name of the first redefined usage. This allows constraining a feature while maintaining its original name.
- Redefinition is recorded in the abstract syntax as a subset of owned subsettings.

# Rules

1. Redefinition is declared with `redefines` or `:>>` followed by the qualified name (or feature chain) of the redefined usage.
2. Multiple redefined usages can be listed, separated by commas.
3. A redefining usage replaces the redefined usage; the redefined usage is no longer an inherited feature in that context.
4. If no name is declared for a redefining usage, its effective name is determined by the name of the first redefined usage.
5. Redefinition is a kind of subsetting: all rules for subsetting also apply.

# Examples

```sysml
// Restricting type and multiplicity:
part def Engine {
  part cylinders : Cylinder [2..*];
}
part def FourCylinderEngine :> Engine {
  part redefines cylinders[4];
}

// Restricting a feature type to a subtype:
part def Vehicle {
  part fuel : Fuel;
}
part truck : Truck {
  part redefines fuel : DieselFuel;
}

// Nested redefinition:
part part1 : Part1 [0..*] {
  part part2 : Part2 [0..*];
}
part part1S : Part1S [1] :> part1 {
  part part2R : Part2R :>> part2;
}
```

# Relationships

- [subsetting.md](subsetting.md) — redefinition is a special kind of subsetting
- [usage.md](usage.md) — redefinition is a relationship between usages
- [definition.md](definition.md) — the redefined usage may be constrained to a more specific definition type
- [multiplicity.md](multiplicity.md) — redefinition may constrain the multiplicity of the redefined usage

# Citations

[1] OMG SysML v2 Specification, §7.6.1, §7.6.3, §7.6.5
