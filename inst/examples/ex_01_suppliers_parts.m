% This example shows how to work with the tables in C. J. Date's classic
% Suppliers-Parts Database example

% The Suppliers-Parts database is defined over in +table_examples

[s,p,sp] = table_examples.SpDb;

% Display one of the tables

fprintf('\nTable s:\n');
prettyprint (s)

% Get the suppliers just in London

london_suppliers = s(strcmp (s.City, 'London'),:)
fprintf('\nSuppliers in London:\n')
prettyprint (london_suppliers)

% Suppliers in Paris with a status of 20 or greater

paris = s(strcmp (s.City, 'Paris') & s.Status >= 20,:)
fprintf('\nParis suppliers with status >= 20:\n')
prettyprint (paris)

% Join the tables up so we can do aggregate queries

% Rename the city columns in the Suppliers and Parts table, because we don't 
% want to use them as a key
s2 = renamevars (s, {'City' 'SupplierCity'})
p2 = renamevars (p, {'City' 'PartCity'});
% Join all the tables
j = innerjoin(innerjoin(sp, s2), p2);
fprintf('\nJoined tables:\n')
prettyprint (j)

% Calculate the total weight of deliveries
j = setvar (j, 'TotalWeight', j.Qty .* j.Weight);

% Calculate the total parts count and weight for each part city
g = groupby (j, {'PartCity'}, {
  'TotalQty', @sum, 'Qty'
  'TotalWeight', @sum, 'TotalWeight'
  });
fprintf ('\nDelivery totals by city:\n');
prettyprint (g);

% You can also use a trick with strjoin() to compactly display all the values
% for a column in a groupby. Note that you have to use {...} to throw the
% resulting strings into a cell so the output of the function is scalar.
g = groupby (j, {'PartCity'}, {
  'Parts', @(x) {strjoin(unique(x), ', ')}, 'PNum'
  'Colors', @(x) {strjoin(unique(x), ', ')}, 'Color'
  'TotalQty', @sum, 'Qty'
  'TotalWeight', @sum, 'TotalWeight'
  });
fprintf ('\nDelivery totals by city with extra info:\n');
prettyprint (g);

