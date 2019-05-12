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

# This is based on the presidents dataset from R’s datasets package

classdef presidents < octave.internal.dataset

  methods

    function this = presidents
      this.name = "presidents";
      this.summary = "Quarterly Approval Ratings of US Presidents";
    endfunction

    function out = load (this)
      approval = [NaN, 87, 82, 75, 63, 50, 43, 32, 35, 60, 54, 55, 36, 39, NaN, ...
        NaN, 69, 57, 57, 51, 45, 37, 46, 39, 36, 24, 32, 23, 25, 32, NaN, 32, 59,  ...
        74, 75, 60, 71, 61, 71, 57, 71, 68, 79, 73, 76, 71, 67, 75, 79, 62, 63,  ...
        57, 60, 49, 48, 52, 57, 62, 61, 66, 71, 62, 61, 57, 72, 83, 71, 78, 79,  ...
        71, 62, 74, 76, 64, 62, 57, 80, 73, 69, 69, 71, 64, 69, 62, 63, 46, 56,  ...
        44, 44, 52, 38, 46, 36, 49, 35, 44, 59, 65, 65, 56, 66, 53, 61, 52, 51,  ...
        48, 54, 49, 49, 61, NaN, NaN, 68, 44, 40, 27, 28, 25, 24, 24]';
      date = [datetime(1945, 1, 1):calmonths(3):datetime(1974, 10, 1)]';
      out = table (date, approval);
    endfunction

  endmethods

endclassdef