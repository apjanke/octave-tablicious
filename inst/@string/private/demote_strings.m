function out = demote_strings(args)
  #DEMOTE_STRINGS Turn all string arguments into chars
  #
  # out = demote_strings(args)
  #
  # This is for compatibility with functions that take chars or cellstrs,
  # but are not aware of string arrays.
  #
  # Takes a single cell array of "arguments" instead of varargin/varargout,
  # because most callers will be dealing with variadic arguments to their own
  # signature with cell arrays.
  #
  # Scalar strings are turned into char row vectors. Nonscalar strings are
  # turned in to cellstrs. This might not actually be the right thing,
  # depending on what function you are calling!
  out = args;
  for i = 1:numel(args)
    if (isa (args{i}, 'string'))
      if (isscalar (args{i}))
        out{i} = char (args{i});
      else
        out{i} = cellstr (args{i});
      endif
    endif
  endfor
endfunction
