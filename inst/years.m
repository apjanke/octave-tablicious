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
## @deftypefn {Function File} {@var{out} =} years (@var{x})
## Create a @code{duration} @var{x} years long, or get the years in a @code{duration}
## @var{x}.
##
## If input is numeric, returns a @code{duration} array in units of fixed-length 
## years of 365.2425 days each.
##
## If input is a @code{duration}, converts the @code{duration} to a number of fixed-length
## years as double.
##
## Note: @code{years} creates fixed-length years, which may not be what you want.
## To create a duration of calendar years (which account for actual leap days),
## use @code{calyears}.
##
## @xref{calyears}.
## @end deftypefn

function out = years (x)
  %YEARS Duration in years
  %
  % If input is numeric, returns a @duration array in units of fixed-length 
  % years of 365.2425 days each.
  %
  % If input is a duration, converts the duration to a number of fixed-length
  % years as double.
  %
  % Note: years creates fixed-length years, which is probably not what you want.
  % To create a duration of calendar years (which account for actual leap days),
  % use calyears.
  if isnumeric (x)
    out = duration.ofDays (double (x) * 365.2425);
  else
    error ('Invalid input: expected numeric or duration; got %s', class (x));
  end
end
