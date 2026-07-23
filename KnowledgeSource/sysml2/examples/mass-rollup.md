---
type: SysML v2 Example
title: Mass Roll-up
description: Demonstrates SysML v2 attribute redefinition and numerical aggregation to compute total mass by recursively summing subcomponent masses.
timestamp: 2026-07-01T00:00:00Z
---

This example defines a `MassedThing` part hierarchy that computes total mass using attribute redefinition and the `sum()` numerical function. A `simpleThing` equates `totalMass` to its own `mass`, while a `compositeThing` sums `mass` with the `totalMass` of all subcomponents. A `filteredMassThing` further refines the rollup by filtering subcomponents whose mass exceeds a minimum threshold using a lambda filter expression.

# Source

```sysml
package MassRollup {
	private import NumericalFunctions::*;
	
	part def MassedThing {
		attribute mass :> ISQ::mass; 
		attribute totalMass :> ISQ::mass;
	}
	
	part simpleThing : MassedThing {
		attribute redefines totalMass = mass;
	}
	
	part compositeThing : MassedThing {
		part subcomponents: MassedThing[*];
		
		attribute redefines totalMass default
			mass + sum(subcomponents.totalMass); 
	}
	
	part filteredMassThing :> compositeThing {
		abstract attribute minMass :> ISQ::mass;
		
		attribute redefines totalMass =
			mass + sum(subcomponents.totalMass.?{in p :> ISQ::mass; p > minMass});
	}

}
```

# Key Concepts Demonstrated

- [`attribute redefines`](../concepts/redefinition.md) — overriding an inherited attribute with a computed value expression
- [`default` attribute values](../concepts/attribute.md) — providing a default computation that can be overridden
- [`sum()` from NumericalFunctions](../concepts/numerical-functions.md) — aggregating a collection of quantity values
- [Collection feature access](../concepts/feature-access.md) — `subcomponents.totalMass` collects the `totalMass` of all subcomponent instances
- [Lambda filter expression `.?{...}`](../concepts/filter-expression.md) — filtering a collection with an inline predicate
- [ISQ quantity kinds](../concepts/quantities.md) — `ISQ::mass` for typed physical quantities

# Notes

- The `default` keyword on `compositeThing.totalMass` allows the rollup formula to be a baseline that specialized parts (like `filteredMassThing`) can override with `=`.
- The filter expression `subcomponents.totalMass.?{in p :> ISQ::mass; p > minMass}` is a SysML v2 collection filter — the `in p` parameter is typed, and the body is a boolean predicate applied element-wise.
- This pattern is a canonical SysML v2 approach for parametric mass budgets: the hierarchy can be arbitrarily deep since `compositeThing` recursively references `MassedThing` subcomponents.

# Citations

[1] OMG SysML v2 Specification, Annex A (example models)
