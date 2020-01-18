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
## @deftp {Class} table
##
## Tabular data array containing multiple columnar variables.
##
## A @code{table} is a tabular data structure that collects multiple parallel 
## named variables.
## Each variable is treated like a column. (Possibly a multi-columned column, if
## that makes sense.)
## The types of variables may be heterogeneous.
##
## A table object is like an SQL table or resultset, or a relation, or a 
## DataFrame in R or Pandas.
##
## A table is an array in itself: its size is @var{nrows}-by-@var{nvariables},
## and you can index along the rows and variables by indexing into the table
## along dimensions 1 and 2.
##
## A note on accessing properties of a @code{table} array: Because .-indexing is
## used to access the variables inside the array, it can’t also be directly used
## to access properties as well. Instead, do @code{t.Properties.<property>} for
## a table @code{t}. That will give you a property instead of a variable.
## (And due to this mechanism, it will cause problems if you have a @code{table}
## with a variable named @code{Properties}. Try to avoid that.)
##
## @end deftp
##
## @deftypeivar table @code{cellstr} VariableNames
##
## The names of the variables in the table, as a cellstr row vector.
##
## @end deftypeivar
##
## @deftypeivar table @code{cell} VariableValues
##
## A cell vector containing the values for each of the variables.
## @code{VariableValues(i)} corresponds to @code{VariableNames(i)}.
##
## @end deftypeivar
##
## @deftypeivar table @code{cellstr} RowNames
##
## An optional list of row names that identify each row in the table. This
## is a cellstr column vector, if present.
##
## @end deftypeivar

% Developer's notes:
% - Wherever you see the abbreviation "pk" here, that means "proxy keys", not
%   "primary keys".

classdef table

  properties
    % The names of the variables (columns), as cellstr
    VariableNames = {}
    % The values of the variables, as a cell vector of arbitrary types
    VariableValues = {}
    % Optional row names, as cellstr
    RowNames = []
    % Dimension names
    DimensionNames = { "Row" "Variables" }
  end
  
  methods
    ## -*- texinfo -*-
    ## @node table.table
    ## @deftypefn {Constructor} {@var{obj} =} table ()
    ##
    ## Constructs a new empty (0 rows by 0 variables) table.
    ##
    ## @end deftypefn
    ##
    ## @deftypefn {Constructor} {@var{obj} =} table (@var{var1}, @var{var2}, @dots{}, @var{varN})
    ##
    ## Constructs a new table from the given variables. The variables passed as
    ## inputs to this constructor become the variables of the table. Their names
    ## are automatically detected from the input variable names that you used.
    ##
    ## @end deftypefn
    ##
    ## @deftypefn {Constructor} {@var{obj} =} table (@code{'Size'}, @var{sz}, @
    ##   @code{'VariableTypes'}, @var{varTypes})
    ##
    ## Constructs a new table of the given size, and with the given variable types.
    ## The variables will contain the default value for elements of that type.
    ##
    ## @end deftypefn
    ##
    ## @deftypefn {Constructor} {@var{obj} =} table (@dots{}, @code{'VariableNames'}, @var{varNames})
    ## @deftypefnx {Constructor} {@var{obj} =} table (@dots{}, @code{'RowNames'}, @var{rowNames})
    ##
    ## Specifies the variable names or row names to use in the constructed table.
    ## Overrides the implicit names garnered from the input variable names.
    ##
    ## @end deftypefn
    function this = table (varargin)
      
      % Peel off trailing options
      [opts, args] = peelOffNameValueOptions (varargin, {'VariableNames', 'RowNames'});
      
      % Calling form handling
      nargs = numel (args);
      if nargs == 3 && isequal (args{1}, 'Backdoor')
        % Undocumented form for internal use
        [varNames, varVals] = args{2:3};
      elseif nargs == 4 && isequal (args{1}, 'Size') && isequal (args{3}, 'VariableTypes')
        error('table: This constructor form is unimplemented');
      else
        varVals = args;
        if isfield (opts, 'VariableNames')
          varNames = opts.VariableNames;
        else
          varNames = cell (size (args));
          for i = 1:numel (args)
            varNames{i} = inputname (i);
            if isempty (varNames{i})
              varNames{i} = sprintf('Var%d', i);
            end
          end
        end
      end
      
      % Input validation
      if ~iscell (varVals) || (~isvector (varVals) && ~isempty (varVals))
        error('table: VariableValues must be a cell vector');
      end
      if ~iscellstr (varNames) || (~isvector (varNames) && ~isempty (varNames))
        error('table: VariableNames must be a cellstr vector');
      end
      varNames = varNames(:)';
      varVals = varVals(:)';
      if numel (varNames) ~= numel (varVals)
        error ('table: Inconsistent number of VariableNames (%d) and VariableValues (%d)', ...
         numel (varNames), numel (varVals));
      end
      for i = 1:numel (varNames)
        if ~isvarname (varNames{i})
          error ('table: Invalid VariableName: ''%s''', varNames{i});
        end
      end
      if ~isempty (varVals)
        nrows = size (varVals{1}, 1);
        for i = 2:numel (varVals)
          if ndims (varVals{i}) > 2
            error (['table: Variable values may not have > 2 dimensions; ' ...
              'input %d (%s) has %d'], i, varNames{i}, ndims (varVals{i}));
          endif
          nrows2 = size (varVals{i}, 1);
          if nrows ~= nrows2
            error ('table: Inconsistent sizes: var 1 (%s) is %d rows; var %d (%s) is %d rows', ...
              varNames{1}, nrows, i, varNames{i}, nrows2);
          end
        end
      end
      [uqNames, ix] = unique (varNames);
      if numel (uqNames) < numel (varNames)
        ixBad = 1:numel (varNames);
        ixBad(ix) = [];
        error ('table: Duplicate VariableNames: %s', strjoin (varNames(ixBad), ', '));
      end

      % Construction
      this.VariableNames = varNames;
      this.VariableValues = varVals;
      if isfield (opts, 'RowNames')
        this.RowNames = opts.RowNames;
      end
    end
    
    % Display
    
    function display (this)
      %DISPLAY Custom display.
      in_name = inputname (1);
      if ~isempty (in_name)
        fprintf ('%s =\n', in_name);
      end
      disp (this);
    end

    function disp (this)
      %DISP Custom display.
      if isempty (this)
        fprintf ('Empty %s %s\n', size2str (size (this)), class (this));
      else
        fprintf ('table: %d rows x %d variables\n', height (this), width (this));
        fprintf ('  VariableNames: %s\n', strjoin (this.VariableNames, ', '));
        if hasrownames (this)
          fprintf ('  Has RowNames\n');
        endif
      end
    end

    ## -*- texinfo -*-
    ## @node table.summary
    ## @deftypefn {Method} summary (@var{obj})
    ##
    ## Summary of table's data.
    ##
    ## Displays a summary of data in the input table. This will contain some
    ## statistical information on each of its variables.
    ##
    ## @end deftypefn
    function out = summary (this)
      summary_impl (this);
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.prettyprint
    ## @deftypefn {Method} {} prettyprint (@var{obj})
    ##
    ## Display table's values in tabular format. This prints the contents
    ## of the table in human-readable, tabular form.
    ##
    ## Variables which contain objects are displayed using the strings
    ## returned by their @code{dispstrs} method, if they define one.
    ##
    ## @end deftypefn
    function prettyprint (this)
      %PRETTYPRINT Display table values, formatted as a table
      if isempty (this)
        fprintf ('Empty %s %s\n', size2str (size (this)), class (this));
        return;
      end
      nVars = width (this);
      varNames = this.VariableNames;
      % Here, "cols" means output columns, not data columns. Each data variable
      % will be displayed in a single output column.
      %FIXME: This display logic might be broken for multi-column variables.
      colNames = varNames;
      
      nCols = nVars;
      colNames = varNames;
      colStrs = cell (1, nVars);
      for iVar = 1:numel (this.VariableValues)
        vals = this.VariableValues{iVar};
        strs = tablevar_dispstrs (vals);
        lines = cell (height(this), 1);
        for iRow = 1:size (strs, 1)
          lines{iRow} = strjoin (strs(iRow,:), '   ');
        endfor
        colStrs{iVar} = lines;
      endfor
      if hasrownames (this)
        colStrs = [{this.RowNames(:)} colStrs];
        colNames = [{'RowName'} colNames];
        nCols++;
      endif

      colWidths = NaN (1, nCols);
      for iCol = 1:nCols
        colWidths(iCol) = max (cellfun ('numel', colStrs{iCol}));
      endfor
      nameWidths = cellfun ('numel', colNames);
      colWidths = max ([nameWidths; colWidths]);
      totalWidth = sum (colWidths) + 4 + (3 * (nCols - 1));
      elementStrs = cat (2, colStrs{:});
      
      rowFmts = cell (1, nCols);
      for i = 1:nCols
        rowFmts{i} = ['%-' num2str(colWidths(i)) 's'];
      end
      rowFmt = ['| ' strjoin(rowFmts, ' | ')  ' |' sprintf('\n')];
      fprintf ('%s\n', repmat ('-', [1 totalWidth]));
      fprintf (rowFmt, colNames{:});
      fprintf ('%s\n', repmat ('-', [1 totalWidth]));
      for i = 1:height (this)
        fprintf (rowFmt, elementStrs{i,:});
      end
      fprintf ('%s\n', repmat ('-', [1 totalWidth]));
    end
    
    % Type conversion
    
    ## -*- texinfo -*-
    ## @node table.table2cell
    ## @deftypefn {Method} {@var{c} =} table2cell (@var{obj})
    ##
    ## Converts table to a cell array. Each variable in @var{obj} becomes
    ## one or more columns in the output, depending on how many columns
    ## that variable has.
    ##
    ## Returns a cell array with the same number of rows as @var{obj}, and
    ## with as many or more columns as @var{obj} has variables.
    ##
    ## @end deftypefn
    function out = table2cell (this)
      out = cell (size (this));
      for i = 1:width (this)
        varVal = this.VariableValues{i};
        if iscell (varVal)
          if size (varVal, 2) == 1
            out(:,i) = varVal;
          else
            out(:,i) = mat2cell (varVal, ones (1, size (varVal, 2)));
          endif
        else
          out(:,i) = num2cell (varVal, 2);
        endif
      endfor
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.table2struct
    ## @deftypefn {Method} {@var{s} =} table2struct (@var{obj})
    ## @deftypefnx {Method} {@var{s} =} table2struct (@dots{}, @code{'ToScalar'}, @var{trueOrFalse})
    ##
    ## Converts @var{obj} to a scalar structure or structure array.
    ##
    ## Row names are not included in the output struct. To include them, you
    ## must add them manually:
    ##   s = table2struct (tbl, 'ToScalar', true);
    ##   s.RowNames = tbl.Properties.RowNames;
    ##
    ## Returns a scalar struct or struct array, depending on the value of the
    ## @code{ToScalar} option.
    ##
    ## @end deftypefn
    function out = table2struct (this, varargin)
      [opts, args] = peelOffNameValueOptions (varargin, {'ToScalar'});
      toScalar = false;
      if isfield (opts, 'ToScalar')
        mustBeA (opts.ToScalar, 'logical');
        mustBeScalar (opts.ToScalar);
        toScalar = opts.ToScalar;
      endif
      
      if toScalar
        out = struct;
        for i = 1:width (this)
          out.(this.VariableNames{i}) = this.VariableValues{i};
        endfor
      else
        %TODO: Figure out how to implement this efficiently using cell2struct
        s0 = struct;
        for i = 1:width (this)
          s0.(this.VariableNames{i}) = [];
        endfor
        out = repmat (s0, [height(this) 1]);
        for iVar = 1:width (this)
          varVal = this.VariableValues{iVar};
          for iRow = 1:height (this)
            if iscell (varVal) && size (varVal, 2) == 1
              elVal = varVal{iRow};
            else
              elVal = varVal(iRow,:);
            endif
            out(iRow).(this.VariableNames{iVar}) = elVal;
          endfor
        endfor
      endif
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.table2array
    ## @deftypefn {Method} {@var{s} =} table2struct (@var{obj})
    ##
    ## Converts @var{obj} to a homogeneous array.
    ##
    ## @end deftypefn
    function out = table2array (this)
      %TABLE2ARRAY Convert table to homogeneous array
      if isempty (this)
        out = [];
        return
      endif
      % Wow, this is an easy implementation
      % TODO: Doesn't work for mixed cell and non-cell variable values, because of the
      % implicit conversion of numerics to single cells. Dunno if we want to add
      % more graceful support for that or not.
      out = cat (2, this.VariableValues{:});
    endfunction

    % Structural stuff
    
    ## -*- texinfo -*-
    ## @node table.varnames
    ## @deftypefn {Method} {@var{out} =} varnames (@var{obj})
    ## @deftypefnx {Method} {@var{out} =} varnames (@var{obj}, @var{varNames})
    ##
    ## Get or set variable names for a table.
    ##
    ## Returns cellstr in the getter form. Returns an updated datetime in the
    ## setter form.
    ##
    ## @end deftypefn
    function out = varnames (this, newVarNames)
      if nargin == 1
        out = this.VariableNames;
      else
        out = this;
        out.VariableNames = newVarNames;
      endif  
    endfunction

    ## -*- texinfo -*-
    ## @node table.istable
    ## @deftypefn {Method} {@var{tf} =} istable (@var{obj})
    ##
    ## True if input is a table.
    ##
    ## @end deftypefn
    function out = istable (this)
      %ISTABLE True if input is a table
      out = true;
    endfunction

    ## -*- texinfo -*-
    ## @node table.size
    ## @deftypefn {Method} {@var{sz} =} size (@var{obj})
    ##
    ## Gets the size of a table.
    ##
    ## For tables, the size is [number-of-rows x number-of-variables].
    ## This is the same as @code{[height(obj), width(obj)]}.
    ##
    ## @end deftypefn
    function out = size (this, dim)
      if nargin == 1
        out = [height(this), width(this)];
      else
        sz = size (this);
        out = sz(dim);
      end
    end
    
    ## -*- texinfo -*-
    ## @node table.length
    ## @deftypefn {Method} {@var{out} =} length (@var{obj})
    ##
    ## Length along longest dimension
    ##
    ## Use of @code{length} is not recommended. Use @code{numel}
    ## or @code{size} instead.
    ##
    ## @end deftypefn
    function out = length (this, varargin)
      out = max (size (this));
    end

    ## -*- texinfo -*-
    ## @node table.ndims
    ## @deftypefn {Method} {@var{out} =} ndims (@var{obj})
    ##
    ## Number of dimensions
    ##
    ## For tables, @code{ndims(obj)} is always 2.
    ##
    ## @end deftypefn
    function out = ndims (this)
      %NDIMS Number of dimensions
      %
      % For tables, ndims is always 2.
      out = 2;
    end
    
    ## -*- texinfo -*-
    ## @node table.squeeze
    ## @deftypefn {Method} {@var{obj} =} squeeze (@var{obj})
    ##
    ## Remove singleton dimensions.
    ##
    ## For tables, this is always a no-op that returns the input 
    ## unmodified, because tables always have exactly 2 dimensions.
    ##
    ## @end deftypefn
    function out = squeeze (this)
      %SQUEEZE Remove singleton dimensions from this.
      %
      % This is always a no-op that returns the input unmodified, because tables
      % always have exactly 2 dimensions.
      out = this;
    endfunction
    
    function out = size_equal
      %SIZE_EQUAL True if the dimensions of all arguments agree.
      error ('table.size_equal: size_equal is not yet implemented for tables');
    endfunction
  
    ## -*- texinfo -*-
    ## @node table.sizeof
    ## @deftypefn {Method} {@var{out} =} sizeof (@var{obj})
    ##
    ## Approximate size of array in bytes. For tables, this returns the sume
    ## of @code{sizeof} for all of its variables’ arrays, plus the size of the 
    ## VariableNames and any other metadata stored in @var{obj}.
    ##
    ## This is currently unimplemented.
    ##
    ## @end deftypefn
    function out = sizeof (this)
      total_size = 0;
      total_size += sizeof(this.VariableNames);
      for i = 1:width(this)
        total_size += sizeof(this.VariableValues{i});
      endfor
      total_size += sizeof(this.RowNames);
      out = total_size;
    endfunction

    ## -*- texinfo -*-
    ## @node table.height
    ## @deftypefn {Method} {@var{out} =} height (@var{obj})
    ##
    ## Number of rows in table.
    ##
    ## @end deftypefn
    function out = height (this)
      %HEIGHT Number of rows in table
      if isempty (this.VariableValues)
        out = 0;
      else
        out = size (this.VariableValues{1}, 1);
      end
    end
    
    ## -*- texinfo -*-
    ## @node table.rows
    ## @deftypefn {Method} {@var{out} =} rows (@var{obj})
    ##
    ## Number of rows in table.
    ##
    ## @end deftypefn
    function out = rows (this)
      %ROWS Number of rows in table
      out = height (this);
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.width
    ## @deftypefn {Method} {@var{out} =} width (@var{obj})
    ##
    ## Number of variables in table.
    ##
    ## Note that this is not the sum of the number of columns in each variable.
    ## It is just the number of variables.
    ##
    ## @end deftypefn
    function out = width (this)
      %WIDTH Number of variables in table
      %
      % Note that this is not the sum of the number of columns in each variable.
      % It is just the number of variables.
      out = numel (this.VariableNames);
    end
    
    ## -*- texinfo -*-
    ## @node table.columns
    ## @deftypefn {Method} {@var{out} =} columns (@var{obj})
    ##
    ## Number of variables in table.
    ##
    ## Note that this is not the sum of the number of columns in each variable.
    ## It is just the number of variables.
    ##
    ## @end deftypefn
    function out = columns (this)
      %COLUMNS Number of columns (variables) in table
      %
      % Note that this is not the sum of the number of columns in each variable.
      % It is just the number of variables.      
      out = width (this);
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.numel
    ## @deftypefn {Method} {@var{out} =} numel (@var{obj})
    ##
    ## Total number of elements in table.
    ##
    ## This is the total number of elements in this table. This is calculated
    ## as the sum of numel for each variable.
    ##
    ## NOTE: Those semantics may be wrong. This may actually need to be defined
    ## as @code{height(obj) * width(obj)}. The behavior of @code{numel} may
    ## change in the future.
    ##
    ## @end deftypefn
    function out = numel (this)
      n = 0;
      for i = 1:numel (this.VariableValues)
        n = n + numel (this.VariableValues{i});
      end
      out = n;
    end
    
    ## -*- texinfo -*-
    ## @node table.isempty
    ## @deftypefn {Method} {@var{out} =} isempty (@var{obj})
    ##
    ## Test whether array is empty.
    ##
    ## For tables, @code{isempty} is true if the number of rows is 0 or the number
    ## of variables is 0.
    ##
    ## @end deftypefn
    function out = isempty (this)
      out = isempty (this.VariableNames);
    end
    
    ## -*- texinfo -*-
    ## @node table.ismatrix
    ## @deftypefn {Method} {@var{out} =} ismatrix (@var{obj})
    ##
    ## Test whether array is a matrix.
    ##
    ## For tables, @code{ismatrix} is always true, by definition.
    ##
    ## @end deftypefn
    function out = ismatrix (this)
      %ISMATRIX True if input is a matrix
      %
      % For tables, ismatrix() is always true, by definition.
      out = true;
    end
    
    ## -*- texinfo -*-
    ## @node table.isrow
    ## @deftypefn {Method} {@var{out} =} isrow (@var{obj})
    ##
    ## Test whether array is a row vector.
    ##
    ## @end deftypefn
    function out = isrow (this)
      %ISROW True if input is a row vector
      out = height (this) == 1;
    end
    
    ## -*- texinfo -*-
    ## @node table.iscol
    ## @deftypefn {Method} {@var{out} =} iscol (@var{obj})
    ##
    ## Test whether array is a column vector.
    ##
    ## For tables, @code{iscol} is true if the input has a single variable.
    ## The number of columns within that variable does not matter.
    ##
    ## @end deftypefn
    function out = iscol (this)
      out = width (this) == 1;
    end
    
    ## -*- texinfo -*-
    ## @node table.isvector
    ## @deftypefn {Method} {@var{out} =} isvector (@var{obj})
    ##
    ## Test whether array is a vector.
    ##
    ## @end deftypefn
    function out = isvector (this)
      %ISVECTOR True if input is a vector
      out = isrow (this) || iscol (this);
    end
    
    ## -*- texinfo -*-
    ## @node table.isscalar
    ## @deftypefn {Method} {@var{out} =} isscalar (@var{obj})
    ##
    ## Test whether array is scalar.
    ##
    ## @end deftypefn
    function out = isscalar (this)
      %ISSCALAR True if input is a scalar
      out = height (this) == 1 && width (this) == 1;
    end
    
    ## -*- texinfo -*-
    ## @node table.hasrownames
    ## @deftypefn {Method} {@var{out} =} hasrownames (@var{obj})
    ##
    ## True if this table has row names defined.
    ##
    ## @end deftypefn
    function out = hasrownames (this)
      %HASROWNAMES True if this table has row names defined
      out = ~isempty (this.RowNames);
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.vertcat
    ## @deftypefn {Method} {@var{out} =} vertcat (@var{varargin})
    ##
    ## Vertical concatenation.
    ##
    ## Combines tables by vertically concatenating them.
    ##
    ## Inputs that are not tables are automatically converted to tables by calling
    ## table() on them.
    ##
    ## The inputs must have the same number and names of variables, and their
    ## variable value types and sizes must be cat-compatible.
    ##
    ## @end deftypefn
    function out = vertcat (varargin)
      args = varargin;
      for i = 1:numel (args)
        if ~istable (args{i})
          args{i} = table (args{i});
        end
      end
      mustBeAllSameVars (args{:});
      out = args{1};
      for i = 2:numel (args)
        if isempty (out.RowNames)
          if ~isempty (args{i}.RowNames)
            error ('table.vertcat: Cannot cat tables with mixed empty and non-empty RowNames');
          end
        else
          out.RowNames = [out.RowNames; args{i}.RowNames];
        end
        for iVar = 1:width (out)
          out.VariableValues{iVar} = [out.VariableValues{iVar}; args{i}.VariableValues{iVar}];
        end
      end
    end
    
    ## -*- texinfo -*-
    ## @node table.horzcat
    ## @deftypefn {Method} {@var{out} =} horzcat (@var{varargin})
    ##
    ## Horizontal concatenation.
    ## 
    ## Combines tables by horizontally concatenating them.
    ## Inputs that are not tables are automatically converted to tables by calling
    ## table() on them.
    ## Inputs must have all distinct variable names.
    ##
    ## Output has the same RowNames as @code{varargin@{1@}}. The variable names and values
    ## are the result of the concatenation of the variable names and values lists
    ## from the inputs.
    ##
    ## @end deftypefn
    function out = horzcat (varargin)
      args = varargin;
      seen_names = args{1}.VariableNames;
      for i = 2:numel (args)
        dup_names = intersect (seen_names, args{i}.VariableNames);
        if ~isempty (dup_names)
          error ('table.horzcat: Inputs have duplicate VariableNames: %s', strjoin (dup_names, ', '));
        end
        seen_names = [seen_names args{i}.VariableNames];
      end
      % Okay, all var names are distinct. We can just concatenate.
      varNameses = cell (size (args));
      varValses = cell (size (args));
      for i = 1:numel (args)
        varNameses{i} = args{i}.VariableNames;
        varValses{i} = args{i}.VariableValues;
      endfor
      out = varargin{1};
      out.VariableNames = cat (2, varNameses{:});
      out.VariableValues = cat (2, varValses{:});
    end
    
    ## -*- texinfo -*-
    ## @node table.repmat
    ## @deftypefn {Method} {@var{out} =} repmat (@var{obj}, @var{sz})
    ##
    ## Replicate matrix.
    ##
    ## Repmats a table by repmatting each of its variables vertically.
    ##
    ## For tables, repmatting is only supported along dimension 1. That is, the
    ## values of sz(2:end) must all be exactly 1.
    ##
    ## Returns a new table with the same variable names and types as tbl, but
    ## with a possibly different row count.
    ##
    ## @end deftypefn
    function out = repmat (this, sz)
      mustBeA (this, 'table');
      mustBeNumeric (sz);
      if any (sz(2:end) != 1)
        error ('table.repmat: all size elements for dim 2 and higher must be 1');
      endif
      out = this;
      for i = 1:numel (this.VariableValues)
        out.VariableValues{i} = repmat (this.VariableValues{i}, sz);
      endfor
      if ! isempty (this.RowNames)
        out.RowNames = repmat (this.RowNames, sz);
      endif
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.repelem
    ## @deftypefn {Method} {@var{out} =} repelem (@var{obj}, @var{R})
    ## @deftypefnx {Method} {@var{out} =} repelem (@var{obj}, @var{R_1}, @var{R_2})
    ##
    ## Replicate elements of matrix.
    ##
    ## Replicates elements of this table matrix by applying repelem to each of
    ## its variables.
    ##
    ## Only two dimensions are supported for @code{repelem} on tables.
    ##
    ## @end deftypefn
    function out = repelem(this, varargin);
      args = varargin;
      if numel (args) > 2
        error ("table.repelem: Only 2 dimensions are supported for repelem on tables");
      endif
      out = this;
      for i = 1:width (this)
        out.VariableValues{i} = repelem (this.VariableValues{i}, args{:});
      endfor
    endfunction
  
    function out = subsref (this, s)
      %SUBSREF Subscripted reference
      %
      % tbl.VarName
      % tbl.VarName(ix)
      % tbl.(VarName)
      % tbl(ixRows, ixVars)
      % tbl{ixRow, ixVar}
      % tbl{ixRow, ixVar}(ix)
      %
      % Table supports various forms of indexing that allow you to subset the
      % table or get at the variable values within the table.
      chain_s = s(2:end);
      s = s(1);
      switch s(1).type
        case '()'
          if numel (s.subs) ~= 2
            error ('table.subsref: ()-indexing of table requires exactly two arguments');
          end
          [ixRow, ixVar] = resolveRowVarRefs (this, s.subs{1}, s.subs{2});
          out = this;
          out = subsetrows (out, ixRow);
          out = subsetvars (out, ixVar);
        case '{}'
          if numel (s.subs) ~= 2
            error ('table.subsref: {}-indexing of table requires exactly two arguments');
          end
          [ixRow, ixVar] = resolveRowVarRefs (this, s.subs{1}, s.subs{2});
          if numel (ixRow) ~= 1 && numel (ixVar) ~= 1
            error('table.subsref: {}-indexing of table requires one of the inputs to be scalar');
          end
          %FIXME: I'm not sure how to handle the signature here yet
          if numel (ixVar) > 1
            error ('table.subsref: {}-indexing across multiple variables is currently unimplemented');
          end
          if numel (ixRow) > 1
            error ('table.subsref: {}-indexing across multiple rows is currently unimplemented');
          end
          varData = this.VariableValues{ixVar};
          out = varData(ixRow);
        case '.'
          name = s.subs;
          if ~ischar (name)
            error ('table.subsref: .-reference arguments must be char');
          end
          % Special cases for special properties and other attribute access
          % TODO: should variable names or dimension names take precedence?
          if isequal (name, 'Properties')
            out = getProperties (this);
          elseif isequal (name, this.DimensionNames{1})
            out = this.RowNames;
          elseif isequal (name, this.DimensionNames{2})
            out = this.VariableNames;
          else
            out = getvar (this, name);
          endif
      end
      % Chained references
      if ~isempty (chain_s)
        out = subsref (out, chain_s);
      end
    end
    
    function out = subsasgn (this, s, val)
      %SUBSASGN Subscripted assignment

      % Chained subscripts
      chain_s = s(2:end);
      s = s(1);
      if ~isempty (chain_s)
          rhs_in = subsref (this, s);
          rhs = subsasgn (rhs_in, chain_s, val);
      else
          rhs = val;
      end

      out = this;
      switch s(1).type
        case '()'
          error ('table.subsasgn: Assignment using ()-indexing is not supported for table');
        case '{}'
          if numel (s.subs) ~= 2
            error ('table.subsasgn: {}-indexing of table requires exactly two arguments');
          end
          [ixRow, ixVar] = resolveRowVarRefs (this, s.subs{1}, s.subs{2});
          if ~isscalar (ixVar)
            error ('table.subsasgn: {}-indexing must reference a single variable; got %d', ...
              numel (ixVar));
          end
          varData = this.VariableValues{ixVar};
          varData(ixRow) = rhs;
          out.VariableValues{ixVar} = varData;
        case '.'
          if ~ischar (s.subs)
            error ('table.subsasgn: .-index argument must be char; got a %s', ...
              class (s.subs));
          endif
          if isequal (s.subs, 'Properties')
            % Special case for this.Properties access
            error ('table.subsasgn: .Properties access is not implemented yet');
          else
            out = setvar (this, s.subs, rhs);            
          endif
      end
    end
    
    ## -*- texinfo -*-
    ## @node table.setVariableNames
    ## @deftypefn {Method} {@var{out} =} setVariableNames (@var{obj}, @var{names})
    ## @deftypefnx {Method} {@var{out} =} setVariableNames (@var{obj}, @var{ix}, @var{names})
    ##
    ## Set variable names.
    ##
    ## Sets the @code{VariableNames} for this table to a new list of names.
    ##
    ## @var{names} is a char or cellstr vector. It must have the same number of elements
    ## as the number of variable names being assigned.
    ##
    ## @var{ix} is an index vector indicating which variable names to set. If 
    ## omitted, it sets all of them present in @var{obj}.
    ##
    ## This method exists because the @code{obj.Properties.VariableNames = @dots{}}
    ## assignment form does not work, possibly due to an Octave bug.
    ##
    ## @end deftypefn
    function this = setVariableNames (this, varargin)
      %SETVARIABLENAMES Set VariableNames
      narginchk (2, 3);
      if nargin == 2
        ix = [];
        names = varargin{1};
      else
        [ix, names] = varargin{:};
      endif
      if ischar (names)
        names = cellstr (names);
      endif
      mustBeCellstr (names);
      if ~all (cellfun (@isvarname, names))
        error ('table: VariableNames must be valid variable names');
      endif
      if isempty (ix)
        n_assigned = width (this);
      else
        n_assigned = numel (ix);
      endif
      if numel (names) != n_assigned
        error ('table: Dimension mismatch: assigning to %d variable names but new VariableNames is %d-long', ...
          n_assigned, numel (names));
      endif
      if isempty (ix)
        this.VariableNames = names;
      else
        if any (ix > width (this))
          error ('table: index out of range during variable name assignment: %d (vs. %d variables in this)', ...
            max (ix), width (this));
        endif
        this.VariableNames(ix) = names;
      endif
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.setDimensionNames
    ## @deftypefn {Method} {@var{out} =} setDimensionNames (@var{obj}, @var{names})
    ## @deftypefnx {Method} {@var{out} =} setDimensionNames (@var{obj}, @var{ix}, @var{names})
    ##
    ## Set dimension names.
    ##
    ## Sets the @code{DimensionNames} for this table to a new list of names.
    ##
    ## @var{names} is a char or cellstr vector. It must have the same number of elements
    ## as the number of dimension names being assigned.
    ##
    ## @var{ix} is an index vector indicating which dimension names to set. If 
    ## omitted, it sets all two of them. Since there are always two dimension,
    ## the indexes in @var{ix} may never be higher than 2.
    ##
    ## This method exists because the @code{obj.Properties.DimensionNames = @dots{}}
    ## assignment form does not work, possibly due to an Octave bug.
    ##
    ## @end deftypefn
    function this = setDimensionNames (this, varargin)
      narginchk (2, 3);
      if nargin == 2
        ix = [];
        names = varargin{1};
      else
        [ix, names] = varargin{:};
      endif
      if ischar (names)
        names = cellstr (names);
      endif
      mustBeCellstr (names);
      if ~all (cellfun (@isvarname, names))
        error ('table.setDimensionNames: DimensionNames must be valid variable names');
      endif
      if isempty (ix)
        n_assigned = 2;
      else
        n_assigned = numel (ix);
      endif
      if numel (names) != n_assigned
        error ('table.setDimensionNames: Dimension mismatch: assigning to %d dimension names but new DimensionNames is %d-long', ...
          n_assigned, numel (names));
      endif
      if isempty (ix)
        this.DimensionNames = names;
      else
        if any (ix > 2)
          error ('table.setDimensionNames: index out of range: %d (max is %d)', ...
            max (ix), 2);
        endif
        this.DimensionNames(ix) = names;
      endif
    endfunction


    ## -*- texinfo -*-
    ## @node table.setRowNames
    ## @deftypefn {Method} {@var{out} =} setRowNames (@var{obj}, @var{names})
    ##
    ## Set row names.
    ##
    ## Sets the row names on @var{obj} to @var{names}.
    ##
    ## @var{names} is a cellstr column vector, with the same number of rows as
    ## @var{obj} has.
    ##
    ## @end deftypefn
    function this = setRowNames (this, names)
      %SETROWNAMES Set RowNames
      if isempty (names)
        this.RowNames = [];
        return;
      endif
      if ~iscellstr (names)
        error ('table: RowNames must be cellstr; got a %s', class (names));
      endif
      if ~isequal (size (names), [height(this), 1])
        error ('table: Dimension mismatch: table has %d rows but new RowNames is %s', ...
          height (this), size2str (size (names)));
      endif
      this.RowNames = names;
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.removevars
    ## @deftypefn {Method} {@var{out} =} removevars (@var{obj}, @var{vars})
    ##
    ## Remove variables from table.
    ##
    ## Deletes the variables specified by @var{vars} from @var{obj}.
    ##
    ## @var{vars} may be a char, cellstr, numeric index vector, or logical
    ## index vector.
    ##
    ## @end deftypefn
    function out = removevars (this, vars)
      ixVar = resolveVarRef (this, vars);
      out = this;
      out.VariableNames(ixVar) = [];
      out.VariableValues(ixVar) = [];
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.movevars
    ## @deftypefn {Method} {@var{out} =} movevars (@var{obj}, @var{vars}, @var{relLocation}, @var{location})
    ##
    ## Move around variables in a table.
    ##
    ## @var{vars} is a list of variables to move, specified by name or index.
    ##
    ## @var{relLocation} is @code{'Before'} or @code{'After'}.
    ##
    ## @var{location} indicates a single variable to use as the target location, 
    ## specified by name or index. If it is specified by index, it is the index
    ## into the list of *unmoved* variables from @var{obj}, not the original full
    ## list of variables in @var{obj}.
    ##
    ## Returns a table with the same variables as @var{obj}, but in a different order.
    ##
    ## @end deftypefn
    function out = movevars (this, vars, relLocation, location)
      if ~ischar (relLocation)
        error ('table.movevars: relLocation must be char; got %s', class (relLocation));
      endif
      if ~ismember (relLocation, {'Before', 'After'})
        error ('table.movevars: relLocation must be ''Before'' or ''After''; got ''%s''', ...
          relLocation);
      endif
      ixVar = resolveVarRef (this, vars);
      ixOtherVars = 1:width (this);
      ixOtherVars(ixVar) = [];
      tmp = subsetvars (this, ixOtherVars);
      moved = subsetvars (this, ixVar);
      ixLoc = resolveVarRef (tmp, location);
      if ~isscalar (ixLoc)
        error ('table.movevars: location must specify a single existing variable');
      endif
      if isequal(relLocation, 'Before')
        insertionIx = ixLoc;
      else
        insertionIx = ixLoc = 1;
      endif
      left = subsetvars (tmp, 1:insertionIx-1);
      right = subsetvars (tmp, insertionIx:width (tmp));
      out = [left moved right];
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.getvar
    ## @deftypefn {Method} {[@var{out}, @var{name}]} = getvar (@var{obj}, @var{varRef})
    ##
    ## Get value and name for single table variable.
    ##
    ## @var{varRef} is a variable reference. It may be a name or an index. It
    ## may only specify a single table variable.
    ##
    ## Returns:
    ##   @var{out} – the value of the referenced table variable
    ##   @var{name} – the name of the referenced table variable
    ##
    ## @end deftypefn
    function [out, name] = getvar (this, var_ref)
      [ix_var, var_names] = resolveVarRef (this, var_ref);
      if ! isscalar (ix_var)
        error ('table.getvar: getvar only accepts a single variable reference; got %d', ...
          numel (ix_var));
      endif
      out = this.VariableValues{ix_var};
      name = var_names{1};
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.getvars
    ## @deftypefn {Method} {[@var{out1}, @dots{}]} = getvars (@var{obj}, @var{varRef})
    ##
    ## Get values for one ore more table variables.
    ##
    ## @var{varRef} is a variable reference in the form of variable names or 
    ## indexes.
    ##
    ## Returns as many outputs as @var{varRef} referenced variables. Each output
    ## contains the contents of the corresponding table variable.
    ##
    ## @end deftypefn
    function varargout = getvars (this, name)
      [ix_var, var_names] = resolveVarRef (this, name);
      varargout = cell (1:numel (ix_var));
      [varargout{:}] = this.VariableValues{ix_var};
    endfunction

    ## -*- texinfo -*-
    ## @node table.setvar
    ## @deftypefn {Method} {@var{out} =} setvar (@var{obj}, @var{varRef}, @var{value})
    ##
    ## Set value for a variable in table.
    ##
    ## This sets (adds or replaces) the value for a variable in @var{obj}. It
    ## may be used to change the value of an existing variable, or add a new
    ## variable.
    ##
    ## This method exists primarily because I cannot get @code{obj.foo = value} to work,
    ## apparently due to an issue with Octave's subsasgn support.
    ##
    ## @var{varRef} is a variable reference, either the index or name of a variable.
    ## If you are adding a new variable, it must be a name, and not an index.
    ##
    ## @var{value} is the value to set the variable to. If it is scalar or
    ## a single string as charvec, it is scalar-expanded to match the number
    ## of rows in @var{obj}.
    ##
    ## @end deftypefn
    function out = setvar (this, varRef, value)
      ixVar = resolveVarRef (this, varRef, 'lenient');
      if ! isscalar (ixVar)
        error('table.setvar: Only a single variable is allowed for varRef; got %d', ...
          numel (ixVar));
      endif
      out = this;
      % Scalar expansion
      value_in = value;
      n_rows = height (this);
      val_is_scalar = isscalar(value) || (ischar(value) && ...
        (size (value, 1) == 1 || isequal (size (value), [0 0])));
      if n_rows != 1 && val_is_scalar
        if ischar (value)
          value = { value };
        endif
        value = repmat (value, [n_rows 1]);
      endif
      if size (value, 1) ~= height (this)
        error ('table.setvar: Inconsistent dimensions: table is height %d, input is height %d', ...
          height (this), size (value, 1));
      end
      if ixVar == 0
        % Adding a variable
        if ! ischar (varRef)
          error (['table.setvar: When adding a variable, you must supply the ' ...
            'variable name instead of an index']);
        endif
        ix_new_var = width (this) + 1;
        out.VariableNames{ix_new_var} = varRef;
        out.VariableValues{ix_new_var} = value;
      else
        % Changing a variable
        out.VariableValues{ixVar} = value;
      endif
    end
    
    ## -*- texinfo -*-
    ## @node table.addvars
    ## @deftypefn {Method} {@var{out} =} addvars (@var{obj}, @var{var1}, @dots{}, @var{varN})
    ## @deftypefnx {Method} {@var{out} =} addvars (@dots{}, @code{'Before'}, @var{Before})
    ## @deftypefnx {Method} {@var{out} =} addvars (@dots{}, @code{'After'}, @var{After})
    ## @deftypefnx {Method} {@var{out} =} addvars (@dots{}, @
    ##   @code{'NewVariableNames'}, @var{NewVariableNames})
    ##
    ## Add variables to table
    ##
    ## Adds the specified variables to a table.
    ##
    ## @end deftypefn
    function out = addvars (this, varargin)
      [opts, args] = peelOffNameValueOptions (varargin, ...
        {'Before', 'After', 'NewVariableNames'});
      ix_insertion = width (this);
      if isfield (opts, 'Before')
        ix_insertion = resolveVarRef (this, opts.Before) - 1;
      endif
      if isfield (opts, 'After')
        ix_insertion = resolveVarRef (this, opts.After);
      endif
      
      new_var_vals = args;
      if isfield (opts, 'NewVariableNames')
        new_var_names = opts.NewVariableNames;
        if numel (new_var_names) != numel (new_var_vals)
          error ('table.addvars: size mismatch: got %d variables but %d names', ...
            numel (new_var_vals), numel (new_var_names));
        endif
      else
        new_var_names = cell (size (args));
        for i = 1:numel (new_var_vals)
          new_var_names{i} = inputname (i + 1);
          if isempty (new_var_names{i})
            error ('table.addvars: no variable name found for input %d', i + 1);
          endif
        endfor
      endif
      
      new_tbl = table (new_var_vals{:}, 'VariableNames', new_var_names);
      if ix_insertion == width (this)
        out = [this new_tbl];
      elseif ix_insertion == 0
        out = [new_tbl this];
      else
        left = subsetvars (this, 1:ix_insertion);
        right = subsetvars (this, ix_insertion+1:end);
        out = [left new_tbl right];
      endif
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.convertvars
    ## @deftypefn {Method} {@var{out} =} convertvars (@var{obj}, @var{vars}, @var{dataType})
    ##
    ## Convert variables to specified data type.
    ##
    ## Converts the variables in @var{obj} specified by @var{vars} to the specified data type.
    ##
    ## @var{vars} is a cellstr or numeric vector specifying which variables to convert.
    ##
    ## @var{dataType} specifies the data type to convert those variables to. It is either
    ## a char holding the name of the data type, or a function handle which will
    ## perform the conversion. If it is the name of the data type, there must
    ## either be a one-arg constructor of that type which accepts the specified
    ## variables' current types as input, or a conversion method of that name
    ## defined on the specified variables' current type.
    ##
    ## Returns a table with the same variable names as @var{obj}, but with converted
    ## types.
    ##
    ## @end deftypefn
    function out = convertvars (this, vars, dataType)
      if ~ischar (dataType) && isa (dataType, 'function_handle')
        error ('table.convertvars: dataType must be char or function_handle; got a %s', ...
          class (dataType));
      endif
      ixVars = resolveVarRef (this, vars);
      out = this;
      for i = 1:numel (ixVars)
        ixVar = ixVars(i);
        out.VariableValues{ixVar} = feval (dataType, this.VariableValues{ixVar});
      endfor
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.mergevars
    ## @deftypefn {Method} {@var{out} =} mergevars (@var{obj}, @var{vars})
    ## @deftypefnx {Method} {@var{out} =} mergevars (@dots{}, @
    ##   @code{'NewVariableName'}, @var{NewVariableName})
    ## @deftypefnx {Method} {@var{out} =} mergevars (@dots{}, @
    ##   @code{'MergeAsTable'}, @var{MergeAsTable})
    ##
    ## Merge table variables into a single variable.
    ##
    ## @end deftypefn
    function out = mergevars (this, vars, varargin)
      [opts, args] = peelOffNameValueOptions (varargin, ...
        {'NewVariableName', 'MergeAsTable'});
      if isfield (opts, 'MergeAsTable')
        merge_as_table = opts.MergeAsTable;
      else
        merge_as_table = false;
      endif
      [ix_vars, var_names] = resolveVarRef (this, vars);
      [ix_vars, ix_sort] = sort(ix_vars);
      var_names = var_names(ix_sort);
      if isfield (opts, 'NewVariableName')
        new_var_name = opts.NewVariableName;
      else
        new_var_name = var_names{1};
      endif      
      
      ix_all_vars = 1:width (this);
      ix_vars_left = ix_all_vars;
      ix_vars_left(ix_vars) = [];
      
      merged_as_tbl = subsetvars (this, ix_vars);
      leftover = subsetvars (this, ix_vars_left);
      if merge_as_table
        new_var_value = merged_as_tbl;
      else
        new_var_value = cat (2, merged_as_tbl.VariableValues{:});
      endif
      out = addvars (leftover, new_var_value, 'After', ix_vars(1)-1, ...
        'NewVariableNames', {new_var_name});
    endfunction
    

    ## -*- texinfo -*-
    ## @node table.splitvars
    ## @deftypefn {Method} {@var{out} =} splitvars (@var{obj})
    ## @deftypefnx {Method} {@var{out} =} splitvars (@var{obj}, @var{vars})
    ## @deftypefnx {Method} {@var{out} =} splitvars (@dots{}, @
    ##   @code{'NewVariableNames'}, @var{NewVariableNames})
    ##
    ## Split multicolumn table variables.
    ##
    ## Splits multicolumn table variables into new single-column variables.
    ## If @var{vars} is supplied, splits only those variables. If @var{vars}
    ## is not supplied, splits all multicolumn variables.
    ##
    ## @end deftypefn
    function out = splitvars(this, varargin)
      [opts, args] = peelOffNameValueOptions (varargin, {'NewVariableNames'});
      if isfield (opts, 'NewVariableNames')
        new_var_names = opts.NewVariableNames;
      else
        new_var_names = [];
      endif
      if isempty(args)
        do_all_vars = true;
      else
        do_all_vars = false;
        vars_to_split = args{1};
      endif
      
      if do_all_vars
        vars_to_split = [];
        for i=1:width (this)
          if size (this.VariableValues{i}, 2) > 1
            vars_to_split(end+1) = i;
          endif
        endfor
      endif
      [ix_vars, old_var_names] = resolveVarRef (this, vars_to_split);
      [ix_vars, ix_sort] = sort (ix_vars);
      old_var_names = old_var_names(ix_sort);
      if numel (ix_vars) > 1 && ! isempty (new_var_names)
        error ('NewVariableNames may only be specified when splitting a single variable');
      endif
      
      out = this;
      for i_var = numel(ix_vars):-1:1
        ix_var = ix_vars(i_var);
        old_val = out.VariableValues{ix_var};
        if isa (old_val, 'table')
          new_var_vals = old_val.VariableValues;
        else
          new_var_vals = num2cell (old_val, 1);
        endif
        if isempty (new_var_names)
          if istable (old_val)
            my_new_var_names = old_val.VariableNames;
          else
            my_new_var_names = cell (size (new_var_vals));
            for i_new_var = 1:numel (my_new_var_names)
              my_new_var_names{i_new_var} = sprintf('%s_%d', old_var_names{i_var}, ...
                i_new_var);
            endfor
          endif
        else
          my_new_var_names = new_var_names;
        endif
        
        out = removevars (out, ix_var);
        out = addvars (out, new_var_vals{:}, 'NewVariableNames', my_new_var_names, ...
          'Before', ix_var);
      endfor
    endfunction

    ## -*- texinfo -*-
    ## @node table.stack
    ## @deftypefn {Method} {@var{out} =} stack (@var{obj}, @var{vars})
    ## @deftypefnx {Method} {@var{out} =} stack (@dots{}, @
    ##   @code{'NewDataVariableName'}, @var{NewDataVariableName})
    ## @deftypefnx {Method} {@var{out} =} stack (@dots{}, @
    ##   @code{'IndexVariableName'}, @var{IndexVariableName})
    ##
    ## Stack multiple table variables into a single variable.
    ##
    ## @end deftypefn
    function out = stack (this, varRef, varargin)
      [opts, args] = peelOffNameValueOptions (varargin, ...
        {'NewDataVariableName', 'IndexVariableName', 'ConstantVariables'});
      index_var_name = [];
      if isfield (opts, 'IndexVariableName')
        index_var_name = opts.IndexVariableName;
      endif
      new_data_var_name = [];
      if isfield (opts, 'NewDataVariableName')
        new_data_var_name = opts.NewDataVariableName;
      endif
      
      [ix_vars, var_names] = resolveVarRef (this, varRef);
      if isfield (opts, 'ConstantVariables')
        [ix_const_vars, const_var_names] = resolveVarRef (this, opts.ConstantVariables);
      else
        ix_const_vars = setdiff (1:width (this), ix_vars);
      endif
      
      tbl = subsetvars (this, ix_const_vars);
      n_rows_orig = height (this);
      n_ctgs = numel (ix_vars);
      ctg_run = categorical (var_names)';
      tbl = repelem (tbl, n_ctgs, 1);
      
      % Do some fancy indexing to arrange the stacked values
      stk_vals = this.VariableValues(ix_vars);
      stk_mat = cat(2, stk_vals{:});
      stk_mat = stk_mat';
      stk_var_vals = stk_mat(:);
      index_var_vals = repmat(ctg_run, [n_rows_orig 1]);
      if isempty (new_data_var_name)
        new_data_var_name = strjoin(var_names, '_');
      endif
      if isempty (index_var_name)
        index_var_name = [new_data_var_name '_Indicator'];
      endif
      stk_tbl = table(index_var_vals, stk_var_vals, ...
        'VariableNames', {index_var_name, new_data_var_name});
      
      out = [tbl stk_tbl];
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.head
    ## @deftypefn {Method} {@var{out} =} head (@var{obj})
    ## @deftypefnx {Method} {@var{out} =} head (@var{obj}, @var{k})
    ##
    ## Get first K rows of table.
    ##
    ## Returns the first @var{k} rows of @var{obj}, as a table.
    ##
    ## @var{k} defaults to 8.
    ##
    ## If there are less than @var{k} rows in @var{obj}, returns all rows.
    ##
    ## @end deftypefn
    function out = head (this, k)
      if nargin < 2 || isempty (k)
        k = 8;
      endif
      nRows = height (this);
      if nRows < k
        out = this;
        return;
      endif
      out = subsetrows (this, 1:k);
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.tail
    ## @deftypefn {Method} {@var{out} =} tail (@var{obj})
    ## @deftypefnx {Method} {@var{out} =} tail (@var{obj}, @var{k})
    ##
    ## Get last K rows of table.
    ##
    ## Returns the last @var{k} rows of @var{obj}, as a table.
    ##
    ## @var{k} defaults to 8.
    ##
    ## If there are less than @var{k} rows in @var{obj}, returns all rows.
    ##
    ## @end deftypefn
    function out = tail (this, k)
      %TAIL Get last K rows of table
      %
      % out = tail (this, k)
      %
      % Returns the last k rows of this. K defaults to 8.
      %
      % If there are less than k rows in this, returns all rows.
      if nargin < 2 || isempty (k)
        k = 8;
      endif
      nRows = height (this);
      if nRows < k
        out = this;
        return;
      endif
      out = subsetrows (this, [(nRows - (k - 1)):nRows]);
    endfunction
    
    function out = transpose (this)
      out = transpose_table (this);
    end

    function out = ctranspose (this)
      out = transpose_table (this);
    end

    % Relational operations
    
    function [out, index] = sortrows (this, varargin)
      %SORTROWS Sort rows of table
      %
      % [out, index] = sortrows (this, varargin)
      %
      % Sorts the rows of this based on the values in their variables.
      
      % Parse input signature
      % This is tricky because the sortrows() signature is complicated and ambiguous
      args = varargin;
      doRowNames = false;
      direction = 'ascend';
      varRef = ':';
      knownOptions = {'MissingPlacement', 'ComparisonMethod'};
      [opts, ~, optArgs] = peelOffNameValueOptions (args, knownOptions);
      if ~isempty (args) && (ischar (args{end}) || iscellstr (args{end})) ...
        && all (ismember (args{end}, {'ascend','descend'}))
        direction = args{end};
        args(end) = [];
      end
      if numel (args) > 1
        error ('table.sortrows: Unrecognized options or arguments');
      endif
      if !isempty (args)
        %FIXME: Determine how to identify the "rowDimName" argument
        if ischar (args{1}) && isequal (args{1}, 'RowNames')
          doRowNames = true;
        else
          varRef = args{1};
        endif
        args(end) = [];
      endif
      
      % Interpret inputs
      
      % Do sorting
      if doRowNames
        % Special case: sort by row names
        if isempty (this.rowNames)
          error ('table.sortrows: this table does not have row names');
        endif
        [sortedRowNames, index] = sortrows (this.RowNames, direction, optArgs{:});
        out = subsetrows (this, index);
      else
        % General case
        ixVars = resolveVarRef (this, varRef);
        if ischar (direction)
          direction = cellstr (direction);
        endif
        if isscalar (direction)
          directions = repmat (direction, size (ixVars));
        else
          directions = direction;
        endif
        if ~isequal (size (directions), size (ixVars))
          error ('table.sortrows: inconsistent size between direction and vars specifier');
        endif
        % Perform a radix sort on the referenced variables
        index = 1:height (this);
        tmp = this;
        for iStep = 1:numel(ixVars)
          iVar = numel(ixVars) - iStep + 1;
          ixVar = ixVars(iVar);
          varVal = tmp.VariableValues{ixVar};
          %Convert Matlab-style 'descend' arg to Octave-style negative column index
          %TODO: Add support for Octave-style negative column indexes in table.sortrows input.
          %TODO: Wrap this arg munging logic in a sortrows_matlabby() function
          %TODO: Better error message when optArgs are is present.
          if isequal (directions{iVar}, 'descend')
            [~, ix] = sortrows (varVal, -1 * (1:size (varVal, 2)), optArgs{:});
          else
            [~, ix] = sortrows (varVal, optArgs{:});
          endif
          index = index(ix);
          tmp = subsetrows (tmp, ix);
        endfor
        out = subsetrows (this, index);
      endif
    endfunction
    
    function out = issortedrows (this, varargin)
      %ISSORTEDROWS Determine if table rows are sorted
      %
      % out = issortedrows (this, varargin)
      %
      % TODO: Document my signature.
      [~, ix] = sortrows (this, varargin{:});
      out = isequal (ix, 1:height (this));
    endfunction
    
    function [out, ia] = topkrows (this, k, varargin)
      %TOPKROWS Top rows in sorted order
      %
      % [out, ia] = topkrows (this, k, varargin)
      %
      % TODO: Document my signature.
      [sorted, ix] = sortrows (this, varargin);
      if k > height (sorted)
        out = sorted;
        ia = ix;
      else
        out = sorted(1:k,:);
        ia = ix(1:k);
      end
    endfunction

    function [out, ia, ic] = unique (this, varargin)
      %UNIQUE Unique row values
      %
      % [out, ia, ic] = unique (this)
      % [out, ia, ic] = unique (..., 'first'/'last')
      % [out, ia, ic] = unique (..., 'legacy')
      % [out, ia, ic] = unique (..., 'stable'/'sorted')
      %
      % The 'legacy', 'stable', and 'sorted' flags are currently unsupported 
      % because Octave's core unique() function does not support them. If you use
      % them, you will get an error with a possibly-obsure error message.
      %
      % You can also pass a 'rows' flag, but it is effectively ignored, because
      % row-wise operation is the only mode supported for unique() on tables. 
      validFlags = {'rows', 'legacy', 'stable', 'sorted', 'first', 'last'};
      redundantFlags = {'rows'};
      if ~iscellstr (varargin)
        error ('table.unique: Invalid inputs: args 2 and later must be char flags');
      endif
      flags = varargin;
      invalidFlags = setdiff (varargin, validFlags);
      if ~isempty (invalidFlags)
        error ('table.unique: Invalid flags: %s', strjoin(invalidFlags, ', '));
      endif
      tfRedundant = ismember (flags, redundantFlags);
      flags(tfRedundant) = [];

      pk = proxykeysForMatrixes (this);
      [uPk, ia, ic] = unique (pk, 'rows', flags{:});
      out = subsetrows (this, ia);
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.join
    ## @deftypefn {Method} {[@var{C}, @var{ib}] =} join (@var{A}, @var{B})
    ## @deftypefnx {Method} {[@var{C}, @var{ib}] =} join (@var{A}, @var{B}, @dots{})
    ##
    ## Combine two tables by rows using key variables, in a restricted form.
    ##
    ## This is not a "real" relational join operation. It has the restrictions
    ## that:
    ##  1) The key values in B must be unique. 
    ##  2) Every key value in A must map to a key value in B.
    ## These are restrictions inherited from the Matlab definition of table.join.
    ##
    ## You probably don’t want to use this method. You probably want to use
    ## innerjoin or outerjoin instead.
    ##
    ## See also: @ref{table.innerjoin}, @ref{table.outerjoin}
    ##
    ## @end deftypefn
    function [C, ib] = join (A, B, varargin)
      % TODO: Implement options
      
      % Input munging
      optNames = {'Keys', 'KeepOneCopy', 'LeftKeys', 'RightKeys', ...
        'LeftVariables', 'RightVariables'};
      opts = peelOffNameValueOptions (varargin, optNames);
      unimplementedOptions = optNames;
      for i = 1:numel (unimplementedOptions)
        if isfield (opts, unimplementedOptions{i})
          error ('table.join: Option %s is unimplemented. Sorry.', ...
            unimplementedOptions{i});
        endif
      endfor
      if !istable (A)
        A = table (A);
      endif
      if !istable (B)
        B = table (B);
      endif
      
      % Join logic
      keyVarNames = intersect_stable (A.VariableNames, B.VariableNames);
      nonKeyVarsB = setdiff_stable (B.VariableNames, keyVarNames);
      if isempty (keyVarNames)
        error ('table.join: Cannot join: inputs have no variable names in common');
      endif
      keysA = subsetvars (A, keyVarNames);
      keysB = subsetvars (B, keyVarNames);
      uKeysB = unique (keysB);
      if height (uKeysB) < height (keysB)
        error ('table.join: Non-unique keys in B');
      endif
      [pkA, pkB] = proxykeysForMatrixes (keysA, keysB);
      [tf, ib] = ismember (pkA, pkB, 'rows');
      if ~all (tf)
        error ('table.join: Some rows in A had no corresponding key values in B');
      endif
      % TODO: Once we've applied the key restrictions, can we just call
      % realjoin() here?
      outA = A;
      nonKeysB = subsetvars (B, nonKeyVarsB);
      outB = subsetrows (nonKeysB, ib);
      C = [outA outB];
    endfunction

    function out = resolveJoinKeysAndVars(A, B, opts)
      %RESOLVEJOINKEYSANDVARS Internal implementation method
      if isfield (opts, 'Keys')
        if isnumeric (opts.Keys) || islogical (opts.Keys)
          if islogical (opts.Keys)
            keyIxA = find (opts.Keys);
            keyIxB = find (opts.Keys);
          else
            keyIxA = opts.Keys;
            keyIxB = opts.Keys;
          endif
          keyNamesA = A.VariableNames(keyIxA);
          keyNamesB = B.VariableNames(keyIxB);
        elseif ischar (opts.Keys) || iscellstr (opts.Keys)
          keyNamesA = cellstr (opts.Keys);
          keyNamesB = cellstr (opts.Keys);
          [tf, keyIxA] = ismember (keyNamesA, A.VariableNames);
          if ! all (tf)
            error ('Named keys not found in table A: %s', strjoin (keyNamesA(!tf), ', '));
          endif
          [tf, keyIxB] = ismember (keyNamesB, B.VariableNames);
          if ! all (tf)
            error ('Named keys not found in table B: %s', strjoin (keyNamesB(!tf), ', '));
          endif
        endif
      elseif isfield (opts, 'LeftKeys')
        if ! isfield (opts, 'RightKeys')
          error ('If option LeftKeys is supplied, then RightKeys must be, too.');
        endif
        if isnumeric (opts.LeftKeys) || islogical (opts.LeftKeys)
          if islogical (opts.LeftKeys)
            keyIxA = find (opts.LeftKeys);
          else
            keyIxA = opts.LeftKeys;
          endif
          keyNamesA = A.VariableNames(keyIxA);
        elseif ischar (opts.LeftKeys) || iscellstr (opts.LeftKeys)
          keyNamesA = cellstr (opts.LeftKeys);
          [tf, keyIxA] = ismember (keyNamesA, A.VariableNames);
          if ! all (tf)
            error ('Named keys not found in table A: %s', strjoin (keyNamesA(!tf), ', '));
          endif
        endif
        if isnumeric (opts.RightKeys) || islogical (opts.RightKeys)
          if islogical (opts.RightKeys)
            keyIxB = find (opts.RightKeys);
          else
            keyIxB = opts.RightKeys;
          endif
          keyNamesB = B.VariableNames(keyIxB);
        elseif ischar (opts.RightKeys) || iscellstr (opts.RightKeys)
          keyNamesB = cellstr (opts.RightKeys);
          [tf, keyIxB] = ismember (keyNamesB, B.VariableNames);
          if ! all (tf)
            error ('Named keys not found in table B: %s', strjoin (keyNamesB(!tf), ', '));
          endif
        endif
      elseif isfield (opts, 'RightKeys')
          error ('If option RightKeys is supplied, then LeftKeys must be, too.');
      else
        % Default keys are a natural join
        commonCols = intersect (A.VariableNames, B.VariableNames);
        keyNamesA = commonCols;
        keyNamesB = commonCols;
        [~, keyIxA] = ismember (commonCols, A.VariableNames);
        [~, keyIxB] = ismember (commonCols, B.VariableNames);
      endif
      if numel (keyIxA) != numel (keyIxB)
        error ('Number of keys must be same for A and B; got %d vs. %s', ...
          numel (keyIxA), numel (keyIxB));
      endif

      if isfield (opts, 'LeftVariables')
        if isnumeric (opts.LeftVariables) || islogical (opts.LeftVariables)
          if islogical (opts.LeftVariables)
            varIxA = find (opts.LeftVariables);
          else
            varIxA = opts.LeftVariables;
          endif
          varNamesA = A.VariableNames(varIxA);
        else
          varNamesA = cellstr (opts.LeftVariables);
          [tf, varIxA] = ismember (varNamesA, A.VariableNames);
          if ! all (tf)
            error ('Named variables not found in table A: %s', strjoin (varNamesA(!tf), ', '));
          endif
        endif
      else
        varIxA = 1:width(A);
        varNamesA = A.VariableNames;
      endif
      if isfield (opts, 'RightVariables')
        if isnumeric (opts.RightVariables) || islogical (opts.RightVariables)
          if islogical (opts.RightVariables)
            varIxB = find (opts.RightVariables);
          else
            varIxB = opts.RightVariables;
          endif
          varNamesB = B.VariableNames(varIxB);
        else
          varNamesB = cellstr (opts.RightVariables);
          [tf, varIxB] = ismember (varNamesB, B.VariableNames);
          if ! all (tf)
            error ('Named variables not found in table B: %s', strjoin (varNamesB(!tf), ', '));
          endif
        endif
      else
        varIxB = find (! ismember (B.VariableNames, varNamesA));
        varNamesB = B.VariableNames(varIxB);
      endif

      out.keyIxA = keyIxA;
      out.keyIxB = keyIxB;
      out.keyNamesA = keyNamesA;
      out.keyNamesB = keyNamesB;
      out.varIxA = varIxA;
      out.varIxB = varIxB;
      out.varNamesA = varNamesA;
      out.varNamesB = varNamesB;
    endfunction

    ## -*- texinfo -*-
    ## @node table.innerjoin
    ## @deftypefn {Method} {[@var{out}, @var{ixa}, @var{ixb}] =} innerjoin (@var{A}, @var{B})
    ## @deftypefnx {Method} {[@dots{}] =} innerjoin (@var{A}, @var{B}, @dots{})
    ##
    ## Combine two tables by rows using key variables.
    ##
    ## Computes the relational inner join between two tables. “Inner” means that
    ## only rows which had matching rows in the other input are kept in the
    ## output.
    ##
    ## TODO: Document options.
    ##
    ## Returns:
    ##   @var{out} - A table that is the result of joining A and B
    ##   @var{ix} - Indexes into A for each row in out
    ##   @var{ixb} - Indexes into B for each row in out
    ##
    ## @end deftypefn
    function [out, ixa, ixb] = innerjoin(A, B, varargin)      
      % Input munging
      optNames = {'Keys', 'LeftKeys', 'RightKeys', ...
        'LeftVariables', 'RightVariables'};
      opts = peelOffNameValueOptions (varargin, optNames);
      if ! istable (A)
        A = table (A);
      endif
      if ! istable (B)
        B = table (B);
      endif
      
      [out, ix] = realjoin(A, B, varargin{:});
      ixa = ix(:,1);
      ixb = ix(:,2);
    endfunction
    
    function [out, ixs] = realjoin(A, B, varargin)
      %REALJOIN "Real" relational inner join, without key restrictions
      %
      % [out, ixs] = realjoin(A, B, varargin)
      %
      % Performs a "real" relational natural inner join between two tables, 
      % without the key restrictions that JOIN imposes.
      %
      % Currently does not support tables which have RowNames. This may be
      % added in the future.
      %
      % This is an Octave extension.
      %
      % TODO: Document options.
      %
      % Returns:
      %   out - a table containing the result of joining A and B, with RowNames
      %         removed.
      %   ixs - an n-by-2 double matrix where ixs(i,:) is [ixA ixB], which are
      %         the indexes from A and B containing the input rows that resulted
      %         in this output row.
      
      % Input handling
      optNames = {'Keys', 'LeftKeys', 'RightKeys', ...
        'LeftVariables', 'RightVariables'};
      opts = peelOffNameValueOptions (varargin, optNames);
      if ! istable (A)
        A = table (A);
      endif
      if ! istable (B)
        B = table (B);
      endif
      opts2 = resolveJoinKeysAndVars (A, B, opts);
      if hasrownames (A)
        error ('table.realjoin: Input A may not have row names');
      endif
      if hasrownames (B)
        error ('table.realjoin: Input B may not have row names');
      endif
      
      % Join logic
      if isempty (opts2.keyIxA)
        % This degenerates to a cartesian product
        [out, ixs] = cartesian (A, B);
        return
      endif
      keysA = subsetvars (A, opts2.keyIxA);
      keysB = subsetvars (B, opts2.keyIxB);
      [pkA, pkB] = proxykeysForMatrixes (keysA, keysB);
      ixs = octave.table.internal.matchrows (pkA, pkB);
      subA = subsetvars (A, opts2.varIxA);
      subB = subsetvars (B, opts2.varIxB);
      [subA, subB] = makeVarNamesUnique (subA, subB);
      outA = subsetrows (subA, ixs(:,1));
      outB = subsetrows (subB, ixs(:,2));
      out = [outA outB];

    endfunction
  
    ## -*- texinfo -*-
    ## @node table.outerjoin
    ## @deftypefn {Method} {[@var{out}, @var{ixa}, @var{ixb}] =} outerjoin (@var{A}, @var{B})
    ## @deftypefnx {Method} {[@dots{}] =} outerjoin (@var{A}, @var{B}, @dots{})
    ##
    ## Combine two tables by rows using key variables, retaining unmatched rows.
    ##
    ## Computes the relational outer join of tables A and B. This is like a
    ## regular join, but also includes rows in each input which did not have
    ## matching rows in the other input; the columns from the missing side are
    ## filled in with placeholder values.
    ##
    ## TODO: Document options.
    ##
    ## Returns:
    ##   @var{out} - A table that is the result of the outer join of A and B
    ##   @var{ixa} - indexes into A for each row in out
    ##   @var{ixb} - indexes into B for each row in out
    ##
    ## @end deftypefn
    function [out, ixa, ixb] = outerjoin (A, B, varargin)

      % Input handling
      if !istable (A)
        A = table (A);
      endif
      if !istable (B)
        B = table (B);
      endif
      optNames = {'Keys', 'LeftKeys', 'RightKeys', 'MergeKeys', ...
        'LeftVariables', 'RightVariables', 'Type'};
      opts = peelOffNameValueOptions (varargin, optNames);
      if isfield (opts, 'Type')
        joinType = opts.Type;
      else
        joinType = 'full';
      endif
      switch joinType
        case 'left'
          fillLeft = false;
          fillRight = true;
        case 'right'
          fillLeft = true;
          fillRight = false;
        case 'full'
          fillLeft = true;
          fillRight = true;
        case 'inner'
          fillLeft = true;
          fillRight = true;
        otherwise
          error ('table.outerjoin: Invalid opts.Type: %s', joinType);
      endswitch
      opts2 = resolveJoinKeysAndVars (A, B, opts);
      if hasrownames (A)
        error ('table.outerjoin: Input A may not have row names');
      endif
      if hasrownames (B)
        error ('table.outerjoin: Input B may not have row names');
      endif
      
      % Join logic
      if isempty (opts2.keyIxA)
        % This degenerates to a cartesian product
        [out, ixs] = cartesian (A, B);
        return
      endif
      keysA = subsetvars (A, opts2.keyIxA);
      keysB = subsetvars (B, opts2.keyIxB);
      [pkA, pkB] = proxykeysForMatrixes (keysA, keysB);
      [ixs, ixUnmatchedA, ixUnmatchedB] = octave.table.internal.matchrows (pkA, pkB);
      subA = subsetvars (A, opts2.varIxA);
      subB = subsetvars (B, opts2.varIxB);
      [subA, subB] = makeVarNamesUnique (subA, subB);
      outA = subsetrows (subA, ixs(:,1));
      outB = subsetrows (subB, ixs(:,2));
      ixa = ixs(:,1);
      ixb = ixs(:,2);
      fillTables = {};
      if fillLeft
        fillRowB = outerfillvals (subB);
        fillLeftTable = [subsetrows(subA, ixUnmatchedA) ...
          repmat(fillRowB, [numel(ixUnmatchedA) 1])];
        fillTables{end+1} = fillLeftTable;
        ixa = [ixa; ixUnmatchedA];
        ixB = [ixb; NaN(size(ixUnmatchedA))];
      endif
      if fillRight
        fillRowA = outerfillvals (subA);
        fillRightTable = [repmat(fillRowA, [numel(ixUnmatchedB) 1]) ...
          subsetrows(subB, ixUnmatchedB)];
        fillTables{end+1} = fillRightTable;
        ixa = [ixa; NaN(size(ixUnmatchedB))];
        ixb = [ixb; ixUnmatchedB];
      endif
      out = [outA outB];
      % We have to do a loop because Octave doesn't like a plain cat() here
      for i = 1:numel (fillTables)
        out = [out; fillTables{i}];
      endfor

    endfunction

    ## -*- texinfo -*-
    ## @node table.outerfillvals
    ## @deftypefn {Method} {@var{out} =} outerfillvals (@var{obj})
    ##
    ## Get fill values for outer join.
    ##
    ## Returns a table with the same variables as this, but containing only
    ## a single row whose variable values are the values to use as fill values
    ## when doing an outer join.
    ##
    ## @end deftypefn
    function out = outerfillvals (this)
      fillVals = cell (1, width (this));
      for iCol = 1:width (this)
        x = this.VariableValues{iCol};
        fillVals{iCol} = tableOuterFillValue (x);
      endfor
      out = table (fillVals{:}, 'VariableNames', this.VariableNames);
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.semijoin
    ## @deftypefn {Method} {[@var{outA}, @var{ixA}, @var{outB}, @var{ixB}] =} semijoin @
    ##   (@var{A}, @var{B})
    ##
    ## Natural semijoin.
    ##
    ## Computes the natural semijoin of tables A and B. The semi-join of tables
    ## A and B is the set of all rows in A which have matching rows in B, based
    ## on comparing the values of variables with the same names.
    ##
    ## This method also computes the semijoin of B and A, for convenience.
    ##
    ## Returns:
    ##   @var{outA} - all the rows in A with matching row(s) in B
    ##   @var{ixA} - the row indexes into A which produced @var{outA}
    ##   @var{outB} - all the rows in B with matching row(s) in A
    ##   @var{ixB} - the row indexes into B which produced @var{outB}
    ##
    ## @end deftypefn
    function [outA, ixA, outB, ixB] = semijoin (A, B)
      
      % Developer note: This is almost exactly the same as antijoin, just with
      % inverted ismember() tests. See if the implementations can be refactored
      % together.
      
      % Input handling
      if !istable (A)
        A = table (A);
      endif
      if !istable (B)
        B = table (B);
      endif
      
      % Join logic
      keyVarNames = intersect_stable (A.VariableNames, B.VariableNames);
      nonKeyVarsB = setdiff_stable (B.VariableNames, keyVarNames);
      if isempty (keyVarNames)
        % The degenerate case of no common variable names is to keep all the rows.
        outA = A;
        ixA = 1:height (A);
        outB = B;
        ixB = 1:height (B);
        return
      endif
      keysA = subsetvars (A, keyVarNames);
      keysB = subsetvars (B, keyVarNames);
      [pkA, pkB] = proxykeysForMatrixes (keysA, keysB);
      ixA = find (ismember (pkA, pkB, 'rows'));
      outA = subsetrows (A, ixA);
      if nargout > 2
        ixB = find (ismember (pkB, pkA, 'rows'));
        outB = subsetrows (B, ixB);
      endif
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.antijoin
    ## @deftypefn {Method} {[@var{outA}, @var{ixA}, @var{outB}, @var{ixB}] =} antijoin @
    ##   (@var{A}, @var{B})
    ##
    ## Natural antijoin (AKA “semidifference”).
    ##
    ## Computes the anti-join of A and B. The anti-join is defined as all the
    ## rows from one input which do not have matching rows in the other input.
    ##
    ## Returns:
    ##   @var{outA} - all the rows in A with no matching row in B
    ##   @var{ixA} - the row indexes into A which produced @var{outA}
    ##   @var{outB} - all the rows in B with no matching row in A
    ##   @var{ixB} - the row indexes into B which produced @var{outB}
    ##
    ## @end deftypefn
    function [outA, ixA, outB, ixB] = antijoin (A, B)
      
      % Input handling
      if !istable (A)
        A = table (A);
      endif
      if !istable (B)
        B = table (B);
      endif
      
      % Join logic
      keyVarNames = intersect_stable (A.VariableNames, B.VariableNames);
      nonKeyVarsB = setdiff_stable (B.VariableNames, keyVarNames);
      if isempty (keyVarNames)
        % The degenerate case when there are no common variable names is the empty set
        outA = subsetrows (A, []);
        ixA = [];
        outB = subsetrows (B, []);
        ixB = [];
        return
      endif
      keysA = subsetvars (A, keyVarNames);
      keysB = subsetvars (B, keyVarNames);
      [pkA, pkB] = proxykeysForMatrixes (keysA, keysB);
      ixA = find (!ismember (pkA, pkB, 'rows'));
      outA = subsetrows (A, ixA);
      if nargout > 2
        ixB = find (!ismember (pkB, pkA, 'rows'));
        outB = subsetrows (B, ixB);
      endif
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.cartesian
    ## @deftypefn {Method} {[@var{out}, @var{ixs}] =} cartesian (@var{A}, @var{B})
    ##
    ## Cartesian product of two tables.
    ##
    ## Computes the Cartesian product of two tables. The Cartesian product is
    ## each row in A combined with each row in B.
    ##
    ## Due to the definition and structural constraints of table, the two inputs
    ## must have no variable names in common. It is an error if they do.
    ##
    ## The Cartesian product is seldom used in practice. If you find yourself
    ## calling this method, you should step back and re-evaluate what you are
    ## doing, asking yourself if that is really what you want to happen. If nothing
    ## else, writing a function that calls cartesian() is usually much less
    ## efficient than alternate ways of arriving at the same result.
    ##
    ## This implementation does not remove duplicate values.
    ## TODO: Determine whether this duplicate-removing behavior is correct.
    ##
    ## The ordering of the rows in the output is not specified, and may be implementation-
    ## dependent. TODO: Determine if we can lock this behavior down to a fixed,
    ## defined ordering, without killing performance.
    ## 
    ## @end deftypefn
    function [out, ixs] = cartesian (A, B)
      
      % Developer's note: The second argout, ixs, is for table's internal use,
      % and is thus undocumented.
      
      mustBeA (A, 'table');
      mustBeA (B, 'table');
      
      commonVars = intersect (A.VariableNames, B.VariableNames);
      if ~isempty (commonVars)
        error ('table.cartesian: Inputs have variable names in common: %s', ...
          strjoin (commonVars, ', '));
      endif
      
      nRowsA = height (A);
      nRowsB = height (B);
      ixA = (1:nRowsA)';
      ixB = (1:nRowsB)';
      ixAOut = repelem (ixA, nRowsB);
      ixBOut = repmat (ixB, [nRowsA 1]);
      ixs = [ixAOut ixBOut];
      outA = subsetrows (A, ixAOut);
      outB = subsetrows (B, ixBOut);
      out = [outA outB];
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.groupby
    ## @deftypefn {Method} {[@var{out}] =} groupby (@var{obj}, @var{groupvars}, @var{aggcalcs})
    ##
    ## Find groups in table data and apply functions to variables within groups.
    ##
    ## This works like an SQL @code{"SELECT ... GROUP BY ..."} statement.
    ##
    ## @var{groupvars} (cellstr, numeric) is a list of the grouping variables, 
    ## identified by name or index.
    ##
    ## @var{aggcalcs} is a specification of the aggregate calculations to perform
    ## on them, in the form @code{@{}@var{out_var}@code{,} @var{fcn}@code{,} @var{in_vars}@code{; ...@}}, where:
    ##   @var{out_var} (char) is the name of the output variable
    ##   @var{fcn} (function handle) is the function to apply to produce it
    ##   @var{in_vars} (cellstr) is a list of the input variables to pass to fcn
    ##
    ## Returns a table.      
    ##
    ## @end deftypefn    
    function out = groupby (this, groupvars, aggcalcs)
      narginchk (2, 3);
      if nargin < 3 || isempty (aggcalcs);  aggcalcs = cell(0, 3); end
      mustBeA (aggcalcs, 'cell');
      if size (aggcalcs, 2) != 3
        error ('table.groupby: aggcalcs must be an 3-wide cell; got %d-wide', ...
          size (aggcalcs, 2));
      endif
      
      % Resolve input vars once up front for speed
      n_aggs = size (aggcalcs, 1);
      for i = 1:n_aggs
        aggcalcs{i,4} = resolveVarRef (this, aggcalcs{i,3});
      endfor
      
      agg_outs = cell (1, n_aggs);
      [group_id, groups_tbl] = findgroups (subsetvars (this, groupvars));
      n_groups = size (groups_tbl, 1);
      for i_group = 1:n_groups
        tf_in_group = group_id == i_group;
        for i_agg = 1:n_aggs
          [~, fcn, in_vars, ix_in_vars] = aggcalcs{i_agg,:};
          agg_ins = cell(1, numel (ix_in_vars));
          for i_in_var = 1:numel (agg_ins)
            agg_ins{i_in_var} = this.VariableValues{ix_in_vars(i_in_var)}(tf_in_group);
          endfor
          agg_out = fcn(agg_ins{:});
          if i_group == 1
            agg_outs{i_agg} = repmat(agg_out, [n_groups 1]);
          else
            agg_outs{i_agg}(i_group,:) = agg_out;
          endif
        endfor
      endfor
      
      agg_out_tbl = table(agg_outs{:}, 'VariableNames', aggcalcs(:,1));
      out = [groups_tbl agg_out_tbl];
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.grpstats
    ## @deftypefn {Method} {[@var{out}] =} grpstats (@var{obj}, @var{groupvar})
    ## @deftypefnx {Method} {[@var{out}] =} grpstats (@dots{}, @code{'DataVars'}, @var{DataVars})
    ##
    ## Statistics by group.
    ##
    ## See also: @ref{table.groupby}.
    ##
    ## @end deftypefn
    function out = grpstats (this, groupvar, varargin)
      [opts, args] = peelOffNameValueOptions (varargin, {'DataVars'});
      if numel (args) > 1
        error ('table.grpstats: too many inputs');
      elseif numel (args) == 1
        whichstats = args{1};
      else
        whichstats = {'mean'};
      endif
      if ! iscell (whichstats)
        error ('whichstats must be a cell array');
      endif
      [ix_groupvar, groupvar_names] = resolveVarRef (this, groupvar);
      if isfield (opts, 'DataVars')
        data_vars = opts.DataVars;
        [ix_data_vars, data_vars] = resolveVarRef (this, data_vars);
      else
        data_vars = setdiff (this.VariableNames, groupvar_names);
      endif
      aggs = cell(0, 3);
      
      % TODO: Implement sem, gname, meanci, predci
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
          if ischar (whichstats{i_stat})
            stat_fcn_name = whichstats{i_stat};
            [tf,loc] = ismember (stat_fcn_name, stat_map(:,1));
            if ! tf
              error ('table.grpstats: unsupported stat name: %s', stat_fcn_name);
            endif
            stat_fcn = stat_map{loc,2};
          elseif isa (whichstats{i_stat}, fcn_handle)
            stat_fcn = whichstats{i_stat};
            stat_fcn_name = func2str (stat_fcn);
          endif
          out_var = sprintf('%s_%s', stat_fcn_name, data_vars{i_var});
          aggs = [aggs; { out_var, stat_fcn, data_vars{i_var} }];
        endfor
      endfor
      
      out = groupby (this, groupvar, aggs);
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.splitapply
    ## @deftypefn {Method} {@var{out} =} splitapply (@var{func}, @var{obj}, @var{G})
    ## @deftypefnx {Method} {[@var{Y1}, @dots{}, @var{YM}] =} splitapply (@var{func}, @var{obj}, @var{G})
    ##
    ## Split table data into groups and apply function.
    ##
    ## Performs a splitapply, using the variables in @var{obj} as the input X variables
    ## to the @code{splitapply} function call.
    ##
    ## See also: @ref{splitapply}, @ref{table.groupby}
    ##
    ## @end deftypefn
    function varargout = splitapply (func, this, G)
      mustBeA (func, 'function_handle');
      mustBeA (this, 'table');
      vars = this.VariableValues;
      out = octave.internal.splitapply_impl (func, vars{:}, G);
    endfunction

    ## -*- texinfo -*-
    ## @node table.rows2vars
    ## @deftypefn {Method} {@var{out} =} rows2vars (@var{obj})
    ## @deftypefnx {Method} {@var{out} =} rows2vars (@var{obj}, @
    ##   @code{'VariableNamesSource'}, @var{VariableNamesSource})
    ## @deftypefnx {Method} {@var{out} =} rows2vars (@dots{}, @
    ##   @code{'DataVariables'}, @var{DataVariables})
    ##
    ## Reorient table, swapping rows and variables dimensions.
    ##
    ## This flips the dimensions of the given table @var{obj}, swapping the
    ## orientation of the contained data, and swapping the row names/labels
    ## and variable names.
    ##
    ## The variable names become a new variable named “OriginalVariableNames”.
    ##
    ## The row names are drawn from the column @var{VariableNamesSource} if it
    ## is specified. Otherwise, if @var{obj} has row names, they are used. 
    ## Otherwise, new variable names in the form “VarN” are generated.
    ##
    ## If all the variables in @var{obj} are of the same type, they are concatenated
    ## and then sliced to create the new variable values. Otherwise, they are
    ## converted to cells, and the new table has cell variable values.
    ##
    ## @end deftypefn
    function out = rows2vars (this, varargin)
      [opts, args] = peelOffNameValueOptions (varargin, {'VariableNamesSource', ...
        'DataVariables'});
        
      for i = 1:width (this)
        if size (this.VariableValues{i}, 2) > 1
          error ('table.rows2vars: Table variables may not have more than 1 column');
        elseif istable (this.VariableValues{i})
          error ('table.rows2vars: Nested tables are not supported');
        endif
      endfor
      
      if isfield (opts, 'VariableNamesSource')
        new_var_names = getvar (this, opts.VariableNamesSource);
        tbl = removevars (this, opts.VariableNamesSource);
      elseif hasrownames (this)
        new_var_names = this.RowNames';
        tbl = this;
      else
        new_var_names = cell (1, height (this));
        for i = 1:height (this)
          new_var_names{i} = sprintf ("Var%d", i);
        endfor
        tbl = this;
      endif
      if isfield (opts, 'DataVariables')
        tbl = subsetvars (tbl, opts.DataVariables);
      endif
      OriginalVariableNames = tbl.VariableNames(:);
      tbl_original_var_names = table (OriginalVariableNames);
      
      col_types = cellfun (@(x) class(x), tbl.VariableValues);
      u_col_types = unique (col_types);
      if isscalar (u_col_types)
        matrix = cat (2, tbl.VariableValues{:});
      else
        cols_as_cells = cell (1, width (tbl));
        for i = 1:width (tbl)
          if iscell (tbl.VariableValues{i})
            cols_as_cells{i} = tbl.VariableValues{i};
          else
            cols_as_cells{i} = num2cell (tbl.VariableValues{i});
          endif
        endfor
        matrix = cat (2, cols_as_cells{:});
      endif

      matrix = matrix';
      new_var_values = num2cell (matrix, 1);
      out = table(new_var_values{:}, ...
        'VariableNames', new_var_names);
      out = [tbl_original_var_names out];
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.congruentize
    ## @deftypefn {Method} {[@var{outA}, @var{outB}] =} congruentize (@var{A}, @var{B})
    ##
    ## Make tables congruent.
    ##
    ## Makes tables congruent by ensuring they have the same variables of the
    ## same types in the same order. Congruent tables may be safely unioned,
    ## intersected, vertcatted, or have other set operations done to them.
    ##
    ## Variable names present in one input but not in the other produces an error.
    ## Variables with the same name but different types in the inputs produces
    ## an error.
    ## Inputs must either both have row names or both not have row names; it is
    ## an error if one has row names and the other doesn't.
    ## Variables in different orders are reordered to be in the same order as A.
    ##
    ## @end deftypefn
    function [outA, outB] = congruentize (A, B)
      
      if !istable (A)
        A = table (A);
      endif
      if !istable (B)
        B = table (B);
      endif
      if hasrownames (A) && !hasrownames (B)
        error ('table.congruentize: Input A has row names but input B does not');
      endif
      if !hasrownames (A) && hasrownames (B)
        error ('table.congruentize: Input B has row names but input A does not');
      endif
      varsOnlyInA = setdiff (A.VariableNames, B.VariableNames);
      if !isempty (varsOnlyInA)
        error ('table.congruentize: Input A has variables not present in B: %s', ...
          strjoin (varsOnlyInA, ', '));
      endif
      varsOnlyInB = setdiff (B.VariableNames, A.VariableNames);
      if !isempty (varsOnlyInB)
        error ('table.congruentize: Input B has variables not present in A: %s', ...
          strjoin (varsOnlyInB, ', '));
      endif

      outA = A;
      outB = B;
      [~,loc] = ismember (A.VariableNames, outB.VariableNames);
      outB = subsetvars (outB, loc);
      
    endfunction

    ## -*- texinfo -*-
    ## @node table.union
    ## @deftypefn {Method} {[@var{C}, @var{ia}, @var{ib}] =} union (@var{A}, @var{B})
    ##
    ## Set union.
    ##
    ## Computes the union of two tables. The union is defined to be the unique
    ## row values which are present in either of the two input tables.
    ##
    ## Returns:
    ##   @var{C} - A table containing all the unique row values present in A or B.
    ##   @var{ia} - Row indexes into A of the rows from A included in C.
    ##   @var{ib} - Row indexes into B of the rows from B included in C.
    ##
    ## @end deftypefn
    function [C, ia, ib] = union (A, B)      
      % Input handling
      [A, B] = congruentize (A, B);
            
      % Set logic
      [pkA, pkB] = proxykeysForMatrixes (A, B);
      [~, ia, ib] = union (pkA, pkB, 'rows');
      C = [subsetrows(A, ia); subsetrows(B, ib)];      
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.intersect
    ## @deftypefn {Method} {[@var{C}, @var{ia}, @var{ib}] =} intersect (@var{A}, @var{B})
    ##
    ## Set intersection.
    ##
    ## Computes the intersection of two tables. The intersection is defined to be the unique
    ## row values which are present in both of the two input tables.
    ##
    ## Returns:
    ##   @var{C} - A table containing all the unique row values present in both A and B.
    ##   @var{ia} - Row indexes into A of the rows from A included in C.
    ##   @var{ib} - Row indexes into B of the rows from B included in C.
    ##
    ## @end deftypefn
    function [C, ia, ib] = intersect (A, B)
      % Input handling
      [A, B] = congruentize (A, B);
            
      % Set logic
      [pkA, pkB] = proxykeysForMatrixes (A, B);
      [~, ia, ib] = intersect (pkA, pkB, 'rows');
      C = [subsetrows(A, ia); subsetrows(B, ib)];      
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.setxor
    ## @deftypefn {Method} {[@var{C}, @var{ia}, @var{ib}] =} setxor (@var{A}, @var{B})
    ##
    ## Set exclusive OR.
    ##
    ## Computes the setwise exclusive OR of two tables. The set XOR is defined to be 
    ## the unique row values which are present in one or the other of the two input
    ## tables, but not in both.
    ##
    ## Returns:
    ##   @var{C} - A table containing all the unique row values in the set XOR of A and B.
    ##   @var{ia} - Row indexes into A of the rows from A included in C.
    ##   @var{ib} - Row indexes into B of the rows from B included in C.
    ##
    ## @end deftypefn
    function [C, ia, ib] = setxor (A, B)
      % Input handling
      [A, B] = congruentize (A, B);
            
      % Set logic
      [pkA, pkB] = proxykeysForMatrixes (A, B);
      [~, ia, ib] = setxor (pkA, pkB, 'rows');
      C = [subsetrows(A, ia); subsetrows(B, ib)];      
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.setdiff
    ## @deftypefn {Method} {[@var{C}, @var{ia}] =} setdiff (@var{A}, @var{B})
    ##
    ## Set difference.
    ##
    ## Computes the set difference of two tables. The set difference is defined to be 
    ## the unique row values which are present in table A that are not in table B.
    ##
    ## Returns:
    ##   @var{C} - A table containing the unique row values in A that were not in B.
    ##   @var{ia} - Row indexes into A of the rows from A included in C.
    ##
    ## @end deftypefn
    function [C, ia] = setdiff (A, B)
      % Input handling
      [A, B] = congruentize (A, B);
            
      % Set logic
      [pkA, pkB] = proxykeysForMatrixes (A, B);
      [~, ia] = setdiff (pkA, pkB, 'rows');
      C = subsetrows (A, ia);
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.ismember
    ## @deftypefn {Method} {[@var{tf}, @var{loc}] =} ismember (@var{A}, @var{B})
    ##
    ## Set membership.
    ##
    ## Finds rows in A that are members of B.
    ##
    ## Returns:
    ##   @var{tf} - A logical vector indicating whether each A(i,:) was present in B.
    ##   @var{loc} - Indexes into B of rows that were found.
    ##
    ## @end deftypefn
    function [tf, loc] = ismember (A, B)      
      % Input handling
      [A, B] = congruentize (A, B);
            
      % Set logic
      [pkA, pkB] = proxykeysForMatrixes (A, B);
      [tf, loc] = ismember (pkA, pkB, 'rows');
    endfunction
    
    % Missing values
    
    ## -*- texinfo -*-
    ## @node table.ismissing
    ## @deftypefn {Method} {@var{out} =} ismissing (@var{obj})
    ## @deftypefnx {Method} {@var{out} =} ismissing (@var{obj}, @var{indicator})
    ##
    ## Find missing values.
    ##
    ## Finds missing values in @var{obj}’s variables.
    ##
    ## If indicator is not supplied, uses the standard missing values for each
    ## variable’s data type. If indicator is supplied, the same indicator list is
    ## applied across all variables.
    ##
    ## All variables in this must be vectors. (This is due to the requirement
    ## that @code{size(out) == size(obj)}.)
    ##
    ## Returns a logical array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = ismissing (this, indicator)
      mustBeA (this, 'table');
      hasIndicator = false;
      if nargin > 1
        hasIndicator = true;
      endif
      mustBeAllColVectorVars (this);
      out = false (size (this));
      for i = 1:width (this)
        if hasIndicator
          out(:,i) = ismissing (this.VariableValues{i}, indicator);
        else
          out(:,i) = ismissing (this.VariableValues{i});
        endif
      endfor
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.rmmissing
    ## @deftypefn {Method} {[@var{out}, @var{tf}] =} rmmissing (@var{obj})
    ## @deftypefnx {Method} {[@var{out}, @var{tf}] =} rmmissing (@var{obj}, @var{indicator})
    ## @deftypefnx {Method} {[@var{out}, @var{tf}] =} rmmissing (@dots{}, @code{'DataVariables'}, @var{vars})
    ## @deftypefnx {Method} {[@var{out}, @var{tf}] =} rmmissing (@dots{}, @code{'MinNumMissing'}, @var{minNumMissing})
    ##
    ## Remove rows with missing values.
    ##
    ## Removes the rows from @var{obj} that have missing values.
    ##
    ## If the 'DataVariables' option is given, only the data in the specified
    ## variables is considered.
    ##
    ## Returns:
    ##   @var{out} - A table the same as @var{obj}, but with rows with missing values removed.
    ##   @var{tf} - A logical index vector indicating which rows were removed.
    ##
    ## @end deftypefn
    function [out, tf] = rmmissing (this, varargin)
      [opts, args] = peelOffNameValueOptions (varargin, {'DataVariables','MinNumMissing'});
      hasIndicator = false;
      if numel (args) > 1
        error ('table.rmmissing: Too many arguments.');
      elseif numel (args) == 1
        hasIndicator = true;
        indicator = args{1};
      endif
      minNumMissing = 1;
      if isfield (opts, 'MinNumMissing')
        minNumMissing = opts.MinNumMissing;
      endif
      
      if isfield (opts, 'DataVariables')
        dataVarsSelector = opts.DataVariables;
        if isa (dataVarsSelector, 'function_handle')
          error ('table.rmmissing: function handle DataVariables option is not implemented.');
        else
          ixDataVars = resolveVarRef (dataVarsSelector);
        endif
      else
        ixDataVars = 1:width (this);
      endif
      
      dataVals = subsetvars (this, ixDataVars);
      if hasIndicator
        tfMissing = ismissing (dataVals, indicator);
      else
        tfMissing = ismissing (dataVals);
      endif
      nMissing = sum (tfMissing, 2);
      tfRowHasMissing = nMissing >= minNumMissing;
      out = subsetrows (this, ~tfRowHasMissing);
      tf = tfRowHasMissing;
    endfunction

    ## -*- texinfo -*-
    ## @node table.standardizeMissing
    ## @deftypefn {Method} {@var{out} =} standardizeMissing (@var{obj}, @var{indicator})
    ## @deftypefnx {Method} {@var{out} =} standardizeMissing (@dots{}, @code{'DataVariables'}, @var{vars})
    ##
    ## Insert standard missing values.
    ##
    ## Standardizes missing values in variable data.
    ##
    ## If the @var{DataVariables} option is supplied, only the indicated variables are 
    ## standardized.
    ##
    ## @var{indicator} is passed along to @code{standardizeMissing} when it is called on each
    ## of the data variables in turn. The same indicator is used for all
    ## variables. You can mix and match indicator types by just passing in 
    ## mixed indicator types in a cell array; indicators that don't match the
    ## type of the column they are operating on are just ignored.
    ##
    ## Returns a table with same variable names and types as @var{obj}, but with variable
    ## values standardized.
    ##
    ## @end deftypefn
    function out = standardizeMissing (this, indicator, varargin)
      narginchk (2, 4);
      mustBeA (this, 'table');
      [opts, args] = peelOffNameValueOptions (varargin, {'DataVariables'});
      if ~isempty (args)
        error ('table.standardizeMissing: Too many input arguments');
      endif

      if isfield (opts, 'DataVariables')
        dataVarsSelector = opts.DataVariables;
        if isa (dataVarsSelector, 'function_handle')
          error ('table.standardizeMissing: function handle DataVariables option is not implemented.');
        else
          ixDataVars = resolveVarRef (dataVarsSelector);
        endif
      else
        ixDataVars = 1:width (this);
      endif
      
      out = this;
      for i = 1:numel (ixDataVars)
        ixDataVar = ixDataVars(i);
        val = this.VariableValues{ixDataVar};
        standardized = standardizeMissing (val, indicator);
        out.VariableValues{ixDataVar} = standardized;
      endfor
      
    endfunction

    % Function application
    
    ## -*- texinfo -*-
    ## @node table.varfun
    ## @deftypefn {Method} {@var{out} =} varfun (@var{fcn}, @var{obj})
    ## @deftypefnx {Method} {@var{out} =} varfun (@dots{}, @code{'OutputFormat'}, @var{outputFormat})
    ## @deftypefnx {Method} {@var{out} =} varfun (@dots{}, @code{'InputVariables'}, @var{vars})
    ## @deftypefnx {Method} {@var{out} =} varfun (@dots{}, @code{'ErrorHandler'}, @var{errorFcn})
    ##
    ## Apply function to table variables.
    ##
    ## Applies the given function @var{fcn} to each variable in @var{obj},
    ## collecting the output in a table, cell array, or array of another type.
    ##
    ## @end deftypefn
    function out = varfun (func, A, varargin)
      mustBeA (A, 'table');
      validOptions = {'InputVariables', 'GroupingVariables', 'OutputFormat', 'ErrorHandler'};
      [opts, args] = peelOffNameValueOptions (varargin, validOptions);
      unimplementedOptions = {'GroupingVariables', 'ErrorHandler'};
      for i = 1:numel (unimplementedOptions)
        if isfield (opts, unimplementedOptions{i})
          error ('table.varfun: Option %s is not yet implemented.', unimplementedOptions{i});
        endif
      endfor
      if ~isa (func, 'function_handle')
        error ('table.varfun: func must be a function handle; got a %s', class (func));
      endif
      outputFormat = 'table';
      if isfield (opts, 'OutputFormat')
        outputFormat = opts.OutputFormat;
      endif
      validOutputFormats = {'table','uniform','cell'};
      if ~ismember (outputFormat, validOutputFormats);
        error ('table.varfun: Invalid OutputFormat: %s. Must be one of: %s', ...
          outputFormat, strjoin (validOutputFormats, ', '));
      endif
      errorHandler = [];
      if isfield (opts, 'ErrorHandler')
        if ~isa (opts.ErrorHandler, 'function_handle')
          error ('table.varfun: ErrorHandler must be a function handle; got a %s', ...
            class (opts.ErrorHandler));
        endif
        errorHandler = opts.ErrorHandler;
      endif
      
      tbl = A;
      if isfield (opts, 'InputVariables')
        ixInVars = resolveVarRef (tbl, opts.InputVariables);
      else
        ixInVars = 1:width (tbl);
      endif
      
      outVals = cell (1, numel (ixInVars));
      for i = 1:numel (ixInVars)
        ixInVar = ixInVars(i);
        varVal = tbl.VariableValues{ixInVar};
        if isempty (errorHandler)
          fcnOut = feval (func, varVal);
        else
          try
            fcnOut = feval (func, varVal);
          catch err
            fcnOut = feval (errorHandler, varVal);
          end_try_catch
        endif
        outVals{i} = fcnOut;
      endfor

      switch outputFormat
        case 'cell'
          out = outVals;
        case 'table'
          out = table (outVals{:}, 'VariableNames', tbl.VariableNames);
        case 'uniform'
          tfScalar = cellfun('isscalar', outVals);
          if ~all (tfScalar)
            ixFirstBad = find(~tfScalar, 1);
            error (['table.varfun: For OutputFormat ''uniform'', all function ' ...
              'outputs must be scalar; output %d was %d long'], ...
              ixFirstBad, numel (outVals{ixFirstBad}));
          endif
          outClasses = cellfun ('class', outVals, 'UniformOutput', false);
          uOutClasses = unique (outClasses);
          if numel (uOutClasses) > 1
            error (['table.varfun: For OutputFormat ''uniform'', all function ' ...
              'outputs must be the same type; got a mix of: %s'], ...
              strjoin (uOutClasses, ', '));
          endif
          out = cat (2, outVals{:});
      endswitch
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.rowfun
    ## @deftypefn {Method} {@var{out} =} varfun (@var{func}, @var{obj})
    ## @deftypefnx {Method} {@var{out} =} varfun (@dots{}, @code{'OptionName'}, @var{OptionValue}, @dots{})
    ##
    ## Apply function to rows in table and collect outputs.
    ##
    ## This applies the function @var{func} to the elements of each row of
    ## @var{obj}’s variables, and collects the concatenated output(s) into the
    ## variable(s) of a new table.
    ##
    ## @var{func} is a function handle. It should take as many inputs as there
    ## are variables in @var{obj}. Or, it can take a single input, and you must
    ## specify @code{'SeparateInputs', false} to have the input variables
    ## concatenated before being passed to @var{func}. It may return multiple
    ## argouts, but to capture those past the first one, you must explicitly
    ## specify the @code{'NumOutputs'} or @code{'OutputVariableNames'} options.
    ##
    ## Supported name/value options:
    ## @table @code
    ## @item 'OutputVariableNames'
    ## Names of table variables to store combined function output arguments in.
    ## @item 'NumOutputs'
    ## Number of output arguments to call function with. If omitted, defaults to
    ## number of items in @var{OutputVariableNames} if it is supplied, otherwise
    ## defaults to 1.
    ## @item 'SeparateInputs'
    ## If true, input variables are passed as separate input arguments to @var{func}.
    ## If false, they are concatenated together into a row vector and passed as
    ## a single argument. Defaults to true.
    ## @item 'ErrorHandler'
    ## A function to call as a fallback when calling @var{func} results in an error.
    ## It is passed the caught exception, along with the original inputs passed
    ## to @var{func}, and it has a “second chance” to compute replacement values
    ## for that row. This is useful for converting raised errors to missing-value
    ## fill values, or logging warnings.
    ## @item 'ExtractCellContents'
    ## Whether to “pop out” the contents of the elements of cell variables in 
    ## @var{obj}, or to leave them as cells. True/false; default is false. If
    ## you specify this option, then @var{obj} may not have any multi-column
    ## cell-valued variables.
    ## @item 'InputVariables'
    ## If specified, only these variables from @var{obj} are used as the function
    ## inputs, instead of using all variables.
    ## @item 'GroupingVariables'
    ## Not yet implemented.
    ## @item 'OutputFormat'
    ## The format of the output. May be @code{'table'} (the default), 
    ## @code{'uniform'}, or @code{'cell'}. If it is @code{'uniform'} or @code{'cell'},
    ## the output variables are returned in multiple output arguments from
    ## @code{'rowfun'}.
    ## @end table
    ##
    ## Returns a @code{table} whose variables are the collected output arguments
    ## of @var{func} if @var{OutputFormat} is @code{'table'}. Otherwise, returns
    ## multiple output arguments of whatever type @var{func} returned (if 
    ## @var{OutputFormat} is @code{'uniform'}) or cells (if @var{OutputFormat}
    ## is @code{'cell'}).
    ##
    ## @end deftypefn
    function varargout = rowfun (func, A, varargin)
      % TODO: Document all the Name/Value options; there's a bunch of them.
      % TODO: Implement the remaining options.
      
      % Input handling
      mustBeA (func, 'function_handle');
      mustBeA (A, 'table');
      validOptions = {'InputVariables', 'GroupingVariables', 'OutputFormat', ...
        'SeparateInputs', 'ExtractCellContents', 'OutputVariableNames', ...
        'NumOutputs', 'ErrorHandler'};
      [opts, args] = peelOffNameValueOptions (varargin, validOptions);
      unimplementedOptions = {'GroupingVariables'};
      for i = 1:numel (unimplementedOptions)
        if isfield (opts, unimplementedOptions{i})
          error ('table.rowfun: Option %s is not yet implemented.', unimplementedOptions{i});
        endif
      endfor
      if ~isa (func, 'function_handle')
        error ('table.rowfun: func must be a function handle; got a %s', class (func));
      endif
      output_format = 'table';
      if isfield (opts, 'OutputFormat')
        output_format = opts.OutputFormat;
      endif
      validOutputFormats = {'table','uniform','cell'};
      if ~ismember (outputFormat, validOutputFormats);
        error ('table.rowfun: Invalid OutputFormat: %s. Must be one of: %s', ...
          outputFormat, strjoin (validOutputFormats, ', '));
      endif
      errorHandler = [];
      if isfield (opts, 'ErrorHandler')
        if ~isa (opts.ErrorHandler, 'function_handle')
          error ('table.rowfun: ErrorHandler must be a function handle; got a %s', ...
            class (opts.ErrorHandler));
        endif
        errorHandler = opts.ErrorHandler;
      endif
      tbl = A;
      n_out_args = [];
      if isfield (opts, 'NumOutputs')
        mustBeScalar (opts.NumOutputs, 'opts.NumOutputs');
        mustBeNumeric (opts.NumOutputs, 'opts.NumOutputs');
        n_out_args = opts.NumOutputs;
      endif
      if isfield (opts, 'OutputVariableNames')
        out_var_names = opts.OutputVariableNames;
        n_out_args = numel (out_var_names);
        mustBeCellstr (out_var_names, 'opts.OutputVariableNames');
      else
        if isempty (n_out_args)
          n_out_args = 1;
        endif
        out_var_names = cell (1, n_out_args);
        for i = 1:n_out_args
          out_var_names = sprintf ("out%d", i);
        endfor
      endif
      do_separate_inputs = true;
      if isfield (opts, 'SeparateInputs')
        do_separate_inputs = opts.SeparateInputs;
      endif
      do_extract_cell_contents = false;
      if isfield (opts, 'ExtractCellContents')
        mustBeScalarLogical (opts.ExtractCellContents, 'opts.ExtractCellContents');
        do_extract_cell_contents = opts.ExtractCellContents;
      endif
      if do_extract_cell_contents
        for i = 1:width (this)
          if iscell (this.VariableValues{i}) && size (this.VariableValues{i}, 2) > 1
            error (['table.rowfun: Calling rowfun on a table with multi-column cell ' ...
              'variables is not supported when ''ExtractCellContents'' is true' ...
              '(bad variable: %s)'], this.VariableNames{i});
          endif
        endfor
      endif
      if isfield (opts, 'InputVariables')
        this = subsetvars (this, opts.InputVariables);
      endif
      
      % Function application
      vars = this.VariableValues;
      n_vars = numel (vars);
      out_bufs = repmat ({cell(height(this), 1)}, [1 n_out_args]);
      for i_row = 1:height (this)
        args = cell (1, n_vars);
        for i_var = 1:n_vars
          if do_extract_cell_contents && iscell (vars{i_var})
            args{i_var} = vars{i_var}{i_row};
          else
            args{i_var} = vars{i_var}(i_row,:);
          endif
        endfor
        argouts = cell (1, n_out_args);
        if do_separate_inputs
          if isempty (errorHandler)
            [argouts{:}] = func (args{:});
          else
            try
              [argouts{:}] = func (args{:});
            catch err
              [argouts{:}] = errorHandler (err, args{:});
            end_try_catch
          endif
        else
          single_input = [args{:}];
          if isempty (errorHandler)
            [argouts{:}] = func (single_input);
          else
            try
              [argouts{:}] = func (single_input);
            catch err
              [argouts{:}] = errorHandler (err, single_input);
            end_try_catch
          endif
        endif
        for i_out_arg = 1:n_out_args
          out_bufs{i_out_arg}{i_row} = argouts{i_out_arg};
        endfor
      endfor
      
      % Output packaging
      switch output_format
        case 'table'
          out_vars = cellfun(@(c) cat(1, c{:}), out_bufs);
          out = table (out_vars{:}, 'VariableNames', out_var_names);
          varargout = { out };
        case 'cell'
          varargout = out_vars;
        case 'uniform'
          varargout = cellfun(@(c) cat(1, c{:}), out_bufs);
        case 'timetable'
          error ('timetable is not yet implemented. Sorry.');
        otherwise
          error ('table.rowfun: Invalid OutputFormat: ''%s''', output_format);
      endswitch
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.findgroups
    ## @deftypefn {Method} {[@var{G}, @var{TID}] =} findgroups (@var{obj})
    ##
    ## Find groups within a table’s row values.
    ##
    ## Finds groups within a table’s row values and get group numbers. A group
    ## is a set of rows that have the same values in all their variable elements.
    ##
    ## Returns:
    ##   @var{G} - A double column vector of group numbers created from @var{obj}.
    ##   @var{TID} - A table containing the row values corresponding to the group numbers.
    ##
    ## @end deftypefn
    function [G, TID] = findgroups (this)
      %FINDGROUPS Find groups within a table's row values and get group numbers
      %
      % [G, TID] = findgroups (this)
      %
      % Returns:
      % G - A double column vector of group numbers created from this.
      % TID - A table containing the row values corresponding to the group numbers.
      [TID, ~, G] = unique (this);
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.evalWithVars
    ## @deftypefn {Method} {@var{out} =} evalWithVars (@var{obj}, @var{expr})
    ##
    ## Evaluate an expression against table’s variables.
    ##
    ## Evaluates the M-code expression @var{expr} in a workspace where all of @var{obj}’s
    ## variables have been assigned to workspace variables.
    ##
    ## @var{expr} is a charvec containing an Octave expression.
    ##
    ## As an implementation detail, the workspace will also contain some variables
    ## that are prefixed and suffixed with "__". So try to avoid those in your
    ## table variable names.
    ##
    ## Returns the result of the evaluation.
    ##
    ## Examples:
    ##
    ## @example
    ## [s,p,sp] = table_examples.SpDb
    ## tmp = join (sp, p);
    ## shipment_weight = evalWithVars (tmp, "Qty .* Weight")
    ## @end example
    ##
    ## @end deftypefn
    function out = evalWithVars (this, expr)
      if ~ischar (expr)
        error ('table.evalWithVars: expr must be char; got a %s', class (expr));
      endif
      out = __eval_expr_with_table_vars_in_workspace__ (this, expr);
    endfunction
    
    ## -*- texinfo -*-
    ## @node table.restrict
    ## @deftypefn {Method} {@var{out} =} restrict (@var{obj}, @var{expr})
    ## @deftypefnx {Method} {@var{out} =} restrict (@var{obj}, @var{ix})
    ##
    ## Subset rows using variable expression or index.
    ##
    ## Subsets a table row-wise, using either an index vector or an expression
    ## involving @var{obj}’s variables.
    ##
    ## If the argument is a numeric or logical vector, it is interpreted as an
    ## index into the rows of this. (Just as with `subsetrows (this, index)`.)
    ##
    ## If the argument is a char, then it is evaulated as an M-code expression,
    ## with all of this’ variables available as workspace variables, as with
    ## @code{evalWithVars}. The output of expr must be a numeric or logical index
    ## vector (This form is a shorthand for 
    ## @code{out = subsetrows (this, evalWithVars (this, expr))}.)
    ##
    ## TODO: Decide whether to name this to "where" to be more like SQL instead
    ## of relational algebra.
    ##
    ## Examples:
    ## @example
    ## [s,p,sp] = table_examples.SpDb;
    ## prettyprint (restrict (p, 'Weight >= 14 & strcmp(Color, "Red")'))
    ## @end example
    ##
    ## @end deftypefn
    function out = restrict (this, arg)
      if ischar (arg)
        rowIx = evalWithVars (this, arg);
        out = subsetrows (this, rowIx);
      elseif isnumeric (arg) || islogical (arg)
        out = subsetrows (this, arg);
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node table.renamevars
    ## @deftypefn {Method} {@var{out} =} renamevars (@var{obj}, @var{renameMap})
    ##
    ## Rename variables in a table.
    ##
    ## Renames selected variables in the table @var{obj} based on the mapping
    ## provided in @var{renameMap}.
    ##
    ## @var{renameMap} is an n-by-2 cellstr array, with the old variable names
    ## in the first column, and the corresponding new variable names in the
    ## second column.
    ##
    ## Variables which are not included in @var{renameMap} are not modified.
    ##
    ## It is an error if any variables named in the first column of @var{renameMap}
    ## are not present in @var{obj}.
    ##
    ## Renames 
    ## @end deftypefn
    function out = renamevars (this, renameMap)
      if ! iscellstr (renameMap) || size (renameMap, 2) ~= 2
        error ('renameMap must be an n-by-2 cellstr; got a %s %s', ...
          size2str (size (renameMap)), class (renameMap));
      endif
      [tf,loc] = ismember (renameMap(:,1), this.VariableNames);
      if ! all (tf)
        error ('No such variables in this: %s', strjoin (renameMap(~tf,1), ', '));
      endif
      out = this;
      out.VariableNames(loc) = renameMap(:,2);
    endfunction

    % Prohibited operations
    
    function out = shiftdims (this, varargin)
      %SHIFTDIMS Not supported
      error ('Function shiftdims is not supported for tables');
    end

    function out = reshape (this, varargin)
      %RESHAPE Not supported
      error ('Function reshape is not supported for tables');
    end

    function out = resize (this, varargin)
      %RESIZE Not supported
      error ('Function resize is not supported for tables');
    end

    function out = vec (this, varargin)
      %VEC Not supported
      error ('Function vec is not supported for tables');
    end
  end
  
  methods (Access = private)
    
    ## -*- texinfo -*-
    ## @node table.resolveVarRef
    ## @deftypefn {Method} {[@var{ixVar}, @var{varNames}] =} resolveVarRef (@var{obj}, @var{varRef})
    ## @deftypefnx {Method} {[@var{ixVar}, @var{varNames}] =} resolveVarRef (@var{obj}, @var{varRef}, @var{strictness})
    ##
    ## Resolve a variable reference against this table.
    ##
    ## A @var{varRef} is a numeric or char/cellstr indicator of which variables within
    ## @var{obj} are being referenced.
    ##
    ## @var{strictness} controls what to do when the given variable references
    ## could not be resolved. It may be 'strict' (the default) or 'lenient'.
    ##
    ## Returns:
    ##   @var{ixVar} - the indexes of the variables in @var{obj}
    ##   @var{varNames} - a cellstr of the names of the variables in @var{obj}
    ##
    ## Raises an error if any of the specified variables could not be resolved,
    ## unless strictness is 'lenient', in which case it will return 0 for the
    ## index and '' for the name for each variable which could not be resolved.
    ##
    ## @end deftypefn
    function [ixVar, varNames] = resolveVarRef (this, varRef, strictness)
      %RESOLVEVARREF Resolve a reference to variables
      %
      % A varRef is a numeric or char/cellstr indicator of which variables within
      % this table are being referenced.
      if nargin < 3 || isempty (strictness); strictness = 'strict'; end
      mustBeMember (strictness, {'strict','lenient'});
      if isnumeric (varRef) || islogical (varRef)
        ixVar = varRef;
        ix_bad = find(ixVar > width (this) | ixVar < 1);
        if ! isempty (ix_bad)
          error ('table: variable index out of bounds: %d (table has %d variables)', ...
            ix_bad(1), width (this));
        endif
      elseif isequal (varRef, ':')
        ixVar = 1:width (this);
      elseif ischar (varRef) || iscellstr (varRef)
        varRef = cellstr (varRef);
        [tf, ixVar] = ismember (varRef, this.VariableNames);
        if isequal (strictness, 'strict')
          if ~all (tf)
            error ('table: No such variable in table: %s', strjoin (varRef(~tf), ', '));
          endif
        else
          ixVar(~tf) = 0;
        endif
      elseif isa (varRef, 'octave.table.internal.vartype_filter')
        ixVar = [];
        for i = 1:width (this)
          if varRef.matches (this.VariableValues{i})
            ixVar(end+1) = i;
          endif
        endfor
      else
        error ('table: Unsupported variable indexing operand type: %s', class (varRef));
      end
      varNames = repmat ({''}, size (ixVar));
      varNames(ixVar != 0) = this.VariableNames(ixVar(ixVar != 0));
    end

    function [ixRow, ixVar] = resolveRowVarRefs (this, rowRef, varRef)
      %RESOLVEROWVARREFS Internal implementation method
      %
      % This resolves both row and variable refs to indexes.
      if isnumeric (rowRef) || islogical (rowRef)
        ixRow = rowRef;
      elseif iscellstr (rowRef)
        if isempty (this.RowNames)
          error ('table: this table has no RowNames');
        end
        [tf, ixRow] = ismember (rowRef, this.RowNames);
        if ~all (tf)
          error ('table: No such named row in table: %s', strjoin (rowRef(~tf), ', '));
        end
      elseif isequal (rowRef, ':')
        ixRow = 1:height (this);
      else
        error ('table: Unsupported row indexing operand type: %s', class (rowRef));
      end
      
      ixVar = resolveVarRef (this, varRef);
    end
    
    ## -*- texinfo -*-
    ## @node table.subsetrows
    ## @deftypefn {Method} {@var{out} =} subsetrows (@var{obj}, @var{ixRows})
    ##
    ## Subset table by rows.
    ##
    ## Subsets this table by rows.
    ##
    ## @var{ixRows} may be a numeric or logical index into the rows of @var{obj}.
    ##
    ## @end deftypefn
    function out = subsetrows (this, ixRows)
      out = this;
      if ~isnumeric (ixRows) && ~islogical (ixRows)
        % TODO: Hmm. Maybe we ought not to do this check, but just defer to the
        % individual variable values' indexing logic, so SUBSREF/SUBSINDX overrides
        % are respected. Would produce worse error messages, but be more "right"
        % type-wise.
        error ('table.subsetrows: ixRows must be numeric or logical; got a %s', ...
          class (ixRows));
      endif
      for i = 1:width (this)
        out.VariableValues{i} = out.VariableValues{i}(ixRows,:);
      end
      if ~isempty (this.RowNames)
        out.RowNames = out.RowNames(ixRows);
      end
    end
    
    ## -*- texinfo -*-
    ## @node table.subsetvars
    ## @deftypefn {Method} {@var{out} =} subsetvars (@var{obj}, @var{ixVars})
    ##
    ## Subset table by variables.
    ##
    ## Subsets table @var{obj} by subsetting it along its variables.
    ##
    ## ixVars may be:
    ##   - a numeric index vector
    ##   - a logical index vector
    ##   - ":"
    ##   - a cellstr vector of variable names
    ##
    ## The resulting table will have its variables reordered to match ixVars.
    ##
    ## @end deftypefn
    function out = subsetvars (this, ixVars)      
      if ischar (ixVars)
        if ~isequal (ixVars, ':')
          ixVars = cellstr (ixVars);
        endif
      endif
      if iscellstr (ixVars)
        [tf,ix] = ismember (ixVars, this.VariableNames);
        if ~all (tf)
          error ('table.subsetvars: no such variables in this table: %s', ...
            strjoin (ixVars(~tf), ', '));
        endif
        ixVars = ix;
      endif
      out = this;
      out.VariableNames = this.VariableNames(ixVars);
      out.VariableValues = this.VariableValues(ixVars);
    end
    
    function [outA, outB] = makeVarNamesUnique (A, B)
      %MAKEVARNAMESUNIQUE Internal implementation method
      seenNames = struct;
      namesA = A.VariableNames;
      for i = 1:numel (namesA)
        seenNames.(namesA{i}) = true;
      endfor
      namesB = B.VariableNames;
      newNamesB = cell (size (namesB));
      for i = 1:numel (namesB)
        oldName = namesB{i};
        newName = [];
        if ! isfield (seenNames, oldName)
          newName = oldName;
        else
          newBaseName = [oldName '_B'];
          if ! isfield (seenNames, newBaseName)
            newName = newBaseName;
          else
            n = 0;
            while true
              n = n + 1;
              candidate = sprintf('%s_%d', newBaseName, n);
              if ! isfield (seenNames, candidate)
                newName = candidate;
                break
              endif
            endwhile
          endif
        endif
        newNamesB{i} = newName;
        senNames.(newName) = true;
      endfor
      outA = A;
      outB = B;
      outB.VariableNames = newNamesB;
    endfunction
  
    function out = transpose_table (this)
      %TRANSPOSE_TABLE This is for table's internal use
      if ~hasrownames (this)
        error ('table.transpose: this must have RowNames, but it does not');
      endif
      tfRowNamesAreVarNames = cellfun(@isvarname, this.RowNames);
      if ~all (tfRowNamesAreVarNames)
        error ('table.transpose: Row names must all be valid variable names');
      endif
      c = table2cell (this);
      out = cell2table(c', 'VariableNames', this.RowNames, 'RowNames', this.VariableNames);
    endfunction

    function mustBeAllSameVars (varargin)
      %MUSTBEALLSAMEVARS Require that all inputs have the same-named columns
      args = varargin;
      if isempty (args)
        return
      endif
      varNames = args{1}.VariableNames;
      for i = 2:numel (args)
        if ~isequal (varNames, args{i}.VariableNames)
          error ('Inconsistent VariableNames.\n  Input 1: %s\n  Input %d: %s', ...
            strjoin (varNames, ', '), i, strjoin (args{i}.VariableNames, ', '));
        endif
      endfor
    endfunction
    
    function mustBeAllColVectorVars (this)
      %MUSTBEALLCOLVECTORVARS Require that all vars in this are vectors, not matrixes
      for i = 1:width (this)
        val = this.VariableValues{i};
        if size (val, 2) ~= 1
          error ('All variables in input must be vectors, but variable %d (''%s'') has %d columns', ...
            i, this.VariableNames{i}, size (val, 2));
        endif
      endfor
    endfunction
    
    function out = getProperties (this)
      %GETPROPERTIES Get object's properties as a struct
      %
      % This is just for the internal use of subsref/subsasgn for .Properties
      % access support.
      out = struct;
      out.VariableNames = this.VariableNames;
      out.VariableValues = this.VariableValues;
      out.RowNames = this.RowNames;
      out.DimensionNames = this.DimensionNames;
    endfunction
  endmethods
  
  methods
    function [pkA, pkB] = proxykeysForMatrixes (A, B)
      %PROXYKEYSFORMATRIXES Compute row proxy keys for tables
      %
      % [pkA, pkB] = proxykeysForMatrixes (A, B)
      %
      % Note: This is called "proxykeysForMatrixes", not "proxyKeysForTables", because
      % it overrides the generic proxykeysForMatrixes, and tables *are* matrixes.
      
      if nargin == 1
        mustBeA (A, 'table');
        pkA = proxykeysForOneTable (A);
      else  
        mustBeA (A, 'table');
        mustBeA (B, 'table');
        if width (A) != width (B)
          error ('table.proxykeysForMatrixes: Tables must be same width; got %d vs %d', ...
            width (A), width (B));
        endif
        [pkA, pkB] = proxykeysForTwoTables (A, B);
      endif
    endfunction
  endmethods

  methods (Access = private)
    
    function out = proxykeysForOneTable (this)
      varProxyKeys = cell (size (this.VariableNames));
      for iVar = 1:numel (this.VariableNames);
        varProxyKeys{iVar} = proxykeysForMatrixes (this.VariableValues{iVar});
      endfor
      out = cat (2, varProxyKeys{:});
    endfunction
    
    function [pkA, pkB] = proxykeysForTwoTables (A, B)
      varProxyKeysA = cell (size (A.VariableNames));
      varProxyKeysB = cell (size (B.VariableNames));
      for iVar = 1:numel (A.VariableNames)
        [varProxyKeysA{iVar}, varProxyKeysB{iVar}] = proxykeysForMatrixes (...
          A.VariableValues{iVar}, B.VariableValues{iVar});
      endfor
      pkA = cat (2, varProxyKeysA{:});
      pkB = cat (2, varProxyKeysB{:});
    endfunction
    
    % Summary stuff
    
    function summary_impl (this, format)
      if nargin < 2 || isempty (format); format = 'compact'; endif
      infos = {};
      for i_var = 1:width (this)
        infos{i_var} = summary_for_variable (this, i_var);
      endfor
      printf ("%s: %d %s by %d %s\n", class (this), height (this), this.DimensionNames{1}, ...
        width (this), this.DimensionNames{2});
      switch format
        case 'long'
          for i_var = 1:numel (infos)
            s = infos{i_var};
            printf ("%d: %s\n", i_var, s.name);
            if ! ismember (s.type, {"double", "string"})
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
          n_vars = width (this);
          for i = 1:vars_per_line:n_vars
            ix = i:min(n_vars, i+vars_per_line-1);
            ss = infos(ix);
            strss = cell (size (ss));
            for j = 1:numel (strss)
              s = ss{j};
              col = {};
              col{end+1} = sprintf ("%d: %s", i_var, s.name);
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
            for j = 1:numel (lines)
              printf ("%s\n", lines{j});
            endfor
          endfor
        otherwise
          error ('table.summary: invalid format: ''%s''', format);
      endswitch
    endfunction
    
    function out = summary_for_variable (this, ix)
      out.name = this.VariableNames{ix};
      x = this.VariableValues{ix};
      out.type = class (x);
      if size (x, 2) > 1
        out.info = {
          'Columns'   size(x, 2)
        };
      elseif isnumeric (x)
        out.info = summary_for_var_numeric (x);
      elseif iscategorical (x)
        out.info = summary_for_var_categorical (x);
      elseif isstring (x) || iscellstr (x)
        out.info = summary_for_var_string (x);
      else
        out.info = cell (0, 2);
      endif
    endfunction
  endmethods

endclassdef

function out = tablevar_dispstrs (x)
  if isa (x, "string")
    out = cellstr (x);
    out(ismissing (x)) = {"<missing>"};
  else
    out = dispstrs (x);
  endif
endfunction

function out = glue_row_strs (strss, n_pad_chars)
  pad = repmat (' ', [1 n_pad_chars]);
  n_cols = numel (strss);
  n_rows = max (cellfun (@numel, strss));
  widths = NaN (1, n_cols);
  for i = 1:numel(strss)
    strss{i}(end+1:n_rows) = {''};
    widths(i) = max (cellfun (@numel, strss{i}));
    for j = 1:numel(strss{i})
      if numel(strss{i}{j}) < widths(i)
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

function out = summary_for_var_numeric (x)
  x_min = min (x);
  x_mean = mean (x);
  x_max = max (x);
  x_prcts = prctile (x, [25 50 75]);
  out = {
    'Min.'      num2str(x_min)
    '1st Qu.'   num2str(x_prcts(1))
    'Median'    num2str(x_prcts(2))
    'Mean'      num2str(x_mean)
    '3rd Qu.'   num2str(x_prcts(3))
    'Max.'      num2str(x_max)
  };
endfunction

function out = summary_for_var_categorical (x)
  max_ctgs_to_list = 7;
  u_ctgs = unique (x (!ismissing (x)));
  n_ctgs = numel (u_ctgs);
  n_missing = numel (find (ismissing (x)));
  u_ctg_strs = dispstrs (u_ctgs);
  if n_ctgs <= max_ctgs_to_list
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

function out = summary_for_var_string (x)
  x = string (x);
  n_missing = numel (find (ismissing (x)));
  u_strs = unique (x (!ismissing (x)));
  # TODO: This redundancy calculation looks wrong. Figure out a real one.
  #redundancy = (numel(x) - n_missing) / numel(u_strs);
  out = {
    "Card."     num2str(numel(u_strs))
    "N. Miss."  num2str(n_missing)
    #"Redund."   num2str(redundancy)
  };
endfunction
