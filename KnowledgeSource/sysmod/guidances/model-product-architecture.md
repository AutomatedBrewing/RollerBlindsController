---
type: SYSMOD Guidance
title: How to Model the Product Architecture
description: A step-by-step guide for modeling the Product Architecture in the SysML model, similar to the Logical Architecture but with concrete specialization of architectural elements.
timestamp: 2026-07-01T00:00:00Z
---

Guidance 7.16 in SYSMOD. This guidance describes how to model the Product Architecture in the SysML system model.

# Context

- **SYSMOD Method:** [4.19 Model the Product Architecture](../methods/model-product-architecture.md)
- **SYSMOD Product:** [5.21 Product Architecture](../products/product-architecture.md)
- **SYSMOD Role:** [System Architect](../roles/system-architect.md)

# Description

The modeling of the Product Architecture is similar to the Logical Architecture. If the Product Architecture should be strongly coupled with the Logical Architecture, the root element of the Product Architecture is a specialization of the Logical Architecture root element.

Note that it is not mandatory to strictly separate the concepts of the Logical Architecture and the Product Architecture in the system model. Only spend the effort if you benefit from the value. If you do not separate the architectures, model only one architecture and call it Physical or Product Architecture.

# How to Model

The steps are similar to guidance 7.15 (How to Model the Logical Architecture), with the following difference:

- If using strong coupling with the Logical Architecture, the root element of the Product Architecture specializes the Logical Architecture root element rather than the core system element.

See [7.15 How to Model the Logical Architecture](../guidances/model-logical-architecture.md) for the detailed steps.

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 7.16.
