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

function out = sprintfv (format, varargin)
%SPRINTFV "Vectorized" sprintf
%
% out = sprintfv (format, varargin)
%
% SPRINTFV is an array-oriented form of sprintf that applies a format to array
% inputs and produces a cellstr.
%
% This is not a high-performance method. It's a convenience wrapper around a
% loop around sprintf ().
%
% Returns cellstr.

  args = varargin;
  sz = [];
  for i = 1:numel (args)
    if ischar (args{i})
      args{i} = { args{i} };  %#ok<CCAT1>
    endif
    if ~isscalar (args{i})
      if isempty (sz)
        sz = size (args{i});
      else
        if ~isequal (sz, size (args{i}))
            error ('Inconsistent dimensions in inputs');
        endif
      endif
    endif
  endfor
  if isempty (sz)
      sz = [1 1];
  endif

  out = cell (sz);
  for i = 1:numel (out)
      theseArgs = cell (size (args));
      for iArg = 1:numel (args)
          if isscalar (args{iArg})
              ix_i = 1;
          else
              ix_i = i;
          endif
          if iscell (args{iArg})
              theseArgs{iArg} = args{iArg}{ix_i};
          else
              theseArgs{iArg} = args{iArg}(ix_i);
          endif
      endfor
      out{i} = sprintf (format, theseArgs{:});
  endfor

endfunction