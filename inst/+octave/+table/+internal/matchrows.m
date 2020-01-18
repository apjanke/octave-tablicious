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

function [ixs, ixUnmatchedA, ixUnmatchedB] = matchrows (A, B)
  %MATCHROWS Find all matching (equal) row value pairs in input matrixes
  %
  % [ixs, ixUnmatchedA, ixUnmatchedB] = matchrows (A, B)
  %
  % This function is for the internal use of table. It is intended that this will
  % be made private or +internal before release 1.0 time; it is currently public 
  % to support convenient debugging.
  %
  % Returns:
  % ixs - an n-by-2 double matrix where each row contains (iA, iB) which are the
  %       the indexes of rows from A and B which had equal values.
  % ixUnmatchedA - a vector of indexes of rows from A which had no matches in B
  % ixUnmatchedB - a vector of indexes of rows from B which had no matches in A
  %
  % This is an Octave extension.
  %
  % Developer notes: It is my intent that if this function turns out to be useful,
  % the slow generic dumb-nested-loops implementation could be supplemented by
  % optimized implementations of smarter matching algorithms for numerics.
  % In particular:
  %  a) an oct-file using a modified merge sort could be implemented to get this down
  %     to O(n log n) time, with a per-operation cost of C-based numeric row
  %     comparisons with short-circuiting.
  %  b) for numerics, a "unique trick" similar to that used to generate proxy 
  %     keys could be used to get this down to scalar numeric proxies for row
  %     values (as long as output ordering for partial-NaN rows is not significant),
  %     at which point a pair of ismember() calls might work.
  
  if ~ismatrix (A)
    error ('matchrows: input A must be a matrix; got a %s', size2str ( size (A)));
  endif
  if ~ismatrix (B)
    error ('matchrows: input B must be a matrix; got a %s', size2str ( size (B)));
  endif
  
  # Two-way ismember will often be faster, but it's not well tested yet
  #[ixs, ixUnmatchedA, ixUnmatchedB] = matchrows_dumb_nested_loops (A, B);
  [ixs, ixUnmatchedA, ixUnmatchedB] = matchrows_two_way_ismember (A, B);
endfunction

function [ixs, ixUnmatchedA, ixUnmatchedB] = matchrows_two_way_ismember (A, B)
  % This is an attempt to do the actual matching using vectorized operations.
  % This will work a lot better on highly selective joins (those with relatively
  % few matching rows).
  
  [uA, ixIA, ixJA] = unique (A, 'rows');
  [uB, ixIB, ixJB] = unique (B, 'rows');
  % ixsK is a cell containing a list of all indexes in the input that mapped
  % to that row in the unique output
  ixsKA = octave.table.internal.jndx2kndxs (ixJA);
  ixsKB = octave.table.internal.jndx2kndxs (ixJB);
  
  [tf, loc] = ismember (uA, uB, 'rows');
  tfUnmatchedUA = !tf;
  ixUnmatchedUA = find (tfUnmatchedUA);
  ixUnmatchedUB = setdiff (1:size(uB,1), loc(tf));
  ixUMatch = [(1:size(uA,1))' loc];
  ixUMatch = ixUMatch(tf,:);
  % These are unique values, so we know we have all the possible matches.
  % Now expand them out to the original input row values
  
  % Avoid a Shlemiel by pre-allocating
  ixs = NaN(size(A,1) * size(B,1), 2);
  n_matches = 0;
  for i_match = 1:size(ixUMatch, 1)
    ixsA = ixsKA{ixUMatch(i_match,1)};
    ixsB = ixsKB{ixUMatch(i_match,2)};
    for i_a = 1:numel(ixsA)
      for i_b = 1:numel(ixsB)
        n_matches = n_matches + 1;
        ixs(n_matches,1) = ixsA(i_a);
        ixs(n_matches,2) = ixsB(i_b);
      endfor
    endfor
  endfor
  ixs = ixs(1:n_matches,:);
  
  ixsUnmatchedA = ixsKA(ixUnmatchedUA);
  ixUnmatchedA = cat(1, ixsUnmatchedA{:});
  ixsUnmatchedB = ixsKB(ixUnmatchedUB);
  ixUnmatchedB = cat(1, ixsUnmatchedB{:});
  
endfunction


function [ixs, ixUnmatchedA, ixUnmatchedB] = matchrows_dumb_nested_loops (A, B)
  % This is a dumb nested-loops M-code implementation of matchrows.
  % Even without going to an oct-file, this could be improved with some smarter
  % M-code logic. I'm just doing the easiest implementation I can for now,
  % to establish the soundness of this approach before working hard on efficiency.
  %
  % If improving this code, avoid doing much to this function: instead, use it
  % as a correctness reference, and provide separate optimized functions.

  nRowsA = size (A, 1);
  nRowsB = size (B, 1);
  nCols = size (A, 2);
  tfMatchedA = false (nRowsA, 1);
  tfMatchedB = false (nRowsB, 1);
  % Pessimistic allocation to avoid Shlemiel-the-painter behavior
  % This could be improved with a Vector/ArrayList implementation
  ixs = NaN(nRowsA * nRowsB, 2);
  nMatches = 0;
  
  for iA = 1:nRowsA
    for iB = 1:nRowsB
      # all(... == ...) is much faster than isequal(). Use that.
      #if isequal (A(iA,:), B(iB,:))
      if all (A(iA,:) == B(iB,:))
        nMatches = nMatches + 1;
        ixs(nMatches,:) = [iA iB];
        tfMatchedA(iA) = true;
        tfMatchedB(iB) = true;
      endif
    endfor
  endfor

  ixs = ixs(1:nMatches,:);
  ixUnmatchedA = find(~tfMatchedA);
  ixUnmatchedB = find(~tfMatchedB);
endfunction