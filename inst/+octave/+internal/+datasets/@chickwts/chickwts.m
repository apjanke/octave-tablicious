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

# This is based on the chickwts dataset from R’s datasets package

classdef chickwts < octave.internal.dataset

  methods

    function this = chickwts
      this.name = "chickwts";
      this.summary = "Chicken Weights by Feed Type";
    endfunction

    function out = load (this)
      weight = [179, 160, 136, 227, 217, 168, 108, 124, 143, ...
        140, 309, 229, 181, 141, 260, 203, 148, 169, 213, 257, 244, 271, 243, 230, ...
        248, 327, 329, 250, 193, 271, 316, 267, 199, 171, 158, 248, 423, 340, 392, ...
        339, 341, 226, 320, 295, 334, 322, 297, 318, 325, 257, 303, 315, 380, 153, ...
        263, 242, 206, 344, 258, 368, 390, 379, 260, 404, 318, 352, 359, 216, 222, ...
        283, 332]';
      feed_code = [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, ...
        3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, ...
        6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 1, ...
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]';
      feed = categorical (feed_code, 1:6, {"casein", ...
        "horsebean", "linseed", "meatmeal", "soybean", "sunflower"});
      out = table (weight, feed);
    endfunction

  endmethods

endclassdef