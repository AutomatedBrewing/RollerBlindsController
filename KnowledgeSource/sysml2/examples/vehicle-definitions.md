---
type: SysML v2 Example
title: Vehicle Definitions
description: Demonstrates how to define parts, ports, and interfaces for a vehicle model using SysML v2 structural definitions.
timestamp: 2026-07-01T00:00:00Z
---

This example defines the structural building blocks of a vehicle system: part definitions for Vehicle, Transmission, AxleAssembly, Axle, Wheel, and Lugbolt; port definitions for drive, axle-mount, and wheel-hub interfaces; and an interface definition that connects axle-mount ports to wheel-hub ports with a torque flow.

# Source

```sysml
package VehicleDefinitions {
	doc
	/*
	 * Example vehicle definitions model.
	 */

	private import ScalarValues::*;
	private import Quantities::*;
	private import MeasurementReferences::*;
	private import ISQ::*;
	private import SI::*;
	
	/* PART DEFINITIONS */
	
	part def Vehicle {
		attribute mass :> ISQ::mass;
	}
	part def Transmission;	
	part def AxleAssembly;
	part def Axle {
		port leftMountingPoint: AxleMountIF;
		port rightMountingPoint: AxleMountIF;
	}
	part def Wheel {
		port hub: WheelHubIF;
	}
	part def Lugbolt {
		attribute tighteningTorque :> ISQ::torque;
	}
	
	/* PORT DEFINITIONS */
	
	port def DriveIF { 
		in driveTorque :> ISQ::torque;
	}
	
	port def AxleMountIF { 
		out transferredTorque :> ISQ::torque;
	}
	
	port def WheelHubIF { 
		in appliedTorque :> ISQ::torque;
	}
	
	/* INTERFACE DEFINITIONS */
	
	interface def Mounting {
		doc /* The definition of the interface for mounting a Wheel to an Axle. */
		end axleMount: AxleMountIF;
		end hub: WheelHubIF;
		
		flow axleMount.transferredTorque to hub.appliedTorque;
	}
}
```

# Key Concepts Demonstrated

- [`part def`](../concepts/part-def.md) — defining reusable part classifiers (Vehicle, Axle, Wheel, etc.)
- [`port def`](../concepts/port-def.md) — typed port classifiers with directional flow features (DriveIF, AxleMountIF, WheelHubIF)
- [`interface def`](../concepts/interface-def.md) — interface with named ends and a torque `flow` between ports
- [`attribute`](../concepts/attribute.md) — typed attributes redefined from ISQ quantity kinds (mass, torque)
- [ISQ / SI imports](../concepts/quantities.md) — use of standard International System of Quantities library

# Notes

- The `Mounting` interface definition shows how SysML v2 explicitly models the torque flow across connected ports, providing traceability between structural connectivity and physical quantities.
- Port directionality (`in`/`out`) on feature declarations defines the conjugate relationship needed when connecting parts.
- This file is the definitions-only side of the vehicle example; actual part usages and configurations are in `VehicleUsages.sysml`.

# Citations

[1] OMG SysML v2 Specification, Annex A (example models)
