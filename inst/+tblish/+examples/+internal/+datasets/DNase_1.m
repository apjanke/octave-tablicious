t = tblish.dataset.DNase;

# TODO: Port this from R

tblish.examples.coplot (t, "conc", "density", "Run", "PlotFcn", @scatter);
tblish.examples.coplot (t, "conc", "density", "Run", "PlotFcn", @loglog, ...
  "PlotArgs", {"o"});
