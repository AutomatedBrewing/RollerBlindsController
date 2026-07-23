---
okf_version: "0.1"
type: OKF Cross-Mapping Bundle
title: OKF Cross-Mapping — SYSMOD × SysML v2 × arc42
description: Bundle index for all 24 per-artifact cross-mapping files. Each file provides the full SysML v2 modeling method, arc42 documentation location, traceability rules, and step-by-step procedure for one SYSMOD product.
timestamp: 2026-07-01T00:00:00Z
---

# OKF Cross-Mapping — SYSMOD × SysML v2 × arc42

This bundle provides detailed cross-mapping files for all 24 SYSMOD products. Each file maps one SYSMOD product artifact to its corresponding SysML v2 modeling elements, arc42 documentation sections, traceability rules, and a step-by-step modeling procedure.

**Ontology reference:** [OKF Ontology](../okf-ontology.md)

---

## MBSE Adoption Process (SM-PRC-4)

These artifacts establish the MBSE infrastructure, methodology, and team capability needed before any engineering work begins. They are prerequisites for all Analysis and Architecture process products.

| ID | Artifact | Brief Description | File |
|----|----------|-------------------|------|
| SM-PRD-01 | MBSE Methodology | Project-specific tailoring of SYSMOD: which processes, methods, products, roles, and notations are applied | [mbse-methodology.md](./mbse-methodology.md) |
| SM-PRD-02 | System Modeling Environment (SME) | Configured modeling toolchain — tool selection, SysML v2 profiles, libraries, and inter-tool integration | [system-modeling-environment.md](./system-modeling-environment.md) |
| SM-PRD-03 | MBSE Training | Training program and coaching plan that equips team members with the skills to apply MBSE | [mbse-training.md](./mbse-training.md) |

---

## Analysis Process (SM-PRC-1)

These artifacts capture the problem space, stakeholder needs, system boundaries, and analysis models that precede architecture design. They establish the "what" and "why" before the "how".

| ID | Artifact | Brief Description | File |
|----|----------|-------------------|------|
| SM-PRD-04 | Problem Statement | Structured description of the current situation, desired state, gap, and affected users | [problem-statement.md](./problem-statement.md) |
| SM-PRD-05 | System Idea | Elevator-pitch vision describing the proposed system, its value proposition, and key features | [system-idea.md](./system-idea.md) |
| SM-PRD-06 | System Objectives | Measurable business and system goals derived from the problem statement and system idea | [system-objectives.md](./system-objectives.md) |
| SM-PRD-07 | Base Architecture | Preliminary architectural sketch providing early design decisions and framing context | [base-architecture.md](./base-architecture.md) |
| SM-PRD-08 | Stakeholders | Identified stakeholders with roles, interests, influence level, and system-relevant concerns | [stakeholders.md](./stakeholders.md) |
| SM-PRD-09 | Risks | Identified and assessed project and system risks with likelihood, impact, and mitigation strategies | [risks.md](./risks.md) |
| SM-PRD-10 | Requirements | Structured, verifiable system requirements derived from stakeholder needs and system objectives | [requirements.md](./requirements.md) |
| SM-PRD-11 | System Context | Explicit system boundary and all external interfaces to actors, neighboring systems, and environments | [system-context.md](./system-context.md) |
| SM-PRD-12 | System Use Cases | Black-box functional use cases describing system behavior from the stakeholder perspective | [system-use-cases.md](./system-use-cases.md) |
| SM-PRD-13 | System Processes | End-to-end operational processes that the system participates in or enables | [system-processes.md](./system-processes.md) |
| SM-PRD-14 | Use Case Activities | Detailed activity flows for each system use case, including alternate and exception flows | [use-case-activities.md](./use-case-activities.md) |
| SM-PRD-15 | Domain Knowledge | Domain model capturing key concepts, entities, relationships, and terminology in the problem space | [domain-knowledge.md](./domain-knowledge.md) |
| SM-PRD-16 | Test Cases | High-level test cases derived from requirements and use cases for system-level validation | [test-cases.md](./test-cases.md) |

---

## Architecture Process (SM-PRC-2)

These artifacts define the system solution structure across functional, logical, and physical dimensions. They answer the "how" by decomposing the system into verifiable architectural elements.

| ID | Artifact | Brief Description | File |
|----|----------|-------------------|------|
| SM-PRD-17 | System Architecture [abstract] | Abstract integration of functional and physical views; the top-level architectural description | [system-architecture.md](./system-architecture.md) |
| SM-PRD-18 | Functional Architecture | Hierarchical decomposition of system functions into functional blocks with internal and external interfaces | [functional-architecture.md](./functional-architecture.md) |
| SM-PRD-19 | Physical Architecture [abstract] | Technology-agnostic structural decomposition before product assignment | [physical-architecture.md](./physical-architecture.md) |
| SM-PRD-20 | Logical Architecture | Technology-independent logical component architecture with explicitly typed interfaces | [logical-architecture.md](./logical-architecture.md) |
| SM-PRD-21 | Product Architecture | Physical realization mapping logical components to concrete hardware and software products | [product-architecture.md](./product-architecture.md) |
| SM-PRD-22 | Scenarios | Dynamic interaction and sequence scenarios illustrating key system behaviors | [scenarios.md](./scenarios.md) |
| SM-PRD-23 | System States | State machine model capturing system lifecycle states and valid transitions | [system-states.md](./system-states.md) |
| SM-PRD-24 | Test Architecture | Verification and validation architecture mapping requirements to test cases and test environments | [test-architecture.md](./test-architecture.md) |

---

## Traceability Link Types

The following link types are used across all cross-mapping files:

| Link Type | Meaning |
|-----------|---------|
| `depends_on` | The source artifact requires the target to exist before it can be created |
| `refines` | The source artifact elaborates or decomposes the target with more detail |
| `implements` | A SysML v2 model element realizes or fulfills the SYSMOD product |
| `documents` | An arc42 section captures or describes the SYSMOD product |
| `enables` | The source artifact makes the target possible (infrastructure/precondition) |
| `verifies` | The source artifact provides evidence that the target is correct or complete |

---

## Usage Notes

- All relative links within mapping files are resolved from the `integration/crossmapping/` directory.
- SysML v2 element references use IDs from the `SML-` namespace as defined in each mapping table.
- arc42 section references use `ARC-NN` identifiers matching the standard 12-section arc42 structure.
- Products SM-PRD-07 through SM-PRD-24 will be fully mapped in subsequent file batches.
