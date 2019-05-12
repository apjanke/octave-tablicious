t = octave.dataset.UKgas;

plot (datenum (t.date), t.gas);
datetick ("x")
xlabel ("Month")
ylabel ("Gas consumption (MM therms)")
