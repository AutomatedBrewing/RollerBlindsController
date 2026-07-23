---
type: SysML v2 Diagram
title: Package Diagram
description: A Package Diagram shows the organization of model elements into packages, the membership relationships between packages and their owned elements, and import relationships between packages.
timestamp: 2026-07-01T00:00:00Z
---

The Package Diagram is the SysML v2 diagram type used to organize a model into packages and show the structural relationships between packages and their member elements. It is the top-level organizational view of a SysML v2 model.

A package is a kind of namespace that is used solely as a container for other elements to organize the model. In addition to packages, all kinds of SysML definitions and usages are also namespaces.

# Purpose

Package diagrams are used to:
- Show the decomposition of a model into packages and sub-packages.
- Show ownership (member) relationships between packages and their elements.
- Show import relationships between packages.
- Show alias relationships, where a package introduces an alias name for an element.
- Filter packages that use recursive import and filter conditions to automatically contain sets of elements identified by metadata.

# Notation

## Package Symbol

A package is shown as a rectangle with the package name. Two notations are valid:
- **Name in body**: The package name appears inside the rectangle body.
- **Name in tab**: The package name appears in a tab at the top-left of the rectangle, and the body shows the contents.

```
Package1
```

## Ownership and Membership

Owned members of a package are shown nested inside the package rectangle. Membership relationships can also be shown as directed lines from the owning package to the member.

## Import

An import relationship is shown as a directed dashed line with the `«import»` (or `«private import»`) stereotype from the importing namespace to the imported namespace. Import notation variants:
- No star: element import (specific element).
- Single star (`*`): package import (public content of a package).
- Double star (`**`): recursive import (all nested namespaces included).

## Aliases

An alias membership is shown with the `«alias»` stereotype label inside the package, with the alias name and the original element name.

## Visibility

Membership visibility is indicated by the keywords `public`, `protected`, or `private` placed before the member declaration in the textual notation.

# Frame and Header

The diagram frame has a header with the diagram kind identifier and the diagram name. The diagram kind identifier for a package diagram is typically `pkg`.

# Compartments

Packages displayed as graphical symbols may include a **members compartment** that lists member elements using textual or graphical notation:

```
Package1
  members
    part def PartDef1
    part def PartDef2
    part part1 : PartDef1
    part part2 : PartDef2
```

# Examples

A model showing a top-level package containing two sub-packages:

```
package SystemModel {
    package Requirements;
    package Architecture;
}
```

An import relationship:
```
package Q {
    public import P::*;
    private import Library::*;
}
```

# Related Concepts

- [Name Resolution](../rules/name-resolution.md)
- [Definition-Usage Pattern](../rules/definition-usage-pattern.md)

# Citations

[1] OMG SysML v2 Specification, §7.5.1 (Namespaces Overview)
[2] OMG SysML v2 Specification, §7.5.2 (Owned Members and Aliases)
[3] OMG SysML v2 Specification, Table 3 (Packages – Representative Notation)
