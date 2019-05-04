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

classdef cupcake < octave.internal.dataset
  % Monthly Airline Passenger Numbers 1949-1960

  methods

    function this = cupcake ()
      this.name = "cupcake";
      this.summary = 'Google Search popularity for "cupcake", 2004-2019';
    endfunction

    function out = load (this)
      my_dir = fileparts (mfilename ("fullpath"));
      csv_file = fullfile (my_dir, "cupcake.csv");
      [fid, msg] = fopen (csv_file);
      fgets (fid); % discard header line
      data = textscan (fid, "%s,%d", "Delimiter", ",");
      fclose (fid);

      month_str = data{1};
      Cupcake = data{2};

      Month = datetime (month_str, "InputFormat", "yyyy-mm");
      out = table (Month, Cupcake);
    endfunction

  endmethods

endclassdef