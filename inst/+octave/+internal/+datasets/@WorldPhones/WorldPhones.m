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

# This is based on the WorldPhones dataset from R’s datasets package

classdef WorldPhones < octave.internal.dataset

  methods

    function this = WorldPhones
      this.name = "WorldPhones";
      this.summary = "The World’s Telephones";
    endfunction

    function out = load (this)
      out.phones = reshape ([45939, 60423, 64721, 68484, 71799, 76036, 79831, 21574, 29990, 
        32510, 35218, 37598, 40341, 43173, 2876, 4708, 5230, 6662, 6856, 8220, ...
        9053, 1815, 2568, 2695, 2845, 3000, 3145, 3338, 1646, 2366, 2526, 2691, ...
        2868, 3054, 3224, 89, 1411, 1546, 1663, 1769, 1905, 2005, 555, 733, 773, ...
        836, 911, 1008, 1076], [7 7]);
      out.dim_names = {"Year", "Region"};
      out.dim_labels = {
        {"1951", "1956", "1957", "1958", "1959", "1960", "1961"}
        {"N.Amer", "Europe", "Asia", "S.Amer", "Oceania", "Africa", "Mid.Amer"}
      };
    endfunction

  endmethods

endclassdef