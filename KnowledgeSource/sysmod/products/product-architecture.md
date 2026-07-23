---
type: SYSMOD Product
title: Product Architecture
description: The Product Architecture specifies the concrete physical architecture of the system of interest as the most detailed system architecture specification in the system model.
timestamp: 2026-07-01T00:00:00Z
---

Product 5.21 in SYSMOD. The Product Architecture is the most detailed System Architecture specification of the system in the system model.

# Purpose

The Product Architecture is the most detailed System Architecture specification of the system in the system model.

# Description

The Product Architecture is a concretization of the Logical Architecture—of architectural and technical concepts and principles—and is the lowest level of abstraction of an architecture described in the system model.

The next level of detail below the Product Architecture is part of specific engineering models (software model, CAD model) and is out of scope for the system model.

The Product Architecture can be strongly coupled to a Logical Architecture using the generalization relationship or loosely coupled using the allocate relationship.

# Relationships

**Responsibility:** [System Architect](../roles/system-architect.md)

**Output of Methods:**
- [4.19 Model the Product Architecture](../methods/model-product-architecture.md)

**Input of Methods:**
- [4.20 Revise an Architecture with Scenarios](../methods/revise-architecture-scenarios.md)

**Representation:**
- SysML block definition and internal block diagrams
- SYSMOD stereotypes for Discipline-specific Elements (mechanical, electrical, software)

**Related Guidance:** [7.16 How to Model the Product Architecture](../guidances/model-product-architecture.md)

**Related Tools:** [Coupling of System Architectures](../tools/coupling-system-architectures.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 5.21.
