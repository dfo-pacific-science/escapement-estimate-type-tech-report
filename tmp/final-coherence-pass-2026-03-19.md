# Final coherence pass — 2026-03-19

## Bottom line

**Yes — the report and toolkit now make sense together from first principles.**

The key logic is now aligned around a stable interpretation:
- **Type 1** remains an **interpretive absolute-abundance / census / near-census class**, not just a raw method label.
- **Method families** describe the primary survey/acquisition context; **analysis / estimation methods** modify but do not erase that base family.
- **Aerial + AUC** stays conservative: AUC can be recorded as an analysis method for aerial series, but the **A-family ceiling remains Type 3** by default.
- **Default redd-count** is no longer treated as a default absolute-abundance / Type 2 path; the default redd family is now **capped at Type 3**.
- **Resistivity** remains within **FS / fixed-site census** rather than being spun out as a new family; the wording now tells users to carry attribution / validation / detection-correction detail in the explanation fields.
- **Final Type** is now clearly separated from toolkit-internal **Max / Provisional / Candidate** trace values.

## Main decisions enforced in this pass

1. **Aerial + AUC**
   - kept conservative in both report and toolkit
   - no default Type 2 aerial path added
   - appendix/app wording now explicitly says AUC inherits the underlying survey family and aerial-family outputs remain capped at Type 3

2. **Redd count**
   - removed the default Type 2 redd path from the toolkit
   - updated report wording and appendix notes so plain/default redd-count is treated conservatively
   - any higher-confidence redd-derived abundance estimate is now described only as an **explicit non-default calibrated/model-based exception**, not the default `R` interpretation

3. **Resistivity**
   - kept in **FS**
   - removed wording that implied the report was leaning toward a new dedicated resistivity family/path
   - aligned report notes, toolkit notes, and app helper text around “stay in FS; capture validation/attribution detail in explanation fields”

4. **Type 1 terminology / upload semantics**
   - aligned report and toolkit around interpretive Type 1 language
   - clarified that **Final Type** is the official upload/classification result
   - clarified that **Max / Provisional / Candidate** are internal QA trace values only

## Reviewer-comment status relevant to this pass

### Incorporated here
- **MA [42] resistivity placement / wording** — resolved conservatively in favor of FS with clearer wording.
- **MA [44] aerial AUC concern** — resolved conservatively by allowing AUC as an analysis label while keeping aerial capped at Type 3.
- **MA [45] redd Type 2 concern** — resolved by removing the default Type 2 redd path.
- **MA [58] define Provisional / Max / Candidate / Final** — now explicit in toolkit help/output and reflected in report wording.
- **EA [50] bulk-upload / field wording** — now clarified around Final Type + justification/explanation fields.

### Already handled in the base worktrees from prior passes and re-checked here
- **MA [1], [19] rapid-status citations** — newer citations already present and still coherent.
- **EA [13] Type 1 “Absolute abundance” framing** — retained and now better aligned with toolkit wording.
- **EA [66] / MA [66] rapid-status flag caution** — remains handled from prior pass.

### Consciously left as non-blocking follow-up / out of scope for this coherence pass
- landscape/layout improvements for long appendix tables and qualifier-code readability
- full house-style sweep on estimate-type capitalization
- any future explicit non-default redd exception path or richer resistivity-specific qualifier model

## Changed files

### Report worktree
- `02_methods.Rmd`
- `03_results.Rmd`
- `04_discussion.Rmd`
- `05_appendix.Rmd`
- `tmp/final-coherence-pass-2026-03-19.md`

### Toolkit worktree
- `app.R`
- `matrix_key/structured_dichotomous_key.yaml`
- `R/classification_engine.R`
- `R/classification_guidance_helpers.R`
- `R/structured_classification_key.R`
- `R/alignment_regression_tests.R`
- `R/comprehensive_path_testing.R`
- `R/test_classification_paths.R`
- `tmp/final-coherence-pass-2026-03-19.md` *(shared memo copy)*

## Validation status

### Report
- `Rscript -e "bookdown::render_book('index.Rmd', output_format = 'bookdown::gitbook')"` ✅
- `Rscript -e "csasdown::render(output_format = 'csasdown::techreport_docx')"` ✅

### Toolkit
- `Rscript R/alignment_regression_tests.R` ✅
- `Rscript -e "source('R/comprehensive_path_testing.R'); quit(status=ifelse(failed_tests>0,1,0))"` ✅ (29/29 path tests passed)
- `Rscript R/test_classification_paths.R` ✅
- `Rscript -e "parse(file='app.R'); cat('app.R parse OK\n')"` ✅

## Remaining non-blocking caveats

1. The toolkit now intentionally **does not implement** a higher-confidence redd-derived exception path. That is deliberate; if the group wants one later, it should be designed explicitly rather than inferred from the default redd family.
2. Resistivity is now coherent at the family/wording level, but a richer qualifier path for attribution/validation could still be added later if policy owners want it.
3. Layout-only reviewer suggestions (landscape appendix tables / figure edge cleanup beyond what was already done in prior passes) were not reopened here because they are not logic-surface blockers.
