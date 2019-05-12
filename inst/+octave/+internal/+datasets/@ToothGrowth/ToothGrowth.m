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

# This is based on the ToothGrowth dataset from R’s datasets package

classdef ToothGrowth < octave.internal.dataset

  methods

    function this = ToothGrowth
      this.name = "ToothGrowth";
      this.summary = "The Effect of Vitamin C on Tooth Growth in Guinea Pigs";
    endfunction

    function out = load (this)
      len = [4.2, 11.5, 7.3, 5.8, 6.4, 10, 11.2, 11.2, 5.2, 7, ...
        16.5, 16.5, 15.2, 17.3, 22.5, 17.3, 13.6, 14.5, 18.8, 15.5, 23.6, 18.5, ...
        33.9, 25.5, 26.4, 32.5, 26.7, 21.5, 23.3, 29.5, 15.2, 21.5, 17.6, 9.7, ...
        14.5, 10, 8.2, 9.4, 16.5, 9.7, 19.7, 23.3, 23.6, 26.4, 20, 25.2, 25.8, ...
        21.2, 14.5, 27.3, 25.5, 26.4, 22.4, 24.5, 24.8, 30.9, 26.4, 27.3, 29.4, ...
        23]';
      supp = categorical ([2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, ...
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, ...
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]', ...
        1:2, {"OJ", "VC"});
      dose = [0.5, 0.5, 0.5, 0.5, 0.5, ...
        0.5, 0.5, 0.5, 0.5, 0.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, ...
        2, 2, 2, 2, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 1, 1, ...
        1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]';
      out = table (supp, dose, len);
    endfunction

  endmethods

endclassdef