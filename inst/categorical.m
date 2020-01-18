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

# TODO: Consider combining .code and .tfMissing into one @single .code array, 
# where NaNs are used to indicate undefineds, instead of a separate tfMissing 
# mask. Or even keep .code as uint16, and just use 0 to indicate undefined.
# Would require creating more temporaries, but some of the code would be simpler.
# Would be about the same storage at rest (uint16 + logical = 3 bytes;
# single = 4 bytes).
# ...actually, it might not be that great: you can't use NaN for indexing and have
# it silently produce another NaN, so you'll still have to mask a lot of your
# operations (in this implementation) with (ismissing(this)).

## -*- texinfo -*-
## @deftp {Class} categorical
##
## Categorical variable array.
##
## A @code{categorical} array represents an array of values of a categorical
## variable. Each @code{categorical} array stores the element values along
## with a list of the categories, and indicators of whether the categories
## are ordinal (that is, they have a meaningful mathematical ordering), and
## whether the set of categories is protected (preventing new categories
## from being added to the array).
##
## In addition to the categories defined in the array, a categorical array
## may have elements of "undefined" value. This is not considered a
## category; rather, it is the absence of any known value. It is
## analagous to a @code{NaN} value.
##
## This class is not fully implemented yet. Missing stuff:
##   - gt, ge, lt, le
##   - Ordinal support in general
##   - countcats
##   - summary
##
## @end deftp
##
## @deftypeivar categorical @code{uint16} code
##
## The numeric codes of the array element values. These are indexes into the
## @code{cats} category list.
##
## This is a planar property.
##
## @end deftypeivar
##
## @deftypeivar categorical @code{logical} tfMissing
##
## A logical mask indicating whether each element of the array is missing
## (that is, undefined).
##
## This is a planar property.
##
## @end deftypeivar
##
## @deftypeivar categorical @code{cellstr} cats
##
## The names of the categories in this array. This is the list into which
## the @code{code} values are indexes.
##
## @end deftypeivar
##
## @deftypeivar categorical @code{scalar_logical} isOrdinal
##
## A scalar logical indicating whether the categories in this array have an
## ordinal relationship.
##
## @end deftypeivar
classdef categorical
  
  properties (SetAccess = private)
    % Code for each element. Codes are an index into cats.
    code = uint16 (0)     % planar
    % Whether each element is missing/undefined
    tfMissing = true      % planar
    % The list of category names for this array, indexed by code
    cats = {}             % not planar
    % Whether this array is ordinal
    isOrdinal = false     % not planar
    % Whether this array's categories are "protected", which disallows implicit
    % expansion of the category list
    isProtected = false   % not planar
  endproperties
  
  methods (Static = true, Hidden = true)
    function out = from_codes (codes, cats, varargin)
      [opts, args] = peelOffNameValueOptions (varargin, {'Ordinal', 'Protected'});
      isOrdinal = false;
      if isfield (opts, 'Ordinal')
        mustBeScalarLogical (opts.Ordinal, 'Ordinal option');
        isOrdinal = opts.Ordinal;
      endif
      isProtected = false;
      if isfield (opts, 'Protected')
        mustBeScalarLogical (opts.Protected, 'Protected option');
        isProtected = opts.Protected;
      endif
      cats = cellstr(cats);
      cats = cats(:)';
      
      code = uint16 (codes);
      if ! isa (codes, 'uint16')
        % TODO: Check for clean conversion
      endif
      
      out = categorical;
      out.code = code;
      out.tfMissing = isnan (codes);
      out.cats = cats;
      out.isOrdinal = isOrdinal;
      out.isProtected = isProtected;
    endfunction
  endmethods
  
  methods (Static)
    
    ## -*- texinfo -*-
    ## @node categorical.undefined
    ## @deftypefn {Static Method} {@var{out} =} categorical.undefined ()
    ## @deftypefnx {Static Method} {@var{out} =} categorical.undefined (sz)
    ##
    ## Create an array of undefined categoricals.
    ##
    ## Creates a categorical array whose elements are all <undefined>.
    ##
    ## @var{sz} is the size of the array to create. If omitted or empty, creates
    ## a scalar.
    ##
    ## Returns a categorical.
    ##
    ## @end deftypefn
    function out = undefined (sz)
      if nargin < 1 || isempty (sz);  sz = [1 1]; end
      out = categorical;
      out.code = repmat (uint16(0), sz);
      out.tfMissing = true (sz);
      out.cats = {};
    endfunction
    
  endmethods
  
  methods
    
    ## -*- texinfo -*-
    ## @node categorical.categorical
    ## @deftypefn {Constructor} {@var{obj} =} categorical ()
    ##
    ## Constructs a new scalar categorical whose value is undefined.
    ##
    ## @end deftypefn
    ##
    ## @deftypefn {Constructor} {@var{obj} =} categorical (@var{vals})
    ## @deftypefnx {Constructor} {@var{obj} =} categorical (@var{vals}, @var{valueset})
    ## @deftypefnx {Constructor} {@var{obj} =} categorical (@var{vals}, @var{valueset}, @var{category_names})
    ## @deftypefnx {Constructor} {@var{obj} =} categorical (@dots{}, @code{'Ordinal'}, @var{Ordinal})
    ## @deftypefnx {Constructor} {@var{obj} =} categorical (@dots{}, @code{'Protected'}, @var{Protected})
    ##
    ## Constructs a new categorical array from the given values.
    ##
    ## @var{vals} is the array of values to convert to categoricals.
    ##
    ## @var{valueset} is the set of all values from which @var{vals} is drawn.
    ## If omitted, it defaults to the unique values in @var{vals}.
    ##
    ## @var{category_names} is a list of category names corresponding to
    ## @var{valueset}. If omitted, it defaults to @var{valueset}, converted
    ## to strings.
    ##
    ## @var{Ordinal} is a logical indicating whether the category values in
    ## @var{obj} have a numeric ordering relationship. Defaults to false.
    ##
    ## @var{Protected} indicates whether @var{obj} should be protected, which
    ## prevents the addition of new categories to the array. Defaults to
    ## false.
    ##
    ## @end deftypefn
    function this = categorical (x, varargin)
      % TODO: Empty strings and cellstrs should convert to <undefined>
      % TODO: Handle datetime and duration inputs
      % TODO: Handle logical inputs
      % TODO: Handle @missing inputs
      % TODO: Numeric conversion is probably wrong. It's trying to convert 
      % numeric inputs directly to codes. It should probably convert them to the
      % num2str representation of numbers instead, and make those all categories.
      % TODO: Support objects.
      
      if nargin == 0
        return
      endif
      
      validOptions = {'Ordinal', 'Protected'};
      [opts, args] = peelOffNameValueOptions (varargin, validOptions);
      if ischar (x)
        x = cellstr (x);
      endif
      if numel (args) >= 1
        valueset = args{1};
        valueset = valueset(:)';
        if any (ismissing (valueset))
          error ('categorical:InvalidInput', 'categorical: Cannot have missing values in valueset');
        endif
        u_valueset = unique (valueset);
        if numel (u_valueset) < numel (valueset)
          error ("categorical:InvalidInput", ...
            "categorical: Non-unique values in valueset; valueset values must be unique.");
        endif
      else
        valueset = unique (x);
        valueset = valueset(!ismissing (valueset));
      endif
      if numel (args) >= 2
        category_names = args{2};
      else
        if isa (valueset, 'string') || iscellstr (valueset)
          category_names = cellstr (valueset);
        else
          category_names = dispstrs (valueset);
        endif
      endif
      doProtected = false;
      if isfield (opts, 'Protected')
        mustBeScalarLogical (opts.Protected, 'Protected option');
        doProtected = opts.Protected;
      endif
      doOrdinal = false;
      if isfield (opts, 'Ordinal')
        mustBeScalarLogical (opts.Ordinal, 'Ordinal option');
        doOrdinal = opts.Ordinal;
      endif
      if doOrdinal
        doProtected = true;
      endif
      
      [tf, loc] = ismember (x, valueset);
      if any(loc > intmax ('uint16'))
        error (['Category count out of range: categorical supports a max of %d ' ...
          'categories; this input has %d'], intmax ('uint16'), max (loc));
      endif
      code = uint16 (loc);
      code(!tf) = 0;
      tfMissing = !tf;
      
      this.code = code;
      this.tfMissing = tfMissing;
      this.cats = category_names;
      this.isOrdinal = doOrdinal;
      this.isProtected = doProtected;
    endfunction

    ## -*- texinfo -*-
    ## @node categorical.sizeof
    ## @deftypefn {Method} {@var{out} =} sizeof (@var{obj})
    ##
    ## Size of array in bytes.
    ##
    ## @end deftypefn
    function out = sizeof (this)
      out = 0;
      out += sizeof (this.code);
      out += sizeof (this.tfMissing);
      out += sizeof (this.cats);
      out += sizeof (this.isOrdinal);
      out += sizeof (this.isProtected);
    endfunction
    
    function this = set.code (this, x)
      if ! isnumeric (x)
        error ('categorical.code: values must be numeric');
      endif
      code = uint16 (x);
      if ! isa (x, 'uint16')
        if ! all (code(:) == x(:))
          error ('categorical.code: input did not convert cleanly to uint16');
        endif
      endif
      this.code = code;
    endfunction
    
    ## -*- texinfo -*-
    ## @node categorical.categories
    ## @deftypefn {Method} {@var{out} =} categories (@var{obj})
    ##
    ## Get a list of the categories in @var{obj}.
    ##
    ## Gets a list of the categories in @var{obj}, identified by their 
    ## category names.
    ##
    ## Returns a cellstr column vector.
    ##
    ## @end deftypefn
    function out = categories (this)
      out = this.cats(:);
    endfunction
    
    ## -*- texinfo -*-
    ## @node categorical.iscategory
    ## @deftypefn {Method} {@var{out} =} iscategory (@var{obj}, @var{catnames})
    ##
    ## Test whether input is a category on a categorical array.
    ##
    ## @var{catnames} is a cellstr listing the category names to check against
    ## @var{obj}.
    ##
    ## Returns a logical array the same size as @var{catnames}.
    ##
    ## @end deftypefn
    function out = iscategory (this, catnames)
      %ISCATEGORY Test for category name existence
      %
      % out = iscategory (this, catnames)
      mustBeA (this, 'categorical');
      catnames = cellstr (catnames);
      out = ismember (catnames, this.cats);
    endfunction
    
    ## -*- texinfo -*-
    ## @node categorical.isordinal
    ## @deftypefn {Method} {@var{out} =} isordinal (@var{obj})
    ##
    ## Whether @var{obj} is ordinal.
    ##
    ## Returns true if @var{obj} is ordinal (as determined by its
    ## @code{IsOrdinal} property), and false otherwise.
    ##
    ## @end deftypefn
    function out = isordinal (this)
      out = this.isOrdinal;
    endfunction
    
    ## -*- texinfo -*-
    ## @node categorical.string
    ## @deftypefn {Method} {@var{out} =} string (@var{obj})
    ##
    ## Convert to string array.
    ##
    ## Converts @var{obj} to a string array. The strings will be the
    ## category names for corresponding values, or <missing> for undefined
    ## values.
    ##
    ## Returns a @code{string} array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = string (this)
      out = cell (size (this));
      out(!this.tfMissing) = this.cats(this.code(!this.tfMissing));
      out = string (out);
      out(this.tfMissing) = string.missing;
    endfunction
    
    ## -*- texinfo -*-
    ## @node categorical.cellstr
    ## @deftypefn {Method} {@var{out} =} cellstr (@var{obj})
    ##
    ## Convert to cellstr.
    ##
    ## Converts @var{obj} to a cellstr array. The strings will be the
    ## category names for corresponding values, or @code{''} for undefined
    ## values.
    ##
    ## Returns a cellstr array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = cellstr (this)
      out = cell (size (this));
      out(!this.tfMissing) = this.cats(this.code(!this.tfMissing));
      out(this.tfMissing) = {""};      
    endfunction
    
    function display (this)
      %DISPLAY Custom display
      in_name = inputname(1);
      if ~isempty(in_name)
        fprintf('%s =\n', in_name);
      end
      disp(this);
    end

    function disp (this)
      %DISP Custom display
      if isempty (this)
        fprintf ('Empty %s categorical\n', size2str (size (this)));
        return;
      end
      my_dispstrs = this.dispstrs;
      out = format_dispstr_array (my_dispstrs);
      fprintf("%s", out);
    end
    
    ## -*- texinfo -*-
    ## @node categorical.dispstrs
    ## @deftypefn {Method} {@var{out} =} dispstrs (@var{obj})
    ##
    ## Display strings.
    ##
    ## Gets display strings for each element in @var{obj}. The display strings are
    ## either the category string, or @code{'<undefined>'} for undefined values.
    ##
    ## Returns a cellstr array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = dispstrs (this)
      out = cell (size (this));
      ix = this.code(!this.tfMissing);
      out(!this.tfMissing) = this.cats(ix);
      out(this.tfMissing) = {'<undefined>'};
    endfunction
    
    function out = dispstr (this)
      if isscalar (this)
        d = dispstrs (this);
        out = d{1};
      else
        out = sprintf ('%s %s array', size2str (size (this)), class (this));
      endif
    endfunction

    function out = sprintf(fmt, varargin)
      args = varargin;
      for i = 1:numel (args)
        if isa (args{i}, 'categorical')
          args{i} = dispstr (args{i});
        endif
      endfor
      out = sprintf (fmt, args{:});
    endfunction
    
    function out = fprintf(varargin)
      args = varargin;
      if isnumeric (args{1})
        fid = args{1};
        args(1) = [];
      else
        fid = [];
      endif
      fmt = args{1};
      args(1) = [];
      for i = 1:numel (args)
        if isa (args{i}, 'categorical')
          args{i} = dispstr (args{i});
        endif
      endfor
      if isempty (fid)
        fprintf (fmt, args{:});
      else
        fprintf (fid, fmt, args{:});
      endif
    endfunction
    
    ## -*- texinfo -*-
    ## @node categorical.summary
    ## @deftypefn {Method} {} summary (@var{obj})
    ##
    ## Display summary of array’s values.
    ##
    ## Displays a summary of the values in this categorical array. The output
    ## may contain info like the number of categories, number of undefined values,
    ## and frequency of each category.
    ##
    ## @end deftypefn
    function summary (this)
      %SUMMARY Print a summary of the values in this categorical array
      
      Code = [1:numel(this.cats)]';
      Category = this.cats';
      category_table = table (Code, Category);
      
      fprintf ('Categorical array\n');
      fprintf ('  %d categories, %d elements\n', numel (Category), numel (this));
      fprintf ('  %d undefined values\n', numel (find (this.tfMissing(:))));
      prettyprint (category_table);
      % TODO: Frequencies of each code value. Probably just roll that up into the
      % above table as an additional column.
    endfunction
    
    ## -*- texinfo -*-
    ## @node categorical.addcats
    ## @deftypefn {Method} {@var{out} =} addcats (@var{obj}, @var{newcats})
    ##
    ## Add categories to categorical array.
    ##
    ## Adds the specified categories to @var{obj}, without changing any of
    ## its values.
    ##
    ## @var{newcats} is a cellstr listing the category names to add to
    ## @var{obj}.
    ##
    ## @end deftypefn
    function out = addcats (this, newcats)
      narginchk (2, 2);
      newcats = cellstr (newcats);
      newcats = newcats(:)';
      if this.isOrdinal
        error (['categorical.addcats: Adding categories for Ordinal arrays is ' ...
          'not implemented yet. Sorry.']);
      endif
      [tf, loc] = ismember (newcats, this.cats);
      if any (tf)
        error ('categorical.addcats: Categories are already present in input: %s', ...
          strjoin (newcats(tf), ', '));
      endif
      out = this;
      out.cats = [out.cats newcats];
    endfunction
    
    ## -*- texinfo -*-
    ## @node categorical.removecats
    ## @deftypefn {Method} {@var{out} =} removecats (@var{obj})
    ##
    ## Removes all unused categories from @var{obj}. This is equivalent to
    ## @code{out = squeezecats (obj)}.
    ##
    ## @end deftypefn
    ##
    ## @deftypefn {Method} {@var{out} =} removecats (@var{obj}, @var{oldcats})
    ##
    ## Remove categories from categorical array.
    ##
    ## Removes the specified categories from @var{obj}. Elements of @var{obj}
    ## whose values belonged to those categories are replaced with undefined.
    ##
    ## @var{newcats} is a cellstr listing the category names to add to
    ## @var{obj}.
    ##
    ## @end deftypefn
    function out = removecats (this, oldcats)
      if nargin == 1
        out = squeezecats (this);
        return
      end
      
      oldcats = cellstr (oldcats);
      [tf, codes_to_remove] = ismember (oldcats, this.cats);
      [tf_undef] = ismember (this.code, codes_to_remove)
      out = this;
      out.code(tf_undef) = 0;
      out.tfMissing = out.tfMissing | tf_undef;
      out = remove_unused_cats (out, oldcats);
    endfunction
    
    ## -*- texinfo -*-
    ## @node categorical.mergecats
    ## @deftypefn {Method} {@var{out} =} mergecats (@var{obj}, @var{oldcats})
    ## @deftypefnx {Method} {@var{out} =} mergecats (@var{obj}, @var{oldcats}, @var{newcat})
    ##
    ## Merge multiple categories.
    ##
    ## Merges the categories @var{oldcats} into a single category. If @var{newcat}
    ## is specified, that new category is added if necessary, and all of @var{oldcats}
    ## are merged into it. @var{newcat} must be an existing category in @var{obj} if
    ## @var{obj} is ordinal.
    ##
    ## If @var{newcat} is not provided, all of @var{odcats} are merged into
    ## @code{oldcats@{1@}}.
    ##
    ## @end deftypefn
    function out = mergecats (this, oldcats, newcat)
      narginchk (2, 3);
      mustBeNonEmpty (oldcats);
      if nargin < 3
        newcat = oldcats{1};
      endif
      oldcats = cellstr (oldcats);
      
      if this.isOrdinal
        error ('categorical: Merging of ordinal categories is not yet implemented. Sorry.');
      endif
      
      [tf, old_cat_codes] = ismember (oldcats, this.cats);
      if ! all (tf)
        % TODO: I don't know if this should be an error, or just silently ignored -apj
        error ('categorical.mergecats: Specified categories not present in input: %s', ...
          strjoin(oldcats(!tf), ', '));
      endif
      [is_current_cat, new_cat_code] = ismember (newcat, this.cats)
      
      out = this;
      if is_current_cat
        % Merge into existing category
        cats_to_delete = setdiff (oldcats, newcat);
        [tf, loc] = ismember (this.code, old_cat_codes);
        out.code(tf) = new_cat_code;
        out = remove_unused_cats (out, cats_to_delete);
      else
        % Merge into new category
        cats_to_delete = oldcats;
        [tf, loc] = ismember (this.code, old_cat_codes);
        out = addcats (out, newcat);
        [~, new_cat_code] = ismember (newcat, out.cats);
        out.code(tf) = new_cat_code;
        out = remove_unused_cats (out, cats_to_delete);
      endif
    endfunction
    
    ## -*- texinfo -*-
    ## @node categorical.renamecats
    ## @deftypefn {Method} {@var{out} =} renamecats (@var{obj}, @var{newcats})
    ## @deftypefnx {Method} {@var{out} =} renamecats (@var{obj}, @var{oldcats}, @var{newcats})
    ##
    ## Rename categories.
    ##
    ## Renames some or all of the categories in @var{obj}, without changing
    ## any of its values.
    ##
    ## @end deftypefn
    function out = renamecats (this, varargin)
      narginchk (2, 3);
      if nargin == 2
        oldnames = this.cats;
        newnames = varargin{1};
      else
        oldnames = varargin{1};
        newnames = varargin{2};
      endif
      oldnames = cellstr (oldnames);
      oldnames = oldnames(:)';
      newnames = cellstr (newnames);
      newnames = newnames(:)';
      if ! isequal (size (oldnames), size (newnames));
        error (['categorical.renamecats: Inconsistent dimensions for oldnames ' ...
          'and newnames: %s vs %s'], size2str (size (oldnames)), size2str (size (newnames)));
      endif
      
      out = this;
      [tf, loc] = ismember (oldnames, this.cats);
      if ! all (tf)
        error ('categorical.renamecats: Specified categories do not exist in input: %s', ...
          strjoin (oldnames(!tf), ', '));
      endif
      out.cats(loc) = newnames;
    endfunction

    ## -*- texinfo -*-
    ## @node categorical.reordercats
    ## @deftypefn {Method} {@var{out} =} reordercats (@var{obj})
    ## @deftypefnx {Method} {@var{out} =} reordercats (@var{obj}, @var{newcats})
    ##
    ## Reorder categories.
    ##
    ## Reorders the categories in @var{obj} to match @var{newcats}.
    ##
    ## @var{newcats} is a cellstr that must be a reordering of @var{obj}’s existing
    ## category list. If @var{newcats} is not supplied, sorts the categories
    ## in alphabetical order.
    ##
    ## @end deftypefn
    function out = reordercats (this, newcats)
      if nargin == 1
        newcats = sort (this.cats);
      endif
      newcats = cellstr (newcats);
      newcats = newcats(:)';
      if ! isequal (sort (newcats), sort (this.cats))
        error ('categorical.reordercats: newcats and oldcats must be the same sets, just reordered');
      endif
      
      [tf, loc] = ismember (this.cats, newcats);
      new_codes = NaN (size (this.code));
      new_codes(!this.tfMissing) = loc(this.code(!this.tfMissing));
      out = this;
      out.code = new_codes;
      out.cats = newcats;
    endfunction
    
    ## -*- texinfo -*-
    ## @node categorical.setcats
    ## @deftypefn {Method} {@var{out} =} setcats (@var{obj}, @var{newcats})
    ##
    ## Set categories for categorical array.
    ##
    ## Sets the categories to use for @var{obj}. If any current categories
    ## are absent from the @var{newcats} list, current values of those
    ## categories become undefined.
    ##
    ## @end deftypefn
    function out = setcats (this, newcats)
      newcats = cellstr (newcats);
      newcats = newcats(:)';
      
      if this.isOrdinal
        error ('categorical.setcats: Cannot set categories on Ordinal categorical arrays');
      endif
      
      [tf, loc] = ismember (this.cats, newcats);
      loc(~tf) = 0;
      codes = codes_with_nans (this);
      new_codes = NaN(size(codes));
      new_codes(!isnan(codes)) = loc(codes(!isnan(codes)));
      out = this;
      out.code = uint16 (new_codes);
      out.tfMissing = out.tfMissing | isnan (new_codes) | new_codes == 0;
    endfunction
    
    ## -*- texinfo -*-
    ## @node categorical.isundefined
    ## @deftypefn {Method} {@var{out} =} isundefined (@var{obj})
    ##
    ## Test whether elements are undefined.
    ##
    ## Checks whether each element in @var{obj} is undefined. "Undefined" is
    ## a special value defined by @code{categorical}. It is equivalent to
    ## a @code{NaN} or a @code{missing} value.
    ##
    ## Returns a logical array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = isundefined (this)
      out = this.tfMissing;
    endfunction
    
    ## -*- texinfo -*-
    ## @node categorical.ismissing
    ## @deftypefn {Method} {@var{out} =} ismissing (@var{obj})
    ##
    ## Test whether elements are missing.
    ##
    ## For categorical arrays, undefined elements are considered to be
    ## missing.
    ##
    ## Returns a logical array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = ismissing (this)
      out = this.tfMissing;
    endfunction
    
    ## -*- texinfo -*-
    ## @node categorical.isnannish
    ## @deftypefn {Method} {@var{out} =} isnannish (@var{obj})
    ##
    ## Test whethere elements are NaN-ish.
    ##
    ## Checks where each element in @var{obj} is NaN-ish. For categorical
    ## arrays, undefined values are considered NaN-ish; any other 
    ## value is not.
    ##
    ## Returns a logical array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = isnannish (this)
      out = ismissing (this);
    endfunction
    
    ## -*- texinfo -*-
    ## @node categorical.squeezecats
    ## @deftypefn {Method} {@var{out} =} squeezecats (@var{obj})
    ##
    ## Remove unused categories.
    ##
    ## Removes all categories which have no corresponding values in @var{obj}’s
    ## elements.
    ##
    ## This is currently unimplemented.
    ##
    ## @end deftypefn
    function out = squeezecats (this)
      error('categorical.squeezecategories: This is unimplemented. Sorry.');
    endfunction
    
    function [A, B] = promote2 (A, B)
      %PROMOTE2 Promote exactly 2 inputs to be comparable categoricals.
      %
      % This is an internal implementation method that will become private before
      % release 1.0.
      %
      % TODO: Promotion of plain values should pick up the Ordinality of its
      % categorical counterpart, to support stuff like `x < 'foo'`.
      
      inA = A;
      inB = B;
      
      % Make them both categoricals
      % TODO: This implementation is wrong. It requires inputs to map to existing
      % categories on the categorical input. Whether that is required should be
      % determined by the Protected property; non-Protected categoricals may expand
      % their set of categories automatically.
      if ! isa (A, 'categorical')
        if isordinal (B)
          B = promote_to_existing_categories (A, B);
        else
          A = categorical (A);
        end
      endif
      if ! isa (B, 'categorical')
        if isordinal (A)
          B = promote_to_existing_categories (B, A);
        else
          B = categorical (B);
        endif
      endif
      
      % Unify their category definitions
      if isequal (A.cats, B.cats)
        return
      endif
      if isordinal (A) || isordinal (B)
        error ('categorical: cannot unify different categories for Ordinal categorical arrays');
      endif
      [A, B] = unify_nonordinal_categories (A, B);
    endfunction
    
    function [outA, outB] = unify_nonordinal_categories (A, B)
      mustBeA (A, 'categorical');
      mustBeA (B, 'categorical');
      % TODO: In the protected case, eliminate categories that have no values on
      % the non-protected side, to avoid possibly-spurious errors.
      if A.isProtected
        cats_only_in_B = setdiff (B.cats, A.cats);
        if ! isempty (cats_only_in_B)
          error ('categorical: input A is Protected, but input B has categories not in A: %s', ...
            strjoin (cats_only_in_B, ', '));
        endif
      endif
      if B.isProtected
        cats_only_in_A = setdiff (A.cats, B.cats);
        if ! isempty (cats_only_in_A)
          error ('categorical: input B is Protected, but input A has categories not in B: %s', ...
            strjoin (cats_only_in_A, ', '));
        endif        
      endif
      % Okay, at this point, it's safe to expand categories on both sides, either
      % because they're not protected, or they will gain no new categories
      unified_categories = unique ([A.cats B.cats]);
      [tf, code_map_a] = ismember (A.cats, unified_categories);
      new_code_a = A.code;
      new_code_a(!A.tfMissing) = code_map_a(A.code(!A.tfMissing));
      outA = A;
      outA.code = new_code_a;
      outA.cats = unified_categories;
      [tf, code_map_b] = ismember (B.cats, unified_categories);
      new_code_b = B.code;
      new_code_b(!B.tfMissing) = code_map_b(B.code(!B.tfMissing));
      outB = B;
      outB.code = new_code_b;
      outB.cats = unified_categories;
    endfunction
    
    % Relational operations
    
    function out = eq (A, B)
      %EQ Equals
      [A, B] = promote2 (A, B);
      out = A.code == B.code;
      out(A.tfMissing | B.tfMissing) = false;
    endfunction
    
    function out = ne (A, B)
      %NE Not equal
      [A, B] = promote2 (A, B);
      out = A.code != B.code;
      out(A.tfMissing | B.tfMissing) = false;      
    endfunction
    
    % TODO: lt, le, gt, ge - depends on more refined conversion semantics
    
    function [out, idx] = ismember (A, B, varargin)
      %ISMEMBER Set membership
      %
      % [out, idx] = ismember (A, B)
      % [out, idx] = ismember (A, B, "rows")
      %
      % Returns a logical array the same size as A. Also returns idx, an index
      % into B of a matching item for each matched element or row in A.
      [A, B] = promote2 (A, B);
      % Hack: use NaN indexes to handle missings
      code_A = codes_with_nans (A);
      code_B = codes_with_nans (B);
      [out, idx] = ismember (code_A, code_B, varargin{:});
    endfunction
    
    function [out, indx, jndx] = unique (X, varargin)
      %UNIQUE Unique values
      %
      % [out, indx, jndx] = unique (X)
      % [out, indx, jndx] = unique (X, "rows")
      % [out, indx, jndx] = unique (..., "first")
      % [out, indx, jndx] = unique (..., "last")
      %
      % Returns a categorical array with the unique values from X, but the 
      % same category list and ordinality.
      
      % Hack: use NaN indexes to handle missings
      code = codes_with_nans (X);
      [u_code, indx, jndx] = unique (code, varargin{:});
      out = X;
      out.code = uint16 (u_code);
      out.tfMissing = isnan (u_code);
    endfunction
    
    function [out, indx] = sort (this, varargin)
      %SORT Sort values
      %
      % [out, indx] = sort (X)
      % [out, indx] = sort (X, dim)
      % [out, indx] = sort (X, mode)
      % [out, indx] = sort (X, dim, mode)
      code = codes_with_nans (this);
      [out_code, indx] = sort (code, varargin{:});
      out = this;
      out.code = uint16(out_code);
      out.tfMissing = isnan (out_code);
    endfunction
    
    function [out, ixa, ixb] = union (A, B, varargin)
      %UNION Set union
      %
      % [out, ixa, ixb] = union (A, B)
      % [out, ixa, ixb] = union (A, B, "rows")
      
      [A, B] = promote2 (A, B);
      % Hack: use NaN indexes to handle missings
      code_A = codes_with_nans (A);
      code_B = codes_with_nans (B);

      code_out = union (code_A, code_B, varargin{:});
      
      out = A;
      out.code = uint16 (code_out);
      out.tfMissing = isnan (code_out);
    endfunction
    
    function [out, ixa, ixb] = intersect (A, B, varargin)
      %INTERSECT Set intersection
      %
      % [out, ixa, ixb] = intersect (A, B)
      % [out, ixa, ixb] = intersect (A, B, "rows")
      
      [A, B] = promote2 (A, B);
      % Hack: use NaN indexes to handle missings
      code_A = codes_with_nans (A);
      code_B = codes_with_nans (B);

      code_out = intersect (code_A, code_B, varargin{:});
      
      out = A;
      out.code = uint16 (code_out);
      out.tfMissing = isnan (code_out);
    endfunction
    
    function [out, ixa, ixb] = setdiff (A, B, varargin)
      %SETDIFF Set difference
      %
      % [out, ixa, ixb] = setdiff (A, B)
      % [out, ixa, ixb] = setdiff (A, B, "rows")
      
      [A, B] = promote2 (A, B);
      % Hack: use NaN indexes to handle missings
      code_A = codes_with_nans (A);
      code_B = codes_with_nans (B);

      code_out = setdiff (code_A, code_B, varargin{:});
      
      out = A;
      out.code = uint16 (code_out);
      out.tfMissing = isnan (code_out);
    endfunction
    
    function [out, ixa, ixb] = setxor (A, B, varargin)
      %SETXOR Set exclusive or
      %
      % [out, ixa, ixb] = setxor (A, B)
      % [out, ixa, ixb] = setxor (A, B, "rows")
      
      [A, B] = promote2 (A, B);
      % Hack: use NaN indexes to handle missings
      code_A = codes_with_nans (A);
      code_B = codes_with_nans (B);
      
      code_out = setxor (code_A, code_B, varargin{:});
      
      out = A;
      out.code = uint16 (code_out);
      out.tfMissing = isnan (code_out);
    endfunction
    
  endmethods
  
  % Planar structural stuff
  methods
    
    function out = size (this, dim)
      %SIZE Size of array.
      if nargin == 1
        out = size (this.code);
      else
        out = size (this.code, dim);
      endif
    endfunction
    
    function out = numel (this)
      %NUMEL Number of elements in array.
      out = numel (this.code);
    endfunction
    
    function out = ndims (this)
      %NDIMS Number of dimensions.
      out = ndims(this.code);
    endfunction
    
    function out = isempty(this)
      %ISEMPTY True for empty array.
      out = isempty (this.code);
    endfunction
    
    function out = isscalar (this)
      %ISSCALAR True if input is scalar.
      out = isscalar (this.code);
    endfunction
    
    function out = isvector (this)
      %ISVECTOR True if input is a vector.
      out = isvector (this.code);
    endfunction
      
    function out = iscolumn (this)
      %ISCOLUMN True if input is a column vector.
      out = iscolumn (this.code);
    endfunction
    
    function out = isrow (this)
      %ISROW True if input is a row vector.
      out = isrow (this.code);
    endfunction
    
    function out = ismatrix (this)
      %ISMATRIX True if input is a matrix.
      out = ismatrix (this.code);
    endfunction
    
    function this = reshape (this, varargin)
      %RESHAPE Reshape array.
      this.code = reshape (this.code, varargin{:});
      this.tfMissing = reshape (this.tfMissing, varargin{:});
    endfunction
    
    function this = squeeze (this, varargin)
      %SQUEEZE Remove singleton dimensions.
      this.code = squeeze (this.code, varargin{:});
      this.tfMissing = squeeze (this.tfMissing, varargin{:});
    endfunction
      
    function this = circshift (this, varargin)
      %CIRCSHIFT Shift positions of elements circularly.
      this.code = circshift (this.code, varargin{:});
      this.tfMissing = circshift (this.tfMissing, varargin{:});
    endfunction
    
    function this = permute (this, varargin)
      %PERMUTE Permute array dimensions.
      this.code = permute (this.code, varargin{:});
      this.tfMissing = permute (this.tfMissing, varargin{:});
    endfunction
    
    function this = ipermute (this, varargin)
      %IPERMUTE Inverse permute array dimensions.
      this.code = ipermute (this.code, varargin{:});
      this.tfMissing = ipermute (this.tfMissing, varargin{:});
    endfunction
    
    function this = repmat (this, varargin)
      %REPMAT Replicate and tile array.
      this.code = repmat (this.code, varargin{:});
      this.tfMissing = repmat (this.tfMissing, varargin{:});
    endfunction
    
    function this = ctranspose (this, varargin)
      %CTRANSPOSE Complex conjugate transpose.
      this.code = ctranspose (this.code, varargin{:});
      this.tfMissing = ctranspose (this.tfMissing, varargin{:});
    endfunction
      
    function this = transpose (this, varargin)
      %TRANSPOSE Transpose vector or matrix.
      this.code = transpose (this.code, varargin{:});
      this.tfMissing = transpose (this.tfMissing, varargin{:});
    endfunction
    
    function [this, nshifts] = shiftdim( this, n)
      %SHIFTDIM Shift dimensions.
      if nargin > 1
        this.code = shiftdim (this.code, n);
        this.tfMissing = shiftdim (this.code, n);
      else
        [this.code, nshifts] = shiftdim (this.code);
        [this.tfMissing, nshifts] = shiftdim (this.tfMissing);
      endif
    endfunction
    
    function out = cat (dim, varargin)
      %CAT Concatenate arrays.
      args = varargin;
      for i = 1:numel(args)
        if ~isa(args{i}, 'categorical')
          args{i} = categorical(args{i});
        end
      end
      out = varargin{1};
      for i = 2:numel (varargin)
        a = out;
        b = varargin{i};
        [a, b] = promote2 (a, b);
        out = a;
        out.code = cat(dim, a.code, b.code);
        out.tfMissing = cat(dim, a.tfMissing, b.tfMissing);
      endfor
    endfunction
      
    function out = horzcat (varargin)
      %HORZCAT Horizontal concatenation.
      out = cat (2, varargin{:});
    endfunction
    
    function out = vertcat (varargin)
      %VERTCAT Vertical concatenation.
      out = cat (1, varargin{:});
    endfunction
    
    function this = subsasgn(this, s, b)
      %SUBSASGN Subscripted assignment.
      
      % Chained subscripts
      if numel(s) > 1
        rhs_in = subsref(this, s(1));
        rhs = subsasgn(rhs_in, s(2:end), b);
      else
        rhs = b;
      endif
      
      % Base case
      switch s(1).type
        case '()'
          this = subsasgnParensPlanar(this, s(1), rhs);
        case '{}'
          % This works just like ()-assignment, and is only defined for
          % compatibility with cellcode
          this = subsasgnParensPlanar(this, s(1), rhs);
        case '.'
          error ('categorical:BadOperation', '.-assignment is not defined for categorical arrays');
      endswitch
    endfunction
      
    function varargout = subsref(this, s)
    %SUBSREF Subscripted reference.
    
      % Base case
      switch s(1).type
        case '()'
          varargout = { subsrefParensPlanar(this, s(1)) };
        case '{}'
          % This pops out char arrays
          varargout = subsrefParensPlanar (this, s(1));
        case '.'
          switch s(1).subs
            case 'code'
              varargout = { this.code };
            case 'cats'
              varargout = { this.cats };
            case 'tfMissing'
              varargout = { this.tfMissing };
            case 'isOrdinal'
              varargout = { this.isOrdinal };
            otherwise
              error ('Invalid property for .-referencing: %s', s(1).subs);
          endswitch
      endswitch
      
      % Chained reference
      if numel (s) > 1
        out = subsref (out, s(2:end));
      endif
    endfunction
  
  endmethods
    
  methods
    function varargout = promote_to_existing_categories(this, varargin)
      % Convert strings or numerics to categorical, using an existing categorical
      %
      % varargout = promote_to_existing_categories(this, varargin)
      %
      % Converts input string or numeric arrays to categorical, using the 
      % existing categories mapping in this. Strings or numeric codes which do
      % not correspond to a defined category in this are an error.
      varargout = cell (size (varargin));
      for i_arg = 1:numel(varargin)
        arg = varargin{i_arg};
        if isa (arg, 'categorical')
          error ('promote_to_existing_categories: categorical input is not supported yet.');
        elseif isstring (arg) || iscellstr (arg)
          [tfMember, loc] = ismember (arg, this.cats);
          tfBad = !tfMember & !ismissing (arg);
          if any (tfBad)
            error('input string had values that were not members of this''s categories');
          endif
          code = loc;
          code(ismissing (arg)) = 0;
          out = categorical;
          out.cats = this.cats;
          out.code = uint16(code);
          out.isOrdinal = this.isOrdinal;
          out.tfMissing = ismissing (arg);
        else
          error ('categorical: unsupported input type: %s', class (arg));
        endif
      endfor
    endfunction
  endmethods
  
  methods (Access=private)
  
    function this = subsasgnParensPlanar (this, s, rhs)
      %SUBSASGNPARENSPLANAR ()-assignment for planar object
      if ~isa (rhs, 'categorical')
        % TODO: This conversion is probably wrong. It probably needs to be done
        % with respect to this's existing cats list
        [this, rhs] = promote2 (this, rhs);
      endif
      this.code(s.subs{:}) = rhs.code;
      this.tfMissing(s.subs{:}) = rhs.tfMissing;
    endfunction
    
    function out = subsrefParensPlanar(this, s)
      %SUBSREFPARENSPLANAR ()-indexing for planar object
      out = this;
      out.code = this.code(s.subs{:});
      out.tfMissing = this.tfMissing(s.subs{:});
    endfunction
    
    function out = parensRef(this, varargin)
      %PARENSREF ()-indexing, for this class's internal use
      out = subsrefParensPlanar (this, struct ('subs', {varargin}));
    endfunction
    
    function out = subset(this, varargin)
      %SUBSET Subset array by indexes.
      % This is what you call internally inside the class instead of doing 
      % ()-indexing references on the RHS, which don't work properly inside the class
      % because they don't respect the subsref() override.
      out = parensRef (this, varargin{:});
    endfunction
        
    function out = asgn(this, ix, value)
      %ASGN Assign array elements by indexes.
      % This is what you call internally inside the class instead of doing 
      % ()-indexing references on the LHS, which don't work properly inside
      % the class because they don't respect the subsasgn() override.
      if ~iscell(ix)
        ix = { ix };
      endif
      s.type = '()';
      s.subs = ix;
      out = subsasgnParensPlanar(this, s, value);
    endfunction
    
  endmethods
  
  methods (Access = private)
    function out = codes_with_nans (this)
      out = single (this.code);
      out(this.tfMissing) = NaN;
    endfunction
    
    function out = remove_unused_cats (this, cats_to_delete)
      %REMOVE_UNUSED_CATS Removes specified categories, as long as they have no values
      [tf, cat_codes_to_rm] = ismember (cats_to_delete, this.cats);
      cat_codes_to_rm = cat_codes_to_rm(tf);
      cats_to_delete2 = cats_to_delete(tf);
      [tf_code_used, loc] = ismember (cat_codes_to_rm, this.code);
      if any (tf_code_used)
        error ('categorical: Internal error: some categories to delete are still in use: %s', ...
          strjoin (cats_to_delete2(tf_code_used), ', '));
      endif
      old_cats = this.cats;
      old_codes = 1:numel(this.cats);
      codes_with_holes = old_codes;
      codes_with_holes(cat_codes) = NaN;
      new_cats = old_cats;
      new_cats(cat_codes_to_rm) = [];
      [tf, loc] = ismember (old_cats, new_cats);
      new_codes(!this.tfMissing) = loc(this.code(!this.tfMissing));
      new_codes(this.tfMissing) = 0;
      out = this;
      out.code = uint16 (new_codes);
      out.cats = new_cats;
    endfunction
  endmethods
endclassdef
