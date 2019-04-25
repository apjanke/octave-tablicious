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

function out = array2table(c, varargin)
  %CELL2TABLE Convert a cell array to a table

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
