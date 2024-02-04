function t_00_dummy_mptest_check (quiet)
# A dummy test just to see if MP-Test is working here.

if nargin < 1 || isempty (quiet);  quiet = false;  endif

prec = 12;

t_begin (4, quiet)

t = sprintf ('%s : check MP-Test functionality : ', 'dummy');

t_ok (1 == 1, [t 'Hello, world! (1 == 1)'])
t_is (42, 42, 12, [t '42 is 42 (using t_is)'])
t_skip (1, [t 'dummy skipped test'])
t_ok (123 < 456, [ 'numeric <'])

t_end

endfunction
