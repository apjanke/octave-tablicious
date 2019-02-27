function [opts, remainingArgs] = peelOffNameValueOptions (args, knownOpts)
  %PEELOFFNAMEVALUEOPTIONS Peel off name-value options from argins
  %
  % Peels off recognized name-value options from the end of an argument array.
  opts = struct;
  while numel (args) >= 2 && ischar (args{end-1}) && ismember (args{end-1}, knownOpts)
    opts.(args{end-1}) = args{end};
    args(end-1:end) = [];
  end
  remainingArgs = args;  
endfunction
