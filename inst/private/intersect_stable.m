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

function [out, indx, jndx] = intersect_stable (A, B)
  %INTERSECT_STABLE Set intersection with stable value ordering
  
  [tf, indx] = ismember (A, B);
  out = A(tf);
  [uOut, ix2] = unique (out);
  if numel (uOut) < numel (out)
    ixDup = 1:numel (out);
    ixDup(ix2) = [];
    out(ixDup) = [];
    indx(ixDup) = [];
  endif
endfunction
