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

function varargout = scalarexpand (varargin)
%SCALAREXPAND Expand scalar inputs to be same size as nonscalar inputs
  sz = [];

  for i = 1:nargin
    if ~isscalar (varargin{i})
      sz_i = size (varargin{i});
      if isempty (sz)
        sz = sz_i;
      else
        if ~isequal (sz, sz_i)
          error ('Matrix dimensions must agree (%s vs %s)',...
            octave.chrono.internal.size2str (sz), octave.chrono.internal.size2str (sz_i))
        endif
      endif
    endif
  endfor

  varargout = varargin;

  if isempty (sz)
    return
  endif

  for i = 1:nargin
    if isscalar (varargin{i})
      varargout{i} = repmat (varargin{i}, sz);
    endif
  endfor

endfunction