---
type: SysML v2 Example
title: Rationale Metadata Example
description: Demonstrates SysML v2 metadata annotations by attaching a Rationale metadata instance to a selected engine part, referencing a trade study analysis.
timestamp: 2026-07-01T00:00:00Z
---

This example shows how to use the `ModelingMetadata::Rationale` metaclass to annotate a model element (`engine4cyl`) with explanatory text and a cross-reference to a trade study analysis (`engineTradeOffAnalysis`). The trade study itself is defined as an `analysis` usage typed by `TradeStudy`, with candidate alternatives and a returned selection.

# Source

```sysml
package RationaleMetadataExample {
	private import ModelingMetadata::Rationale;
	
    /* Example: the following provides the rationale for selecting the engine4cyl based on a trade study analysis. 
    The rationale could be contained in the vehicle configuration with the selected engine */
    
    part engine;
    part engine4cyl :> engine;
    part engine6cyl :> engine;
    
    metadata engineSelectionRationale : Rationale about engine4cyl {
    	text = "This rationale for selecting the engine4cyl refers to the engineTradeOffAnalysis.";
    	explanation = engineTradeOffAnalysis;
    }
    
    private import TradeStudies::*;
    analysis engineTradeOffAnalysis:TradeStudy{
        subject alternatives :> engine [2] = (engine4cyl, engine6cyl);

        /* ... */
        
        return selectedEngine :> engine;
     }
}
```

# Key Concepts Demonstrated

- [`metadata`](../concepts/metadata.md) — attaching a typed metadata instance to a model element using `about`
- [`Rationale` metaclass](../concepts/metadata.md) — standard SysML v2 modeling metadata type for recording design rationale
- [`analysis` usage](../concepts/analysis.md) — defining an analysis case typed by `TradeStudy`
- [`subject`](../concepts/analysis.md) — declaring the subject alternatives of the trade study
- [`return`](../concepts/analysis.md) — specifying the output of an analysis (the selected alternative)
- [Part specialization `:>`](../concepts/part.md) — `engine4cyl` and `engine6cyl` as specializations of `engine`

# Notes

- The `metadata ... about <element>` construct is SysML v2's mechanism for annotating any model element with typed metadata without modifying the element itself — a clean separation of concerns.
- The `explanation` feature of `Rationale` is set to the analysis usage reference, establishing a navigable cross-reference from the rationale to the supporting trade study.
- This pattern supports model-based rationale capture, making design decisions traceable directly within the SysML model rather than in external documents.

# Citations

[1] OMG SysML v2 Specification, Annex A (example models)
