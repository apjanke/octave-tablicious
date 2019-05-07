
t = octave.dataset.EuStockMarkets;

# The fact that we're doing this munging means that table might have
# been the wrong structure for this data in the first place

t2 = removevars (t, "day");
index_names = t2.Properties.VariableNames;
day = 1:height (t2);
price = table2array (t2);

price0 = price(1,:);

rel_price = price ./ repmat (price0, [size(price,1) 1]);

figure;
plot (day, rel_price);
legend (index_names);
xlabel ("Business day");
ylabel ("Relative price");


