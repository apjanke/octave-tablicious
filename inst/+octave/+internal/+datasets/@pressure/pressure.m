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

# This is based on the pressure dataset from R’s datasets package

classdef pressure < octave.internal.dataset

  methods

    function this = pressure
      this.name = "pressure";
      this.summary = "Vapor Pressure of Mercury as a Function of Temperature";
    endfunction

    function out = load (this)
      temperature = [0, 20, 40, 60, 80, 100, 120, 140, 160, 180, ...
        200, 220, 240, 260, 280, 300, 320, 340, 360]';
      pressure = [0.0002, 0.0012, 0.006, 0.03, 0.09, 0.27, ...
        0.75, 1.85, 4.2, 8.8, 17.3, 32.1, 57, 96, 157, ...
        247, 376, 558, 806]';
      out = table (temperature, pressure);
    endfunction

  endmethods

endclassdef