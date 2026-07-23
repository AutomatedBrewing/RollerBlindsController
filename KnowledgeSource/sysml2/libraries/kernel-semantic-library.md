---
type: SysML v2 Library
title: Kernel Semantic Library
description: The Kernel Semantic Library defines the foundational semantic types and behavioral constructs of the KerML language upon which all SysML v2 models are built.
timestamp: 2026-07-01T00:00:00Z
---

The Kernel Semantic Library is the lowest-level standard library in the SysML v2/KerML stack. It defines the abstract classifiers, associations, occurrences, objects, performances, and transfer mechanisms that give the language its core semantics. Every classifier in both the Kernel Function Library and the SysML Systems Library ultimately specializes types defined here. All files in this library use the `.kerml` extension and are declared as `standard library package` elements.

# Contents

- **Base** (`Base.kerml`) — Defines `Anything` (the root classifier), `DataValue`, the top-level feature `things`, `dataValues`, `naturals`, and the standard multiplicity literals `exactlyOne`, `zeroOrOne`, `oneToMany`, `zeroOrMany`.
- **Links** (`Links.kerml`) — Defines `Link` (the most general association), `BinaryLink`, `SelfLink`, and the root features `links`, `binaryLinks`, `selfLinks`.
- **Occurrences** (`Occurrences.kerml`) — Defines `Occurrence` as the most general classifier of time-and-space entities, including features for `suboccurrences`, `superoccurrence`, `timeSlices`, `spaceSlices`, temporal/spatial containment connectors (`HappensDuring`, `HappensWhile`, etc.), and `Life`.
- **Objects** (`Objects.kerml`) — Defines `Object` as a structural occurrence that may change over time, with `subobjects`, `involvingPerformances`, `enactedPerformances`, `ownedPerformances`, and `BinaryLinkObject`.
- **Performances** (`Performances.kerml`) — Defines `Performance` as the most general behavioral occurrence, with `involvedObjects`, `performers`, `enclosedPerformances`, `subperformances`, and evaluation support.
- **Transfers** (`Transfers.kerml`) — Defines `Transfer`, `TransferBefore`, `SendPerformance`, `AcceptPerformance`, and `MessageTransfer` for modeling item and message flows between occurrences.
- **Metaobjects** (`Metaobjects.kerml`) — Defines `Metaobject` and `SemanticMetadata` as the basis for language extension annotations.
- **KerML** (`KerML.kerml`) — The reflective KerML model of the KerML abstract syntax, providing `Metaclass` definitions for all KerML language elements.
- **Clocks** (`Clocks.kerml`) — Defines `Clock`, `InstantOf`, and `universalClock` for temporal reference.
- **SpatialFrames** (`SpatialFrames.kerml`) — Defines `SpatialFrame` and related features for spatial reference.
- **Observation** (`Observation.kerml`) — Defines `ObservationPerformance` and related constructs.
- **ControlPerformances** (`ControlPerformances.kerml`) — Defines `MergePerformance`, `DecisionPerformance`, `IfThenPerformance`, `IfThenElsePerformance`, and `LoopPerformance` for control flow.
- **StatePerformances** (`StatePerformances.kerml`) — Defines `StatePerformance`, `InitialTransition`, and `AcceptTransition`.
- **TransitionPerformances** (`TransitionPerformances.kerml`) — Defines `TransitionPerformance` and `NonStateTransitionPerformance`.
- **FeatureReferencingPerformances** (`FeatureReferencingPerformances.kerml`) — Defines `FeatureWritePerformance` for assignment semantics.
- **Triggers** (`Triggers.kerml`) — Defines `TriggerInvocation` and related trigger types.

# Key Types

| Type | Kind | Description |
|---|---|---|
| `Anything` | abstract classifier | Root type of the language; every element is an `Anything`. |
| `DataValue` | abstract datatype | Values that do not change over time; root of all scalar and collection values. |
| `Link` / `BinaryLink` | abstract assoc | Associations between two or more things; basis for all connectors. |
| `Occurrence` | abstract class | Entities with identity that exist over time and space. |
| `Object` | abstract struct | Structural occurrences (things that persist and change). |
| `Performance` | abstract behavior | Behavioral occurrences (things that are performed). |
| `Transfer` | interaction | Transfer of a payload from one occurrence to another. |
| `Metaobject` / `SemanticMetadata` | metadata base | Foundation for all language-extension annotations. |
| `Clock` / `universalClock` | class / singleton | Time reference mechanism. |

# Usage

Import individual packages from the Kernel Semantic Library when defining new kernel-level abstractions. For typical SysML modeling, the Systems Library (which imports from the Kernel Semantic Library transitively) is sufficient.

```sysml
private import Occurrences::Occurrence;
private import Performances::Performance;
private import Transfers::Transfer;
```

When writing language extensions (metadata definitions), import `Metaobjects::SemanticMetadata`:

```sysml
private import Metaobjects::SemanticMetadata;
metadata def <myAnnotation> MyMeta :> SemanticMetadata { ... }
```

# Source

`c:\workspace\KnowledgeExtractor\Input\Sysml_2\SysML-v2-Pilot-Implementation\sysml.library\Kernel Libraries\Kernel Semantic Library\`

Key files: `Base.kerml`, `Links.kerml`, `Occurrences.kerml`, `Objects.kerml`, `Performances.kerml`, `Transfers.kerml`, `Metaobjects.kerml`, `KerML.kerml`, `Clocks.kerml`, `SpatialFrames.kerml`, `Observation.kerml`, `ControlPerformances.kerml`, `StatePerformances.kerml`, `TransitionPerformances.kerml`, `FeatureReferencingPerformances.kerml`, `Triggers.kerml`

# Related Libraries

- [Kernel Function Library](./kernel-function-library.md)
- [Kernel Data Type Library](./kernel-data-type-library.md)
- [Systems Library](./systems-library.md)

# Citations

[1] OMG SysML v2 Specification, §9
