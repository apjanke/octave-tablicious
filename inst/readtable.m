## Copyright (C) 2020 Andrew Janke
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

## -*- texinfo -*-
## @deftypefn {Function} {@var{out} =} readtable (@var{filename})
## @deftypefnx {Function} {@var{out} =} readtable (@var{filename}, @var{opts})
## @deftypefnx {Function} {@var{out} =} readtable (@dots{}, @var{Name}, @var{Value})
##
## Read a table from a file.

function out = readtable (filename, varargin)

[parent_dir,base_name,extn] = fileparts (filename)

switch lower(extn)
  case {'.xls' '.xlsx' '.xlsm' '.xlst'}
    out = octave.table.internal.readtable_excel(filename, varargin{:});
  otherwise
    error('Cannot read file %s: don''t know how to handle files of type ''%s''', extn);
  end
end
