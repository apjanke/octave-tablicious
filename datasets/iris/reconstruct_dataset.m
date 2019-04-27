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
