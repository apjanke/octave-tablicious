t = octave.dataset.presidents;

figure
plot (datenum (t.date), t.approval)
datetick ("x")
xlabel ("Date")
ylabel ("Approval rating (%)")
title ("presidents data")
