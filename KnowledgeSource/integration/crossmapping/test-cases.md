---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Test Cases
description: Full SysML v2 and arc42 mapping for SYSMOD product Test Cases (SM-PRD-16).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Test Cases (SM-PRD-16)

Test Cases close the engineering V-loop by specifying how to verify that the system satisfies its Requirements. Each Test Case is a behavioral specification returning a pass/fail verdict. SYSMOD distinguishes Model Test Cases (verifying the model's internal consistency) from System Test Cases (verifying the real system). Both are first-class artifacts in the system model, formally linked to requirements via `verify` relationships.

## §1 SysMod Definition

**Product ID:** SM-PRD-16
**SYSMOD §:** 5.16
**Process:** [Analysis](../../sysmod/processes/analysis-process.md) (SM-PRC-1)
**Creating Method:** [4.16 Specify Test Cases](../../sysmod/methods/specify-test-cases.md) (SM-MTH-16)
**Responsible Role:** [System Tester](../../sysmod/roles/system-tester.md)

### Purpose
Test Cases specify the acceptance criteria for each Requirement in an executable, model-based form. They ensure that requirements are verifiable and that verification results are traceable back into the system model. By expressing test cases as SysML `verification case def` elements, the entire verification process becomes part of the model rather than an external test management document.

### Role in Process
In the Analysis process (SM-PRC-1), Test Cases are specified alongside or immediately after Requirements (SM-PRD-10). They are organized and executed within the Test Architecture (SM-PRD-24). A completed Test Case set confirms that the requirements specification is complete and testable — requirements with no test case signal incomplete or unverifiable specifications.

### Inputs

| # | Artifact | ID | Description |
|---|----------|----|-------------|
| 1 | Requirements | SM-PRD-10 | Each requirement is the direct verification target of one or more test cases |
| 2 | Use Case Activities | SM-PRD-14 | UCA sub-functions define the system operations exercised under test |
| 3 | Domain Knowledge | SM-PRD-15 | Item types used as test inputs, stimuli, and expected output values |
| 4 | Test Architecture | SM-PRD-24 | Organizes test cases into suites and provides the test harness context |

### Outputs / Dependent Artifacts

| # | Artifact | ID | How Used |
|---|----------|----|----------|
| 1 | Test Architecture | SM-PRD-24 | Test cases are organized into suites and allocated to test infrastructure |
| 2 | Requirements | SM-PRD-10 | Closed loop: completed TCs confirm that each requirement is verifiable |

### Dependencies
- **Requires:** SM-PRD-10 (Requirements) — every test case must `verify` at least one requirement.
- **Benefits from:** SM-PRD-14 (Use Case Activities) — activity models define the expected system behavior under test.
- **Organized by:** SM-PRD-24 (Test Architecture) — test cases are allocated to test suites and test environments.

---

## §2 SysML v2 Mapping

### Mapping Table

| SYSMOD Concept | SysML v2 Element | Node ID | Rationale |
|----------------|-----------------|---------|-----------|
| Test Case | `verification case def` | [SML-DEF-VCaseDef](../../sysml2/concepts/verification-case-definition.md) | Dedicated SysML v2 behavioral classifier for verification |
| Test execution instance | `verification case` usage | SML-USG-VCaseUSG | Usage instantiates a case for a specific subject under test |
| Link to requirement | `verify` relationship | — | Formal traceability link from verification case to requirement def |
| Design satisfies requirement | `satisfy` relationship | [SML-USG-Satisfy](../../sysml2/concepts/satisfy.md) | Links a design element to the requirement it satisfies |
| Test type + method annotation | `metadata def TestCaseMeta` | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Captures test type, verification method, and verdict as model metadata |
| Requirements traceability | Requirements Diagram | [SML-DGM-ReqDiag](../../sysml2/diagrams/requirements-diagram.md) | Shows verify/satisfy links: test cases ↔ requirements ↔ design elements |
| Test execution steps | Action Flow Diagram | [SML-DGM-ActFlow](../../sysml2/diagrams/action-flow-diagram.md) | Specifies setup/execute/verify steps as a typed action flow |
| Test package | `package` | [SML-DEF-Package](../../sysml2/concepts/package.md) | Groups all verification case definitions per system |

### Modeling Pattern

```sysml
package VehicleSystem_TestCases {

  metadata def TestCaseMeta {
    attribute testType           : String; // systemTestCase | modelTestCase
    attribute verificationMethod : String; // test | analysis | inspection | demonstration
    attribute verdict            : String; // pass | fail | inconclusive
  }

  verification case def TC_001_EmergencyBrakingResponse {
    doc /* Verify that emergency braking responds within 200 ms under nominal conditions */
    @TestCaseMeta {
      testType           = "systemTestCase";
      verificationMethod = "test";
    }
    subject sut : VehicleControlSystem;
    objective   : verify REQ_001_SafetyResponseTime;

    action setup {
      doc /* Set vehicle speed to 80 km/h; road surface = dry asphalt; nominal sensor health */
    }
    action execute {
      doc /* Depress brake pedal > 80% travel within 50 ms */
    }
    action verifyOutcome {
      doc /* Measure elapsed time from pedal input to full brake application; must be ≤ 200 ms */
    }
    return verdict : VerdictKind;
  }

  verification case def TC_002_ABSActivation {
    doc /* Verify ABS activates when wheel slip exceeds 15% on a wet surface */
    @TestCaseMeta {
      testType           = "systemTestCase";
      verificationMethod = "test";
    }
    subject sut : VehicleControlSystem;
    objective   : verify REQ_002_ABSSafety;

    action setup   { doc /* Road surface = wet; initial speed = 60 km/h */ }
    action execute { doc /* Apply emergency brake; maintain pressure for 2 s */ }
    action verifyOutcome {
      doc /* Confirm ABS modulation cycle begins within 100 ms of wheel slip detection */
    }
    return verdict : VerdictKind;
  }

  verification case def TC_003_NormalBrakingDeceleration {
    doc /* Verify normal braking achieves target deceleration within tolerance */
    @TestCaseMeta {
      testType           = "systemTestCase";
      verificationMethod = "test";
    }
    subject sut : VehicleControlSystem;
    objective   : verify REQ_003_NormalBrakingPerf;

    action setup   { doc /* Speed = 50 km/h; road surface = dry; pedal travel = 40% */ }
    action execute { doc /* Apply steady brake pedal input for 3 s */ }
    action verifyOutcome {
      doc /* Achieved deceleration ≥ 3.5 m/s² within 500 ms of pedal application */ }
    return verdict : VerdictKind;
  }
}
```

### Recommended Package Structure

```
<System>_Verification/
  test_cases/
    <System>_TestCases.sysml              ← All verification case defs + TestCaseMeta
    <System>_VerificationMatrix.sysml     ← Requirements diagram views (verify/satisfy links)
```

---

## §3 arc42 Mapping

| arc42 Section | Node ID | Usage | Mandatory? |
|---------------|---------|-------|-----------|
| [Quality Requirements](../../arc42/sections/quality-requirements.md) | ARC-10 | Test cases serve as acceptance scenarios for quality goals; each quality scenario maps to one or more test cases | **MANDATORY** |
| [Building Block View](../../arc42/sections/building-block-view.md) | ARC-05 | Test cases reference specific components (subject under test); component IDs should match ARC-05 Level 1 block names | Optional |
| [Risks and Technical Debts](../../arc42/sections/risks-and-technical-debts.md) | ARC-11 | Requirements with no test case or coverage gaps are logged as technical debts | Optional |

**Placement guidance:** In ARC-10, organize test cases by the quality attribute they verify (performance, safety, reliability, availability). Reference the SysML package path and `verification case def` name. In ARC-05, annotate components with the list of test case IDs that validate them.

---

## §4 Traceability

### Incoming Links

| From Node | ID | Relationship | Description |
|-----------|----|--------------|-------------|
| Requirements | SM-PRD-10 | `depends_on` | Every test case verifies one or more requirements via `verify` |
| Use Case Activities | SM-PRD-14 | `depends_on` | Activities define the behavioral context and expected system actions under test |
| Domain Knowledge | SM-PRD-15 | `depends_on` | Item types used as test input stimuli and acceptance threshold values |
| Test Architecture | SM-PRD-24 | `depends_on` | Provides organizational structure, execution environment, and test harness |

### Outgoing Links

| To Node | ID | Relationship | Description |
|---------|----|--------------|-------------|
| Test Architecture | SM-PRD-24 | `implements` | Test cases are organized into suites within the test architecture |
| Requirements | SM-PRD-10 | `implements` | Closed verification loop: confirms each requirement is testable |
| ARC-10 Quality Requirements | ARC-10 | `documents` | Quality scenarios in ARC-10 are backed by formal test case specifications |
| ARC-05 Building Block View | ARC-05 | `documents` | Test cases annotate the components and subsystems they validate |

### Traceability Rules

1. Every Requirement (SM-PRD-10) MUST have at least one `verification case def` linked via `verify`.
2. Every `verification case def` MUST carry `@TestCaseMeta` with `testType` and `verificationMethod` populated.
3. Every `verification case def` MUST specify a `subject` typed by the system-under-test classifier.
4. Every `verification case def` MUST contain at least three action usages: `setup`, `execute`, and `verifyOutcome`.
5. arc42 ARC-10 MUST list each test case by ID with: requirement reference, verification method, acceptance criterion, and SysML package path.

---

## §5 Modeling Procedure

1. **Build the test case register** — retrieve all requirement definitions from SM-PRD-10; create a register table mapping each requirement ID to one or more planned test case IDs with planned verification method.
2. **Classify by verification method** — assign `verificationMethod` to each test case: `test` (physical execution), `analysis` (computational or formal proof), `inspection` (structured review), or `demonstration` (observable behavior without measurement).
3. **Classify by test type** — assign `testType`: `systemTestCase` (real physical system) or `modelTestCase` (model-in-the-loop, SIL, or HIL).
4. **Create `verification case def` entries** — write one `verification case def` per test case with `@TestCaseMeta`; fill in `subject` (typed by the system classifier) and `objective : verify <REQ_ID>`.
5. **Define test steps** — add `action` usages for `setup`, `execute`, and `verifyOutcome`; provide concrete, measurable acceptance criteria in each `doc` string (numerical thresholds, timing limits, observable conditions).
6. **Add `verify` relationships** — link each verification case to the requirement definition(s) it covers using `verify`; ensure every requirement has coverage.
7. **Add `satisfy` links** — link design elements (from SM-PRD-18, SM-PRD-20, SM-PRD-21) to the requirements they satisfy using `satisfy`.
8. **Generate Requirements Diagram (SML-DGM-ReqDiag)** — create a traceability matrix view showing all `verify` and `satisfy` links for stakeholder review.
9. **Register in arc42 ARC-10** — add each test case to the quality scenarios table with requirement ID, method, criterion, and SysML package reference.

---

*See also:* [OKF Ontology](../okf-ontology.md) · [Requirements cross-mapping](requirements.md) (SM-PRD-10) · [Test Architecture cross-mapping](test-architecture.md) (SM-PRD-24)
