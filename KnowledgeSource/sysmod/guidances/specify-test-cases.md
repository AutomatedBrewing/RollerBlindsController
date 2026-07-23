---
type: SYSMOD Guidance
title: How to Specify Test Cases
description: A step-by-step guide for specifying test cases in the SysML model using SYSMOD systemTestCase and modelTestCase stereotypes with verify relationships to requirements.
timestamp: 2026-07-01T00:00:00Z
---

Guidance 7.14 in SYSMOD. This guidance describes how to specify Test Cases in the SysML system model.

# Context

- **SYSMOD Method:** [4.16 Specify Test Cases](../methods/specify-test-cases.md)
- **SYSMOD Product:** [5.16 Test Cases](../products/test-cases.md)
- **SYSMOD Role:** [System Tester](../roles/system-tester.md)

# Description

Test Cases are modeled with SYSMOD stereotypes «systemTestCase» or «modelTestCase». Each Test Case has verify relationships to the Requirements it tests, and dependency relationships to architectural elements used in the test.

# How to Model

1. Select the package `<system>_VerificationValidation`.
2. Create a table `<system>_TestCases` depicting all Test Cases in the package with related information.
3. For each identified Test Case, create a SysML block definition diagram named `<test case>_Definition`.
4. Create the Test Case element in the diagram.
5. Place all dependent Test Cases on the diagram and model the dependency relationships.
6. Place the Requirements that are verified by the Test Case on the diagram and model the verify relationships from the Test Case to the Requirements.
7. Place all test data instance specifications used by the Test Case on the diagram and model usage relationships from the Test Case to the instance specifications.
8. Select the Test Case.
9. Create a SysML Activity with an activity diagram owned by the Test Case.
10. Define pre- and postconditions for the activity if appropriate.
11. Model the steps of the Test Case, including control and object flow if necessary.
12. Use the documentation field or a linked SysML Comment to add brief textual descriptions for each action and non-obvious guards of decision nodes.

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 7.14.
