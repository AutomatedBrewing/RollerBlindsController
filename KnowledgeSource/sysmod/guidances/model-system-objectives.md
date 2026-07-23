---
type: SYSMOD Guidance
title: How to Model the System Objectives
description: A step-by-step guide for modeling the System Objectives in the SysML model using SYSMOD objective elements and relating them to stakeholders.
timestamp: 2026-07-01T00:00:00Z
---

Guidance 7.4 in SYSMOD. This guidance describes how to model the System Objectives in the SysML system model.

# Context

- **SYSMOD Method:** [4.6 Describe the System Idea and System Objectives](../methods/describe-system-idea-objectives.md)
- **SYSMOD Product:** [5.6 System Objectives](../products/system-objectives.md)
- **SYSMOD Role:** [Project Manager](../roles/project-manager.md)

# Description

Like for the System Idea, workshop tools (Product Box, Product Vision Board, SAMS method) can be used to elaborate the System Objectives. There are two types of System Objectives: system-related (prefix OBJ-S) and organization-related (prefix OBJ-O).

System Objectives are stored as SYSMOD «objective» elements in the model and traced to their source Stakeholders.

# How to Model

1. Select the package `Objectives`.
2. Create a table named `System Objectives` configured to depict objectives with id, name, text, and the related Stakeholder.
3. Create a SYSMOD «objective» as the root element for all System Objectives. The text value is "Objectives of the system `<name of the system>`".
4. Create one SYSMOD «objective» for each identified System Objective. The text value is the documentation of the objective.
5. Create a containment relationship from the root element to all other System Objectives.
6. If the Stakeholder of the System Objective is not part of the model, create them as described in guidance 7.6. Create a trace relationship from each System Objective to the Stakeholder who is the source of the objective.

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 7.4.
