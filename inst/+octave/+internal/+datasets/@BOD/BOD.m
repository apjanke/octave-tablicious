## Copyright (C) 1995-2014 R Core Team
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

# This is based on the BOD dataset from R’s datasets package

classdef BOD < octave.internal.dataset

  methods

    function this = BOD
      this.name = "BOD";
      this.summary = "Biochemical Oxygen Demand";
    endfunction

    function out = load (this)
      Time = [1, 2, 3, 4, 5, 6, 7]';
      demand = [8.3, 10.3, 19, 16, 15.6, 19.8]';
      out = table (Time, demand);
    endfunction

  endmethods

endclassdef