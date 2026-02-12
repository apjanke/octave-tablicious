## Copyright (C) 2019, 2023, 2024, 2026 Andrew Janke
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
## @deftypefn {Function} {@var{out} =} tail (@var{A})
## @deftypefnx {Function} {@var{out} =} tail (@var{A}, @var{k})
##
## Get last K rows of an array.
##
## Returns the array @var{A}, subsetted to its last @var{k} rows. This means
## subsetting it to the last @code{(min (k, size (A, 1)))} elements along
## dimension 1, and leaving all other dimensions unrestricted.
##
## @var{A} is the array to subset.
##
## @var{k} is the number of rows to get. @var{k} defaults to 8 if it is omitted
## or empty.
##
## If there are less than @var{k} rows in @var{A}, returns all rows.
##
## Returns an array of the same type as @var{A}, unless ()-indexing @var{A}
## produces an array of a different type, in which case it returns that type.
##
## @seealso{head}
##
## @end deftypefn
function out = tail (A, k)
  if (nargin < 2 || isempty (k))
    k = 8;
  endif
  nRows = size (A, 1);
  if (nRows < k)
    out = A;
    return
  endif
  ixs = repmat ({':'}, [1 ndims(A)]);
  ixs{1} = nRows-k+1:nRows;
  out = A(ixs{:});
endfunction
