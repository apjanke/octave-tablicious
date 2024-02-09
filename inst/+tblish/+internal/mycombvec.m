## Copyright (C) 2019, 2023, 2024 Andrew Janke <floss@apjanke.net>
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

function out = mycombvec (vecs)
  #MYCOMBVEC All combinations of elements from vectors
  #
  # out = mycombvec (vecs)
  #
  # This is kind of similar to Matlab's combvec, but has a different signature, taking
  # a single cell array containing a list of vectors, instead of each vector in a
  # separate argument, and combining all the elements of the input vectors, instead of
  # combining rows of the input arrays. It should probably be named something like
  # "combel" instead of "combvec", because it's not producing combinations of column
  # vectors; it's just producing combinations of elements.
  #
  # Does not consider unique values of the input vec elements, it just combines them
  # positionally. So if you have duplicate values in any inputs, you'll have duplicate
  # combo values (rows) in the output.
  #
  # Vecs (cell) is a cell array of input vectors to combine. Each element is an array
  # of elements to be combined, with the element from vecs{i} going in the column i
  # of the output.
  #
  # Returns an n-by-m array, where vecs was m long, and n is how many combinations were
  # produced.
  if (! iscell (vecs))
    error ('Input vecs must be cell');
  endif
  switch (numel (vecs))
    case 0
      error ('Must supply at least one input vector');
    case 1
      out = vecs{1}(:);
    case 2
      a = vecs{1}(:);
      b = vecs{2}(:);
      out = repmat (a, [numel(b) 2]);
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
      rest_combs = tblish.internal.mycombvec (rest);
      for i = 1:numel (a)
        out = [out; [repmat(a(i), [size(rest_combs,1) 1]) rest_combs]];
      endfor
  endswitch
endfunction
