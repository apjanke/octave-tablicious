## Copyright (C) 2019, 2023, 2024, 2025, 2026 Andrew Janke
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; If not, see <http://www.gnu.org/licenses/>.

function out = demote_strings (args)
  #DEMOTE_STRINGS Turn all string arguments into chars
  #
  # out = demote_strings (args)
  #
  # This is for compatibility with functions that take chars or cellstrs,
  # but are not aware of string arrays.
  #
  # Takes a single cell array of "arguments" instead of varargin/varargout,
  # because most callers will be dealing with variadic arguments to their own
  # signature with cell arrays.
  #
  # Scalar strings are turned into char row vectors. Nonscalar strings are
  # turned in to cellstrs. This might not actually be the right thing,
  # depending on what function you are calling!
  out = args;
  for i = 1:numel (args)
    if (isa (args{i}, 'string'))
      if (isscalar (args{i}))
        out{i} = char (args{i});
      else
        out{i} = cellstr (args{i});
      endif
    endif
  endfor
endfunction
