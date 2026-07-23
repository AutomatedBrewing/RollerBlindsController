---
type: SysML v2 Concept
title: Metadata Usage
description: A metadata usage is a kind of annotating element declared with the keyword `metadata` or the `@` symbol that applies a metadata definition to one or more model elements, providing structured or tagged annotation with typed attribute value bindings.
timestamp: 2026-07-01T00:00:00Z
---

A metadata usage is declared with keyword `metadata` (or the shorthand `@`) followed by the metadata definition name and an optional `about` clause naming the annotated elements. It is a kind of annotating element (§7.4) that attaches structured information to model elements.

Characteristics:
- **Definition**: a metadata usage is defined by exactly one metadata definition (or KerML metaclass)
- **Annotated elements**: identified by the `about` keyword, or implicitly the containing namespace if none are specified
- **Value bindings**: if the metadata definition has features, the usage body provides `<name> = <value>` bindings
- **Short forms**: `ref`, `redefines` (`:>>`), and `defined by` (`:`) may be omitted in the body

The inherited feature `annotatedElement` from `Metaobject` is implicitly bound to the annotated elements. A metadata usage can annotate multiple elements (listed after `about`).

# Syntax

```sysml
// Structured usage, long form
metadata ApprovalAnnotation about Design {
  ref :>> approved = true;
  ref :>> approver = "John Smith";
}

// Structured usage, short form (ref and :>> omitted)
metadata ApprovalAnnotation about Design {
  approved = true;
  approver = "John Smith";
}

// Shorthand @ syntax inside a namespace (implicit annotation of container)
partdef Design {
  @ApprovalAnnotation {
    approved = true;
    approver = "John Smith";
  }
}

// Simple tag (no value bindings needed)
metadata securityAnnotation : SecurityRelated
  about SecurityRequirements, SecurityDesign;

// Using @ shorthand
@SecurityRelated;
```

# Semantics

- A metadata usage is an annotating element (§7.4).
- The `annotatedElement` feature is implicitly bound to the listed elements or the containing namespace.
- If the metadata definition has features, value bindings must be provided for all of them.
- Feature bindings in the body redefine the features of the metadata definition; nested usages must use the same feature names.
- Semantic metadata usages may cause annotated types to implicitly specialize the `baseType` of the metadata definition.

# Rules

- Declared with `metadata <DefName>` or `@<DefName>`.
- The definition name (or KerML metaclass name) follows `metadata` or `@`.
- Annotated elements listed after `about`; omitted when nested inside the annotated element.
- Body provides `<name> = <model-level-evaluable-expression>` for each feature of the metadata definition.

# Examples

```sysml
metadata ToolMetadata about vehicleAnalysis {
  toolName     = "ToolX";
  toolURL      = "http://tool.example.com";
  behaviorName = "ComputeVehicleState";
}

verification def VehicleMassTest {
  // Annotate with the verification method
  metadata VerificationMethod {
    kind = VerificationMethodKind::test;
  }
  // ...
}
```

# Relationships

- [metadata.md](metadata.md) — general metadata concept
- [metadata-definition.md](metadata-definition.md) — the definition applied by this usage
- [annotation.md](annotation.md) — metadata usage is a kind of annotating element
- [verification-case.md](verification-case.md) — VerificationMethod metadata is often applied to verification cases

# Citations

[1] OMG SysML v2 Specification, §7.27.2
