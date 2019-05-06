t = octave.dataset.co2;

plot (datenum (t.date), t.co2);
datetick ("x");
xlabel ("Time"); ylabel ("Atmospheric concentration of CO2");
title ("co2 data set");
