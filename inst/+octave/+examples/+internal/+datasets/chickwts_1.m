# This example requires the statistics package from Octave Forge

t = octave.dataset.chickwts

# Boxplot by group
figure
g = groupby (t, "feed", {
  "weight", @(x) {x}, "weight"
});
boxplot (g.weight, 1);
xlabel ("feed"); ylabel ("Weight at six weeks (gm)");
xticklabels ([{""} cellstr(g.feed')]);

# Linear model
# TODO: This linear model thing and anova
