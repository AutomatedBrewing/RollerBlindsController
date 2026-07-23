---
type: SYSMOD Guidance
title: How to Model the Domain Knowledge
description: A step-by-step guide for modeling domain knowledge in the SysML model using SYSMOD domainBlock elements in block definition diagrams with value types and units.
timestamp: 2026-07-01T00:00:00Z
---

Guidance 7.13 in SYSMOD. This guidance describes how to model the Domain Knowledge in the SysML system model.

# Context

- **SYSMOD Method:** [4.15 Model the Domain Knowledge](../methods/model-domain-knowledge.md)
- **SYSMOD Product:** [5.15 Domain Knowledge](../products/domain-knowledge.md)
- **SYSMOD Role:** [Requirements Engineer](../roles/requirements-engineer.md)

# Description

Domain blocks represent the domain objects. The definition requires, typically, value types and units. Context domain blocks are entities exchanged between the system and system actors; system domain blocks are used only inside the system.

# How to Model

1. Select the package `<system>_Context Domain`.
2. Create a SysML block definition diagram named `<system> Context Domain Knowledge`.
3. For each identified context domain block, create a SYSMOD «domainBlock». Specify the properties of the block and associations to other domain blocks.
4. Use the documentation field of the domain block and its properties or linked SysML Comments to add brief textual descriptions.
5. Repeat steps 1–4 for the system domain blocks.

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 7.13.
