function mustBeNumeric (x)
  if ~isnumeric (x)
    name = inputname (1);
    if isempty (name)
      name = 'Input';
    endif
    error ('mustBeNumeric: %s must be numeric; got a %s', name, class (x));
  endif
endfunction
