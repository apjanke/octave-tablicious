function out = __eval_expr_with_table_vars_in_workspace__ (__tbl__, __expr__)

  % Set up workspace
  __tbl_vars__ = varnames (__tbl__);
  for __i_var__ = 1:numel (__tbl_vars__)
    eval (sprintf ('%s = __tbl__.%s;', __tbl_vars__{__i_var__}, __tbl_vars__{__i_var__}));
  endfor
  
  % Eval code
  out = eval (__expr__);
  
end