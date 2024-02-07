## Copyright (C) 2024 Andrew Janke <floss@apjanke.net>
##
## This file is part of Tablicious.
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

function out = nanmean (x, dim)
  # mean, omitting NaNs
  #
  # This function exists so that we can do this on Octaves prior to 7.x, which did
  # not support the 'omitnan'option.
  #
  # This is a minimal implementation that supports only the mean calculations that table
  # needs.
  if (ndims (x) > 2)
    error ('tblish.internal.nanmean: only 2-D inputs are supported');
  endif

  if (isvector (x) && nargin == 1)
    x2 = x (~isnan(x));
    out = mean (x2);
  else
    if (nargin < 2 || isempty (dim)); dim = 1; endif
    if (dim == 1)
      out = NaN (1, size (x, 2));
      for i = 1:size (x, 2)
        out(i) = tblish.internal.nanmean (x(:,i));
      endfor
    elseif (dim == 2)
      outInv = tblish.internal.nanmean (x', 1);
      out = outInv';
    else
      error ('tblish.internal.nanmean: invalid dim argument: %d', dim)
    endif
  endif
endfunction
