t = octave.dataset.pressure;

figure
plot (t.temperature, t.pressure)
xlabel ("Temperature (deg C)")
ylabel ("Pressure (mm of Hg)")
title ("pressure data: Vapor Pressure of Mercury")

figure
semilogy (t.temperature, t.pressure)
xlabel ("Temperature (deg C)")
ylabel ("Pressure (mm of Hg)")
title ("pressure data: Vapor Pressure of Mercury")

