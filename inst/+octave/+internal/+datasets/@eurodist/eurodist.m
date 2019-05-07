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

# This is based on the eurodist dataset from R’s datasets package

classdef eurodist < octave.internal.dataset

  methods

    function this = eurodist
      this.name = "eurodist";
      this.summary = "Distances Between European Cities and Between US Cities";
    endfunction

    function out = load (this)
      eurodist = [3313, 2963, 3175, 3339, 2762, 3276, 2610, 4485, 2977, 3030, ...
        4532, 2753, 3949, 2865, 2282, 2179, 3000, 817, 3927, 1991, 1318, 1326, ...
        1294, 1498, 2218, 803, 1172, 2018, 1490, 1305, 645, 636, 521, 1014, 1365, ...
        1033, 1460, 2868, 1802, 204, 583, 206, 966, 677, 2256, 597, 172, 2084, ...
        690, 1558, 1011, 925, 747, 285, 1511, 1616, 1175, 460, 409, 1136, 747, ...
        2224, 714, 330, 2052, 739, 1550, 1059, 1077, 977, 280, 1662, 1786, 1381, ...
        785, 1545, 853, 2047, 1115, 731, 1827, 789, 1347, 1101, 1209, 1160, 340, ...
        1794, 2196, 1588, 760, 1662, 2436, 460, 269, 2290, 714, 1764, 1035, 911, ...
        583, 465, 1497, 1403, 937, 1418, 3196, 460, 269, 2971, 1458, 2498, 1778, ...
        1537, 1104, 1176, 2050, 650, 1455, 1975, 1118, 895, 1936, 158, 1439, 425, ...
        328, 591, 513, 995, 2068, 1019, 2897, 2428, 676, 1817, 698, 1693, 2185, ...
        2565, 1971, 2631, 3886, 2974, 550, 2671, 1159, 2198, 1479, 1238, 805, 877, ...
        1751, 949, 1155, 2280, 863, 1730, 1183, 1098, 851, 457, 1683, 1500, 1205, ...
        1178, 668, 1762, 2250, 2507, 1799, 2700, 3231, 2937, 1281, 320, 328, 724, ...
        471, 1048, 2108, 1157, 1157, 1724, 2010, 1273, 2097, 3188, 2409, 618, 1109, ...
        792, 1011, 2428, 1363, 331, 856, 586, 2187, 898, 821, 946, 1754, 428, 1476, ...
        1827, 1249, 2707, 1209, 2105]';
      
      # TODO: Figure out the right way to load the UScitiesD data set in here
      out = struct;
      out.eurodist = eurodist;
    endfunction

  endmethods

endclassdef