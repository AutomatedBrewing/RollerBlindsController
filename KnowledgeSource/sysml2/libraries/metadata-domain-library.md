---
type: SysML v2 Library
title: Metadata Domain Library
description: The Metadata Domain Library provides standard metadata annotation definitions for model status tracking, risk assessment, image annotation, and parameter-of-interest designation in SysML v2 models.
timestamp: 2026-07-01T00:00:00Z
---

The Metadata Domain Library is a SysML v2 domain library that supplies a set of reusable metadata annotation types intended for annotating model elements with engineering and management information. It does not introduce new structural or behavioral types; instead it extends the language with `metadata def` and `enum def` elements for common annotation concerns. All source files use `.sysml` syntax and reside in the `Domain Libraries/Metadata/` directory.

# Contents

- **ModelingMetadata** (`ModelingMetadata.sysml`) — Provides metadata for general model management annotations:
  - `StatusKind` — enumeration with values `open`, `tbd`, `tbr`, `tbc`, `done`, `closed` representing the work status of a model element.
  - `StatusInfo` — metadata definition for attaching a `StatusKind` status and an optional `description` string to any model element.
  - `ReviewInfo` — metadata for recording review notes and reviewer identity on model elements.
  - Additional general-purpose modeling annotation types.
- **RiskMetadata** (`RiskMetadata.sysml`) — Provides metadata for risk assessment:
  - `Level` — an attribute definition (specializing `Real`) constrained to the interval [0.0, 1.0].
  - `LevelEnum` — enumeration providing standard probability levels: `low` (0.25), `medium` (0.50), `high` (0.75).
  - `RiskLevel` — attribute definition combining `probability` and optional `impact` levels.
  - `RiskLevelEnum` — enumeration of standard risk levels with defined probability values.
  - `Risk` — metadata definition for annotating model elements with a `RiskLevel`.
- **ImageMetadata** (`ImageMetadata.sysml`) — Provides metadata for associating image resources with model elements, including URI and MIME type attributes.
- **ParametersOfInterestMetadata** (`ParametersOfInterestMetadata.sysml`) — Provides `ParameterOfInterest` and related metadata for tagging features as parameters of interest in analysis contexts.

# Key Types

| Type | Kind | Description |
|---|---|---|
| `StatusKind` | enum def | Work status: `open`, `tbd`, `tbr`, `tbc`, `done`, `closed`. |
| `StatusInfo` | metadata def | Annotates model element with a `StatusKind` and optional `description`. |
| `Level` | attribute def | Real number in [0.0, 1.0] for expressing probability/impact levels. |
| `LevelEnum` | enum def | Standard level values: `low`=0.25, `medium`=0.50, `high`=0.75. |
| `RiskLevel` | attribute def | Combines `probability` and optional `impact` levels. |
| `Risk` | metadata def | Annotates model elements with a `RiskLevel`. |
| `ImageMetadata` | metadata def | Associates an image URI and MIME type with a model element. |
| `ParameterOfInterest` | metadata def | Tags a feature as a parameter of interest for analysis. |

# Usage

Import the desired metadata package and annotate model elements:

```sysml
private import ModelingMetadata::StatusInfo;
private import RiskMetadata::Risk;

#StatusInfo(status = ModelingMetadata::StatusKind::tbd)
part def PropulsionSystem { ... }

#Risk(riskLevel = RiskMetadata::RiskLevelEnum::high)
requirement def ThrustRequirement { ... }
```

# Source

`c:\workspace\KnowledgeExtractor\Input\Sysml_2\SysML-v2-Pilot-Implementation\sysml.library\Domain Libraries\Metadata\`

Files: `ModelingMetadata.sysml`, `RiskMetadata.sysml`, `ImageMetadata.sysml`, `ParametersOfInterestMetadata.sysml`

# Related Libraries

- [Systems Library](./systems-library.md)
- [Analysis Domain Library](./analysis-domain-library.md)

# Citations

[1] OMG SysML v2 Specification, §9
