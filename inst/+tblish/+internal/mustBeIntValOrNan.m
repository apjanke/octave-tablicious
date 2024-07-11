function mustBeIntValOrNan (x)
  % Require that the input is
  errDescr = 'input must be an integer-valued (whole number) numeric';
  if (! isnumeric (x))
    error('%s; got a non-numeric (%s)', errDescr, class (x))
  endif
  tfIntVal = fix (x) == x;
  tfNan = isnan (x);
  tfOk = tfIntVal | tfNan;
  if (! all (tfOk(:)))
    error('%s; some elements were not integer-valued', errDescr)
  end
endfunction
