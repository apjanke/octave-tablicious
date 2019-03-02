function out = dispstrs (x)
  %DISPSTRS Display strings for arbitrary array
  if isnumeric (x) || islogical (x)
    out = reshape (strtrim (cellstr (num2str (x(:)))), size (x));
  elseif iscellstr (x) || isa (x, 'string')
    out = cellstr (x);
  elseif isa (x, 'datetime')
    out = datestrs (x);    
  elseif ischar (x)
    out = num2cell (x);
  else
    out = repmat ({sprintf('1-by-1 %s', class(x))}, size (x));
  endif
endfunction
