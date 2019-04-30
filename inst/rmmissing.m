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
## @deftypefn {Function} {[@var{out}, @var{tf}] =} rmmissing (@var{X})
## @deftypefnx {Function} {[@var{out}, @var{tf}] =} rmmissing (@var{X}, @var{dim})
## @deftypefnx {Function} {[@var{out}, @var{tf}] =} rmmissing (@dots{}, @code{'MinNumMissing'}, @var{MinNumMissing})
##
## Remove missing values.
##
## If @var{x} is a vector, removes elements with missing values. If @var{x} is a matrix,
## removes rows or columns with missing data elements.
##
## @var{dim} is the dimension to operate along. Specifying a dimension forces @code{rmmissing}
## to operate in matrix instead of vector mode.
##
## @var{MinNumMissing} indicates how many missing element values there must be in a
## row or column for it to be considered missing and this removed. This option
## is only used in matrix mode; it is silently ignored in vector mode.
##
## Returns:
##   @var{out} - the input, with missing elements or rows or columns removed
##   @var{tf} - a logical index vector indicating which elements, rows, or columns were removed
##
## @end deftypefn
function [out,tf] = rmmissing (x, varargin)
  
  validOptions = {'MinNumMissing'};
  [opts, args] = peelOffNameValueOptions (varargin, validOptions);
  dim = [];
  if numel (args) > 1
    error ('rmmissing: Too many arguments');
  elseif numel (args) == 1
    dim = args{1};
  endif
  mustBeNumeric (dim);
  if numel (dim) > 1
    error ('rmmissing: dim must be scalar or empty; got %d-long', numel (dim));
  endif
  if ~isempty (dim) && ~ismember (dim, [1 2])
    error ('rmmissing: invalid dim: must be 1 or 2; got %f', dim);
  endif

  if ~ismatrix (x)
    error ('rmmissing: x must be vector or matrix; got %d dimensions', ndims (x));
  endif
  
  tfMissing = ismissing (x);
  
  if isvector (x) && isempty (dim)
    out = x(~tfMissing);
    tf = tfMissing;
  else
    % By default, operates along first non-scalar dimension
    if isempty (dim)
      sz = size (x);
      ixNonScalarDims = find (sz ~= 1);
      if isempty (ixNonScalarDims)
        dim = 1;
      else
        dim = ixNonScalarDims(1);
      endif
    endif
    % x is a matrix, not N-D, because we checked it before
    minNumMissing = 1;
    if isfield (opts, 'MinNumMissing')
      minNumMissing = opts.MinNumMissing;
    endif
    if dim == 1
      nMissing = sum (double(tfMissing), 2);
      tf = nMissing >= minNumMissing;
      out = x(~tf,:);
    else
      nMissing = sum (double(tfMissing), 1);
      tf = nMissing >= minNumMissing;
      out = x(:,~tf);
    endif
  endif
  
endfunction
