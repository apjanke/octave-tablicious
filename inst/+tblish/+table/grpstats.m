## Copyright (C) 2019, 2023, 2024 Andrew Janke
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

## -*- texinfo -*-
## @deftypefn {Function} {[@var{out}] =} tblish.table.grpstats (@var{tbl}, @var{groupvar})
## @deftypefnx {Function} {[@var{out}] =} tblish.table.grpstats (@dots{}, @code{'DataVars'}, @var{DataVars})
##
## Statistics by group for a table array.
##
## This is a table-specific implementation of @code{grpstats} that works on table arrays.
## It is supplied as a function in the @var{+tblish} package to avoid colliding with
## the global @code{grpstats} function supplied by the Statistics Octave Forge package.
## Depending on which version of the Statistics OF package you are using, it may or may
## not support table inputs to its @code{grpstats} function. This function is supplied
## as an alternative you can use in an environment where @code{table} arrays are not
## supported by the @code{grpstats} that you have, though you need to make code changes
## and call it as @code{tblish.table.grpstats(tbl)} instead of with a plain
## @code{grpstats(tbl)}.
##
## @seealso{table.groupby, table.findgroups, table.splitapply}
##
## @end deftypefn
function out = grpstats (tbl, groupvar, varargin)
  [opts, args] = tblish.internal.peelOffNameValueOptions (varargin, {'DataVars'});
  if (numel (args) > 1)
    error ('table.table.grpstats: too many inputs');
  elseif (numel (args) == 1)
    whichstats = args{1};
  else
    whichstats = {'mean'};
  endif
  if (! iscell (whichstats))
    error ('whichstats must be a cell array');
  endif
  [ix_groupvar, groupvar_names] = resolveVarRef (tbl, groupvar);
  if (isfield (opts, 'DataVars'))
    data_vars = opts.DataVars;
    [ix_data_vars, data_vars] = resolveVarRef (tbl, data_vars);
  else
    data_vars = setdiff (tbl.Properties.VariableNames, groupvar_names);
  endif
  aggs = cell(0, 3);

  # TODO: Implement sem, gname, meanci, predci
  stat_map = {
    'mean'    @mean
    'numel'   @numel
    'std'     @std
    'var'     @var
    'min'     @min
    'max'     @max
    'range'   @range
    };

  for i_var = 1:numel (data_vars)
    for i_stat = 1:numel (whichstats)
      if (ischar (whichstats{i_stat}))
        stat_fcn_name = whichstats{i_stat};
        [tf,loc] = ismember (stat_fcn_name, stat_map(:,1));
        if (! tf)
          error ('tblish.table.grpstats: unsupported stat name: %s', stat_fcn_name);
        endif
        stat_fcn = stat_map{loc,2};
      elseif (isa (whichstats{i_stat}, fcn_handle))
        stat_fcn = whichstats{i_stat};
        stat_fcn_name = func2str (stat_fcn);
      endif
      out_var = sprintf('%s_%s', stat_fcn_name, data_vars{i_var});
      aggs = [aggs; { out_var, stat_fcn, data_vars{i_var} }];
    endfor
  endfor

  out = groupby (tbl, groupvar, aggs);
endfunction

function [ixVar, varNames] = resolveVarRef (tbl, varRef, strictness)
  if (nargin < 3 || isempty (strictness)); strictness = 'strict'; endif
  [ixVar, varNames] = tblish.internal.table.resolveVarRef (tbl, varRef, strictness);
endfunction
