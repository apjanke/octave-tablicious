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

# This is based on the longley dataset from R’s datasets package

classdef longley < octave.internal.dataset

  methods

    function this = longley
      this.name = "longley";
      this.summary = "Longley’s Economic Regression Data";
    endfunction

    function out = load (this)
      Year = [1947:1962]';
      GNP_deflator = [83, 88.5, 88.2, 89.5, 96.2, 98.1, 99, 100, 101.2, 104.6, ...
        108.4, 110.8, 112.6, 114.2, 115.7, 116.9]';
      GNP = [234.289, 259.426, 258.054, 284.599, 328.975, 346.999, ...
        365.385, 363.112, 397.469, 419.18, 442.769, ...
        444.546, 482.704, 502.601, 518.173, 554.894]';
      Unemployed = [235.6, 232.5, 368.2, 335.1, 209.9, 193.2, 187, 357.8, ...
        290.4, 282.2, 293.6, 468.1, 381.3, 393.1, 480.6, 400.7]';
      Armed_Forces = [159, 145.6, 161.6, 165, 309.9, 359.4, 354.7, 335, ...
        304.8, 285.7, 279.8, 263.7, 255.2, 251.4, 257.2, 282.7]';
      Population = [107.608, 108.632, 109.773, 110.929, 112.075, 113.27, ...
        115.094, 116.219, 117.388, 118.734, 120.445, ...
        121.95, 123.366, 125.368, 127.852, 130.081]';
      Employed = [60.323, 61.122, 60.171, 61.187, 63.221, 63.639, 64.989, 63.761, ...
        66.019, 67.857, 68.169, 66.513, 68.655, 69.564, 69.331, 70.551]';
      out = table (Year, GNP_deflator, GNP, Unemployed, Armed_Forces, ...
        Population, Employed);
    endfunction

  endmethods

endclassdef