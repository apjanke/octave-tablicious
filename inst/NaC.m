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
## @deftypefn {Function} {@var{out} =} NaC ()
## @deftypefnx {Function} {@var{out} =} NaC (@var{sz})
##
## “Not-a-Categorical". Creates missing-valued categorical arrays.
##
## Returns a new @code{categorical} array of all missing values of
## the given size. If no input @var{sz} is given, the result is a scalar missing
## categorical.
##
## @code{NaC} is the @code{categorical} equivalent of @code{NaN} or @code{NaT}. It
## represents a missing, invalid, or null value. @code{NaC} values never compare
## equal to any value, including other @code{NaC}s.
##
## @code{NaC} is a convenience function which is strictly a wrapper around
## @code{categorical.undefined} and returns the same results, but may be more convenient
## to type and/or more readable, especially in array expressions with several values.
##
## @seealso{categorical.undefined}
##
## @end deftypefn
function out = NaC (sz)
  #NaS Not-a-Categorical (missing-valued categorical array)
  #
  # Creates a categorical array with all-missing values.
  if (nargin == 0)
    out = categorical.undefined;
  else
    out = categorical.undefined (sz);
  endif
endfunction

%!shared t, t0
%! t = NaC;
%! t0 = categorical ('foo');
%!assert (isequal (class (t), 'categorical'))
%!assert (ismissing (t))
%!assert (isnanny (t))
%!assert (! (t == t0))
%!assert (t != t0)
%!xtest assert (! (t < t0))
%!xtest assert (! (t > t0))
%!assert (! (t == t))
%!assert (t != t)
