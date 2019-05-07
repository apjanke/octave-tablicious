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

# This is based on the euro dataset from R’s datasets package

classdef euro < octave.internal.dataset

  methods

    function this = euro
      this.name = "euro";
      this.summary = "Conversion Rates of Euro Currencies";
    endfunction

    function out = load (this)
      euro_currs = {"ATS", "BEF", "DEM", "ESP", "FIM", "FRF", "IEP"< "ITL", ...
        "LUF", "NLG", "PTE"};
      euro_rates = [13.7603, 40.3399, 1.95583, 166.386, ...
    	  5.94573, 6.55957, .787564, 1936.27, 40.3399, ...
        2.20371, 200.482];

      # TODO: Figure out how to generate the [currs x currs] matrix of rates
      # with a quick cross product
      out = struct;
      out.euro_currs = euro_currs;
      out.euro_rates = euro_rates;
    endfunction

  endmethods

endclassdef