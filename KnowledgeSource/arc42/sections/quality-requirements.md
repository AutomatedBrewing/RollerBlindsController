---
type: arc42 Section
title: Quality Requirements
description: Specifies quality goals with concrete quality scenarios that define measurable acceptance criteria for the architecture.
timestamp: 2026-07-01T00:00:00Z
---

The Quality Requirements section elaborates the top quality goals identified in Section 1 into concrete, measurable quality scenarios. While Section 1 names the quality attributes at a high level, this section makes them testable by describing specific situations in which the system's quality can be observed and evaluated against acceptance criteria.

Quality scenarios follow a well-established structure: they describe a stimulus (what happens), the system's required response (what the system must do), and the response measure (how well it must do it). For example, a performance scenario might state that when 1000 concurrent users submit a request, the system must respond within 2 seconds for 95% of requests. This specificity transforms vague quality goals into verifiable architecture requirements.

The section contains two subsections: the Quality Requirements Overview, which may use a quality tree or similar structure to organise and prioritise the full set of quality requirements; and the Quality Scenarios subsection, which lists the individual scenarios. Together they form the quality contract against which the architecture can be validated.

# Schema

| Subsection | Content |
|------------|---------|
| Quality Requirements Overview | Structured overview of all quality requirements, typically as a quality tree or prioritised list |
| Quality Scenarios | Individual quality scenarios each with stimulus, response, and response measure |

**Quality scenario structure:**

| Field | Description |
|-------|-------------|
| Stimulus | The event or condition that triggers the quality measurement |
| System response | How the system reacts to the stimulus |
| Response measure | The measurable criterion that defines acceptable quality (e.g., latency threshold, error rate) |

# Relationships

* [Introduction and Goals](introduction-and-goals.md) — Quality goals stated at a high level in Section 1 are elaborated into scenarios here.
* [Architecture Decisions](architecture-decisions.md) — Quality scenarios often motivate or justify specific architecture decisions documented in Section 9.

# Citations

[1] [arc42 Template](../references/arc42-template.md)
