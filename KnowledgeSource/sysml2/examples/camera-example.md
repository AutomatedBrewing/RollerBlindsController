---
type: SysML v2 Example
title: Camera Example
description: Demonstrates SysML v2 action decomposition by showing how a Camera part delegates picture-taking actions to specialized focusing and imaging subsystems.
timestamp: 2026-07-01T00:00:00Z
---

This example models a Camera part definition that performs a `takePicture` action specializing the `PictureTaking::takePicture` action. The Camera is decomposed into a `focusingSubsystem` that performs the `focus` step and an `imagingSubsystem` that performs the `shoot` step, showing how SysML v2 allocates action steps to structural parts.

# Source

```sysml
part def Camera {
	private import PictureTaking::*;
	
	perform action takePicture[*] :> PictureTaking::takePicture;
	
	part focusingSubsystem {
		perform takePicture.focus;
	}
	
	part imagingSubsystem {
		perform takePicture.shoot;
	}
	
}
```

# Key Concepts Demonstrated

- [`part def`](../concepts/part-def.md) — defining a Camera classifier that owns behavioral features
- [`perform action`](../concepts/action.md) — assigning an action usage to a part, with multiplicity `[*]`
- [Action specialization `:>`](../concepts/action.md) — specializing `takePicture` from the imported `PictureTaking` package
- [Action step delegation](../concepts/action.md) — nested parts each `perform` a named step of the parent action (`takePicture.focus`, `takePicture.shoot`)
- [Package import](../concepts/import.md) — `private import PictureTaking::*` brings action definitions into scope

# Notes

- The pattern `perform takePicture.focus` inside `focusingSubsystem` is a SysML v2 idiom for allocating a specific action step to a structural subsystem, keeping behavior and structure tightly linked without a separate allocation table.
- The `[*]` multiplicity on `takePicture` means the camera can perform the action an unbounded number of times.
- This is a minimal, self-contained example that demonstrates behavior-to-structure allocation — one of the most commonly used patterns in SysML v2 system modeling.

# Citations

[1] OMG SysML v2 Specification, Annex A (example models)
