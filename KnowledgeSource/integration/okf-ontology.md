---
okf_version: "0.1"
type: OKF Integration Knowledge
title: OKF Unified Ontology — SYSMOD × SysML v2 × arc42
description: Comprehensive ontology connecting all SYSMOD products, SysML v2 model elements, and arc42 documentation sections into a unified, traceable knowledge graph with adjacency mappings, dependency graph, and project structure guidance.
timestamp: 2026-07-01T00:00:00Z
---

# OKF Unified Ontology — SYSMOD × SysML v2 × arc42

This file is the single authoritative integration reference for a SYSMOD-based MBSE project documented with arc42 and modelled in SysML v2. An LLM can use this file alone to answer:

- "Which SysML v2 elements implement SYSMOD product X?"
- "In which arc42 section is artifact Y documented?"
- "What must be created before I start on product Z?"
- "How do I trace from a requirement to a test case?"

**Sources:**
- SYSMOD, 3rd ed. (Tim Weilkiens, MBSE4U, 2020) → [`../sysmod/`](../sysmod/)
- OMG SysML v2 Specification (formal/2026-03) → [`../sysml2/`](../sysml2/)
- arc42 Architecture Documentation Framework → [`../arc42/`](../arc42/)

---

## Section 1 — Node Catalogue

### 1.1 SysMod Nodes

Products are numbered SM-PRD-01…24 in ascending SYSMOD section order (§5.1–§5.24). Abstract concepts are marked **[abstract]**.

#### 1.1.1 Products

| ID | Tag | SYSMOD § | Name | 1-Line Description |
|----|-----|----------|------|--------------------|
| **SM-PRD-01** | [SYSMOD-PRODUCT] | 5.1 | [MBSE Methodology](../sysmod/products/mbse-methodology.md) | Tailored set of processes, roles, methods, products, and tools that guides MBSE application. |
| **SM-PRD-02** | [SYSMOD-PRODUCT] | 5.2 | [System Modeling Environment (SME)](../sysmod/products/system-modeling-environment.md) | Configured modeling toolset (profiles, plugins, repos) enabling the MBSE Methodology. |
| **SM-PRD-03** | [SYSMOD-PRODUCT] | 5.3 | [MBSE Training](../sysmod/products/mbse-training.md) | All training sessions and coaching activities that deploy MBSE knowledge and skills. |
| **SM-PRD-04** | [SYSMOD-PRODUCT] | 5.4 | [Problem Statement](../sysmod/products/problem-statement.md) | Clear, user-centric statement of the gap between current state and desired state. |
| **SM-PRD-05** | [SYSMOD-PRODUCT] | 5.5 | [System Idea](../sysmod/products/system-idea.md) | Elevator-pitch description of the system's purpose, value, and leading features. |
| **SM-PRD-06** | [SYSMOD-PRODUCT] | 5.6 | [System Objectives](../sysmod/products/system-objectives.md) | Vendor/owner objectives (system-related and business-related) that drive requirements. |
| **SM-PRD-07** | [SYSMOD-PRODUCT] | 5.7 | [Base Architecture](../sysmod/products/base-architecture.md) | Pre-set architectural and technical decisions that constrain the solution space. |
| **SM-PRD-08** | [SYSMOD-PRODUCT] | 5.8 | [Stakeholders](../sysmod/products/stakeholders.md) | All persons and organisations with concerns about the system, including their concerns. |
| **SM-PRD-09** | [SYSMOD-PRODUCT] | 5.9 | [Risks](../sysmod/products/risks.md) | Potential inability to achieve System Objectives, linked to requirements and architectures. |
| **SM-PRD-10** | [SYSMOD-PRODUCT] | 5.10 | [Requirements](../sysmod/products/requirements.md) | Contract between stakeholders and systems engineers specifying what the system must satisfy. |
| **SM-PRD-11** | [SYSMOD-PRODUCT] | 5.11 | [System Context](../sysmod/products/system-context.md) | External entities (actors), interfaces, and item flows that bound the system. |
| **SM-PRD-12** | [SYSMOD-PRODUCT] | 5.12 | [System Use Cases](../sysmod/products/system-use-cases.md) | Table-of-contents of services provided by the system to system actors. |
| **SM-PRD-13** | [SYSMOD-PRODUCT] | 5.13 | [System Processes](../sysmod/products/system-processes.md) | Logical execution order of System Use Cases as higher-level process flows. |
| **SM-PRD-14** | [SYSMOD-PRODUCT] | 5.14 | [Use Case Activities](../sysmod/products/use-case-activities.md) | Functional decomposition of each System Use Case: actions, execution order, object flows. |
| **SM-PRD-15** | [SYSMOD-PRODUCT] | 5.15 | [Domain Knowledge](../sysmod/products/domain-knowledge.md) | Specification of domain objects (data, physical entities, value types, units) known by the system. |
| **SM-PRD-16** | [SYSMOD-PRODUCT] | 5.16 | [Test Cases](../sysmod/products/test-cases.md) | Behavioural descriptions of how to verify the system satisfies each requirement. |
| **SM-PRD-17** | [SYSMOD-PRODUCT] **[abstract]** | 5.17 | [System Architecture](../sysmod/products/system-architecture.md) | Root of the architecture taxonomy; encompasses all architecture kinds (abstract). |
| **SM-PRD-18** | [SYSMOD-PRODUCT] | 5.18 | [Functional Architecture](../sysmod/products/functional-architecture.md) | Technology-independent functional description: functional elements, interfaces, and flows. |
| **SM-PRD-19** | [SYSMOD-PRODUCT] **[abstract]** | 5.19 | [Physical Architecture](../sysmod/products/physical-architecture.md) | Abstract parent of Base, Logical, Product, and Test Architectures. |
| **SM-PRD-20** | [SYSMOD-PRODUCT] | 5.20 | [Logical Architecture](../sysmod/products/logical-architecture.md) | High-abstraction physical architecture specifying essential technical concepts and principles. |
| **SM-PRD-21** | [SYSMOD-PRODUCT] | 5.21 | [Product Architecture](../sysmod/products/product-architecture.md) | Concrete, most-detailed physical architecture specification in the system model. |
| **SM-PRD-22** | [SYSMOD-PRODUCT] | 5.22 | [Scenarios](../sysmod/products/scenarios.md) | Concrete collaborations of actors and system parts verifying a specific use-case path. |
| **SM-PRD-23** | [SYSMOD-PRODUCT] | 5.23 | [System States](../sysmod/products/system-states.md) | Discrete conditions of the system or its parts controlling behaviour upon events. |
| **SM-PRD-24** | [SYSMOD-PRODUCT] | 5.24 | [Test Architecture](../sysmod/products/test-architecture.md) | Specification of the test setup: system under test integrated into the test environment. |

#### 1.1.2 Processes

| ID | Tag | Name | 1-Line Description |
|----|-----|------|--------------------|
| **SM-PRC-01** | [SYSMOD-PROCESS] | Analysis Process | Captures all problem-space artifacts: problem, stakeholders, requirements, context, use cases, domain. |
| **SM-PRC-02** | [SYSMOD-PROCESS] | Architecture Process | Translates analysis results into logical, product, and functional architectures; validates with scenarios. |
| **SM-PRC-03** | [SYSMOD-PROCESS] | Infrastructure Process | Establishes MBSE Methodology, SME, and MBSE Training before engineering begins. |
| **SM-PRC-04** | [SYSMOD-PROCESS] | MBSE Adoption Process (SMAP) | Applies SYSMOD to itself to derive and deploy a customized MBSE Methodology. |

#### 1.1.3 Methods (Key Reference)

| ID | Tag | Name | SYSMOD Method No. | Primary Outputs |
|----|-----|------|-------------------|-----------------|
| **SM-MTH-01** | [SYSMOD-METHOD] | Tailor the MBSE Methodology | 4.1 | SM-PRD-01 |
| **SM-MTH-02** | [SYSMOD-METHOD] | Set up and Maintain the SME | 4.2 | SM-PRD-02 |
| **SM-MTH-03** | [SYSMOD-METHOD] | Deploy the MBSE Methodology | 4.3 | SM-PRD-01 (deployed) |
| **SM-MTH-04** | [SYSMOD-METHOD] | Provide MBSE Training and Coaching | 4.4 | SM-PRD-03 |
| **SM-MTH-05** | [SYSMOD-METHOD] | Analyze the Problem | 4.5 | SM-PRD-04 |
| **SM-MTH-06** | [SYSMOD-METHOD] | Describe System Idea and Objectives | 4.6 | SM-PRD-05, SM-PRD-06 |
| **SM-MTH-07** | [SYSMOD-METHOD] | Describe the Base Architecture | 4.7 | SM-PRD-07 |
| **SM-MTH-08** | [SYSMOD-METHOD] | Identify Stakeholders | 4.8 | SM-PRD-08 |
| **SM-MTH-09** | [SYSMOD-METHOD] | Model Risks | 4.9 | SM-PRD-09 |
| **SM-MTH-10** | [SYSMOD-METHOD] | Model Requirements | 4.10 | SM-PRD-10 |
| **SM-MTH-11** | [SYSMOD-METHOD] | Identify the System Context | 4.11 | SM-PRD-11 |
| **SM-MTH-12** | [SYSMOD-METHOD] | Identify System Use Cases | 4.12 | SM-PRD-12 |
| **SM-MTH-13** | [SYSMOD-METHOD] | Identify System Processes | 4.13 | SM-PRD-13 |
| **SM-MTH-14** | [SYSMOD-METHOD] | Model Use Case Activities | 4.14 | SM-PRD-14 |
| **SM-MTH-15** | [SYSMOD-METHOD] | Model the Domain Knowledge | 4.15 | SM-PRD-15 |
| **SM-MTH-16** | [SYSMOD-METHOD] | Specify Test Cases | 4.16 | SM-PRD-16 |
| **SM-MTH-17** | [SYSMOD-METHOD] | Model the Functional Architecture | 4.17 | SM-PRD-18 |
| **SM-MTH-18** | [SYSMOD-METHOD] | Model the Logical Architecture | 4.18 | SM-PRD-20 |
| **SM-MTH-19** | [SYSMOD-METHOD] | Model the Product Architecture | 4.19 | SM-PRD-21 |
| **SM-MTH-20** | [SYSMOD-METHOD] | Revise Architecture with Scenarios | 4.20 | SM-PRD-22 |
| **SM-MTH-21** | [SYSMOD-METHOD] | Define System States | 4.21 | SM-PRD-23 |
| **SM-MTH-22** | [SYSMOD-METHOD] | Model the Test Architecture | 4.22 | SM-PRD-24 |

---

### 1.2 SysML v2 Nodes

#### 1.2.1 Definition Elements

| ID | Tag | Full Name | 1-Line Description |
|----|-----|-----------|--------------------|
| **SML-DEF-PartDef** | [SML-DEFINITION] | [Part Definition](../sysml2/concepts/part-definition.md) | Classifies modular structural units (system, subsystem, component, external entity). |
| **SML-DEF-ReqDef** | [SML-DEFINITION] | [Requirement Definition](../sysml2/concepts/requirement-definition.md) | Specifies stakeholder-imposed constraints a design solution must satisfy; has subject, actors, assumed/required constraints. |
| **SML-DEF-UCaseDef** | [SML-DEFINITION] | [Use Case Definition](../sysml2/concepts/use-case-definition.md) | Specifies required behavior of a subject relative to actors with an observable result of value. |
| **SML-DEF-ActDef** | [SML-DEFINITION] | [Action Definition](../sysml2/concepts/action-definition.md) | Classifies action performances; has in/out parameters and nested sub-action usages. |
| **SML-DEF-StateDef** | [SML-DEFINITION] | [State Definition](../sysml2/concepts/state-definition.md) | Classifies state performances; has entry/do/exit actions and hierarchical sub-states. |
| **SML-DEF-ItemDef** | [SML-DEFINITION] | [Item Definition](../sysml2/concepts/item-definition.md) | Classifies identifiable objects with temporal extent that can be acted on (data, materials, signals). |
| **SML-DEF-AttrDef** | [SML-DEFINITION] | [Attribute Definition](../sysml2/concepts/attribute-definition.md) | Defines data values (numbers, strings, quantity values with units, structured data). |
| **SML-DEF-PortDef** | [SML-DEFINITION] | [Port Definition](../sysml2/concepts/port-definition.md) | Defines a connection point enabling typed interaction; implicitly declares a conjugated port. |
| **SML-DEF-ConnDef** | [SML-DEFINITION] | [Connection Definition](../sysml2/concepts/connection-definition.md) | Classifies binary or n-ary connections between related occurrences; is also a part definition. |
| **SML-DEF-IfaceDef** | [SML-DEFINITION] | [Interface Definition](../sysml2/concepts/interface-definition.md) | Connection definition whose ends are restricted to port definitions; models typed interaction contracts. |
| **SML-DEF-AllocDef** | [SML-DEFINITION] | [Allocation Definition](../sysml2/concepts/allocation-definition.md) | Always-binary connection definition mapping a source element to a target that realizes it. |
| **SML-DEF-VCaseDef** | [SML-DEFINITION] | [Verification Case Definition](../sysml2/concepts/verification-case-definition.md) | Specifies how to verify a subject against requirements; returns a VerdictKind result. |
| **SML-DEF-ConstrDef** | [SML-DEFINITION] | [Constraint Definition](../sysml2/concepts/constraint-definition.md) | Defines a logical predicate with an implicit Boolean result parameter. |
| **SML-DEF-MetaDef** | [SML-DEFINITION] | [Metadata Definition](../sysml2/concepts/metadata-definition.md) | Defines the schema of a structured annotation (tag or structured attribute set) applied to model elements. |
| **SML-DEF-FlowDef** | [SML-DEFINITION] | [Flow Definition](../sysml2/concepts/flow.md) | Binary action/relationship classifying directed transfer of payload between occurrences. |
| **SML-DEF-VpointDef** | [SML-DEFINITION] | [Viewpoint Definition](../sysml2/concepts/viewpoint-definition.md) | Requirement definition whose subject is a view; frames stakeholder concerns that views must address. |
| **SML-DEF-Package** | [SML-DEFINITION] | [Package](../sysml2/concepts/package.md) | Namespace used purely for organizing model elements; supports filter conditions. |

#### 1.2.2 Usage Elements

| ID | Tag | Full Name | 1-Line Description |
|----|-----|-----------|--------------------|
| **SML-USG-PartUSG** | [SML-USAGE] | [Part Usage](../sysml2/concepts/part-usage.md) | Named structural component instance typed by a part definition within a context. |
| **SML-USG-ReqUSG** | [SML-USAGE] | [Requirement Usage](../sysml2/concepts/requirement-usage.md) | Application of a requirement definition in a specific containment context. |
| **SML-USG-UCaseUSG** | [SML-USAGE] | [Use Case Usage](../sysml2/concepts/use-case-usage.md) | Application of a use case definition; binds subject and actors to specific instances. |
| **SML-USG-ActUSG** | [SML-USAGE] | [Action Usage](../sysml2/concepts/action-usage.md) | Application of an action definition as a named behavioral step within a context. |
| **SML-USG-StateUSG** | [SML-USAGE] | [State Usage](../sysml2/concepts/state-usage.md) | Application of a state definition; represents a state instance on a specific part. |
| **SML-USG-ItemUSG** | [SML-USAGE] | [Item Usage](../sysml2/concepts/item-usage.md) | Application of an item definition; represents a typed object in a context. |
| **SML-USG-AttrUSG** | [SML-USAGE] | [Attribute Usage](../sysml2/concepts/attribute-usage.md) | Application of an attribute definition; represents a named data property. |
| **SML-USG-PortUSG** | [SML-USAGE] | [Port Usage](../sysml2/concepts/port-usage.md) | Application of a port definition on a part; represents a typed connection point. |
| **SML-USG-ConnUSG** | [SML-USAGE] | [Connection Usage](../sysml2/concepts/connection-usage.md) | Application of a connection definition linking specific part or port usages. |
| **SML-USG-IfaceUSG** | [SML-USAGE] | [Interface Usage](../sysml2/concepts/interface-usage.md) | Application of an interface definition between specific port usages. |
| **SML-USG-AllocUSG** | [SML-USAGE] | [Allocation Usage](../sysml2/concepts/allocation-usage.md) | Application of an allocation definition mapping specific source to target. |
| **SML-USG-VCaseUSG** | [SML-USAGE] | [Verification Case Usage](../sysml2/concepts/verification-case-usage.md) | Application of a verification case definition for a specific subject and requirements. |
| **SML-USG-Satisfy** | [SML-USAGE] | [Satisfy](../sysml2/concepts/satisfy.md) | Assert-constraint usage that positively asserts a design element satisfies a requirement. |
| **SML-USG-ItemFlow** | [SML-USAGE] | [Item Flow](../sysml2/concepts/item-flow.md) | Streaming flow usage transferring typed items between output and input features of occurrences. |

#### 1.2.3 Diagram Types

| ID | Tag | Full Name | 1-Line Description |
|----|-----|-----------|--------------------|
| **SML-DGM-DefDiag** | [SML-DIAGRAM] | [Definition Diagram](../sysml2/diagrams/definition-diagram.md) | Shows definitions, features, specialization hierarchies; equivalent to SysML v1 BDD. |
| **SML-DGM-ActFlow** | [SML-DIAGRAM] | [Action Flow Diagram](../sysml2/diagrams/action-flow-diagram.md) | Shows action decomposition, successions (control flow), flows (data flow), and control nodes. |
| **SML-DGM-ReqDiag** | [SML-DIAGRAM] | [Requirements Diagram](../sysml2/diagrams/requirements-diagram.md) | Shows requirement hierarchy, assumed/required constraints, and satisfy relationships. |
| **SML-DGM-StateDiag** | [SML-DIAGRAM] | [State Machine Diagram](../sysml2/diagrams/state-diagram.md) | Shows state definitions/usages, transitions, entry/do/exit actions, hierarchical states. |
| **SML-DGM-SeqDiag** | [SML-DIAGRAM] | [Sequence Diagram](../sysml2/diagrams/sequence-diagram.md) | Shows time-ordered message exchange between part usage lifelines (interaction view). |
| **SML-DGM-ConstrDiag** | [SML-DIAGRAM] | [Constraint Diagram](../sysml2/diagrams/constraint-diagram.md) | Shows constraint definitions/usages with formal expressions and parameter bindings to model elements. |
| **SML-DGM-PkgDiag** | [SML-DIAGRAM] | [Package Diagram](../sysml2/diagrams/package-diagram.md) | Shows model organization into packages, membership relationships, and import relationships. |

---

#### 1.2.4 Behavioral & Control Flow Elements

Concrete action types, control flow nodes, and state-behavior elements.

| Tag | Full Name | 1-Line Description |
|-----|-----------|--------------------|
| [SML-ACT] | [Accept Action](../sysml2/concepts/accept-action.md) | Accepts a transfer/payload received by a given receiver occurrence; outputs that payload. |
| [SML-ACT] | [Assign Action](../sysml2/concepts/assign-action.md) | Changes the value of a referent feature of a target occurrence to a new assigned value. |
| [SML-ACT] | [For Loop Action](../sysml2/concepts/for-loop-action.md) | Structured control action iterating over a sequence; binds a loop variable per iteration. |
| [SML-ACT] | [If Action](../sysml2/concepts/if-action.md) | Conditional structured action with if/else-if/else branches evaluated at runtime. |
| [SML-ACT] | [Perform Action](../sysml2/concepts/perform-action.md) | Invokes an action or use case definition by reference without embedding inline content. |
| [SML-ACT] | [Send Action](../sysml2/concepts/send-action.md) | Transfers a payload from a sender occurrence to a target port or receiver occurrence. |
| [SML-ACT] | [While Loop Action](../sysml2/concepts/while-loop-action.md) | Structured loop action performing its body repeatedly while a Boolean condition is true. |
| [SML-ACT] | [Include Use Case](../sysml2/concepts/include-use-case.md) | Use case usage that is also a perform action; includes another use case in a containing use case. |
| [SML-CTL] | [Decision Node](../sysml2/concepts/decision-node.md) | Control node with one incoming and multiple guarded outgoing successions; flow branch point. |
| [SML-CTL] | [Fork Node](../sysml2/concepts/fork-node.md) | Control node splitting one incoming succession into multiple concurrent outgoing successions. |
| [SML-CTL] | [Join Node](../sysml2/concepts/join-node.md) | Control node merging multiple incoming successions; fires when all predecessor actions complete. |
| [SML-CTL] | [Merge Node](../sysml2/concepts/merge-node.md) | Control node with multiple incoming and one outgoing succession; fires when any input arrives. |
| [SML-CTL] | [Succession](../sysml2/concepts/succession.md) | Time-ordering relationship between two occurrences; the control flow connector between actions/states. |
| [SML-CTL] | [Transition](../sysml2/concepts/transition.md) | Action usage connecting source to target state with optional trigger, guard, and effect actions. |
| [SML-CTL] | [Exhibit State](../sysml2/concepts/exhibit-state.md) | State usage specifying that a structural part exhibits a given state behavior. |

---

#### 1.2.5 Concept Abstractions

Abstract groupings covering both the definition and usage of each construct. Individual def/usage nodes are catalogued in §1.2.1–1.2.2.

| Tag | Full Name | 1-Line Description |
|-----|-----------|--------------------|
| [SML-ABST] | [Action](../sysml2/concepts/action.md) | Abstract: covers action defs and usages; occurrence over time coordinating sub-actions. |
| [SML-ABST] | [Allocation](../sysml2/concepts/allocation.md) | Abstract: covers allocation defs and usages; mapping from source to realizing target. |
| [SML-ABST] | [Attribute](../sysml2/concepts/attribute.md) | Abstract: covers attribute defs and usages; data values characterizing system elements. |
| [SML-ABST] | [Calculation](../sysml2/concepts/calculation.md) | Abstract: covers calculation defs and usages; reusable computation with a result parameter. |
| [SML-ABST] | [Calculation Definition](../sysml2/concepts/calculation-definition.md) | Action definition specifying a reusable computation with a distinguished result parameter. |
| [SML-ABST] | [Calculation Usage](../sysml2/concepts/calculation-usage.md) | Action usage typed by a calculation definition; performs a specific computation. |
| [SML-ABST] | [Case](../sysml2/concepts/case.md) | Abstract: calculation with objective about a subject; supertype of use cases, verification cases, and analysis cases. |
| [SML-ABST] | [Case Definition](../sysml2/concepts/case-definition.md) | Calculation definition with objective, subject, and actor roles; base for UC/test/analysis defs. |
| [SML-ABST] | [Case Usage](../sysml2/concepts/case-usage.md) | Calculation usage typed by a case definition; performance with bound subject and actors. |
| [SML-ABST] | [Analysis Case](../sysml2/concepts/analysis-case.md) | Case whose objective is to perform an analysis on a subject and return a result. |
| [SML-ABST] | [Analysis Case Definition](../sysml2/concepts/analysis-case-definition.md) | Case definition for analysis; objective always bound to the result produced, not the subject. |
| [SML-ABST] | [Connection](../sysml2/concepts/connection.md) | Abstract: covers connection defs and usages; binary or n-ary relationship between occurrences. |
| [SML-ABST] | [Constraint](../sysml2/concepts/constraint.md) | Abstract: general concept for logical predicates evaluated against a context. |
| [SML-ABST] | [Constraint Usage](../sysml2/concepts/constraint-usage.md) | Occurrence usage typed by a constraint definition; applies the predicate in a containing context. |
| [SML-ABST] | [Frame Constraint](../sysml2/concepts/frame-constraint.md) | Composite constraint inside a requirement; lists features unchanged by a state transition (frame axiom). |
| [SML-ABST] | [Require Constraint](../sysml2/concepts/require-constraint.md) | Composite constraint inside a requirement; asserts an additional required condition on the subject. |
| [SML-ABST] | [Enumeration](../sysml2/concepts/enumeration.md) | Abstract: covers enumeration defs and usages; classifies a finite set of named values. |
| [SML-ABST] | [Enumeration Definition](../sysml2/concepts/enumeration-definition.md) | Attribute definition whose instances are restricted to the declared enum value literals. |
| [SML-ABST] | [Enum Value](../sysml2/concepts/enum-value.md) | Named literal declared in an enumeration definition body. |
| [SML-ABST] | [Interface](../sysml2/concepts/interface.md) | Abstract: covers interface defs and usages; connection whose ends are restricted to port defs. |
| [SML-ABST] | [Item](../sysml2/concepts/item.md) | Abstract: covers item defs and usages; identifiable objects with temporal extent. |
| [SML-ABST] | [Message](../sysml2/concepts/message.md) | Abstract flow usage specifying a payload transfer between lifelines in a sequence diagram. |
| [SML-ABST] | [Metadata](../sysml2/concepts/metadata.md) | Abstract: covers metadata defs and usages; structured annotation schema applied to elements. |
| [SML-ABST] | [Metadata Usage](../sysml2/concepts/metadata-usage.md) | Annotating element declared with `meta` keyword; applies a metadata definition to a target. |
| [SML-ABST] | [Part](../sysml2/concepts/part.md) | Abstract: covers part defs and usages; general modular structural unit concept. |
| [SML-ABST] | [Port](../sysml2/concepts/port.md) | Abstract: covers port defs and usages; general typed connection point concept. |
| [SML-ABST] | [Conjugated Port](../sysml2/concepts/conjugated-port.md) | Port with reversed direction features; implicitly declared for every port definition. |
| [SML-ABST] | [Requirement](../sysml2/concepts/requirement.md) | Abstract: covers requirement defs and usages; stakeholder-imposed constraint on a subject. |
| [SML-ABST] | [State](../sysml2/concepts/state.md) | Abstract: covers state defs and usages; occurrence defining conditions under which actions occur. |
| [SML-ABST] | [Use Case](../sysml2/concepts/use-case.md) | Abstract: covers use case defs and usages; required behavior of a subject relative to actors. |
| [SML-ABST] | [Variability](../sysml2/concepts/variability.md) | Design choice points modeled via variation elements and bound optional/variant usages. |
| [SML-ABST] | [Verification Case](../sysml2/concepts/verification-case.md) | Abstract: general concept for verification cases; produces a verdict on the subject. |
| [SML-ABST] | [Verify](../sysml2/concepts/verify.md) | Subrequirement inside a verification case objective asserting the subject satisfies a requirement. |
| [SML-ABST] | [View](../sysml2/concepts/view.md) | Abstract: covers view defs and usages; part filtered by a viewpoint for a stakeholder. |
| [SML-ABST] | [View Definition](../sysml2/concepts/view-definition.md) | Part definition specifying filter conditions; produces a stakeholder-specific model presentation. |
| [SML-ABST] | [Viewpoint](../sysml2/concepts/viewpoint.md) | Abstract: covers viewpoint defs and usages; frames stakeholder concerns a view must address. |
| [SML-ABST] | [Render](../sysml2/concepts/render.md) | Kind of part def/usage specifying how a view renders a model presentation for stakeholders. |

---

#### 1.2.6 Language Mechanisms & Relationships

Root metaconcepts, specialization relationships, and structural mechanisms of the SysML v2 language.

| Tag | Full Name | 1-Line Description |
|-----|-----------|--------------------|
| [SML-META] | [Element](../sysml2/concepts/element.md) | Root metaconcept: every model constituent with a unique identifier; owns relationships. |
| [SML-META] | [Namespace](../sysml2/concepts/namespace.md) | Element containing and providing names for other elements; supports filter conditions. |
| [SML-META] | [Definition](../sysml2/concepts/definition.md) | Abstract supertype of all definitions; classifies a kind of thing and owns usage members. |
| [SML-META] | [Usage](../sysml2/concepts/usage.md) | Abstract supertype of all usages; applies a definition in a specific containment context. |
| [SML-META] | [Occurrence](../sysml2/concepts/occurrence.md) | Entity with temporal (and possibly spatial) extent; supertype of all behavioral/structural elements. |
| [SML-META] | [Relationship](../sysml2/concepts/relationship.md) | Abstract supertype of binary relationships; relates two or more elements with optional owned members. |
| [SML-META] | [Dependency](../sysml2/concepts/dependency.md) | Directed relationship between client (source) and supplier (target); client depends on supplier. |
| [SML-META] | [Membership](../sysml2/concepts/membership.md) | Relationship between a namespace and one of its member elements; establishes the containment link. |
| [SML-META] | [Subclassification](../sysml2/concepts/subclassification.md) | Specialization between definitions; subclass inherits all features from its superclass. |
| [SML-META] | [Subsetting](../sysml2/concepts/subsetting.md) | Specialization between usages; the subsetting usage has a subset of values of the subsetted usage. |
| [SML-META] | [Redefinition](../sysml2/concepts/redefinition.md) | Subsetting where the redefining usage replaces the redefined usage in all featuring contexts. |
| [SML-META] | [Feature Typing](../sysml2/concepts/feature-typing.md) | Relationship asserting a definition as the type of a usage; establishes conformance semantics. |
| [SML-META] | [Multiplicity](../sysml2/concepts/multiplicity.md) | Specifies lower and upper value-count bounds for any instance of a usage's featuring definition. |
| [SML-META] | [Annotation](../sysml2/concepts/annotation.md) | Relationship between an annotating element (comment, metadata) and its annotated element. |
| [SML-META] | [Comment](../sysml2/concepts/comment.md) | Annotating element providing textual description; may annotate one or more model elements. |
| [SML-META] | [Documentation](../sysml2/concepts/documentation.md) | Distinguished comment documenting exactly its owning element; declared with the `doc` keyword. |
| [SML-META] | [Import](../sysml2/concepts/import.md) | Relationship bringing memberships from one namespace into the scope of another. |
| [SML-META] | [Individual](../sysml2/concepts/individual.md) | Occurrence representing a single, uniquely identified entity distinct from all others. |
| [SML-META] | [Snapshot](../sysml2/concepts/snapshot.md) | Zero-duration portion of an individual's lifetime representing a specific instant in time. |
| [SML-META] | [Timeslice](../sysml2/concepts/timeslice.md) | Portion of an occurrence's lifetime corresponding to a duration; used for temporal state analysis. |

---

#### 1.2.7 Language Rules

Normative rules from the SysML v2 specification governing syntax, semantics, and type-system behavior. See [`../sysml2/rules/`](../sysml2/rules/) for full text.

| Full Name | 1-Line Description |
|-----------|--------------------|
| [Conjugation Rules](../sysml2/rules/conjugation-rules.md) | Every port definition implicitly declares a conjugated port with reversed directions; conjugated usage conforms to original. |
| [Definition-Usage Pattern](../sysml2/rules/definition-usage-pattern.md) | Every element is either a definition classifying a kind of thing or a usage applying it in a context. |
| [Feature Chains](../sysml2/rules/feature-chains.md) | Dot-separated qualified names where each segment resolves to a usage in the previous segment's context. |
| [Feature Direction](../sysml2/rules/feature-direction.md) | Directed usages declared with `in`, `out`, or `inout`; determines what may change the feature's values. |
| [Flow Typing Rules](../sysml2/rules/flow-typing-rules.md) | Flow payload type must be consistent with both source output and target input feature types. |
| [Multiplicity Bounds](../sysml2/rules/multiplicity-bounds.md) | Lower and upper value-count bounds must be natural numbers; multiplicity constrains feature value count. |
| [Name Resolution](../sysml2/rules/name-resolution.md) | Unqualified names resolved in owning namespace, then lexical enclosures, then imported memberships. |
| [Requirement Satisfaction](../sysml2/rules/requirement-satisfaction.md) | `satisfy` asserts a design element satisfies a requirement; requirement evaluates to true when satisfied. |
| [Specialization Rules](../sysml2/rules/specialization-rules.md) | Three kinds: subclassification (definitions), subsetting (usages/values), redefinition (replacement). |
| [Textual Notation Keywords](../sysml2/rules/textual-notation-keywords.md) | Reserved keywords and symbolic equivalents that cannot be used as ordinary identifiers. |

---

### 1.3 arc42 Nodes

| ID | Tag | Section Name | 1-Line Description |
|----|-----|--------------|--------------------|
| **ARC-01** | [ARC42-SECTION] | [Introduction and Goals](../arc42/sections/introduction-and-goals.md) | Essential requirements, top quality goals, and stakeholder expectations driving the architecture. |
| **ARC-02** | [ARC42-SECTION] | [Architecture Constraints](../arc42/sections/architecture-constraints.md) | Non-negotiable organizational, technical, and regulatory constraints restricting design freedom. |
| **ARC-03** | [ARC42-SECTION] | [Context and Scope](../arc42/sections/context-and-scope.md) | System boundary, external actors, and all external interfaces in business and technical terms. |
| **ARC-04** | [ARC42-SECTION] | [Solution Strategy](../arc42/sections/solution-strategy.md) | Summary of fundamental technology choices and decomposition strategy addressing quality goals. |
| **ARC-05** | [ARC42-SECTION] | [Building Block View](../arc42/sections/building-block-view.md) | Static decomposition into building blocks at hierarchical whitebox/blackbox levels. |
| **ARC-06** | [ARC42-SECTION] | [Runtime View](../arc42/sections/runtime-view.md) | Dynamic runtime scenarios showing how building block instances interact. |
| **ARC-07** | [ARC42-SECTION] | [Deployment View](../arc42/sections/deployment-view.md) | Technical infrastructure and mapping of software building blocks to hardware/infrastructure nodes. |
| **ARC-08** | [ARC42-SECTION] | [Cross-cutting Concepts](../arc42/sections/cross-cutting-concepts.md) | Recurring principles and patterns (security, logging, error handling) spanning multiple building blocks. |
| **ARC-09** | [ARC42-SECTION] | [Architecture Decisions](../arc42/sections/architecture-decisions.md) | Significant, hard-to-reverse decisions with context, alternatives considered, and rationale (ADRs). |
| **ARC-10** | [ARC42-SECTION] | [Quality Requirements](../arc42/sections/quality-requirements.md) | Quality scenarios with stimulus, system response, and response measure elaborating quality goals. |
| **ARC-11** | [ARC42-SECTION] | [Risks and Technical Debts](../arc42/sections/risks-and-technical-debts.md) | Known technical risks and accumulated technical debt with impact and mitigation. |
| **ARC-12** | [ARC42-SECTION] | [Glossary](../arc42/sections/glossary.md) | Domain-specific and technical terms ensuring shared vocabulary across all stakeholders. |

---

## Section 2 — Edge Type Definitions

| Edge Type | Meaning | Direction | Example |
|-----------|---------|-----------|---------|
| `implements` | A SysML v2 element is the formal model representation of a SYSMOD artifact | SML → SM | `SML-DEF-ReqDef.implements.SM-PRD-10` |
| `documents` | An arc42 section is the **rendered publication view** of a SYSMOD artifact; the model element is the source of truth, arc42 is the generated output | ARC → SM | `ARC-01.documents.SM-PRD-10` |
| `depends_on` | Artifact Y must exist before artifact X can be created; Y is an input of the method that creates X | SM → SM | `SM-PRD-11.depends_on.SM-PRD-10` |
| `refines` | Artifact X is a more detailed elaboration of artifact Y at a lower abstraction level | SM → SM | `SM-PRD-21.refines.SM-PRD-20` |
| `maps_to` | A SYSMOD artifact is visualised by a specific SysML v2 diagram type | SM → SML-DGM | `SM-PRD-14.maps_to.SML-DGM-ActFlow` |
| `traced_by` | A model element is verified or validated by a test or verification artifact | SM → SM | `SM-PRD-10.traced_by.SM-PRD-16` |
| `describes` | A SYSMOD artifact defines domain vocabulary for the system | SM → domain | `SM-PRD-15.describes.domain-vocabulary` |
| `realizes` | A lower-level architecture realizes the intent of a higher-level one via allocation | SM → SM | `SM-PRD-21.realizes.SM-PRD-20` |
| `validates` | A scenario exercises a specific path through an activity against the architecture | SM → SM | `SM-PRD-22.validates.SM-PRD-20` |

---

## Section 3 — Adjacency Mapping Table

All 24 SYSMOD products mapped to their primary SysML v2 elements and primary arc42 sections.

| Product ID | Product Name | Primary SysML v2 Elements | Primary arc42 Sections | Key Edge Types |
|-----------|-------------|--------------------------|----------------------|----------------|
| SM-PRD-01 | MBSE Methodology | SML-DEF-Package, SML-DEF-MetaDef | ARC-04, ARC-09 | documents |
| SM-PRD-02 | System Modeling Environment | SML-DEF-Package | ARC-04, ARC-08 | documents |
| SM-PRD-03 | MBSE Training | SML-DEF-Package | ARC-04 | documents |
| SM-PRD-04 | Problem Statement | SML-DEF-ReqDef, SML-DEF-MetaDef | ARC-01 | implements, documents |
| SM-PRD-05 | System Idea | SML-DEF-ReqDef, SML-DEF-VpointDef | ARC-01 | implements, documents |
| SM-PRD-06 | System Objectives | SML-DEF-ReqDef, SML-DEF-ConstrDef | ARC-01, ARC-10 | implements, documents |
| SM-PRD-07 | Base Architecture | SML-DEF-PartDef, SML-DEF-ConnDef, SML-DEF-AllocDef | ARC-02, ARC-04, ARC-09 | implements, documents |
| SM-PRD-08 | Stakeholders | SML-DEF-PartDef, SML-DEF-ReqDef, SML-DEF-VpointDef | ARC-01 | implements, documents |
| SM-PRD-09 | Risks | SML-DEF-ReqDef, SML-DEF-MetaDef | ARC-11 | implements, documents |
| SM-PRD-10 | Requirements | SML-DEF-ReqDef, SML-USG-ReqUSG, SML-DEF-ConstrDef, SML-USG-Satisfy | ARC-01, ARC-10 | implements, documents, traced_by |
| SM-PRD-11 | System Context | SML-DEF-PartDef, SML-DEF-ConnDef, SML-DEF-IfaceDef, SML-USG-ItemFlow, SML-DGM-DefDiag | ARC-03 | implements, documents, maps_to |
| SM-PRD-12 | System Use Cases | SML-DEF-UCaseDef, SML-USG-UCaseUSG, SML-DEF-ReqDef | ARC-01, ARC-03 | implements, documents |
| SM-PRD-13 | System Processes | SML-DEF-StateDef, SML-DEF-ActDef, SML-USG-UCaseUSG | ARC-06 | implements, documents, maps_to |
| SM-PRD-14 | Use Case Activities | SML-DEF-ActDef, SML-USG-ActUSG, SML-USG-ItemFlow, SML-DEF-FlowDef | ARC-06 | implements, documents, maps_to |
| SM-PRD-15 | Domain Knowledge | SML-DEF-ItemDef, SML-DEF-AttrDef, SML-DEF-PartDef, SML-DGM-DefDiag | ARC-12 | implements, documents, describes |
| SM-PRD-16 | Test Cases | SML-DEF-VCaseDef, SML-USG-VCaseUSG, SML-USG-ActUSG, SML-USG-Satisfy | ARC-10, ARC-01 | implements, documents, traced_by |
| SM-PRD-17 | System Architecture *(abstract)* | SML-DEF-Package | ARC-04, ARC-05 | documents |
| SM-PRD-18 | Functional Architecture | SML-DEF-PartDef, SML-DEF-ActDef, SML-DEF-PortDef, SML-DEF-ConnDef, SML-DEF-FlowDef | ARC-05 | implements, documents, maps_to |
| SM-PRD-19 | Physical Architecture *(abstract)* | SML-DEF-PartDef | ARC-05 | documents |
| SM-PRD-20 | Logical Architecture | SML-DEF-PartDef, SML-DEF-PortDef, SML-DEF-ConnDef, SML-DEF-AllocDef, SML-USG-IfaceUSG | ARC-05, ARC-09 | implements, documents, maps_to, refines |
| SM-PRD-21 | Product Architecture | SML-DEF-PartDef, SML-USG-PartUSG, SML-DEF-AttrDef, SML-USG-AttrUSG, SML-DEF-AllocDef | ARC-05, ARC-07 | implements, documents, refines, realizes |
| SM-PRD-22 | Scenarios | SML-DGM-SeqDiag, SML-USG-PartUSG, SML-USG-ItemFlow | ARC-06 | implements, documents, validates |
| SM-PRD-23 | System States | SML-DEF-StateDef, SML-USG-StateUSG, SML-DGM-StateDiag | ARC-06, ARC-05 | implements, documents, maps_to |
| SM-PRD-24 | Test Architecture | SML-DEF-PartDef, SML-DEF-ConnDef, SML-DEF-VCaseDef, SML-USG-AllocUSG | ARC-05, ARC-07 | implements, documents |

**Notes on SysML v2 element selection:**
- SM-PRD-01..03 (Infrastructure products) have no direct SysML v2 structural counterpart; they are meta-level products managed as `package` organization and `metadata def` annotations.
- SM-PRD-17 (System Architecture) and SM-PRD-19 (Physical Architecture) are abstract SYSMOD concepts; their SysML v2 representation is a package grouping their concrete specializations.
- `SML-USG-Satisfy` is the mechanism linking requirements (SM-PRD-10) to architectural elements (SM-PRD-20, SM-PRD-21).

---

## Section 4 — Dependency Graph

### 4.1 Hierarchical Dependency Chart

```
Level 0 — Infrastructure Preconditions (SM-PRC-03, SM-PRC-04):
  SM-PRD-01  MBSE Methodology          (no prerequisites)
  SM-PRD-02  System Modeling Env.      (needs: SM-PRD-01)
  SM-PRD-03  MBSE Training             (needs: SM-PRD-01)

Level 1 — Problem Space Initiation (SM-PRC-01 begins):
  SM-PRD-04  Problem Statement         (no prerequisites)
    → SM-PRD-05  System Idea           (needs: SM-PRD-04)
    → SM-PRD-06  System Objectives     (needs: SM-PRD-04)

Level 2 — Problem Space Elaboration (parallel threads):
  SM-PRD-07  Base Architecture         (needs: SM-PRD-05, SM-PRD-06)
  SM-PRD-08  Stakeholders              (needs: SM-PRD-05, SM-PRD-06, SM-PRD-07)
  SM-PRD-09  Risks                     (needs: SM-PRD-05, SM-PRD-06)

Level 3 — Requirements and Context:
  SM-PRD-10  Requirements              (needs: SM-PRD-05, SM-PRD-06, SM-PRD-07, SM-PRD-08, SM-PRD-09)
  SM-PRD-11  System Context            (needs: SM-PRD-10)

Level 4 — Use Case Specification:
  SM-PRD-12  System Use Cases          (needs: SM-PRD-10, SM-PRD-11)
  SM-PRD-13  System Processes          (needs: SM-PRD-12)

Level 5 — Functional Specification:
  SM-PRD-14  Use Case Activities       (needs: SM-PRD-10, SM-PRD-12, SM-PRD-13)
  SM-PRD-15  Domain Knowledge          (needs: SM-PRD-14)
  SM-PRD-16  Test Cases                (needs: SM-PRD-10, SM-PRD-14)
  SM-PRD-23  System States             (needs: SM-PRD-12, SM-PRD-14)

Level 6 — Architecture (SM-PRC-02 begins):
  SM-PRD-18  Functional Architecture   (needs: SM-PRD-14, SM-PRD-15)
  SM-PRD-20  Logical Architecture      (needs: SM-PRD-07, SM-PRD-10, SM-PRD-11, SM-PRD-12, SM-PRD-18)
  SM-PRD-21  Product Architecture      (needs: SM-PRD-20)
    → SM-PRD-22  Scenarios             (needs: SM-PRD-14, SM-PRD-20, SM-PRD-21)

Level 7 — Verification Setup:
  SM-PRD-24  Test Architecture         (needs: SM-PRD-16, SM-PRD-20, SM-PRD-21)

Abstract (no process position — taxonomy roots only):
  SM-PRD-17  System Architecture       [abstract parent of all architecture kinds]
  SM-PRD-19  Physical Architecture     [abstract parent of Base, Logical, Product, Test Arch.]
```

### 4.2 Dependency Table

| Product ID | Product Name | Depends On (IDs) | SYSMOD Method That Creates It |
|-----------|-------------|-----------------|-------------------------------|
| SM-PRD-01 | MBSE Methodology | — | SM-MTH-01 |
| SM-PRD-02 | System Modeling Environment | SM-PRD-01 | SM-MTH-02 |
| SM-PRD-03 | MBSE Training | SM-PRD-01 | SM-MTH-04 |
| SM-PRD-04 | Problem Statement | — | SM-MTH-05 |
| SM-PRD-05 | System Idea | SM-PRD-04 | SM-MTH-06 |
| SM-PRD-06 | System Objectives | SM-PRD-04 | SM-MTH-06 |
| SM-PRD-07 | Base Architecture | SM-PRD-05, SM-PRD-06 | SM-MTH-07 |
| SM-PRD-08 | Stakeholders | SM-PRD-05, SM-PRD-06, SM-PRD-07 | SM-MTH-08 |
| SM-PRD-09 | Risks | SM-PRD-05, SM-PRD-06 | SM-MTH-09 |
| SM-PRD-10 | Requirements | SM-PRD-05, SM-PRD-06, SM-PRD-07, SM-PRD-08, SM-PRD-09 | SM-MTH-10 |
| SM-PRD-11 | System Context | SM-PRD-10 | SM-MTH-11 |
| SM-PRD-12 | System Use Cases | SM-PRD-10, SM-PRD-11 | SM-MTH-12 |
| SM-PRD-13 | System Processes | SM-PRD-12 | SM-MTH-13 |
| SM-PRD-14 | Use Case Activities | SM-PRD-10, SM-PRD-12, SM-PRD-13 | SM-MTH-14 |
| SM-PRD-15 | Domain Knowledge | SM-PRD-14 | SM-MTH-15 |
| SM-PRD-16 | Test Cases | SM-PRD-10, SM-PRD-14 | SM-MTH-16 |
| SM-PRD-17 | System Architecture *(abstract)* | — | — |
| SM-PRD-18 | Functional Architecture | SM-PRD-14, SM-PRD-15 | SM-MTH-17 |
| SM-PRD-19 | Physical Architecture *(abstract)* | — | — |
| SM-PRD-20 | Logical Architecture | SM-PRD-07, SM-PRD-10, SM-PRD-11, SM-PRD-12, SM-PRD-18 | SM-MTH-18 |
| SM-PRD-21 | Product Architecture | SM-PRD-20 | SM-MTH-19 |
| SM-PRD-22 | Scenarios | SM-PRD-14, SM-PRD-20, SM-PRD-21 | SM-MTH-20 |
| SM-PRD-23 | System States | SM-PRD-12, SM-PRD-14 | SM-MTH-21 |
| SM-PRD-24 | Test Architecture | SM-PRD-16, SM-PRD-20, SM-PRD-21 | SM-MTH-22 |

---

## Section 5 — Global Traceability System

### 5.1 ID Schema

| Namespace | Pattern | Example |
|-----------|---------|---------|
| SYSMOD Products | `SM-PRD-<NN>` (NN = 01–24) | `SM-PRD-10` = Requirements |
| SYSMOD Methods | `SM-MTH-<NN>` (NN = 01–22) | `SM-MTH-10` = Model Requirements |
| SYSMOD Processes | `SM-PRC-<NN>` (NN = 01–04) | `SM-PRC-01` = Analysis Process |
| SysML v2 Definitions | `SML-DEF-<ShortName>` | `SML-DEF-ReqDef` = Requirement Definition |
| SysML v2 Usages | `SML-USG-<ShortName>` | `SML-USG-ReqUSG` = Requirement Usage |
| SysML v2 Diagrams | `SML-DGM-<ShortName>` | `SML-DGM-ReqDiag` = Requirements Diagram |
| arc42 Sections | `ARC-<NN>` (NN = 01–12) | `ARC-01` = Introduction and Goals |

**Short name registry for SML-DEF-\*:**

| ShortName | Full Element |
|-----------|-------------|
| PartDef | part definition |
| ReqDef | requirement definition |
| UCaseDef | use case definition |
| ActDef | action definition |
| StateDef | state definition |
| ItemDef | item definition |
| AttrDef | attribute definition |
| PortDef | port definition |
| ConnDef | connection definition |
| IfaceDef | interface definition |
| AllocDef | allocation definition |
| VCaseDef | verification case definition |
| ConstrDef | constraint definition |
| MetaDef | metadata definition |
| FlowDef | flow definition |
| VpointDef | viewpoint definition |
| Package | package |

**Short name registry for SML-USG-\*:**

| ShortName | Full Element |
|-----------|-------------|
| PartUSG | part usage |
| ReqUSG | requirement usage |
| UCaseUSG | use case usage |
| ActUSG | action usage |
| StateUSG | state usage |
| ItemUSG | item usage |
| AttrUSG | attribute usage |
| PortUSG | port usage |
| ConnUSG | connection usage |
| IfaceUSG | interface usage |
| AllocUSG | allocation usage |
| VCaseUSG | verification case usage |
| Satisfy | satisfy (assert-constraint usage) |
| ItemFlow | item flow usage |

**Short name registry for SML-DGM-\*:**

| ShortName | Full Element |
|-----------|-------------|
| DefDiag | definition diagram |
| ActFlow | action flow diagram |
| ReqDiag | requirements diagram |
| StateDiag | state machine diagram |
| SeqDiag | sequence diagram |

### 5.2 Link Naming Convention

Format: `<source-id>.<edge-type>.<target-id>`

**Examples:**

| Link | Meaning |
|------|---------|
| `SM-PRD-10.implements.SML-DEF-ReqDef` | Requirements are formally represented as `requirement def` in SysML v2 |
| `ARC-01.documents.SM-PRD-10` | Requirements are documented in arc42 section 01 |
| `SM-PRD-14.depends_on.SM-PRD-12` | Use Case Activities require System Use Cases to exist first |
| `SM-PRD-21.refines.SM-PRD-20` | Product Architecture is a concrete refinement of Logical Architecture |
| `SM-PRD-20.realizes.SM-PRD-18` | Logical Architecture realizes the Functional Architecture via allocation |
| `SM-PRD-10.traced_by.SM-PRD-16` | Requirements are traced through Test Cases |
| `SM-PRD-14.maps_to.SML-DGM-ActFlow` | Use Case Activities are visualised using Action Flow Diagrams |
| `SM-PRD-22.validates.SM-PRD-20` | Scenarios validate the Logical Architecture |

### 5.3 Mandatory Link Rules

| Artifact Type | Mandatory Links | Optional Links |
|--------------|----------------|----------------|
| **All Products** | `documents.ARC-<NN>` (at least one) | `refines.SM-PRD-<NN>` |
| **Infrastructure Products** (SM-PRD-01..03) | `documents.ARC-04` | `documents.ARC-08`, `documents.ARC-09` |
| **Problem-Space Products** (SM-PRD-04..09) | `documents.ARC-01` | `documents.ARC-11` (risks), `documents.ARC-02` (constraints) |
| **Requirements** (SM-PRD-10) | `implements.SML-DEF-ReqDef`, `documents.ARC-01`, `traced_by.SM-PRD-16` | `documents.ARC-10` |
| **Context Products** (SM-PRD-11) | `implements.SML-DEF-PartDef`, `documents.ARC-03` | `maps_to.SML-DGM-DefDiag` |
| **Use Case Products** (SM-PRD-12..14) | `implements.SML-DEF-UCaseDef` or `implements.SML-DEF-ActDef` | `maps_to.SML-DGM-ActFlow`, `maps_to.SML-DGM-SeqDiag` |
| **Domain Products** (SM-PRD-15) | `implements.SML-DEF-ItemDef`, `documents.ARC-12` | `describes.domain-vocabulary` |
| **Structural Arch. Products** (SM-PRD-20, SM-PRD-21) | `implements.SML-DEF-PartDef`, `documents.ARC-05` | `maps_to.SML-DGM-DefDiag`, `refines.SM-PRD-<NN>` |
| **Behavioral Products** (SM-PRD-13, SM-PRD-14) | `implements.SML-DEF-ActDef`, `documents.ARC-06` | `maps_to.SML-DGM-ActFlow` |
| **State Products** (SM-PRD-23) | `implements.SML-DEF-StateDef`, `documents.ARC-06` | `maps_to.SML-DGM-StateDiag` |
| **Scenario Products** (SM-PRD-22) | `implements.SML-USG-PartUSG`, `documents.ARC-06` | `maps_to.SML-DGM-SeqDiag`, `validates.SM-PRD-20` |
| **Verification Products** (SM-PRD-16) | `implements.SML-DEF-VCaseDef`, `traced_by.SM-PRD-10` | `maps_to.SML-DGM-ReqDiag` |
| **Test Architecture** (SM-PRD-24) | `implements.SML-DEF-PartDef`, `documents.ARC-07` | `maps_to.SML-DGM-DefDiag` |

### 5.4 Cross-Layer Traceability Table

Complete traceability chain for all 24 products across SYSMOD → SysML v2 → arc42.

| SYSMOD Product | Primary SysML v2 Element | Primary arc42 Section | Cross-Layer Traceability ID |
|---------------|------------------------|----------------------|----------------------------|
| SM-PRD-01 MBSE Methodology | SML-DEF-Package | ARC-04 | `SM-PRD-01↔SML-DEF-Package↔ARC-04` |
| SM-PRD-02 System Modeling Environment | SML-DEF-Package | ARC-04 | `SM-PRD-02↔SML-DEF-Package↔ARC-04` |
| SM-PRD-03 MBSE Training | SML-DEF-Package | ARC-04 | `SM-PRD-03↔SML-DEF-Package↔ARC-04` |
| SM-PRD-04 Problem Statement | SML-DEF-ReqDef | ARC-01 | `SM-PRD-04↔SML-DEF-ReqDef↔ARC-01` |
| SM-PRD-05 System Idea | SML-DEF-ReqDef | ARC-01 | `SM-PRD-05↔SML-DEF-ReqDef↔ARC-01` |
| SM-PRD-06 System Objectives | SML-DEF-ReqDef | ARC-01, ARC-10 | `SM-PRD-06↔SML-DEF-ReqDef↔ARC-01` |
| SM-PRD-07 Base Architecture | SML-DEF-PartDef | ARC-02, ARC-04, ARC-09 | `SM-PRD-07↔SML-DEF-PartDef↔ARC-02` |
| SM-PRD-08 Stakeholders | SML-DEF-PartDef | ARC-01 | `SM-PRD-08↔SML-DEF-PartDef↔ARC-01` |
| SM-PRD-09 Risks | SML-DEF-ReqDef | ARC-11 | `SM-PRD-09↔SML-DEF-ReqDef↔ARC-11` |
| SM-PRD-10 Requirements | SML-DEF-ReqDef | ARC-01, ARC-10 | `SM-PRD-10↔SML-DEF-ReqDef↔ARC-01` |
| SM-PRD-11 System Context | SML-DEF-PartDef | ARC-03 | `SM-PRD-11↔SML-DEF-PartDef↔ARC-03` |
| SM-PRD-12 System Use Cases | SML-DEF-UCaseDef | ARC-01, ARC-03 | `SM-PRD-12↔SML-DEF-UCaseDef↔ARC-03` |
| SM-PRD-13 System Processes | SML-DEF-ActDef | ARC-06 | `SM-PRD-13↔SML-DEF-ActDef↔ARC-06` |
| SM-PRD-14 Use Case Activities | SML-DEF-ActDef | ARC-06 | `SM-PRD-14↔SML-DEF-ActDef↔ARC-06` |
| SM-PRD-15 Domain Knowledge | SML-DEF-ItemDef | ARC-12 | `SM-PRD-15↔SML-DEF-ItemDef↔ARC-12` |
| SM-PRD-16 Test Cases | SML-DEF-VCaseDef | ARC-10, ARC-01 | `SM-PRD-16↔SML-DEF-VCaseDef↔ARC-10` |
| SM-PRD-17 System Architecture *(abstract)* | SML-DEF-Package | ARC-04, ARC-05 | `SM-PRD-17↔SML-DEF-Package↔ARC-05` |
| SM-PRD-18 Functional Architecture | SML-DEF-PartDef | ARC-05 | `SM-PRD-18↔SML-DEF-PartDef↔ARC-05` |
| SM-PRD-19 Physical Architecture *(abstract)* | SML-DEF-PartDef | ARC-05 | `SM-PRD-19↔SML-DEF-PartDef↔ARC-05` |
| SM-PRD-20 Logical Architecture | SML-DEF-PartDef | ARC-05, ARC-09 | `SM-PRD-20↔SML-DEF-PartDef↔ARC-05` |
| SM-PRD-21 Product Architecture | SML-DEF-PartDef | ARC-05, ARC-07 | `SM-PRD-21↔SML-DEF-PartDef↔ARC-05` |
| SM-PRD-22 Scenarios | SML-DGM-SeqDiag | ARC-06 | `SM-PRD-22↔SML-DGM-SeqDiag↔ARC-06` |
| SM-PRD-23 System States | SML-DEF-StateDef | ARC-06, ARC-05 | `SM-PRD-23↔SML-DEF-StateDef↔ARC-06` |
| SM-PRD-24 Test Architecture | SML-DEF-PartDef | ARC-05, ARC-07 | `SM-PRD-24↔SML-DEF-PartDef↔ARC-07` |

---

## Section 6 — Recommended Project Structure

### 6.1 Folder and Package Tree

```
<ProjectName>/
  model/                              ← SysML v2 model root
    <System>_MBSE/                    ← SM-PRD-01, SM-PRD-02, SM-PRD-03
      methodology/                    ← SM-PRD-01 (MBSE Methodology)
      environment/                    ← SM-PRD-02 (SME config)
    <System>_Analysis/                ← SM-PRC-01 outputs
      problem/                        ← SM-PRD-04, SM-PRD-05, SM-PRD-06
      stakeholders/                   ← SM-PRD-08
      risks/                          ← SM-PRD-09
      requirements/                   ← SM-PRD-10
      context/                        ← SM-PRD-11
      use-cases/                      ← SM-PRD-12, SM-PRD-13, SM-PRD-14
      domain/                         ← SM-PRD-15
      test-cases/                     ← SM-PRD-16
    <System>_Architecture/            ← SM-PRC-02 outputs
      base/                           ← SM-PRD-07
      functional/                     ← SM-PRD-18
      logical/                        ← SM-PRD-20
      product/                        ← SM-PRD-21
      states/                         ← SM-PRD-23
      scenarios/                      ← SM-PRD-22
    <System>_Verification/            ← SM-PRD-16, SM-PRD-24
      test-architecture/              ← SM-PRD-24
      test-cases/                     ← SM-PRD-16 (also referenced above)
  docs/                               ← arc42 documentation
    arc42/
      01-introduction-goals.md        ← ARC-01
      02-constraints.md               ← ARC-02
      03-context-scope.md             ← ARC-03
      04-solution-strategy.md         ← ARC-04
      05-building-block-view.md       ← ARC-05
      06-runtime-view.md              ← ARC-06
      07-deployment-view.md           ← ARC-07
      08-crosscutting.md              ← ARC-08
      09-decisions.md                 ← ARC-09
      10-quality.md                   ← ARC-10
      11-risks.md                     ← ARC-11
      12-glossary.md                  ← ARC-12
```

### 6.2 Folder-to-Domain Mapping Table

| Model Folder | SYSMOD Products | Primary arc42 Sections | Primary SysML v2 Packages |
|-------------|----------------|------------------------|--------------------------|
| `<System>_MBSE/` | SM-PRD-01, SM-PRD-02, SM-PRD-03 | ARC-04, ARC-08 | `package <Project>Methodology` |
| `<System>_Analysis/problem/` | SM-PRD-04, SM-PRD-05, SM-PRD-06 | ARC-01 | `package ProblemSpace` |
| `<System>_Analysis/stakeholders/` | SM-PRD-08 | ARC-01 | `package Stakeholders` |
| `<System>_Analysis/risks/` | SM-PRD-09 | ARC-11 | `package Risks` |
| `<System>_Analysis/requirements/` | SM-PRD-10 | ARC-01, ARC-10 | `package Requirements` |
| `<System>_Analysis/context/` | SM-PRD-11 | ARC-03 | `package SystemContext` |
| `<System>_Analysis/use-cases/` | SM-PRD-12, SM-PRD-13, SM-PRD-14 | ARC-01, ARC-03, ARC-06 | `package UseCases`, `package Activities` |
| `<System>_Analysis/domain/` | SM-PRD-15 | ARC-12 | `package DomainKnowledge` |
| `<System>_Analysis/test-cases/` | SM-PRD-16 | ARC-10 | `package TestCases` |
| `<System>_Architecture/base/` | SM-PRD-07 | ARC-02, ARC-04, ARC-09 | `package BaseArchitecture` |
| `<System>_Architecture/functional/` | SM-PRD-18 | ARC-05 | `package FunctionalArch` |
| `<System>_Architecture/logical/` | SM-PRD-20 | ARC-05, ARC-09 | `package LogicalArch` |
| `<System>_Architecture/product/` | SM-PRD-21 | ARC-05, ARC-07 | `package ProductArch` |
| `<System>_Architecture/states/` | SM-PRD-23 | ARC-06, ARC-05 | `package SystemStates` |
| `<System>_Architecture/scenarios/` | SM-PRD-22 | ARC-06 | `package Scenarios` |
| `<System>_Verification/test-architecture/` | SM-PRD-24 | ARC-05, ARC-07 | `package TestArchitecture` |

### 6.3 SysML v2 Package Import Strategy

In SysML v2, packages do not automatically see each other's contents. Every package that uses types from another package **must explicitly import** them. The table below defines the required import relationships between model packages in a SYSMOD-structured project.

#### Import syntax

```sysml
// Public import: all public members of TargetPackage become accessible
import TargetPackage::*;

// Aliased import: access via short alias
import <System>_Domain as Domain;

// Single-element import
import <System>_Domain::EspressoShot;
```

#### Required import matrix

| Package (importer) | Must import | Reason |
|--------------------|-------------|--------|
| `<System>_Context` | `<System>_Domain::*` | Actor and item flow types are domain items |
| `<System>_Context` | `<System>_Analysis/problem::*` | System and actor `part def` may reference problem-space metadata |
| `<System>_Requirements` | `<System>_Context::*` | Interface requirements reference port types from context |
| `<System>_Requirements` | `<System>_Analysis/stakeholders::*` | `@RequirementMeta.source` references stakeholder part defs |
| `<System>_UseCases` | `<System>_Context::*` | Use case `subject` and `actor` are typed by context part defs |
| `<System>_UseCases` | `<System>_Requirements::*` | Use case objective may reference requirements |
| `<System>_Activities` | `<System>_Domain::*` | Item flows in action bodies are typed by domain item defs |
| `<System>_Activities` | `<System>_UseCases::*` | Activity `action def` specializes or references use case defs |
| `<System>_SystemStates` | `<System>_Activities::*` | States are pre/postconditions of activity steps |
| `<System>_SystemStates` | `<System>_LogicalArch::*` | `exhibit state` attaches state machines to logical part defs |
| `<System>_ArchTaxonomy` | — | No imports needed; defines only abstract supertypes |
| `<System>_FunctionalArch` | `<System>_ArchTaxonomy::*` | Functional parts specialize `SystemArchitecture` or `FunctionalArchitecture` |
| `<System>_FunctionalArch` | `<System>_Domain::*` | Functional port types and flow types are domain items |
| `<System>_FunctionalArch` | `<System>_Activities::*` | Functional elements host the action defs from activities |
| `<System>_LogicalArch` | `<System>_ArchTaxonomy::*` | Logical parts specialize `PhysicalArchitecture` |
| `<System>_LogicalArch` | `<System>_FunctionalArch::*` | Allocation defs reference functional elements |
| `<System>_LogicalArch` | `<System>_Requirements::*` | `satisfy` links reference requirement defs |
| `<System>_LogicalArch` | `<System>_Domain::*` | Port and interface types are domain items |
| `<System>_ProductArch` | `<System>_LogicalArch::*` | Product parts specialize or are allocated from logical parts |
| `<System>_ProductArch` | `<System>_Domain::*` | Attribute types and flow types are domain items |
| `<System>_Scenarios` | `<System>_LogicalArch::*` | Lifelines are part usages of logical or product components |
| `<System>_Scenarios` | `<System>_ProductArch::*` | Scenarios exercising the product architecture |
| `<System>_TestArch` | `<System>_ProductArch::*` | SUT is typed by product architecture part defs |
| `<System>_TestArch` | `<System>_Requirements::*` | Verification cases reference requirement defs |
| `<System>_TestCases` | `<System>_TestArch::*` | Test case usages are inside test bench part defs |
| `<System>_TestCases` | `<System>_Requirements::*` | `verify` links reference requirement defs |

#### Canonical import block (place at top of each package file)

```sysml
package CoffeeMachine_LogicalArch {

  // Required imports
  import CoffeeMachine_ArchTaxonomy::*;
  import CoffeeMachine_FunctionalArch::*;
  import CoffeeMachine_Requirements::*;
  import CoffeeMachine_Domain::*;

  // ... part defs follow
}
```

> **Rule:** A package that fails to import its dependencies will produce unresolved-type errors. Import failures are the most common root cause of model inconsistency in SysML v2 textual notation projects.

---

## Section 7 — System Decomposition Strategy

### 7.1 Four-Level Decomposition Table

| Level | Name | SYSMOD Products | SysML v2 Construct | arc42 Section | Description |
|-------|------|-----------------|--------------------|--------------|-------------|
| **L0** | System Context | SM-PRD-11 | `part def <System>`, `part def <Actor>`, `connection def`, `interface def`, `item flow` | ARC-03 | System boundary and all external interfaces; actors and item flows enter/leave the system here. |
| **L1** | Functional Architecture | SM-PRD-18 | `part def <FunctionalElement>`, `action def <FunctionBehavior>`, `port def`, `flow def` | ARC-05 Level 1 | Technology-independent functional decomposition; functional elements transform input flows to output flows. |
| **L2** | Logical Architecture | SM-PRD-20 | `part def <LogicalComponent>`, `port def <Interface>`, `connection def`, `interface def`, `allocation def` | ARC-05 Level 2 | Technology-principle-level architecture; reusable across product families; connected via typed ports and interfaces. |
| **L3** | Product Architecture | SM-PRD-21 | `part def <PhysicalComponent>` (concrete, non-abstract), `attribute def`, `attribute usage`, `part usage` | ARC-05 Level 3, ARC-07 | Concrete physical implementation; all parts are instantiable; lowest level in the system model. |
| **L4** | Component Detail | (part of SM-PRD-21) | `part usage`, `attribute usage`, `perform action`, `exhibit state`, `satisfy requirement` | ARC-05 Level 3+ | Fine-grained internal specification of individual components; connects to engineering sub-models. |

### 7.2 Specialization and Subsetting Rules

**Subclassification (`:>` — general specialization):**
- `part def LogicalController :> LogicalComponent` — LogicalController is a more specific kind of LogicalComponent; all features of LogicalComponent are inherited.
- Use `:>` when the specialized definition is an ISA refinement of its parent with no feature overrides.

**Subsetting (`::>` — feature subsetting):**
- `part actuator ::> component` — the `actuator` part usage subsets the `component` usage; actuator's values are a subset of component's values in the same context.
- Use `::>` when a feature in a specialization participates in the same value pool as a feature in the general type.

**Redefinition (`:>>` — feature redefinition):**
- `part :>> engine : ElectricMotor` — redefines `engine` inherited from `Vehicle` with a more specific type `ElectricMotor`.
- Use `:>>` when a specialization must replace an inherited feature with a different (more specific) type or multiplicity.

### 7.3 Allocation Chain: Functional → Logical → Physical

The allocation chain traces functional responsibility through the architecture levels:

```sysml
// Step 1: Functional element defined (SM-PRD-18)
part def FunctionalElement {
    action def ProcessInput;
}

// Step 2: Logical component allocated from functional element (SM-PRD-20)
allocation def FunctionalToLogicalAllocation {
    end part source : FunctionalElement;
    end part target : LogicalComponent;
}

// Step 3: Concrete product part specializes logical component (SM-PRD-21)
part def ConcreteProcessor :> LogicalComponent;

// Step 4: Satisfaction link from product part to requirement (SM-PRD-10)
part def SystemDesign {
    part proc : ConcreteProcessor;
    satisfy processingRequirement by proc;
}
```

**Allocation rules:**
- Functional Architecture → Logical Architecture: `allocation def` with `SML-DEF-AllocDef`; maps functional elements to logical components.
- Logical Architecture → Product Architecture: `part def <Product> :> <Logical>` (strong coupling via subclassification) OR `allocation def <LogicalToProduct>` (loose coupling).
- Requirements → Architecture: `satisfy <requirement> by <part>` using `SML-USG-Satisfy`.
- Test Cases → Requirements: `verification def` with `verify <requirement>` in the objective body using `SML-DEF-VCaseDef`.

### 7.4 Diagram Selection Guide

| SYSMOD Product | Recommended Diagram Type | SML-DGM ID | What to Show |
|---------------|-------------------------|------------|--------------|
| SM-PRD-11 System Context | Definition Diagram | SML-DGM-DefDiag | `part def <System>`, `part def <Actor>`, `connection def`, `item flow` |
| SM-PRD-12 System Use Cases | Requirements Diagram | SML-DGM-ReqDiag | `use case def`, actors, extend/include relationships |
| SM-PRD-13 System Processes | Action Flow Diagram | SML-DGM-ActFlow | Ordered `use case` usages as action steps, successions, decision nodes |
| SM-PRD-14 Use Case Activities | Action Flow Diagram | SML-DGM-ActFlow | `action def`, `action usage`, succession and flow arrows, control nodes |
| SM-PRD-10 Requirements | Requirements Diagram | SML-DGM-ReqDiag | `requirement def`, `requirement usage`, `satisfy`, hierarchy |
| SM-PRD-16 Test Cases | Requirements Diagram | SML-DGM-ReqDiag | `verification def`, `verify`, `satisfy` links |
| SM-PRD-18 Functional Architecture | Definition Diagram | SML-DGM-DefDiag | `part def` (functional), `port def`, `flow def` |
| SM-PRD-20 Logical Architecture | Definition Diagram | SML-DGM-DefDiag | `part def` (logical), `port def`, `interface def`, `allocation def` |
| SM-PRD-21 Product Architecture | Definition Diagram | SML-DGM-DefDiag | `part def` (concrete), `attribute def`, `part usage` |
| SM-PRD-22 Scenarios | Sequence Diagram | SML-DGM-SeqDiag | Part usage lifelines, messages, event occurrences |
| SM-PRD-23 System States | State Machine Diagram | SML-DGM-StateDiag | `state def`, states, transitions, triggers, guards, effects |

---

## Source File References

| Domain | Index File |
|--------|-----------|
| SYSMOD Products | [`../sysmod/products/`](../sysmod/products/) |
| SYSMOD Methods | [`../sysmod/methods/index.md`](../sysmod/methods/index.md) |
| SYSMOD Processes | [`../sysmod/processes/`](../sysmod/processes/) |
| SysML v2 Concepts | [`../sysml2/concepts/`](../sysml2/concepts/) |
| SysML v2 Diagrams | [`../sysml2/diagrams/index.md`](../sysml2/diagrams/index.md) |
| arc42 Sections | [`../arc42/sections/`](../arc42/sections/) |
| ISO 15288 Mapping | [`../sysmod/references/iso-15288-mapping.md`](../sysmod/references/iso-15288-mapping.md) |
