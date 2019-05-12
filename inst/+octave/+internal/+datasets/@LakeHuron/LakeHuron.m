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

# This is based on the LakeHuron dataset from R’s datasets package

classdef LakeHuron < octave.internal.dataset

  methods

    function this = LakeHuron
      this.name = "LakeHuron";
      this.summary = "Level of Lake Huron 1875-1972";
    endfunction

    function out = load (this)
      year = [1875:1972]';
      level = [580.38, 581.86, 580.97, 580.8, 579.79, 580.39, 580.42, ...
        580.82, 581.4, 581.32, 581.44, 581.68, 581.17, 580.53, 580.01,  ...
        579.91, 579.14, 579.16, 579.55, 579.67, 578.44, 578.24, 579.1,  ...
        579.09, 579.35, 578.82, 579.32, 579.01, 579, 579.8, 579.83, 579.72, ... 
        579.89, 580.01, 579.37, 578.69, 578.19, 578.67, 579.55, 578.92,  ...
        578.09, 579.37, 580.13, 580.14, 579.51, 579.24, 578.66, 578.86,  ...
        578.05, 577.79, 576.75, 576.75, 577.82, 578.64, 580.58, 579.48,  ...
        577.38, 576.9, 576.94, 576.24, 576.84, 576.85, 576.9, 577.79,  ...
        578.18, 577.51, 577.23, 578.42, 579.61, 579.05, 579.26, 579.22,  ...
        579.38, 579.1, 577.95, 578.12, 579.75, 580.85, 580.41, 579.96,  ...
        579.61, 578.76, 578.18, 577.21, 577.13, 579.1, 578.25, 577.91,  ...
        576.89, 575.96, 576.8, 577.68, 578.38, 578.52, 579.74, 579.31,  ...
        579.89, 579.96]';
      out = table (year, level);
    endfunction

  endmethods

endclassdef