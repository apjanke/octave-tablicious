function out = table_gen_prohibited_ops
  % Generate code for the prohibited table operations
  
  bad = {'transpose', 'ctranspose', 'circshift', 'length', ...
    'shiftdims'};
  
  for i = 1:numel(bad)
    fcn = bad{i};
    printf('    function out = %s(this,varargin)\n', fcn);
    printf('      error(''Function %s is not supported for tables'');\n', fcn);
    printf('    end\n');
    printf('\n');
  end
end
