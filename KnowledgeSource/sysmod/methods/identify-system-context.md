---
type: SYSMOD Method
title: Identify the System Context
description: Identify all users and other external entities that interact with the system, defining the system boundary, interfaces, and relevant item flows.
timestamp: 2026-07-01T00:00:00Z
---

Method 4.11 in SYSMOD. The System Context defines the environment of the system that needs to be considered, the system boundary, and the interfaces of the system.

# Purpose

The System Context defines the environment of the system that needs to be considered, the system boundary, and the interfaces of the system.

# Description

The System Context depicts all elements from the environment of the system that interact with it. These elements are called system actors. The obvious ones are the users of the system and external systems with communication interfaces. Less obvious system actors—but equally important—are environmental effects like temperature or mechanical systems like the installation surface.

A special external entity is the Planet Environment. A Systems Engineer must consider the impact of the system of interest on the planet. The actor Planet Environment is an element in the SYSMOD Model Library with the actor category EnvironmentalImpact.

Besides the list of system actors, the System Context describes system interfaces and relevant flows of items between the system actors and the system.

Human actors and the humans or organizations behind non-human actors are also Stakeholders. An actor always interacts directly with the system; Stakeholders that do not directly interact are not part of the actor list.

The System Architecture methods later refine the System Context and add architecture-specific elements like interfaces.

# Relationships

**Primary Performer:** [Requirements Engineer](../roles/requirements-engineer.md)

**Inputs:**
- [5.10 Requirements](../products/requirements.md)

**Outputs:**
- [5.11 System Context](../products/system-context.md)

**ISO 15288 Process:** Business Mission Analysis; Stakeholder Needs and Requirements Definition; Architecture Definition

**Guidance:**
- [7.9 How to Model the System Context](../guidances/model-system-context.md)

**Part of Process:**
- [SYSMOD Analysis Process](../processes/analysis-process.md)

**Related Tools:**
- [The Death of the Actor](../tools/death-of-actor.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 4.11.
