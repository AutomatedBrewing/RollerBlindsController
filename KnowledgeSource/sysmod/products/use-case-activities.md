---
type: SYSMOD Product
title: Use Case Activities
description: The Use Case Activities are specifications of the system functions represented by the System Use Cases, defining their functional decomposition, execution order, and object flows.
timestamp: 2026-07-01T00:00:00Z
---

Product 5.14 in SYSMOD. The Use Case Activities are the functional decompositions of the System Use Cases and specify the system functionality from the Requirements perspective.

# Purpose

The Use Case Activities are the functional decompositions of the System Use Cases and specify the system functionality from the Requirements perspective.

# Description

A System Use Case is only the abstract of the depicted system behavior and represents the purpose. The behavior itself is specified by a Use Case Activity.

A Use Case Activity defines the single functions of a System Use Case, their order of execution, and the flow of objects between the functions. The Use Case Activity that is directly owned by the System Use Case is the primary Use Case Activity. Further decomposed functions on lower levels are secondary Use Case Activities.

The activity tree provides a structural view of the Use Case Activities showing the hierarchy of functions—where one function calls another.

# Relationships

**Responsibility:** [Requirements Engineer](../roles/requirements-engineer.md)

**Output of Methods:**
- [4.14 Model Use Case Activities](../methods/model-use-case-activities.md)

**Input of Methods:**
- [4.15 Model the Domain Knowledge](../methods/model-domain-knowledge.md)
- [4.16 Specify Test Cases](../methods/specify-test-cases.md)
- [4.17 Model the Functional Architecture](../methods/model-functional-architecture.md)

**Representation:**
- SysML activity diagrams
- SysML block definition diagrams for activity trees with SysML adjunct properties

**Related Guidance:** [7.12 How to Model Use Case Activities](../guidances/model-use-case-activities.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 5.14.
