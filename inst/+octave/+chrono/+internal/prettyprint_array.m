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

function out = prettyprint_array (strs)
%PRETTYPRINT_ARRAY Pretty-print an array from dispstrs
%
% out = prettyprint_array (strs)
%
% strs (cellstr) is an array of display strings of any size.

if ismatrix (strs)
    out = prettyprint_matrix (strs);
else
    sz = size (strs);
    high_sz = sz(3:end);
    high_ixs = {};
    for i = 1:numel (high_sz)
        high_ixs{i} = [1:high_sz(i)]';
    endfor
    page_ixs = dispstr.internal.mycombvec (high_ixs);
    chunks = {};
    for i_page = 1:size (page_ixs, 1)
        page_ix = page_ixs(i_page,:);
        chunks{end+1} = sprintf ('(:,:,%s) = ', ...
            strjoin (dispstr.internal.num2cellstr (page_ix), ':')); %#ok<*AGROW>
        page_ix_cell = num2cell (page_ix);
        page_strs = strs(:,:,page_ix_cell{:});
        chunks{end+1} = prettyprint_matrix (page_strs);
    endfor
    out = strjoin (chunks, '\n');
endif
if nargout == 0
    disp (out);
    clear out;
endif
endfunction

function out = prettyprint_matrix (strs)
if ~ismatrix (strs)
    error ('Input must be matrix; got %d-D', ndims (strs));
endif
lens = cellfun ('prodofsize', strs);
widths = max (lens);
formats = octave.chrono.internal.sprintfv ('%%%ds', widths);
format = strjoin (formats, '   ');
lines = cell (size (strs,1), 1);
for i = 1:size (strs, 1)
    lines{i} = sprintf (format, strs{i,:});
endfor
out = strjoin (lines, '\n');
endfunction