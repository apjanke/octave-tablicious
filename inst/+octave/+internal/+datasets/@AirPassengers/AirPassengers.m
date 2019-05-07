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

# This is based on the AirPassengers dataset from R’s datasets package

classdef AirPassengers < octave.internal.dataset
  % Monthly Airline Passenger Numbers 1949-1960

  methods

    function this = AirPassengers ()
      this.name = "AirPassengers";
      this.summary = "Monthly Airline Passenger Numbers 1949-1960";
    endfunction

    function out = load (this)
      passengers = [112, 118, 132, 129, 121, 135, 148, 148, 136, 119, ...
        104, 118, 115, 126, 141, 135, 125, 149, 170, 170, 158, 133, 114, ...
        140, 145, 150, 178, 163, 172, 178, 199, 199, 184, 162, 146, 166, ...
        171, 180, 193, 181, 183, 218, 230, 242, 209, 191, 172, 194, 196, ...
        196, 236, 235, 229, 243, 264, 272, 237, 211, 180, 201, 204, 188, ...
        235, 227, 234, 264, 302, 293, 259, 229, 203, 229, 242, 233, 267, ...
        269, 270, 315, 364, 347, 312, 274, 237, 278, 284, 277, 317, 313, ...
        318, 374, 413, 405, 355, 306, 271, 306, 315, 301, 356, 348, 355, ...
        422, 465, 467, 404, 347, 305, 336, 340, 318, 362, 348, 363, 435, ...
        491, 505, 404, 359, 310, 337, 360, 342, 406, 396, 420, 472, 548, ...
        559, 463, 407, 362, 405, 417, 391, 419, 461, 472, 535, 622, 606, ...
        508, 461, 390, 432]';
      start_date = datetime ('1949-01-01');

      out.passengers = passengers;
      out.start_date = start_date;
    endfunction

  endmethods

endclassdef