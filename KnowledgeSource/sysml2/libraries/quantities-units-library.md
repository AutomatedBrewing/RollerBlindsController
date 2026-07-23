---
type: SysML v2 Library
title: Quantities and Units Library
description: The Quantities and Units Library provides SysML v2 definitions for physical quantities, measurement references, SI units, ISQ quantity kinds, and common unit systems aligned with ISO 80000 standards.
timestamp: 2026-07-01T00:00:00Z
---

The Quantities and Units Library is the most comprehensive domain library in the SysML v2 standard library set. It defines the complete framework for expressing typed physical quantities (scalar, vector, tensor), associating them with measurement references (units, coordinate frames, scales), and providing the full International System of Quantities (ISQ) and SI unit definitions derived from ISO/IEC 80000. It also includes US Customary unit definitions and support for quantity calculations. All source files use `.sysml` syntax and reside in the `Domain Libraries/Quantities and Units/` directory.

# Contents

**Core quantity and measurement framework:**
- **Quantities** (`Quantities.sysml`) — Defines the root abstract types for quantity values: `TensorQuantityValue`, `VectorQuantityValue`, `ScalarQuantityValue`, and the root features `tensorQuantities`, `vectorQuantities`, `scalarQuantities`, plus `3dVectorQuantityValue`.
- **MeasurementReferences** (`MeasurementReferences.sysml`) — Defines measurement reference types: `MeasurementReference`, `ScalarMeasurementReference`, `VectorMeasurementReference`, `TensorMeasurementReference`, `Unit`, `SimpleUnit`, `DerivedUnit`, `PrefixedUnit`, `CoordinateFrame`, `ThreeDCoordinateFrame`, `Scale`, and coordinate transformation types.
- **MeasurementRefCalculations** (`MeasurementRefCalculations.sysml`) — Defines calculation functions for converting between measurement references (unit conversions, scale changes).

**ISQ quantity kinds (from ISO/IEC 80000):**
- **ISQBase** (`ISQBase.sysml`) — Seven base quantities: `LengthValue`/`LengthUnit`, `DurationValue`/`DurationUnit`, `MassValue`/`MassUnit`, `ElectricCurrentValue`/`ElectricCurrentUnit`, `ThermodynamicTemperatureValue`, `AmountOfSubstanceValue`, `LuminousIntensityValue`, and their root features.
- **ISQ** (`ISQ.sysml`) — Top-level ISQ package aggregating all ISQ sub-packages, defining the `isq` singleton and `universalCartesianSpatial3dCoordinateFrame`.
- **ISQSpaceTime** (`ISQSpaceTime.sysml`) — Space and time quantities: area, volume, speed, acceleration, angular quantities.
- **ISQMechanics** (`ISQMechanics.sysml`) — Mechanical quantities: force, energy, power, pressure, momentum, torque, density.
- **ISQThermodynamics** (`ISQThermodynamics.sysml`) — Thermodynamic quantities: heat, entropy, heat capacity, thermal conductivity.
- **ISQElectromagnetism** (`ISQElectromagnetism.sysml`) — Electromagnetic quantities: voltage, resistance, capacitance, inductance, magnetic flux.
- **ISQLight** (`ISQLight.sysml`) — Photometric and radiometric quantities: luminous flux, illuminance, radiance.
- **ISQAcoustics** (`ISQAcoustics.sysml`) — Acoustic quantities: sound pressure, sound power level.
- **ISQChemistryMolecular** (`ISQChemistryMolecular.sysml`) — Chemistry and molecular quantities: concentration, molar mass.
- **ISQCondensedMatter** (`ISQCondensedMatter.sysml`) — Condensed matter quantities: permeability, permittivity.
- **ISQAtomicNuclear** (`ISQAtomicNuclear.sysml`) — Atomic and nuclear quantities: activity, absorbed dose.
- **ISQInformation** (`ISQInformation.sysml`) — Information-theoretic quantities: bit, byte, entropy.
- **ISQCharacteristicNumbers** (`ISQCharacteristicNumbers.sysml`) — Dimensionless characteristic numbers (Reynolds number, Mach number, etc.).

**SI units:**
- **SI** (`SI.sysml`) — All SI base units (`m`, `kg`, `s`, `A`, `K`, `mol`, `cd`) and coherent derived SI units, as `attribute def` instances of `SimpleUnit` or `DerivedUnit`.
- **SIPrefixes** (`SIPrefixes.sysml`) — SI prefix definitions (`kilo`, `mega`, `milli`, `micro`, etc.) as `PrefixedUnit` multipliers.

**Additional unit systems and calculations:**
- **Time** (`Time.sysml`) — Extends the time quantity with calendar units (`min`, `h`, `day`) and a `Clock` / `TimeInstantValue` model.
- **USCustomaryUnits** (`USCustomaryUnits.sysml`) — US customary units: `ft`, `in`, `mi`, `lb`, `°F`, `gal`, etc.
- **VectorCalculations** (`VectorCalculations.sysml`) — Vector quantity arithmetic and coordinate transformation calculations.
- **TensorCalculations** (`TensorCalculations.sysml`) — Tensor contraction and transformation calculations.
- **QuantityCalculations** (`QuantityCalculations.sysml`) — General arithmetic over `ScalarQuantityValue` and `VectorQuantityValue` values.

# Key Types

| Type | Kind | Description |
|---|---|---|
| `ScalarQuantityValue` | abstract attribute def | Root of all typed scalar physical quantity values. |
| `VectorQuantityValue` | abstract attribute def | Root of all typed vector physical quantity values. |
| `TensorQuantityValue` | abstract attribute def | Root of all typed tensor physical quantity values. |
| `SimpleUnit` | attribute def | A base measurement unit. |
| `DerivedUnit` | attribute def | A unit derived from other units via `QuantityPowerFactor`. |
| `PrefixedUnit` | attribute def | A unit with an SI prefix applied. |
| `ThreeDCoordinateFrame` | attribute def | A three-dimensional spatial coordinate frame. |
| `LengthValue` | attribute def | Scalar value for length (ISO 80000-3, dimension L). |
| `MassValue` | attribute def | Scalar value for mass (ISO 80000-4, dimension M). |
| `DurationValue` | attribute def | Scalar value for time/duration (ISO 80000-3, dimension T). |
| `ForceValue` | attribute def | Scalar value for force (ISO 80000-4, dimension M·L·T⁻²). |
| `EnergyValue` | attribute def | Scalar value for energy (ISO 80000-4, dimension M·L²·T⁻²). |
| `m` / `kg` / `s` | attribute | SI base unit instances (metre, kilogram, second). |
| `Position3dVector` | attribute def | 3D position vector quantity. |
| `Displacement3dVector` | attribute def | 3D displacement vector quantity. |

# Usage

Use quantity types as `attribute` feature types in part and item definitions:

```sysml
private import ISQBase::LengthValue;
private import ISQMechanics::MassValue;
private import SI::m;
private import SI::kg;

part def Beam {
    attribute length : LengthValue = 5.0 [m];
    attribute mass   : MassValue   = 12.5 [kg];
}
```

Apply SI prefixes via `SIPrefixes`:

```sysml
private import SIPrefixes::kilo;
private import SI::m;

attribute distance : LengthValue = 3.0 [kilo * m];  // 3 km
```

# Source

`c:\workspace\KnowledgeExtractor\Input\Sysml_2\SysML-v2-Pilot-Implementation\sysml.library\Domain Libraries\Quantities and Units\`

Key files: `Quantities.sysml`, `MeasurementReferences.sysml`, `ISQBase.sysml`, `ISQ.sysml`, `ISQSpaceTime.sysml`, `ISQMechanics.sysml`, `ISQElectromagnetism.sysml`, `ISQThermodynamics.sysml`, `SI.sysml`, `SIPrefixes.sysml`, `Time.sysml`, `USCustomaryUnits.sysml`, `VectorCalculations.sysml`, `QuantityCalculations.sysml`, `MeasurementRefCalculations.sysml`, `TensorCalculations.sysml`

# Related Libraries

- [Kernel Data Type Library](./kernel-data-type-library.md)
- [Kernel Function Library](./kernel-function-library.md)
- [Geometry Domain Library](./geometry-domain-library.md)
- [Analysis Domain Library](./analysis-domain-library.md)
- [Systems Library](./systems-library.md)

# Citations

[1] OMG SysML v2 Specification, §9
