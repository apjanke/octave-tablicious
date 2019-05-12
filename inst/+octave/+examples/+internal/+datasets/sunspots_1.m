t = octave.dataset.sunspots;

figure
plot (datenum (t.month), t.sunspots)
datetick ("x")
xlabel ("Date")
ylabel ("Monthly sunspot numbers")
title ("sunspots data")

