## Copyright (C) 2019, 2023, 2024 Andrew Janke
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
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
## @deftypefn {Function} {@var{out} =} fillValForVal (@var{x})
##
## Outer fill value for variable within a table.
##
## Determines the fill value to use for a given variable value @var{x}
## when that value is used as a variable in a table that is involved in
## an outer join, an all-missing table is being constructed, or "missing"
## placeholder values are needed for other reasons.
##
## This implementation for @code{fillValForVal} has support for all Octave
## primitive types, plus cellstrs, datetime & friends, strings, and
## @code{table}-valued variables. It also default logic that will determine
## the fill value for an arbitrary type by detecting the value used to fill
## elements during array expansion operations. This will be appropriate for
## most data types.
##
## This is an internal function for Tablicious's own use, and not part of its
## public API. In the future, a public function may be provided to allow
## user-defined classes to define their own fill values, but this is not
## currently supported.
##
## Returns a 1-by-ncols value of the same type as x, which may be any type,
## where ncols is the number of columns in the input.
##
## @end deftypefn
function out = fillValForVal (x)
  nCols = size (x, 2);

  if (isnumeric (x))
    if (isa (x, 'double'))
      out = NaN (1, nCols);
    elseif (isa (x, 'single'))
      out = single (NaN (1, nCols));
    elseif (isinteger (x))
      out = zeros (1, nCols, class (x));
    else
      error ('table: value was numeric but not single, double, or integer: %s', ...
        class (x));
    endif
  elseif (iscell (x))
    if (iscellstr (x))
      # This is an exception to the "check the type, not its values" rule.
      out = repmat ({''}, 1, nCols);
    else
      out = repmat ({[]}, 1, nCols);
    endif
  elseif (isa (x, 'datetime'))
    out = NaT (1, nCols);
  elseif (isa (x, 'string'))
    out = NaS (1, nCols);
  elseif (isa (x, 'table'))
    if (! isempty (x.Properties.RowNames))
      error (['table: cannot construct outer fill values for table-valued ' ...
       'variables that have row names']);
    endif
    varVals = cell (1, size (x, 2));
    for i = 1:width (x)
      varVals{i} = tblish.internal.table.fillValForVal (x.Properties.VariableValues{i});
    endfor
    varNames = x.Properties.VariableNames;
    out = table (varVals{:}, 'VariableNames', x.Properties.VariableNames);
  elseif (isa (x, 'categorical'))
    out = NaC (1, nCols);
  else
    # General case: Fall back to using array-expansion fill value
    if (isempty (x))
      # Assume the 0-arg constructor works
      x0 = feval (class (x));
    else
      x0 = x(1,:);
    endif
    x0(3,:) = x0;
    out = x0(2,:);
  endif
endfunction
