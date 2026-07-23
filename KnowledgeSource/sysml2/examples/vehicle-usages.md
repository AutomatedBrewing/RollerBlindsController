---
type: SysML v2 Example
title: Vehicle Usages
description: Demonstrates SysML v2 part usages, subsetting, redefinition, and interface connections across three progressively specialized vehicle configurations.
timestamp: 2026-07-01T00:00:00Z
---

This example instantiates and specializes the structural elements defined in `VehicleDefinitions`. Three vehicle configurations are shown — `vehicle_C1` (basic hierarchy), `vehicle_C2` (adds named wheel references and interface connections), and `vehicle_C3` (adds a transmission with a drive interface connected deep into the axle hierarchy). It illustrates subset/redefine specialization, multiplicity constraints, and flow-bearing interface connections.

# Source

```sysml
package VehicleUsages {
	doc
	/*
	 * Example usages of elements from the vehicle definitions model.
	 */

	private import SI::N;
	private import SI::m;
	private import ScalarFunctions::*;

	public import VehicleDefinitions::*;

	/* VALUES */	 
	T1 = 10.0 [N * m];
	T2 = 20.0 [N * m];
	
	/* PARTS */	
	part narrowRimWheel: Wheel {
		doc /* Narrow-rim wheel configuration with 4 to 5 lugbolts. */

		part lugbolt: Lugbolt[4..5];
	}
	
	part wideRimWheel: Wheel {
		doc /* Wide-rim wheel configuration with 4 to 6 lugbolts. */	

		part lugbolt: Lugbolt[4..6];
	}

	part vehicle_C1: Vehicle {
		doc /* Basic Vehicle configuration showing a part hierarchy. */

		part frontAxleAssembly: AxleAssembly {
			part frontWheel[2] subsets narrowRimWheel {
				part redefines lugbolt[4] {
					attribute redefines tighteningTorque = T1;
				}
			}
			part frontAxle: Axle;
		}		
		part rearAxleAssembly: AxleAssembly {
			part rearWheel[2] subsets wideRimWheel {
				part redefines lugbolt[6] {
					attribute redefines tighteningTorque = T2;
				}
			}
			part rearAxle: Axle;			
		}
	}
	
	part vehicle_C2 subsets vehicle_C1 {
		doc /* Specialized configuration with part-specific ports. */

		part redefines frontAxleAssembly {
			part leftFrontWheel subsets frontWheel = frontWheel#(1);
			part rightFrontWheel subsets frontWheel = frontWheel#(2);
			
			interface leftFrontMount: Mounting connect 
				frontAxle.leftMountingPoint to leftFrontWheel.hub;
				
			interface rightFrontMount: Mounting connect 
				frontAxle.rightMountingPoint to rightFrontWheel.hub;
		}
		
		part rearAxleAssembly redefines vehicle_C1::rearAxleAssembly {
			part leftRearWheel subsets rearWheel = rearWheel#(1);
			part rightRearWheel subsets rearWheel = rearWheel#(2);

			interface leftRearMount: Mounting connect 
				rearAxle.leftMountingPoint to leftRearWheel.hub;
				
			interface rightRearMount: Mounting connect 
				rearAxle.rightMountingPoint to rightRearWheel.hub;
		}		
	}
	
	part vehicle_C3 subsets vehicle_C2 {
		doc /* Further specialized configuration with a connection to a deeply-nested port. */

		
		part transmission: Transmission {
			port drive: ~DriveIF;
		}
		
		part redefines rearAxleAssembly {
			part redefines rearAxle {
				port drive: DriveIF;
			}
		}
		
		interface driveShaft connect 
			transDrive ::> transmission.drive to axleDrive ::> rearAxleAssembly.rearAxle.drive {
			flow transDrive.driveTorque to axleDrive.driveTorque;
		}		
	}
}
```

# Key Concepts Demonstrated

- [`part` usage](../concepts/part.md) — instantiating part definitions with multiplicity (e.g., `Lugbolt[4..5]`)
- [`subsets`](../concepts/subsetting.md) — specializing a usage to a subset of another usage
- [`redefines`](../concepts/redefinition.md) — overriding a part or attribute in a specialized context
- [`interface` usage](../concepts/interface.md) — connecting port ends via named interface usages with `connect`
- [Index notation `#(n)`](../concepts/indexing.md) — selecting individual members from a multiplicity set
- [Conjugate port `~`](../concepts/port-conjugation.md) — inverting port direction with the `~` operator
- [`flow`](../concepts/flow.md) — data/value flows declared inside interface bodies

# Notes

- The three configurations show progressive specialization: C1 establishes the tree, C2 names individual wheels and wires axle-to-wheel interfaces, C3 adds a powertrain and connects it through a deeply-nested port path using `::>` binding connectors.
- The `::>` syntax in `driveShaft` binds the anonymous connector ends (`transDrive`, `axleDrive`) to specific ports, enabling flow declarations that reference those ends.

# Citations

[1] OMG SysML v2 Specification, Annex A (example models)
