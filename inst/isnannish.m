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
## @deftypefn {Function} {@var{out} =} isnannish (@var{X})
##
## Test if elements are NaN or NaN-like
##
## Tests if input elements are NaN, NaT, or otherwise NaN-like. This is true
## if @code{isnan()} or @code{isnat()} returns true, and is false for types that do not support
## @code{isnan()} or @code{isnat()}.
##
## This function only exists because:
##
## @enumerate a
## @item
## Matlab decided to call their NaN values for datetime “NaT” instead, and
## test for them with a different “isnat()” function, and
## @item
## isnan() errors out for some types that do not support isnan(), like cells.
## @end enumerate
##
## @code{isnannish()} smooths over those differences so you can call it polymorphically on
## any input type.
##
## Under normal operation, @code{isnannish()} should not throw an error for any type or
## value of input.
##
## See also: @code{isnan}, @code{isnat}, @ref{ismissing}, @ref{eqn}, @code{isequaln}
##
## @end deftypefn
function out = isnannish (x)  
  if isnumeric (x)
    out = isnan (x);
  elseif isa (x, 'datetime')
    out = isnat (x);
  elseif isa (x, 'duration') || isa (x, 'calendarDuration')
    out = isnan (x);
  elseif isobject (x)
    % A check using ismember ('isnan', methods (x)) is currently broken because 
    % methods() doesn't work right on classdef objects. So use an ugly try/catch
    % instead.
    % TODO: Maybe we could use meta.class.fromName() and check its methods list
    % instead?
    try
      out = isnan (x);
      return
    catch
      % quash
    end_try_catch
    try
      out = isnat (x);
      return
    catch
      % quash
    end_try_catch
    out = false (size (x));
  else
    out = false (size (x));
  endif
endfunction
