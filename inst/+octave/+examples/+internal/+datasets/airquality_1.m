t = octave.dataset.airquality
# Plot a scatter-plot plus a fitted line, for each combination of measurements
vars = {"Ozone", "SolarR", "Wind", "Temp" "Month", "Day"};
n_vars = numel (vars);
figure;
for i = 1:n_vars
  for j = 1:n_vars
    if i == j
      continue
    endif
    ix_subplot = (n_vars*(j - 1) + i);
    hax = subplot (n_vars, n_vars, ix_subplot);
    var_x = vars{i};
    var_y = vars{j};
    x = t.(var_x);
    y = t.(var_y);
    scatter (hax, x, y, 10);
    # Fit a cubic line to these points
    # TODO: Find out exactly what kind of fitted line R's example is using, and
    # port that.
    hold on
    p = polyfit (x, y, 3);
    x_hat = unique(x);
    p_y = polyval (p, x_hat);
    plot (hax, x_hat, p_y, "r");
  endfor
endfor
