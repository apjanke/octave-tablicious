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

# This is based on the morley dataset from R’s datasets package

classdef morley < octave.internal.dataset

  methods

    function this = morley
      this.name = "morley";
      this.summary = "Michelson Speed of Light Data";
    endfunction

    function out = load (this)
      tab_file = fullfile (fileparts (mfilename ("fullpath")), "morley.tab");
      data = dlmread(tab_file);
      data(1,:) = []; % drop header line
      Expt = data(:,2);
      Run = data(:,3);
      Speed = data(:,4);
      out = table (Expt, Run, Speed);
    endfunction

  endmethods

endclassdef