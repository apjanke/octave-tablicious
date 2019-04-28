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

function out = vecfun(fcn, x, dim)
  %VECFUN Apply a function to vector slices of an N-dimensional array
  %
  % out = vecfcn(fcn, x, dim)
  %
  % This is like arrayfun, except instead of iterating over all dimensions and
  % applying a function to scalar elements of an array, it iterates over all but
  % one specified dimension of an array, and applies a function to the vector
  % slices along that dimension.
  
  n_dims = ndims (x);
  
  error('vecfun: This function is not yet implemented. Sorry.');
endfunction
