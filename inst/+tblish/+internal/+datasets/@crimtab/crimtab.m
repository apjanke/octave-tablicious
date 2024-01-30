## Copyright (C) 1995-2019 R Core Team
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

# This is based on the crimtab dataset from R’s datasets package

classdef crimtab < tblish.internal.dataset

  methods

    function this = crimtab
      this.name = "crimtab";
      this.summary = "Student’s 3000 Criminals Data";
    endfunction

    function out = load (this)
      csv_file = fullfile (fileparts (mfilename ("fullpath")), "crimtab.csv");
      x = csvread (csv_file);
      out = struct;
      out.finger_length = x(2:end,1);
      out.body_height = x(1,2:end);
      out.counts = x(2:end,2:end);
    endfunction

  endmethods

endclassdef