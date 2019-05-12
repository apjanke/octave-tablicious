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

# This is based on the sunspot_month dataset from R’s datasets package

classdef sunspot_month < octave.internal.dataset

  methods

    function this = sunspot_month
      this.name = "sunspot_month";
      this.summary = "Monthly Sunspot Data, from 1749 to “Present”";
    endfunction

    function out = load (this)
      # I've delayed implementing this because it will require more
      # extensive formatting from the R source than the other R datasets have.
      error ("Unimplemented. Sorry.")
    endfunction

  endmethods

endclassdef