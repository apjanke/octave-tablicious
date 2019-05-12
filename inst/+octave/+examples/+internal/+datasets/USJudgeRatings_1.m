t = octave.dataset.USJudgeRatings;

figure
octave.examples.plot_pairs (t(:,2:end));
title ("USJudgeRatings data")