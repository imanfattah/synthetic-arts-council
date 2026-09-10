# First pilot experiment report

Date: 2026-09-10  
Case: `SAC-JKT-AI-DISCLOSURE-001`  
Status: **Recommendation ready; human review required**

## Question

Should a hypothetical Jakarta public cultural-grant programme require applicants to disclose material uses of generative AI in funded artistic work?

## Method executed

One human-approved shared pack containing 9 sources and 21 evidence items was frozen before deliberation. Six discipline-configured committees then assessed the same case independently. They did not see one another's positions and did not conduct private research. A structured comparison was produced only after all six outputs were complete.

## Result

All six committees returned `support_with_conditions`. Mean stated confidence was `0.74`, ranging from `0.68` to `0.78`.

The shared recommendation is to test a concise, neutral disclosure of **material** generative-AI use while distinguishing substantive creative use from routine administrative or accessibility assistance. Disclosure should not produce automatic ineligibility, imply infringement, or replace consent, rights review, consultation, or human assessment.

This is not a recommendation for immediate real-world adoption. Every committee required Jakarta stakeholder co-design, a locally tested definition of materiality, operational and accessibility testing, current Indonesian legal review, and fair correction and appeal procedures.

## Agreement that survived comparison

- proportional, accessible disclosure rather than a blanket ban;
- accountability limited to information reasonably known or controlled by applicants;
- human-led grant assessment;
- confidentiality, correction, appeal, and proportionate remedies;
- consultation before implementation.

## Disagreement and variation preserved

- Music emphasized voice, composition, performance, and sound-role attribution.
- Theatre emphasized evolving ensemble processes and production updates.
- Dance emphasized movement, embodied authorship, and community or traditional custodians.
- Film emphasized digital replicas, production stages, archives, and final reporting.
- Literature emphasized translation, expressive text, and the distinction between assistance and generation.
- Visual Arts emphasized style, cultural data, fabrication, curation, and audience-facing notices.

The committees did not establish one shared materiality threshold or reporting schedule. This unresolved design question remains visible in the deliberation record.

## Failures and repairs

The Film Committee initially returned its display name instead of its configured machine ID. The original invalid output is preserved in `failures/film-committee-id.initial.json`. The validator had not checked this field, so the test exposed and repaired a real contract weakness.

The validator also did not initially confirm that evidence IDs cited by committee and decision outputs existed in the shared evidence pack. That check was added before final validation.

## Limits

The evidence is stronger on institutional and international policy than on Jakarta stakeholder experience. No inference should be made that Jakarta artists, an arts council, or a public authority endorses this result. Foreign law remains comparative only, and the Indonesian sources do not settle AI-specific arts questions.

## Provisional evaluation

The run provisionally meets the v0.1 methodological threshold: its evidence trail, interpretations, discipline-specific positions, disagreement, gaps, correction history, and institutional state can be reconstructed. Human review is still required before the experiment is marked complete.
