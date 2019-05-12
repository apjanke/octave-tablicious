t = octave.dataset.trees;

figure
octave.examples.plot_pairs (t);

figure
loglog (t.Girth, t.Volume)
xlabel ("Girth")
ylabel ("Volume")

# TODO: Transform to log space for the coplot

# TODO: Linear model
