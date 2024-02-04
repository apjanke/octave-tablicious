function tblish_check_stats_overlap (stats_pkg_path)
# Check for overlap with the Statistics package's API.
if nargin < 1; stats_pkg_path = []; end

stats_src_subdirs = {'Classification', 'Clustering', 'datasets', 'dist_fit', 'dist_fun', ...
  'dist_stat', 'Regression'};

# Use this Tablicious package

tblish_pkg_path = fileparts (fileparts (mfilename ('fullpath')));

# Locate Statistics package for comparison
if isempty (stats_pkg_path)
  # Default to Andrew's conventional repo location
  stats_pkg_path = fullfile ( getenv ('HOME'), 'repos', 'octave-statistics');
endif
stats_probe_file = fullfile (stats_pkg_path, 'inst', 'anova2.m');
if ! isfile (stats_probe_file)
  error ('Could not find Statistics OF package at: %s', stats_pkg_path)
endif
stats_inst = fullfile (stats_pkg_path, 'inst');

stats_src_paths = {stats_inst};
for i = 1:numel (stats_src_subdirs)
  stats_src_paths{end+1} = fullfile (stats_inst, stats_src_subdirs{i});
endfor

# Announce

emit ('Comparing Tablicious and Statistics package APIs')
emit ('  Tablicious: %s', tblish_pkg_path)
emit ('  Statistics: %s', stats_pkg_path)
emit ('')

# Compare functions

tblish_inst = fullfile (tblish_pkg_path, 'inst');

t_fcns = list_fcns_in_dirs (tblish_inst);
s_fcns = list_fcns_in_dirs (stats_src_paths);
emit('Found functions/classes: Tablicious: %d  Statistics: %d', ...
  numel (t_fcns), numel (s_fcns))


dupe_fcns = intersect (t_fcns, s_fcns);
emit ('Found %d duplicate functions', numel (dupe_fcns))
emit ('  dupes: %s', strjoin (dupe_fcns, ', '))
emit ('')

endfunction

function emit (fmt, varargin)
  fprintf ([fmt '\n'], varargin{:});
endfunction

function out = list_mfiles_in_dir (f)
  files = readdir (f);
  out = files (endsWith (files, '.m'));
endfunction

function out = list_fcns_in_dirs (dirs)
  # Lists functions (or classes) implied by M-files in a set of directories.
  dirs = cellstr (dirs);
  out = {};
  for i = 1:numel (dirs)
    d = dirs{i};
    mfiles = list_mfiles_in_dir (d);
    names = regexprep (mfiles, '\.m$', '');
    out = [out; names];
  endfor
endfunction
