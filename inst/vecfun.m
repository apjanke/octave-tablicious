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
## @deftypefn {Function} {@var{out} =} vecfun (@var{fcn}, @var{x}, @var{dim})
##
## Apply function to vectors in array along arbitrary dimension.
##
## This function is not implemented yet.
##
## Applies a given function to the vector slices of an N-dimensional array, where
## those slices are along a given dimension.
##
## @var{fcn} is a function handle to apply.
##
## @var{x} is an array of arbitrary type which is to be sliced and passed
## in to @var{fcn}.
##
## @var{dim} is the dimension along which the vector slices lay.
##
## Returns the collected output of the @var{fcn} calls, which will be
## the same size as @var{x}, but not necessarily the same type.
##
## @end deftypefn
function out = vecfun(fcn, x, dim)
  
  n_dims = ndims (x);
  
  error('vecfun: This function is not yet implemented. Sorry.');
endfunction
