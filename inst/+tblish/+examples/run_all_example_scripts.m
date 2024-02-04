function run_all_example_scripts ()
  # Runs all example scripts in the inst/examples directory.
  #
  # This function is meant for use in BIST tests. It just ensures that all
  # the examples run without error.
  #
  # This runs the example *scripts* in the inst/examples directory, not the
  # example *functions* or package-scoped scripts in the tblish.examples package.

  this_dir = fileparts (mfilename ('fullpath'));
  inst_dir = fileparts (fileparts (this_dir));
  examples_dir = fullfile (inst_dir, 'examples');
  example_scripts = setdiff (readdir (examples_dir), {'.' '..'});

  nScripts = numel (example_scripts);
  fprintf ('Running %d example scripts from %s\n\n', nScripts, examples_dir);
  for i = 1:nScripts
    ex_script = example_scripts{i};
    fprintf ('Running %s\n', ex_script);
    script_path = fullfile (examples_dir, ex_script);
    run (script_path)
    fprintf ('\n');
  endfor
  fprintf ('All example scripts run (%d scripts).\n', nScripts);

endfunction
