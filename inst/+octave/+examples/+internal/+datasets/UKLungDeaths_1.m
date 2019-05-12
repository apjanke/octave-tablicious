t = octave.dataset.UKLungDeaths;

figure
plot (datenum (t.date), t.ldeaths);
title ("Total UK Lung Deaths")
xlabel ("Month")
ylabel ("Deaths")

figure
plot (datenum (t.date), [t.fdeaths t.mdeaths]);
title ("UK Lung Deaths buy sex")
legend ({"Female", "Male"})
xlabel ("Month")
ylabel ("Deaths")
