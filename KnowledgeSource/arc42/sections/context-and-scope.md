---
type: arc42 Section
title: Context and Scope
description: Defines the system boundary and describes all external interfaces in both business and technical terms.
timestamp: 2026-07-01T00:00:00Z
---

The Context and Scope section establishes what is inside the system under consideration and what lies outside it. It draws a clear system boundary and enumerates all external actors, systems, and channels that the system communicates with. This boundary definition is foundational: every other architectural view depends on a shared understanding of where the system ends and its environment begins.

The section is split into two complementary subsections. The Business Context describes external interfaces from a domain perspective, using the language of the business rather than technical detail. It may take the form of a context diagram or a table, optionally accompanied by an explanation of each external domain interface. The Technical Context refines the picture by showing the actual technical protocols, data formats, and channels through which the system exchanges information with its environment, including a mapping of input and output to specific communication channels.

Together these two subsections ensure that both business stakeholders and technical architects have a consistent view of the system's external relationships, reducing misunderstandings at integration boundaries.

# Schema

| Subsection | Content |
|------------|---------|
| Business Context | Diagram or table showing external partners and communication relationships from a business/domain perspective; optional explanation of external domain interfaces |
| Technical Context | Diagram or table of technical interfaces; explanation of protocols and data formats; mapping of inputs and outputs to communication channels |

**Business Context elements:**

| Element | Description |
|---------|-------------|
| Diagram or Table | Visual or tabular representation of the system and its external neighbours |
| External domain interfaces | Optional explanation of each communication partner and the information exchanged |

**Technical Context elements:**

| Element | Description |
|---------|-------------|
| Diagram or Table | Technical view of channels and protocols |
| Technical interfaces | Explanation of technical protocols and data formats |
| Mapping Input/Output to Channels | Table or description mapping each data flow to its transport mechanism |

# Relationships

* [Building Block View](building-block-view.md) — External interfaces defined here are implemented by building blocks visible at the whitebox level in Section 5.
* [Deployment View](deployment-view.md) — Technical channels identified here map to infrastructure elements described in Section 7.

# Citations

[1] [arc42 Template](../references/arc42-template.md)
