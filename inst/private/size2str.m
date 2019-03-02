function out = size2str (sz)
%SIZE2STR Format an array size for display
%
% out = size2str (sz)
%
% Sz is an array of dimension sizes, in the format returned by SIZE.
%
% Examples:
%
% size2str (magic (3))

strs = cell (size (sz));
for i = 1:numel (sz)
	strs{i} = sprintf ('%d', sz(i));
endfor

out = strjoin (strs, '-by-');
endfunction
