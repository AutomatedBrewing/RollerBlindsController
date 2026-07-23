---
type: SYSMOD Guidance
title: How to Model the System Context
description: A step-by-step guide for modeling the System Context in the SysML model using block definition and internal block diagrams with SYSMOD actor and systemContext stereotypes.
timestamp: 2026-07-01T00:00:00Z
---

Guidance 7.9 in SYSMOD. This guidance describes how to model the System Context in the SysML system model.

# Context

- **SYSMOD Method:** [4.11 Identify the System Context](../methods/identify-system-context.md)
- **SYSMOD Product:** [5.11 System Context](../products/system-context.md)
- **SYSMOD Role:** [Requirements Engineer](../roles/requirements-engineer.md)

# Description

Note that SysML does not have a system context diagram. The System Context Diagram only exists in MBSE methodologies like SYSMOD. The diagram is created as a SysML internal block diagram.

# How to Model

1. Select the package `<system>_Context`.
2. Create a SysML block definition diagram named `<system> System Context Definition`.
3. Create a SYSMOD «systemContext» named `<system> System Context`. If using strong coupling to the Base Architecture, model a generalization relationship from the System Context to the Base Architecture System Context element.
4. For each identified system actor, create a SYSMOD actor (e.g., «externalSystem»).
5. Typically, a human actor is also a Stakeholder. Apply both stereotypes «extendedStakeholder» and «user» to the model element.
6. Add the special actor `Planet Environment` from the SYSMOD Library `Engineering4Planet` as an additional mandatory actor.
7. Place the system element from the core package on the diagram.
8. Model directed composition relationships from the system context to each system actor and the system model element.
9. Check inherited properties if generalization to the Base Architecture context element exists.
10. Create a SysML internal block diagram for the system context (the System Context Diagram).
11. Place all parts on the internal block diagram and connect the actor parts with the system part.
12. If the information is important, model an item flow between the actor parts and the system part.
13. Place an item flow on the connector between the system and the actor `Planet Environment`.

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 7.9.
