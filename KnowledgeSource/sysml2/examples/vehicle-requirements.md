---
type: SysML v2 Example
title: Vehicle Requirements (HSUV)
description: Demonstrates SysML v2 hierarchical requirements with sub-requirements, requirement groups, and require references for a Hybrid SUV system.
timestamp: 2026-07-01T00:00:00Z
---

This example defines a set of user requirements for a Hybrid Sport Utility Vehicle (HSUV). Requirements are organized hierarchically using composite sub-requirements under functional and performance categories (Load, EcoFriendliness, Performance, Ergonomics). A top-level `HybridSUVSpec` requirement group collects them by reference using `require`.

# Source

```sysml
package HSUVRequirements {
	private import Requirements::*;
	
	requirement <'UR1.1'> Load: FunctionalRequirementCheck {
		// The following requirements are composite sub-requirements.
		requirement Passengers;
		requirement FuelCapacity;
		requirement Cargo;
	}
	
	requirement <'UR1.2'> EcoFriendliness: PerformanceRequirementCheck {
		requirement <'URI1.2.1'> Emissions: PerformanceRequirementCheck {
			/* The car shall meet 2010 Kyoto Accord emissions standards. */
		}
	}
	
	requirement <'UR1.3'> Performance: PerformanceRequirementCheck {
		requirement Acceleration;
		requirement <'UR1.3.1'> FuelEconomy: PerformanceRequirementCheck {
			/* User shall obtain fuel economy better than that provided by
			 * 95% of cars built in 2004.
			 */
		}
		requirement Braking;
		requirement Range;
		requirement Power;
	}
	
	requirement <'UR1.4'> Ergonomics;
	
	// Syntactically, should this be explicitly marked as a "group"?
	requirement HybridSUVSpec {		
		// The following requirements are required by reference.
		require Load;
		require EcoFriendliness;
		require Performance;
		require Ergonomics;
	}
}
```

# Key Concepts Demonstrated

- [`requirement`](../concepts/requirement.md) — defining named requirements with short IDs (e.g., `<'UR1.1'>`)
- [Requirement specialization](../concepts/requirement.md) — typing requirements as `FunctionalRequirementCheck` or `PerformanceRequirementCheck`
- [Composite sub-requirements](../concepts/requirement.md) — nesting `requirement` declarations inside a parent requirement
- [`require`](../concepts/require.md) — referencing requirements by name to assemble a requirement group
- [Requirements library import](../concepts/requirements-library.md) — `private import Requirements::*` provides the base requirement types

# Notes

- The distinction between composite sub-requirements (declared inline) and required-by-reference requirements (`require`) is an important SysML v2 pattern: the former implies decomposition ownership; the latter implies a dependency or inclusion without redefining the requirement.
- Requirement short IDs (e.g., `<'UR1.1'>`) provide traceability tokens that can be referenced in verification cases and analysis.
- The `HybridSUVSpec` group pattern is a common way to bundle a system's top-level requirement set for a specific product configuration.

# Citations

[1] OMG SysML v2 Specification, Annex A (example models)
