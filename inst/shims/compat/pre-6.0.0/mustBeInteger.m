## Copyright (C) 2019, 2023, 2024 Andrew Janke
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
## @deftypefn {Function File} {@var{x} =} mustBeInteger (@var{x}, @var{label})
##
## Requires that input is integer-valued (but not necessarily integer-typed).
##
## Raises an error if any element of the input @var{x} is not a finite,
## real, integer-valued numeric value, as determined by various checks.
##
## @var{label} is an optional input that determines how the input will be described in
## error messages. If not supplied, @code{inputname (1)} is used, and if that is
## empty, it falls back to "input".
##
## @end deftypefn

function x = mustBeInteger (x, label)
  if nargin < 2; label = []; endif
  if isinteger (x) || islogical (x)
    return
  endif
  but = [];
  if ! isnumeric (x)
    but = sprintf ("it was non-numeric (got a %s)", class (x));
  elseif any (! isfinite (x))
    but = "there were Inf values";
  elseif ! isreal (x)
    but = "it was complex";
  elseif ! all (floor (x) == x)
    but = "it had fractional values in some elements";
  endif
  if ! isempty (but)
    if isempty (label)
      label = inputname (1);
    endif
    if isempty (label)
      label = "input";
    endif
    error ("%s must be integer-valued; but %s", ...
      label, but);
  endif
endfunction
