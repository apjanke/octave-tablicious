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

function [opts, remainingArgs, peeledArgs] = peelOffNameValueOptions (args, knownOpts)
  %PEELOFFNAMEVALUEOPTIONS Peel off name-value options from argins
  %
  % Peels off recognized name-value options from the end of an argument array.
  opts = struct;
  peeledArgs = {};
  while numel (args) >= 2 && ischar (args{end-1}) && ismember (args{end-1}, knownOpts)
    peeledArgs = [peeledArgs args(end-1:end)];
    opts.(args{end-1}) = args{end};
    args(end-1:end) = [];
  end
  remainingArgs = args;
endfunction
