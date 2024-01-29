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

function out = prefillNewSizeForSubsasgn(x, ixRef, fillVal)
  sz = size(x);
  if isequal(ixRef, ':')
    out = x;
  elseif isscalar(ixRef)
    ix = ixRef{1};
    out = x;
    if max(ix) > numel(x)
      if ~isvector(x)
        error('Invalid resizing operation using out-of-bounds linear indexing on a non-vector input');
      endif
      out(max(ix)) = fillVal;
      out(numel(x)+1:end) = fillVal;
    endif
  else
    ixs = ixRef;
    newSz = NaN([1 ndims(x)]);
    for i = 1:numel(ixs)
      newSz = max(size(x, i), max(ixs{i}));
    endfor
    if isequal(sz, newSz)
      out = x;
    else
      out = NaN(newSz);
      oldRange = cell(1, ndims(x));
      for i = 1:numel(oldRange)
        oldRange{i} = 1:size(x,i);
      endfor
      out(oldRange{:}) = x;
    end
  endif
endfunction
