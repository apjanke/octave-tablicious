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
      names = octave.internal.dataset.included_datasets;
      c = {};
      for i = 1:numel (names)
        dset = octave.internal.dataset.lookup (names{i});
        c = [c; {dset.name dset.summary}];
      endfor
      out = cell2table(c, "VariableNames", {"Name", "Summary"});
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
      dset = octave.internal.dataset.lookup (name);
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

    ## -*- texinfo -*-
    ## @node datasets.description
    ## @deftypefn {Static Method} description (@var{datasetName})
    ## @deftypefnx {Static Method} {@var{out} =} description (@var{datasetName})
    ##
    ## Get or display the description for a dataset.
    ##
    ## Gets the description for the named dataset. If the output is captured,
    ## it is returned as a charvec containing plain text suitable for human display.
    ## If the output is not captured, displays the description to the console.
    ##
    ## @end deftypefn
    function out = description (name)
      dset = octave.internal.dataset.lookup (name);
      out = dset.description;
      if nargout == 0
        disp (out);
        clear out
      endif
    endfunction

    function out = datasets_dir
      parent_dir = fileparts (mfilename ("fullpath"));
      out = fullfile (parent_dir, "datasets");
    endfunction

  endmethods

endclassdef