---
type: SysML v2 Concept
title: Metadata
description: Metadata in SysML v2 is the general concept encompassing metadata definitions and metadata usages, providing a mechanism to attach structured, modeler-defined annotations with typed attributes to model elements.
timestamp: 2026-07-01T00:00:00Z
---

Metadata is the general concept covering both **metadata definitions** (defining the structure of an annotation) and **metadata usages** (applying that annotation to one or more model elements). Metadata usages are a kind of annotating element (§7.4) that allow modelers to attach tool-specific, project-specific, or domain-specific information to any model element.

There are two flavors of metadata definition behavior:
1. **Simple tag** — if the metadata definition has no features, the usage acts as a user-defined syntactic tag
2. **Structured annotation** — if the definition has features, the usage must provide value bindings for all of them

Metadata can also be used as **semantic metadata** (§7.27.3) by specializing `SemanticMetadata`, which causes annotated types to implicitly specialize the `baseType` of the metadata definition.

Metadata definitions can also serve as **user-defined keywords** using the `#` prefix (§7.27.4).

# Syntax

```sysml
// Simple tag metadata definition
metadata def SecurityRelated;

// Structured metadata definition
metadata def ApprovalAnnotation {
  attribute approved : Boolean;
  attribute approver : String;
}

// Usage — long form
metadata ApprovalAnnotation about Design {
  approved = true;
  approver = "John Smith";
}

// Usage — shorthand @ syntax
partdef Design {
  @ApprovalAnnotation {
    approved = true;
    approver = "John Smith";
  }
}

// Usage annotating multiple elements
metadata securityDesignAnnotation : SecurityRelated
  about SecurityRequirements, SecurityDesign;
```

# Semantics

- A metadata usage is a kind of annotating element (§7.4).
- A metadata usage is defined by exactly one metadata definition or KerML metaclass.
- If the definition has features, the usage body must provide value bindings for all features.
- If the metadata usage is owned by a namespace, the annotated element is implicitly the containing namespace.
- `annotatedElement` is inherited from `Metaobject` and is implicitly bound to the annotated elements.

# Rules

- Metadata definitions declared with `metadata def`.
- Metadata usages declared with `metadata` or `@` followed by the definition name.
- `about` keyword identifies explicitly annotated elements.
- Feature value bindings use `<name> = <value>` (shorthand: `ref` and `redefines`/`:>>` may be omitted).
- Metadata definitions can restrict annotatable element types by subsetting `annotatedElement`.

# Examples

```sysml
metadata def ToolMetadata {
  attribute toolName : String;
  attribute toolURL  : String;
  attribute behaviorName : String;
}

analysis vehicleAnalysis : VehicleAnalysis;
metadata ToolMetadata about vehicleAnalysis {
  toolName     = "ToolX";
  toolURL      = "http://...";
  behaviorName = "ComputeVehicleState";
}
```

# Relationships

- [metadata-definition.md](metadata-definition.md) — the definition form
- [metadata-usage.md](metadata-usage.md) — the usage form
- [annotation.md](annotation.md) — metadata is a kind of annotating element

# Citations

[1] OMG SysML v2 Specification, §7.27.1
