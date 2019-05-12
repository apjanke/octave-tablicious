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

# This is based on the WWWusage dataset from R’s datasets package

classdef WWWusage < octave.internal.dataset

  methods

    function this = WWWusage
      this.name = "WWWusage";
      this.summary = "WWWusage";
    endfunction

    function out = load (this)
      users = [88, 84, 85, 85, 84, 85, 83, 85, 88, 89, 91, 99, 104,
        112, 126, 138, 146, 151, 150, 148, 147, 149, 143, 132, 131, 139, 147,
        150, 148, 145, 140, 134, 131, 131, 129, 126, 126, 132, 137, 140, 142,
        150, 159, 167, 170, 171, 172, 172, 174, 175, 172, 172, 174, 174, 169,
        165, 156, 142, 131, 121, 112, 104, 102, 99, 99, 95, 88, 84, 84, 87,
        89, 88, 85, 86, 89, 91, 91, 94, 101, 110, 121, 135, 145, 149, 156,
        165, 171, 175, 177, 182, 193, 204, 208, 210, 215, 222, 228, 226, 222,
        220];
      out.users = users;
    endfunction

  endmethods

endclassdef