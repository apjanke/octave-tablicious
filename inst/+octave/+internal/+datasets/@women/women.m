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

# This is based on the women dataset from R’s datasets package

classdef women < octave.internal.dataset

  methods

    function this = women
      this.name = "women";
      this.summary = "Average Heights and Weights for American Women";
    endfunction

    function out = load (this)
      height = [58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, ...
        70, 71, 72]';
      weight = [115, 117, 120, 123, 126, 129, 132, 135, 139, 142, ...
        146, 150, 154, 159, 164]';
      out = table (height, weight);
    endfunction

  endmethods

endclassdef