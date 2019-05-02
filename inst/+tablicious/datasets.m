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
## @deftp {Class} datasets
##
## Example dataset collection.
##
## @code{datasets} is a collection of example datasets to go with the 
## Tablicious package.
##
## The @code{datasets} class provides methods for listing and loading
## the example datasets.
##
## @end deftp
classdef datasets

  properties (Constant)
    mainList = cell2table({
      "iris"    "The Fisher Iris set: measurements for various flowers"
    }, "VariableNames", {"Name", "Description"})
  endproperties

  methods (Static)

    ## -*- texinfo -*-
    ## @node datasets.list
    ## @deftypefn {Static Method} list ()
    ## @deftypefnx {Static Method} {@var{out} =} list ()
    ##
    ## List all datasets.
    ##
    ## Lists all the example datasets known to this class. If the output is
    ## captured, returns the list as a table. If the output is not captured,
    ## displays the list.
    ##
    ## Returns a table with variables Name, Description, and possibly more.
    ##
    ## @end deftypefn
    function out = list ()
      names = tablicious.internal.dataset.included_datasets;
      c = {};
      for i = 1:numel (names)
        dset = tablicious.internal.dataset.lookup (names{i});
        c = [c; {dset.name dset.description}];
      endfor
      out = cell2table(c, "VariableNames", {"Name", "Description"});
      if nargout == 0
        prettyprint (out);
        clear out
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node datasets.load
    ## @deftypefn {Static Method} load (@var{datasetName})
    ## @deftypefnx {Static Method} {@var{out} =} load (@var{datasetName})
    ##
    ## Load a specified dataset.
    ##
    ## @var{datasetName} is the name of the dataset to load, as found in the
    ## @code{Name} column of the dataset list.
    ##
    ## @end deftypefn
    function out = load (name)
      dset = tablicious.internal.dataset.lookup (name);
      s = dset.load ();
      if nargout == 0
        vars = fieldnames (s);
        for i = 1:numel(vars)
          var = vars{i};
          assignin ("caller", var, s.(var));
        endfor
      else
        out = s;
      endif
    endfunction

    function out = datasets_dir
      parent_dir = fileparts (mfilename ("fullpath"));
      out = fullfile (parent_dir, "datasets");
    endfunction

  endmethods

endclassdef