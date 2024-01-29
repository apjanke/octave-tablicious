t = tblish.dataset.trees;

figure
tblish.examples.plot_pairs (t);

figure
loglog (t.Girth, t.Volume)
xlabel ("Girth")
ylabel ("Volume")

# TODO: Transform to log space for the coplot

# TODO: Linear model
