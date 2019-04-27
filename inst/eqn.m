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

function out = eqn (A, B)
  %EQN Determine element-wise equality, treating NaNs as equal
  %
  % out = eqn (A, B)
  %
  % EQN is just like EQ (the function that implements the == operator), except
  % that it considers NaN and NaN-like values to be equal. This is the element-wise
  % equivalent of ISEQUALN.
  %
  % EQN uses ISNANNISH to test for NaN and NaN-like values, which means that NaNs
  % and NaTs are considered to be NaN-like, and it is still TBD whether string
  % and categorical objects' "missing" values will be considered equal.
  %
  % This is an Octave extension.
  %
  % See also: EQ, ISEQUALN, ISNANNISH
  
  % Developer's note: the name is a little unfortunate because "eqn" could also
  % be an abbreviation for "equation", but this name follows the ISEQUALN pattern
  % of appending an "N" to the corresponding non-NaN-aware function.
  
  out = A == B;
  out(isnannish (A) & isnany (B)) = true;

endfunction
