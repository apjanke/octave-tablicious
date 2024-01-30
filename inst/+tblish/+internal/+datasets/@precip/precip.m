## Copyright (C) 1995-2007 R Core Team
## Copyright (C) 2019, 2023, 2024 Andrew Janke
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

# This is based on the precip dataset from R’s datasets package

classdef precip < tblish.internal.dataset

  methods

    function this = precip
      this.name = "precip";
      this.summary = "Annual Precipitation in US Cities";
    endfunction

    function out = load (this)
      precip = [67, 54.7, 7, 48.5, 14, 17.2, 20.7, 13, 43.4, 40.2, 38.9, 54.5, ...
        59.8, 48.3, 22.9, 11.5, 34.4, 35.1, 38.7, 30.8, 30.6, 43.1, 56.8, 40.8, ...
        41.8, 42.5, 31, 31.7, 30.2, 25.9, 49.2, 37, 35.9, 15, 30.2, 7.2, 36.2, ...
        45.5, 7.8, 33.4, 36.1, 40.2, 42.7, 42.5, 16.2, 39, 35, 37, 31.4, 37.6, ...
        39.9, 36.2, 42.8, 46.4, 24.7, 49.1, 46, 35.9, 7.8, 48.2, 15.2, 32.5, 44.7, ...
        42.6, 38.8, 17.4, 40.8, 29.1, 14.6, 59.2]';
      city = string ({"Mobile", "Juneau", ...
        "Phoenix", "Little Rock", "Los Angeles", "Sacramento", "San Francisco", ...
        "Denver", "Hartford", "Wilmington", "Washington", "Jacksonville", "Miami", ...
        "Atlanta", "Honolulu", "Boise", "Chicago", "Peoria", "Indianapolis", ...
        "Des Moines", "Wichita", "Louisville", "New Orleans", "Portland", ...
        "Baltimore", "Boston", "Detroit", "Sault Ste. Marie", "Duluth", ...
        "Minneapolis/St Paul", "Jackson", "Kansas City", "St Louis", "Great Falls", ...
        "Omaha", "Reno", "Concord", "Atlantic City", "Albuquerque", "Albany", ...
        "Buffalo", "New York", "Charlotte", "Raleigh", "Bismark", "Cincinnati", ...
        "Cleveland", "Columbus", "Oklahoma City", "Portland", "Philadelphia", ...
        "Pittsburg", "Providence", "Columbia", "Sioux Falls", "Memphis", ...
        "Nashville", "Dallas", "El Paso", "Houston", "Salt Lake City", "Burlington", ...
        "Norfolk", "Richmond", "Seattle Tacoma", "Spokane", "Charleston", "Milwaukee", ...
        "Cheyenne", "San Juan"}');
      out = table (city, precip);
    endfunction

  endmethods

endclassdef