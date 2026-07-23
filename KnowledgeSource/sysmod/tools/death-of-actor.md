---
type: SYSMOD Tool
title: The Death of the Actor
description: An MBSE pattern recommending the use of SysML Block instead of the SysML Actor model element to represent system actors, enabling internal structure modeling, port specification, and flexible viewpoint changes.
timestamp: 2026-07-01T00:00:00Z
---

Tool 11.1 in SYSMOD. This pattern recommends not using the SysML model element Actor. Instead, the SYSMOD stereotypes for actors are specializations of the SysML Block model element.

# Purpose

Using SysML Block instead of SysML Actor for actors provides greater modeling flexibility and enables internal structure specification.

# Description

There are several good reasons to use the SysML Block to model an actor:

- You can switch the role of the external entity by also applying a stereotype «system» or «subsystem» without creating multiple model elements.
- You can model the internal structure of the actor, for example, to specify in detail how it is connected with the system of interest.
- You can model ports to specify the interfaces of the actors that are connected with the system of interest.

The term System is relative and depends on the viewpoint. From one viewpoint, an entity is a system; from other viewpoints, it is a subsystem or an external system. You lose the flexibility of changing the viewpoint if you model an actor with the SysML element Actor—by definition, the Actor model element represents an external entity and cannot be a system in another viewpoint.

Additionally, a SysML Actor is a black-box element: it is not allowed to model the internal structure or define ports on an Actor model element.

Therefore, the SYSMOD stereotypes for actors are specializations of the SysML Block model element. A SYSMOD system context diagram with Block-based actors looks almost the same as with Actor-based actors, with the added benefit of ports and internal structure.

# Relationships

**Related Products:**
- [5.11 System Context](../products/system-context.md)

**Related Methods:**
- [4.11 Identify the System Context](../methods/identify-system-context.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 11.1.
