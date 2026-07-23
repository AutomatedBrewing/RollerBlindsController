---
type: SysML v2 Library
title: Geometry Domain Library
description: The Geometry Domain Library provides SysML v2 definitions for geometric shape items and spatially-extended physical items that act as three-dimensional spatial frames of reference.
timestamp: 2026-07-01T00:00:00Z
---

The Geometry Domain Library is a SysML v2 domain library for modeling systems with explicit geometric and spatial properties. It builds on the Kernel Semantic Library's `SpatialFrames` package and the Quantities and Units Library's `ISQ` packages to define item types representing geometric shapes and three-dimensional spatial objects. All source files use `.sysml` syntax and reside in the `Domain Libraries/Geometry/` directory.

# Contents

- **SpatialItems** (`SpatialItems.sysml`) — Defines `SpatialItem` and related types for items with a three-dimensional spatial extent that also serve as spatial frames of reference:
  - `SpatialItem` — an `item def` specializing `SpatialFrame`; owns a `coordinateFrame : ThreeDCoordinateFrame` (defaulting to `universalCartesianSpatial3dCoordinateFrame`), an `originPoint : Point`, and a `localClock : Clock`. Asserts that the `CurrentPositionOf(originPoint, that)` is always a zero vector.
  - `RigidBody` — a `SpatialItem` whose subparts maintain fixed relative positions; includes orientation and position attributes.
  - Definitions for relative position and displacement vectors expressed in terms of `ISQ` quantity types (`Position3dVector`, `Displacement3dVector`).
- **ShapeItems** (`ShapeItems.sysml`) — Defines item types representing geometric shapes with associated size quantities:
  - `PlanarCurve` — a curve embeddable in a plane with a `length` attribute.
  - `PlanarSurface` — a flat surface with an `area` attribute.
  - `Line` — a straight `PlanarCurve` with a given `length`.
  - `Path` — a structured curve composed of connected segments.
  - `Circle` — a `PlanarCurve` defined by `radius` and `circumference`.
  - `Rectangle` — a `PlanarSurface` defined by `width` and `height`.
  - `Sphere` / `Cylinder` / `Box` — volumetric shape items with associated dimension and volume attributes.
  - `Curve` / `Surface` / `Volume` — abstract base item types for geometric shape categories.
  - `StructuredSpaceObject` — abstract item type for composable geometric structures.

# Key Types

| Type | Kind | Description |
|---|---|---|
| `SpatialItem` | item def | Item with 3D spatial extent and coordinate frame; acts as a `SpatialFrame`. |
| `RigidBody` | item def | `SpatialItem` with fixed relative geometry between subparts. |
| `PlanarCurve` | item def | Curve embeddable in a plane; has `length`. |
| `PlanarSurface` | item def | Flat surface; has `area`. |
| `Line` | item def | Straight `PlanarCurve` with a given `length`. |
| `Circle` | item def | Circular `PlanarCurve` with `radius` and `circumference`. |
| `Rectangle` | item def | Rectangular `PlanarSurface` with `width` and `height`. |
| `Sphere` | item def | Spherical volume item with `radius` and `volume`. |
| `Cylinder` | item def | Cylindrical volume item with `radius`, `height`, `volume`. |
| `Box` | item def | Rectangular box with `width`, `height`, `depth`, `volume`. |
| `Curve` | abstract item def | Abstract base for all curve shapes. |
| `Surface` | abstract item def | Abstract base for all surface shapes. |
| `Volume` | abstract item def | Abstract base for all volumetric shapes. |

# Usage

Use `SpatialItems` to model physical components with explicit geometry and spatial relationships:

```sysml
private import SpatialItems::SpatialItem;
private import ShapeItems::Sphere;

part def Sensor :> SpatialItem {
    attribute :>> coordinateFrame = ISQ::universalCartesianSpatial3dCoordinateFrame;
    item :>> shape : Sphere { attribute :>> radius = 0.05 [SI::m]; }
}
```

# Source

`c:\workspace\KnowledgeExtractor\Input\Sysml_2\SysML-v2-Pilot-Implementation\sysml.library\Domain Libraries\Geometry\`

Files: `SpatialItems.sysml`, `ShapeItems.sysml`

# Related Libraries

- [Quantities and Units Library](./quantities-units-library.md)
- [Systems Library](./systems-library.md)
- [Kernel Semantic Library](./kernel-semantic-library.md)

# Citations

[1] OMG SysML v2 Specification, §9
