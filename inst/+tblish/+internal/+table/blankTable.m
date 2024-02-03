## Copyright (C) 2024 Andrew Janke
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

## -*- texinfo -*-
## @deftypefn {Function} {@var{out} =} blankTable (@var{sz}, @var{varTypes}, @var{varNames} @var{fillStyle})
##
## Construct a new preallocated "blank" table for a given size and variable types.
##
## The @var{sz} argument is the size of the table array to create, as @code{[rows, cols]},
## where @code{cols} is the number of variables, and they are mostly single-column. (An
## exception is the 'table' type, which is preallocated with zero variables and thus zero
## columns.)
##
## The @var{fillStyle} argument selects which style of fill value is used for the
## preallocated variables. @code{'outer'} (the default) uses outer-join style values,
## which are typically missing values. @code{'ctor'} uses the preallocation constructor
## style, which uses zeros instead of missings for many types, and supports additional
## pseudotypes.
##
## The @varNames{varNames} argument specifies the variable names to use in the created
## table. If omitted or empty, default variable names are used. Cellstr or convertible to
## one.
##
## Returns a table array.
function out = blankTable (sz, varTypes, varNames, fillStyle)

if nargin < 3 || isempty(varNames);     varNames = {}; endif
if nargin < 4 || isempty (fillStyle);   fillStyle = 'outer'; endif

varTypes = cellstr (varTypes);
varNames = cellstr (varNames);
mustBeMember (fillStyle, {'outer', 'ctor'})
if !isequal (size (sz), [1 2])
  error ('sz must be exactly size 1-by-2; was size %s', size2str (size (sz)))
endif
doCtorStyle = isequal (fillStyle, 'ctor');

[nRows, nVars] = deal (sz(1), sz(2));
if isempty (varNames)
  varNames = tblish.internal.table.defaultVarNames (nVars);
endif

varVals = cell (1, nVars);
for i = 1:nVars
  if doCtorStyle
    proto = tblish.internal.table.fillValForTypeCtorStyle (varTypes{i});
  else
    proto = tblish.internal.table.fillValForType (varTypes{i});
  endif
  if nRows == 1
    varVal = proto;
  else
    varVal = repmat (proto, [nRows 1]);
  endif
  varVals{i} = varVal;
endfor

out = table('__tblish_backdoor__', varNames, varVals);

endfunction
