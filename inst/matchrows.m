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
  
  % M-code dumb-nested-loops is the only implementation we currently have
  [ixs, ixUnmatchedA, ixUnmatchedB] = matchrows_dumb_nested_loops (A, B);
  
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
  tfMatchedA = false (nRowsA, 1);
  tfMatchedB = false (nRowsB, 1);
  % Pessimistic allocation to avoid Shlemiel-the-painter behavior
  % This could be improved with a Vector/ArrayList implementation
  ixs = NaN(nRowsA * nRowsB, 2);
  nMatches = 0;
  
  for iA = 1:nRowsA
    for iB = 1:nRowsB
      if isequal (A(iA,:), B(iB,:))
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