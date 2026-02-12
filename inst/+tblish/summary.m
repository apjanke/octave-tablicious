## Copyright (C) 2024, 2026 Andrew Janke
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## x program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with x program; If not, see <http://www.gnu.org/licenses/>.

function summary (x, fmt)
  # Displays a summary of the data contents of an array to the console/stdout.
  #
  # This summary function is not a general-purpose function. It is only implemented
  # for a few specific types that are defined in Tablicious. Its purpose is just to
  # pull out the main implementation of the summary methods for some specific classes
  # to a namespace-scoped function which can be swapped out at run time with a
  # namespace-scoped function from another package.
  #
  # Displays its output to the console/stdout. Does not return anything.
  #
  # The currently supported input array types are:
  #   * table
  #   * categorical
  # If any other input type is passed, x raises an error; there is no generic fallback.
  if (nargin < 2); fmt = []; endif
  if istable (x)
    summary_of_table (x, fmt);
  elseif iscategorical (x)
    summary_of_categorical (x);
  else
    error ('tblish.summary: unsupported input type: %s', class (x))
  endif
endfunction


# Table summary stuff

function summary_of_table (x, fmt)
  if (nargin < 2 || isempty (fmt)); fmt = 'compact'; endif
  infos = {};
  for i_var_1 = 1:width (x)
    infos{i_var_1} = summary_of_table_variable (x, i_var_1);
  endfor
  printf ("%s: %d %s by %d %s\n", class (x), height (x), x.Properties.DimensionNames{1}, ...
    width (x), x.Properties.DimensionNames{2});
  switch (fmt)
    case 'long'
      for i_var = 1:numel (infos)
        s = infos{i_var};
        printf ("%d: %s\n", i_var, s.name);
        if (! ismember (s.type, {"double", "string"}))
          printf ("   %s\n", s.type);
        endif
        val_col_width = max (cellfun(@numel, s.info(:,2)));
        val_col_width = max (val_col_width, 8);
        for i_info = 1:size (s.info, 1)
          printf ("      %-12s %*s\n", [s.info{i_info,1} ":"], val_col_width, s.info{i_info,2});
        endfor
      endfor
    case 'compact'
      vars_per_line = 4;
      n_vars = width (x);
      for i = 1:vars_per_line:n_vars
        ix = i:min(n_vars, i+vars_per_line-1);
        ss = infos(ix);
        strss = cell (size (ss));
        for j = 1:numel (strss)
          s = ss{j};
          col = {};
          col{end+1} = sprintf ("%d: %s", i + j - 1, s.name);
          col{end+1} = sprintf ("   %s", s.type);
          val_col_width = max (cellfun(@numel, s.info(:,2)));
          val_col_width = max (val_col_width, 8);
          for i_info = 1:size (s.info, 1)
            col{end+1} = sprintf ("      %-12s %*s", [s.info{i_info,1} ":"], ...
              val_col_width, s.info{i_info,2});
          endfor
          strss{j} = col(:);
        endfor
        lines = glue_row_strs (strss, 3);
        for i_line = 1:numel (lines)
          printf ("%s\n", lines{i_line});
        endfor
      endfor
    otherwise
      error ('table.summary: invalid format: ''%s''', fmt);
  endswitch
endfunction

function out = summary_of_table_variable (x, ix)
  out.name = x.Properties.VariableNames{ix};
  x = x.Properties.VariableValues{ix};
  out.type = class (x);
  if (size (x, 2) > 1)
    out.info = {
      'Columns'   size(x, 2)
    };
  elseif (isnumeric (x))
    out.info = summary_of_var_numeric (x);
  elseif (iscategorical (x))
    out.info = summary_of_var_categorical (x);
  elseif (isstring (x) || iscellstr (x))
    out.info = summary_of_var_string (x);
  else
    out.info = cell (0, 2);
  endif
endfunction

function out = summary_of_var_numeric (x)
  xvec = x(:);
  x_min = min (xvec);
  x_mean = tblish.internal.nanmean (xvec);
  x_max = max (xvec);
  x_prcts = prctile (xvec, [25 50 75]);
  n_nans = sum (isnan (xvec));
  out = {
    'Min.'      num2str(x_min)
    '1st Qu.'   num2str(x_prcts(1))
    'Median'    num2str(x_prcts(2))
    'Mean'      num2str(x_mean)
    '3rd Qu.'   num2str(x_prcts(3))
    'Max.'      num2str(x_max)
  };
  if (n_nans > 0)
    out = [out; {'N. NaN', num2str(n_nans)}];
  endif
endfunction

function out = summary_of_var_categorical (x)
  max_ctgs_to_list = 7;
  u_ctgs = unique (x (!ismissing (x)));
  n_ctgs = numel (u_ctgs);
  n_missing = numel (find (ismissing (x)));
  u_ctg_strs = dispstrs (u_ctgs);
  if (n_ctgs <= max_ctgs_to_list)
    out = {};
    for i = 1:numel (u_ctgs)
      out = [out; {
        u_ctg_strs{i}   num2str(numel(find(x == u_ctgs(i))))
      }];
    endfor
    out = [out; {
      '<undefined>'   num2str(n_missing)
    }];
  else
    out = {
      'N. Ctgs.'  num2str(n_ctgs)
      'N. Miss.'  num2str(n_missing)
    };
  endif
endfunction

function out = summary_of_var_string (x)
  x = string (x);
  n_missing = numel (find (ismissing (x)));
  u_strs = unique (x (!ismissing (x)));
  # TODO: x redundancy calculation looks wrong. Figure out a real one.
  #redundancy = (numel(x) - n_missing) / numel(u_strs);
  out = {
    "Card."     num2str(numel(u_strs))
    "N. Miss."  num2str(n_missing)
    #"Redund."   num2str(redundancy)
  };
endfunction

function out = glue_row_strs (strss, n_pad_chars)
  pad = repmat (' ', [1 n_pad_chars]);
  n_cols = numel (strss);
  n_rows = max (cellfun (@numel, strss));
  widths = NaN (1, n_cols);
  for i = 1:numel (strss)
    strss{i}(end+1:n_rows) = {''};
    widths(i) = max (cellfun (@numel, strss{i}));
    for j = 1:numel (strss{i})
      if (numel(strss{i}{j}) < widths(i))
        strss{i}{j}(end+1:widths(i)) = ' ';
      endif
    endfor
  endfor
  grid = cat (2, strss{:});
  for i_line = 1:n_rows
    lines{i_line} = strjoin(grid(i_line,:), {pad});
  endfor
  out = lines;
endfunction

# Categorical summary stuff

function summary_of_categorical (x, fmt)
  error ('tblish.summary: support for categorical inputs is not implemented or fully thought out yet. sorry.')
endfunction
