---
type: SYSMOD Product
title: Requirements
description: The Requirements specify functions, non-functional properties, or constraints that must be satisfied by the system, forming the contract between stakeholders and systems engineers.
timestamp: 2026-07-01T00:00:00Z
---

Product 5.10 in SYSMOD. The Requirements are the contract between the Stakeholders of the system and the Systems engineers who build the system.

# Purpose

The Requirements are the contract between the Stakeholders of the system and the Systems engineers who build the system.

# Description

The Requirements are the list of functions, non-functional properties, and constraints that must be satisfied by the system of interest. Requirements are handled very differently by projects: from rough to very detailed requirement specifications.

Requirements in a SysML model can be the original requirements or proxies for requirements stored outside the SysML model. A Requirement can be a classical textual statement, a formal modeled requirement expression, or a mix of both. The «extendedRequirement» model element in the SYSMOD Profile enables any model element to be a requirement.

# Relationships

**Responsibility:** [Requirements Engineer](../roles/requirements-engineer.md)

**Output of Methods:**
- [4.10 Model Requirements](../methods/model-requirements.md)

**Input of Methods:**
- [4.11 Identify the System Context](../methods/identify-system-context.md)
- [4.12 Identify System Use Cases](../methods/identify-system-use-cases.md)
- [4.14 Model Use Case Activities](../methods/model-use-case-activities.md)
- [4.16 Specify Test Cases](../methods/specify-test-cases.md)
- [4.18 Model the Logical Architecture](../methods/model-logical-architecture.md)

**Representation:**
- SysML requirements diagrams, tables, and matrices
- SYSMOD stereotype «extendedRequirement» and specialized stereotypes for requirement categories

**Related Guidance:** [7.8 How to Model Requirements](../guidances/model-requirements.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 5.10.
