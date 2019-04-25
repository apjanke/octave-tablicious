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

function out = struct2table (s, varargin)
  %STRUCT2TABLE Convert struct to table
  
  % Peel off trailing options
  [opts, args] = peelOffNameValueOptions (varargin, {'AsArray'});
  if isfield (opts, 'AsArray') && opts.AsArray
    error ('struct2table: AsArray option is currently unimplemented');
  endif
  if ~isempty (args)
    error ('struct2table: Unrecognized options');
  endif

  % Conversion logic
  varNames = fieldnames (s);
  if isscalar (s)
    varValues = struct2cell (s);
    out = table (varValues{:}, 'VariableNames', varNames);
  else
    s = s(:);
    c = struct2cell (s);
    c = c';
    out = cell2table (c, 'VariableNames', varNames);
  end
  
endfunction
