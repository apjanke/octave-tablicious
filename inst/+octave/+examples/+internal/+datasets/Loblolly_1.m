t = octave.dataset.Loblolly;

t2 = t(t.Seed == "329",:);
scatter (t2.age, t2.height)
xlabel ("Tree age (yr)");
ylabel ("Tree height (ft)");
title ("Loblolly data and fitted curve (Seed 329 only)")

# TODO: Compute and plot fitted curve
