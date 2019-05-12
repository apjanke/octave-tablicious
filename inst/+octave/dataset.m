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

## -*- texinfo -*-
## @deftp {Class} dataset
##
## The @code{dataset} class provides convenient access to the various
## datasets included with Tablicious.
##
## This class just contains a bunch of static methods, each of which loads
## the dataset of that name. It’s provided so you can use tab completion
## on the dataset list.
##
## @end deftp
classdef dataset

  methods (Static)

    ## -*- texinfo -*-
    ## @node dataset.airmiles
    ## @deftypefn {Static Method} {@var{out} =} airmiles ()
    ##
    ## Passenger Miles on Commercial US Airlines, 1937-1960
    ##
    ## @subsubheading Description
    ## 
    ## The revenue passenger miles flown by commercial airlines in the
    ## United States for each year from 1937 to 1960.
    ## 
    ## @subsubheading Source
    ## 
    ## @cite{F.A.A. Statistical Handbook of Aviation}.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.airmiles;
    ## plot (t.year, t.miles);
    ## title ("airmiles data");
    ## xlabel ("Passenger-miles flown by U.S. commercial airlines")
    ## ylabel ("airmiles");
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = airmiles ()
      name = 'airmiles';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.AirPassengers
    ## @deftypefn {Static Method} {@var{out} =} AirPassengers ()
    ##
    ## Monthly Airline Passenger Numbers 1949-1960
    ##
    ## @subsubheading Description
    ## 
    ## The classic Box & Jenkins airline data. Monthly totals of international
    ## airline passengers, 1949 to 1960.
    ## 
    ## @subsubheading Source
    ## 
    ## Box, G. E. P., Jenkins, G. M. and Reinsel, G. C. (1976) @cite{Time Series
    ## Analysis, Forecasting and Control}. Third Edition. Holden-Day. Series G.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## ## TODO: This example needs to be ported from R.
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = AirPassengers ()
      name = 'AirPassengers';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.airquality
    ## @deftypefn {Static Method} {@var{out} =} airquality ()
    ##
    ## New York Air Quality Measurements from 1973
    ##
    ## @subsubheading Description
    ## 
    ## Daily air quality measurements in New York, May to September 1973.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item Ozone
    ## Ozone concentration (ppb)
    ## @item SolarR
    ## Solar R (lang)
    ## @item Wind
    ## Wind (mph)
    ## @item Temp
    ## Temperature (degrees F)
    ## @item Month
    ## Month (1-12)
    ## @item Day
    ## Day of month (1-31)
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## New York State Department of Conservation (ozone data) and the National
    ## Weather Service (meteorological data).
    ## 
    ## @subsubheading References
    ## 
    ## Chambers, J. M., Cleveland, W. S., Kleiner, B. and Tukey, P. A. (1983)
    ## @cite{Graphical Methods for Data Analysis}. Belmont, CA: Wadsworth.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.airquality
    ## # Plot a scatter-plot plus a fitted line, for each combination of measurements
    ## vars = @{"Ozone", "SolarR", "Wind", "Temp" "Month", "Day"@};
    ## n_vars = numel (vars);
    ## figure;
    ## for i = 1:n_vars
    ##   for j = 1:n_vars
    ##     if i == j
    ##       continue
    ##     endif
    ##     ix_subplot = (n_vars*(j - 1) + i);
    ##     hax = subplot (n_vars, n_vars, ix_subplot);
    ##     var_x = vars@{i@};
    ##     var_y = vars@{j@};
    ##     x = t.(var_x);
    ##     y = t.(var_y);
    ##     scatter (hax, x, y, 10);
    ##     # Fit a cubic line to these points
    ##     # TODO: Find out exactly what kind of fitted line R's example is using, and
    ##     # port that.
    ##     hold on
    ##     p = polyfit (x, y, 3);
    ##     x_hat = unique(x);
    ##     p_y = polyval (p, x_hat);
    ##     plot (hax, x_hat, p_y, "r");
    ##   endfor
    ## endfor
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = airquality ()
      name = 'airquality';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.anscombe
    ## @deftypefn {Static Method} {@var{out} =} anscombe ()
    ##
    ## Anscombe’s Quartet of “Identical” Simple Linear Regressions
    ##
    ## @subsubheading Description
    ## 
    ## Four sets of x/y pairs which have the same statistical properties, but are
    ## very different.
    ## 
    ## @subsubheading Format
    ## 
    ## The data comes in an array of 4 structs, each with fields as follows:
    ## 
    ## @table @code
    ## @item x
    ## The X values for this pair.
    ## @item y
    ## The Y values for this pair.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Tufte, Edward R. (1989). @cite{The Visual Display of Quantitative Information}.
    ## 13–14. Graphics Press.
    ## 
    ## @subsubheading References
    ## 
    ## Anscombe, Francis J. (1973). “Graphs in statistical analysis”. @cite{The
    ## American Statistician}, 27, 17–21. 
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## data = octave.dataset.anscombe
    ## 
    ## # Pick good limits for the plots
    ## all_x = [data.x];
    ## all_y = [data.y];
    ## x_limits = [min(0, min(all_x)) max(all_x)*1.2];
    ## y_limits = [min(0, min(all_y)) max(all_y)*1.2];
    ## 
    ## # Do regression on each pair and plot the input and results
    ## figure;
    ## haxs = NaN (1, 4);
    ## for i_pair = 1:4
    ##   x = data(i_pair).x;
    ##   y = data(i_pair).y;
    ##   # TODO: Port the anova and other characterizations from the R code
    ##   # TODO: Do a linear regression and plot its line
    ##   hax = subplot (2, 2, i_pair);
    ##   haxs(i_pair) = hax;
    ##   xlabel (sprintf ("x%d", i_pair));
    ##   ylabel (sprintf ("y%d", i_pair));
    ##   scatter (x, y, "r");
    ## endfor
    ## 
    ## # Fiddle with the plot axes parameters
    ## linkaxes (haxs);
    ## xlim(haxs(1), x_limits);
    ## ylim(haxs(1), y_limits);
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = anscombe ()
      name = 'anscombe';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.attenu
    ## @deftypefn {Static Method} {@var{out} =} attenu ()
    ##
    ## Joyner-Boore Earthquake Attenuation Data
    ##
    ## @subsubheading Description
    ## 
    ## Event data for 23 earthquakes in California, showing peak accelerations.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item event
    ## Event number
    ## @item mag
    ## Moment magnitude
    ## @item station
    ## Station identifier
    ## @item dist
    ## Station-hypocenter distance (km)
    ## @item accel
    ## Peak acceleration (g)
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Joyner, W.B., D.M. Boore and R.D. Porcella (1981). Peak horizontal acceleration
    ## and velocity from strong-motion records including records from the 1979
    ## Imperial Valley, California earthquake. USGS Open File report 81-365. Menlo
    ## Park, Ca.
    ## 
    ## @subsubheading References
    ## 
    ## Boore, D. M. and Joyner, W. B.(1982). The empirical prediction of ground
    ## motion, @cite{Bulletin of the Seismological Society of America}, 72, S269–S268.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # TODO: Port the example code from R
    ## # It does coplot() and pairs(), which are higher-level plotting tools 
    ## # than core Octave provides. This could turn into a long example if we
    ## # just use base Octave here.
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = attenu ()
      name = 'attenu';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.attitude
    ## @deftypefn {Static Method} {@var{out} =} attitude ()
    ##
    ## The Chatterjee-Price Attitude Data
    ##
    ## @subsubheading Description
    ## 
    ## Aggregated data from a survey of clerical employees at a large financial
    ## organization.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item rating
    ## Overall rating.
    ## @item complaints
    ## Handling of employee complaints.
    ## @item privileges
    ## Does not allow special privileges.
    ## @item learning
    ## Opportunity to learn.
    ## @item raises
    ## Raises based on performance.
    ## @item critical
    ## Too critical.
    ## @item advance
    ## Advancement.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Chatterjee, S. and Price, B. (1977) @cite{Regression Analysis by Example}. New York:
    ## Wiley. (Section 3.7, p.68ff of 2nd ed.(1991).)
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.attitude
    ## 
    ## octave.examples.plot_pairs (t);
    ## 
    ## # TODO: Display table summary
    ## 
    ## # TODO: Whatever those statistical linear-model plots are that R is doing
    ## 
    ## 
    ## @end example
    ##
    ## @end deftypefn
    function out = attitude ()
      name = 'attitude';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.austres
    ## @deftypefn {Static Method} {@var{out} =} austres ()
    ##
    ## Australian Population
    ##
    ## @subsubheading Description
    ## 
    ## Numbers of Australian residents measured quarterly from March 1971 to March 1994.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item date
    ## The month of the observation.
    ## @item residents
    ## The number of residents.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## P. J. Brockwell and R. A. Davis (1996) @cite{Introduction to Time Series and
    ## Forecasting}. Springer
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.austres
    ## 
    ## plot (datenum (t.date), t.residents);
    ## datetick x
    ## xlabel ("Month"); ylabel ("Residents"); title ("Australian Residents");
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = austres ()
      name = 'austres';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.beavers
    ## @deftypefn {Static Method} {@var{out} =} beavers ()
    ##
    ## Body Temperature Series of Two Beavers
    ##
    ## @subsubheading Description
    ## 
    ## Body temperature readings for two beavers.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item day
    ## Day of observation (in days since the beginning of 1990), December 12–13 (beaver1) 
    ## and November 3–4 (beaver2).
    ## @item time
    ## Time of observation, in the form 0330 for 3:30am
    ## @item temp
    ## Measured body temperature in degrees Celsius.
    ## @item activ
    ## Indicator of activity outside the retreat.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## P. S. Reynolds (1994) Time-series analyses of beaver body temperatures.
    ## Chapter 11 of Lange, N., Ryan, L., Billard, L., Brillinger, D., Conquest,
    ## L. and Greenhouse, J. eds (1994) @cite{Case Studies in Biometry}. New York: John Wiley
    ## and Sons.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # TODO: This example needs to be ported from R.
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = beavers ()
      name = 'beavers';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.BJsales
    ## @deftypefn {Static Method} {@var{out} =} BJsales ()
    ##
    ## Sales Data with Leading Indicator
    ##
    ## @subsubheading Description
    ## 
    ## Sales Data with Leading Indicator
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item record
    ## Index of the record.
    ## @item lead
    ## Leading indicator.
    ## @item sales
    ## Sales volume.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## The data are given in Box & Jenkins (1976). Obtained from the Time Series Data
    ## Library at @url{http://www-personal.buseco.monash.edu.au/~hyndman/TSDL/}.
    ## 
    ## @subsubheading References
    ## 
    ## G. E. P. Box and G. M. Jenkins (1976): @cite{Time Series Analysis, Forecasting and
    ## Control}, Holden-Day, San Francisco, p. 537.
    ## 
    ## P. J. Brockwell and R. A. Davis (1991): @cite{Time Series: Theory and Methods},
    ## Second edition, Springer Verlag, NY, pp. 414.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # TODO: Come up with example code here
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = BJsales ()
      name = 'BJsales';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.BOD
    ## @deftypefn {Static Method} {@var{out} =} BOD ()
    ##
    ## Biochemical Oxygen Demand
    ##
    ## @subsubheading Description
    ## 
    ## Contains biochemical oxygen demand versus time in an evaluation of water quality.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item Time
    ## Time of the measurement (in days).
    ## @item demand
    ## Biochemical oxygen demand (mg/l).
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Bates, D.M. and Watts, D.G. (1988), @cite{Nonlinear Regression Analysis and Its
    ## Applications}, Wiley, Appendix A1.4.
    ## 
    ## Originally from Marske (1967), @cite{Biochemical Oxygen Demand Data
    ## Interpretation Using Sum of Squares Surface}, M.Sc. Thesis, University of
    ## Wisconsin – Madison.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # TODO: Port this example from R
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = BOD ()
      name = 'BOD';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.cars
    ## @deftypefn {Static Method} {@var{out} =} cars ()
    ##
    ## Speed and Stopping Distances of Cars
    ##
    ## @subsubheading Description
    ## 
    ## Speed of cars and distances taken to stop. Note that the data were recorded in the 1920s.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item speed
    ## Speed (mph).
    ## @item dist
    ## Stopping distance (ft).
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Ezekiel, M. (1930) @cite{Methods of Correlation Analysis}. Wiley.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. R. (1977) Interactive Data Analysis. Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## 
    ## t = octave.dataset.cars;
    ## 
    ## 
    ## # TODO: Add Lowess smoothed lines to the plots
    ## 
    ## figure;
    ## plot (t.speed, t.dist, "o");
    ## xlabel ("Speed (mph)"); ylabel("Stopping distance (ft)");
    ## title ("cars data");
    ## 
    ## figure;
    ## loglog (t.speed, t.dist, "o");
    ## xlabel ("Speed (mph)"); ylabel("Stopping distance (ft)");
    ## title ("cars data (logarithmic scales)");
    ## 
    ## # TODO: Do the linear model plot
    ## 
    ## # Polynomial regression
    ## figure;
    ## plot (t.speed, t.dist, "o");
    ## xlabel ("Speed (mph)"); ylabel("Stopping distance (ft)");
    ## title ("cars polynomial regressions");
    ## hold on
    ## xlim ([0 25]);
    ## x2 = linspace (0, 25, 200);
    ## for degree = 1:4
    ##   [P, S, mu] = polyfit (t.speed, t.dist, degree);
    ##   y2 = polyval(P, x2, [], mu);
    ##   plot (x2, y2);
    ## endfor
    ## 
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = cars ()
      name = 'cars';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.ChickWeight
    ## @deftypefn {Static Method} {@var{out} =} ChickWeight ()
    ##
    ## Weight versus age of chicks on different diets
    ##
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item weight
    ## a numeric vector giving the body weight of the chick (gm).
    ## @item Time
    ## a numeric vector giving the number of days since birth when the
    ## measurement was made.
    ## @item Chick
    ## an ordered factor with levels 18 < ... < 48 giving a unique
    ## identifier for the chick. The ordering of the levels groups chicks on the same
    ## diet together and orders them according to their final weight (lightest to
    ## heaviest) within diet.
    ## @item Diet
    ## a factor with levels 1, ..., 4 indicating which experimental diet
    ## the chick received.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Crowder, M. and Hand, D. (1990), @cite{Analysis of Repeated Measures}. Chapman and
    ## Hall (example 5.3)
    ## 
    ## Hand, D. and Crowder, M. (1996), @cite{Practical Longitudinal Data Analysis}. Chapman
    ## and Hall (table A.2)
    ## 
    ## Pinheiro, J. C. and Bates, D. M. (2000) @cite{Mixed-effects Models in S and S-PLUS}.
    ## Springer.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.ChickWeight
    ## 
    ## octave.examples.coplot (t, "Time", "weight", "Chick");
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = ChickWeight ()
      name = 'ChickWeight';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.chickwts
    ## @deftypefn {Static Method} {@var{out} =} chickwts ()
    ##
    ## Chicken Weights by Feed Type
    ##
    ## @subsubheading Description
    ## 
    ## An experiment was conducted to measure and compare the effectiveness of various
    ## feed supplements on the growth rate of chickens.
    ## 
    ## Newly hatched chicks were randomly allocated into six groups, and each group
    ## was given a different feed supplement. Their weights in grams after six weeks
    ## are given along with feed types.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item weight
    ## Chick weight at six weeks (gm).
    ## @item feed
    ## Feed type.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Anonymous (1948) @cite{Biometrika}, 35, 214.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. R. (1977) @code{Interactive Data Analysis}. New York: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # This example requires the statistics package from Octave Forge
    ## 
    ## t = octave.dataset.chickwts
    ## 
    ## # Boxplot by group
    ## figure
    ## g = groupby (t, "feed", @{
    ##   "weight", @@(x) @{x@}, "weight"
    ## @});
    ## boxplot (g.weight, 1);
    ## xlabel ("feed"); ylabel ("Weight at six weeks (gm)");
    ## xticklabels ([@{""@} cellstr(g.feed')]);
    ## 
    ## # Linear model
    ## # TODO: This linear model thing and anova
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = chickwts ()
      name = 'chickwts';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.co2
    ## @deftypefn {Static Method} {@var{out} =} co2 ()
    ##
    ## Mauna Loa Atmospheric CO2 Concentration
    ##
    ## @subsubheading Description
    ## 
    ## Atmospheric concentrations of CO2 are expressed in parts per million (ppm) and
    ## reported in the preliminary 1997 SIO manometric mole fraction scale. Contains
    ## monthly observations from 1959 to 1997.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item date
    ## Date of the month of the observation, as datetime.
    ## @item co2
    ## CO2 concentration (ppm).
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## The values for February, March and April of 1964 were missing and have
    ## been obtained by interpolating linearly between the values for January
    ## and May of 1964.
    ## 
    ## @subsubheading Source
    ## 
    ## Keeling, C. D. and Whorf, T. P., Scripps Institution of Oceanography
    ## (SIO), University of California, La Jolla, California USA 92093-0220.
    ## 
    ## @url{ftp://cdiac.esd.ornl.gov/pub/maunaloa-co2/maunaloa.co2}.
    ## 
    ## @subsubheading References
    ## 
    ## Cleveland, W. S. (1993) @code{Visualizing Data}. New Jersey: Summit Press.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.co2;
    ## 
    ## plot (datenum (t.date), t.co2);
    ## datetick ("x");
    ## xlabel ("Time"); ylabel ("Atmospheric concentration of CO2");
    ## title ("co2 data set");
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = co2 ()
      name = 'co2';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.crimtab
    ## @deftypefn {Static Method} {@var{out} =} crimtab ()
    ##
    ## Student’s 3000 Criminals Data
    ##
    ## @subsubheading Description
    ## 
    ## Data of 3000 male criminals over 20 years old undergoing their sentences in the
    ## chief prisons of England and Wales.
    ## 
    ## @subsubheading Format
    ## 
    ## This dataset contains three separate variables. The @code{finger_length} and
    ## @code{body_height} variables correspond to the rows and columns of the
    ## @code{count} matrix.
    ## 
    ## @table @code
    ## @item finger_length
    ## Midpoints of intervals of finger lengths (cm).
    ## @item body_height
    ## Body heights (cm).
    ## @item count
    ## Number of prisoners in this bin.
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## Student is the pseudonym of William Sealy Gosset. In his 1908 paper he wrote
    ## (on page 13) at the beginning of section VI entitled Practical Test of the
    ## forgoing Equations:
    ## 
    ## “Before I had succeeded in solving my problem analytically, I had endeavoured
    ## to do so empirically. The material used was a correlation table containing
    ## the height and left middle finger measurements of 3000 criminals, from a
    ## paper by W. R. MacDonell (Biometrika, Vol. I., p. 219). The measurements
    ## were written out on 3000 pieces of cardboard, which were then very thoroughly
    ## shuffled and drawn at random. As each card was drawn its numbers were written
    ## down in a book, which thus contains the measurements of 3000 criminals in a
    ## random order. Finally, each consecutive set of 4 was taken as a sample—750
    ## in all—and the mean, standard deviation, and correlation of each sample 
    ## etermined. The difference between the mean of each sample and the mean of
    ## the population was then divided by the standard deviation of the sample, giving
    ## us the z of Section III.”
    ## 
    ## The table is in fact page 216 and not page 219 in MacDonell(1902). In the
    ## MacDonell table, the middle finger lengths were given in mm and the heights
    ## in feet/inches intervals, they are both converted into cm here. The midpoints
    ## of intervals were used, e.g., where MacDonell has “4' 7"9/16 -- 8"9/16”, we
    ## have 142.24 which is 2.54*56 = 2.54*(4' 8").
    ## 
    ## MacDonell credited the source of data (page 178) as follows: “The data on which
    ## the memoir is based were obtained, through the kindness of Dr Garson, from the
    ## Central Metric Office, New Scotland Yard... He pointed out on page 179 that:
    ## “The forms were drawn at random from the mass on the office shelves; we are
    ## therefore dealing with a random sampling.”
    ## 
    ## @subsubheading Source
    ## 
    ## @url{http://pbil.univ-lyon1.fr/R/donnees/criminals1902.txt} thanks to Jean R.
    ## Lobry and Anne-Béatrice Dufour.
    ## 
    ## @subsubheading References
    ## 
    ## Garson, J.G. (1900). The metric system of identification of criminals, as used
    ## in in Great Britain and Ireland. @cite{The Journal of the Anthropological
    ## Institute of Great Britain and Ireland}, 30, 161–198.
    ## 
    ## MacDonell, W.R. (1902). On criminal anthropometry and the identification of
    ## criminals. @cite{Biometrika}, 1(2), 177–227.
    ## 
    ## Student (1908). The probable error of a mean. @code{Biometrika}, 6, 1–25.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # TODO: Port this from R
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = crimtab ()
      name = 'crimtab';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.cupcake
    ## @deftypefn {Static Method} {@var{out} =} cupcake ()
    ##
    ## Google Search popularity for "cupcake", 2004-2019
    ##
    ## @subsubheading Description
    ## 
    ## Monthly popularity of worldwide Google search results for "cupcake", 2004-2019.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item Month
    ## Month when searches took place
    ## @item Cupcake
    ## An indicator of search volume, in unknown units
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Google Trends, @url{https://trends.google.com/trends/explore?q=%2Fm%2F03p1r4&date=all},
    ## retrieved 2019-05-04 by Andrew Janke.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.cupcake
    ## plot(datenum(t.Month), t.Cupcake)
    ## title ('“Cupcake” Google Searches'); xlabel ("Year"); ylabel ("Unknown popularity metric")
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = cupcake ()
      name = 'cupcake';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.discoveries
    ## @deftypefn {Static Method} {@var{out} =} discoveries ()
    ##
    ## Yearly Numbers of Important Discoveries
    ##
    ## @subsubheading Description
    ## 
    ## The numbers of “great” inventions and scientific discoveries in each year from 1860 to 1959.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item year
    ## Year.
    ## @item discoveries
    ## Number of “great” discoveries that year.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## @cite{The World Almanac and Book of Facts}, 1975 Edition, pages 315–318.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. R. (1977) @cite{Interactive Data Analysis}. Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.discoveries;
    ## 
    ## plot (t.year, t.discoveries);
    ## xlabel ("Time"); ylabel ("Number of important discoveries");
    ## title ("discoveries data set");
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = discoveries ()
      name = 'discoveries';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.DNase
    ## @deftypefn {Static Method} {@var{out} =} DNase ()
    ##
    ## Elisa assay of DNase
    ##
    ## @subsubheading Description
    ## 
    ## Data obtained during development of an ELISA assay for the recombinant protein DNase in rat serum.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item Run
    ## Ordered @code{categorical} indicating the assay run.
    ## @item conc
    ## Known concentration of the protein (ng/ml).
    ## @item density
    ## Measured optical density in the assay (dimensionless).
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Davidian, M. and Giltinan, D. M. (1995) @cite{Nonlinear Models for Repeated
    ## Measurement Data}, Chapman & Hall (section 5.2.4, p. 134)
    ## 
    ## Pinheiro, J. C. and Bates, D. M. (2000) @cite{Mixed-effects Models in S and
    ## S-PLUS}, Springer.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.DNase;
    ## 
    ## # TODO: Port this from R
    ## 
    ## octave.examples.coplot (t, "conc", "density", "Run", "PlotFcn", @@scatter);
    ## octave.examples.coplot (t, "conc", "density", "Run", "PlotFcn", @@loglog, ...
    ##   "PlotArgs", @{"o"@});
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = DNase ()
      name = 'DNase';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.esoph
    ## @deftypefn {Static Method} {@var{out} =} esoph ()
    ##
    ## Smoking, Alcohol and Esophageal Cancer
    ##
    ## @subsubheading Description
    ## 
    ## Data from a case-control study of (o)esophageal cancer in Ille-et-Vilaine, France.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item item
    ## Age group (years).
    ## @item alcgp
    ## Alcohol consumption (gm/day).
    ## @item tobgp
    ## Tobacco consumption (gm/day).
    ## @item ncases
    ## Number of cases.
    ## @item ncontrols
    ## Number of controls
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Breslow, N. E. and Day, N. E. (1980) @cite{Statistical Methods in Cancer Research.
    ## Volume 1: The Analysis of Case-Control Studies}. IARC Lyon / Oxford University Press.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # TODO: Port this from R
    ## 
    ## # TODO: Port the anova output
    ## 
    ## # TODO: Port the fancy plot
    ## # This involves a "mosaic plot", which is not supported by Octave, so this will
    ## # take some work.
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = esoph ()
      name = 'esoph';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.euro
    ## @deftypefn {Static Method} {@var{out} =} euro ()
    ##
    ## Conversion Rates of Euro Currencies
    ##
    ## @subsubheading Description
    ## 
    ## Conversion rates between the various Euro currencies.
    ## 
    ## @subsubheading Format
    ## 
    ## This data comes in two separate variables.
    ## 
    ## @table @code
    ## @item euro
    ## An 11-long vector of the value of 1 Euro in all participating currencies.
    ## @item euro_cross
    ## An 11-by-11 matrix of conversion rates between various Euro currencies.
    ## @item euro_date
    ## The date upon which these Euro conversion rates were fixed.
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## The data set euro contains the value of 1 Euro in all currencies participating
    ## in the European monetary union (Austrian Schilling ATS, Belgian Franc BEF,
    ## German Mark DEM, Spanish Peseta ESP, Finnish Markka FIM, French Franc FRF,
    ## Irish Punt IEP, Italian Lira ITL, Luxembourg Franc LUF, Dutch Guilder NLG and
    ## Portuguese Escudo PTE). These conversion rates were fixed by the European
    ## Union on December 31, 1998. To convert old prices to Euro prices, divide by the
    ## respective rate and round to 2 digits.
    ## 
    ## @subsubheading Source
    ## 
    ## Unknown.
    ## 
    ## This example data set was derived from the R 3.6.0 example datasets, and they
    ## do not specify a source.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # TODO: Port this from R
    ## 
    ## # TODO: Example conversion
    ## 
    ## # TODO: "dot chart" showing euro-to-whatever conversion rates and vice versa
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = euro ()
      name = 'euro';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.eurodist
    ## @deftypefn {Static Method} {@var{out} =} eurodist ()
    ##
    ## Distances Between European Cities and Between US Cities
    ##
    ## @subsubheading Description
    ## 
    ## @code{eurodist} gives road distances (in km) between 21 cities in Europe. The
    ## data are taken from a table in The Cambridge Encyclopaedia.
    ## 
    ## @code{UScitiesD} gives “straight line” distances between 10 cities in the US.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item eurodist
    ## ?????
    ## @end table
    ## 
    ## TODO: Finish this.
    ## 
    ## @subsubheading Source
    ## 
    ## Crystal, D. Ed. (1990) @cite{The Cambridge Encyclopaedia}. Cambridge:
    ## Cambridge University Press,
    ## 
    ## The US cities distances were provided by Pierre Legendre.
    ## 
    ## @subsubheading Examples
    ## 
    ## 
    ##
    ## @end deftypefn
    function out = eurodist ()
      name = 'eurodist';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.EuStockMarkets
    ## @deftypefn {Static Method} {@var{out} =} EuStockMarkets ()
    ##
    ## Daily Closing Prices of Major European Stock Indices
    ##
    ## @subsubheading Description
    ## 
    ## Contains the daily closing prices of major European stock indices: Germany DAX
    ## (Ibis), Switzerland SMI, France CAC, and UK FTSE. The data are sampled in
    ## business time, i.e., weekends and holidays are omitted.
    ## 
    ## @subsubheading Format
    ## 
    ## A multivariate time series with 1860 observations on 4 variables.
    ## 
    ## The starting date is the 130th day of 1991, with a frequency of 260 observations
    ## per year.
    ## 
    ## @subsubheading Source
    ## 
    ## The data were kindly provided by Erste Bank AG, Vienna, Austria.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## 
    ## t = octave.dataset.EuStockMarkets;
    ## 
    ## # The fact that we're doing this munging means that table might have
    ## # been the wrong structure for this data in the first place
    ## 
    ## t2 = removevars (t, "day");
    ## index_names = t2.Properties.VariableNames;
    ## day = 1:height (t2);
    ## price = table2array (t2);
    ## 
    ## price0 = price(1,:);
    ## 
    ## rel_price = price ./ repmat (price0, [size(price,1) 1]);
    ## 
    ## figure;
    ## plot (day, rel_price);
    ## legend (index_names);
    ## xlabel ("Business day");
    ## ylabel ("Relative price");
    ## 
    ## 
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = EuStockMarkets ()
      name = 'EuStockMarkets';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.faithful
    ## @deftypefn {Static Method} {@var{out} =} faithful ()
    ##
    ## Old Faithful Geyser Data
    ##
    ## @subsubheading Description
    ## 
    ## Waiting time between eruptions and the duration of the eruption for the Old
    ## Faithful geyser in Yellowstone National Park, Wyoming, USA.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item eruptions
    ## Eruption time (mins).
    ## @item waiting
    ## Waiting time to next eruption (mins).
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## W. Härdle.
    ## 
    ## @subsubheading References
    ## 
    ## Härdle, W. (1991). @cite{Smoothing Techniques with Implementation in S}. New York:
    ## Springer.
    ## 
    ## Azzalini, A. and Bowman, A. W. (1990). A look at some data on the Old
    ## Faithful geyser. @cite{Applied Statistics}, 39, 357–365.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.faithful;
    ## 
    ## % Munge the data, rounding eruption time to the second
    ## e60 = 60 * t.eruptions;
    ## ne60 = round (e60);
    ## # TODO: Port zapsmall to Octave
    ## eruptions = ne60 / 60;
    ## # TODO: Display mean relative difference and bins summary
    ## 
    ## % Histogram of rounded eruption times
    ## figure
    ## hist (ne60, max (ne60))
    ## xlabel ("Eruption time (sec)")
    ## ylabel ("n")
    ## title ("faithful data: Eruptions of Old Faithful")
    ## 
    ## % Scatter plot of eruption time vs waiting time
    ## figure
    ## scatter (t.eruptions, t.waiting)
    ## xlabel ("Eruption time (min)")
    ## ylabel ("Waiting time to next eruption (min)")
    ## title ("faithful data: Eruptions of Old Faithful")
    ## # TODO: Port Lowess smoothing to Octave
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = faithful ()
      name = 'faithful';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.Formaldehyde
    ## @deftypefn {Static Method} {@var{out} =} Formaldehyde ()
    ##
    ## Determination of Formaldehyde
    ##
    ## @subsubheading Description
    ## 
    ## These data are from a chemical experiment to prepare a standard curve for the
    ## determination of formaldehyde by the addition of chromatropic acid and
    ## concentrated sulphuric acid and the reading of the resulting purple color on
    ## a spectrophotometer.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item record
    ## Observation record number.
    ## @item carb
    ## Carbohydrate (ml).
    ## @item optden
    ## Optical Density
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Bennett, N. A. and N. L. Franklin (1954) @cite{Statistical Analysis in
    ## Chemistry and the Chemical Industry}. New York: Wiley.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. R. (1977) @cite{Interactive Data Analysis}. New York: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.Formaldehyde;
    ## 
    ## figure
    ## scatter (t.carb, t.optden)
    ## % TODO: Add a linear model line
    ## xlabel ("Carbohydrate (ml)")
    ## ylabel ("Optical Density")
    ## title ("Formaldehyde data")
    ## 
    ## % TODO: Add linear model summary output
    ## % TOD: Add linear model summary plot
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = Formaldehyde ()
      name = 'Formaldehyde';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.freeny
    ## @deftypefn {Static Method} {@var{out} =} freeny ()
    ##
    ## Freeny's Revenue Data
    ##
    ## @subsubheading Description
    ## 
    ## Freeny’s data on quarterly revenue and explanatory variables.
    ## 
    ## @subsubheading Format
    ## 
    ## Freeny’s dataset consists of one observed dependent variable
    ## (revenue) and four explanatory variables (lagged quartery
    ## revenue, price index, income level, and market potential).
    ## 
    ## @table @code
    ## @item date
    ## Start date of the quarter for the observation.
    ## @item y
    ## Observed quarterly revenue.
    ## TODO: Determine units (probably millions of USD?)
    ## @item lag_quarterly_revenue
    ## Quarterly revenue (@code{y}), lagged 1 quarter.
    ## @item price_index
    ## A price index
    ## @item income_level
    ## ??? TODO: Fill this in
    ## @item market_potential
    ## ??? TODO: Fill this in
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## A. E. Freeny (1977) @cite{A Portable Linear Regression Package with Test
    ## Programs}. Bell Laboratories memorandum.
    ## 
    ## @subsubheading References
    ## 
    ## Becker, R. A., Chambers, J. M. and Wilks, A. R. (1988) @cite{The New S
    ## Language}. Wadsworth & Brooks/Cole.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.freeny;
    ## 
    ## summary(t)
    ## 
    ## octave.examples.plot_pairs (removevars (t, "date"))
    ## 
    ## # TODO: Create linear model and print summary
    ## 
    ## # TODO: Linear model plot
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = freeny ()
      name = 'freeny';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.HairEyeColor
    ## @deftypefn {Static Method} {@var{out} =} HairEyeColor ()
    ##
    ## Hair and Eye Color of Statistics Students
    ##
    ## @subsubheading Description
    ## 
    ## Distribution of hair and eye color and sex in 592 statistics students.
    ## 
    ## @subsubheading Format
    ## 
    ## This data set comes in multiple variables
    ## 
    ## @table @code
    ## @item n
    ## A 3-dimensional array containing the counts of students in each bucket. It
    ## is arranged as hair-by-eye-by-sex.
    ## @item hair
    ## Hair colors for the indexes along dimension 1.
    ## @item eye
    ## Eye colors for the indexes along dimension 2.
    ## @item sex
    ## Sexes for the indexes along dimension 3.
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## The Hair x Eye table comes rom a survey of students at the University of
    ## Delaware reported by Snee (1974). The split by Sex was added by Friendly
    ## (1992a) for didactic purposes.
    ## 
    ## This data set is useful for illustrating various techniques for the analysis
    ## of contingency tables, such as the standard chi-squared test or, more
    ## generally, log-linear modelling, and graphical methods such as mosaic plots,
    ## sieve diagrams or association plots.
    ## 
    ## @subsubheading Source
    ## 
    ## @url{http://euclid.psych.yorku.ca/ftp/sas/vcd/catdata/haireye.sas}
    ## 
    ## Snee (1974) gives the two-way table aggregated over Sex. The Sex split of 
    ## the ‘Brown hair, Brown eye’ cell was changed to agree with that used by
    ## Friendly (2000).
    ## 
    ## @subsubheading References
    ## 
    ## Snee, R. D. (1974). Graphical display of two-way contingency tables.
    ## @cite{The American Statistician}, 28, 9–12.
    ## 
    ## Friendly, M. (1992a). Graphical methods for categorical data. @cite{SAS User
    ## Group International Conference Proceedings}, 17, 190–200.
    ## @url{http://www.math.yorku.ca/SCS/sugi/sugi17-paper.html}
    ## 
    ## Friendly, M. (1992b). Mosaic displays for loglinear models. @cite{Proceedings
    ## of the Statistical Graphics Section}, American Statistical Association, pp.
    ## 61–68. @url{http://www.math.yorku.ca/SCS/Papers/asa92.html}
    ## 
    ## Friendly, M. (2000). @cite{Visualizing Categorical Data}. SAS Institute,
    ## ISBN 1-58025-660-0.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## octave.dataset.HairEyeColor
    ## 
    ## # TODO: Aggregate over sex and display a table of counts
    ## 
    ## # TODO: Port mosaic plot to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = HairEyeColor ()
      name = 'HairEyeColor';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.Harman23cor
    ## @deftypefn {Static Method} {@var{out} =} Harman23cor ()
    ##
    ## Harman Example 2.3
    ##
    ## @subsubheading Description
    ## 
    ## A correlation matrix of eight physical measurements on 305 girls between
    ## ages seven and seventeen.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item cov
    ## An 8-by-8 correlation matrix.
    ## @item names
    ## Names of the variables corresponding to the indexes of the correlation matrix’s
    ## dimensions.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Harman, H. H. (1976) @cite{Modern Factor Analysis}, Third Edition Revised,
    ## University of Chicago Press, Table 2.3.
    ## 
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## octave.dataset.Harman23cor;
    ## 
    ## # TODO: Port factanal to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = Harman23cor ()
      name = 'Harman23cor';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.Harman74cor
    ## @deftypefn {Static Method} {@var{out} =} Harman74cor ()
    ##
    ## Harman Example 7.4
    ##
    ## @subsubheading Description
    ## 
    ## A correlation matrix of 24 psychological tests given to 145 seventh and
    ## eighth-grade children in a Chicago suburb by Holzinger and Swineford.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item cov
    ## A 2-dimensional correlation matrix.
    ## @item vars
    ## Names of the variables corresponding to the indexes along the dimensions of
    ## @code{cov}.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Harman, H. H. (1976) @cite{Modern Factor Analysis}, Third Edition
    ## Revised, University of Chicago Press, Table 7.4.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## octave.dataset.Harman74cor;
    ## 
    ## # TODO: Port factanal to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = Harman74cor ()
      name = 'Harman74cor';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.Indometh
    ## @deftypefn {Static Method} {@var{out} =} Indometh ()
    ##
    ## Pharmacokinetics of Indomethacin
    ##
    ## @subsubheading Description
    ## 
    ## Data on the pharmacokinetics of indometacin (or, older spelling,
    ## ‘indomethacin’).
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item Subject
    ## Subject identifier.
    ## @item time
    ## Time since drug administration at which samples were drawn (hours).
    ## @item conc
    ## Plasma concentration of indomethacin (mcg/ml).
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## Each of the six subjects were given an intravenous injection of indometacin.
    ## 
    ## @subsubheading Source
    ## 
    ## Kwan, Breault, Umbenhauer, McMahon and Duggan (1976) Kinetics of
    ## Indomethacin absorption, elimination, and enterohepatic circulation in man.
    ## @cite{Journal of Pharmacokinetics and Biopharmaceutics} 4, 255–280.
    ## 
    ## Davidian, M. and Giltinan, D. M. (1995) @cite{Nonlinear Models for Repeated
    ## Measurement Data}, Chapman & Hall (section 5.2.4, p. 129)
    ## 
    ## Pinheiro, J. C. and Bates, D. M. (2000) @cite{Mixed-effects Models in S and
    ## S-PLUS}, Springer.
    ## 
    ##
    ## @end deftypefn
    function out = Indometh ()
      name = 'Indometh';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.infert
    ## @deftypefn {Static Method} {@var{out} =} infert ()
    ##
    ## Infertility after Spontaneous and Induced Abortion
    ##
    ## @subsubheading Description
    ## 
    ## This is a matched case-control study dating from before the availability of
    ## conditional logistic regression.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item education
    ## Index of the record.
    ## @item age
    ## Age in years of case.
    ## @item parity
    ## Count.
    ## @item induced
    ## Number of prior induced abortions, grouped into “0”, “1”, or “2 or more”.
    ## @item case_status
    ## 0 = control, 1 = case.
    ## @item spontaneous
    ## Number of prior spontaneous abortions, grouped into “0”, “1”, or “2 or more”.
    ## @item stratum
    ## Matched set number.
    ## @item pooled_stratum
    ## Stratum number.
    ## @end table
    ## 
    ## @subsubheading Note
    ## 
    ## One case with two prior spontaneous abortions and two prior induced abortions is omitted.
    ## 
    ## @subsubheading Source
    ## 
    ## Trichopoulos et al (1976) @cite{Br. J. of Obst. and Gynaec.} 83, 645–650.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.infert;
    ## 
    ## # TODO: Port glm() (generalized linear model) stuff to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = infert ()
      name = 'infert';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.InsectSprays
    ## @deftypefn {Static Method} {@var{out} =} InsectSprays ()
    ##
    ## Effectiveness of Insect Sprays
    ##
    ## @subsubheading Description
    ## 
    ## The counts of insects in agricultural experimental units treated with different
    ## insecticides.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item spray
    ## The type of spray.
    ## @item count
    ## Insect count.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Beall, G., (1942) The Transformation of data from entomological field
    ## experiments, @cite{Biometrika}, 29, 243–262.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. (1977) @cite{Interactive Data Analysis}. New York: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.InsectSprays;
    ## 
    ## # TODO: boxplot
    ## 
    ## # TODO: AOV plots
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = InsectSprays ()
      name = 'InsectSprays';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.iris
    ## @deftypefn {Static Method} {@var{out} =} iris ()
    ##
    ## The Fisher Iris dataset: measurements of various flowers
    ##
    ## @subsubheading Description
    ## 
    ## This is the classic Fisher Iris dataset.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item Species
    ## The species of flower being measured.
    ## @item SepalLength
    ## Length of sepals, in centimeters.
    ## @item SepalWidth
    ## Width of sepals, in centimeters.
    ## @item PetalLength
    ## Length of petals, in centimeters.
    ## @item PetalWidth
    ## Width of petals, in centimeters.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## @url{http://archive.ics.uci.edu/ml/datasets/Iris}
    ## 
    ## @subsubheading References
    ## 
    ## @url{https://en.wikipedia.org/wiki/Iris_flower_data_set}
    ## 
    ## Fisher, R.A. “The use of multiple measurements in taxonomic problems”
    ## Annals of Eugenics, 7, Part II, 179-188 (1936); also in @cite{Contributions 
    ## to Mathematical Statistics} (John Wiley, NY, 1950).
    ## 
    ## Duda, R.O., & Hart, P.E. (1973) @cite{Pattern Classification and Scene Analysis}.
    ## (Q327.D83) John Wiley & Sons. ISBN 0-471-22361-1. See page 218.
    ## 
    ## The data were collected by Anderson, Edgar (1935). The irises of the Gaspe
    ## Peninsula, @cite{Bulletin of the American Iris Society}, 59, 2–5.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # TODO: Port this example from R
    ## @end example
    ##
    ## @end deftypefn
    function out = iris ()
      name = 'iris';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.islands
    ## @deftypefn {Static Method} {@var{out} =} islands ()
    ##
    ## Areas of the World's Major Landmasses
    ##
    ## @subsubheading Description
    ## 
    ## The areas in thousands of square miles of the landmasses which exceed 10,000
    ## square miles.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item name
    ## The name of the island.
    ## @item area
    ## The area, in thousands of square miles.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## @cite{The World Almanac and Book of Facts}, 1975, page 406.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. R. (1977) @cite{Interactive Data Analysis}. Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.islands;
    ## 
    ## # TODO: Port dot chart to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = islands ()
      name = 'islands';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.JohnsonJohnson
    ## @deftypefn {Static Method} {@var{out} =} JohnsonJohnson ()
    ##
    ## Quarterly Earnings per Johnson & Johnson Share
    ##
    ## @subsubheading Description
    ## 
    ## Quarterly earnings (dollars) per Johnson & Johnson share 1960–80.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item date
    ## Start date of the quarter.
    ## @item earnings
    ## Earnings per share (USD).
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Shumway, R. H. and Stoffer, D. S. (2000) @cite{Time Series Analysis and its
    ## Applications}. Second Edition. Springer. Example 1.1.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.JohnsonJohnson
    ## 
    ## # TODO: Yikes, look at all those plots. Port them to Octave.
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = JohnsonJohnson ()
      name = 'JohnsonJohnson';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.LakeHuron
    ## @deftypefn {Static Method} {@var{out} =} LakeHuron ()
    ##
    ## Level of Lake Huron 1875-1972
    ##
    ## @subsubheading Description
    ## 
    ## Annual measurements of the level, in feet, of Lake Huron 1875–1972.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item year
    ## Year of the measurement
    ## @item level
    ## Lake level (ft).
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Brockwell, P. J. and Davis, R. A. (1991). @cite{Time Series and Forecasting
    ## Methods}. Second edition. Springer, New York. Series A, page 555.
    ## 
    ## Brockwell, P. J. and Davis, R. A. (1996). @cite{Introduction to Time Series
    ## and Forecasting}. Springer, New York. Sections 5.1 and 7.6.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.LakeHuron;
    ## 
    ## plot (t.year, t.level)
    ## xlabel ("Year")
    ## ylabel ("Lake level (ft)")
    ## title ("Level of Lake Huron")
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = LakeHuron ()
      name = 'LakeHuron';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.lh
    ## @deftypefn {Static Method} {@var{out} =} lh ()
    ##
    ## Luteinizing Hormone in Blood Samples
    ##
    ## @subsubheading Description
    ## 
    ## A regular time series giving the luteinizing hormone in blood samples at 10
    ## minute intervals from a human female, 48 samples.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item sample
    ## The number of the observation.
    ## @item lh
    ## Level of luteinizing hormone.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## P.J. Diggle (1990) @cite{Time Series: A Biostatistical Introduction}. Oxford,
    ## table A.1, series 3
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.lh;
    ## 
    ## plot (t.sample, t.lh);
    ## xlabel ("Sample Number");
    ## ylabel ("lh level");
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = lh ()
      name = 'lh';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.LifeCycleSavings
    ## @deftypefn {Static Method} {@var{out} =} LifeCycleSavings ()
    ##
    ## Intercountry Life-Cycle Savings Data
    ##
    ## @subsubheading Description
    ## 
    ## Data on the savings ratio 1960–1970.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item country
    ## Name of the country.
    ## @item sr
    ## Aggregate personal savings.
    ## @item pop15
    ## Percentage of population under 15.
    ## @item pop75
    ## Percentage of population over 75.
    ## @item dpi
    ## Real per-capita disposable income.
    ## @item ddpi
    ## Percent growth rate of dpi.
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## Under the life-cycle savings hypothesis as developed by Franco Modigliani, the
    ## savings ratio (aggregate personal saving divided by disposable income) is
    ## explained by per-capita disposable income, the percentage rate of change in
    ## per-capita disposable income, and two demographic variables: the percentage
    ## of population less than 15 years old and the percentage of the population over
    ## 75 years old. The data are averaged over the decade 1960–1970 to remove the
    ## business cycle or other short-term fluctuations.
    ## 
    ## @subsubheading Source
    ## 
    ## The data were obtained from Belsley, Kuh and Welsch (1980). They in turn
    ## obtained the data from Sterling (1977).
    ## 
    ## @subsubheading References
    ## 
    ## Sterling, Arnie (1977) Unpublished BS Thesis. Massachusetts Institute of
    ## Technology.
    ## 
    ## Belsley, D. A., Kuh. E. and Welsch, R. E. (1980) @cite{Regression Diagnostics}.
    ## New York: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.LifeCycleSavings;
    ## 
    ## # TODO: linear model
    ## 
    ## # TODO: pairs plot with Lowess smoothed line
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = LifeCycleSavings ()
      name = 'LifeCycleSavings';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.Loblolly
    ## @deftypefn {Static Method} {@var{out} =} Loblolly ()
    ##
    ## Growth of Loblolly pine trees
    ##
    ## @subsubheading Description
    ## 
    ## Records of the growth of Loblolly pine trees.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item height
    ## Tree height (ft).
    ## @item age
    ## Tree age (years).
    ## @item Seed
    ## Seed source for the tree. Ordering is according to increasing maximum height.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Kung, F. H. (1986), Fitting logistic growth curve with predetermined carrying
    ## capacity, in @cite{Proceedings of the Statistical Computing Section}, American
    ## Statistical Association, 340–343.
    ## 
    ## Pinheiro, J. C. and Bates, D. M. (2000) @cite{Mixed-effects Models in S and
    ## S-PLUS}, Springer.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.Loblolly;
    ## 
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = Loblolly ()
      name = 'Loblolly';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.mtcars
    ## @deftypefn {Static Method} {@var{out} =} mtcars ()
    ##
    ## Motor Trend 1974 Car Road Tests
    ##
    ## @subsubheading Description
    ## 
    ## The data was extracted from the 1974 Motor Trend US magazine, and
    ## comprises fuel consumption and 10 aspects of automobile design and
    ## performance for 32 automobiles (1973–74 models).
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item mpg
    ## Fuel efficiency in miles/gallon
    ## @item cyl
    ## Number of cylinders
    ## @item disp
    ## Displacement (cu. in.)
    ## @item hp
    ## Gross horsepower
    ## @item drat
    ## Rear axle ratio
    ## @item wt
    ## Weight (1,000 lbs)
    ## @item qsec
    ## 1/4 mile time
    ## @item vs
    ## Engine type (0 = V-shaped, 1 = straight)
    ## @item am
    ## Transmission type (0 = automatic, 1 = manual)
    ## @item gear
    ## Number of forward gears
    ## @item carb
    ## Number of carburetors
    ## @end table
    ## 
    ## @subsubheading Note
    ## 
    ## Henderson and Velleman (1981) comment in a footnote to Table 1: “Hocking
    ## [original transcriber]’s noncrucial coding of the Mazda’s rotary engine
    ## as a straight six-cylinder engine and the Porsche’s flat engine as a V
    ## engine, as well as the inclusion of the diesel Mercedes 240D, have been
    ## retained to enable direct comparisons to be made with previous analyses.”
    ## 
    ## @subsubheading Source
    ## 
    ## Henderson and Velleman (1981), “Building multiple regression models
    ## interactively”. Biometrics, 37, 391–411.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # TODO: Port this example from R
    ## @end example
    ##
    ## @end deftypefn
    function out = mtcars ()
      name = 'mtcars';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

  endmethods

endclassdef
