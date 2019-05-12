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

# This is based on the stackloss dataset from R’s datasets package

classdef stackloss < octave.internal.dataset

  methods

    function this = stackloss
      this.name = "stackloss";
      this.summary = "Brownlee's Stack Loss Plant Data";
    endfunction

    function out = load (this)
      AirFlow = [80,80,75,62,62,62,62,62,58,58,58,58,58,58,50,50,50,50,50,56,70]';
      WaterTemp = [27,27,25,24,22,23,24,24,23,18,18,17,18,19,18,18,19,19,20,20,20]';
      AcidConc = [89,88,90,87,87,87,93,93,87,80,89,88,82,93,89,86,72,79,80,82,91]';
      StackLoss = [42,37,37,28,18,18,19,20,15,14,14,13,11,12, 8, 7, 8, 8, 9,15,15]';
      out = table (AirFlow, WaterTemp, AcidConc, StackLoss);
    endfunction

  endmethods

endclassdef