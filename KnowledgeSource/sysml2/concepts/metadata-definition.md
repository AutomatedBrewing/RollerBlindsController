---
type: SysML v2 Concept
title: Metadata Definition
description: A metadata definition is declared like an item definition using the keyword `metadata def` and defines the structure of a structured annotation that can be applied to model elements as a metadata usage.
timestamp: 2026-07-01T00:00:00Z
---

A metadata definition is declared with the keyword `metadata def`. It is structurally similar to an item definition (§7.10) but is used to define the schema of annotations rather than domain items. A metadata definition can:

- Have **no features** — acting as a simple syntactic tag when used as a metadata usage
- Have **attribute features** — requiring value bindings in any metadata usage of this definition
- **Restrict annotatable element types** by subsetting `Metaobject::annotatedElement` and restricting its type to a reflective metaclass
- Specialize **`SemanticMetadata`** (§7.27.3) to make annotated types implicitly specialize a base type
- Be used as a **user-defined keyword** via the `#` prefix (§7.27.4)

The base library element is `MetadataItem` from the `Metadata` library.

# Syntax

```sysml
// Simple tag (no features)
metadata def SecurityRelated;

// Structured annotation
metadata def ApprovalAnnotation {
  attribute approved : Boolean;
  attribute approver : String;
}

// With restricted annotatable element type
metadata def CommandMetadata {
  :> annotatedElement : SysML::ActionDefinition;
  :> annotatedElement : SysML::ActionUsage;
}

// Semantic metadata (annotated types implicitly specialize UserAction)
action def UserAction;
action userActions : UserAction[*] nonunique;

metadata def <situation> SituationMetadata :> SemanticMetadata {
  :>> baseType = userActions meta SysML::Usage;
}
```

# Semantics

- A metadata definition specializes item definition structurally.
- If a metadata usage applies a metadata definition that has features, all features must have value bindings in the usage body.
- A metadata definition can restrict which element types it can annotate by subsetting `annotatedElement`.
- A semantic metadata definition (specializing `SemanticMetadata`) causes annotated types to implicitly specialize `baseType`.
- The `#<name>` prefix can be used to apply a semantic metadata definition as a user-defined keyword in declarations.

# Rules

- Declared with `metadata def`.
- May optionally specialize `SemanticMetadata` for semantic annotation effects.
- Can subset `annotatedElement` to restrict the types of elements it annotates.
- If features are declared, all metadata usages of this definition must provide value bindings.

# Examples

```sysml
metadata def ProjectInfo {
  attribute projectName  : String;
  attribute modifiedAt   : Time::Iso8601DateTime;
  attribute author       : String;
  attribute status       : StatusKind;
}

metadata def VerificationMethod {
  attribute kind : VerificationMethodKind;
}
```

# Relationships

- [metadata.md](metadata.md) — general metadata concept
- [metadata-usage.md](metadata-usage.md) — usages of this definition
- [item-definition.md](item-definition.md) — analogous structural pattern

# Citations

[1] OMG SysML v2 Specification, §7.27.2, §7.27.3, §7.27.4
