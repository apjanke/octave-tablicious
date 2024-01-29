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

function out = parse_ismissing_indicator (indicator)
%PARSE_ISMISSING_INDICATOR Parse indicator argument for ismissing() and friends
%
% Parses an "indicator" input value and converts it to a regular 
% indicator value. A regular indicator value is a cell row vector whose
% elements are either:
%   * a single string as a char row vector
%   * a scalar value of any type
%
% Throws an error if the input could not be cleanly converted to a regular
% indicator value.

in = indicator;

x = in;

% Convert non-cells by breaking out elements or converting strings
if ~iscell (x)
  if ischar (x)
  	x = cellstr (x);
  else
  	x = num2cell (x);
  endif
endif

x = x(:)';

% Validate
for i = 1:numel (x)
  el = x{i};
  if ischar (el)
  	if size (el, 1) > 1
  	  error ('ismissing: char indicator elements must be row vectors; element %d is %d rows high', ...
  	    i, size (el, 1));
  	endif
  else
  	if ~isscalar (el)
  	  error ('ismissing: non-char indicator elements must be scalar; element %d is a %s %s', ...
  	    size2str (size (el)), class (el));
  	endif
  endif
endfor

out = x;

endfunction