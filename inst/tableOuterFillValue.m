## Copyright (C) 2019 Andrew Janke
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function} {@var{out} =} tableOuterFillValue (@var{x})
##
## Outer fill value for variable within a table.
##
## Determines the fill value to usse for a given variable value @var{x}
## when that value is used as a variable in a table that is involved in
## an outer join.
##
## The default implementation for @code{tableOuterFillValue} has support for
## all Octave primitive types, plus cellstrs, datetime & friends, strings,
## and @code{table}-valued variables.
##
## This function may become private to table before version 1.0. It is currently
## global to make debugging more convenient. It (or an equivalent) will remain
## global if we want to allow user-defined classes to customize their fill value.
## It also has default logic that will determine the fill value for an arbitrary
## type by detecting the value used to fill elements during array expansion
## operations. This will be appropriate for most data types.
## 
## Returns a 1-by-ncols value of the same type as x, which may be any type, where
## ncols is the number of columns in the input.
##
## @end deftypefn
function out = tableOuterFillValue (x)  
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
      % This is an exception to the "check the type, not its values" rule.
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
    % in a categorical variable. Currently a moot point since categorical is not
    % defined in Octave yet.
    error ('table: outer fill values for categorical variables are not yet implemented');
  else
    % Fall back to using array-expansion fill value
    if isempty (x)
      % Assume the 0-arg constructor works
      x0 = feval (class (x));
    else
      x0 = x(1,:);
    endif
    x0(3,:) = x0;
    out = x0(2,:);
  endif
endfunction
