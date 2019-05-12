t = octave.dataset.rock;

figure
scatter (t.area, t.perm)
xlabel ("Area of pores space (pixels out of 256x256)")
ylabel ("Permeability (milli-Darcies)")
