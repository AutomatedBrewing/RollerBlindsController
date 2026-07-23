---
type: SYSMOD Guidance
title: How to Model the System Idea
description: A step-by-step guide for modeling the System Idea in the SysML model using the systemIdea property of the SYSMOD system stereotype.
timestamp: 2026-07-01T00:00:00Z
---

Guidance 7.3 in SYSMOD. This guidance describes how to model the System Idea in the SysML system model.

# Context

- **SYSMOD Method:** [4.6 Describe the System Idea and System Objectives](../methods/describe-system-idea-objectives.md)
- **SYSMOD Product:** [5.5 System Idea](../products/system-idea.md)
- **SYSMOD Role:** [Project Manager](../roles/project-manager.md)

# Description

Helpful and effective tools to collect information about the System Idea are the Product Box, the Product Vision Board, and the SAMS method. The System Idea is stored in the model as a property of the SYSMOD stereotype «system».

# How to Model

1. Select the system element in the root package of the core.
2. The SYSMOD stereotype «system» has a property `systemIdea` to store the System Idea. If the System Idea is more than text (e.g., includes graphics), put a reference to the external source in the model.

The model diagram also shows the strong-coupling approach to connect the Base Architecture by a generalization relationship.

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 7.3.
