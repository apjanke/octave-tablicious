t = octave.dataset.Formaldehyde;

figure
scatter (t.carb, t.optden)
% TODO: Add a linear model line
xlabel ("Carbohydrate (ml)")
ylabel ("Optical Density")
title ("Formaldehyde data")

% TODO: Add linear model summary output
% TOD: Add linear model summary plot