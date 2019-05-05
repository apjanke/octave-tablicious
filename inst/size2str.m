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

## -*- texinfo -*-
## @node size2str
## @deftypefn {Function} {@var{out} =} size2str (@var{sz})
##
## Format an array size for display.
##
## Formats the given array size @var{sz} as a string for human-readable
## display. It will be in the format “d1-by-d2-...-by-dN”, for the @var{N}
## dimensions represented by @var{sz}.
##
## @var{sz} is an array of dimension sizes, in the format returned by
## the @code{size} function.
##
## Returns a charvec.
##
## Examples:
## @example
## str = size2str (size (magic (4)))
##     @result{} str = 4-by-4
## @end example
##
## @end deftypefn
function out = size2str (sz)
	strs = cell (size (sz));
	for i = 1:numel (sz)
		strs{i} = sprintf ("%d", sz(i));
	endfor
	out = strjoin (strs, "-by-");
endfunction
