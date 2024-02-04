## Copyright (C) 2019, 2023, 2024 Andrew Janke <floss@apjanke.net>
##
## This file is part of Tablicious.
##
## Octave is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## Octave is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function} {@var{out} =} istabular (@var{x})
##
## True if input is eitehr a @code{table} or @code{timetable} array, or an object
## like them.
##
## Respects @code{istable} and @code{istimetable} override methods on user-defined
## classes, even if they do not inherit from @code{table} or were known to Tablicious
## at authoring time.
##
## Returns a scalar logical.
##
## @end deftypefn

# Developers' note: Other packages that wish to support tables and be compatible
# with Tablicious, but not take a mandatory dependency on Tablicious, may want
# to use istable() to test for table inputs. This function is simple, well-defined,
# and likely stable enough for other packages to just copy-paste an exact copy
# of it in to their own `inst/` directory, so there will be an istable() available
# whether or not Tablicious is installed and loaded.

function out = istabular (x)
  #ISTABULAR True for table-like and timetable-like arrays.
  out = istable (x) || istimetable (x);
endfunction
