function mustBeScalar (x)
  if ~isscalar (x)
    name = inputname (1);
    if isempty (name)
      name = 'input';
    endif
    error ('%s must be scalar', name);
  endif
endfunction
