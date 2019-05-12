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

# This is based on the UKgas dataset from R’s datasets package

classdef UKgas < octave.internal.dataset

  methods

    function this = UKgas
      this.name = "UKgas";
      this.summary = "UK Quarterly Gas Consumption";
    endfunction

    function out = load (this)
      date = [datetime(1960, 1, 1):calmonths(3):datetime(1986, 10, 1)]';
      gas = [160.1, 129.7, 84.8, 120.1, 160.1, 124.9, 84.8, 116.9, ...
        169.7, 140.9, 89.7, 123.3, 187.3, 144.1, 92.9, 120.1, 176.1, 147.3, ...
        89.7, 123.3, 185.7, 155.3, 99.3, 131.3, 200.1, 161.7, 102.5, 136.1, ...
        204.9, 176.1, 112.1, 140.9, 227.3, 195.3, 115.3, 142.5, 244.9, 214.5, ...
        118.5, 153.7, 244.9, 216.1, 188.9, 142.5, 301.0, 196.9, 136.1, 267.3, ...
        317.0, 230.5, 152.1, 336.2, 371.4, 240.1, 158.5, 355.4, 449.9, 286.6, ...
        179.3, 403.4, 491.5, 321.8, 177.7, 409.8, 593.9, 329.8, 176.1, 483.5, ...
        584.3, 395.4, 187.3, 485.1, 669.2, 421.0, 216.1, 509.1, 827.7, 467.5, ...
        209.7, 542.7, 840.5, 414.6, 217.7, 670.8, 848.5, 437.0, 209.7, 701.2, ...
        925.3, 443.4, 214.5, 683.6, 917.3, 515.5, 224.1, 694.8, 989.4, 477.1, ...
        233.7, 730.0, 1087.0, 534.7, 281.8, 787.6, 1163.9, 613.1, 347.4, ...
        782.8]';
      out = table (date, gas);
    endfunction

  endmethods

endclassdef