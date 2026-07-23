---
type: SysML v2 Library
title: Cause and Effect Library
description: The Cause and Effect Library provides SysML v2 language-extension metadata and connection definitions for modeling multicausation relationships between occurrences.
timestamp: 2026-07-01T00:00:00Z
---

The Cause and Effect Library is a SysML v2 domain library for explicitly modeling causal relationships between system occurrences. It defines both structural connection types (for the causal network) and semantic metadata annotations (for tagging usages as causes or effects). All source files use `.sysml` syntax and reside in the `Domain Libraries/Cause and Effect/` directory.

# Contents

- **CausationConnections** (`CausationConnections.sysml`) — Defines the structural connection types used in cause-effect models:
  - `Multicausation` — a connection definition representing a many-to-many causal relationship where one or more `causes` produce one or more `effects`.
  - `causes` — a `connection usage` feature representing the cause ends of a `Multicausation`.
  - `effects` — a `connection usage` feature representing the effect ends of a `Multicausation`.
  - `originalRequirements` / `derivedRequirements` — usage features referenced by the companion derivation library.
- **CauseAndEffect** (`CauseAndEffect.sysml`) — Defines metadata annotation types for causal modeling:
  - `CauseMetadata` (`#cause`) — a `SemanticMetadata` that identifies a usage as a cause occurrence and sets its `baseType` to the `causes` feature.
  - `EffectMetadata` (`#effect`) — a `SemanticMetadata` that identifies a usage as an effect occurrence and sets its `baseType` to the `effects` feature.
  - `CausationMetadata` — a metadata definition annotating a `ConnectionDefinition` or `ConnectionUsage` with causal properties:
    - `isNecessary : Boolean` — whether all causes are necessary for all effects.
    - `isSufficient : Boolean` — whether the causes are sufficient for all effects.
    - `probability : Real[0..1]` — the probability that the causes produce the effects.

# Key Types

| Type | Kind | Description |
|---|---|---|
| `Multicausation` | connection def | Many-to-many causal connection between occurrences. |
| `CauseMetadata` | metadata def | Tags a usage as a cause; keyword `#cause`. |
| `EffectMetadata` | metadata def | Tags a usage as an effect; keyword `#effect`. |
| `CausationMetadata` | metadata def | Annotates a causation connection with `isNecessary`, `isSufficient`, `probability`. |

# Usage

Define cause-effect relationships by annotating usage features and connections:

```sysml
private import CauseAndEffect::*;
private import CausationConnections::*;

part def FaultPropagationModel {
    #cause occurrence def Overpressure { ... }
    #effect occurrence def ValveFailure { ... }

    connection :> Multicausation
        #CausationMetadata(isNecessary = true, isSufficient = false, probability = 0.8)
        from Overpressure to ValveFailure;
}
```

# Source

`c:\workspace\KnowledgeExtractor\Input\Sysml_2\SysML-v2-Pilot-Implementation\sysml.library\Domain Libraries\Cause and Effect\`

Files: `CausationConnections.sysml`, `CauseAndEffect.sysml`

# Related Libraries

- [Systems Library](./systems-library.md)
- [Requirement Derivation Library](./requirement-derivation-library.md)

# Citations

[1] OMG SysML v2 Specification, §9
