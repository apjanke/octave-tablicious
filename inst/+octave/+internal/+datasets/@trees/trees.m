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

# This is based on the trees dataset from R’s datasets package

classdef trees < octave.internal.dataset

  methods

    function this = trees
      this.name = "trees";
      this.summary = "Diameter, Height and Volume for Black Cherry Trees";
    endfunction

    function out = load (this)
      Girth = [8.3, 8.6, 8.8, 10.5, 10.7, 10.8, 11, 11, 11.1, ...
        11.2, 11.3, 11.4, 11.4, 11.7, 12, 12.9, 12.9, 13.3, 13.7, 13.8, 14, 14.2, ...
        14.5, 16, 16.3, 17.3, 17.5, 17.9, 18, 18, 20.6]';
      Height = [70, 65, 63, ...
        72, 81, 83, 66, 75, 80, 75, 79, 76, 76, 69, 75, 74, 85, 86, 71, 64, 78, ...
        80, 74, 72, 77, 81, 82, 80, 80, 80, 87]';
      Volume = [10.3, 10.3, 10.2, 16.4, ...
        18.8, 19.7, 15.6, 18.2, 22.6, 19.9, 24.2, 21, 21.4, 21.3, 19.1, 22.2, 33.8, ...
        27.4, 25.7, 24.9, 34.5, 31.7, 36.3, 38.3, 42.6, 55.4, 55.7, 58.3, 51.5, ...
        51, 77]';
      out = table (Girth, Height, Volume);
    endfunction

  endmethods

endclassdef