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

# This is based on the treering dataset from R’s datasets package

classdef treering < octave.internal.dataset

  methods

    function this = treering
      this.name = "treering";
      this.summary = "Yearly Treering Data, -6000-1979";
    endfunction

    function out = load (this)
      # I'm putting off porting this because it will require extensive reformatting
      # from the R source
      error ("This function is not yet implemented. Sorry.");
    endfunction

  endmethods

endclassdef