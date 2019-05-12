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

# This is based on the VADeaths dataset from R’s datasets package

classdef VADeaths < octave.internal.dataset

  methods

    function this = VADeaths
      this.name = "VADeaths";
      this.summary = "Death Rates in Virginia (1940)";
    endfunction

    function out = load (this)
      out.deaths = reshape ([11.7, 18.1, 26.9, 41, 66, 8.7, 11.7, 20.3, 30.9, 54.3, 15.4, ...
        24.3, 37, 54.6, 71.1, 8.4, 13.6, 19.3, 35.1, 50], [5 4]);
      out.dim_names = {"Age Group", "Demographic Group"};
      out.dim_labels = {
        {"50-54", "55-59", "60-64", "65-69", "70-74"}
        {"Rural Male", "Rural Female", "Urban Male", "Urban Female"}
      };
    endfunction

  endmethods

endclassdef