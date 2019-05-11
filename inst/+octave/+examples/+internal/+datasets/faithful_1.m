t = octave.dataset.faithful;

% Munge the data, rounding eruption time to the second
e60 = 60 * t.eruptions;
ne60 = round (e60);
# TODO: Port zapsmall to Octave
eruptions = ne60 / 60;
# TODO: Display mean relative difference and bins summary

% Histogram of rounded eruption times
figure
hist (ne60, max (ne60))
xlabel ("Eruption time (sec)")
ylabel ("n")
title ("faithful data: Eruptions of Old Faithful")

% Scatter plot of eruption time vs waiting time
figure
scatter (t.eruptions, t.waiting)
xlabel ("Eruption time (min)")
ylabel ("Waiting time to next eruption (min)")
title ("faithful data: Eruptions of Old Faithful")
# TODO: Port Lowess smoothing to Octave