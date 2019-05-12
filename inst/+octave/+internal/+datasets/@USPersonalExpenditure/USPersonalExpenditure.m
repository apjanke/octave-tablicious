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

# This is based on the USPersonalExpenditure dataset from R’s datasets package

classdef USPersonalExpenditure < octave.internal.dataset

  methods

    function this = USPersonalExpenditure
      this.name = "USPersonalExpenditure";
      this.summary = "Personal Expenditure Data";
    endfunction

    function out = load (this)
      out.x = reshape ([22.2, 10.5, 3.53, 1.04, 0.341, 44.5, 15.5, 5.76, 1.98, 0.974, ...
        59.6, 29, 9.71, 2.45, 1.8, 73.2, 36.5, 14, 3.4, 2.6, 86.8, 46.2, 21.1, ...
        5.4, 3.64], [5 5]);
      out.dim_names = {"Category", "Year"};
      out.dim_labels = {
        {"Food and Tobacco", "Household Operation", ...
          "Medical and Health", "Personal Care", "Private Education"}
        {"1940", "1945", "1950", "1955", "1960"}
      };
    endfunction

  endmethods

endclassdef