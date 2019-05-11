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

# This is based on the HairEyeColor dataset from R’s datasets package

classdef HairEyeColor < octave.internal.dataset

  methods

    function this = HairEyeColor
      this.name = "HairEyeColor";
      this.summary = "Hair and Eye Color of Statistics Students";
    endfunction

    function out = load (this)
      n = [32, 53, 10, 3, 11, 50, 10, 30, 10, 25, 7, 5, 3, 15, 7, 8, ...
        36, 66, 16, 4,  9, 34,  7, 64,  5, 29, 7, 5, 2, 14, 7, 8, ...
        32, 53, 10, 3, 11, 50, 10, 30, 10, 25, 7, 5, 3, 15, 7, 8, ...
        36, 66, 16, 4,  9, 34,  7, 64,  5, 29, 7, 5, 2, 14, 7, 8];
      n = reshape (n, [4 4 2]);
      hair = {"Black", "Brown", "Red", "Blond"};
      eye = {"Brown", "Blue", "Hazel", "Green"};
      sex = {"Male", "Female"};
      out.n = n;
      out.hair = hair;
      out.eye = eye;
      out.sex = sex;
    endfunction

  endmethods

endclassdef