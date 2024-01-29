function out = cmp_versions(a, b)
  av = parse_version(a);
  bv = parse_version(b);
  if numel(av) < numel(bv)
    av(end+1:numel(bv)) = 0;
  endif
  if numel(bv) < numel(av)
    bv(end+1:numel(av)) = 0;
  endif
  for i = 1:numel(av)
    if av(i) < bv(i)
      out = -1;
      return
    endif
    if av(i) > bv(i)
      out = 1;
      return
    endif
  endfor
  out = 0;
endfunction

function out = parse_version(v)
  cmps = strsplit(v, '.');
  out = cellfun(@str2double, cmps);
  for i = 1:numel(out)
    if isnan(out(i))
      error ('Failed parsing version ''%s'': Got NaN in element %d', i);
    endif
  endfor
endfunction
