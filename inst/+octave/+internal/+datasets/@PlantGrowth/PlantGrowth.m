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

# This is based on the PlantGrowth dataset from R’s datasets package

classdef PlantGrowth < octave.internal.dataset

  methods

    function this = PlantGrowth
      this.name = "PlantGrowth";
      this.summary = "Results from an Experiment on Plant Growth";
    endfunction

    function out = load (this)
      weight = [4.17, 5.58, 5.18, 6.11, 4.5, 4.61, 5.17, 4.53, ...
        5.33, 5.14, 4.81, 4.17, 4.41, 3.59, 5.87, 3.83, 6.03, 4.89, 4.32, 4.69, ...
        6.31, 5.12, 5.54, 5.5, 5.37, 5.29, 4.92, 6.15, 5.8, 5.26]';
      group = categorical ([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, ...
        2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]', 1:3, ...
        {"ctrl", "trt1", "trt2"});
      out = table (group, weight);
    endfunction

  endmethods

endclassdef