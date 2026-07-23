---
type: SYSMOD Guidance
title: How to Model the Base Architecture
description: A step-by-step guide for modeling the Base Architecture in the SysML model using block definition and internal block diagrams with SYSMOD system stereotypes.
timestamp: 2026-07-01T00:00:00Z
---

Guidance 7.5 in SYSMOD. This guidance describes how to model the Base Architecture in the SysML system model.

# Context

- **SYSMOD Method:** [4.7 Describe the Base Architecture](../methods/describe-base-architecture.md)
- **SYSMOD Product:** [5.7 Base Architecture](../products/base-architecture.md)
- **SYSMOD Role:** [System Architect](../roles/system-architect.md)

# Description

The Base Architecture can be described textually using the `systemIdea` property of the SYSMOD stereotype «system», or modeled formally as block definition and internal block diagrams.

# How to Model

1. Select the package `<system>_BaseArchitecture`.
2. Create a SysML block definition diagram named `<system> Base Architecture Definition`.
3. If describing the Base Architecture textually, use the property `systemIdea` of the SYSMOD stereotype «system» applied to the Base Architecture element, or reference external sketches.
4. Create a SysML Block with appropriate features for every part of the Base Architecture. Use the documentation field or a linked SysML Comment for brief textual descriptions.
5. Create part properties and connect the parts in a SysML internal block diagram.
6. Typically, the context of the system is also relevant to the Base Architecture. In that case, create a SYSMOD «systemContext» named `<system> Base Architecture Context`. The Base Architecture system element is part of the context as well as the actors.
7. The Base Architecture can also be a kind of constraint requirement.

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 7.5.
