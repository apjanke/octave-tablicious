data = octave.dataset.anscombe

# Pick good limits for the plots
all_x = [data.x];
all_y = [data.y];
x_limits = [min(0, min(all_x)) max(all_x)*1.2];
y_limits = [min(0, min(all_y)) max(all_y)*1.2];

# Do regression on each pair and plot the input and results
figure;
haxs = NaN (1, 4);
for i_pair = 1:4
  x = data(i_pair).x;
  y = data(i_pair).y;
  # TODO: Port the anova and other characterizations from the R code
  # TODO: Do a linear regression and plot its line
  hax = subplot (2, 2, i_pair);
  haxs(i_pair) = hax;
  xlabel (sprintf ("x%d", i_pair));
  ylabel (sprintf ("y%d", i_pair));
  scatter (x, y, "r");
endfor

# Fiddle with the plot axes parameters
linkaxes (haxs);
xlim(haxs(1), x_limits);
ylim(haxs(1), y_limits);