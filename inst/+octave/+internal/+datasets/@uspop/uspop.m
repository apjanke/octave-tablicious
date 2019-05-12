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

# This is based on the uspop dataset from R’s datasets package

classdef uspop < octave.internal.dataset

  methods

    function this = uspop
      this.name = "uspop";
      this.summary = "Populations Recorded by the US Census";
    endfunction

    function out = load (this)
      year = [1790:10:1970]';
      population = [3.93, 5.31, 7.24, 9.64, 12.9, 17.1, 23.2, 31.4, 39.8, 50.2, ...
        62.9, 76, 92, 105.7, 122.8, 131.7, 151.3, 179.3, 203.2]';
      out = table (year, population);
    endfunction

  endmethods

endclassdef