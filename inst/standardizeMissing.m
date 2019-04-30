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
## @deftypefn {Function} {@var{out} =} standardizeMissing (@var{X}, @var{indicator})
##
## Insert standard missing values.
##
## Standardizes missing values in @var{X} by replacing the values listed in
## @var{indicator} with the standard missing values for the type of @var{X}.
##
## Standard missing values depend on the data type:
##   * NaN for double, single, duration, and calendarDuration
##   * NaT for datetime
##   * @code{' '} for char
##   * @code{@{''@}} for cellstrs
##   * Integer numeric types have no standard missing value; they are never 
##     considered missing.
##   * Structs are never considered missing.
##   * Logicals are never considered missing.
##
## See also: @ref{table.standardizeMissing}
##
## @end deftypefn
function out = standardizeMissing(A, indicator)
  
  % Developer's note: This is the implementation for cell and primitive matrixes.
  % The table implementation is at table.standardizeMissing.
  
  if isnumeric (A)
    out = standardizeMissing_numeric (A, indicator);
  elseif iscell (A)
    out = standardizeMissing_cell (A, indicator);
  elseif ischar (A)
    out = standardizeMissing_char (A, indicator);
  elseif isa (A, 'datetime') || isa (A, 'duration') || isa (A, 'calendarDuration')
    % TODO: Implement these
    error ('standardizeMissing:Unimplemented', ['standardizeMissing: Support for ' ...
      '%s is not implemented yet. Sorry.'], ...
      class (A));
  elseif isa (A, 'categorical')
    % TODO: Implement this
    error ('standardizeMissing:Unimplemented', ['standardizeMissing: Support for ' ...
      '%s is not implemented yet. Sorry.'], ...
      class (A));
  else
    error ('standardizeMissing:InvalidInput', 'standardizeMissing: Unsupported input type: %s', ...
      class (A));
  endif
endfunction

function out = standardizeMissing_numeric (A, indicator)
  if iscell (indicator)
    sentinels = [];
    for i = 1:numel (indicator)
      if isnumeric (indicator{i})
        sentinels = [sentinels indicator{i}(:)'];
      endif
    endfor
  elseif isnumeric (indicator)
    sentinels = indicator;
  else
    % Just ignore the input, instead of erroring!
    out = A;
    return
  endif
  
  if isinteger (A)
    error ('standardizeMissing:InvalidInput', ...
      ['standardizeMissing: Cannot standardize missings for integers, because ' ...
         'no standard missing value is defined for them. (Got input type: %s)'], ...
         class (A));
  endif
  
  out = A;
  % We do not have to test for isnan() here, because any input values that are isnan()
  % are _already_ standardized.
  tfMissing = ismember (A, sentinels);
  out(tfMissing) = NaN;
endfunction

function out = standardizeMissing_cell (A, indicator)
  if ! iscellstr (A)
    error ('standardizeMissing:InvalidInput', ...
      ['standardizeMissing: Only cellstrs are supported for cell inputs. Input was not a cellstr.']);
  endif
  
  sentinels = {};
  if ischar (indicator)
    indicator = cellstr (indicator);
  endif
  if iscell (indicator)
    for i = 1:numel (indicator)
      if ischar (indicator{i})
        sentinels{end+1} = indicator{i};
      else
        % Just ignore it
      endif
    endfor
  else
    % Just ignore it, instead of erroring
    out = A;
    return;
  endif
  
  out = A;
  tfMissing = ismember (A, sentinels);
  out(tfMissing) = {''};
endfunction

function out = standardizeMissing_char (A, indicator)
  
  if ischar (indicator)
    sentinels = indicator;
  elseif iscell (indicator)
    sentinels = '';
    for i = 1:numel (indicator)
      if ischar (indicator{i})
        sentinels = [sentinels indicator{i}(:)'];
      else
        % Just ignore it
      endif
    endfor
  else
    % Just ignore it, instead of erroring
    out = A;
    return;
  endif

  out = A;
  tfMissing = ismember (A, sentinels);
  out(tfMissing) = ' ';
endfunction
