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
## @deftypefn {Function} {@var{out} =} isfile (@var{file})
##
## Test whether file exists and is not a folder.
##
## Tests whether the given file path @var{file} exists on the filesystem, and
## is not a folder (aka “directory”). Files of any type except for directories
## are considered files by this function.
##
## TODO: Handling of symlinks is undetermined as of yet.
##
## @var{file} is a charvec containing the path to the file to test. It may be
## an absolute or relative path.
##
## This is a new, more specific replacement for @code{exist(file, "file")}. Unlike
## @code{exist}, @code{isfile} will not search the Octave load path for files.
##
## The underlying logic defers to @code{stat(file)} for determining file existence
## and attributes, so any paths supported by @code{stat} are also supported by
## @code{isfile}. In particular, it seems that the @code{~} alias for the home
## directory is supported, at least on Unix platforms.
##
## See also: @ref{isfolder}, @code{exist}
##
## @end deftypefn

function out = isfile (file)
  st = stat (file);
  if isempty (st)
    out = false;
    return
  endif
  out = st.modestr(1) != 'd';
endfunction
