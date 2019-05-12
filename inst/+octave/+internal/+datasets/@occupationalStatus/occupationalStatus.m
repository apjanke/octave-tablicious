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

# This is based on the occupationalStatus dataset from R’s datasets package

classdef occupationalStatus < octave.internal.dataset

  methods

    function this = occupationalStatus
      this.name = "occupationalStatus";
      this.summary = "Occupational Status of Fathers and their Sons";
    endfunction

    function out = load (this)
      data = [50, 16, 12, 11, 2, 12, 0, 0, ...
        19, 40, 35, 20, 8, 28, 6, 3, ...
        26, 34, 65, 58, 12,102, 19, 14, ...
        8, 18, 66, 110, 23, 162, 40, 32, ...
        7, 11, 35, 40, 25, 90, 21, 15, ...
        11, 20, 88, 183, 46, 554, 158, 126, ...
        6, 8, 23, 64, 28, 230, 143, 91, ...
        2, 3, 21, 32, 12, 177, 71, 106];
      data = reshape (data, [8 8]);
      out = data;
    endfunction

  endmethods

endclassdef