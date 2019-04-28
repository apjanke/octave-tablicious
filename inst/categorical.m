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

classdef categorical
  %CATEGORICAL Categorical variable array
  %
  % This class is not fully implemented yet. Missing stuff:
  %   gt, ge, lt, le
  %   Ordinal support in general
  
  properties (SetAccess = private)
    % Code for each element. Codes are an index into cats.
    code = uint16(0)      % planar
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
  
  methods
    
    function this = categorical (x, varargin)
      %CATEGORICAL Construct a new categorical array
      %
      % this = categorical (vals)
      % this = categorical (vals, valueset);
      % this = categorical (vals, valueset, category_names);
      % this = categorical (..., "Ordinal", true);
      % this = categorical (..., "Protected", true);
      %
      % TODO: Empty strings and cellstrs should convert to <undefined>
      % TODO: Handle datetime and duration inputs
      % TODO: Handle logical inputs
      % TODO: Numeric conversion is probably wrong. It's trying to convert 
      % numeric inputs directly to codes. It should probably convert them to the
      % num2str representation of numbers instead, and make those all categories.
      % TODO: Support objects.
      
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
        valueset = valueset(!ismissing(valueset));
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
    
    function out = categories (this)
      %CATEGORIES Get a list of the categories in this categorical array
      %
      % Returns a cellstr column vector.
      out = this.cats(:);
    endfunction
    
    function out = iscategory (this, catnames)
      %ISCATEGORY Test for category name existence
      %
      % out = iscategory (this, catnames)
      mustBeA (this, 'categorical');
      catnames = cellstr (catnames);
      out = ismember (catnames, this.cats);
    endfunction
    
    function out = isordinal (this)
      %ISORDINAL True if this categorical array is ordinal
      out = this.isOrdinal;
    endfunction
    
    function out = string (this)
      %STRING Convert to string array
      out = cell (size (this));
      out(!this.tfMissing) = this.category_list(this.code(!this.tfMissing));
      out = string (out);
      out(this.tfMissing) = string.missing;
    endfunction
    
    function out = cellstr (this)
      %CELLSTR Convert to cellstr
      out = cell (size (this));
      out(!this.tfMissing) = this.category_list(this.code(!this.tfMissing));
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
    
    function out = dispstrs (this)
      %DISPSTRS Custom display strings
      %
      % out = dispstrs (this)
      %
      % Gets display strings for each element in this. The display strings are
      % either the category string, or '<undefined>' for undefined values.
      %
      % Returns cellstr, for compatibility with the dispstr API.
      out = cell (size (this));
      ix = this.code(!this.tfMissing);
      out(!this.tfMissing) = this.cats(ix);
      out(this.tfMissing) = {'<undefined>'};
    endfunction
    
    function summary (this)
      %SUMMARY Print a summary of the values in this categorical array
      
      Code = [1:numel(this.cats)]';
      Category = this.cats';
      category_table = table (Code, Category);
      
      fprintf ('Categorical array\n');
      fprintf ('  %d categories, %d elements\n', numel (Category), numel (this));
      fprintf ('  %d missing values\n', numel (find (this.tfMissing(:))));
      prettyprint (category_table);
      % TODO: Frequencies of each code value. Probably just roll that up into the
      % above table as an additional column.
    endfunction
    
    function out = addcats (this, newcats)
      %ADDCATS Add categories to this categorical array
      %
      % out = addcats (this, newcats)
      %
      % Adds the specified categories to this categorical array, without changing
      % any of its values.
      %
      % newcats is a cellstr.
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
    
    function out = removecats (this, oldcats)
      %REMOVECATS Remove categories from this categorical array
      %
      % out = removecats (this)
      % out = removecats (this, oldcats)
      %
      % out = removecats (this) removes all unused categories from this. This is
      % equivalent to out = squeezecats (this).
      %
      % out = removecats (this, oldcats) removes all specified categories from 
      % this. Elements of this whose values belonged to those categories are 
      % replaced with undefined.
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
    
    function out = mergecats (this, oldcats, newcat)
      %MERGECATS Merge multiple categories
      %
      % out = mergecats (this, oldcats)
      % out = mergecats (this, oldcats, newcat)
      %
      % newcat is the name of the new category to merge the input categories
      % into. It does not have to be an existing category in this (unless this
      % is ordinal.
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
    
    function out = renamecats (this, varargin)
      %RENAMECATS Rename categories
      %
      % out = renamecats (this, varargin)
      %
      % Renames existing categories in this, without changing values.
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

    function out = reordercats (this, newcats)
      %REORDERCATS Reorder categories in this' category list
      %
      % out = reordercats (this)
      % out = reordercats (this, newcats)
      %
      % newcats (cellstr) must be a reordering of this' existing category list.
      % If newcats is not supplied, sorts the categories in alphabetical order.
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
    
    function out = ismissing (this)
      %ISMISSING True for missing data
      %
      % out = ismissing (this)
      %
      % Indicates which values in this are missing.
      %
      % Returns a logical array the same size as this.
      out = this.tfMissing;
    endfunction
    
    function out = isnannish (this)
      %ISNANNISH True for NaN-like values
      %
      % Missing values are considered nanny; any other string value is not.
      %
      % Returns a logical array the same size as this.
      out = ismissing (this);
    endfunction
    
    function out = squeezecats (this)
      %SQUEEZECATS Remove categories that have no corresponding values in this
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
    
    function out = size (this)
      %SIZE Size of array.
      out = size (this.code);
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
