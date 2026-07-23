---
type: SYSMOD Product
title: Base Architecture
description: The Base Architecture is a description of the architectural and technical decisions that are preset at the project start, documenting constraints and setting the abstraction level for system requirements.
timestamp: 2026-07-01T00:00:00Z
---

Product 5.7 in SYSMOD. The Base Architecture documents architectural and technical constraints and sets the abstraction level for the system Requirements.

# Purpose

The Base Architecture documents architectural and technical constraints and sets the abstraction level for the system Requirements.

# Description

The Base Architecture represents the system architecture that is already fixed before the project starts. As a simple input for the project, it can be a sketch together with a brief textual description ("napkin architecture" or "beermat architecture").

As a more formal input, the Base Architecture is part of the system model in the form of block diagrams. The Base Architecture in the model could be strongly coupled with the Logical Architecture using the specialization relationship or loosely coupled by using the allocate relationship.

# Relationships

**Responsibility:** [System Architect](../roles/system-architect.md)

**Output of Methods:**
- [4.7 Describe the Base Architecture](../methods/describe-base-architecture.md)

**Input of Methods:**
- [4.8 Identify Stakeholders](../methods/identify-stakeholders.md)
- [4.10 Model Requirements](../methods/model-requirements.md)
- [4.18 Model the Logical Architecture](../methods/model-logical-architecture.md)
- [4.20 Revise an Architecture with Scenarios](../methods/revise-architecture-scenarios.md)

**Representation:**
- SysML block definition and internal block diagrams
- SYSMOD stereotypes for Discipline-specific Elements (mechanical, electrical, software)
- Text, sketches

**Related Guidance:** [7.5 How to Model the Base Architecture](../guidances/model-base-architecture.md)

**Related Tools:** [Zigzag Pattern](../tools/zigzag-pattern.md); [Coupling of System Architectures](../tools/coupling-system-architectures.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 5.7.
