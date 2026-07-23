---
type: SYSMOD Product
title: System Context
description: The System Context lists the external entities that interact with the system and shows how the system is embedded in its environment, including system actors, interfaces, and item flows.
timestamp: 2026-07-01T00:00:00Z
---

Product 5.11 in SYSMOD. The System Context depicts how the system is embedded in its environment, i.e., the system actors, interfaces, and communication links between the actors and the system.

# Purpose

The System Context depicts how the system is embedded in its environment, i.e., the system actors, interfaces, and communication links between the actors and the system.

# Description

A system is embedded in an environment and provides and requests functions. The System Context is a list of the external entities and the relevant item flows between the system and the entities. The entities are called system actors.

The System Context should consider at least four categories of actors: human actors, external systems, environmental effects, and the environmental impact. If relevant for the system of interest, the System Context also describes structures of the system actors and links between actors as well as interfaces.

# Relationships

**Responsibility:** [Requirements Engineer](../roles/requirements-engineer.md)

**Output of Methods:**
- [4.11 Identify the System Context](../methods/identify-system-context.md)

**Input of Methods:**
- [4.12 Identify System Use Cases](../methods/identify-system-use-cases.md)
- [4.18 Model the Logical Architecture](../methods/model-logical-architecture.md)

**Representation:**
- SysML block definition diagram and internal block diagram
- SYSMOD stereotypes «system», «systemContext», and SYSMOD stereotypes for actors

**Related Guidance:** [7.9 How to Model the System Context](../guidances/model-system-context.md)

**Related Tools:** [The Death of the Actor](../tools/death-of-actor.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 5.11.
