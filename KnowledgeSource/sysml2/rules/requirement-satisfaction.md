---
type: SysML v2 Rule
title: Requirement Satisfaction and Verification
description: A requirement is satisfied when it evaluates to true, and a satisfy requirement usage asserts satisfaction by binding a given feature to the subject parameter of the requirement.
timestamp: 2026-07-01T00:00:00Z
---

A requirement definition is a kind of constraint definition that specifies stakeholder-imposed constraints that a design solution must satisfy to be a valid solution. Since a requirement is a kind of constraint, it can be evaluated to true or false: a requirement is satisfied when it evaluates to true.

# Rule Statement

## Requirement Structure

- A requirement definition contains one or more features that are constraint usages designated as the **required constraints**.
- These may be specified informally using text statements (commonly known as "shall" statements) or more formally using constraint expressions.
- A requirement definition may also optionally include **assumed constraints**. The required constraints of a requirement only apply if all the assumed constraints are satisfied.
- The effective constraint for a requirement is a logical implication: if all the assumption constraints are true, all the required constraints must be true.

## Subject

- A requirement definition or usage always has a **subject**, which is a distinguished parameter that identifies the entity on which the requirement is being specified.
- A requirement usage can only be satisfied by an entity that conforms to the definition of its subject.
- The subject parameter is always an `in` parameter. The keyword `subject` is used instead of an explicit direction keyword.
- If no subject is explicitly specified, the subject is implicitly assumed to be defined as `Anything`.

## Require and Assume Keywords

- Required constraints are declared with the `require` keyword before a constraint usage declaration.
- Assumed constraints are declared with the `assume` keyword before a constraint usage declaration.
- Alternatively, `assume` or `require` may be followed immediately by a qualified name or feature chain identifying an existing constraint, related by a reference subsetting relationship.

## Satisfaction

- A **satisfy requirement usage** is a kind of assert constraint usage that asserts that a requirement is satisfied when a given feature is bound to the subject parameter of the requirement.
- Syntax: `satisfy <requirementUsage> by <subject>;` or `satisfy <requirementUsage>;` (within the body of the satisfying element).
- A satisfy requirement usage can also be **negated**, asserting that some entity does **not** satisfy the given requirement.
- A requirement usage must be defined by a **single** requirement definition.

## Decomposition

- A requirement definition or usage may be decomposed into nested requirement usages.
- Any nested **composite** requirement usage is automatically considered a required constraint of the containing requirement.
- For the overall requirement to be satisfied, all nested composite or referenced requirements must be satisfied.

# Rationale

Requirement satisfaction provides the link between the requirements model and the design model, enabling formal verification that design elements meet specified constraints. The subject parameter enables requirements to be written as reusable templates and then applied to specific design solutions.

# Examples

```
requirement def <'1.1'> MaximumMass {
    doc
    /*
     * Assuming the required mass is greater than 0,
     * the actual mass shall be less than or equal to
     * the required mass.
     */
    attribute massActual : MassValue;
    attribute massRequired : MassValue;
    assume constraint { massRequired > 0[kg] }
    require constraint { massActual <= massRequired }
}

requirement <'v1.1'> vehicleMaximumMass : MaximumMass {
    subject vehicle : Vehicle;
    attribute :>> massActual = vehicle.totalMass;
    attribute :>> massRequired = 2000[kg];
}

// Satisfaction
part part1 : Part1 {
    satisfy vehicleMaximumMass;
}

// Shorthand
satisfy requirement1 by part1;
```

# Violations

- Declaring a requirement usage defined by more than one requirement definition.
- Declaring a subject parameter after other parameters in a requirement definition or usage.
- Asserting satisfaction by an entity whose type does not conform to the subject definition of the requirement.
- Having a required constraint that is evaluated without all assumed constraints being checked first.

# Related Concepts

- [Definition-Usage Pattern](definition-usage-pattern.md)
- [Specialization Rules](specialization-rules.md)

# Citations

[1] OMG SysML v2 Specification, §7.21.1 (Requirements Overview)
[2] OMG SysML v2 Specification, §7.21.2 (Requirement Definition and Usage)
