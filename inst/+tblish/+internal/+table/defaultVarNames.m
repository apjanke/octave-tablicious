## Copyright (C) 2024 Andrew Janke
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

## -*- texinfo -*-
## @deftypefn {Function} {@var{out} =} defaultVarNames (@var{nVars})
##
## Get default variable names for a table of a given number of variables.
##
## Returns a cellstr vector.

function out = defaultVarNames (nVars)
varNames = cell (1, nVars);
for i = 1:nVars
  varNames{i} = sprintf('Var%d', i);
endfor
out = varNames;
end
