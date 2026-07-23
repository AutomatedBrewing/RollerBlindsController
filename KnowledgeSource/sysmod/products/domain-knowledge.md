---
type: SYSMOD Product
title: Domain Knowledge
description: The Domain Knowledge is a specification of the domain objects used by the Use Case Activities, Requirements, and System Architectures, defining the data and physical entities known by the system.
timestamp: 2026-07-01T00:00:00Z
---

Product 5.15 in SYSMOD. The Domain Knowledge specifies the data, physical entities, related value types, and units that are used ("known") by the system.

# Purpose

The Domain Knowledge specifies the data, physical entities, related value types, and units that are used ("known") by the system.

# Description

The object flows of the Use Case Activities define the usage of domain objects by the system. The objects are data or physical entities. They are the inputs and outputs of system functions.

The domain objects are specified by domain blocks. The definition of a domain block requires, typically, value types and units. Both are also part of the Domain Knowledge.

The Domain Knowledge is also known as a concept model or a data model of the system.

# Relationships

**Responsibility:** [Requirements Engineer](../roles/requirements-engineer.md)

**Output of Methods:**
- [4.15 Model the Domain Knowledge](../methods/model-domain-knowledge.md)

**Input of Methods:** None

**Representation:**
- SysML block definition diagrams with SYSMOD «domainBlock»
- SysML ValueTypes and Units

**Related Guidance:** [7.13 How to Model the Domain Knowledge](../guidances/model-domain-knowledge.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 5.15.
