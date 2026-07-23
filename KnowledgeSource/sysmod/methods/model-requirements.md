---
type: SYSMOD Method
title: Model Requirements
description: Specify the requirements in the system model, representing the contract between the stakeholders and the systems engineers who build the system.
timestamp: 2026-07-01T00:00:00Z
---

Method 4.10 in SYSMOD. The Requirements are the contract between the Systems Engineers and the Stakeholders of the system. They specify the features, non-functional properties, and constraints the system must satisfy.

# Purpose

The Requirements are the contract between the Systems Engineers and the Stakeholders of the system.

# Description

The Requirements specify the features of the system. Depending on the abstraction level covered by the system model (see Zigzag Pattern), the Requirements are stakeholder requirements or system requirements.

The Stakeholders are the source of the Requirements. Requirements arrive as documents, as an outcome of workshops, as a result of a discussion, in the form of a presentation, or as defined requirements in a proprietary requirements management tool.

Requirements in a SysML model can be the original requirements or proxies for requirements stored outside the SysML model, for example, in a requirements management tool. A Requirement can be a classical textual statement, a formal modeled requirement expression, or a mix of both.

The «extendedRequirement» model element defined in the SYSMOD Profile enables any model element to be a requirement.

# Relationships

**Primary Performer:** [Requirements Engineer](../roles/requirements-engineer.md)

**Inputs:**
- [5.8 Stakeholders](../products/stakeholders.md)
- [5.5 System Idea](../products/system-idea.md)
- [5.6 System Objectives](../products/system-objectives.md)
- [5.7 Base Architecture](../products/base-architecture.md)

**Outputs:**
- [5.10 Requirements](../products/requirements.md)

**ISO 15288 Process:** Stakeholder Needs and Requirements Definition; System Requirements Definition

**Guidance:**
- [7.8 How to Model Requirements](../guidances/model-requirements.md)

**Part of Process:**
- [SYSMOD Analysis Process](../processes/analysis-process.md)

**Related Tools:**
- [Zigzag Pattern](../tools/zigzag-pattern.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 4.10.
