---
type: SYSMOD Guidance
title: How to Set up an Initial Package Structure
description: A step-by-step guide for creating the initial SysML model package structure that organizes system modeling aspects and scales to models of any size.
timestamp: 2026-07-01T00:00:00Z
---

Guidance 7.1 in SYSMOD. This guidance describes how to create the initial package structure of a SysML model using the SYSMOD-recommended approach.

# Context

- **SYSMOD Method:** [4.2 Set up and Maintain the SME](../methods/set-up-maintain-sme.md)
- **SYSMOD Product:** [5.2 System Modeling Environment (SME)](../products/system-modeling-environment.md)
- **SYSMOD Role:** [SME Administrator](../roles/sme-administrator.md)

# Description

A SysML model has many orthogonal aspects and abstraction layers that can be mapped into the package structure—domain concepts, methods, organizational aspects. Mixing those aspects leads to confusion.

The SYSMOD proposed package structure is based on the MBSE Cookbook from the MBSE Challenge Team SE² for Telescope Modeling. The root package represents the complete system model. On the next level, different modeling aspects are separated: system context, requirements, structure, etc. The prefix of each package reflects the enclosing namespace to avoid naming conflicts.

The architecture packages contain the architectural elements of the system. Each element with a detailed description has its own package on the next level with the same package structure inside. This makes the structure straightforward and scalable—it works for models of any size.

# How to Model

1. Make sure that the model is empty and that there are no predefined package structures.
2. Create a SysML model element `Model` with the name of your system.
3. Inside the model element, create the three top-level packages for the core, configurations, and variations, as well as some auxiliary packages for issues, notes, or other things not directly part of the system model.
4. Inside the core package, create the top-level packages for the SYSMOD Products like context or requirements.
5. Create a SYSMOD «system» element with name `<system> Base Architecture` in the package `<system>_BaseArchitecture`.
6. Create an abstract SYSMOD «system» element with the name of your system in the core package. If you want strong coupling to the Base Architecture, model a generalization relationship to the system element of the Base Architecture.

It is helpful to create a template for system models that already provides an initial package structure, including special diagrams, tables, or model element structures commonly used in your projects.

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 7.1.
