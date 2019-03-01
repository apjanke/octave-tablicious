function mustBeType (x, type)
  if isa (x, type)
    return
  endif
  name = inputname (1);
  if isempty (name)
    name = 'input';
  endif
  error ('%s must be of type %s; got %s', name, type, class (x));
endfunction
