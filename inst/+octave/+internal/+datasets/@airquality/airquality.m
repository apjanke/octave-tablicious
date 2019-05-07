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

# This is based on the airquality dataset from R’s datasets package

classdef airquality < octave.internal.dataset

  methods

    function this = airquality ()
      this.name = "airquality";
      this.summary = "New York Air Quality Measurements from 1973";
    endfunction

    function out = load (this)
      my_dir = fileparts (mfilename ("fullpath"));
      tab_file = fullfile (my_dir, "airquality.tab");
      data = dlmread(tab_file, "\t");
      data(1,:) = []; % drop header line
      Ozone = data(:,1);
      SolarR = data(:,2);
      Wind = data(:,3);
      Temp = data(:,4);
      Month = data(:,5);
      Day = data(:,6);
      out = table(Ozone, SolarR, Wind, Temp, Month, Day);
    endfunction
  
  endmethods

endclassdef
