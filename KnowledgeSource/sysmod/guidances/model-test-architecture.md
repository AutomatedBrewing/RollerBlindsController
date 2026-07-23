---
type: SYSMOD Guidance
title: How to Model the Test Architecture
description: A step-by-step guide for modeling the Test Architecture in the SysML model using block definition and internal block diagrams with SYSMOD system stereotypes and test context.
timestamp: 2026-07-01T00:00:00Z
---

Guidance 7.19 in SYSMOD. This guidance describes how to model the Test Architecture in the SysML system model.

# Context

- **SYSMOD Method:** [4.22 Model the Test Architecture](../methods/model-test-architecture.md)
- **SYSMOD Product:** [5.24 Test Architecture](../products/test-architecture.md)
- **SYSMOD Role:** [System Tester](../roles/system-tester.md)

# Description

The Test Architecture modeling is similar to the Logical Architecture. The test context includes the system under test as well as all test system actors.

# How to Model

1. Select the package `<system>_TestArchitecture`.
2. Create a SysML block definition diagram named `<system> Test Architecture Definition`.
3. Create a SYSMOD «system» named `<system> Test Architecture`.
4. For each identified part type of the Test Architecture, create a SysML Block with appropriate properties, proxy ports, constraints, and operations. Use the documentation field or a linked SysML Comment for brief descriptions.
5. Create a package `<system>_Interface Types` for the types of the ports. Create appropriate SysML InterfaceBlocks for the proxy port types.
6. Model the logical hierarchy of the test system breakdown structure by creating appropriate part properties in the blocks.
7. Create a SysML internal block diagram for the root element `<system> Test Architecture` and populate it with the part properties. Repeat for each block that owns part properties.
8. Model the connections between the part properties and ports.
9. Create a SYSMOD «systemContext» named `<system> Test Architecture Context`.
10. Create a SysML internal block diagram for the Test Architecture Context and model the connectors to the actors.

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 7.19.
