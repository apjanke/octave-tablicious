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

# This is based on the InsectSprays dataset from R’s datasets package

classdef InsectSprays < octave.internal.dataset

  methods

    function this = InsectSprays
      this.name = "InsectSprays";
      this.summary = "Effectiveness of Insect Sprays";
    endfunction

    function out = load (this)
      spray = categorical ([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, ...
        2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, ...
        4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, ...
        6, 6, 6, 6, 6, 6, 6, 6, 6]', 1:6, {"A", "B", "C", "D", "E", "F"});
      count = [10, 7, 20, 14, 14, 12, 10, 23, 17, 20, 14, 13, ...
        11, 17, 21, 11, 16, 14, 17, 17, 19, 21, 7, 13, 0, 1, 7, 2, 3, 1, 2, 1, ...
        3, 0, 1, 4, 3, 5, 12, 6, 4, 3, 5, 5, 5, 5, 2, 4, 3, 5, 3, 5, 3, 6, 1, 1, ...
        3, 2, 6, 4, 11, 9, 15, 22, 15, 16, 13, 10, 26, 26, 24, 13]';
      out = table (spray, count);
    endfunction

  endmethods

endclassdef