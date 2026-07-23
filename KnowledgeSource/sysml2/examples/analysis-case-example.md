---
type: SysML v2 Example
title: Analysis Case — Vehicle Dynamics
description: Demonstrates SysML v2 analysis actions and calculation definitions for straight-line vehicle dynamics, showing two equivalent styles of expressing cascaded physics computations.
timestamp: 2026-07-01T00:00:00Z
---

This example defines four calculation definitions (Power, Acceleration, Velocity, Position) and a `StraightLineVehicleDynamics` action definition that combines them via an `assert constraint`. Two concrete action usages (`dyn1`, `dyn2`) show alternative styles: `dyn1` uses inline attribute assignments with redefinitions, while `dyn2` uses named `calc` usages with explicit bindings.

# Source

```sysml
package Dynamics {
	private import ScalarValues::Real;
	private import ISQ::*;
	
	// Function definitions
	
	calc def Power {
		in whlpwr : PowerValue; in Cd : Real; in Cf : Real; in tm : MassValue; in v : SpeedValue;
		return tp : PowerValue = whlpwr - Cd * v - Cf * tm * v;
	}
	
	calc def Acceleration { in dt : TimeValue; in tm : MassValue; in tp: PowerValue; 
		return a : AccelerationValue = tp * dt * tp;
	}
	
	calc def Velocity { in dt : TimeValue; in v0 : SpeedValue; in a : AccelerationValue;
		return v : SpeedValue = v0 + a * dt;
	}
 	
	calc def Position { in dt : TimeValue; in x0 : LengthValue; in v : SpeedValue; 
		return x : LengthValue = x0 + v * dt;
	}

	// Analysis action def
	
	action def StraightLineVehicleDynamics {
		
		in attribute dt : TimeValue;
		in attribute whlpwr : PowerValue;
		in attribute Cd : Real;
		in attribute Cf: Real;
		in attribute tm : MassValue;
		in attribute v_in : SpeedValue;
		in attribute x_in : LengthValue;
		
		out attribute a_out : AccelerationValue;
		out attribute v_out : SpeedValue;
		out attribute x_out : LengthValue;
			
		assert constraint {
			attribute tp : PowerValue;
			
			tp == Power(whlpwr, Cd, Cf, tm, v_in) &
			a_out == Acceleration(dt, tm, tp) &
			v_out == Velocity(dt, v_in, a_out) &
			x_out == Position(dt, x_in, v_in)
		}
	}
	

	// Analysis actions
	
	action dyn1 : StraightLineVehicleDynamics {
        in attribute dt : TimeValue;
        in attribute whlpwr : PowerValue;
        in attribute Cd : Real;
        in attribute Cf: Real;
        in attribute tm : MassValue;
        in attribute v_in : SpeedValue;
        in attribute x_in : LengthValue;

		attribute tp : PowerValue = Power(whlpwr, Cd, Cf, tm, v_in);
		
		out attribute :>> a_out : AccelerationValue = Acceleration(dt, tm, tp);
		out attribute :>> v_out : SpeedValue = Velocity(dt, v_in, a_out);
		out attribute :>> x_out : LengthValue = Position(dt, x_in, v_in);
	}	
	
	action dyn2 : StraightLineVehicleDynamics {
		calc acc : Acceleration {
			in dt = dyn2::dt;
			in tm = dyn2::tm;
			in tp = Power(whlpwr, Cd, Cf, tm, v_in);
		}
		bind a_out = acc.a;
		
		calc vel : Velocity {
			in dt = dyn2::dt;
			in v0 = dyn2::v_in; 
			in a = acc.a;
		}
		bind v_out = vel.v;
		
		calc pos : Position {
			in dt = dyn2::dt;
			in x0 = dyn2::x_in;
			in v0 = vel.v;
		}
		bind x_out = pos.x;
	}
}
```

# Key Concepts Demonstrated

- [`calc def`](../concepts/calc-def.md) — defining typed calculation functions with `in` parameters and a `return` expression
- [`action def`](../concepts/action-def.md) — defining a reusable action classifier with input/output attributes
- [`assert constraint`](../concepts/constraint.md) — embedding a constraint block inside an action to specify behavioral relations
- [`out attribute :>> redefines`](../concepts/redefinition.md) — redefined output attributes with computed values in `dyn1`
- [`calc` usage with `bind`](../concepts/calc.md) — named calculation usages with explicit input binding and output binding in `dyn2`
- [Qualified name reference `dyn2::dt`](../concepts/qualified-name.md) — referencing an outer scope feature from inside a nested calc usage
- [ISQ quantity types](../concepts/quantities.md) — `PowerValue`, `MassValue`, `SpeedValue`, etc. from the ISQ library

# Notes

- `dyn1` and `dyn2` are semantically equivalent formulations of the same dynamics. `dyn1` is more declarative (expression-style), while `dyn2` is more structural (named calc usages with explicit dataflow bindings).
- The `assert constraint` in `StraightLineVehicleDynamics` uses `&` (logical AND) to chain multiple equality constraints, forming a specification-level behavioral contract independently of any particular evaluation order.
- The `dyn2::dt` qualified-name pattern is needed inside nested `calc` usages to reference the enclosing action's parameters, since the inner scope would otherwise shadow or not inherit outer names.

# Citations

[1] OMG SysML v2 Specification, Annex A (example models)
