
t = octave.dataset.cars;


# TODO: Add Lowess smoothed lines to the plots

figure;
plot (t.speed, t.dist, "o");
xlabel ("Speed (mph)"); ylabel("Stopping distance (ft)");
title ("cars data");

figure;
loglog (t.speed, t.dist, "o");
xlabel ("Speed (mph)"); ylabel("Stopping distance (ft)");
title ("cars data (logarithmic scales)");

# TODO: Do the linear model plot

# Polynomial regression
figure;
plot (t.speed, t.dist, "o");
xlabel ("Speed (mph)"); ylabel("Stopping distance (ft)");
title ("cars polynomial regressions");
hold on
xlim ([0 25]);
x2 = linspace (0, 25, 200);
for degree = 1:4
  [P, S, mu] = polyfit (t.speed, t.dist, degree);
  y2 = polyval(P, x2, [], mu);
  plot (x2, y2);
endfor

