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

function generate_datasets_list ()
  % Generates the dataset.m file based on existing datasets

  my_dir = fileparts (mfilename ("fullpath"));
  octave_namespace_dir = fileparts (my_dir);
  dataset_m_file = fullfile (octave_namespace_dir, "dataset.m");
  in_file = [dataset_m_file ".in"];

  names = octave.internal.dataset.included_datasets;

  txt = {};
  function p(fmt, varargin)
    txt{end+1} = sprintf(fmt, varargin{:});
  endfunction

  for i_dataset = 1:numel(names)
    name = names{i_dataset};
    dset = octave.internal.dataset.lookup (name);
    
    descr_texi = dset.description_texi;
    texi_lines = regexp (descr_texi, '\r?\n', "split");
    descr_comment_lines = strcat ({"    ## "}, texi_lines);
    descr_comment = strjoin (descr_comment_lines, "\n");

    p ("    ## -*- texinfo -*-");
    p ("    ## @node dataset.%s", name);
    p ("    ## @deftypefn {Static Method} {@var{out} =} %s ()", name);
    p ("    ##");
    p ("    ## %s", dset.summary);
    p ("    ##");
    p ("%s", descr_comment);
    p ("    ##");
    p ("    ## @end deftypefn");
    p ("    function out = %s ()", name);
    p ("      name = '%s';", name);
    p ("      data = octave.datasets.load(name);")
    p ("      if nargout == 0")
    p ("        if isstruct (data)")
    p ("          s = data;")
    p ("          vars = fieldnames (s);")
    p ("          for i = 1:numel (vars)")
    p ("            assignin ('caller', vars{i}, s.(vars{i}));")
    p ("          endfor")
    p ("          loaded_vars = vars;")
    p ("        else")
    p ("          assignin ('caller', name, data);")
    p ("          loaded_vars = { name };")
    p ("        endif")
    p ("%s", "        printf ('Loaded ''%s''. Variables: %s\\n', name, strjoin (loaded_vars, ', '));")
    p ("      else")
    p ("        out = data;")
    p ("      endif")
    p ("    endfunction");
    p ("");
  endfor
  txt = strjoin (txt, "\n");

  in_txt = fileread (in_file);
  out_txt = strrep (in_txt, '@DATASET_LIST_GOES_HERE@', txt);

  [fid, msg] = fopen (dataset_m_file, "w");
  fprintf(fid, "%s", out_txt);
  fclose (fid);
  fprintf ("Regenerated %s\n", dataset_m_file);
endfunction