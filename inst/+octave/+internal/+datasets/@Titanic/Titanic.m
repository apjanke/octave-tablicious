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

# This is based on the Titanic dataset from R’s datasets package

classdef Titanic < octave.internal.dataset

  methods

    function this = Titanic
      this.name = "Titanic";
      this.summary = "Survival of passengers on the Titanic";
    endfunction

    function out = load (this)
      n = [  0,   0,  35,   0, ...
          0,   0,  17,   0, ...
        118, 154, 387, 670, ...
          4,  13,  89,   3, ...
          5,  11,  13,   0, ...
          1,  13,  14,   0, ...
         57,  14,  75, 192, ...
        140,  80,  76,  20];
      n = reshape (n, [4 2 2 2]);
      dim_names = {
        "Class", "Sex", "Age", "Survived"
      };
      dim_labels = {
        {"1st", "2nd", "3rd", "Crew"}
        {"Male", "Female"}
        {"Child", "Adult"}
        {"No", "Yes"}
      };
      out.n = n;
      out.dim_names = dim_names;
      out.dim_labels = dim_labels;
    endfunction

  endmethods

endclassdef