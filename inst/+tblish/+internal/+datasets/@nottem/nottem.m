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

# This is based on the nottem dataset from R’s datasets package

classdef nottem < tblish.internal.dataset

  methods

    function this = nottem
      this.name = "nottem";
      this.summary = "Average Monthly Temperatures at Nottingham, 1920-1939";
    endfunction

    function out = load (this)
      month = [datetime(1920, 1, 1):calmonths(1):datetime(1939, 12, 1)]';
      temp = [40.6, 40.8, 44.4, 46.7, 54.1, 58.5, 57.7, 56.4, 54.3, ...
        50.5, 42.9, 39.8, 44.2, 39.8, 45.1, 47, 54.1, 58.7, 66.3, 59.9, ...
        57, 54.2, 39.7, 42.8, 37.5, 38.7, 39.5, 42.1, 55.7, 57.8, 56.8, ...
        54.3, 54.3, 47.1, 41.8, 41.7, 41.8, 40.1, 42.9, 45.8, 49.2, 52.7, ...
        64.2, 59.6, 54.4, 49.2, 36.3, 37.6, 39.3, 37.5, 38.3, 45.5, 53.2, ...
        57.7, 60.8, 58.2, 56.4, 49.8, 44.4, 43.6, 40, 40.5, 40.8, 45.1, ...
        53.8, 59.4, 63.5, 61, 53, 50, 38.1, 36.3, 39.2, 43.4, 43.4, 48.9, ...
        50.6, 56.8, 62.5, 62, 57.5, 46.7, 41.6, 39.8, 39.4, 38.5, 45.3, ...
        47.1, 51.7, 55, 60.4, 60.5, 54.7, 50.3, 42.3, 35.2, 40.8, 41.1, ...
        42.8, 47.3, 50.9, 56.4, 62.2, 60.5, 55.4, 50.2, 43, 37.3, 34.8, ...
        31.3, 41, 43.9, 53.1, 56.9, 62.5, 60.3, 59.8, 49.2, 42.9, 41.9, ...
        41.6, 37.1, 41.2, 46.9, 51.2, 60.4, 60.1, 61.6, 57, 50.9, 43, ...
        38.8, 37.1, 38.4, 38.4, 46.5, 53.5, 58.4, 60.6, 58.2, 53.8, 46.6, ...
        45.5, 40.6, 42.4, 38.4, 40.3, 44.6, 50.9, 57, 62.1, 63.5, 56.3, ...
        47.3, 43.6, 41.8, 36.2, 39.3, 44.5, 48.7, 54.2, 60.8, 65.5, 64.9, ...
        60.1, 50.2, 42.1, 35.8, 39.4, 38.2, 40.4, 46.9, 53.4, 59.6, 66.5, ...
        60.4, 59.2, 51.2, 42.8, 45.8, 40, 42.6, 43.5, 47.1, 50, 60.5, ...
        64.6, 64, 56.8, 48.6, 44.2, 36.4, 37.3, 35, 44, 43.9, 52.7, 58.6, ...
        60, 61.1, 58.1, 49.6, 41.6, 41.3, 40.8, 41, 38.4, 47.4, 54.1, ...
        58.6, 61.4, 61.8, 56.3, 50.9, 41.4, 37.1, 42.1, 41.2, 47.3, 46.6, ...
        52.4, 59, 59.6, 60.4, 57, 50.7, 47.8, 39.2, 39.4, 40.9, 42.4, ...
        47.8, 52.4, 58, 60.7, 61.8, 58.2, 46.7, 46.6, 37.8]';
      out = table (momnth, temp);
    endfunction

  endmethods

endclassdef
