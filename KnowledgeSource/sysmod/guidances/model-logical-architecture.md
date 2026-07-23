---
type: SYSMOD Guidance
title: How to Model the Logical Architecture
description: A step-by-step guide for modeling the Logical Architecture in the SysML model using block definition and internal block diagrams with system and systemContext stereotypes.
timestamp: 2026-07-01T00:00:00Z
---

Guidance 7.15 in SYSMOD. This guidance describes how to model the Logical Architecture in the SysML system model.

# Context

- **SYSMOD Method:** [4.18 Model the Logical Architecture](../methods/model-logical-architecture.md)
- **SYSMOD Product:** [5.20 Logical Architecture](../products/logical-architecture.md)
- **SYSMOD Role:** [System Architect](../roles/system-architect.md)

# Description

The Logical Architecture models technical concepts and principles. Each block type in the Logical Architecture can have a sub-package structure similar to the overall system package structure.

# How to Model

1. Select the package `<system>_LogicalArchitecture`.
2. Create a SysML block definition diagram named `<system> Logical Architecture Definition`.
3. Create a SYSMOD «system» named `<system> Logical Architecture` and model a SysML Generalization relationship to the system element in the package `<system>_Core`.
4. For each identified part type of the Logical Architecture, create a SysML Block with appropriate properties, proxy ports, constraints, and operations. Use the documentation field or a linked SysML Comment for brief descriptions.
5. Create a package `<system>_Interface Types` for the types of the ports. Create the appropriate SysML InterfaceBlocks for the proxy port types.
6. Model the logical hierarchy of the system breakdown structure by creating appropriate part properties in the blocks.
7. Create a SysML internal block diagram for the root element `<system> Logical Architecture` and populate it with the part properties. Repeat for each block that owns part properties.
8. Model the connections between the part properties and ports.
9. Create a SYSMOD «systemContext» named `<system> Logical Architecture Context`. The element is a specialization of the `<system> System Context`.
10. Create a SysML internal block diagram for the Logical Architecture Context to model connections from the system actor parts specific to the Logical Architecture.

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 7.15.
