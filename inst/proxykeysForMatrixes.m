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

function [pkA, pkB] = proxykeysForMatrixes (A, B)
  %PROXYKEYSFORMATRIXES Compute row proxy keys for matrices
  %
  % pkA = proxykeysForMatrixes (A)
  % [pkA, pkB] = proxykeysForMatrixes (A, B)
  %
  % Computes row-identity "proxy key" matrix pairs for input matrices. A proxy 
  % key matrix pair is a pair of double matrices whose respective rows have the 
  % same identity and ordering relationships (both within the same matrix and
  % across the two matrices) as the corresponding rows in the input matrices.
  % In the case of one input, proxy keys are computed for that matrix on its own,
  % without reference to any other input.
  %
  % Proxy keys are used by table for efficient computation of record identity/equality
  % and ordering for tables with heterogeneous variable types.
  %
  % For an m1-by-n A and m2-by-n B, pkA and pkB will be m1-by-k and m2-by-k,
  % respectively. k is not necessarily the same as n; it may be smaller or larger.
  %
  % The identity and ordering relationships between rows will be true even in 
  % the case of NaN and NaN-like inputs, including the case where some but not 
  % all of the columns in the
  %
  % In particular, this means that the following relationships hold:
  %
  %   [tf, s_idx] = ismember(pkA, pkB, 'rows')
  %   [tf, s_idx] = ismember(A, B, 'rows')           % same tf, s_idx results
  %
  %   all(pkA(i,:) == pkB(j,:), 2) == all(A(i,:), B(j,:), 2)   % For any i, j
  %
  %   any(isnan(pkA), 2) == any(isnannish(A), 2)
  %   % where "isnannish()" uses whichever of isnan() or isnat() is defined for A
  %   
  %   [~, s_idx] = sortrows(A)
  %   [~, s_idx] = sortrows(pkA)  % same s_idx result
  %
  % (The more-specific identity of Octave isna() inputs versus isnan()-but-not-isna()
  % inputs is *not* preserved. This is a limitation of the current proxykeysForMatrixes
  % implementation, not necessarily a limitation of the semantics of the isna() 
  % interface, so this shortcoming may be addressed in the future.)
  %
  % The generic proxykeysForMatrixes function can compute proxy keys for any type
  % that supports the `unique()` function (as long as that unique()
  % implementation does not itself depend on proxykeysForMatrixes).
  %
  % Note that the proxy key identity and ordering relationships:
  %  a) Are for entire *rows* of matrices, not individual *elements* within the
  %     matrix. In particular, a given value x in one column of A may be represented
  %     by one proxy key element value in one column of pkA, and another proxy key 
  %     element value in another column of pkA.
  %  b) Only hold within the scope of the specific values in A and B, so they are
  %     only good for comparisons between those two specific matrices. The proxy
  %     key values for a given row in A may change if either other rows in A have
  %     different values, or if any rows in B have different values. That is, for:
  %         [pkA1, pkB] = proxykeysForMatrixes (A, B)
  %         [pkA2, pkC] = proxykeysForMatrixes (A, C)
  %     pkA1 and pkA2 may not be the same values.
  %
  % User-defined classes may override proxykeysForMatrixes to provide optimized
  % implementations, or so that their unique() implementations may themselves use
  % proxykeysForMatrixes. This may be especially useful for classes which are 
  % represented internally by single numeric matrices.
  %
  % This is an Octave extension.

  % TODO: Add support for non-cellstr cell inputs.

  % Developer's note: If it wasn't for NaNs, we could make the proxy keys outputs
  % be simple column vectors with element-wise equality and ordering semantics.
  % It's only the case of the relative ordering of multi-column records where
  % some but not all columns are NaN that requires proxy keys to be matrices with
  % row-wise identity.
  
  % Input handling / conversion
  
  if nargin == 1
    pkA = proxykeysForOneMatrix (A);
    return
  endif

  if !isequal (class (A), class (B))
    [origA, origB] = deal (A, B);
    [A, B] = widenTypesForProxyKeys (A, B);
    if !isequal (class (A), class (B))
      error ("proxykeysForMatrixes: Could not convert %s and %s to compatible types", ...
        class (origA), class (origB));
    endif
  endif

  if size (A, 2) != size (B, 2)
    error ("proxykeysForMatrixes: Inputs must have same number of columns; got %d and %d", ...
      size (A, 2), size (B, 2));
  endif

  % Main proxy key computation logic
  
  % Special-case type optimizations
  widenableToDoubleIntTypes = {'uint8' 'int8' 'uint16' 'int16' 'uint32' 'int32'};
  if isa (A, 'double')
    pkA = A;
    pkB = B;
  elseif isa (A, 'single')
    pkA = double (A);
    pkB = double (B);
  elseif ismember (class (A), widenableToDoubleIntTypes)
    pkA = double (A);
    pkB = double (B);
  else
    % General case: use the pair-wise version of the "unique() trick"
    [pkA, pkB] = uniqueTrickForTwoMatrixes(A, B);
  endif
  
endfunction

function [outA, outB] = widenTypesForProxyKeys (A, B)
  outA = A;
  outB = B;
  widenableToDoubleIntTypes = {'uint8' 'int8' 'uint16' 'int16' 'uint32' 'int32'};
  if isa (A, 'double') && isa (B, 'single')
    outB = double (B);
  elseif isa (A, 'single') && isa (B, 'double')
    outA = double (A);
  elseif ismember (class (A), widenableToDoubleIntTypes) ...
      && ismember (class (B), widenableToDoubleIntTypes)
    outA = double(A);
    outB = double(B);
  endif
endfunction

function pk = proxykeysForOneMatrix (A)
  % Special-case optimizations
  if isa (A, 'double')
    pk = A;
    return;
  elseif isa (A, 'single')
    pk = double (A);
    return;
  elseif ismember (class (A), {'uint8' 'int8' 'uint16' 'int16' 'uint32' 'int32'})
    % Note that (u)int64 is not included here; it cannot be losslessly widened to double
    pk = double (A);
    return;
  elseif isa (A, 'datetime')
    pk = datenum (A);
    return;
  endif
  
  % General case: use the "unique() trick"
  pk = uniqueTrickForOneMatrix (A);
endfunction

function pkA = uniqueTrickForOneMatrix (A)
  pkA = NaN (size (A));
  for i = 1:size (A, 2)
    a_i = A(:,i);
    [ux, indx, jndx] = unique (a_i);
    tfNan = isnannish (a_i);
    pkA(:,i) = jndx;
    pkA(tfNan,i) = NaN;
  endfor  
endfunction

function [pkA, pkB] = uniqueTrickForTwoMatrixes (A, B)
  pkA = NaN (size (A));
  pkB = NaN (size (B));
  nRowsA = size (A, 1);
  nCols = size (A, 2);
  for iCol = 1:nCols
    a = A(:,iCol);
    b = B(:,iCol);
    both = [a; b];
    tfNan = isnannish (both);
    [~, indx, jndx] = unique (both);
    pkForCol = jndx;
    pkForCol(tfNan) = NaN;
    pkA(:,iCol) = pkForCol(1:nRowsA);
    pkB(:,iCol) = pkForCol(nRowsA+1:end);
  endfor
endfunction
