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

function [opts, remaining_args] = peel_off_name_value_options (args, known_opts, defaults)
  %PEEL_OFF_NAME_VALUE_OPTIONS Peel off name-value options from argins
  %
  % [opts, remaining_args] = peel_off_name_value_options (args, known_opts, defaults)
  %
  % Peels off recognized name-value options from the end of an argument array.
  %
  % args (cell) is the arguments array to parse. Typically, you should pass in your
  % varargin here.
  %
  % known_opts (cellstr) is the list of valid option names.
  %
  % defaults is the default values to use for options that were not found in the input
  % args. May be supplied as a struct, name/value cell vector, or n-by-2 cellrec (with
  % option names in the first column and corresponding default option values in the 
  % second column).
  %
  % Returns:
  %   opts – the parsed options, as a struct
  %   remaining_args – what is left of args after removing the recognized option
  %      name/value pairs.
  %
  % Examples:
  %
  % function foo (x, y, varargin)
  %   [opts, args] = octave.examples.peel_off_name_value_options (varargin, ...
  %     {"Foo", "Bar", "FooBar"});
  %   if ! isempty (args)
  %     error ("Unrecognized arguments");
  %   endif
  %   foobar = [];
  %   if isfield (opts, "FooBar")
  %      foobar = opts.FooBar;
  %   endif
  %   
  %   % ... do actual work with inputs here ...
  % endfunction
  %
  % function foo2 (x, y, varargin)
  %   [opts, args] = octave.examples.peel_off_name_value_options (varargin, ...
  %     {"FooBar", "QuxQux"}, {...
  %       "FooBar"  42
  %       "QuxQux"  "some default string value"
  %     });
  %   z = x + y + opts.FooBar;  % no need to check for isfield(); it will always
  %                             % be there since you supplied a default for it
  % endfunction

  % 

  if nargin < 3 || isempty (defaults); defaults = struct; endif
  defaults = parse_defaults (defaults);
  opts = defaults;
  peeled_args = {};
  while numel (args) >= 2 && ischar (args{end-1}) && ismember (args{end-1}, known_opts)
    peeled_args = [peeled_args args(end-1:end)];
    opts.(args{end-1}) = args{end};
    args(end-1:end) = [];
  end
  remaining_args = args;
endfunction

function out = parse_defaults (defaults)
  if isstruct (defaults)
    out = struct;
    return
  endif
  if iscell (defaults)
    if size (defaults, 2) == 2
      % Convert cellrec to name/value list
      defaults = defaults';
      defaults = defaults(:)';
    endif
    out = struct;
    for i = 1:2:numel(defaults)
      out.(defaults{i}) = defaults{i+1};
    endfor
  else
    error ("peel_off_name_value_options: invalid format for defaults");
  endif
endfunction