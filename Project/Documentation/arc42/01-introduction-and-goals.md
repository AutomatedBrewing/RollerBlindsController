# 1. Introduction and Goals

> Rendered from `model/Analysis/problem`, `model/Analysis/stakeholders`,
> `model/Analysis/requirements`. Source of truth: `.sysml` files under `model/`.

## 1.1 Requirements Overview

**Problem** (`ProblemStatement::NeedForConvenientShutterOperation`): residential
roller shutters are often manually operated only, limiting convenience and
integration with home automation. Scope: residential/light building-automation
retrofit where a wall switch already exists; new-build wiring, commercial/
industrial systems, and multi-shutter scene control are explicitly out of
scope.

**System Idea** (`SystemIdea::systemIdea`): the Window Roller Shutter
Controller (WRSC) is a compact controller enabling local (wall switch) and
remote (home automation) control of a roller shutter, using time-based
(sensorless) positioning for cost-effectiveness and ease of install, with
per-installation configurable timing.

**Top-level functional requirements** (`model/Analysis/requirements/Requirements.sysml`,
package `L0_Requirements`):

| Req ID | Title | Priority | Source Stakeholder |
|---|---|---|---|
| REQ-F-01 | controlRollerShutter — control shutter movement | mandatory | Manufacturer, User |
| REQ-F-02 | localControl — local control via wall switch | mandatory | User |
| REQ-F-03 | remoteControl — remote control via home automation | mandatory | User |
| REQ-F-04 | fullShutterMovement — automatic full open/close | mandatory | User |
| REQ-F-05 | manualPositioning — intermediate positioning | recommended | User |
| REQ-F-06 | stopShutterMovement — stop on request | mandatory | User |
| REQ-F-07 | configurableTimingProfile — per-install travel time config (≤120 s) | mandatory | Installer, Manufacturer |
| REQ-F-08 | configurationMode — explicit, signaled config mode | mandatory | Installer |
| REQ-I-01 | wallSwitchWiringCompatibility — momentary + latching wiring | mandatory | Installer |
| REQ-I-02 | remoteControlWiringCompatibility — dry-contact UP/DOWN, no protocol | mandatory | User |
| REQ-E-01 | regulatedDisposal — WEEE/RoHS compliant disposal | mandatory | DisposalFacility |

Interface, Quality, and Safety requirements are elaborated in
[10-quality-requirements.md](10-quality-requirements.md); the Environmental
requirement is cross-referenced in
[11-risks-and-technical-debts.md](11-risks-and-technical-debts.md).

## 1.2 Quality Goals

Top quality attributes, per `L0_Requirements::Quality`/`Safety` (mandatory
priority unless noted) and `SystemObjectives`:

| Rank | Quality Goal | Requirement | Motivation |
|---|---|---|---|
| 1 | Safety | REQ-S-01 (SELV ≤50V, galvanic isolation), REQ-S-02 (conflict indication) | Mains-switching device; UP+DOWN conflict must never energize the motor and must be observable |
| 2 | Reliability | REQ-Q-03 (≥10,000 cycles) | Mitigates RISK-T-03 (motor relay wear-out) |
| 3 | Availability | REQ-Q-02 (≥99.8% uptime, rolling 12 months) | Core to `SystemObjectives::reliability` |
| 4 | Ease of Installation | REQ-Q-01 (≤30 min first-time install) | Mitigates RISK-T-05 (misconfiguration) |
| 5 | Diagnosability / Field Replaceability | REQ-Q-04, REQ-Q-05 | Supports UC_04 field maintenance without lab equipment or wiring changes |

Affordability (`SystemObjectives::affordability`, mandatory) is realized as a
BOM-level design constraint rather than a testable quality scenario — see
[02-architecture-constraints.md](02-architecture-constraints.md) and ADR-001.

## 1.3 Stakeholders

Source: `model/Analysis/stakeholders/Stakeholders.sysml`.

| Role / Name | Contact | Expectations |
|---|---|---|
| Manufacturer | — (`part def Manufacturer`) | Low unit cost (`CostConcern`); operation in typical residential/outdoor conditions (`OperatingConditions`) |
| User | — (`part def User`) | Convenient shutter control (`ShutterControllerExistence`); compact form factor fitting a ⌀60 flush-mount box (`MinimalSize`); high availability, reliability, safety, and observable conflict indication (`Availability`, `Reliability`, `SafetyConcern`, `ConflictIndicationConcern`) |
| Installer | — (`part def Installer`) | Fast installation (`DurationOfInstallation`, ≤30 min); reconfigurable without disassembly (`EaseOfConfiguration`) |
| Maintenance Technician | — (`part def MaintenanceTechnician`) | Field-diagnosable faults without lab equipment (`Diagnosability`); on-site repair/replace using existing wiring (`FieldReplaceability`) |
| Disposal Facility | — (`part def DisposalFacility`) | WEEE/RoHS-compliant disposability (`RegulatedDisposability`) |

No contact/organizational data is modeled beyond the stakeholder role itself
(`Stakeholder` concerns only) — the "Contact" column is intentionally left as
a role marker (`—`), not fabricated.
