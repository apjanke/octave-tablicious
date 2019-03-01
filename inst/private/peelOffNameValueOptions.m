function [opts, remainingArgs, peeledArgs] = peelOffNameValueOptions (args, knownOpts)
  %PEELOFFNAMEVALUEOPTIONS Peel off name-value options from argins
  %
  % Peels off recognized name-value options from the end of an argument array.
  opts = struct;
  peeledArgs = {};
  while numel (args) >= 2 && ischar (args{end-1}) && ismember (args{end-1}, knownOpts)
    peeledArgs = [peeledArgs args(end-1:end)];
    opts.(args{end-1}) = args{end};
    args(end-1:end) = [];
  end
  remainingArgs = args;
endfunction
