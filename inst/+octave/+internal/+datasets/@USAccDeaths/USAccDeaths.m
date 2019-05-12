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

# This is based on the USAccDeaths dataset from R’s datasets package

classdef USAccDeaths < octave.internal.dataset

  methods

    function this = USAccDeaths
      this.name = "USAccDeaths";
      this.summary = "Accidental Deaths in the US 1973-1978";
    endfunction

    function out = load (this)
      month = [datetime(1973, 1, 1):calmonths(1):datetime(1978, 12, 1)]';
      deaths = [9007, 8106, 8928, 9137, 10017, 10826, 11317, 10744, 
        9713, 9938, 9161, 8927, 7750, 6981, 8038, 8422, 8714, 9512, 10120, 
        9823, 8743, 9129, 8710, 8680, 8162, 7306, 8124, 7870, 9387, 9556, 
        10093, 9620, 8285, 8466, 8160, 8034, 7717, 7461, 7767, 7925, 
        8623, 8945, 10078, 9179, 8037, 8488, 7874, 8647, 7792, 6957, 
        7726, 8106, 8890, 9299, 10625, 9302, 8314, 8850, 8265, 8796, 
        7836, 6892, 7791, 8192, 9115, 9434, 10484, 9827, 9110, 9070, 
        8633, 9240]';
      out = table (month, deaths);
    endfunction

  endmethods

endclassdef