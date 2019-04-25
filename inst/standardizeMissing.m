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
