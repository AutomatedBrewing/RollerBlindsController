# 3. Context and Scope

> Rendered from `model/Analysis/context/Context.sysml` (package `SystemContext`).

## 3.1 Business Context

External actors interacting with `BaseArchitecture::ShutterController`
(`SystemContext::SystemContextDiagram`):

| Actor | Relationship | Description |
|---|---|---|
| `WallSwitch` | User → local control channel | Local dry-contact wall switch operated by the User |
| `HomeAutomationSystem` | User → remote control channel | External automation/relay system issuing UP/DOWN dry-contact signals |
| `ControlPowerSupply` | Power provider | Supplies 12 VDC logic power |
| `MainsPowerSupply` | Power provider | Supplies 230 VAC mains, switched onward to the motor |
| `WindowRollerShutter` | Actuated device | Receives switched mains drive signals (ROLLER UP/DOWN) |
| `User` | Stakeholder | Operates via `WallSwitch`/`HomeAutomationSystem` |
| `Manufacturer`, `Installer`, `MaintenanceTechnician`, `DisposalFacility` | Stakeholders | Connected abstractly (no engineering signal) to `shutterController` for their respective lifecycle concerns |

## 3.2 Technical Context

Boundary ports on `SystemContext::SystemContextDiagram::shutterController`,
typed by port defs declared in `SystemContext`:

| Port | Port Def | Direction | Carries |
|---|---|---|---|
| `localCtrl` | `DryContactControlPort` | in (conjugated) | UP/DOWN dry-contact booleans from `WallSwitch` |
| `remoteCtrl` | `DryContactControlPort` | in (conjugated) | UP/DOWN dry-contact booleans from `HomeAutomationSystem` |
| `controlPower` | `ControlPowerPort` | in (conjugated) | 12 V DC logic supply (`nominalVoltage = 12 V`) |
| `mainsPower` | `MainsPowerPort` | in (conjugated) | 230 V AC mains (`nominalVoltage = 230 V`) |
| `shutterDrive` | `ShutterDrivePort` | out | Switched ROLLER UP/ROLLER DOWN mains outputs to `WindowRollerShutter` |

**Channel mapping:**

| Input/Output | Channel | Protocol/Format |
|---|---|---|
| Local UP/DOWN command | `localCtrl` ← `WallSwitch.ctrl` | Dry-contact voltage presence (no protocol stack) |
| Remote UP/DOWN command | `remoteCtrl` ← `HomeAutomationSystem.ctrl` | Dry-contact/relay voltage presence, electrically/behaviorally equivalent to local (REQ-I-02) |
| Logic power | `controlPower` ← `ControlPowerSupply.supply` | 12 VDC ±10% (`L0_Constraints::Electrical::supplyVoltage`) |
| Mains power | `mainsPower` ← `MainsPowerSupply.supply` | 230 VAC (`L0_Constraints::Electrical::switchingLoad`) |
| Motor drive | `shutterDrive` → `WindowRollerShutter.drive` | Switched mains outputs, ROLLER UP / ROLLER DOWN |

No home-automation communication protocol (Zigbee, Z-Wave, MQTT, etc.) is
implemented or required — confirmed by REQ-I-02 and ADR-005 (no dedicated
cybersecurity artifact, since every external interface is dry-contact/relay
based with no protocol stack).
