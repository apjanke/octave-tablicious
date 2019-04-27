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

classdef categorical
  %CATEGORICAL Categorical variable array
  %
  % This class is not fully implemented yet. Missing stuff:
  %   gt, ge, lt, le
  %   union, intersect, setdiff
  %   Ordinal support in general
  
  properties (SetAccess = private)
    % Code for each element. Codes are an index into categoryList.
    code = uint16(0)      % planar
    % Whether each element is missing/undefined
    tfMissing = true      % planar
    % The list of categoryList for this array, indexed by code
    categoryList = {}
    % Whether this array is ordinal
    isOrdinal = false
  endproperties
  
  methods
    
    function this = categorical (x, varargin)
      %CATEGORICAL Construct a new categorical array
      %
      % this = categorical (string_vals)
      % this = categorical (string_vals, category_vals);
      % this = categorical (string_vals, category_order, 'Ordinal', true);
      
      validOptions = {'Ordinal'};
      [opts, args] = peelOffNameValueOptions (varargin, validOptions);
      if ischar (x)
        x = cellstr (x);
      endif
      if isstring (x) || iscellstr (x)
        % String conversion
        if numel (varargin) > 1
          error ('categorical: too many inputs');
        endif
        doOrdinal = false;
        if isfield (opts, 'Ordinal')
          mustBeScalarLogical (opts.Ordinal, 'Ordinal option');
          doOrdinal = opts.Ordinal;
        endif
        x = string (x);
        if isempty (varargin)
          categoryList = unique (x);
          categoryList(ismissing(categoryList)) = [];
          categoryList = categoryList(:)';
        else
          categoryList = varargin{1};
          if ! (iscellstr (categoryList) || isstring (categoryList))
            error ('categorical: categories list must be string or cellstr; got %s', ...
              class (categoryList));
          endif
          categoryList = string (categoryList);
          if any (ismissing (categoryList))
            error ('categorical: cannot have missing values in categories list');
          endif
          u_categoryList = unique (categoryList);
          if numel (u_categoryList) < numel (categoryList)
            error ('categorical: cannot have duplicate values in categories list');
          endif
          if doOrdinal
            % Leave categoryList list in its provided order
          else
            categoryList = sort (categoryList);
          endif
          categoryList = categoryList(:)';
        endif
        [tf, loc] = ismember (x, categoryList);
        tfBogusLevel = (!tf) & (!ismissing (x));
        if any (tfBogusLevel)
          u_bogus = unique (x(tfBogusLevel));
          error ('categorical: got values that were not in provided categories list: %s', ...
            strjoin (u_bogus, ', '));
        endif
      elseif isa (x, 'missing')
        this.code = repmat (uint16 (0), size (x));
        this.tfMissing = true (size (x));
        this.categoryList = {};
        return;
      elseif isnumeric (x)
        if isempty (args)
          error ('categorical: category_vals must be supplied for numerics');
        endif
        categoryList = args{1};
        if ! (iscellstr (categoryList) || isstring (categoryList))
          error ('categorical: category_values must be a string or cellstr; got a %s', ...
            class (categoryList));
        endif
        categoryList = cellstr (categoryList);
        code = uint16(x);
        % Need to refine this test to allow for NaNs
        %if ! all (code(:) == x(:))
        %  error ('categorical: numeric code input did not convert cleanly to uint16');
        %endif
        if doOrdinal
          error ('categorical: Ordinal support for numeric inputs is not implemented yet. Sorry.');
        endif
        % TODO: Sort categories and map code values
        this.code = code;
        this.categoryList = categoryList(:)';
        this.tfMissing = isnan (code);
        this.isOrdinal = doOrdinal;
      else
        error ('categorical:InvalidInput', 'categorical: invalid input type: %s', ...
          class (x));
      endif
      categoryList = cellstr (categoryList);
      code = uint16 (loc);
      code(ismissing (x)) = 0;
      this.code = code;
      this.tfMissing = ismissing (x);
      this.categoryList = categoryList;
      this.isOrdinal = doOrdinal;
    endfunction
    
    function this = set.code (this, x)
      if ! isnumeric (x)
        error ('categorical.code: values must be numeric');
      endif
      code = uint16 (x);
      if !all (code(:) == x(:))
        error ('categorical.code: input did not convert cleanly to uint16');
      endif
      this.code = code;
    endfunction
    
    function out = categories (this)
      %CATEGORIES Get a list of the categories in this categorical array
      out = this.categoryList(:);
    endfunction
    
    function out = isordinal (this)
      %ISORDINAL True if this categorical is ordinal
      out = this.isOrdinal;
    endfunction
    
    function out = string (this)
      out = cell (size (this));
      out(!this.tfMissing) = this.category_list(this.code(!this.tfMissing));
      out(this.tfMissing) = string.missing;
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
      out(!this.tfMissing) = this.categoryList(ix);
      out(this.tfMissing) = {'<undefined>'};
    endfunction
    
    function summary (this)
      %SUMMARY Print a summary of the values in this categorical array
      
      Code = [1:numel(this.categoryList)]';
      Category = this.categoryList';
      category_table = table (Code, Category);
      
      fprintf ('Categorical array\n');
      fprintf ('  %d categories, %d elements\n', numel (Category), numel (this));
      fprintf ('  %d missing values\n', numel (find (this.tfMissing(:))));
      prettyprint (category_table);
      % TODO: Frequencies of each code value. Probably just roll that up into the
      % above table as an additional column.
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
    
    function [A, B] = promote2 (A, B)
      %PROMOTE2 Promote exactly 2 inputs to be comparable categoricals.
      %
      % This is an internal implementation method that will become private before
      % release 1.0.
      
      inA = A;
      inB = B;
      
      % Make them both categoricals
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
      if isequal (A.categoryList, B.categoryList)
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
      unified_categories = unique ([A.categoryList B.categoryList]);
      [tf, code_map_a] = ismember (A.categoryList, unified_categories);
      new_code_a = A.code;
      new_code_a(!A.tfMissing) = code_map_a(A.code(!A.tfMissing));
      outA = A;
      outA.code = new_code_a;
      outA.categoryList = unified_categories;
      [tf, code_map_b] = ismember (B.categoryList, unified_categories);
      new_code_b = B.code;
      new_code_b(!B.tfMissing) = code_map_b(B.code(!B.tfMissing));
      outB = B;
      outB.code = new_code_b;
      outB.categoryList = unified_categories;
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
      code_A = double (A.code);
      code_A(A.tfMissing) = NaN;
      code_B = double (B.code);
      code_B(B.tfMissing) = NaN;
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
      code = double (X.code);
      code(X.tfMissing) = NaN;
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
      code = double (this.code);
      code(this.tfMissing) = NaN;
      [out_code, indx] = sort (code, varargin{:});
      out = this;
      out.code = uint16(out_code);
      out.tfMissing = isnan (out_code);
    endfunction
    
    % TODO: union, intersect, setdiff
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
            case 'categoryList'
              varargout = { this.categoryList };
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
        elseif isstring (arg)
          [tfMember, loc] = ismember (arg, this.categoryList);
          tfBad = !tfMember & !ismissing (arg);
          if any (tfBad)
            error('input string had values that were not members of this''s categories');
          endif
          code = loc;
          code(ismissing (arg)) = 0;
          out = categorical;
          out.categoryList = this.categoryList;
          out.code = uint16(code);
          out.isOrdinal = this.isOrdinal;
          out.tfMissing = ismissing (arg);
        elseif iscellstr (arg)
          
        endif
      endfor
    endfunction
  endmethods
  
  methods (Access=private)
  
    function this = subsasgnParensPlanar (this, s, rhs)
      %SUBSASGNPARENSPLANAR ()-assignment for planar object
      if ~isa (rhs, 'categorical')
        % TODO: This conversion is probably wrong. It probably needs to be done
        % with respect to this's existing categoryList list
        rhs = categorical (rhs);
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
  
endclassdef
