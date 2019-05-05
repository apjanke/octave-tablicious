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
## @deftypefn {Function} {} pp (@var{X})
## @deftypefnx {Function} {} pp (@var{A}, @var{B}, @var{C}, @dots{})
## @deftypefnx {Function} {} pp (@code{'A'}, @code{'B'}, @code{'C'}, @dots{})
## @deftypefnx {Function} {} pp @code{A} @code{B} @code{C} @dots{}
##
## Alias for prettyprint, for interactive use.
##
## This is an alias for prettyprint(), with additional name-conversion magic.
##
## If you pass in a char, instead of pretty-printing that directly, it will 
## grab and pretty-print the variable of that name from the caller’s workspace.
## This is so you can conveniently run it from the command line.
##
## @end deftypefn
function pp(varargin)
  %PP Alias for prettyprint, for debugging
  %
  % pp (x)
  % pp x
  % pp (A, B, C)
  % pp A B C
  %
  % This is an alias for prettyprint(), with additional name-conversion magic.
  %
  % If you pass in a string, instead of pretty-printing that directly, it will 
  % grab and pretty-print the variable of that name from the caller's workspace.
  % This is so you can conveniently run it from the command line.
  
  show_label = nargin > 1;
  for i = 1:numel (varargin)
    arg = varargin{i};
    if ischar (arg)
      label = arg;
      value = evalin ("caller", arg);
    else
      value = arg;
      label = inputname (i);
      if isempty (label)
        label = sprintf ("Input %d", i);
      endif
    endif
    
    if show_label
      fprintf ("%s:\n", label);
    endif
    prettyprint (value);
  endfor
endfunction
