---
type: SYSMOD Tool
title: Proxy versus Full Port
description: A SysML modeling pattern recommending the exclusive use of proxy ports over full ports for specifying block interfaces, simplifying models and ensuring consistent part property representation.
timestamp: 2026-07-01T00:00:00Z
---

Tool 11.4 in SYSMOD. SysML provides two different port concepts: the full port and the proxy port. This pattern recommends using only proxy ports.

# Purpose

Using only proxy ports over full ports simplifies the model by ensuring all parts of the system are modeled the same way by part properties.

# Description

A SysML FullPort represents a real entity of the system—it is part of the bill of material (BOM) and specifies behavior and internal structures. The type of a full port is typically a SysML Block.

A proxy port does not directly represent a real-world entity but is a proxy defining an interaction point. In the model, the proxy port is connected by a SysML BindingConnector with the model element that represents the real-world entity.

The recommendation is to use only proxy ports and ignore the concept of full ports. In that case, all parts of the system are modeled the same way by part properties. If every port in the model is a proxy port, you can discard the stereotype notation «proxy», which makes the diagrams less cluttered.

The proxy port and the appropriate internal part are connected with a binding connector that assures that the instances of the proxy port and the part have the same value, i.e., they represent the same thing.

# Relationships

**Related Methods:**
- [4.18 Model the Logical Architecture](../methods/model-logical-architecture.md)
- [4.19 Model the Product Architecture](../methods/model-product-architecture.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 11.4.
