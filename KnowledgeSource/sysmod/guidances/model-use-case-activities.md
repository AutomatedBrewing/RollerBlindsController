---
type: SYSMOD Guidance
title: How to Model Use Case Activities
description: A step-by-step guide for modeling Use Case Activities in the SysML model using activity diagrams with CallBehaviorActions, control flows, and object flows.
timestamp: 2026-07-01T00:00:00Z
---

Guidance 7.12 in SYSMOD. This guidance describes how to model Use Case Activities in the SysML system model.

# Context

- **SYSMOD Method:** [4.14 Model Use Case Activities](../methods/model-use-case-activities.md)
- **SYSMOD Product:** [5.14 Use Case Activities](../products/use-case-activities.md)
- **SYSMOD Role:** [Requirements Engineer](../roles/requirements-engineer.md)

# Description

Use Case Activities and Domain Knowledge cannot be performed in a strict order—they are mutually dependent. The activity for each Use Case step is modeled with CallBehaviorActions.

# How to Model

For each System Use Case:

1. Select a System Use Case.
2. Create a SysML Activity with an activity diagram that is owned by the System Use Case.
3. If the System Use Case description defines pre- and postconditions, define appropriate conditions for the activity.
4. Model the steps of the Use Case Activity with CallBehaviorActions. Create an activity for each action if it does not already exist in the model or a model library.
5. It is good practice to separate steps responsible for input and output functionality from the other steps. Use SysML activity partitions to separate I/O related steps.
6. Model the control flows between the use case steps, including decision, fork, merge, join, and other control nodes.
7. Model the object flow. The types of input and output pins are domain blocks from the Domain Knowledge.
8. Use the documentation field of the model elements or a linked SysML Comment to add brief textual descriptions for each called activity and non-obvious guards of decision nodes.

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 7.12.
