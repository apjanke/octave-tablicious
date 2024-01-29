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

function out = size2str (sz)
%SIZE2STR Format an array size for display
%
% out = size2str (sz)
%
% Sz is an array of dimension sizes, in the format returned by SIZE.
%
% Examples:
%
% size2str (magic (3))
  strs = cell (size (sz));
  for i = 1:numel (sz)
    strs{i} = sprintf ('%d', sz(i));
  endfor
  out = strjoin (strs, '-by-');
endfunction
