---
type: SYSMOD Guidance
title: How to Analyze the Problem
description: A step-by-step guide for analyzing and documenting the problem statement, including use of the Problem Statement model template and workshop tools for problem space exploration.
timestamp: 2026-07-01T00:00:00Z
---

Guidance 7.2 in SYSMOD. This guidance describes how to model the Problem Statement in the SysML model.

# Context

- **SYSMOD Method:** [4.5 Analyze the Problem](../methods/analyze-problem.md)
- **SYSMOD Product:** [5.4 Problem Statement](../products/problem-statement.md)
- **SYSMOD Role:** [Project Manager](../roles/project-manager.md)

# Description

The Problem Statement is stored in the model as a property of the SYSMOD stereotype «system». The 6M and Five Whys workshop tools can be used to analyze the problem space before creating the Problem Statement. The Problem Statement summarizes the conclusions of this analysis.

The Problem Statement document template contains the fields: Who is having the problem, What is the problem and the context, and Why it matters.

# How to Model

1. Select the system element in the root package of the core.
2. The SYSMOD stereotype «system» has a property `problemStatement` to store the Problem Statement. Enter the text of the Problem Statement in this field. If the Problem Statement refers to external documents, put a reference to the external source in the model.

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 7.2.
