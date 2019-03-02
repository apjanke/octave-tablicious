function varargout = SpDb
  %SPDB The classic suppliers-parts example database
  %
  % s = table.examples.SpDb
  % [s, p, sp] = table.examples.SpDb
  %
  % Constructs the classic C. J. Date Suppliers-Parts ("SP") example database
  % as tables.
  %
  % If one argout is captured, the tables are returned in the fields of a struct.
  % If multiple argouts are captured, the tables are returned as three argouts.
  S = cell2table ({
    'S1'  'Smith' 20  'London'
    'S2'  'Jones' 10  'Paris'
    'S3'  'Blake' 30  'Paris'
    'S4'  'Clark' 20  'London'
    'S5'  'Adams' 30  'Athens'
  }, 'VariableNames', {'SNum', 'SName', 'Status', 'City'});
  P = cell2table ({
    'P1'  'Nut'    'Red'    12.0    'London'
    'P2'  'Bolt'   'Green'  17.0    'Paris'
    'P3'  'Screw'  'Blue'   17.0    'Oslo'
    'P4'  'Screw'  'Red'    14.0    'London'
    'P5'  'Cam'    'Blue'   12.0    'Paris'
    'P6'  'Cog'    'Red'    19.0    'London'      
  }, 'VariableNames', {'PNum', 'PName', 'Color', 'Weight', 'City'});
  SP = cell2table ({
    'S1'  'P1'  300
    'S1'  'P2'  200
    'S1'  'P3'  400
    'S1'  'P4'  200
    'S1'  'P5'  100
    'S1'  'P6'  100
    'S2'  'P1'  300
    'S2'  'P2'  400
    'S3'  'P2'  200
    'S4'  'P2'  200
    'S4'  'P4'  300
    'S4'  'P5'  400      
  }, 'VariableNames', {'SNum', 'PNum', 'Qty'});
  if nargout == 1
    varargout = { struct('S', S, 'P', P, 'SP', SP) };
  else
    varargout = { S, P, SP };
  endif
endfunction
