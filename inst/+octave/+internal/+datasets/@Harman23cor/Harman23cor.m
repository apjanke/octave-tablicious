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

# This is based on the Harman23.cor dataset from R’s datasets package

classdef Harman23cor < octave.internal.dataset

  methods

    function this = Harman23cor
      this.name = "Harman23cor";
      this.summary = "Harman Example 2.3";
    endfunction

    function out = load (this)
      names = {"height", "arm.span", "forearm", "lower.leg", 
        "weight", "bitro.diameter", "chest.girth", "chest.width"};
      data = [1, 0.846, 0.805, 0.859, 0.473, ...
        0.398, 0.301, 0.382, 0.846, 1, 0.881, 0.826, 0.376, 0.326, 0.277, ...
        0.415, 0.805, 0.881, 1, 0.801, 0.38, 0.319, 0.237, 0.345, 0.859, ...
        0.826, 0.801, 1, 0.436, 0.329, 0.327, 0.365, 0.473, 0.376, 0.38, ...
        0.436, 1, 0.762, 0.73, 0.629, 0.398, 0.326, 0.319, 0.329, 0.762, ...
        1, 0.583, 0.577, 0.301, 0.277, 0.237, 0.327, 0.73, 0.583, 1, ...
        0.539, 0.382, 0.415, 0.345, 0.365, 0.629, 0.577, 0.539, 1];
      data = reshape (data, [8 8]);
      out.cov = data;
      out.vars = names;
    endfunction

  endmethods

endclassdef