function out = struct2table (s, varargin)
  %STRUCT2TABLE Convert struct to table
  
  % Peel off trailing options
  [opts, args] = peelOffNameValueOptions (varargin, {'AsArray'});
  if isfield (opts, 'AsArray') && opts.AsArray
    error ('AsArray option is currently unimplemented');
  endif
  if ~isempty (args)
    error ('Unrecognized options');
  endif

  varNames = fieldnames (s);
  if isscalar (s)
    varValues = struct2cell (s);
    out = table (varValues{:}, 'VariableNames', varNames);
  else
    s = s(:);
    c = struct2cell (s);
    c = c';
    out = cell2table (c, 'VariableNames', varNames);
  end
  
endfunction
