function [out, indx, jndx] = intersect_stable (A, B)
  %INTERSECT_STABLE Set intersection with stable value ordering
  
  [tf, indx] = ismember (A, B);
  out = A(tf);
  [uOut, ix2] = unique (out);
  if numel (uOut) < numel (out)
    ixDup = 1:numel (out);
    ixDup(ix2) = [];
    out(ixDup) = [];
    indx(ixDup) = [];
  endif
endfunction
