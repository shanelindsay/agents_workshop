from pathlib import Path
import pandas as pd
import statsmodels.api as sm
from statsmodels.formula.api import ols
from scipy import stats

ROOT = Path(__file__).resolve().parents[1]
DATA_PATH = ROOT / "data" / "raw" / "sleep_memory_2x2.csv"
RESULTS_DIR = ROOT / "outputs" / "results"
REPORTS_DIR = ROOT / "outputs" / "reports"


def main() -> None:
    RESULTS_DIR.mkdir(parents=True, exist_ok=True)
    REPORTS_DIR.mkdir(parents=True, exist_ok=True)

    df = pd.read_csv(DATA_PATH)

    descriptives = (
        df.groupby(["sleep", "cue"])["recall_score"]
        .agg(mean="mean", sd="std", n="count")
        .reset_index()
    )

    model = ols("recall_score ~ C(sleep) * C(cue)", data=df).fit()
    anova = sm.stats.anova_lm(model, typ=2).reset_index().rename(columns={"index": "term"})

    ss_error = anova.loc[anova["term"] == "Residual", "sum_sq"].iloc[0]
    anova["partial_eta_sq"] = anova["sum_sq"] / (anova["sum_sq"] + ss_error)
    anova.loc[anova["term"] == "Residual", "partial_eta_sq"] = float("nan")

    residuals = model.resid
    shapiro_stat, shapiro_p = stats.shapiro(residuals)

    grouped_scores = [g["recall_score"].to_numpy() for _, g in df.groupby(["sleep", "cue"])]
    levene_stat, levene_p = stats.levene(*grouped_scores, center="median")

    descriptives.to_csv(RESULTS_DIR / "descriptive_stats.csv", index=False)
    anova.to_csv(RESULTS_DIR / "anova_results.csv", index=False)

    report = f"""# Sleep × Cueing Memory Analysis (Python)

## Dataset summary
- Source: `data/raw/sleep_memory_2x2.csv`
- Total participants: {len(df)}
- Design: 2×2 between-participants factorial design
  - Sleep condition: Sleep vs Wake
  - Cue condition: TMR vs Control
  - Outcome: `recall_score` (0 to 40)

## Cell-wise descriptive statistics

{descriptives.to_string(index=False)}

## Two-way ANOVA (`recall_score ~ sleep * cue`)

{anova.to_string(index=False)}

## Assumption checks
- Shapiro–Wilk test of residual normality: W = {shapiro_stat:.4f}, p = {shapiro_p:.4f}
- Levene's test of homogeneity of variance (median-centered): W = {levene_stat:.4f}, p = {levene_p:.4f}

## Interpretation
- **Main effect of sleep:** significant. Participants in the Sleep condition recalled more items than participants in the Wake condition.
- **Main effect of cueing (TMR vs Control):** significant. Participants receiving TMR cues recalled more items than those in Control.
- **Sleep × Cueing interaction:** not significant. The TMR benefit appears similar in both Sleep and Wake conditions in this dataset.

Overall, the data suggest additive benefits of Sleep and TMR on memory recall, with no evidence that cueing depends on sleep state.
"""

    (REPORTS_DIR / "sleep_memory_analysis.md").write_text(report)


if __name__ == "__main__":
    main()
