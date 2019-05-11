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

# This is based on the Formaldehyde dataset from R’s datasets package

classdef Formaldehyde < octave.internal.dataset

  methods

    function this = Formaldehyde
      this.name = "Formaldehyde";
      this.summary = "Determination of Formaldehyde";
    endfunction

    function out = load (this)
      carb  = [0.1, 0.3, 0.5, 0.6, 0.7, 0.9]';
      optden = [0.086, 0.269, 0.446, 0.538, 0.626, 0.782]';
      record = [1:numel(carb)]';
      out = table (record, carb, optden);
    endfunction

  endmethods

endclassdef