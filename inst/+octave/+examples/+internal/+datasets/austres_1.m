t = octave.dataset.austres

plot (datenum (t.date), t.residents);
datetick x
xlabel ("Month"); ylabel ("Residents"); title ("Australian Residents");