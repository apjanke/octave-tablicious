function out = tableOuterFillValue (x)
  %TABLEOUTERFILLVALUE Fill value for outer joins for a given variable value
  %
  % Determines the fill value to use vor a given variable value in table outer
  % joins.
  %
  % This function may become private to table before version 1.0. It is currently
  % global to make debugging more convenient. It (or an equivalent) will remain
  % global if we want to allow user-defined classes to customize their fill value.
  % 
  % Returns a 1-by-ncols value of the same type as x, which may be any type, where
  % ncols is the number of columns in the input.
  
  % TODO: This is now redundant with table.outerfillvals. Merge them.

  nCols = size (x, 2);
  if isnumeric (x)
    if isa (x, 'double') || isa (x, 'single')
      out = NaN (1, nCols);
    elseif isinteger (x)
      out = zeros (1, nCols, class (x));
    else
      error ('table: value was numeric but not single, double, or integer: %s', ...
        class (x));
    endif
  elseif iscell (x)
    if iscellstr (x)
      % This is an exception to the "check the type, not its values" rule
      out = repmat ({''}, 1, nCols);
    else
      error ('table: outer fill values for non-cellstr cells are not supported');
    endif
  elseif isa (x, 'datetime')
    out = NaT (1, nCols);
  elseif isa (x, 'duration') || isa (x, 'calendarDuration')
    out = NaN (1, nCols);
  elseif isa (x, 'string')
    out = repmat (string (missing), [1 nCols]);
  elseif isa (x, 'table')
    if hasrownames (x)
      error (['table: cannot construct outer fill values for table-valued ' ...
       'variables that have row names']);
    endif
    varVals = cell (1, size (x, 2));
    for i = 1:width (x)
      varVals{i} = tableOuterFillValue (x.Properties.VariableValues{i});
    endfor
    varNames = x.Properties.VariableNames;
    out = table (varVals{:}, 'VariableNames', x.Properties.VariableNames);
  elseif isa (x, 'categorical')
    % We may need to construct an <undefined> value of the particular categories
    % in a categorical variable. Moot point since categorical is not defined in
    % Octave yet
    error ('table: outer fill values for categorical variables are not yet implemented');
  else
    % Fall back to using array-expansion fill value
    if isempty (x)
      % Assume the 0-arg constructor works
      x0 = feval (class (x));
    else
      x0 = x(1);
    endif
    x0(3) = x0;
    out = repmat (x0(2), 1, nCols);
  endif
endfunction
