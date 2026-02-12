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
## @deftypefn {Function File} {@var{out} =} caldays (@var{x})
## Create a @code{calendarDuration} that is a given number of calendar days
## long.
##
## Input @var{x} is a numeric array specifying the number of calendar days.
##
## This is a shorthand alternative to calling the @code{calendarDuration}
## constructor with @code{calendarDuration(0, 0, x)}.
##
## Returns a new @code{calendarDuration} object of the same size as @var{x}.
##
## @xref{calendarDuration}.
##
## @end deftypefn

function out = caldays (x)
  #CALDAYS Calendar duration in days
  if (! isnumeric (x))
    error ('Input must be numeric');
  endif
  out = calendarDuration (0, 0, x);
endfunction

# The Months, Days, and Time properties shouldn't be accessible bc they're private,
# but they seem to be anyway, and that's a decent way to test it I guess.
%!test
%!  d = caldays (4);
%!  assert (isa (d, 'calendarDuration'))
%!  assert (isequal (class (d), 'calendarDuration'))
%!  assert (isequal (d.Months, 0))
%!  assert (isequal (d.Days, 4))
%!  assert (isequal (d.Time, 0))
