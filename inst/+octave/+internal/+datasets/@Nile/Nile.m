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

# This is based on the Nile dataset from R’s datasets package

classdef Nile < octave.internal.dataset

  methods

    function this = Nile
      this.name = "Nile";
      this.summary = "Flow of the River Nile";
    endfunction

    function out = load (this)
      year = [1871:1970]';
      flow = [1120, 1160, 963, 1210, 1160, 1160, 813, 1230, 1370, 1140, ...
        995, 935, 1110, 994, 1020, 960, 1180, 799, 958, 1140, 1100, 1210, ...
        1150, 1250, 1260, 1220, 1030, 1100, 774, 840, 874, 694, 940, 833, 701, ...
        916, 692, 1020, 1050, 969, 831, 726, 456, 824, 702, 1120, 1100, 832, ...
        764, 821, 768, 845, 864, 862, 698, 845, 744, 796, 1040, 759, 781, 865, ...
        845, 944, 984, 897, 822, 1010, 771, 676, 649, 846, 812, 742, 801, ...
        1040, 860, 874, 848, 890, 744, 749, 838, 1050, 918, 986, 797, 923, ...
        975, 815, 1020, 906, 901, 1170, 912, 746, 919, 718, 714, 740]' .* 10^8;
      out = table (year, flow);
    endfunction

  endmethods

endclassdef