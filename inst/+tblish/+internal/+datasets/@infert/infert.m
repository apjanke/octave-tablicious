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

# This is based on the infert dataset from R’s datasets package

classdef infert < tblish.internal.dataset

  methods

    function this = infert
      this.name = "infert";
      this.summary = "Infertility after Spontaneous and Induced Abortion";
    endfunction

    function out = load (this)
      education = categorical ([1, 1, 1, 1, 2, ...
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, ...
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, ...
        3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, ...
        3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 2, 2, ...
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, ...
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, ...
        3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, ...
        3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 2, ...
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, ...
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, ...
        3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, ...
        3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]', 1:3, ...
        {"0-5yrs", "6-11yrs", "12+ yrs"}, "Ordinal", true);
      age = [26, 42, 39, 34, 35, 36, 23, 32, ...
        21, 28, 29, 37, 31, 29, 31, 27, 30, 26, 25, 44, 40, 35, 28, 36, ...
        27, 40, 38, 34, 28, 30, 32, 34, 42, 32, 39, 35, 36, 34, 30, 28, ...
        39, 35, 41, 37, 30, 37, 28, 27, 26, 38, 24, 36, 27, 28, 29, 36, ...
        28, 28, 28, 27, 35, 25, 34, 31, 26, 32, 21, 28, 37, 25, 32, 25, ...
        31, 38, 26, 31, 31, 25, 31, 34, 35, 29, 23, 26, 42, 39, 34, 35, ...
        36, 23, 32, 21, 28, 29, 37, 31, 29, 31, 27, 30, 26, 25, 44, 40, ...
        35, 28, 36, 27, 40, 38, 34, 28, 30, 32, 34, 42, 32, 39, 35, 36, ...
        34, 30, 28, 39, 35, 41, 37, 30, 37, 28, 27, 26, 38, 24, 36, 27, ...
        28, 29, 36, 28, 28, 28, 27, 35, 25, 34, 31, 26, 32, 21, 28, 37, ...
        25, 32, 25, 31, 26, 31, 31, 25, 31, 34, 35, 29, 23, 26, 42, 39, ...
        34, 35, 36, 23, 32, 21, 28, 29, 37, 31, 29, 31, 27, 30, 26, 25, ...
        44, 40, 35, 28, 36, 27, 40, 38, 34, 28, 30, 32, 34, 42, 32, 39, ...
        35, 36, 34, 30, 28, 39, 35, 41, 37, 30, 37, 28, 27, 26, 38, 24, ...
        36, 27, 28, 29, 36, 28, 28, 28, 27, 35, 25, 34, 31, 26, 32, 21, ...
        28, 37, 25, 32, 25, 31, 38, 26, 31, 31, 25, 31, 34, 35, 29, 23]';
      parity = [6, 1, 6, 4, 3, 4, 1, 2, 1, 2, 2, 4, 1, 3, 2, 2, ...
        5, 1, 3, 1, 1, 2, 2, 1, 2, 2, 2, 3, 4, 4, 1, 2, 1, 2, 1, 2, 1, ...
        3, 3, 1, 3, 1, 1, 2, 1, 1, 2, 4, 2, 3, 3, 5, 3, 1, 2, 2, 2, 2, ...
        1, 2, 2, 1, 1, 2, 2, 1, 1, 3, 3, 1, 1, 1, 1, 6, 2, 1, 2, 1, 1, ...
        1, 2, 1, 1, 6, 1, 6, 4, 3, 4, 1, 2, 1, 2, 2, 4, 1, 3, 2, 2, 5, ...
        1, 3, 1, 1, 2, 2, 1, 2, 2, 2, 3, 4, 4, 1, 2, 1, 2, 1, 2, 1, 3, ...
        3, 1, 3, 1, 1, 2, 1, 1, 2, 4, 2, 3, 3, 5, 3, 1, 2, 2, 2, 2, 1, ...
        2, 2, 1, 1, 2, 2, 1, 1, 3, 3, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1, 2, ...
        1, 1, 6, 1, 6, 4, 3, 4, 1, 2, 1, 2, 2, 4, 1, 3, 2, 2, 5, 1, 3, ...
        1, 1, 2, 2, 1, 2, 2, 2, 3, 4, 4, 1, 2, 1, 2, 1, 2, 1, 3, 3, 1, ...
        3, 1, 1, 2, 1, 1, 2, 4, 2, 3, 3, 5, 3, 1, 2, 2, 2, 2, 1, 2, 2, ...
        1, 1, 2, 2, 1, 1, 3, 3, 1, 1, 1, 1, 6, 2, 1, 2, 1, 1, 1, 2, 1, 1]';
      induced = categorical ([1, 1, 2, 2, 1, 2, 0, 0, 0, 0, 1, 2, 1, 2, 1, ...
        2, 2, 0, 2, 0, 0, 2, 0, 0, 1, 0, 0, 0, 1, 2, 0, 1, 1, 0, 1, 0, ...
        0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 2, 2, 0, 1, 1, 1, 0, 0, 0, 1, ...
        0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, ...
        0, 0, 2, 0, 0, 2, 0, 2, 0, 2, 1, 0, 2, 0, 0, 0, 1, 0, 0, 1, 1, ...
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, ...
        2, 0, 1, 1, 0, 0, 0, 1, 0, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, ...
        1, 1, 2, 1, 0, 0, 0, 0, 0, 2, 1, 0, 1, 0, 0, 0, 0, 2, 0, 0, 0, ...
        0, 0, 0, 2, 0, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1, ...
        1, 1, 0, 0, 2, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 2, 0, 0, 0, 2, 0, ...
        0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 1, 2, 2, 2, 0, 1, 0, 2, 1, 0, 1, ...
        1, 1, 0, 1, 0, 1, 0, 2, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 2, 0, 0]', ...
        0:2, {"0", "1", "2 or more"});
      case_status = [repmat(1, [1 83]) repmat(0, [1 165])]';
      spontaneous = categorical ([2, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0, ...
        0, 1, 0, 1, 1, 1, 1, 1, 0, 2, 1, 1, 2, 2, 2, 2, 0, 1, 0, 0, 2, ...
        0, 2, 1, 2, 0, 1, 2, 0, 0, 1, 0, 0, 2, 0, 0, 2, 2, 2, 1, 1, 2, ...
        2, 0, 2, 1, 2, 2, 1, 1, 2, 0, 1, 1, 2, 2, 0, 0, 1, 1, 2, 2, 1, ...
        1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, ...
        0, 0, 2, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 2, 1, 0, 0, 0, 0, 0, ...
        0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, ...
        1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 2, 0, 0, 0, ...
        0, 0, 0, 1, 1, 0, 0, 0, 2, 0, 2, 0, 1, 0, 1, 1, 1, 0, 2, 0, 0, ...
        2, 0, 1, 0, 0, 0, 0, 1, 2, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, ...
        0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, ...
        0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 2, 1, 0, 1, 1, 1, ...
        0, 0, 1, 1]', 0:2, {"0", "1", "2 or more"});
      stratum = [1:83, 1:73, 75:83, 1:83]'; # one '74' missing
      pooled_stratum = [3, 1, 4, 2, 32, 36, 6, 22, 5, 19, 20, 37, 9, 29, 21, 18, ...
        38, 7, 28, 17, 14, 24, 19, 12, 18, 27, 26, 31, 34, 35, 10, 23, 16, 22, ...
        13, 24, 12, 31, 30, 8, 33, 11, 15, 25, 44, 48, 51, 61, 49, 60, 56, 62, ...
        57, 42, 52, 55, 51, 51, 42, 50, 54, 41, 47, 53, 49, 46, 39, 58, ...
        59, 41, 46, 41, 45, 63, 49, 45, 53, 41, 45, 47, 54, 43, 40, 3, ...
        1, 4, 2, 32, 36, 6, 22, 5, 19, 20, 37, 9, 29, 21, 18, 38, 7, ...
        28, 17, 14, 24, 19, 12, 18, 27, 26, 31, 34, 35, 10, 23, 16, 22, ...
        13, 24, 12, 31, 30, 8, 33, 11, 15, 25, 44, 48, 51, 61, 49, 60, ...
        56, 62, 57, 42, 52, 55, 51, 51, 42, 50, 54, 41, 47, 53, 49, 46, ...
        39, 58, 59, 41, 46, 41, 45, 49, 45, 53, 41, 45, 47, 54, 43, 40, ...
        3, 1, 4, 2, 32, 36, 6, 22, 5, 19, 20, 37, 9, 29, 21, 18, 38, ...
        7, 28, 17, 14, 24, 19, 12, 18, 27, 26, 31, 34, 35, 10, 23, 16, ...
        22, 13, 24, 12, 31, 30, 8, 33, 11, 15, 25, 44, 48, 51, 61, 49, ...
        60, 56, 62, 57, 42, 52, 55, 51, 51, 42, 50, 54, 41, 47, 53, 49, ...
        46, 39, 58, 59, 41, 46, 41, 45, 63, 49, 45, 53, 41, 45, 47, 54, 43, 40]';
      out = table (education, age, parity, induced, case_status, spontaneous, ...
        stratum, pooled_stratum);
    endfunction

  endmethods

endclassdef