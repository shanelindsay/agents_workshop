# AGENTS.md

This file is read by coding agents that work in this repository. Keep it short and concrete.

## Role and communication

- What should the agent call you
- What should you call the agent
- How should it write in the report (plain language, concise, APA style)

## Constraints and safety

- Do not edit files in `data/raw/`
- Do not fabricate results or citations
- If something is unclear or missing, stop and ask

## Workflow and commands

- Use the environment wrapper for R and Quarto
  - `./dev/run-in-env.sh Rscript scripts/01_analyse.R`
  - `./dev/run-in-env.sh quarto render reports/report.qmd --output-dir outputs/reports`
- Prefer small, auditable steps
- Write outputs to `outputs/` as CSV, YAML, PNG, or HTML

## Definition of done and checks

- `outputs/results/anova.yml` exists and includes ANOVA table and effect sizes
- `outputs/figures/interaction.png` exists and matches the descriptives
- `outputs/reports/report.html` renders without errors
- Re-run `make` and confirm it completes
