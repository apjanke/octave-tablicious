function out = jndx2kndxs(jndx)
  n = max (jndx);
  out = cell (n, 1);
  for i = 1:n
    out{i} = find (jndx == i);
  endfor
endfunction
