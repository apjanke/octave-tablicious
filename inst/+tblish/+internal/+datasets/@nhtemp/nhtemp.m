## Copyright (C) 1995-2007 R Core Team
## Copyright (C) 2019, 2023, 2024 Andrew Janke
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

# This is based on the nhtemp dataset from R’s datasets package

classdef nhtemp < tblish.internal.dataset

  methods

    function this = nhtemp
      this.name = "nhtemp";
      this.summary = "Average Yearly Temperatures in New Haven";
    endfunction

    function out = load (this)
      year = [1912:1971]';
      temp = [49.9, 52.3, 49.4, 51.1, 49.4, 47.9, 49.8, 50.9, 49.3, 51.9, ...
        50.8, 49.6, 49.3, 50.6, 48.4, 50.7, 50.9, 50.6, 51.5, 52.8, 51.8, 51.1, ...
        49.8, 50.2, 50.4, 51.6, 51.8, 50.9, 48.8, 51.7, 51, 50.6, 51.7, 51.5, 52.1, ...
        51.3, 51, 54, 51.4, 52.7, 53.1, 54.6, 52, 52, 50.9, 52.6, 50.2, 52.6, 51.6, ...
        51.9, 50.5, 50.9, 51.7, 51.4, 51.7, 50.8, 51.9, 51.8, 51.9, 53]';
      out = table (year, temp);
    endfunction

  endmethods

endclassdef