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

# This is based on the airmiles dataset from R’s datasets package
# https://rdrr.io/r/datasets/airmiles.html

classdef airmiles < octave.internal.dataset
  % Passenger Miles on Commercial US Airlines, 1937-1960
  %
  % Source: R example datasets

  methods

    function this = airmiles ()
      this.name = "airmiles";
      this.summary = "Passenger Miles on Commercial US Airlines, 1937-1960";
    endfunction

    function out = load (this)
      miles = [412, 480, 683, 1052, 1385, 1418, 1634, 2178, 3362, 5948, 6109, ...
               5981, 6753, 8003, 10566, 12528, 14760, 16769, 19819, 22362, ...
               25340, 25343, 29269, 30514]';
      year = [1937:1960]';
      out = table (year, miles);
    endfunction

  endmethods

endclassdef