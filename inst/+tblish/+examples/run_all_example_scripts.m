function run_all_example_scripts
  % Runs all example scripts in the inst/examples directory
  %
  % This function is meant for use in BIST tests. It just ensures that all
  % the examples run without error.
  
  this_dir = fileparts (mfilename ('fullpath'));
  inst_dir = fileparts (this_dir);
  examples_dir = fullfile (inst_dir, 'examples');
  example_scripts = setdiff (readdir (examples_dir), {'.' '..'});

  for i = 1:numel(example_scripts)
    ex_script = example_scripts{i};
    fprintf ('Running %s\n', ex_script);
    script_path = fullfile (examples_dir, ex_script);
    run (script_path)
  endfor
endfunction
