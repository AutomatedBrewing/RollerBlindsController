---
type: SYSMOD Product
title: Functional Architecture
description: The Functional Architecture consists of functional elements, functional interfaces, flows, and architecture decisions, providing a technology-independent functional description of the system.
timestamp: 2026-07-01T00:00:00Z
---

Product 5.18 in SYSMOD. The Functional Architecture strengthens the functional aspect and is a technology-independent functional description of the system.

# Purpose

The Functional Architecture strengthens the functional aspect and is a technology-independent functional description of the system.

# Description

The functional elements transform input flows into output flows. The functional interfaces are attached to the functional elements and specify the allowed input and output flows. Connectors between the functional elements specify the flow paths.

The Functional Architecture is derived from functional requirements, for example, from the Use Case Activities with the FAS method. It is independent of the technical components of the Logical and Product Architecture, but depends on the technical components of the Base Architecture.

The Functional Architecture is not a core product of SYSMOD. It can be derived from SYSMOD Products using the FAS method and can be a valuable input to elaborate a Physical Architecture.

# Relationships

**Responsibility:** [System Architect](../roles/system-architect.md)

**Output of Methods:**
- [4.17 Model the Functional Architecture](../methods/model-functional-architecture.md)

**Input of Methods:**
- [4.18 Model the Logical Architecture](../methods/model-logical-architecture.md)

**Representation:**
- SysML block definition and internal block diagrams
- FAS stereotypes from the FAS method

**Related Tools:** [Functional Architectures for Systems (FAS)](../tools/functional-architectures-for-systems.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 5.18; Section 11.2.
