# Covered by the 3-clause BSD License (see LICENSES/LICENSE-MATPOWER file for details).
#
# Copyright (c) 1996-2022 Power Systems Engineering Research Center (PSERC)
# Copyright (c) 2024, 2026 Andrew Janke

function t_01a_table_manipulation (quiet)
# Tests for table array manipulation functionality.

if nargin < 1 || isempty (quiet);   quiet = false;  endif
verbose = ! quiet;

t_begin (6, quiet);

t_01a_01_rowfun (quiet);

t_end;

endfunction

function t_01a_01_rowfun (quiet)
# Test rowfun().
#
# 6 tests.

if nargin < 1 || isempty (quiet);   quiet = false;  endif
verbose = ! quiet;

t = table((1:4)', (-4:-1)', 'VariableNames', {'A', 'B'});

r = rowfun(@(a,b) a+b, t, 'InputVariables', {'A', 'B'}, 'SeparateInputs', true);

t_ok (isa (r, 'table'));
t_ok (isequal (r.Properties.VariableNames, {'out1'}));

r_c = rowfun(@(a,b) a+b, t, 'InputVariables', {'A', 'B'}, 'SeparateInputs', true, 'OutputFormat', 'cell');

t_ok (isa (r_c, 'cell'));
t_ok (isequal (r_c, {-3, -1, 1, 3}'));

r_u = rowfun(@(a,b) a+b, t, 'InputVariables', {'A', 'B'}, 'SeparateInputs', true, 'OutputFormat', 'uniform');

t_ok (isa (r_u, 'double'));
t_is (r_u, [-3, -1, 1, 3]');

endfunction
