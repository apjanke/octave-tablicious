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
## @deftypefn {Function} {@var{out} =} dispstrs (@var{x})
##
## Display strings for array.
##
## Gets the display strings for each element of @var{x}. The display strings
## should be short, one-line, human-presentable strings describing the
## value of that element.
##
## The default implementation of @code{dispstrs} can accept input of any
## type, and has decent implementations for Octave’s standard built-in types,
## but will have opaque displays for most user-defined objects.
##
## This is a polymorphic method that user-defined classes may override
## with their own custom display that is more informative.
##
## Returns a cell array the same size as @var{x}.
##
## @end deftypefn
function out = dispstrs (x)
  %DISPSTRS Display strings for arbitrary array
  if isnumeric (x) || islogical (x)
    out = reshape (strtrim (cellstr (num2str (x(:)))), size (x));
  elseif iscellstr (x) || isa (x, 'string')
    out = cellstr (x);
  elseif isa (x, 'datetime')
    out = datestrs (x);    
  elseif ischar (x)
    out = num2cell (x);
  else
    out = repmat ({sprintf('1-by-1 %s', class(x))}, size (x));
  endif
endfunction
