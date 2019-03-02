classdef table
  %TABLE Tabular data array
  %
  % A tabular data structure that collects multiple parallel named variables.
  % Each variable is treated like a column (possibly a multi-column column).
  % The types of variables may be heterogeneous.
  %
  % A table object is like an SQL table or resultset, or a relation, or a 
  % DataFrame in R or Pandas.
  
  properties
    % The names of the variables (columns), as cellstr
    VariableNames = {}
    % The values of the variables, as a cell vector of arbitrary types
    VariableValues = {}
    % Optional row names, as cellstr
    RowNames = []
  end
  
  methods
    function this = table (varargin)
      %TABLE Construct a new table
      %
      % t = table (var1, var2, ... varN)
      % t = table ('Size', sz, 'VariableTypes', varTypes)
      % t = table (..., 'VariableNames', varNames)
      % t = table (..., 'RowNames', rowNames)
      % t = table
      
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
      end
    end
    
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
      colStrs = cell (1, nVars);
      colWidths = NaN (1, nVars);
      for iVar = 1:numel (this.VariableValues)
        vals = this.VariableValues{iVar};
        strs = dispstrs (vals);
        lines = cell (height(this), 1);
        for iRow = 1:size (strs, 1)
          lines{iRow} = strjoin (strs(iRow,:), '   ');
        end
        colStrs{iVar} = lines;
        colWidths(iVar) = max (cellfun ('numel', lines));
      end
      colWidths;
      nameWidths = cellfun ('numel', varNames);
      colWidths = max ([nameWidths; colWidths]);
      totalWidth = sum (colWidths) + 4 + (3 * (nVars - 1));
      elementStrs = cat (2, colStrs{:});
      
      rowFmts = cell (1, nVars);
      for i = 1:nVars
        rowFmts{i} = ['%-' num2str(colWidths(i)) 's'];
      end
      rowFmt = ['| ' strjoin(rowFmts, ' | ')  ' |' sprintf('\n')];
      fprintf ('%s\n', repmat ('-', [1 totalWidth]));
      fprintf (rowFmt, varNames{:});
      fprintf ('%s\n', repmat ('-', [1 totalWidth]));
      for i = 1:height (this)
        fprintf (rowFmt, elementStrs{i,:});
      end
      fprintf ('%s\n', repmat ('-', [1 totalWidth]));
    end
    
    % Structural stuff
    
    function out = istable (this)
      out = true;
    endfunction

    function out = size (this)
      out = [height (this), width (this)];
    end
    
    function out = ndims (this)
      out = 2;
    end
    
    function out = height (this)
      if isempty (this.VariableValues)
        out = 0;
      else
        out = size (this.VariableValues{1}, 1);
      end
    end
    
    function out = width (this)
      out = numel (this.VariableNames);
    end
    
    function out = numel (this)
      n = 0;
      for i = 1:numel (this.VariableValues)
        n = n + numel (this.VariableValues{i});
      end
      out = n;
    end
    
    function out = isempty (this)
      out = isempty (this.VariableNames);
    end
    
    function out = ismatrix (this)
      out = true;
    end
    
    function out = isrow (this)
      out = height (this) == 1;
    end
    
    function out = iscol (this)
      out = width (this) == 1;
    end
    
    function out = isvector (this)
      out = isrow (this) || iscol (this);
    end
    
    function out = isscalar (this)
      out = height (this) == 1 && width (this) == 1;
    end
    
    function out = hasrownames (this)
      out = ~isempty (this.RowNames);
    endfunction
    
    function out = vertcat (varargin)
      args = varargin;
      for i = 1:numel (args)
        if ~isa (args{i}, 'table')
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
    
    function out = horzcat (varargin)
      %HORZCAT Horizontal concatenation
      %
      % Inputs must have all distinct variable names.
      %
      % Output has the same RowNames as varargin{1}. The variable names and values
      % are the result of the concatenation of the variable names and values lists
      % from the inputs.
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
    
    function out = subsref (this, s)
      chain_s = s(2:end);
      s = s(1);
      switch s(1).type
        case '()'
          if numel (s.subs) ~= 2
            error ('table.subsref: ()-indexing of table requires exactly two arguments');
          end
          [ixRow, ixVar] = resolveRowVarRefs (this, s.subs{1}, s.subs{2});
          out = this;
          out = subsetRows (out, ixRow);
          out = subsetCols (out, ixVar);
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
          out = getVar (this, name);
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
            error('table.subsasgn: {}-indexing of table requires exactly two arguments');
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
          out = setCol (this, s.subs, rhs);
      end
    end
    
    function ixVar = resolveVarRef (this, varRef)
      %RESOLVEVARREF Resolve a reference to variables
      %
      % A varRef is a numeric or char/cellstr indicator of which variables within
      % this table are being referenced.
      if isnumeric (varRef) || islogical (varRef)
        ixVar = varRef;
      elseif isequal (varRef, ':')
        ixVar = 1:width (this);
      elseif ischar (varRef) || iscellstr (varRef)
        varRef = cellstr (varRef);
        [tf, ixVar] = ismember (varRef, this.VariableNames);
        if ~all (tf)
          error ('table.resolveVarRef: No such variable in table: %s', strjoin (varRef(~tf), ', '));
        end
      else
        error ('table.resolveVarRef: Unsupported variable indexing operand type: %s', class (varRef));
      end
    end

    function [ixRow, ixVar] = resolveRowVarRefs (this, rowRef, varRef)
      if isnumeric (rowRef) || islogical (rowRef)
        ixRow = rowRef;
      elseif iscellstr (rowRef)
        if isempty (this.RowNames)
          error ('table.resolveRowVarRefs: this table has no RowNames');
        end
        [tf, ixRow] = ismember (rowRef, this.RowNames);
        if ~all (tf)
          error ('table.resolveRowVarRefs: No such named row in table: %s', strjoin (rowRef(~tf), ', '));
        end
      elseif isequal (rowRef, ':')
        ixRow = 1:width (this);
      else
        error ('table.resolveRowVarRefs: Unsupported row indexing operand type: %s', class (rowRef));
      end
      
      ixVar = resolveVarRef (this, varRef);
    end
    
    function out = subsetRows (this, ixRows)
      out = this;
      if ~isnumeric (ixRows) && ~islogical (ixRows)
        % TODO: Hmm. Maybe we ought not to do this check, but just defer to the
        % individual variable values' indexing logic, so SUBSREF/SUBSINDX overrides
        % are respected. Would produce worse error messages, but be more "right"
        % type-wise.
        error ('table.subsetRows: ixRows must be numeric or logical; got a %s', ...
          class (ixRows));
      endif
      for i = 1:width (this)
        out.VariableValues{i} = out.VariableValues{i}(ixRows,:);
      end
      if ~isempty (this.RowNames)
        out.RowNames = out.RowNames(ixRows);
      end
    end
    
    function out = subsetVars (this, ixVars)
      %SUBSETVARS Subset this along its variables

      if ischar (ixVars)
        if ~isequal (ixVars, ':')
          ixVars = cellstr (ixVars);
        endif
      endif
      if iscellstr (ixVars)
        [tf,ix] = ismember (ixVars, this.VariableNames);
        if ~all (tf)
          error ('table.subsetVars: no such variables in this table: %s', ...
            strjoin (ixVars(~tf), ', '));
        endif
        ixVars = ix;
      endif
      out = this;
      out.VariableNames = this.VariableNames(ixVars);
      out.VariableValues = this.VariableValues(ixVars);
    end
    
    function out = setvar (this, varRef, value)
      %SETVAR Set value for a variable
      %
      % This sets (replaces) the value for a variable that already exists in this.
      % It cannot be used to add a new variable.
      ixVar = resolveVarRef (this, varRef);
      out = this;
      if size (value, 1) ~= height (this)
        error ('table.setvar: Inconsistent dimensions: table is height %d, input is height %d', ...
          height (this), size (value, 1));
      end
      out.VariableValues{ixVar} = value;
    end
    
    % Relational operations
    
    function [out, index] = sortrows (this, varargin)
      %SORTROWS Sort rows of table
      
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
        out = subsetRows (this, index);
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
          %TODO: Add support for Octave-style negative column indexes.
          %TODO: Wrap this arg munging logic in a sortrows_matlabby() function
          %TODO: Better error message when optArgs are is present.
          if isequal (directions{iVar}, 'descend')
            [~, ix] = sortrows (varVal, -1 * (1:size (varVal, 2)), optArgs{:});
          else
            [~, ix] = sortrows (varVal, optArgs{:});
          endif
          index = index(ix);
          tmp = subsetRows (tmp, ix);
        endfor
        out = subsetRows (this, index);
      endif
    endfunction
    
    function [out, indx] = unique (this)
      %UNIQUE Unique row values
      pk = proxykeysForMatrixes (this);
      [uPk, indx] = unique (pk, 'rows');
      out = subsetRows (this, indx);
    endfunction
    
    function [C, ib] = join (A, B, varargin)
      %JOIN Combine two tables by rows using key variables
      %
      % This is not a full relational join operation. It has the restrictions
      % that:
      %  1) The key values in B must be unique. 
      %  2) Every key value in A must map to a key value in B.
      % These are restrictions inherited from the Matlab definition of table.join.
      
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
      if !isa (A, 'table')
        A = table (A);
      endif
      if !isa (B, 'table')
        B = table (B);
      endif
      
      % Join logic
      keyVarNames = intersect_stable (A.VariableNames, B.VariableNames);
      nonKeyVarsB = setdiff_stable (B.VariableNames, keyVarNames);
      if isempty (keyVarNames)
        error ('table.join: Cannot join: inputs have no variable names in common');
      endif
      keysA = subsetVars (A, keyVarNames);
      keysB = subsetVars (B, keyVarNames);
      uKeysB = unique (keysB);
      if height (uKeysB) < height (keysB)
        error ('table.join: Non-unique keys in B');
      endif
      [pkA, pkB] = proxykeysForMatrixes (keysA, keysB);
      [tf, ib] = ismember (pkA, pkB, 'rows');
      if ~all (tf)
        error ('table.join: Some rows in A had no corresponding key values in B');
      endif
      outA = A;
      nonKeysB = subsetVars (B, nonKeyVarsB);
      outB = subsetRows (nonKeysB, ib);
      C = [outA outB];
    endfunction

    function [out, ixs] = realjoin(A, B)
      %REALJOIN "Real" relational inner join, without key restrictions
      %
      % [out, ixs] = realjoin(A, B)
      %
      % Performs a "real" relational natural inner join between two tables, 
      % without the key restrictions that JOIN imposes.
      %
      % Returns:
      %   out - a table containing the result of joining A and B, with RowNames
      %         removed.
      %   ixs - an n-by-2 double matrix where ixs(i,:) is [ixA ixB], which are
      %         the indexes from A and B containing the input rows that resulted
      %         in this output row.
      %
      % RowNames on the output may be added in a future revision.
      %
      % This is an Octave extension.
      
      % Input handling
      if !isa (A, 'table')
        A = table (A);
      endif
      if !isa (B, 'table')
        B = table (B);
      endif
      if hasrownames (A)
        error ('table.realjoin: Input A may not have row names');
      endif
      if hasrownames (B)
        error ('table.realjoin: Input B may not have row names');
      endif
      
      % Join logic
      keyVarNames = intersect_stable (A.VariableNames, B.VariableNames);
      nonKeyVarsB = setdiff_stable (B.VariableNames, keyVarNames);
      if isempty (keyVarNames)
        error ('table.realjoin: Cannot join: inputs have no variable names in common');
      endif
      keysA = subsetVars (A, keyVarNames);
      keysB = subsetVars (B, keyVarNames);
      [pkA, pkB] = proxykeysForMatrixes (keysA, keysB);
      ixs = matchrows (pkA, pkB);
      outA = subsetRows (A, ixs(:,1));
      nonKeysB = subsetVars (B, nonKeyVarsB);
      outB = subsetRows (nonKeysB, ixs(:,2));
      out = [outA outB];

    endfunction
    
    % Prohibited operations

    function out = transpose (this,varargin)
      error ('Function transpose is not supported for tables');
    end

    function out = ctranspose (this,varargin)
      error ('Function ctranspose is not supported for tables');
    end

    function out = circshift (this,varargin)
      error ('Function circshift is not supported for tables');
    end

    function out = length (this,varargin)
      error ('Function length is not supported for tables');
    end

    function out = shiftdims (this,varargin)
      error ('Function shiftdims is not supported for tables');
    end
  end
  
  methods (Access = private)
    function out = getVar (this, name)
      [tf, loc] = ismember (name, this.VariableNames);
      if ~tf
        error ('table has no variable named ''%s''', name);
      endif
      out = this.VariableValues{loc};
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
  endmethods
  
  methods
    function [pkA, pkB] = proxykeysForMatrixes (A, B)
      %PROXYKEYSFORMATRIXES Compute row proxy keys for tables
      if nargin == 1
        mustBeType (A, 'table');
        pkA = proxykeysForOneTable (A);
      else  
        mustBeType (A, 'table');
        mustBeType (B, 'table');
        if !isequal (A.VariableNames, B.VariableNames)
          error ('table.proxykeysForMatrixes: Inconsistent variable names in inputs');
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
  endmethods
endclassdef
