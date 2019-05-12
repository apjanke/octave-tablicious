t = octave.dataset.uspop;

figure
semilogy (t.year, t.population)
xlabel ("Year")
ylabel ("U.S. Population (millions)")
