# Window Roller Shutter Controller model
This directory contains model for window roller shutter controller.

## Structure
Folder structure is organized based on SYSMOD process outputs (Analysis → Architecture →
Verification), following guidelines from the SYSMOD book (by Tim Weilkiens). One SysML v2
file per SYSMOD product. Since this repository models a single system, the `<System>_`
prefix recommended by SYSMOD for file/folder names is omitted for brevity — package names
inside each file remain fully qualified regardless of file path.

arc42 is treated as the *target publication format* rendered from this model — not a
parallel folder structure. arc42 sections are populated from `doc` blocks and metadata
annotations already present in the model elements below.

```
model/
  Analysis/                SYSMOD Analysis process outputs
    problem/                 Problem Statement, System Idea, System Objectives
    stakeholders/            Stakeholders and their concerns
    risks/                   Risks
    requirements/            System requirements
    context/                 System Context (external actors, interfaces)
    use_cases/                System Use Cases
    processes/                System Processes (use case ordering)
    use_case_activities/      Use Case Activities (functional decomposition)
    domain/                   Domain Knowledge (not yet modelled)
  Architecture/             SYSMOD Architecture process outputs
    base/                     Base Architecture + architectural constraints
    functional/               Functional Architecture
    logical/                   Logical Architecture
    product/                   Product Architecture
    states/                    System States (SystemStates.sysml)
    scenarios/                 Scenarios
  Verification/             Verification-related outputs
    test_cases/                Test Cases / Verification
    test_architecture/         Test Architecture (not yet modelled)
  Traceability/             Cross-cutting derivation links between all products
```

See `KnowledgeSource/integration/okf-ontology.md §6` and
`KnowledgeSource/integration/crossmapping/<product>.md §2` for the full SYSMOD ↔ SysML v2
↔ arc42 mapping rationale behind this structure.