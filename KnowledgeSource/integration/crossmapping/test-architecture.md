---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Test Architecture
description: Full SysML v2 and arc42 mapping for SYSMOD product Test Architecture (SM-PRD-24).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Test Architecture (SM-PRD-24)

The Test Architecture specifies the test environment setup — how the System Under Test (SUT) is physically integrated with test systems, test equipment, and test context actors. In SYSMOD, the Test Architecture is a Physical Architecture specialized for testing: it is a peer of the Product Architecture (SM-PRD-21) but differs in purpose — it defines the structural environment in which Test Cases (SM-PRD-16) are executed rather than the product itself. Test systems are systems in their own right and may be separately specified. The Test Architecture uses the SYSMOD stereotypes «testContext» and «systemUnderTest», realized in SysML v2 as `metadata def`.

## §1 SysMod Definition

**Product ID:** SM-PRD-24  
**SYSMOD §:** 5.24  
**Process:** [Architecture](../../sysmod/processes/architecture-process.md) (SM-PRC-2)  
**Creating Method:** [4.22 Model the Test Architecture](../../sysmod/methods/model-test-architecture.md) (SM-MTH-22)  
**Responsible Role:** [System Tester](../../sysmod/roles/system-tester.md)

### Purpose

The Test Architecture serves three purposes: (1) **Test environment specification** — it formally specifies how the SUT is connected to each test system, making the test setup reproducible and unambiguous; (2) **Interface traceability** — every test interface point traces back to a physical interface in the Product Architecture, ensuring the test environment accesses the system through realistic interfaces; and (3) **Test architecture as a system** — test equipment (simulators, data loggers, test harnesses) are modelled as `part def` elements in their own right, enabling the test environment to be version-controlled, reviewed, and reused across test campaigns.

### Role in Process

In the Architecture process (SM-PRC-2), Method 4.22 (Model the Test Architecture) is executed after the Product Architecture (SM-PRD-21) is sufficiently concrete to identify physical test interface points, and after Test Cases (SM-PRD-16) have identified the stimulus/response pairs that the test environment must support. The System Tester: (1) identifies all test interface points on the SUT (derived from SM-PRD-21 ports); (2) identifies required test equipment for each test case type; (3) defines the test context — the top-level container holding SUT and all test equipment; (4) specifies physical connections between SUT ports and test equipment ports; and (5) documents the test deployment topology in arc42 (ARC-07).

### Inputs (table)

| # | Input Artifact | ID | Description |
|---|---|---|---|
| 1 | Product Architecture | SM-PRD-21 | Defines the SUT: its `part def` structure, physical ports, and component specifications |
| 2 | Logical Architecture | SM-PRD-20 | Defines the abstract interface contracts the test architecture must exercise |
| 3 | Test Cases | SM-PRD-16 | Test cases specify stimulus/response pairs that dictate what test equipment is needed |
| 4 | Scenarios | SM-PRD-22 | Key scenarios reveal which interaction patterns the test environment must support |
| 5 | Requirements | SM-PRD-10 | Non-functional test requirements (e.g., HIL accuracy, measurement uncertainty) |

### Outputs / Dependent Artifacts (table)

| # | Dependent Artifact | ID | Relationship |
|---|---|---|---|
| 1 | Test Cases | SM-PRD-16 | Test cases are executed within the Test Architecture; the test context is referenced in each test case |

### Dependencies

- **SM-PRD-21 (Product Architecture):** The SUT `part def` specializes the Product Architecture's top-level assembly. Every test interface point MUST correspond to a physical port in SM-PRD-21.
- **SM-PRD-20 (Logical Architecture):** Logical interface contracts define the minimum interface coverage that the test architecture must achieve — every logical port must be exercisable via a test equipment connection.
- **SM-PRD-16 (Test Cases):** Test case specifications drive the selection and specification of test equipment. Each unique test technique (HIL, signal injection, bus monitoring) requires a corresponding test equipment `part def`.

---

## §2 SysML v2 Mapping

### Mapping Table

| SYSMOD Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| «testContext» stereotype | `metadata def TestContextMeta` | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Replaces SYSMOD stereotypes; annotates `part def` elements with their test role |
| System Under Test | `part def SystemUnderTest :> <ProductAssembly>` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Specializes the Product Architecture top-level assembly; adds test observation ports |
| Test equipment (generic) | `part def <TestEquipment>` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Each test system (HIL, logger, test harness) is a `part def` in its own right |
| Test context (top-level container) | `part def <System>TestContext` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Holds SUT and all test equipment; annotated `@TestContextMeta { contextType = "testContext" }` |
| Test interface port | `port def` | [SML-DEF-PortDef](../../sysml2/concepts/port-definition.md) | Test-specific port added to the SUT for observation (OBD, JTAG, bus monitoring) |
| Test connection | `connection def` | [SML-DEF-ConnDef](../../sysml2/concepts/connection-definition.md) | Formalizes the physical link between SUT port and test equipment port |
| Test case type | `verification case def` | [SML-DEF-VCaseDef](../../sysml2/concepts/verification-case-definition.md) | Defines the type of verification performed in the test architecture |
| Test setup view | Definition Diagram | [SML-DGM-DefDiag](../../sysml2/diagrams/definition-diagram.md) | Shows the full test context structure: SUT, test equipment, and their connections |
| Test equipment port | `port def` | [SML-DEF-PortDef](../../sysml2/concepts/port-definition.md) | Input/output points on test equipment matching the SUT's test interface ports |

### Modeling Pattern

```sysml
package VehicleSystem_TestArchitecture {

  // Metadata replaces SYSMOD stereotypes «testContext», «systemUnderTest», «testEquipment»
  metadata def TestContextMeta {
    attribute contextType : String;
    // Valid values: "testContext" | "systemUnderTest" | "testEquipment"
  }

  // Test-specific port types
  port def OBD2Port {
    attribute protocol  : String  = "ISO 15765-2";
    attribute baudRate  : Integer = 500000; // bps
  }
  port def CANAnalyzerPort {
    attribute channels  : Integer = 2;
    attribute maxRate   : Real    = 5.0;  // Mbps (CAN FD)
  }
  port def VehicleSignalPort {
    attribute signalCount : Integer;
    attribute voltageRange : String = "0-12V";
  }
  port def PowerSupplyPort {
    attribute nominalVoltage : Real = 12.0; // V
    attribute maxCurrent     : Real = 20.0; // A
  }

  // System Under Test — specializes the Product Architecture (SM-PRD-21)
  part def SystemUnderTest :> VehicleControlSystem_Product {
    @TestContextMeta { contextType = "systemUnderTest"; }
    doc /* SUT is the production Product Architecture with test observation ports added */
    port ecuOBD2       : OBD2Port;          // diagnostic access port
    port canMonitor    : CANAnalyzerPort;   // CAN bus monitoring tap
    port testPowerIn   : ~PowerSupplyPort;  // controlled power supply input
  }

  // Test equipment: Hardware-in-the-Loop simulator
  part def HIL_Simulator {
    @TestContextMeta { contextType = "testEquipment"; }
    doc /* Hardware-in-the-Loop simulator providing virtual sensors, loads, and vehicle bus signals */
    attribute vendor        : String = "dSPACE";
    attribute model         : String = "MicroAutoBox III";
    attribute ioChannels    : Integer = 64;
    port vehicleSignals     : VehicleSignalPort { attribute signalCount = 32; }
    port canChannel1        : CANAnalyzerPort;
    port canChannel2        : CANAnalyzerPort;
    port hilPowerOut        : PowerSupplyPort;
  }

  // Test equipment: CAN data logger
  part def CANDataLogger {
    @TestContextMeta { contextType = "testEquipment"; }
    doc /* Records all CAN frames on monitored channels for post-test analysis */
    attribute vendor        : String = "Vector";
    attribute model         : String = "CANalyzer 12";
    port loggerCAN1         : ~CANAnalyzerPort;
    port loggerCAN2         : ~CANAnalyzerPort;
  }

  // Test equipment: OBD2 diagnostic tool
  part def OBD2DiagnosticTool {
    @TestContextMeta { contextType = "testEquipment"; }
    doc /* Reads and clears diagnostic trouble codes; reads live data streams */
    attribute vendor        : String = "Bosch";
    attribute model         : String = "KTS 590";
    port obdConnector       : ~OBD2Port;
  }

  // Top-level test context — the full test environment
  part def VehicleSystemTestContext {
    @TestContextMeta { contextType = "testContext"; }
    doc /* Complete test environment for VehicleControlSystem integration testing */

    part sut    : SystemUnderTest;
    part hil    : HIL_Simulator;
    part logger : CANDataLogger;
    part obd2   : OBD2DiagnosticTool;

    // SUT ↔ HIL connections
    connect sut.canMonitor       to hil.canChannel1;
    connect hil.vehicleSignals   to sut.vehicleSignalPort;
    connect hil.hilPowerOut      to sut.testPowerIn;

    // SUT ↔ Logger connections
    connect sut.canMonitor       to logger.loggerCAN1;
    connect hil.canChannel2      to logger.loggerCAN2;

    // SUT ↔ OBD2 connection
    connect sut.ecuOBD2          to obd2.obdConnector;
  }

  // Verification case type: functional integration test
  verification case def FunctionalIntegrationTest {
    doc /* Verifies that a functional requirement is satisfied in the test context */
    subject sut : SystemUnderTest;
  }

  // Verification case type: fault injection test
  verification case def FaultInjectionTest {
    doc /* Injects a fault via HIL and verifies the SUT's fault response */
    subject sut : SystemUnderTest;
    actor  hil  : HIL_Simulator;
  }
}
```

### Recommended Package Structure

```
<System>_Verification/
  test_architecture/
    <System>_TestArchitecture.sysml          ← Test context, SUT, and test equipment part defs
    <System>_TestInterfaces.sysml            ← Test-specific port def and connection def types
    <System>_VerificationCases.sysml         ← verification case def types for this system
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Relationship | Content Contributed |
|---|---|---|---|
| [Deployment View](../../arc42/sections/deployment-view.md) | ARC-07 | **Mandatory** | Test deployment topology: SUT node + each test equipment node + physical connections; annotated with connection types and protocols |
| [Building Block View](../../arc42/sections/building-block-view.md) | ARC-05 | **Mandatory** | Test building blocks as a parallel building block tree alongside the product building blocks; SUT as a building block with its test observation interfaces |
| [Architecture Decisions](../../arc42/sections/architecture-decisions.md) | ARC-09 | Recommended | Test equipment selection decisions; HIL vs. SIL vs. physical test bench trade-off; test interface protocol choices |
| [Cross-cutting Concepts](../../arc42/sections/cross-cutting-concepts.md) | ARC-08 | Recommended | Test architecture patterns applied across multiple test campaigns; metadata annotation conventions for test roles |
| [Quality Requirements](../../arc42/sections/quality-requirements.md) | ARC-10 | Recommended | Quality scenarios for test environment itself (e.g., HIL timing accuracy, logger data rate) |

---

## §4 Traceability

### Incoming Links (table)

| Source ID | Source Name | Link Type | Description |
|---|---|---|---|
| SM-PRD-19 | Physical Architecture [abstract] | `refines` | Test Architecture is a concrete child of Physical Architecture specialized for verification |
| SM-PRD-21 | Product Architecture | `depends_on` | SUT `part def` specializes the Product Architecture; all SUT ports derive from product ports |
| SM-PRD-20 | Logical Architecture | `depends_on` | Logical interface contracts define the minimum test coverage target |
| SM-PRD-16 | Test Cases | `depends_on` | Test case specifications drive the selection of test equipment types |
| SM-PRD-22 | Scenarios | `depends_on` | Key scenarios define interaction patterns the test environment must support |

### Outgoing Links (table)

| Target ID | Target Name | Link Type | Description |
|---|---|---|---|
| SM-PRD-16 | Test Cases | `implements` | Test cases are executed within this test architecture; the test context is the execution environment |
| ARC-07 | Deployment View | `documents` | Test deployment topology (SUT + test equipment + connections) documented in ARC-07 |
| ARC-05 | Building Block View | `documents` | Test building blocks (SUT, HIL, logger, etc.) appear as a parallel tree in ARC-05 |

### Traceability Rules

1. Every physical port in the Product Architecture (SM-PRD-21) that is exercised by any Test Case (SM-PRD-16) MUST be accessible from the Test Architecture — either as a port on the `SystemUnderTest` `part def` or via a test equipment connection.
2. Every test equipment `part def` MUST carry a `@TestContextMeta` annotation with `contextType = "testEquipment"`.
3. The `SystemUnderTest` `part def` MUST specialize the Product Architecture top-level assembly (`part def SystemUnderTest :> <ProductAssembly>`).
4. Every `port` connection in the Test Context MUST be typed — no untyped connections are permitted. Port types must be compatible (conjugate `~` used correctly).
5. Every `verification case def` MUST reference at least one `subject` part from the Test Architecture and be traceable to at least one Test Case (SM-PRD-16).
6. Every arc42 ARC-07 test deployment node MUST correspond to a `part def` in the Test Architecture; no ARC-07 node may be undocumented in the model.

---

## §5 Modeling Procedure

1. **Identify test interface points on the SUT.** Starting from the Product Architecture (SM-PRD-21), enumerate every physical port that Test Cases (SM-PRD-16) must access. Categorize them by access type: diagnostic (OBD2, JTAG), signal monitoring (CAN tap, oscilloscope probe), stimulus injection (signal generator, power supply, HIL channel), and data logging. These become test-specific ports added to the `SystemUnderTest` `part def`.

2. **Define the `TestContextMeta` metadata and test port types.** Create `metadata def TestContextMeta` with a `contextType` attribute. Create `port def` types for each unique test interface protocol (OBD2, CAN analyzer, HIL signal, power supply). These are test-domain types distinct from the production interface types in SM-PRD-21.

3. **Define the System Under Test.** Create `part def SystemUnderTest :> <ProductAssembly>`. Add all test observation ports identified in step 1. Do not remove or modify any production ports from the Product Architecture — only add test-specific ports. Annotate with `@TestContextMeta { contextType = "systemUnderTest" }`.

4. **Specify test equipment `part def` elements.** For each category of test equipment identified in step 1, create a `part def` with: (a) vendor and model attributes; (b) typed ports matching the SUT test interface ports (using conjugate `~` for receiving ends); (c) capacity attributes (channel count, measurement range, data rate); (d) `@TestContextMeta` annotation. Model each test equipment type as a separate `part def` even if multiple units of the same type exist.

5. **Assemble the test context.** Create `part def <System>TestContext` annotated with `@TestContextMeta { contextType = "testContext" }`. Add `part` usages for the SUT and all test equipment. Add `connect` statements for every test interface connection. Verify that every test port on the SUT has exactly one connection to a test equipment port — unconnected SUT test ports indicate missing test equipment.

6. **Define verification case types.** Create `verification case def` types for each distinct test technique used (functional integration test, fault injection test, performance test, environmental test). Each type specifies the `subject` (SUT) and any `actor` (test equipment actively controlling the test). These types are instantiated in SM-PRD-16 (Test Cases).

7. **Validate coverage.** For every Test Case in SM-PRD-16, trace the stimulus/response path through the Test Architecture. Verify that: (a) the stimulus can be injected via a connected test equipment port, (b) the response can be observed or measured via a connected monitoring port, and (c) any fault injection required is supported by the HIL configuration. Missing coverage gaps require adding test equipment or test ports.

8. **Document in arc42.** Draw the test deployment topology in ARC-07 (Deployment View) showing: SUT node, each test equipment node, communication links with protocol labels, and power supply connections. Add the test building block tree in ARC-05 as a parallel view alongside the product building block view. Record test equipment selection rationale in ARC-09 (Architecture Decisions).
