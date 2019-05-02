## Copyright (C) 2019 Andrew Janke
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; If not, see <http://www.gnu.org/licenses/>.

function reconstruct_dataset
  %RECONSTRUCT_DATASET Reconstruct this dataset
  %
  % Reconstructs the Fisher Iris dataset.
  %
  % Source: http://archive.ics.uci.edu/ml/datasets/Iris
  %
  % References:
  %   https://en.wikipedia.org/wiki/Iris_flower_data_set
  
  csv_url = "http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data";
  urlwrite (csv_url, "iris.csv");
  fid = fopen ("iris.csv");
  RAII.fid = onCleanup (@() fclose (fid));
  
  data = textscan (fid, "%f,%f,%f,%f,%s");
  
  species = strrep (data{5}, 'Iris-', '');
  
  s.SepalLength = data{1};
  s.SepalWidth = data{2};
  s.PetalLength = data{3};
  s.PetalWidth = data{4};
  s.Species = species;
  
  iris = s;
  
  save ('iris.mat', 'iris');
  fprintf('Generated mat file: iris.mat\n');
endfunction
