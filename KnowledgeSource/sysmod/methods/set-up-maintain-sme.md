---
type: SYSMOD Method
title: Set up and Maintain the SME
description: Configure the modeling tools and create a System Modeling Environment (SME) for the project or organization.
timestamp: 2026-07-01T00:00:00Z
---

Method 4.2 in SYSMOD. The core of the SME is a SysML modeling tool. This method covers the configuration and customization of the modeling tool and related toolchain to support the tailored MBSE Methodology.

# Purpose

Provide a suitable SME to perform the tailored MBSE Methodology.

# Description

Out-of-the-box, a SysML modeling tool provides the whole set of SysML model elements and some extensions defined by the tool vendor. It is necessary to enable methodology-specific extensions to use a SysML modeling tool for a tailored MBSE Methodology.

Additionally, you should remove superfluous model elements from the toolbox and add convenience functions for a better user experience. If required, model libraries must be made accessible, and toolchains to other tools (requirements management, simulation) must be established.

Besides the SysML tool, other tools are typically part of the SME. They must also be customized.

# Relationships

**Primary Performer:** [SME Administrator](../roles/sme-administrator.md)

**Inputs:**
- [5.1 MBSE Methodology](../products/mbse-methodology.md)

**Outputs:**
- [5.2 System Modeling Environment (SME)](../products/system-modeling-environment.md)

**ISO 15288 Process:** Infrastructure Management

**Guidance:**
- [7.1 How to Set up an Initial Package Structure](../guidances/setup-package-structure.md)

**Part of Process:**
- [SYSMOD Infrastructure Process](../processes/infrastructure-process.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 4.2.
