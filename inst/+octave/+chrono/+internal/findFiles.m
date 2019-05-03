## Copyright (C) 2019 Andrew Janke <floss@apjanke.net>
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

function out = findFiles (dirPath)
  %FINDFILES Recursively find files under a directory
  out = findFilesStep (dirPath, '');
endfunction

function out = findFilesStep (dirPath, pathPrefix)
  found = {};
  d = mydir (dirPath);
  for i = 1:numel (d)
    f = d(i);
    if f.isdir
      % Can't use spaces here or syntax error happens
      found = [found findFilesStep(fullfile (dirPath, f.name), ...
        fullfile(pathPrefix, f.name))];
    else
      found{end+1} = fullfile (pathPrefix, f.name);
    endif
  endfor
  out = found;
endfunction

function out = mydir (folder)
  d = dir (folder);
  names = {d.name};
  out = d;
  out(ismember (names, {'.','..'})) = [];
endfunction