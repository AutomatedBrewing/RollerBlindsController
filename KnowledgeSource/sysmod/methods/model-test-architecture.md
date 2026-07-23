---
type: SYSMOD Method
title: Model the Test Architecture
description: Model the setup of the test system and the system under test, specifying the configurations needed to perform the test cases.
timestamp: 2026-07-01T00:00:00Z
---

Method 4.22 in SYSMOD. The Test Architecture specifies the configurations of the test system, the system under test, and the environment to perform the Test Cases.

# Purpose

The Test Architecture specifies the configurations of the test system, the system under test, and the environment to perform the Test Cases.

# Description

Typically, you need a test system and additional actors to test your system. The Test Architecture specifies the setup of these elements. It can also specify the test system itself—the specification of the test system in a system model.

The Test Architecture consists of more than one test setup. For example, a setup for a user interaction test and another setup for a hardware-in-the-loop test (HIL).

If appropriate, variant modeling techniques can be applied to specify the different setups. The OMG standard UML Testing Profile (UTP) can also be applied to a SysML model, including stereotypes to model test architectures like SUT (system under test) or TestContext.

# Relationships

**Primary Performer:** [System Tester](../roles/system-tester.md)

**Inputs:**
- [5.19 Physical Architecture](../products/physical-architecture.md)

**Outputs:**
- [5.24 Test Architecture](../products/test-architecture.md)

**ISO 15288 Process:** Verification; Validation

**Guidance:**
- [7.19 How to Model the Test Architecture](../guidances/model-test-architecture.md)

**Part of Process:**
- [SYSMOD Architecture Process](../processes/architecture-process.md)

**Related Tools:**
- [Variant Modeling](../tools/variant-modeling.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 4.22.
