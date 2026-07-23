---
type: SYSMOD Method
title: Specify Test Cases
description: Model the test cases that verify and validate the requirements, closing the loop from system requirements through the architecture and back to the requirements.
timestamp: 2026-07-01T00:00:00Z
---

Method 4.16 in SYSMOD. The Test Cases close the loop from the system requirements to the Physical Architecture and system implementation via the Test Cases back to the system requirements.

# Purpose

The Test Cases close the loop from the system requirements to the Physical Architecture and system implementation via the Test Cases back to the system requirements.

# Description

The Test Cases specify how to verify and validate that the system satisfies the Requirements. At the specification level, the Test Cases have a verify relationship to the Requirements and a dependency relationship to the architectural elements that are used in the test.

A special kind of Test Case is the Model Test Case that verifies or validates that the model virtually satisfies the Requirements instead of the real system itself.

SYSMOD only considers the Test Cases on the system level. Test Cases on specific engineering discipline levels (software test cases, etc.) are not covered by this method.

# Relationships

**Primary Performer:** [System Tester](../roles/system-tester.md)

**Inputs:**
- [5.10 Requirements](../products/requirements.md)
- [5.14 Use Case Activities](../products/use-case-activities.md)

**Outputs:**
- [5.16 Test Cases](../products/test-cases.md)

**ISO 15288 Process:** Verification; Validation

**Guidance:**
- [7.14 How to Specify Test Cases](../guidances/specify-test-cases.md)

**Part of Process:**
- [SYSMOD Analysis Process](../processes/analysis-process.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 4.16.
