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
    function this = table(varargin)
      %TABLE Construct a new table
      %
      % t = table(var1, var2, ... varN)
      % t = table('Size', sz, 'VariableTypes', varTypes)
      % t = table(..., 'VariableNames', varNames)
      % t = table(..., 'RowNames', rowNames)
      % t = table
      
      args = varargin;
      
      % Peel off trailing options
      knownOpts = {'VariableNames', 'RowNames'};
      opts = struct;
      while numel(args) >= 3 && ismember(args{end-1}, knownOpts)
        opts.(args{end-1}) = args{end};
        args(end-1:end) = [];
      end
      
      % Calling form handling
      nargs = numel(args);
      if nargs == 3 && isequal(args{1}, 'Backdoor')
        % Undocumented form for internal use
        [varNames, varVals] = args{2:3};
      elseif nargs == 4 && isequal(args{1}, 'Size') && isequal(args{3}, 'VariableTypes')
        error('This constructor form is unimplemented');
      else
        varVals = args;
        if isfield(opts, 'VariableNames')
          varNames = opts.VariableNames;
        else
          varNames = cell(size(args));
          for i = 1:numel(args)
            varNames{i} = inputname(i);
            if isempty(varNames{i})
              varNames{i} = sprintf('Var%d', i);
            end
          end
        end
      end
      
      % Input validation
      if ~iscell(varVals) || (~isvector(varVals) && ~isempty(varVals))
        error('VariableValues must be a cell vector');
      end
      if ~iscellstr(varNames) || (~isvector(varNames) && ~isempty(varNames))
        error('VariableNames must be a cellstr vector');
      end
      varNames = varNames(:)';
      varVals = varVals(:)';
      if numel(varNames) ~= numel(varVals)
        error('Inconsistent number of VariableNames (%d) and VariableValues (%d)', ...
         numel(varNames), numel(varVals));
      end
      for i = 1:numel(varNames)
        if ~isvarname(varNames{i})
          error('Invalid VariableName: ''%s''', varNames{i});
        end
      end
      if ~isempty(varVals)
        nrows = size(varVals{1}, 1);
        for i = 2:numel(varVals)
          nrows2 = size(varVals{i}, 1);
          if nrows ~= nrows2
            error('Inconsistent sizes: var 1 (%s) is %d rows; var %d (%s) is %d rows', ...
              varNames{1}, nrows, i, varNames{i}, nrows2);
          end
        end
      end
      [uqNames,ix] = unique(varNames);
      if numel(uqNames) < numel(varNames)
        ixBad = 1:numel(varNames);
        ixBad(ix) = [];
        error('Duplicate VariableNames: %s', strjoin(varNames(ixBad), ', '));
      end

      % Construction
      this.VariableNames = varNames;
      this.VariableValues = varVals;
      if isfield(opts, 'RowNames')
        this.RowNames = opts.RowNames;
      end
    end
    
    % Structural stuff
    
    function out = size(this)
      out = [height(this), width(this)];
    end
    
    function out = ndims(this)
      out = 2;
    end
    
    function out = height(this)
      if isempty(this.VariableValues)
        out = 0;
      else
        out = size(this.VariableValues{1}, 1);
      end
    end
    
    function out = width(this)
      out = numel(this.VariableNames);
    end
    
    function out = numel(this)
      n = 0;
      for i = 1:numel(this.VariableValues)
        n = n + numel(this.VariableValues{i});
      end
      out = n;
    end
    
    function out = isempty(this)
      out = isempty(this.VariableNames);
    end
    
    function out = ismatrix(this)
      out = true;
    end
    
    function out = isrow(this)
      out = height(this) == 1;
    end
    
    function out = iscol(this)
      out = width(this) == 1;
    end
    
    function out = isvector(this)
      out = isrow(this) || iscol(this);
    end
    
    function out = isscalar(this)
      out = height(this) == 1 && width(this) == 1;
    end
    
    function out = vertcat(varargin)
      args = varargin;
      for i = 1:numel(args)
        if ~isa(args{i}, 'table')
          args{i} = table(args{i});
        end
      end
      mustBeAllSameCols(args{:});
      out = args{1};
      for i = 2:numel(args)
        if isempty(out.RowNames)
          if ~isempty(args{i}.RowNames)
            error('Cannot cat tables with mixed empty and non-empty RowNames');
          end
        else
          out.RowNames = [out.RowNames; args{i}.RowNames];
        end
        for iCol = 1:width(out)
          out.VariableValues{iCol} = [out.VariableValues{iCol}; args{i}.VariableValues{iCol}];
        end
      end
    end
    
    function out = horzcat(varargin)
      args = varargin;
      seen_names = args{1}.VariableNames;
      for i = 2:numel(args)
        dup_names = intersect(seen_names, args{i}.VariableNames);
        if ~isempty(dup_names)
          error('Inputs have duplicate VariableNames: %s', strjoin(dup_names, ', '));
        end
        seen_names = [seen_names args{i}.VariableNames];
      end
    end
    
    function out = subsref(this, s)
      chain_s = s(2:end);
      s = s(1);
      switch s(1).type
        case '()'
          if numel(s.subs) ~= 2
            error('()-indexing of table requires exactly two arguments');
          end
          [ixRow, ixCol] = resolveRowColRefs(this, s.subs{1}, s.subs{2});
          out = this;
          out = subsetRows(out, ixRow);
          out = subsetCols(out, ixCol);
        case '{}'
          if numel(s.subs) ~= 2
            error('{}-indexing of table requires exactly two arguments');
          end
          [ixRow, ixCol] = resolveRowColRefs(this, s.subs{1}, s.subs{2});
          if numel(ixRow) ~= 1 && numel(ixCol) ~= 1
            error('{}-indexing of table requires one of the inputs to be scalar');
          end
          % I'm not sure how to handle the signature here yet
          if numel(ixCol) > 1
            error('{}-indexing across multiple columns is currently unimplemented');
          end
          if numel(ixRow) > 1
            error('{}-indexing across multiple rows is currently unimplemented');
          end
          colData = this.VariableValues{ixCol};
          out = colData(ixRow);
        case '.'
          name = s.subs;
          if ~ischar(name)
            error('.-reference arguments must be char');
          end
          out = getVar(this, name);
      end
      % Chained references
      if ~isempty(chain_s)
        out = subsref(out, chain_s);
      end
    end
    
    function out = subsasgn(this, s, val)
      %SUBSASGN Subscripted assignment
      chain_s = s(2:end);
      s = s(1);
      out = this;
      switch s(1).type
        case '()'
          error('Assignment using ()-indexing is not supported for table');
        case '{}'
          rhs = val;
          if numel(s.subs) ~= 2
            error('{}-indexing of table requires exactly two arguments');
          end
          [ixRow, ixCol] = resolveRowColRefs(this, s.subs{1}, s.subs{2});
          if ~isscalar(ixCol)
            error('{}-indexing must reference a single variable; got %d', ...
              numel(ixCol));
          end
          colData = this.VariableValues{ixCol};
          if ~isempty(chain_s)
            error('Chained {}-indexing is not implemented. Sorry.');
          end
          colData(ixRow) = val;
          out.VariableValues{ixCol} = colData;
        case '.'
          out = setCol(this, s.subs, val);
      end
    end
    
    function ixCol = resolveColRef(this, colRef)
      if isnumeric(colRef) || islogical(colRef)
        ixCol = colRef;
      elseif ischar(colRef) || iscellstr(colRef)
        colRef = cellstr(colRef);
        [tf,ixCol] = ismember(colRef, this.VariableNames);
        if ~all(tf)
          error('No such variable in table: %s', strjoin(colRef(~tf), ', '));
        end
      elseif isequal(colRef, ':')
        ixCol = 1:width(this);
      else
        error('Unsupported column indexing operand type: %s', class(colRef));
      end
    end

    function [ixRow,ixCol] = resolveRowColRefs(this, rowRef, colRef)
      if isnumeric(rowRef) || islogical(rowRef)
        ixRow = rowRef;
      elseif iscellstr(rowRef)
        if isempty(this.RowNames)
          error('this table has no RowNames');
        end
        [tf,ixRow] = ismember(rowRef, this.RowNames);
        if ~all(tf)
          error('No such named row in table: %s', strjoin(rowRef(~tf), ', '));
        end
      elseif isequal(rowRef, ':')
        ixRow = 1:width(this);
      else
        error('Unsupported row indexing operand type: %s', class(rowRef));
      end
      
      ixCol = resolveColRef(this, colRef);
    end
    
    function out = subsetRows(this, ixRows)
      out = this;
      for i = 1:width(this)
        out.VariableValues{i} = out.VariableValues{i}(ixRows,:);
      end
      if ~isempty(this.RowNames)
        out.RowNames = out.RowNames(ixRows);
      end
    end
    
    function out = subsetCols(this, ixCols)
      out = this;
      out.VariableNames = this.VariableNames(ixCols);
      out.VariableValues = this.VariableValues(ixCols);
    end
    
    function out = setcol(this, colRef, value)
      ixCol = resolveColRef(this, colRef);
      out = this;
      if size(value, 1) ~= height(this)
        error('Inconsistent dimensions: table is height %d, input is height %d', ...
          height(this), size(value, 1));
      end
      out.VariableValues{ixCol} = value;
    end

    % Display
    
    function display(this)
      %DISPLAY Custom display.
      in_name = inputname(1);
      if ~isempty(in_name)
        fprintf('%s =\n', in_name);
      end
      disp(this);
    end

    function disp(this)
      %DISP Custom display.
      if isempty(this)
        fprintf('Empty %s %s\n', size2str(size(this)), class(this));
      else
        fprintf('table: %d rows x %d variables\n', height(this), width(this));
        fprintf('  VariableNames: %s\n', strjoin(this.VariableNames, ', '));
      end
    end
    
    function prettyprint(this)
      %PRETTYPRINT Display table values, formatted as a table
      if isempty(this)
        fprintf('Empty %s %s\n', size2str(size(this)), class(this));
        return;
      end
      nCols = width(this);
      colNames = this.VariableNames;
      colStrs = cell(1, nCols);
      colWidths = NaN(1, nCols);
      for iVar = 1:numel(this.VariableValues)
        vals = this.VariableValues{iVar};
        strs = dispstrs(vals);
        lines = cell(height(this), 1);
        for iRow = 1:size(strs, 1)
          lines{iRow} = strjoin(strs(iRow,:), '   ');
        end
        colStrs{iVar} = lines;
        colWidths(iVar) = max(cellfun('numel', lines));
      end
      colWidths;
      nameWidths = cellfun('numel', colNames);
      colWidths = max([nameWidths; colWidths]);
      totalWidth = sum(colWidths) + 4 + (3 * (nCols-1));
      elementStrs = cat(2, colStrs{:});
      
      rowFmts = cell(1, nCols);
      for i = 1:nCols
        rowFmts{i} = ['%-' num2str(colWidths(i)) 's'];
      end
      rowFmt = ['| ' strjoin(rowFmts, ' | ')  ' |' sprintf('\n')];
      fprintf('%s\n', repmat('-', [1 totalWidth]));
      fprintf(rowFmt, colNames{:});
      fprintf('%s\n', repmat('-', [1 totalWidth]));
      for i = 1:height(this)
        fprintf(rowFmt, elementStrs{i,:});
      end
      fprintf('%s\n', repmat('-', [1 totalWidth]));
    end
    
    % Prohibited operations

    function out = transpose(this,varargin)
      error('Function transpose is not supported for tables');
    end

    function out = ctranspose(this,varargin)
      error('Function ctranspose is not supported for tables');
    end

    function out = circshift(this,varargin)
      error('Function circshift is not supported for tables');
    end

    function out = length(this,varargin)
      error('Function length is not supported for tables');
    end

    function out = shiftdims(this,varargin)
      error('Function shiftdims is not supported for tables');
    end
  end
  
  methods (Access = private)
    function out = getVar(this, name)
      [tf,loc] = ismember(name, this.VariableNames);
      if ~tf
        error('table has no variable named ''%s''', name);
      end
      out = this.VariableValues{loc};
    end
  end
end


function mustBeAllSameCols(varargin)
  args = varargin;
  if isempty(args)
    return
  end
  colNames = args{1}.VariableNames;
  for i = 2:numel(args)
    if ~isequal(colNames, args{i}.VariableNames)
      error('Inconsistent VariableNames.\n  Input 1: %s\n  Input %d: %s', ...
        strjoin(colNames, ', '), i, strjoin(args{i}.VariableNames, ', '));
    end
  end
end

function out = size2str(sz)
%SIZE2STR Format an array size for display
%
% out = size2str(sz)
%
% Sz is an array of dimension sizes, in the format returned by SIZE.
%
% Examples:
%
% size2str(magic(3))

strs = cell(size(sz));
for i = 1:numel(sz)
	strs{i} = sprintf('%d', sz(i));
end

out = strjoin(strs, '-by-');
end

function out = dispstrs(x)
  if isnumeric(x) || islogical(x)
    out = reshape(strtrim(cellstr(num2str(x(:)))), size(x));
  elseif iscellstr(x) || isa(x, 'string')
    out = cellstr(x);
  elseif isa(x, 'datetime')
    out = datestrs(x);    
  elseif ischar(x)
    out = num2cell(x);
  else
    out = repmat({sprintf('1-by-1 %s', class(x))}, size(x));
  end
end
