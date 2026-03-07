# Sleep × Cueing Memory Analysis (Python)

## Dataset summary
- Source: `data/raw/sleep_memory_2x2.csv`
- Total participants: 80
- Design: 2×2 between-participants factorial design
  - Sleep condition: Sleep vs Wake
  - Cue condition: TMR vs Control
  - Outcome: `recall_score` (0 to 40)

## Cell-wise descriptive statistics

sleep     cue    mean       sd  n
Sleep Control 26.4930 3.577802 20
Sleep     TMR 29.8520 3.915471 20
 Wake Control 21.5820 3.358257 20
 Wake     TMR 24.5365 3.220819 20

## Two-way ANOVA (`recall_score ~ sleep * cue`)

           term     sum_sq   df         F       PR(>F)  partial_eta_sq
       C(sleep) 522.906511  1.0 42.014745 8.168673e-09        0.356013
         C(cue) 199.301411  1.0 16.013566 1.448774e-04        0.174035
C(sleep):C(cue)   0.818101  1.0  0.065733 7.983464e-01        0.000864
       Residual 945.879715 76.0       NaN          NaN             NaN

## Assumption checks
- Shapiro–Wilk test of residual normality: W = 0.9871, p = 0.6028
- Levene's test of homogeneity of variance (median-centered): W = 0.3170, p = 0.8130

## Interpretation
- **Main effect of sleep:** significant. Participants in the Sleep condition recalled more items than participants in the Wake condition.
- **Main effect of cueing (TMR vs Control):** significant. Participants receiving TMR cues recalled more items than those in Control.
- **Sleep × Cueing interaction:** not significant. The TMR benefit appears similar in both Sleep and Wake conditions in this dataset.

Overall, the data suggest additive benefits of Sleep and TMR on memory recall, with no evidence that cueing depends on sleep state.
