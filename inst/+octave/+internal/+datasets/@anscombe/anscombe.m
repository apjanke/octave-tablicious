## Copyright (C) 1995-2018 R Core Team
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

# This is based on the anscombe dataset from R’s datasets package

classdef anscombe < octave.internal.dataset

  methods

    function this = anscombe ()
      this.name = "anscombe";
      this.summary = 'Anscombe’s Quartet of “Identical” Simple Linear Regressions';
    endfunction

    function out = load (this)
      x1 = [10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5];
      x2 = [10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5];
      x3 = [10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5];
      x4 = [8, 8, 8, 8, 8, 8, 8, 19, 8, 8, 8];
      y1 = [8.04, 6.95,  7.58, 8.81, 8.33, 9.96, 7.24, 4.26,10.84, 4.82, 5.68];
      y2 = [9.14, 8.14,  8.74, 8.77, 9.26, 8.1,  6.13, 3.1,  9.13, 7.26, 4.74];
      y3 = [7.46, 6.77, 12.74, 7.11, 7.81, 8.84, 6.08, 5.39, 8.15, 6.42, 5.73];
      y4 = [6.58, 5.76,  7.71, 8.84, 8.47, 7.04, 5.25, 12.5, 5.56, 7.91, 6.89];
      out = struct("x", x1, "y", y1);
      out(2) = struct("x", x2, "y", y2);
      out(3) = struct("x", x3, "y", y3);
      out(4) = struct("x", x4, "y", y4);
    endfunction
  
  endmethods

endclassdef
