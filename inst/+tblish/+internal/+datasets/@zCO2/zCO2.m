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

# This is based on the zCO2 dataset from R’s datasets package

classdef zCO2 < tblish.internal.dataset

  methods

    function this = zCO2
      this.name = "zCO2";
      this.summary = "Carbon Dioxide Uptake in Grass Plants";
    endfunction

    function out = load (this)
      # TODO: Port the CO2.rda binary file to Octave
      error ("This function is not yet implemented. Sorry.");
    endfunction

  endmethods

endclassdef
