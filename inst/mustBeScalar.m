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
## @deftypefn {Function File} {@var{x} =} mustBeScalar (@var{x}, @var{label})
##
## Requires that input is scalar.
##
## Raises an error if the input @var{x} is not scalar, as determined by
## @code{isscalar (x)}.
##
## @var{label} is an optional input that determines how the input will be described in
## error messages. If not supplied, @code{inputname (1)} is used, and if that is
## empty, it falls back to "input".
##
## @end deftypefn

function mustBeScalar (x)
  if !isscalar (x)
    name = inputname (1);
    if isempty (name)
      name = 'input';
    endif
    error ('%s must be scalar', name);
  endif
endfunction
