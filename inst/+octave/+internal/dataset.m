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

classdef (Abstract) dataset
  %DATASET An example dataset, managed by Tablicious’ datasets mechanism
  %
  % To use this, subclass it, and have your constructor populate
  % the name and description fields, and implement load(), regenerate(),
  % and possibly fetch().
  % 
  % There are three typical ways to define a dataset:
  %   - All in code, in which case your subclass will just implement load()
  %   - As a stored, checked-in mat-file, in which case your subclass will
  %       implement regenerate_dataset() and load()
  %   - As a cached post-installation mat-file, in which case your subclass
  %       will implement cache_dataset() and load(), and make use of
  %       cache_file_path() in both of them.

  properties (Constant)

    % The list of datasets included with Tablicious itself, in the
    % tablicious.internal.datasets namespace. The names here must match
    % The class base name.
    %
    % Keep this list in alphabetical order, for tidiness.
    included_datasets = {
      "airmiles"
      "AirPassengers"
      "airquality"
      "anscombe"
      "attenu"
      "attitude"
      "austres"
      "beavers"
      "BJsales"
      "BOD"
      "cars"
      "ChickWeight"
      "chickwts"
      "co2"
      "crimtab"
      "cupcake"
      "discoveries"
      "DNase"
      "esoph"
      "euro"
      "eurodist"
      "EuStockMarkets"
      "faithful"
      "Formaldehyde"
      "freeny"
      "HairEyeColor"
      "Harman23cor"
      "Harman74cor"
      "Indometh"
      "infert"
      "InsectSprays"
      "iris"
      "islands"
      "JohnsonJohnson"
      "LakeHuron"
      "lh"
      "LifeCycleSavings"
      "Loblolly"
      "longley"
      "lynx"
      "morley"
      "mtcars"
      "nhtemp"
      "Nile"
      "nottem"
      "npk"
      "occupationalStatus"
      "Orange"
      "OrchardSprays"
      "PlantGrowth"
      "precip"
      "presidents"
      "pressure"
      "Puromycin"
      "quakes"
      "randu"
      "rivers"
      "rock"
      "sleep"
      "stackloss"
      "state"
      "sunspot_month"
      "sunspot_year"
      "sunspots"
      "swiss"
      "Theoph"
      "Titanic"
      "ToothGrowth"
      "treering"
      "trees"
      "UCBAdmissions"
      "UKDriverDeaths"
      "UKgas"
      "UKLungDeaths"
      "USAccDeaths"
      "USArrests"
      "USJudgeRatings"
      "USPersonalExpenditure"
      "uspop"
      "VADeaths"
      "volcano"
      "warpbreaks"
      "women"
      "WorldPhones"
      "WWWusage"
      "zCO2"
    }

  endproperties

  properties
    name
    summary
  endproperties

  methods (Static)

    function out = lookup (name)
      if ! ismember (name, octave.internal.dataset.included_datasets)
        error ("No defined dataset with name '%s'", name);
      endif
      class_name = ["octave.internal.datasets." name];
      out = feval (class_name);
    endfunction

    function regenerate_all_datasets ()
      names = octave.internal.dataset.included_datasets;
      for i = 1:numel (names)
        dset = octave.internal.dataset.lookup (names{i});
        dset.regenerate_dataset ();
      endfor
    endfunction

  endmethods

  methods
    
    function out = load (this)
      %LOAD Load the dataset from its local files
      %
      % This is what gets called when a user does tablicious.datasets.load("foo").
      %
      % This method must return a scalar struct whose fields are
      % the variables defined in this dataset.
      error("dataset.load is abstract. Subclass %s must implement it, but it does not.", ...
        class (this));
    endfunction

    function out = description_texi (this)
      %DESCRIPTION_TEXI Get the Texinfo description for this dataset
      description_file = fullfile (this.class_dir, "description.texi");
      if ! isfile (description_file)
        out = "<no description available>";
        return
      endif
      texi_in = fileread (description_file);
      % Process our special directives
      texi = texi_in;
      octave_namespace_dir = fileparts (fileparts (mfilename ("fullpath")));
      example_scripts_dir = fullfile (octave_namespace_dir, "+examples", ...
        "+internal", "+datasets");
      % Include example scripts
      while true
        [ix_start, ix_end, tok] = regexp (texi, '@INCLUDE_DATASET_EXAMPLE_SCRIPT\{(.*?)\}', ...
          "start", "end", "tokens");
        if isempty (ix_start)
          break
        endif
        script_file_base = tok{1}{1};
        script_file = fullfile (example_scripts_dir, script_file_base);
        if ! isfile (script_file)
          error ("dataset.description_texi: File not found: %s", script_file);
        endif
        script = fileread (script_file);
        script_texi = escape_for_texi (script);
        texi = [texi(1:ix_start-1) script_texi texi(ix_end+1:end)];
      endwhile
      out = texi;
    endfunction

    function regenerate_dataset (this)
      % Regenerate the dataset from its original source
      %
      % This is what goes out to a website or some other source, downloads
      % the original source data, parses and munges it, and saves it as a
      % .mat file (or something else) in the Tablicious source tree. This is
      % called at development time by the dataset’s maintainer. It should not
      % be called by the user.
      %
      % Since the dataset is never expected to change, and the generated files
      % are checked into the source tree, this method only needs to be called
      % if the file format for Octave mat-files changes, or something similar.
      % So, basically never, and it"s included just as a reference for where
      % the data came from.
      %
      % This is a do-nothing in the base class. Leave it as a do-nothing if
      % your dataset does not require regeneration.
    endfunction

    function cache_dataset (this)
      % Cache the dataset by downloading it and storing in user cache files
      %
      % This is what gets called by cache_all_datasets. The user will call
      % that after installing Octave. This caching mechanism is for datasets
      % that cannot be directly redistributed with Octave or Tablicious itself,
      % for size or licensing reasons.
      %
      % Most datasets should not require caching, so this should be left as
      % a do-nothing method for most datasets.
    endfunction

    function out = cache_file_path (this)
      %CACHE_FILE_PATH Path to the local cache file, for classes that use caching

      if ispc
        error (["octave.internal.dataset.cache_file_path: this is not " ...
          "implemented for Windows yet. Sorry."]);
      else
        % Use the XDG standard cache location on Linux and Mac
        xdg_cache_dir = fullfile (getenv ("HOME"), ".cache");
        datasets_cache_dir = fullfile (xdg_cache_dir, "octave", "datasets");
      endif
      out = fullfile (datasets_cache_dir, [class(this) ".mat"]);
    endfunction

  endmethods

  methods (Protected)
    function out = class_dir (this)
      %CLASS_DIR Directory of the class definition
      %
      % This only works for datasets implemented as part of Tablicious" example
      % data sets, because it makes assumptions about where they live. We have
      % to do this because Octave"s which() doesn"t work on classes in namespaces,
      % as of Octave 4.4.
      my_dir = fileparts (mfilename ("fullpath"));
      datasets_namespace_dir = fullfile (my_dir, "+datasets");
      klass = class (this);
      base_class = regexprep (klass, '.*\.', "");
      out = fullfile (datasets_namespace_dir, ["@" base_class]);
    endfunction
  endmethods
endclassdef

function out = escape_for_texi (txt)
  out = txt;
  out = strrep (out, "@", "@@");
  out = strrep (out, "{", "@{");
  out = strrep (out, "}", "@}");
endfunction
