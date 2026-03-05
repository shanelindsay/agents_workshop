SHELL := /bin/bash

.PHONY: all analyse report clean

all: analyse report

analyse: outputs/results/anova.yml outputs/figures/interaction.png

report: outputs/reports/report.html

outputs/results/anova.yml outputs/figures/interaction.png: scripts/01_analyse.R data/raw/sleep_memory_2x2.csv
	./dev/run-in-env.sh Rscript scripts/01_analyse.R

outputs/reports/report.html: reports/report.qmd outputs/results/anova.yml outputs/figures/interaction.png
	./dev/run-in-env.sh quarto render reports/report.qmd --output-dir outputs/reports

clean:
	rm -rf outputs/results/* outputs/figures/* outputs/reports/*
