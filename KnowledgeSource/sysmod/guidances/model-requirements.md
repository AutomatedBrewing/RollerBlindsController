---
type: SYSMOD Guidance
title: How to Model Requirements
description: A step-by-step guide for modeling requirements in the SysML model using SYSMOD requirement stereotypes, tables, and optional coverage of base architecture constraints.
timestamp: 2026-07-01T00:00:00Z
---

Guidance 7.8 in SYSMOD. This guidance describes how to model Requirements in the SysML system model.

# Context

- **SYSMOD Method:** [4.10 Model Requirements](../methods/model-requirements.md)
- **SYSMOD Product:** [5.10 Requirements](../products/requirements.md)
- **SYSMOD Role:** [Requirements Engineer](../roles/requirements-engineer.md)

# Description

Each Requirement is documented in a table to store the information in a uniform structured format. Requirements can be textual statements or model-based. A Use Case Activity can also be a «functionalRequirement».

# How to Model

1. Select the package `<system>_Requirements`.
2. Create a table to depict the Requirements.
3. For each identified Requirement, create an appropriate SYSMOD requirement element (e.g., «performanceRequirement») and fill out its properties. A Use Case Activity can also be a «functionalRequirement».
4. Typically, you have so many Requirements that you need more structure in the model. Create packages and requirements containment hierarchies as necessary.
5. If you want to cover the Base Architecture with a Requirement, create a constraint requirement named `Base Architecture` and model a refine relationship from the Base Architecture element to the constraint Requirement.

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 7.8.
