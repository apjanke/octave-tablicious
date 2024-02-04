## Copyright (C) 2019, 2023, 2024 Andrew Janke <floss@apjanke.net>
##
## This file is part of Tablicious.
##
## Octave is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## Octave is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function} {@var{out} =} NaS ()
## @deftypefnx {Function} {@var{out} =} NaS (@var{sz})
##
## “Not-a-String". Creates missing-valued string arrays.
##
## Returns a new @code{string} array of all missing values of
## the given size. If no input @var{sz} is given, the result is a scalar missing
## string.
##
## @code{NaS} is the @code{string} equivalent of @code{NaN} or @code{NaT}. It
## represents a missing, invalid, or null value. @code{NaS} values never compare
## equal to any value, including other @code{NaS}s.
##
## @code{NaS} is a convenience function which is strictly a wrapper around
## @code{string.missing} and returns the same results, but may be more convenient
## to type and/or more readable, especially in array expressions with several values.
##
## @seealso{string.missing}
##
## @end deftypefn
function out = NaS (sz)
  #NaS Not-a-String (missing-valued string array)
  #
  # Creates a string array with all-missing values.
  if (nargin == 0)
    out = string.missing;
  else
    out = string.missing (sz);
  endif
endfunction
