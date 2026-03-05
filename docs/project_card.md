# Project card

## Scenario

You are analysing a synthetic dataset from a memory experiment.

Participants learned a list of word pairs and then completed a recall test.

Two between-participants factors were manipulated.

- Sleep condition: Sleep vs Wake
- Cue condition: TMR vs Control

The dependent variable is `recall_score`, a score from 0 to 40.

## Research question

Do sleep and cueing influence recall performance, and do they interact.

## Deliverables

1. A 2 × 2 ANOVA on recall score with an APA style write-up.
2. Descriptives for each group, mean and SD.
3. An interaction plot.

## Constraints

- Do not edit the raw data file.
- Put generated files in `outputs/`.
- Use R and Quarto via `./dev/run-in-env.sh`.

## How to run

- Analysis step
  - `make analyse`
- Report step
  - `make report`

## Success checks

- Results should be reproducible. Running `make` twice should not change the numbers.
- The plot should reflect the means in the descriptives.
- If you make any assumption, write it down in the report.
