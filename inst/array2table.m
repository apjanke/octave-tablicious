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
## @deftypefn {Function} {@var{out} =} array2table (@var{c})
## @deftypefnx {Function} {@var{out} =} array2table (@dots{}, @code{'VariableNames'}, @var{VariableNames})
## @deftypefnx {Function} {@var{out} =} array2table (@dots{}, @code{'RowNames'}, @var{RowNames})
##
## Convert an array to a table.
##
## Converts a 2-D array to a table, with columns in the array becoming variables in
## the output table. This is typically used on numeric arrays, but it can
## be applied to any type of array.
##
## You may not want to use this on cell arrays, though, because you will
## end up with a table that has all its variables of type cell. If you use
## @code{cell2table} instead, columns of the cell array which can be 
## condensed into primitive arrays will be. With @code{array2table}, they
## won't be.
##
## See also: @ref{cell2table}, @ref{table}, @ref{struct2table}
##
## @end deftypefn
function out = array2table(c, varargin)
  %ARRAY2TABLE Convert an array to a table

  if ndims (c) > 2
    error ('array2table: Input must be 2-D; got %d-D', ndims (c));
  endif
  
  % Peel off trailing options
  [opts, args] = peelOffNameValueOptions (varargin, {'VariableNames', 'RowNames'});
  if ~isempty (args)
    error ('array2table: Unrecognized options');
  endif

  nCols = size (c, 2);
  colVals = cell (1, nCols);
  for iCol = 1:nCols
    colVals{iCol} = c(:,iCol);
  endfor
  
  if isfield (opts, 'VariableNames')
    varNames = opts.VariableNames;
  else
    varNames = cell (1, nCols);
    for iCol = 1:nCols
      varNames{iCol} = sprintf('Var%d', iCol);
    endfor
  endif
  
  optArgs = {'VariableNames', varNames};
  if isfield (opts, 'RowNames')
    optArgs = [optArgs {'RowNames', opts.RowNames}];
  endif
  out = table (colVals{:}, optArgs{:});  
endfunction
