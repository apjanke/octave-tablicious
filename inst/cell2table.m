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
## @deftypefn {Function} {@var{out} =} cell2table (@var{c})
## @deftypefnx {Function} {@var{out} =} cell2table (@dots{}, @code{'VariableNames'}, @var{VariableNames})
## @deftypefnx {Function} {@var{out} =} cell2table (@dots{}, @code{'RowNames'}, @var{RowNames})
##
## Convert a cell array to a table.
##
## Converts a 2-dimensional cell matrix into a table. Each column in the
## input @var{c} becomes a variable in @var{out}. For columns that contain
## all scalar values of @code{cat}-compatible types, they are “popped out”
## of their cells and condensed into a homogeneous array of the contained
## type.
##
## See also: @ref{array2table}, @ref{table}, @ref{struct2table}
##
## @end deftypefn
function out = cell2table(c, varargin)
  %CELL2TABLE Convert a cell array to a table

  if ~iscell (c)
    error ('cell2table: Input must be cell; got %s', class (c));
  endif
  if ndims (c) > 2
    error ('cell2table: Input must be 2-D; got %d-D', ndims (c));
  endif
  
  % Peel off trailing options
  [opts, args] = peelOffNameValueOptions (varargin, {'VariableNames', 'RowNames'});  
  if ~isempty (args)
    error ('cell2table: Unrecognized options');
  endif

  nCols = size (c, 2);
  colVals = cell (1, nCols);
  for iCol = 1:nCols
    if iscellstr (c(:,iCol))
      % Special-case char conversion
      colVals{iCol} = c(:,iCol);
    else
      % Cheap hack to test for cat-ability
      try
        x = cat (1, c{:,iCol});
        if size (x, 1) == size (c, 1)
          colVals{iCol} = x;
          continue
        endif
      catch
        % Nope, couldn't cat. Fall through.
      end
      colVals{iCol} = c(:,iCol);
    endif
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
