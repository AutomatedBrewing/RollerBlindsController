# 11. Risks and Technical Debt

> Rendered from `Project/Model/Analysis/risks/Risks.sysml`
> (`@RiskMeta`: probability × impact → severity matrix) and
> `// GAP:` comments in `Project/Model/Architecture/scenarios/Scenarios.sysml`.

## Risk Register

| ID | Category | Risk | Prob. | Impact | Severity | Status | Owner | Mitigation |
|---|---|---|---|---|---|---|---|---|
| RISK-T-01 | Technical | Positioning drift (no position feedback → cumulative timing error) | medium | medium | **major** | open | System Architect | +5s open/close margin (`timingMarginS`); see [08](08-cross-cutting-concepts.md) Concept 2 |
| RISK-T-03 | Technical | Motor relay/triac wear-out under repeated switching | medium | medium | **major** | open | Hardware Engineer | ≥10,000-cycle rated components; validated by `TC_Q_003_ReliabilityEndurance` |
| RISK-T-04 | Technical | Shutter motor type incompatibility (speed/torque variance defeats one fixed timing profile) | medium | medium | **major** | open | System Architect | Per-installation configurable `TravelTime`; validated by `TC_F_012_ConfigurableTimingProfile_Nominal` |
| RISK-T-05 | Technical | Installer misconfiguration during timing calibration | medium | low | **minor** | open | System Architect | Guided config-mode procedure + out-of-range calibration rejection (`RejectOutOfRangeCalibration`, Scenarios::SCEN_22); validated by `TC_Q_001_InstallationTime` |
| RISK-S-01 | Safety | Insufficient galvanic isolation → electric shock hazard | low | high | **critical** (escalated) | open | Safety Engineer | Mandatory `motorIsolation`/`inputIsolation` constraints; validated by `TC_B_001`/`TC_B_002`/`TC_B_006` |
| RISK-B-01 | Business | Isolation/switching-load components push unit cost above 50 PLN target | medium | medium | **major** | open | Project Manager | Early sourcing engagement; track vs. `Business::costEffective` |
| RISK-I-01 | Integration | Wall-switch wiring topology incompatibility (momentary vs. latching) | medium | medium | **major** | open | System Architect | Documented topologies + configurable input mode; validated by `TC_F_002`/`TC_F_003` |

**Note on severity escalation (RISK-S-01):** the standard probability×impact
matrix would yield *major* for low×high; severity is escalated one level to
**critical** by explicit project convention whenever impact is a
safety-of-life hazard (ALARP-style treatment), per the risk's own
`rationale` field.

**Note on numbering:** there is no `RISK-T-02` — a gap in the ID sequence in
`Risks.sysml`, not a missing/removed risk.

All 7 risks remain `status = open`; none are `mitigated` or `closed` in the
current model.

## Technical Debt (Documented Model Gaps)

Explicit `// GAP:` comments in `Scenarios.sysml` mark intentionally
unresolved modeling detail — deferred by choice, not defect:

| Scenario | Gap |
|---|---|
| SCEN_15 (`PowerLoss_DuringMovement`) | No Logical/Product component observes, logs, or reacts to a control-power interruption; relay de-energization is a passive electrical consequence, not modeled behavior. No distinction between "stopped by timeout" and "stopped by power loss." |
| SCEN_16 (`PowerRecovery_AfterOutage`) | No modeled function re-establishes the shutter's physical position after power loss/recovery (ADR-003's no-position-feedback decision means no sensor exists to query); firmware boot/re-init is inferred generic MCU behavior, not a traceable model element. |
| SCEN_17 (`MechanicalJam_TimeBasedStopWithoutFeedback`) | No fault classification, indication, or recovery mechanism distinguishes a mid-travel mechanical jam from normal end-of-travel completion; the only recovery path is user-initiated re-calibration. |
| SCEN_21 (`DisposeController_EndOfLife`) | `UseCaseActivities::DisposeController` remains an intentionally underspecified single-action stub at the UCA layer (UC_05); the disposal scenario's steps are inferred from UC_05 metadata rather than a decomposed UCA. |
| SCEN_23 (`LocalControl_WiringModeMismatch`) | No existing UCA action models wiring-mode-mismatch **detection** specifically (recorded three times — in the scenario's header doc, step `s3`, and the trailing scenario-level comment); closest anchor is `HandleConflictingMovementCommands`. |

SCEN_05's former gap (no structural owner for the "latched-stopped-until-release"
guard) was resolved by the Software Architecture remediation (SWR-022/SWR-030):
`ProductComponents::CommandArbitrationSoftware` is the named owner — see
`Architecture/states/SystemStates.sysml`'s `MovingManual` doc.

These gaps are cross-cutting with RISK-T-01 (SCEN_15, SCEN_17) and
RISK-I-01 (SCEN_23) — they are the concrete scenario-level manifestations
of the risk register's open items, not independent defects.

## Software Architecture Technical Debt

- **ADR prose tightening (deferred by design):** `ADR_009_SWExecutionModel`
  and `ADR_010_InputDebouncing` match the existing `ADR_001`–`008` prose
  style (4–8 sentence fields) rather than a tighter target. This is a
  deliberate, documented deferral (`Architecture/software/REMEDIATION_PLAN.md`
  item 17) — retroactively tightening every existing ADR's prose is a
  separate, explicitly-scoped cleanup pass, not silently dropped.
