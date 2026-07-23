---
type: SYSMOD Product
title: Logical Architecture
description: The Logical Architecture specifies the architectural and technical concepts and principles of the system on a high abstraction level, covering the essential technical notion reusable across product families.
timestamp: 2026-07-01T00:00:00Z
---

Product 5.20 in SYSMOD. The Logical Architecture covers the essential technical notion of the system and is reusable for similar systems like product families or generations.

# Purpose

The Logical Architecture covers the essential technical notion of the system and is reusable for similar systems like product families or generations.

# Description

The Logical Architecture is more abstract than a Product Architecture. The elements specify general technical concepts like a motor or a control unit.

If strongly coupled with a Base Architecture, the root element of the Logical Architecture specializes elements of the Base Architecture. If loosely coupled with the Base Architecture, elements of the Logical Architecture have allocate-relationships from elements of the Base Architecture.

# Relationships

**Responsibility:** [System Architect](../roles/system-architect.md)

**Output of Methods:**
- [4.18 Model the Logical Architecture](../methods/model-logical-architecture.md)

**Input of Methods:**
- [4.19 Model the Product Architecture](../methods/model-product-architecture.md)
- [4.20 Revise an Architecture with Scenarios](../methods/revise-architecture-scenarios.md)

**Representation:**
- SysML block definition and internal block diagrams
- SYSMOD stereotypes for Discipline-specific Elements (mechanical, electrical, software)

**Related Guidance:** [7.15 How to Model the Logical Architecture](../guidances/model-logical-architecture.md)

**Related Tools:** [Coupling of System Architectures](../tools/coupling-system-architectures.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 5.20.
