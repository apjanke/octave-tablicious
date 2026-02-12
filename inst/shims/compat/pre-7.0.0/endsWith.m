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

## -*- texinfo -*-
## @deftypefn {Function} {@var{out} =} endsWith (@var{str}, @var{pattern})
## @deftypefnx {Function} {@var{out} =} endsWith (@dots{}, @code{'IgnoreCase'}, @var{IgnoreCase})
##
## Test if strings end with a pattern.
##
## Tests whether the given strings end with the given pattern(s).
##
## @var{str} (char, cellstr, or string) is a list of strings to compare against
## @var{pattern}.
##
## @var{pattern} (char, cellstr, or string) is a list of patterns to match. These are
## literal plain string patterns, not regex patterns. If more than one pattern
## is supplied, the return value is true if the string matched any of them.
##
## Returns a logical array of the same size as the string array represented by
## @var{str}.
##
## This definition of @code{endsWith} is supplied by Tablicious, and is a compatibility shim
## for versions of Octave which do not provide one. It is only loaded in Octaves older than
## 7.0.0.
##
## @seealso{startsWith, contains}
##
## @end deftypefn
function out = endsWith (str, pattern, varargin)
  [opts, args] = tblish.internal.peelOffNameValueOptions (varargin, {'IgnoreCase'});
  ignore_case = false;
  if (isfield (opts, 'IgnoreCase'))
    mustBeScalarLogical (opts.IgnoreCase, 'IgnoreCase option');
    ignore_case = opts.IgnoreCase;
  endif

  str = cellstr (str);
  pattern = cellstr (pattern);

  if (any (cellfun ('isempty', pattern(:))))
    out = true (size (str));
    return;
  endif

  if (ignore_case)
    str = lower (str);
    pattern = lower (pattern);
  endif
  out = false (size (str));
  for i_str = 1:numel (str)
    s = str{i_str};
    for i_pattern = 1:numel (pattern)
      pat = pattern{i_pattern};
      n = numel(pat);
      if (n > numel (s))
        continue
      endif
      tf = isequal (s(end-n+1:end), pat);
      if (tf)
        out(i_str) = true;
        break
      endif
    endfor
  endfor
endfunction
