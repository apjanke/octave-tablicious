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

function out = contains (str, pattern, varargin)
  %CONTAINS Test if strings contain a pattern
  %
  % out = contains (str, pattern)
  % out = contains (str, pattern, 'IgnoreCase', true)
  %
  % Tests whether the given strings contain the given pattern(s).
  %
  % str (char, cellstr, string) is a list of strings to compare against 
  % pattern.
  %
  % pattern (char, cellstr, string) is a list of patterns to match. These are
  % literal plain string patterns, not regex patterns. If more than one pattern
  % is supplied, the return value is true if the string matched any of them.
  %
  % Returns a logical array of the same size as the string array represented by
  % str.
  
  [opts, args] = peelOffNameValueOptions (varargin, {'IgnoreCase'});
  ignore_case = false;
  if isfield (opts, 'IgnoreCase')
    mustBeScalarLogical (opts.IgnoreCase, 'IgnoreCase option');
    ignore_case = opts.IgnoreCase;
  endif
  
  str = cellstr (str);
  pattern = cellstr (pattern);
  
  if any (cellfun ('isempty', pattern(:)))
    out = true (size (str));
    return;
  endif
  
  % TODO: This implementation is inefficient, because strfind() scans the
  % full string for multiple matches. Could replace this whole function with
  % an oct-file that does efficient scanning.
  
  if ignore_case
    str = lower (str);
    pattern = lower (pattern);
  endif
  out = false (size (str));
  for i_str = 1:numel (str)
    for i_pattern = 1:numel (pattern)
      pat = pattern{i_pattern};
      ix = strfind (str{i_str}, pattern{i_pattern});
      tf = ! isempty (ix);
      if tf
        out(i_str) = true;
        break
      endif
    endfor
  endfor
endfunction
