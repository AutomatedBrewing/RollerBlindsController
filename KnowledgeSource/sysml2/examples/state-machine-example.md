---
type: SysML v2 Example
title: State Space Representation — Cart Sample
description: Demonstrates SysML v2 continuous state-space dynamics modeling by defining a Cart part with typed input, output, and state attributes connected to a pusher via a behavior flow.
timestamp: 2026-07-01T00:00:00Z
---

This example models a cart-and-pusher system using the `StateSpaceRepresentation` library. The `Cart` part defines typed `CartInput`, `CartOutput`, and `CartState` attribute definitions, and hosts a `ContinuousStateSpaceDynamics` action behavior that specifies how state derivatives and outputs are computed. The `Pusher` part provides force output that flows into the cart's behavior input.

# Source

```sysml
// State Space Representation cart example

package CartSample {
    private import StateSpaceRepresentation::*;
    part def Cart {
        attribute mass :> ISQ::mass;

        attribute def CartInput :> Input {
            attribute force :> ISQ::force;
        }

        attribute def CartOutput :> Output {
            attribute velocity :> ISQ::speed;
        }

        attribute def CartState :> StateSpace {
            attribute velocity :> ISQ::speed;
        }

        attribute def CartStateDerivative :> StateDerivative {
            ref :>> stateSpace : CartState;
            attribute accel :> ISQ::acceleration;
        }
    }

    part def Pusher {
        attribute def PusherOutput :> Output {
            attribute force :> ISQ::force;
        }
    }

    part context {
        part cart : Cart {
            action cartBehavior : ContinuousStateSpaceDynamics {
                in input : CartInput;
                out output : CartOutput;
                :>> stateSpace : CartState;

                calc :>> getDerivative { 
                	in input: CartInput; 
                	in stateSpace: CartState;
                    new CartStateDerivative(input.force / mass)
                }
                calc :>> getOutput {
                	in :>> stateSpace : CartState;
                    new CartOutput(stateSpace.velocity)
                }
            }
        }
        part pusher : Pusher {
            attribute pusherForce :> ISQ::force;

            action pusherBehavior : ContinuousStateSpaceDynamics {
                in input;
                out output : PusherOutput;
                calc :>> getOutput {
                    new PusherOutput(pusherForce)
                }
            }
        }

        flow pusher.pusherBehavior.output to cart.cartBehavior.input;
    }
}
```

# Key Concepts Demonstrated

- [`StateSpaceRepresentation` library](../concepts/state-space.md) — standard SysML v2 library for continuous dynamics modeling
- [`ContinuousStateSpaceDynamics` action](../concepts/state-space.md) — typed behavior for state-space systems with derivative and output computations
- [`attribute def` with inheritance](../concepts/attribute-def.md) — defining typed input/output/state attribute classifiers by specializing library types
- [`calc :>> redefines`](../concepts/calc.md) — redefining inherited calculation steps (`getDerivative`, `getOutput`) with concrete expressions
- [`new` expression](../concepts/new-expression.md) — constructing a new instance of an attribute type inline
- [`flow` between action features](../concepts/flow.md) — connecting output of one part's behavior to input of another

# Notes

- The `new CartStateDerivative(input.force / mass)` expression shows SysML v2's constructor-like syntax for creating typed attribute instances with computed field values.
- The `flow pusher.pusherBehavior.output to cart.cartBehavior.input` at the context level is a cross-part behavioral connection, linking the pusher's force output directly to the cart's dynamics input.
- The `StateSpaceRepresentation` library provides a reusable framework for expressing continuous system dynamics in a model-theoretic way, bridging SysML structural models and control-system formulations.

# Citations

[1] OMG SysML v2 Specification, Annex A (example models)
