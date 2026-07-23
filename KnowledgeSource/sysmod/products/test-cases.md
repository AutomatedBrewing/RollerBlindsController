---
type: SYSMOD Product
title: Test Cases
description: The Test Cases specify procedures on how to test that the system satisfies the requirements, closing the loop from requirements through the system architecture back to the requirements.
timestamp: 2026-07-01T00:00:00Z
---

Product 5.16 in SYSMOD. The Test Cases close the loop, starting with the Requirements through the system analysis to the System Architectures and implementation, and assure that the modeled and implemented system satisfies the Requirements.

# Purpose

The Test Cases close the loop, starting with the Requirements through the system analysis to the System Architectures and implementation, and assure that the modeled and implemented system satisfies the Requirements.

# Description

The Test Cases are behavioral descriptions of how to test the system. It can be a step-by-step work description of a manual test, a specification for test scripts, or an executable behavior. The Test Case behavior returns a verdict that represents the test result (pass, fail, etc.).

A Model Test Case is a special Test Case that tests the model of the system rather than the real system, verifying the specification of the system.

# Relationships

**Responsibility:** [System Tester](../roles/system-tester.md)

**Output of Methods:**
- [4.16 Specify Test Cases](../methods/specify-test-cases.md)

**Input of Methods:**
- [4.22 Model the Test Architecture](../methods/model-test-architecture.md)

**Representation:**
- SysML requirements diagram with SYSMOD stereotype «systemTestCase» or «modelTestCase»
- SysML activity diagram
- SysML block definition diagram and matrices

**Related Guidance:** [7.14 How to Specify Test Cases](../guidances/specify-test-cases.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 5.16.
