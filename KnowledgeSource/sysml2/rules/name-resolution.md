---
type: SysML v2 Rule
title: Name Resolution and Scoping
description: An unqualified name used within a namespace body is resolved in the context of that namespace and potentially other namespaces in which it is lexically nested, taking into account imported and inherited memberships.
timestamp: 2026-07-01T00:00:00Z
---

Name resolution is the process of determining the element identified by a qualified name. A namespace is a kind of element that can contain other elements and provide names for them. The elements contained in a namespace are referred to as its member elements.

# Rule Statement

The following rules govern name resolution and scoping in SysML v2:

1. **Qualified names** use `::` as the separator between namespace segments. A qualified name is a sequence of segment names separated by `::`, of which all but the last must identify namespaces.

2. **Unqualified name resolution**: An unqualified name used within the body of a namespace is resolved in the context of that namespace and, potentially, other namespaces in which the first namespace is lexically nested, taking into account imported (see §7.5.3) and inherited (see §7.6) memberships.

3. **Qualified name resolution**: A qualified name with more than one segment is resolved by recursively resolving the name of the qualifying namespace and then resolving the element name in that context.

4. **Imports**: An import relationship allows one namespace to import memberships from another namespace. Imported member elements become unowned members of the importing namespace in addition to being members of the imported namespace. Members of an imported namespace can then be referenced without qualification within the scope of the importing namespace.
   - `import Package::*` imports public members of `Package`.
   - `import Package::**` imports recursively, including all nested namespaces.
   - Imports can be `public`, `protected`, or `private`.

5. **Visibility**: The visibility of a membership can be `public` (default, visible outside the namespace), `protected` (special meaning for inheritance in definitions and usages), or `private` (not visible outside the namespace).

6. **Aliases**: A namespace may introduce an alias name for an element. An element may have both owning and non-owning memberships with the same namespace, but can have at most one owning membership across all namespaces.

7. **Name conflicts**: All inherited features must have names that are distinct from each other and from any owned features. Name conflicts from multiple inheritance can be resolved by redefining one or more of the conflicting inherited features.

8. **Feature chains** use `.` (dot) notation and resolve subsequent names as public members of the previously resolved usage (see §7.6.6).

# Rationale

Namespaces and scoping rules allow models to be organized into packages and definitions without ambiguity. Qualified names ensure that elements can be uniquely identified across a model regardless of how they are organized.

# Examples

```
package P {
    public part def A;
    private attribute def B;
    part a : A;  // public by default
}

package Q {
    import P::*;  // imports A and a, but not B
    part q : A;   // A is resolved without qualification
}

package Package1 {
    package Package2 {
        part def PartDef3;
    }
}
// Qualified reference:
// Package1::Package2::PartDef3
```

# Violations

- Referencing a private member of a namespace from outside that namespace.
- Using an unqualified name that is ambiguous due to multiple memberships in the resolution scope.
- Using `::` notation to navigate through a feature path (must use `.` feature chains for that purpose).

# Related Concepts

- [Feature Chains](feature-chains.md)
- [Specialization Rules](specialization-rules.md)
- [Definition-Usage Pattern](definition-usage-pattern.md)

# Citations

[1] OMG SysML v2 Specification, §7.5.1 (Namespaces Overview)
[2] OMG SysML v2 Specification, §7.5.2 (Owned Members and Aliases)
[3] OMG SysML v2 Specification, §7.5.3 (Imports)
