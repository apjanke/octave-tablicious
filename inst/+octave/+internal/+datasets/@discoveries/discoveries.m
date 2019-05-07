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

# This is based on the discoveries dataset from R’s datasets package

classdef discoveries < octave.internal.dataset

  methods

    function this = discoveries
      this.name = "discoveries";
      this.summary = "Yearly Numbers of Important Discoveries";
    endfunction

    function out = load (this)
      year = [1860:1959]';
      discoveries = [5, 3, 0, 2, 0, 3, 2, 3, 6, 1, 2, 1, 2, 1, 3, 3, 3, 5, 2, 4, ...
        4, 0, 2, 3, 7, 12, 3, 10, 9, 2, 3, 7, 7, 2, 3, 3, 6, 2, 4, 3, 5, 2, 2, ...
        4, 0, 4, 2, 5, 2, 3, 3, 6, 5, 8, 3, 6, 6, 0, 5, 2, 2, 2, 6, 3, 4, 4, 2, ...
        2, 4, 7, 5, 3, 3, 0, 2, 2, 2, 1, 3, 4, 2, 2, 1, 1, 1, 2, 1, 4, 4, 3, 2, ...
        1, 4, 1, 1, 1, 0, 0, 2, 0]';
      out = table (year, discoveries);
    endfunction

  endmethods

endclassdef