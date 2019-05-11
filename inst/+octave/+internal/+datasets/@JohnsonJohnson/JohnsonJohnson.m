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

# This is based on the JohnsonJohnson dataset from R’s datasets package

classdef JohnsonJohnson < octave.internal.dataset

  methods

    function this = JohnsonJohnson
      this.name = "JohnsonJohnson";
      this.summary = "Quarterly Earnings per Johnson & Johnson Share";
    endfunction

    function out = load (this)
      date = [datetime(1960, 1, 1):calmonths(3):datetime(1980, 10, 1)]';
      earnings = [.71, .63, .85, .44, .61, .69, .92, .55, .72, .77, ...
        .92, .6, .83, .8, 1, .77, .92, 1, 1.24, 1, 1.16, 1.3, 1.45, 1.25, ...
        1.26, 1.38, 1.86, 1.56, 1.53, 1.59, 1.83, 1.86, 1.53, 2.07, 2.34, ...
        2.25, 2.16, 2.43, 2.7, 2.25, 2.79, 3.42, 3.69, 3.6, 3.6, 4.32, 4.32, ...
        4.05, 4.86, 5.04, 5.04, 4.41, 5.58, 5.85, 6.57, 5.31, 6.03, 6.39, ...
        6.93, 5.85, 6.93, 7.74, 7.83, 6.12, 7.74, 8.91, 8.28, 6.84, 9.54, ...
        10.26, 9.54, 8.73, 11.88, 12.06, 12.15, 8.91, 14.04, 12.96, 14.85, ...
        9.99, 16.2, 14.67, 16.02, 11.61]';
      out = table (date, earnings);
    endfunction

  endmethods

endclassdef