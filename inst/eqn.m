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
## @deftypefn {Function} {@var{out} =} eqn (@var{A}, @var{B})
##
## Determine element-wise equality, treating NaNs as equal
##
## out = eqn (A, B)
##
## @code{eqn} is just like @code{eq} (the function that implements the 
## @code{==} operator), except
## that it considers NaN and NaN-like values to be equal. This is the element-wise
## equivalent of @code{isequaln}.
##
## @code{eqn} uses @code{isnannish} to test for NaN and NaN-like values, 
## which means that NaNs and NaTs are considered to be NaN-like, and 
## string arrays’ “missing” and categorical objects’ “undefined” values 
## are considered equal, because they are NaN-ish.
##
## Developer's note: the name “@code{eqn}” is a little unfortunate,
## because “eqn” could also be an abbreviation for “equation”. But this 
## name follows the @code{isequaln} pattern of appending an “n” to the
## corresponding non-NaN-equivocating function.
##
## See also: @code{eq}, @code{isequaln}, @ref{isnannish}
##
## @end deftypefn
function out = eqn (A, B)
  
  % Developer's note: the name is a little unfortunate because "eqn" could also
  % be an abbreviation for "equation", but this name follows the ISEQUALN pattern
  % of appending an "N" to the corresponding non-NaN-aware function.
  
  out = A == B;
  out(isnannish (A) & isnannish (B)) = true;

endfunction
