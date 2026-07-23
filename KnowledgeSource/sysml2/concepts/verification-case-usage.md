---
okf_version: "0.1"
type: SysML v2 Concept
title: Verification Case Usage
description: A verification case usage is an application of a verification case definition that verifies a specific subject against one or more requirements, returning a VerdictKind result.
timestamp: 2026-07-01T00:00:00Z
---

A **verification case usage** is a usage of a [verification case definition](verification-case-definition.md). It is declared with the keyword `verification` (without `def`). A verification case usage instantiates the definition in a specific containment context, binding the `subject` parameter to a concrete model element (e.g., a `part usage`) and asserting `verify` relationships to the specific requirements it checks.

The result of any verification case usage is a `VerdictKind` value (`pass`, `fail`, `inconclusive`, or `error`).

Verification case usages are the operational complement to verification case definitions: definitions specify *how* to verify; usages apply that procedure to a *specific system element* and its *specific requirements*.

# Syntax

```sysml
// Inside a test package or test part def:
verification <name> : <VerificationCaseDefinition> {
  subject <name> : <SubjectType>;  // binds the subject to a specific part
}

// Inline (anonymous) form:
verification : <VerificationCaseDefinition>;

// With explicit verify links in objective (if overriding definition):
verification massCheck : VehicleMassTest {
  subject testVehicle : CoffeeMachineProduct;
  objective {
    verify REQ_PF_001_BrewTime;
    verify REQ_SF_001_ThermalSafety;
  }
}
```

# Semantics

- Declared using the keyword `verification` (a usage keyword, not `verification def`).
- A verification case usage must be typed by exactly one [verification case definition](verification-case-definition.md).
- The `subject` parameter of the usage must be bound to a specific `part usage` or `item usage` — it cannot remain unbound.
- `verify <requirement>` in the `objective` block identifies which requirements this usage instance checks. If the objective is inherited from the definition, individual usages may add additional `verify` links.
- The returned verdict propagates from the definition's `return verdict : VerdictKind` expression.
- Multiple verification case usages can type-share the same definition while checking different subjects or different requirement sets.

# Rules

- Declared with `verification` (not `verification def`).
- The `subject` must be bound in the usage if the definition leaves it unbound.
- Every `verify` target must be a `requirement def` or `requirement usage` accessible in scope.
- A verification case usage is a kind of case usage, which is a kind of calculation usage.

# Examples

```sysml
package CoffeeMachine_TestCases {

  // Reuse definition from SM-PRD-16 test cases
  verification def VerifyBrewTime {
    subject cm : CoffeeMachine;
    objective {
      verify REQ_PF_001_BrewWithin30s;
    }
    return verdict : VerdictKind;
  }

  // Usage 1: verify the nominal product (SM-PRD-21)
  part def CoffeeMachineTestBench {
    part sut : CoffeeMachineProduct;

    // Verification case usage — applies VerifyBrewTime to the SUT
    verification brewTimeCheck : VerifyBrewTime {
      subject sut;
    }
  }

  // Usage 2: verify a variant product on the same test bench
  part def CoffeeMachineVariantTestBench {
    part sut : CoffeeMachineVariant;

    verification brewTimeCheckVariant : VerifyBrewTime {
      subject sut;
      objective {
        verify REQ_PF_001_BrewWithin30s;
        verify REQ_PF_002_BrewTemperature; // additional requirement for variant
      }
    }
  }
}
```

# Relationships

- [verification-case-definition.md](verification-case-definition.md) — the definition this usage instantiates
- [verification-case.md](verification-case.md) — general verification case concept
- [case-usage.md](case-usage.md) — supertype (verification case usage is a kind of case usage)
- [satisfy.md](satisfy.md) — complement: `satisfy` links design to requirements; `verify` links tests to requirements
- [requirement-usage.md](requirement-usage.md) — the target of `verify` relationships in the objective

# Citations

[1] OMG SysML v2 Specification, §7.24.3
