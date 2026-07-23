---
type: SysML v2 Diagram
title: Constraint Diagram
description: A Constraint Diagram shows constraint definitions and usages, their formal constraint expressions, and how constraint parameters are bound to model elements to evaluate system properties.
timestamp: 2026-07-01T00:00:00Z
---

The Constraint Diagram is the SysML v2 diagram type for modeling mathematical and logical constraints that apply to system elements. Constraints in SysML v2 are formal expressions that evaluate to true or false. They can represent design constraints, performance constraints, physical laws, or any other formally expressible system property.

A constraint definition is a kind of occurrence definition that classifies the constraint. A constraint usage is a kind of occurrence usage applied in some context.

# Purpose

Constraint diagrams are used to:
- Define reusable constraint expressions in terms of constraint parameters.
- Show constraint usages applied within definitions and usages, binding constraint parameters to specific model features.
- Support parametric modeling by expressing mathematical relationships between system attributes.
- Compose constraints as building blocks for requirements (assumed and required constraints).
- Show bindings between constraint parameters and the design model attributes they constrain.

# Notation

## Constraint Symbol

A constraint definition is shown as a rectangle with the `«constraint def»` stereotype:

```
«constraint def»
ConstraintDef1
```

A constraint usage is shown with the `«constraint»` stereotype:

```
«constraint»
constraint1 : ConstraintDef1
```

## Constraint Expression Compartment

The constraint expression is displayed as a formal Boolean expression in the body or a documentation compartment:

```
«constraint»
massLimit
  { massActual <= massRequired }
```

## Parameter Bindings

Constraint parameter bindings are shown as bind connections between the constraint parameters and the model attributes or usages they are bound to. In the textual notation:

```
constraint massLimit {
    attribute mass : MassValue;
    attribute massLimit : MassValue;
    mass <= massLimit;
}
```

Applied in a requirement with parameter bindings:

```
require massLimit {
    :>> mass = massActual;
    :>> massLimit = massRequired;
}
```

## Constraint Assume and Require

In a requirements context, constraint usages are decorated with:
- **«assume»** stereotype: The constraint is an assumed condition.
- **«require»** stereotype: The constraint is a required condition.
- **«assume constraint»**: An inline assumed constraint usage.
- **«require constraint»**: An inline required constraint usage.

# Frame and Header

The diagram frame header for a constraint diagram typically uses the identifier `constraint` or `cst`.

# Compartments

Constraint definition and usage symbols may include:
- **parameters** — the constraint's input parameters (attribute usages typed by value types).
- **constraint expression** — the Boolean expression body.
- **documentation** — informal description of the constraint.

# Examples

```
constraint def MassLimitConstraint {
    attribute massActual : MassValue;
    attribute massRequired : MassValue;
    massActual <= massRequired;
}

constraint def PositiveMass {
    attribute mass : MassValue;
    mass > 0[kg];
}

// Applied in a part definition
part def Vehicle {
    attribute totalMass : MassValue;
    attribute maxAllowedMass : MassValue := 2000[kg];

    constraint massCheck : MassLimitConstraint {
        :>> massActual = totalMass;
        :>> massRequired = maxAllowedMass;
    }
}
```

# Related Concepts

- [Requirement Satisfaction](../rules/requirement-satisfaction.md)
- [Requirements Diagram](requirements-diagram.md)
- [Definition-Usage Pattern](../rules/definition-usage-pattern.md)

# Citations

[1] OMG SysML v2 Specification, §7.20 (Constraints)
[2] OMG SysML v2 Specification, §7.21.2 (Requirement Definition and Usage), assumed/required constraints
