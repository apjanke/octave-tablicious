## Copyright (C) 1995-2007 R Core Team
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

# This is based on the OrchardSprays dataset from R’s datasets package

classdef OrchardSprays < octave.internal.dataset

  methods

    function this = OrchardSprays
      this.name = "OrchardSprays";
      this.summary = "Potency of Orchard Sprays";
    endfunction

    function out = load (this)
      decrease = [57, 95, 8, 69, 92, 90, 15, 2, 84, 6, 127, 36, ...
        51, 2, 69, 71, 87, 72, 5, 39, 22, 16, 72, 4, 130, 4, 114, 9, 20, 24, 10, ...
        51, 43, 28, 60, 5, 17, 7, 81, 71, 12, 29, 44, 77, 4, 27, 47, 76, 8, 72, ...
        13, 57, 4, 81, 20, 61, 80, 114, 39, 14, 86, 55, 3, 19];
      rowpos = [1, 2, ...
        3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, ...
        3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, ...
        3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8];
      colpos = [1, 1, 1, 1, 1, 1, ...
        1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, ...
        4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, ...
        7, 7, 8, 8, 8, 8, 8, 8, 8, 8];
      treatment = categorical ([4, 5, 2, ...
        8, 7, 6, 3, 1, 3, 2, 8, 4, 5, 1, 6, 7, 6, 8, 1, 5, 4, 3, 7, 2, 8, 1, 5, ...
        3, 6, 7, 2, 4, 5, 4, 7, 1, 3, 2, 8, 6, 1, 3, 6, 7, 2, 4, 5, 8, 2, 7, 3, ...
        6, 1, 8, 4, 5, 7, 6, 4, 2, 8, 5, 1, 3]', 1:8, {"A", "B", ...
        "C", "D", "E", "F", "G", "H"});
      out = table (rowpos, colpos, treatment, decrease);
    endfunction

  endmethods

endclassdef