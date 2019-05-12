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

# This is based on the sleep dataset from R’s datasets package

classdef sleep < octave.internal.dataset

  methods

    function this = sleep
      this.name = "sleep";
      this.summary = "Student’s Sleep Data";
    endfunction

    function out = load (this)
      extra = [0.7, -1.6, -0.2, -1.2, -0.1, 3.4, 3.7,
        0.8, 0, 2, 1.9, 0.8, 1.1, 0.1, -0.1, 4.4, 5.5, 1.6, 4.6, 3.4]';
      group = repelem ([1 2], [1 10])';
      id = repmat(1:10, [1 2])';
      out = table (id, group, extra);
    endfunction

  endmethods

endclassdef