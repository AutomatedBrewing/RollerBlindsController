---
type: SYSMOD Method
title: Model the Domain Knowledge
description: Define the terms of the domain from the perspective of the system, specifying the semantic and structure of domain objects used by the system.
timestamp: 2026-07-01T00:00:00Z
---

Method 4.15 in SYSMOD. The Domain Knowledge defines the semantic and structure of the domain objects that are used by the system.

# Purpose

The Domain Knowledge defines the semantic and structure of the domain objects that are used by the system.

# Description

The system has knowledge about objects of the domain. For example, if you ask the system about an "operator", it knows that an operator is one of its users and has an ID, a name, and a list of active tasks.

You can derive the domain objects from the object flow of the Use Case Activities. If an object is input or output of a system function, the system must know the concept of that object. Typically, the modeled Use Case Activities and included object flows are not complete, so only parts of the Domain Knowledge can be directly derived from them.

When separating the I/O steps of the Use Case Activities, two kinds of domain objects emerge:
1. Context objects — entities exchanged between the system and system actors
2. System objects — domain objects used only inside the system

The Domain Knowledge is also known as a concept model or a data model of the system.

# Relationships

**Primary Performer:** [Requirements Engineer](../roles/requirements-engineer.md)

**Inputs:**
- [5.14 Use Case Activities](../products/use-case-activities.md)

**Outputs:**
- [5.15 Domain Knowledge](../products/domain-knowledge.md)

**ISO 15288 Process:** Stakeholder Needs and Requirements Definition; System Requirements Definition

**Guidance:**
- [7.13 How to Model the Domain Knowledge](../guidances/model-domain-knowledge.md)

**Part of Process:**
- [SYSMOD Analysis Process](../processes/analysis-process.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 4.15.
