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
## @deftypefn {Function} {@var{out} =} NaT ()
## @deftypefnx {Function} {@var{out} =} NaT (@var{sz})
##
## “Not-a-Time”. Creates NaT-valued arrays.
## 
## Constructs a new @code{datetime} array of all @code{NaT} values of
## the given size. If no input @var{sz} is given, the result is a scalar @code{NaT}.
##
## @code{NaT} is the @code{datetime} equivalent of @code{NaN}. It represents a missing
## or invalid value. @code{NaT} values never compare equal to, greater than, or less
## than any value, including other @code{NaT}s. Doing arithmetic with a @code{NaT} and
## any other value results in a @code{NaT}.
##
## @end deftypefn
function out = NaT (sz)
  %NaT Not-a-Time
  %
  % Creates an array of datetimes with the value NaT.
  if nargin == 0
    out = datetime.NaT;
  else
    out = repmat( datetime.NaT, sz);
  end
end
