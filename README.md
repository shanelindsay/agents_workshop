# Agents workshop in R

This repo is a small, agent-friendly data analysis pipeline for a psychology workshop.

## What you will do

1. Edit `AGENTS.md` so an agent understands how to work in this repo.
2. Run an agent task to analyse the dataset in `data/raw/`.
3. Review what the agent changed and verify the results.
4. Render a short Quarto report.

## Quick start

Run the full pipeline:

```bash
make
```

Or run steps:

```bash
make analyse
make report
```

## What to look at after running

- `outputs/results/anova.yml`
- `outputs/figures/interaction.png`
- `outputs/reports/report.html`

## Data

Synthetic dataset for a 2 × 2 between-participants design.

- Factor 1: sleep condition (`Sleep` vs `Wake`)
- Factor 2: cue condition (`TMR` vs `Control`)
- DV: recall score (0 to 40)

See `docs/project_card.md` for the research question and deliverables.
