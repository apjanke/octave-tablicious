## Copyright (C) 2019, 2023, 2024 Andrew Janke <floss@apjanke.net>
##
## This file is part of Octave.
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
## @deftypefn {Function File} octave_tablicious_make_local
##
## Build all the octfiles in Tablicious, using mkoctfile from the Octave you are
## running it from.
##
## This is for use when you are building Tablicious from the source in the repo. It
## is not needed when you are using Tablicious after it is installed. You do not need
## to call it yourself if you install Tablicious using @command{pkg}.
##
## @end deftypefn

function octave_tablicious_make_local ()
  %OCTAVE_TABLICIOUS_MAKE_LOCAL Build the octfiles for this repo
  %
  % Call this function if you are working with a local copy of this repo instead
  % of installing it as a package.
  d = dir;
  if (! ismember('octave_tablicious_make_local.m', {d.name}))
    [my_dir,me] = fileparts (mfilename ('fullpath'));
    error (['You are calling this function from the wrong directory.\n' ...
      '%s needs to be run from the directory it lives in.\n' ...
      'cd to %s and try again.'], ...
      me, my_dir);
  endif
  octfcns = {
    '__tblish_time_binsearch__'
    };
  for i = 1:numel (octfcns)
    octfcn = octfcns{i};
    mkoctfile (sprintf ('src/%s.cc', octfcn));
    dot_o_file = sprintf ('%s.o', octfcn);
    if isfile (dot_o_file)
      delete (dot_o_file);
    endif
    movefile (sprintf ('%s.oct', octfcn), 'inst');
    printf (sprintf ('Built %s\n', octfcn));
  endfor
endfunction
