function [out, indx] = setdiff_stable (A, B)
  %SETDIFF_STABLE Set difference with stable value ordering
  [tf, loc] = ismember (A, B);
  out = A;
  indx = 1:numel (A);
  out(tf) = [];
  indx(tf) = [];
endfunction
