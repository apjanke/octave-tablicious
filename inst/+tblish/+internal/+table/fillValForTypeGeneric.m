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

## -*- texinfo -*-
## @deftypefn {Function} {@var{out} =} fillValForTypeGeneric (@var{typeName})
##
## Fill value for a given type within a table, detected generically via
## array expansion.
##
## This is defined as a separate function so the other @var{fillValForType*}
## functions in this package can share it. It should probably not be called
## directly by other code.
##
## Returns a scalar value.
function out = fillValForTypeGeneric (typeName)

try
  protoVal = feval (typeName);
catch err
  error (["could not detect table fill value for type '%s': error when calling " ...
    "zero-arg constructor: %s"], typeName, err.message)
end
if (! isscalar (protoVal))
  error (["could not detect table fill value for type '%s': zero-arg constructor " ...
    "returned a non-scalar value: size was %s"], typeName, size2str (size (protoVal)))
endif

out = tblish.internal.table.fillValForVal (protoVal);

endfunction
