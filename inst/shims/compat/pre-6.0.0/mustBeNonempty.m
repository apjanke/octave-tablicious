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
## @deftypefn {Function} {@var{x} =} mustBeNonempty (@var{x}, @var{label})
##
## Requires that input is nonempty.
##
## Raises an error if the input @var{x} is not empty, as determined by
## @code{! isempty (x)}.
##
## @var{label} is an optional input that determines how the input will be described in
## error messages. If not supplied, @code{inputname (1)} is used, and if that is
## empty, it falls back to "input". The @var{label} argument is a Tablicious extension,
## and is not part of the standard interface of this function.
##
## This definition of @code{mustBeNonempty} is supplied by Tablicious, and is a
## compatibility shim for versions of Octave which do not provide one. It is only loaded
## in Octaves older than 6.0.0.
##
## @seealso{isempty}
##
## @end deftypefn

function x = mustBeNonempty (x, label)
  if (nargin < 2); label = []; endif
  if (isempty (x))
    if (isempty (label))
      label = inputname (1);
    endif
    if (isempty (label))
      label = "input";
    endif
    error ("%s must be nonempty; got a %s empty", ...
      label, size2str (size (x)));
  endif
endfunction
