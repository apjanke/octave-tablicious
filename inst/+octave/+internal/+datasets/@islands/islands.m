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

# This is based on the islands dataset from R’s datasets package

classdef islands < octave.internal.dataset

  methods

    function this = islands
      this.name = "islands";
      this.summary = "Areas of the World's Major Landmasses";
    endfunction

    function out = load (this)
      name = string ({"Africa", "Antarctica", "Asia", "Australia", "Axel Heiberg", ...
        "Baffin", "Banks", "Borneo", "Britain", "Celebes", "Celon", "Cuba", "Devon",  ...
        "Ellesmere", "Europe", "Greenland", "Hainan", "Hispaniola", "Hokkaido",  ...
        "Honshu", "Iceland", "Ireland", "Java", "Kyushu", "Luzon", "Madagascar",  ...
        "Melville", "Mindanao", "Moluccas", "New Britain", "New Guinea", ...
        "New Zealand (N)", "New Zealand (S)", "Newfoundland", "North America", ...
        "Novaya Zemlya", "Prince of Wales", "Sakhalin", "South America", ...
        "Southampton", "Spitsbergen", "Sumatra", "Taiwan", "Tasmania", ...
        "Tierra del Fuego", "Timor", "Vancouver", "Victoria"})';
      area = [11506, 5500, 16988, 2968, 16, 184, 23, 280, 84, 73, 25, 43, 21, ...
        82, 3745, 840, 13, 30, 30, 89, 40, 33, 49, 14, 42, 227, 16, 36, 29, 15, 306, ...
        44, 58, 43, 9390, 32, 13, 29, 6795, 16, 15, 183, 14, 26, 19, 13, 12, 82]';
      out = table (name, area);
    endfunction

  endmethods

endclassdef