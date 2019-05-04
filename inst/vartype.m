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


## -*- texinfo -*-
## @deftypefn {Function} {@var{out} =} vartype (@var{type})
##
## Filter by variable type for use in suscripting.
##
## Creates an object that can be used for subscripting into the variables
## dimension of a table and filtering on variable type.
##
## @var{type} is the name of a type as charvec. This may be anything that
## the @code{isa} function accepts, or @code{'cellstr'} to select cellstrs,
## as determined by @code{iscellstr}.
##
## Returns an object of an opaque type. Don’t worry about what type it is;
## just pass it into the second argument of a subscript into a @code{table}
## object.
##
## @end deftypefn
function out = vartype (type)
  mustBeCharvec (type);
  out = octave.table.internal.vartype_filter (type);
endfunction
