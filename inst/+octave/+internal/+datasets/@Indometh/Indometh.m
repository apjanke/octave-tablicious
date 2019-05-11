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

# This is based on the Indometh dataset from R’s datasets package

classdef Indometh < octave.internal.dataset

  methods

    function this = Indometh
      this.name = "Indometh";
      this.summary = "Pharmacokinetics of Indomethacin";
    endfunction

    function out = load (this)
      Subject = categorical ([1, 1, 1, 1, 1, 1, ...
        1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 6, 6, 6, 6, 6, ...
        6, 6, 6, 6, 6, 6, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, ...
        4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5]', 1:6, ...
        {"1", "4", "2", "5", "6", "3"}, "Ordinal", true);
      time = [0.25, 0.5, 0.75, 1, 1.25, 2, 3, 4, 5, 6, 8, 0.25, 0.5, ...
        0.75, 1, 1.25, 2, 3, 4, 5, 6, 8, 0.25, 0.5, 0.75, 1, 1.25, 2, 3,...
        4, 5, 6, 8, 0.25, 0.5, 0.75, 1, 1.25, 2, 3, 4, 5, 6, 8, 0.25, ...
        0.5, 0.75, 1, 1.25, 2, 3, 4, 5, 6, 8, 0.25, 0.5, 0.75, 1, 1.25, ...
        2, 3, 4, 5, 6, 8]';
      conc = [1.5, 0.94, 0.78, 0.48, 0.37, 0.19, 0.12, 0.11, ...
        0.08, 0.07, 0.05, 2.03, 1.63, 0.71, 0.7, 0.64, 0.36, 0.32, 0.2, ...
        0.25, 0.12, 0.08, 2.72, 1.49, 1.16, 0.8, 0.8, 0.39, 0.22, 0.12, ...
        0.11, 0.08, 0.08, 1.85, 1.39, 1.02, 0.89, 0.59, 0.4, 0.16, 0.11, ...
        0.1, 0.07, 0.07, 2.05, 1.04, 0.81, 0.39, 0.3, 0.23, 0.13, 0.11, ...
        0.08, 0.1, 0.06, 2.31, 1.44, 1.03, 0.84, 0.64, 0.42, 0.24, 0.17, ...
        0.13, 0.1, 0.09]';
      out = table (Subject, time, conc);
      carb  = [0.1, 0.3, 0.5, 0.6, 0.7, 0.9]';
      optden = [0.086, 0.269, 0.446, 0.538, 0.626, 0.782]';
      record = [1:numel(carb)]';
      out = table (record, carb, optden);
    endfunction

  endmethods

endclassdef