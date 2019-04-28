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
## @deftypefn {Function File} {[@code{a}, @code{b}] =} mustBeSameSize (@code{a}, @code{b}, @code{labelA}, @code{labelB})
##
## Requires that the inputs are the same size.
##
## Raises an error if the inputs @code{a} and @code{b} are not the same size,
## as determined by @code{isequal (size (a), size (b))}.
##
## @code{labelA} and @code{labelB} are optional inputs that determine how 
## the input will be described in error messages. If not supplied, 
## @code{inputname (...)} is used, and if that is empty, it falls back to 
## "input 1" and "input 2".
##
## @end deftypefn

function [a, b] = mustBeSameSize (a, b, labelA, labelB)
  if nargin < 3; labelA = []; endif
  if nargin < 4; labelB = []; endif
  if ! isequal (size (a), size (b))
    if isempty (labelA)
      label = inputname (1);
    endif
    if isempty (labelA)
      label = "input 1";
    endif
    if isempty (labelB)
      label = inputname (2);
    endif
    if isempty (labelB)
      label = "input 2";
    endif
    error ("%s and %s must be the same size; got %s and %s", ...
      labelA, labelB, size2str (size (a)), size2str (size (b)));
  endif
endfunction
