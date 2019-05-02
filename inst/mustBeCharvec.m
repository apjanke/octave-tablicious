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
## @deftypefn {Function File} {@code{x} =} mustBeCharvec (@code{x}, @code{label})
##
## Requires that input is a char row vector.
##
## Raises an error if the input @code{x} is not a row vector of @code{char}s.
## @code{char} row vectors are Octave's normal representation of single strings.
## (They are what are produced by @code{'...'} string literals.) As a special
## case, 0-by-0 empty chars (what is produced by the string literal @code{''})
## are also considered charvecs.
##
## This does not differentiate between single-quoted and double-quoted strings.
##
## @code{label} is an optional input that determines how the input will be described in
## error messages. If not supplied, @code{inputname (1)} is used, and if that is
## empty, it falls back to "input".
##
## @end deftypefn

function mustBeCharvec (x, label)
  if nargin < 2; label = []; endif
  if ! (ischar (x) && (isrow (x) || isequal (size (x), [0 0])))
    if isempty (label)
      label = inputname (1);
    endif
    if isempty (label)
      label = "input";
    endif
    error ("%s must be a char row vector; got a %s %s", ...
      label, size2str (size (x)), class (x));
  endif
endfunction
