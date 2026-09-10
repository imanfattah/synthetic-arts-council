# AI-disclosure pilot

## Policy question

> Should a hypothetical Jakarta public cultural-grant programme require applicants to disclose material uses of generative AI in funded artistic work?

This is a simulated, low-stakes test case. It is not a proposal from, decision by, or representation of Dewan Kesenian Jakarta or another institution.

## Research method

1. A controlled research process identifies candidate sources.
2. Each complete source is registered in `sources.yaml`.
3. Bounded claims, provisions, excerpts, or data points are extracted into `evidence.yaml` with context and limitations.
4. A human reviewer checks the shared evidence pack before deliberation.
5. All six committees receive the same case, mandate, and shared evidence pack.
6. Committees produce their initial positions independently.
7. Committees may abstain, declare the question outside their domain, or request missing evidence and stakeholders.
8. New evidence is added to the shared pack and human-reviewed before affected committees reassess.
9. Deliberation preserves disagreement and minority positions.
10. The recommendation remains decision support until human review.

Committee agents interpret evidence; they do not conduct private, open-ended research during the initial deliberation.

## Evidence admission criteria

A source or evidence item may enter the shared pack only when:

- its provenance is recorded;
- the source can be retrieved or preserved;
- extraction is bounded and distinguishable from interpretation;
- date, geography, context, reliability, and limitations are recorded;
- conflicting evidence is retained rather than silently reconciled;
- a human reviewer records the review state.

## Planned evidence categories

These are research targets, not claims that relevant evidence already exists:

- applicable grant rules and public-sector mandates;
- existing AI-disclosure policies or comparable cultural-funding practices;
- artist and cultural-worker perspectives across disciplines;
- effects on copyright, consent, attribution, labour, accessibility, and artistic freedom;
- administrative burden and enforceability;
- perspectives from affected communities and audiences;
- relevant Indonesian context and cautiously selected international comparisons.

## Required outputs

- six independent committee positions, including valid abstentions or `outside_domain` responses;
- one structured deliberation record;
- one draft decision record requiring human review;
- one completed evaluation scorecard;
- one experiment report documenting both successful and failed behaviours.

No deliberation should begin while `evidence_review.status` in `case.yaml` is not `approved`.
