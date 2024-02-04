function out = jndx2kndxs (jndx)
  # Convert the `[jndx = ...]` output of ismember etc. to a cell vector of indexes
  # for each distinct jndx value.
  n = max (jndx);
  out = cell (n, 1);
  for i = 1:n
    out{i} = find (jndx == i);
  endfor
endfunction
