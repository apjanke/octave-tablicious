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

# This is based on the Puromycin dataset from R’s datasets package

classdef Puromycin < octave.internal.dataset

  methods

    function this = Puromycin
      this.name = "Puromycin";
      this.summary = "Reaction Velocity of an Enzymatic Reaction";
    endfunction

    function out = load (this)
      conc = [0.02, 0.02, 0.06, 0.06, 0.11, 0.11, 0.22, 0.22, 0.56, ...
        0.56, 1.1, 1.1, 0.02, 0.02, 0.06, 0.06, 0.11, 0.11, 0.22, 0.22, ...
        0.56, 0.56, 1.1]';
      rate = [76, 47, 97, 107, 123, 139, 159, 152, 191, 201, 207, 200, ...
        67, 51, 84, 86, 98, 115, 131, 124, 144, 158, 160]';
      state = categorical ([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, ...
        2, 2, 2, 2, 2, 2, 2, 2]', 1:2, {"treated", "untreated"});
      out = table (state, conc, rate);
    endfunction

  endmethods

endclassdef