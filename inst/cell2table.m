function out = cell2table(c, varargin)
  %CELL2TABLE Convert a cell array to a table

  if ~iscell (c)
    error ('Input must be cell; got %s', class (c));
  endif
  if ndims (c) > 2
    error ('Input must be 2-D; got %d-D', ndims (c));
  endif
  
  % Peel off trailing options
  [opts, args] = peelOffNameValueOptions (varargin, {'VariableNames', 'RowNames'});  
  if ~isempty (args)
    error ('Unrecognized options');
  endif

  nCols = size (c, 2);
  colVals = cell (1, nCols);
  for iCol = 1:nCols
    if iscellstr (c(:,iCol))
      % Special-case char conversion
      colVals{iCol} = c(:,iCol);
    else
      % Cheap hack to test for cat-ability
      try
        x = cat (1, c{:,iCol});
        if size (x, 1) == size (c, 1)
          colVals{iCol} = x;
          continue
        endif
      catch
        % Nope, couldn't cat. Fall through.
      end
      colVals{iCol} = c(:,iCol);
    endif
  endfor
  
  if isfield (opts, 'VariableNames')
    varNames = opts.VariableNames;
  else
    varNames = cell (1, nCols);
    for iCol = 1:nCols
      varNames{iCol} = sprintf('Var%d', iCol);
    endfor
  endif
  
  optArgs = {'VariableNames', varNames};
  if isfield (opts, 'RowNames')
    optArgs = [optArgs {'RowNames', opts.RowNames}];
  endif
  out = table (colVals{:}, optArgs{:});  
endfunction
