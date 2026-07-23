---
type: SYSMOD Tool
title: Functional Architectures for Systems (FAS)
description: The FAS method derives a technology-independent Functional Architecture from Use Case Activities by grouping system functions based on functional cohesion, providing a bridge between functional requirements and physical architectures.
timestamp: 2026-07-01T00:00:00Z
---

Tool 11.2 in SYSMOD. The Functional Architecture provides the bridge between the functional requirements and Physical Architectures, supporting the derivation of the right system implementation.

# Purpose

The FAS method provides a bridge between functional requirements and Physical Architectures and supports the process to derive the right implementation of system functions by a capable Physical Architecture.

# Description

Functions are the essential core of a system. The Requirements Engineer has a focus on system functions as functional requirements from the viewpoint of users and Stakeholders. The System Architect has a focus on technical components and their specific technical functions.

The FAS method describes how to derive a Functional Architecture from Use Case Activities. The System Architect derives a new grouping of the Use Case Activities based on the criterion of functional cohesion—functions that do similar things are members of the same functional group. The FAS method provides heuristics for the grouping.

In SysML, a group of functions in the architecture is modeled by a functional block. The groups are connected if functions in one group deliver outputs that are input of functions in another group. The elements of the Functional Architecture are then allocated to a Physical Architecture via the SysML allocate relationship.

The FAS method is independent of SYSMOD but is a perfect supplement. SYSMOD Products are inputs of the FAS method, and the Functional Architecture is helpful to derive a Physical Architecture. The FAS method was first presented in 2010 and is documented in the book Model-Based System Architectures [We15].

# Relationships

**Related Products:**
- [5.14 Use Case Activities](../products/use-case-activities.md) — input to FAS
- [5.18 Functional Architecture](../products/functional-architecture.md) — output of FAS
- [5.20 Logical Architecture](../products/logical-architecture.md) — uses Functional Architecture

**Related Methods:**
- [4.17 Model the Functional Architecture](../methods/model-functional-architecture.md)

**Related Processes:**
- [SYSMOD Architecture Process](../processes/architecture-process.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 11.2. Also: Weilkiens, T. Model-Based System Architectures. Wiley, 2015.
