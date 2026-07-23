---
type: SysML v2 Library
title: Requirement Derivation Library
description: The Requirement Derivation Library provides SysML v2 language-extension metadata and connection definitions for explicitly modeling how higher-level requirements are derived into lower-level requirements.
timestamp: 2026-07-01T00:00:00Z
---

The Requirement Derivation Library is a SysML v2 domain library for formalizing requirement-derivation traceability. It introduces a `Derivation` connection type and three companion semantic metadata annotations that allow modelers to tag usages as original requirements, derived requirements, or derivation connections. All source files use `.sysml` syntax and reside in the `Domain Libraries/Requirement Derivation/` directory.

# Contents

- **DerivationConnections** (`DerivationConnections.sysml`) — Defines the structural elements of the derivation relationship:
  - `Derivation` — a connection definition representing the formal derivation of one or more `derivedRequirements` from one or more `originalRequirements`.
  - `originalRequirements` — a usage feature for the higher-level (source) requirements end of a `Derivation`.
  - `derivedRequirements` — a usage feature for the lower-level (derived) requirements end of a `Derivation`.
  - `derivations` — the root feature for all `Derivation` usages.
- **RequirementDerivation** (`RequirementDerivation.sysml`) — Defines metadata annotation types for requirement derivation:
  - `OriginalRequirementMetadata` (`#original`) — a `SemanticMetadata` that identifies a usage as an original (parent) requirement and sets its `baseType` to the `originalRequirements` feature.
  - `DerivedRequirementMetadata` (`#derive`) — a `SemanticMetadata` that identifies a usage as a derived (child) requirement and sets its `baseType` to the `derivedRequirements` feature.
  - `DerivationMetadata` (`#derivation`) — a `SemanticMetadata` that identifies a `ConnectionDefinition` or `ConnectionUsage` as a derivation connection and sets its `baseType` to `derivations`.

# Key Types

| Type | Kind | Description |
|---|---|---|
| `Derivation` | connection def | Formal derivation relationship from original to derived requirements. |
| `originalRequirements` | usage feature | Root feature for original-requirement ends of a `Derivation`. |
| `derivedRequirements` | usage feature | Root feature for derived-requirement ends of a `Derivation`. |
| `OriginalRequirementMetadata` | metadata def | Tags a usage as an original requirement; keyword `#original`. |
| `DerivedRequirementMetadata` | metadata def | Tags a usage as a derived requirement; keyword `#derive`. |
| `DerivationMetadata` | metadata def | Tags a connection as a derivation connection; keyword `#derivation`. |

# Usage

Annotate requirements and connections to establish explicit derivation traceability:

```sysml
private import RequirementDerivation::*;
private import DerivationConnections::*;

package SystemRequirements {
    #original requirement def TopLevelSpeed { ... }

    #derive requirement def SubsystemSpeed :> TopLevelSpeed { ... }

    #derivation connection def SpeedDerivation :> Derivation
        from TopLevelSpeed to SubsystemSpeed;
}
```

# Source

`c:\workspace\KnowledgeExtractor\Input\Sysml_2\SysML-v2-Pilot-Implementation\sysml.library\Domain Libraries\Requirement Derivation\`

Files: `DerivationConnections.sysml`, `RequirementDerivation.sysml`

# Related Libraries

- [Systems Library](./systems-library.md)
- [Cause and Effect Library](./cause-effect-library.md)

# Citations

[1] OMG SysML v2 Specification, §9
