---
type: SYSMOD Guidance
title: How to Model Stakeholders
description: A step-by-step guide for modeling stakeholders in the SysML model using SYSMOD extendedStakeholder elements in a table view.
timestamp: 2026-07-01T00:00:00Z
---

Guidance 7.6 in SYSMOD. This guidance describes how to model Stakeholders in the SysML system model.

# Context

- **SYSMOD Method:** [4.8 Identify Stakeholders](../methods/identify-stakeholders.md)
- **SYSMOD Product:** [5.8 Stakeholders](../products/stakeholders.md)
- **SYSMOD Role:** [Requirements Engineer](../roles/requirements-engineer.md)

# Description

Stakeholders are typically modeled in a table rather than a diagram, since generalization relationships between Stakeholders are not commonly used (stereotype properties are not inherited in SysML).

# How to Model

1. Select the package `Stakeholders` below the package `<system>_Requirements`.
2. Create a table named `Stakeholders`.
3. Create a SYSMOD «extendedStakeholder» for each identified Stakeholder and fill out its properties.

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 7.6.
