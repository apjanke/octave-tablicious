function out = standardizeMissing(A, indicator)
  %STANDARDIZEMISSING Insert standard missing values
  
  % Developer's note: This is the implementation for cell and primitive matrixes.
  % The table implementation is at table.standardizeMissing.
  
  if isnumeric (A)
    out = standardizeMissing_numeric(A, indicator);
  elseif iscell (A)
    out = standardizeMissing_cell(A, indicator);
  elseif ischar (A)
    out = standardizeMissing_char(A, indicator);
  else
    error ('standardizeMissing:InvalidInput', 'Unsupported input type: %s', ...
      class (A));
  endif
endfunction
