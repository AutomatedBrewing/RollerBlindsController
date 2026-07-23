---
type: SysML v2 Concept
title: Variability
description: Variability in SysML models design choice points using variation elements and their associated variant elements, representing a family of possible design configurations.
timestamp: 2026-07-01T00:00:00Z
---

**Variability** in SysML is modeled using **variation** and **variant** elements. A **variation** (also called a variation point) identifies an element in a model that can differ from one design configuration to another. For each variation, there are design choices called **variants** that represent the possible options.

A variation can apply to any kind of definition or usage (except enumeration). A variation is always abstract. Its variants are usage elements. If the containing variation is a definition, each variant is implicitly defined by that variation definition. If the containing variation is a usage, each variant implicitly subsets the variation usage.

Variations can be nested, creating hierarchical variability structures. A model containing variations is sometimes called a **superset model** that encompasses all possible design configurations. A particular configuration is selected by choosing a variant for each variation.

# Syntax

```sysml
// Variation definition with variants:
variation part def TransmissionChoices :> Transmission {
  variant part manual : ManualTransmission;
  variant part automatic : AutomaticTransmission;
}

// Variation usage with variants (inline):
part def Vehicle {
  variation part engine : Engine {
    variant part smallEngine : FourCylinderEngine;
    variant part bigEngine : SixCylinderEngine;
  }
}

// Variant referencing externally declared usages:
part smallEngine : FourCylinderEngine;
part bigEngine : SixCylinderEngine;

part def Vehicle {
  variation part engine : Engine {
    variant smallEngine;
    variant bigEngine;
  }
}
```

# Semantics

- A **variation** is declared by placing the `variation` keyword before the kind keyword of a definition or usage.
- A variation is always abstract; the `abstract` keyword is not used alongside `variation`.
- All usages declared directly within the body of a variation are **variant** usages, declared using the `variant` keyword.
- Variant usages may only be declared within a variation.
- The kind of a variant usage must be consistent with the kind of its owning variation.
- If the owning variation is a **definition**, each variant is implicitly typed by the variation definition.
- If the owning variation is a **usage**, each variant implicitly subsets the variation usage.
- A non-variant usage can act as a variant by using `variant` followed by the identification of the externally declared usage (without a kind keyword).
- Variations can be nested within other variations to any level.
- Constraints can be modeled to restrict valid combinations of variant selections.
- SysML provides validation rules to evaluate whether a particular configuration is valid.

# Rules

1. The `variation` keyword before the kind keyword declares a variation.
2. A variation is always abstract; the `abstract` keyword is redundant and not used.
3. Nested usages within a variation body are declared with the `variant` keyword.
4. Variants may only appear within a variation.
5. The variant kind must be consistent with the owning variation's kind.
6. A `variant` followed by a reference to a non-variant usage (no kind keyword) adds that usage as a variant.

# Examples

```sysml
// Variation definition with named variants:
variation part def TransmissionChoices :> Transmission {
  variant part manual : ManualTransmission;
  variant part automatic : AutomaticTransmission;
}

// Nested variation:
variation part def EngineChoices :> Engine {
  variant part fourCylinder : FourCylinderEngine {
    variation part bore : BoreDiameter {
      variant part smallBore : SmallBoreDiameter;
      variant part largeBore : LargeBoreDiameter;
    }
  }
  variant part sixCylinder : SixCylinderEngine;
}
```

# Relationships

- [usage.md](usage.md) — variation and variant are specialized kinds of usage
- [definition.md](definition.md) — variation can also apply to definitions
- [subclassification.md](subclassification.md) — variant definitions implicitly specialize the variation definition
- [subsetting.md](subsetting.md) — variant usages implicitly subset the variation usage

# Citations

[1] OMG SysML v2 Specification, §7.6.1, §7.6.7
