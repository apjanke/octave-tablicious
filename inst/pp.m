function pp(varargin)
  %PP Alias for prettyprint, for debugging
  %
  % pp (x)
  % pp x
  % pp (A, B, C)
  % pp A B C
  %
  % This is an alias for prettyprint(), with additional name-conversion magic.
  %
  % If you pass in a string, instead of pretty-printing that directly, it will 
  % grab and pretty-print the variable of that name from the caller's workspace.
  % This is so you can conveniently run it from the command line.
  
  show_label = nargin > 1;
  for i = 1:numel (varargin)
    arg = varargin{i};
    if ischar (arg)
      label = arg;
      value = evalin ("caller", arg);
    else
      value = arg;
      label = inputname (i);
      if isempty (label)
        label = sprintf ("Input %d", i);
      endif
    endif
    
    if show_label
      fprintf ("%s:\n", label);
    endif
    prettyprint (value);
  endfor
endfunction
