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

# This is based on the Orange dataset from R’s datasets package

classdef Orange < octave.internal.dataset

  methods

    function this = Orange
      this.name = "Orange";
      this.summary = "Growth of Orange Trees";
    endfunction

    function out = load (this)
      record = [1:35]';
      Tree = categorical ([2, 2, 2, 2, 2, 2, 2, ...
        4, 4, 4, 4, 4, 4, 4, 1, 1, 1, 1, 1, 1, 1, 5, 5, 5, 5, 5, 5, 5, ...
        3, 3, 3, 3, 3, 3, 3]', 1:5, {"3", "1", "5", "2", "4"}, ...
        "Ordinal", true);
      age = [118, 484, 664, ...
        1004, 1231, 1372, 1582, 118, 484, 664, 1004, 1231, 1372, 1582, ...
        118, 484, 664, 1004, 1231, 1372, 1582, 118, 484, 664, 1004, 1231, ...
        1372, 1582, 118, 484, 664, 1004, 1231, 1372, 1582]';
      circumference = [30, ...
        58, 87, 115, 120, 142, 145, 33, 69, 111, 156, 172, 203, 203, ...
        30, 51, 75, 108, 115, 139, 140, 32, 62, 112, 167, 179, 209, 214, ...
        30, 49, 81, 125, 142, 174, 177]';
      out = table (record, Tree, age, circumference);
    endfunction

  endmethods

endclassdef