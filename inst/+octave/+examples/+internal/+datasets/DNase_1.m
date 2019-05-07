t = octave.dataset.DNase;

# TODO: Port this from R

octave.examples.coplot (t, "conc", "density", "Run", "PlotFcn", @scatter);
octave.examples.coplot (t, "conc", "density", "Run", "PlotFcn", @loglog, ...
  "PlotArgs", {"o"});
