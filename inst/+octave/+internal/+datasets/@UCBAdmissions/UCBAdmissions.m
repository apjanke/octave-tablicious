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

# This is based on the UCBAdmissions dataset from R’s datasets package

classdef UCBAdmissions < octave.internal.dataset

  methods

    function this = UCBAdmissions
      this.name = "UCBAdmissions";
      this.summary = "Student Admissions at UC Berkeley";
    endfunction

    function out = load (this)
      out.n = reshape([512, 313,
        89, 19,
        353, 207,
        17, 8,
        120, 205,
        202, 391,
        138, 279,
        131, 244,
        53, 138,
        94, 299,
        22, 351,
        24, 317], [2 2 6]);
      out.dim_names = {"Admit", "Gender", "Dept"};
      out.dim_labels = {
        {"Admitted", "Rejected"}
        {"Male", "Female"}
        {"A" "B" "C" "D" "E" "F"}
      };
    endfunction

  endmethods

endclassdef