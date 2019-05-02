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

function out = mycombvec (vecs)
  %MYCOMBVEC All combinations of values from vectors
  %
  % This is similar to Matlab's combvec, but has a different signature.
  if ~iscell (vecs)
    error ('Input vecs must be cell');
  end
  switch numel (vecs)
    case 0
      error ('Must supply at least one input vector');
    case 1
      out = vecs{1}(:);
    case 2
      a = vecs{1}(:);
      b = vecs{2}(:);
      out = repmat (a, [numel (b) 2]);
      i_comb = 1;
      for i_a = 1:numel (a)
        for i_b = 1:numel (b)
          out(i_comb,:) = [a(i_a) b(i_b)];
          i_comb = i_comb + 1;
        endfor
      endfor
    otherwise
      out = [];
      a = vecs{1}(:);
      rest = vecs(2:end);
      rest_combs = octave.chrono.internal.mycombvec (rest);
      for i = 1:numel (a)
        out = [out; [repmat (a(i), [size (rest_combs,1) 1]) rest_combs]];
      endfor
  endswitch
endfunction
