## Copyright (C) 2019 Andrew Janke <floss@apjanke.net>
##
## This file is part of Octave.
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
## @deftypefn {Function File} {@var{out} =} calmonths (@var{x})
## Create a @code{calendarDuration} that is a given number of calendar months
## long.
##
## Input @var{x} is a numeric array specifying the number of calendar months.
##
## This is a shorthand alternative to calling the @code{calendarDuration} 
## constructor with @code{calendarDuration(0, x, 0)}.
##
## Returns a new @code{calendarDuration} object of the same size as @var{x}.
##
## @xref{calendarDuration}.
##
## @end deftypefn

function out = calmonths (x)
  %CALMONTHS Calendar duration in months
  if ~isnumeric (x)
    error ('Input must be numeric');
  endif
  out = calendarDuration (0, x, 0);  
endfunction
