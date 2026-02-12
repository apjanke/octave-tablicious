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
## @deftypefn {Function} {@var{out} =} calyears (@var{x})
##
## Construct a @code{calendarDuration} a given number of years long.
##
## This is a shorthand for calling @code{calendarDuration(@var{x}, 0, 0)}.
##
## @xref{calendarDuration}.
##
## @end deftypefn

function out = calyears (x)
  #CALYEARS Calendar duration in years
  if (! isnumeric (x))
    error ('Input must be numeric');
  endif
  out = calendarDuration (x, 0, 0);
endfunction

# The Months, Days, and Time properties shouldn't be accessible bc they're private,
# but they seem to be anyway, and that's a decent way to test it I guess.
%!test
%!  d = calyears (3);
%!  assert (isa (d, 'calendarDuration'))
%!  assert (isequal (class (d), 'calendarDuration'))
%!  assert (isequal (d.Months, 36))
%!  assert (isequal (d.Days, 0))
%!  assert (isequal (d.Time, 0))
