# Escapement Estimate Type report review triage — 2026-03-19

Repo/worktree: `/Users/alan/.openclaw/workspace/tmp/escapement-report-integration-20260319`

## Summary

This pass triaged all comments from Erika Anderson (EA) and Michael Arbeider / Isabella Borea (MA/IB), applied the low-regret source edits that were straightforward to justify, rebuilt the report, and ran the paper-skill citation audit.

### Bucket counts

- **Accept directly / applied now:** 16
- **Accept with adaptation / applied in a narrower form:** 11
- **Substantive decision still needed:** 6

## 1) Accept directly / applied now

| IDs | Reviewer | Suggestion | Resolution in this pass |
|---|---|---|---|
| EA [0] | EA | Clarify what “estimate” means in the opening framing | Revised abstract/introduction wording to say estimate Types classify how interpretable a **spawner abundance estimate** is. |
| EA [6] | EA | Define qualifier codes earlier | Added plain-language definition: standardized codes that record why a classification was conservatively downgraded. |
| EA [9] | EA | Hyatt bullets may read like direct quotes | Rewrote as prose paraphrase rather than quote-like bullets. |
| EA [11] | EA | Table reference missing | Replaced fragile cross-reference wording with plain “Table 1” text; rebuilt DOCX and did not reproduce “Reference source not found”. |
| EA [13] | EA | Prefer “Absolute abundance (census)” style wording | Renamed Type 1 label to **“Absolute abundance (census / near-census)”**. |
| EA [40] | EA | Heading needs edit after legacy-term paragraph | Inserted spacing and retitled the heading to **“NuSEDS data dictionary alignment (selected fields)”**. |
| EA [46] | EA | Date/source Figure 2 | Updated Figure 2 caption and surrounding text to describe the all-area SEN extract and 1990–2025 year filter; Appendix D now records provenance. |
| EA [61] | EA | “SEN-first” unclear | Added an explicit definition of **SEN-first** and contrasted it with site/CU-context extensions. |
| EA [66], MA [66] | EA, MA | WSP_RAPID_STATUS_YN overemphasized / tenuous | Removed it as a recommended candidate field; replaced with a note that a dedicated rapid-status flag is **not recommended** here without active governance. |
| MA [1], MA [19] | MA | Use newer rapid-status citations, not Holt 2009 | Replaced rapid-status-specific Holt 2009 cites with **Pestal et al. 2023** and **DFO 2024/004**; added both entries to `bib/refs.bib`. |
| MA [39] | MA | “(varies)” is too vague in metadata table | Replaced vague entries with explicit phrases (component-level qualifiers + integration rule; calibration diagnostics / revision metadata; revision metadata / audit trail). |
| MA [58] | MA | Define provisional / max / candidate type | Added a short definition block in the toolkit section explaining these intermediate toolkit terms and distinguishing them from the final estimate type. |
| EA [124] | EA | Table 10 needs context and in-text reference | Expanded the Appendix C.3 lead-in/caption and referenced the lookup in the main text. |
| EA [126] | EA | Appendix D feels empty / unclear | Reworked Appendix D into a provenance appendix with a source-and-processing table plus an interpretation note. |
| EA [115], EA [120] | EA | Sankey screenshots crop labels | Adjusted Sankey plotting margins/label placement to reduce text cropping at figure edges. |
| EA [58], EA [63], MA [17] | EA, MA | Positive comments / no requested change | No source change needed; retained as-is. |

## 2) Accept with adaptation / applied in narrower form

| IDs | Reviewer | Suggestion | Adapted resolution |
|---|---|---|---|
| EA [7] | EA | Wording implies imminent historical reclassification | Softened to say the report supports **forward use** and clearer interpretation of legacy terms, not a blanket historic reclassification exercise. |
| EA [24] | EA | Toolkit disclaimer feels overemphasized | Kept the distinction, but softened the wording: the report is authoritative guidance and the toolkit is the operational companion implementation. |
| EA [37] | EA | Method-family table order unclear | Kept current order (aligned to family short codes used throughout the report/toolkit) and added a sentence explaining that ordering choice. |
| EA [48] | EA | Qualify Shiny URL if needed | Revised wording to say a **current ShinyApps.io deployment** is available at that URL, rather than implying a permanent/public guarantee. |
| EA [50] | EA | Generalize STREAM / bulk-upload wording | Reworded to “SEN and, where applicable, corresponding NuSEDS bulk-upload workflow fields,” rather than hard-coding STREAM details. |
| EA [70] | EA | “Version NuSEDS” is too broad | Narrowed the wording to versioning of the **guidance / toolkit logic / thresholds / qualifier rules**, not NuSEDS as a whole. |
| MA [33], MA [34] | MA, IB | Calibration wording may imply downstream rule changes | Kept calibration as metadata, but explicitly added that the report does **not** prescribe automatic legacy reclassification or a downstream assessment rule for calibrated series. |
| MA [45] | MA | Redd survey reaching Type 2 needs clarification | Kept the existing upper bound for now, but added explicit caveat text that Type 2 is only intended where a validated spawners-per-redd conversion and documentation are available. |
| MA [62], MA [63] | MA, IB | Are SEN optional fields analyst-downloadable? | Added a scope note: the report states what should be captured for interpretation; analyst-facing export availability is an implementation question outside report scope. |
| EA [15] | EA | Generic capitalization/style of “estimate type” | Smoothed some wording locally, but did **not** do a full style sweep; this remains mostly a style preference rather than a technical blocker. |
| MA [42] | MA | Resistivity handling feels only partly aligned | Added an explicit note in Appendix C that the current resistivity mapping is provisional and may warrant a dedicated post-processing/validation term in future revisions. |

## 3) Substantive decision still needed

| IDs | Reviewer | Issue | Why left unresolved |
|---|---|---|---|
| MA [42] | MA | Whether resistivity should sit under fixed-site census vs a more sonar/post-processing-like path | This is a genuine modelling/specification question for the guidance + toolkit logic, not a safe editorial-only fix. I only added a provisional note. |
| MA [43] | MA | Toolkit reportedly allows Visual Count to reach Candidate/Max Type 1 while table caps visual family lower | Needs joint review of the toolkit path logic versus the report table; not justified to change one side unilaterally in this pass. |
| MA [44] | MA | Whether aerial methods coupled to high-quality survey-life estimates should ever reach Type 2 | This is a policy/classification boundary question with downstream consequences; no source change made without broader agreement. |
| EA [108] | EA | Appendix B qualifier-code table readability / landscape suggestion | Could be improved with a broader layout redesign, but that is a formatting pass rather than a safe surgical fix. |
| EA [114], EA [119] | EA | Landscape orientation for large Appendix C tables | Same as above: probably desirable, but it needs broader CSAS/bookdown layout work and was not safe to force quickly. |
| EA [15] | EA | Full global style decision on “estimate type” capitalization | Minor but still open if the group wants a formal house style; only local cleanup was done here. |

## Source edits applied

Edited files:

- `index.Rmd`
- `01_introduction.Rmd`
- `02_methods.Rmd`
- `03_results.Rmd`
- `04_discussion.Rmd`
- `05_appendix.Rmd`
- `bib/refs.bib`

Main content changes:

1. Clarified opening framing, qualifier-code language, and legacy-term wording.
2. Replaced rapid-status citations with `pestal2023stateSalmon` and `dfo2024rapidStatus`.
3. Added toolkit intermediate-term definitions (provisional / max / candidate type).
4. Softened wording around calibration / historical roll-up implications.
5. Clarified SEN-first and generalized bulk-upload wording.
6. Removed emphasis on `WSP_RAPID_STATUS_YN` as a recommended field.
7. Improved Figure 2 provenance and populated Appendix D.
8. Expanded Appendix C.3 context and improved Sankey figure label margins.
9. Added provisional notes for resistivity and redd-count edge cases.
10. Replaced fragile `\@ref(...)` prose references that were confusing the citation audit and at least one reviewer-facing DOCX render.

## Build + audit status

### Build

- **HTML:** passed via `bookdown::render_book("index.Rmd", output_format = "bookdown::gitbook")`
- **DOCX:** passed via `csasdown::render(output_format = "csasdown::techreport_docx")`
- **PDF:** not available through the installed `csasdown` package in this environment (`techreport_pdf` is not exported), so no PDF artifact was produced

### Citation audit

Paper-skill audit rerun completed successfully after the cross-reference cleanup:

- Run dir: `notes/artifacts/citation-audit/runs/20260319-090418-escapement-report-integration-20260319`
- Hard-rule status: **passed** (`hard_rule_failed: false`)

Residual audit note:

- `hyatt1997` is still flagged in `source_needed_queue.jsonl` as lacking a DOI/URL-backed full-text artifact in the local audit library. That did **not** fail the hard rule, but if the team wants a cleaner evidence pack later, that source should be rehydrated into the citation-audit library.

## Commit / handoff

- Local commit created: **Integrate reviewer feedback into estimate type report**
- Exact commit hash should be reported from the final handoff summary (to avoid note/HEAD self-reference drift after amend).
