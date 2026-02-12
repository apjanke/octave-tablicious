## Copyright (C) 2019, 2023, 2024, 2026 Andrew Janke
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; If not, see <http://www.gnu.org/licenses/>.

## === texinfo disabled for this function so it doesn't show in the doco ===
##
## @node table.resolveVarRef
## @deftypefn {Function} {[@var{ixVar}, @var{varNames}] =} resolveVarRef (@var{tbl}, @var{varRef})
## @deftypefnx {Function} {[@var{ixVar}, @var{varNames}] =} resolveVarRef (@var{tbl}, @var{varRef}, @var{strictness})
##
## Resolve a variable reference against this table.
##
## A @var{varRef} is a numeric or char/cellstr indicator of which variables within
## @var{tbl} are being referenced.
##
## @var{strictness} controls what to do when the given variable references
## could not be resolved. It may be 'strict' (the default) or 'lenient'.
##
## Returns:
##   @var{ixVar} - the indexes of the variables in @var{tbl}, as a numeric or logical
##       row vector.
##   @var{varNames} - a cellstr of the names of the variables in @var{tbl}
##
## Raises an error if any of the specified variables could not be resolved,
## unless strictness is 'lenient', in which case it will return 0 for the
## index and '' for the name for each variable which could not be resolved.
##
## @end deftypefn
function [ixVar, varNames] = resolveVarRef (tbl, varRef, strictness)
  #RESOLVEVARREF Resolve a reference to variables
  #
  # A varRef is a numeric or char/cellstr indicator of which variables within
  # this table are being referenced.
  if (nargin < 3 || isempty (strictness)); strictness = 'strict'; endif
  mustBeMember (strictness, {'strict','lenient'});
  if (isnumeric (varRef) || islogical (varRef))
    ixVar = varRef;
    ix_bad = find(ixVar > width (tbl) | ixVar < 1);
    if (! isempty (ix_bad))
      error ('table: variable index out of bounds: %d (table has %d variables)', ...
        ix_bad(1), width (tbl));
    endif
  elseif (isequal (varRef, ':'))
    ixVar = 1:width (tbl);
  elseif (ischar (varRef) || iscellstr (varRef))
    varRef = cellstr (varRef);
    [tf, ixVar] = ismember (varRef, tbl.Properties.VariableNames);
    if (isequal (strictness, 'strict'))
      if (! all (tf))
        error ('table: No such variable in table: %s', strjoin (varRef(!tf), ', '));
      endif
    else
      ixVar(!tf) = 0;
    endif
  elseif (isa (varRef, 'tblish.internal.table.vartype_filter'))
    ixVar = [];
    for i = 1:width (tbl)
      if (varRef.matches (tbl.Properties.VariableValues{i}))
        ixVar(end+1) = i;
      endif
    endfor
  else
    error ('table: Unsupported variable indexing operand type: %s', class (varRef));
  endif
  varNames = repmat ({''}, size (ixVar));
  varNames(ixVar != 0) = tbl.Properties.VariableNames(ixVar(ixVar != 0));
  ixVar = ixVar(:)';
endfunction
