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
    ## Box, G. E. P., Jenkins, G. M. and Reinsel, G. C. (1976). @cite{Time Series
    ## Analysis, Forecasting and Control}. Third Edition. San Francisco: Holden-Day.
    ## Series G.
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
    ## Chambers, J. M., Cleveland, W. S., Kleiner, B. and Tukey, P. A. (1983).
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
    ## 13–14. Cheshire, CT: Graphics Press.
    ## 
    ## @subsubheading References
    ## 
    ## Anscombe, Francis J. (1973). Graphs in statistical analysis. @cite{The
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
    ## Park, CA.
    ## 
    ## @subsubheading References
    ## 
    ## Boore, D. M. and Joyner, W. B. (1982). The empirical prediction of ground
    ## motion. @cite{Bulletin of the Seismological Society of America}, 72, S269–S268.
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
    ## Chatterjee, S. and Price, B. (1977). @cite{Regression Analysis by Example}. New York:
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
    ## Brockwell, P. J. and Davis, R. A. (1996). @cite{Introduction to Time Series and
    ## Forecasting}. New York: Springer-Verlag.
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
    ## L. and Greenhouse, J. (Eds.) (1994) @cite{Case Studies in Biometry}. New York: John Wiley
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
    ## Box, G. E. P. and Jenkins, G. M. (1976). @cite{Time Series Analysis, Forecasting and
    ## Control}. San Francisco: Holden-Day. p. 537.
    ## 
    ## Brockwell, P. J. and Davis, R. A. (1991). @cite{Time Series: Theory and Methods},
    ## Second edition. New York: Springer-Verlag. p. 414.
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
    ## Bates, D.M. and Watts, D.G. (1988). @cite{Nonlinear Regression Analysis and Its
    ## Applications}. New York: John Wiley & Sons. Appendix A1.4.
    ## 
    ## Originally from: Marske (1967). @cite{Biochemical Oxygen Demand Data
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
    ## Ezekiel, M. (1930). @cite{Methods of Correlation Analysis}. New York: Wiley.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. R. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
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
    ## Crowder, M. and Hand, D. (1990). @cite{Analysis of Repeated Measures}. London: Chapman and
    ## Hall. (example 5.3)
    ## 
    ## Hand, D. and Crowder, M. (1996), @cite{Practical Longitudinal Data Analysis}. London: Chapman
    ## and Hall. (table A.2)
    ## 
    ## Pinheiro, J. C. and Bates, D. M. (2000) @cite{Mixed-effects Models in S and S-PLUS}.
    ## New York: Springer.
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
    ## McNeil, D. R. (1977). @code{Interactive Data Analysis}. New York: Wiley.
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
    ## Cleveland, W. S. (1993). @code{Visualizing Data}. New Jersey: Summit Press.
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
    ## McNeil, D. R. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
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
    ## Davidian, M. and Giltinan, D. M. (1995). @cite{Nonlinear Models for Repeated
    ## Measurement Data}. London: Chapman & Hall. (section 5.2.4, p. 134)
    ## 
    ## Pinheiro, J. C. and Bates, D. M. (2000). @cite{Mixed-effects Models in S and
    ## S-PLUS}. New York: Springer.
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
    ## Volume 1: The Analysis of Case-Control Studies}. Oxford: IARC Lyon / Oxford University Press.
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
    ## Crystal, D. Ed. (1990). @cite{The Cambridge Encyclopaedia}. Cambridge:
    ## Cambridge University Press.
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
    ## Bennett, N. A. and N. L. Franklin (1954). @cite{Statistical Analysis in
    ## Chemistry and the Chemical Industry}. New York: Wiley.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. R. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
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
    ## Freeny, A. E. (1977). @cite{A Portable Linear Regression Package with Test
    ## Programs}. Bell Laboratories memorandum.
    ## 
    ## @subsubheading References
    ## 
    ## Becker, R. A., Chambers, J. M. and Wilks, A. R. (1988). @cite{The New S
    ## Language}. Monterey: Wadsworth & Brooks/Cole.
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
    ## Harman, H. H. (1976). @cite{Modern Factor Analysis}, Third Edition Revised.
    ## Chicago: University of Chicago Press. Table 2.3.
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
    ## Harman, H. H. (1976). @cite{Modern Factor Analysis}, Third Edition
    ## Revised. Chicago: University of Chicago Press. Table 7.4.
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
    ## Kwan, Breault, Umbenhauer, McMahon and Duggan (1976). Kinetics of
    ## Indomethacin absorption, elimination, and enterohepatic circulation in man.
    ## @cite{Journal of Pharmacokinetics and Biopharmaceutics} 4, 255–280.
    ## 
    ## Davidian, M. and Giltinan, D. M. (1995). @cite{Nonlinear Models for Repeated
    ## Measurement Data}. London: Chapman & Hall. (section 5.2.4, p. 129)
    ## 
    ## Pinheiro, J. C. and Bates, D. M. (2000). @cite{Mixed-effects Models in S and
    ## S-PLUS}. New York: Springer.
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
    ## Trichopoulos et al (1976). @cite{Br. J. of Obst. and Gynaec.} 83, 645–650.
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
    ## Beall, G., (1942). The Transformation of data from entomological field
    ## experiments. @cite{Biometrika}, 29, 243–262.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
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
    ## Fisher, R. A. (1936). The use of multiple measurements in taxonomic problems.
    ## Annals of Eugenics, 7, Part II, 179-188. also in @cite{Contributions 
    ## to Mathematical Statistics} (John Wiley, NY, 1950).
    ## 
    ## Duda, R.O., & Hart, P.E. (1973). @cite{Pattern Classification and Scene Analysis}.
    ## (Q327.D83) New York: John Wiley & Sons. ISBN 0-471-22361-1. See page 218.
    ## 
    ## The data were collected by Anderson, Edgar (1935). The irises of the Gaspe
    ## Peninsula. @cite{Bulletin of the American Iris Society}, 59, 2–5.
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
    ## McNeil, D. R. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
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
    ## Shumway, R. H. and Stoffer, D. S. (2000). @cite{Time Series Analysis and its
    ## Applications}. Second Edition. New York: Springer. Example 1.1.
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
    ## Methods}. Second edition. New York: Springer. Series A, page 555.
    ## 
    ## Brockwell, P. J. and Davis, R. A. (1996). @cite{Introduction to Time Series
    ## and Forecasting}. New York: Springer. Sections 5.1 and 7.6.
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
    ## P.J. Diggle (1990). @cite{Time Series: A Biostatistical Introduction}. Oxford.
    ## Table A.1, series 3.
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
    ## Sterling, Arnie (1977). Unpublished BS Thesis. Massachusetts Institute of
    ## Technology.
    ## 
    ## Belsley, D. A., Kuh. E. and Welsch, R. E. (1980). @cite{Regression Diagnostics}.
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
    ## Kung, F. H. (1986). Fitting logistic growth curve with predetermined carrying
    ## capacity. @cite{Proceedings of the Statistical Computing Section}, American
    ## Statistical Association, 340–343.
    ## 
    ## Pinheiro, J. C. and Bates, D. M. (2000). @cite{Mixed-effects Models in S and
    ## S-PLUS}. New York: Springer.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.Loblolly;
    ## 
    ## t2 = t(t.Seed == "329",:);
    ## scatter (t2.age, t2.height)
    ## xlabel ("Tree age (yr)");
    ## ylabel ("Tree height (ft)");
    ## title ("Loblolly data and fitted curve (Seed 329 only)")
    ## 
    ## # TODO: Compute and plot fitted curve
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
    ## @node dataset.longley
    ## @deftypefn {Static Method} {@var{out} =} longley ()
    ##
    ## Longley’s Economic Regression Data
    ##
    ## @subsubheading Description
    ## 
    ## A macroeconomic data set which provides a well-known example for a highly
    ## collinear regression.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item Year
    ## The year.
    ## @item GNP_deflator
    ## GNP implicit price deflator (1954=100).
    ## @item GNP
    ## Gross National Product.
    ## @item Unemployed
    ## Number of unemployed.
    ## @item Armed_Forces
    ## Number of people in the armed forces.
    ## @item Population
    ## “Noninstitutionalized” population ≥ 14 years of age.
    ## @item Employed
    ## Number of people employed.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## J. W. Longley (1967). An appraisal of least-squares programs from the point of
    ## view of the user. @cite{Journal of the American Statistical Association}, 62,
    ## 819–841.
    ## 
    ## @subsubheading References
    ## 
    ## Becker, R. A., Chambers, J. M. and Wilks, A. R. (1988). @cite{The New S
    ## Language}. Monterey: Wadsworth & Brooks/Cole.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.longley;
    ## 
    ## # TODO: Linear model
    ## # TODO: opar plot
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = longley ()
      name = 'longley';
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
    ## @node dataset.lynx
    ## @deftypefn {Static Method} {@var{out} =} lynx ()
    ##
    ## Annual Canadian Lynx trappings 1821-1934
    ##
    ## @subsubheading Description
    ## 
    ## Annual numbers of lynx trappings for 1821–1934 in Canada. Taken from Brockwell
    ## & Davis (1991), this appears to be the series considered by Campbell & Walker
    ## (1977).
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item year
    ## Year of the record.
    ## @item lynx
    ## Number of lynx trapped.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Brockwell, P. J. and Davis, R. A. (1991). @cite{Time Series and Forecasting
    ## Methods}. Second edition. New York: Springer. Series G (page 557).
    ## 
    ## @subsubheading References
    ## 
    ## Becker, R. A., Chambers, J. M. and Wilks, A. R. (1988). @cite{The New S
    ## Language}. Monterey: Wadsworth & Brooks/Cole.
    ## 
    ## Campbell, M. J. and Walker, A. M. (1977). A Survey of statistical work on
    ## the Mackenzie River series of annual Canadian lynx trappings for the years
    ## 1821–1934 and a new analysis. @cite{Journal of the Royal Statistical Society
    ## series A}, 140, 411–431. 
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.lynx;
    ## 
    ## plot (t.year, t.lynx);
    ## xlabel ("Year");
    ## ylabel ("Lynx Trapped");
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = lynx ()
      name = 'lynx';
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
    ## @node dataset.morley
    ## @deftypefn {Static Method} {@var{out} =} morley ()
    ##
    ## Michelson Speed of Light Data
    ##
    ## @subsubheading Description
    ## 
    ## A classical data of Michelson (but not this one with Morley) on measurements
    ## done in 1879 on the speed of light. The data consists of five experiments,
    ## each consisting of 20 consecutive ‘runs’. The response is the speed of
    ## light measurement, suitably coded (km/sec, with 299000 subtracted).
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item Expt
    ## The experiment number, from 1 to 5.
    ## @item Run
    ## The run number within each experiment.
    ## @item Speed
    ## Speed-of-light measurement.
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## The data is here viewed as a randomized block experiment with @code{experiment}
    ## and @code{run} as the factors. @code{run} may also be considered a quantitative
    ## variate to account for linear (or polynomial) changes in the measurement over
    ## the course of a single experiment.
    ## 
    ## @subsubheading Source
    ## 
    ## A. J. Weekes (1986). @cite{A Genstat Primer}. London: Edward Arnold.
    ## 
    ## S. M. Stigler (1977). Do robust estimators work with real data? @cite{Annals
    ## of Statistics} 5, 1055–1098. (See Table 6.)
    ## 
    ## A. A. Michelson (1882). Experimental determination of the velocity of
    ## light made at the United States Naval Academy, Annapolis. @cite{Astronomic
    ## Papers}, 1, 135–8. U.S. Nautical Almanac Office. (See Table 24.).
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.morley;
    ## 
    ## # TODO: Port to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = morley ()
      name = 'morley';
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
    ## Henderson and Velleman (1981). Building multiple regression models
    ## interactively. @cite{Biometrics}, 37, 391–411.
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

    ## -*- texinfo -*-
    ## @node dataset.nhtemp
    ## @deftypefn {Static Method} {@var{out} =} nhtemp ()
    ##
    ## Average Yearly Temperatures in New Haven
    ##
    ## @subsubheading Description
    ## 
    ## The mean annual temperature in degrees Fahrenheit in New Haven, Connecticut,
    ## from 1912 to 1971.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item year
    ## Year of the observation.
    ## @item temp
    ## Mean annual temperature (degrees F).
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Vaux, J. E. and Brinker, N. B. (1972) @cite{Cycles}, 1972, 117–121.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. R. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.nhtemp;
    ## 
    ## plot (t.year, t.temp);
    ## title ("nhtemp data");
    ## xlabel ("Mean annual temperature in New Haven, CT (deg. F)");
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = nhtemp ()
      name = 'nhtemp';
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
    ## @node dataset.Nile
    ## @deftypefn {Static Method} {@var{out} =} Nile ()
    ##
    ## Flow of the River Nile
    ##
    ## @subsubheading Description
    ## 
    ## Measurements of the annual flow of the river Nile at Aswan (formerly Assuan),
    ## 1871–1970, in m^3, “with apparent changepoint near 1898”
    ## (Cobb(1978), Table 1, p.249).
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item year
    ## Year of the record.
    ## @item flow
    ## Annual flow (cubic meters).
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Durbin, J. and Koopman, S. J. (2001). @cite{Time Series Analysis by State
    ## Space Methods}. Oxford: Oxford University Press. @url{http://www.ssfpack.com/DKbook.html}
    ## 
    ## @subsubheading References
    ## 
    ## Balke, N. S. (1993). Detecting level shifts in time series. @cite{Journal of
    ## Business and Economic Statistics}, 11, 81–92.
    ## 
    ## Cobb, G. W. (1978). The problem of the Nile: conditional solution to a
    ## change-point problem. @cite{Biometrika} 65, 243–51.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.Nile;
    ## 
    ## figure
    ## plot (t.year, t.flow);
    ## 
    ## # TODO: Port the rest of the example to Octave
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = Nile ()
      name = 'Nile';
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
    ## @node dataset.nottem
    ## @deftypefn {Static Method} {@var{out} =} nottem ()
    ##
    ## Average Monthly Temperatures at Nottingham, 1920-1939
    ##
    ## @subsubheading Description
    ## 
    ## A time series object containing average air temperatures at
    ## Nottingham Castle in degrees Fahrenheit for 20 years.
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
    ## Anderson, O. D. (1976). @cite{Time Series Analysis and Forecasting:
    ## The Box-Jenkins approach}. London: Butterworths. Series R.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # TODO: Come up with example code here
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = nottem ()
      name = 'nottem';
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
    ## @node dataset.npk
    ## @deftypefn {Static Method} {@var{out} =} npk ()
    ##
    ## Classical N, P, K Factorial Experiment
    ##
    ## @subsubheading Description
    ## 
    ## A classical N, P, K (nitrogen, phosphate, potassium) factorial experiment
    ## on the growth of peas conducted on 6 blocks. Each half of a fractional
    ## factorial design confounding the NPK interaction was used on 3 of the plots.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item block
    ## Which block (1 to 6).
    ## @item N
    ## Indicator (0/1) for the application of nitrogen.
    ## @item P
    ## Indicator (0/1) for the application of phosphate.
    ## @item K
    ## Indicator (0/1) for the application of potassium.
    ## @item yield
    ## Yield of peas, in pounds/plot. Plots were 1/70 acre.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Imperial College, London, M.Sc. exercise sheet.
    ## 
    ## @subsubheading References
    ## 
    ## Venables, W. N. and Ripley, B. D. (2002). @cite{Modern Applied Statistics
    ## with S}. Fourth edition. New York: Springer.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.npk;
    ## 
    ## # TODO: Port aov() and LM to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = npk ()
      name = 'npk';
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
    ## @node dataset.occupationalStatus
    ## @deftypefn {Static Method} {@var{out} =} occupationalStatus ()
    ##
    ## Occupational Status of Fathers and their Sons
    ##
    ## @subsubheading Description
    ## 
    ## Cross-classification of a sample of British males according to each subject’s
    ## occupational status and his father’s occupational status.
    ## 
    ## @subsubheading Format
    ## 
    ## An 8-by-8 matrix of counts, with classifying fators @code{origin} (father’s
    ## occupational status, levels 1:8) and @code{destination} (son’s
    ## occupational status, levels 1:8).
    ## 
    ## @subsubheading Source
    ## 
    ## Goodman, L. A. (1979). Simple Models for the Analysis of Association in
    ## Cross-Classifications having Ordered Categories. @cite{J. Am. Stat.
    ## Assoc.}, 74 (367), 537–552.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # TODO: Come up with example code here
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = occupationalStatus ()
      name = 'occupationalStatus';
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
    ## @node dataset.Orange
    ## @deftypefn {Static Method} {@var{out} =} Orange ()
    ##
    ## Growth of Orange Trees
    ##
    ## @subsubheading Description
    ## 
    ## Records of the growth of orange trees.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item Tree
    ## A categorical indicating on which tree the measurement is made.
    ## Ordering is according to increasing maximum diameter.
    ## @item age
    ## Age of the tree (days since 1968-12-31).
    ## @item circumference
    ## Trunk circumference (mm).
    ## This is probably “circumference at breast height”, a standard measurement in forestry.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## The data are given in Box & Jenkins (1976). Obtained from the Time Series Data
    ## Library at @url{http://www-personal.buseco.monash.edu.au/~hyndman/TSDL/}.
    ## 
    ## @subsubheading References
    ## 
    ## Draper, N. R. and Smith, H. (1998). @cite{Applied Regression Analysis (3rd ed)}.
    ## New York: Wiley. (exercise 24.N).
    ## 
    ## Pinheiro, J. C. and Bates, D. M. (2000). @cite{Mixed-effects Models in S and
    ## S-PLUS}. New York: Springer.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.Orange;
    ## 
    ## # TODO: Port coplot to Octave
    ## 
    ## # TODO: Linear model
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = Orange ()
      name = 'Orange';
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
    ## @node dataset.OrchardSprays
    ## @deftypefn {Static Method} {@var{out} =} OrchardSprays ()
    ##
    ## Potency of Orchard Sprays
    ##
    ## @subsubheading Description
    ## 
    ## An experiment was conducted to assess the potency of various constituents
    ## of orchard sprays in repelling honeybees, using a Latin square design.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item rowpos
    ## Row of the design.
    ## @item colpos
    ## Column of the design
    ## @item treatment
    ## Treatment level.
    ## @item decrease
    ## Response.
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## Individual cells of dry comb were filled with measured amounts of lime
    ## sulphur emulsion in sucrose solution. Seven different concentrations of lime
    ## sulphur ranging from a concentration of 1/100 to 1/1,562,500 in successive
    ## factors of 1/5 were used as well as a solution containing no lime sulphur.
    ## 
    ## The responses for the different solutions were obtained by releasing 100
    ## bees into the chamber for two hours, and then measuring the decrease in volume
    ## of the solutions in the various cells.
    ## 
    ## An 8 x 8 Latin square design was used and the treatments were coded as follows:
    ## 
    ## A – highest level of lime sulphur
    ## B – next highest level of lime sulphur
    ## @dots{}
    ## G – lowest level of lime sulphur
    ## H – no lime sulphur
    ## 
    ## @subsubheading Source
    ## 
    ## Finney, D. J. (1947). @cite{Probit Analysis}. Cambridge.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. R. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.OrchardSprays;
    ## 
    ## octave.examples.plot_pairs (t);
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = OrchardSprays ()
      name = 'OrchardSprays';
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
    ## @node dataset.PlantGrowth
    ## @deftypefn {Static Method} {@var{out} =} PlantGrowth ()
    ##
    ## Results from an Experiment on Plant Growth
    ##
    ## @subsubheading Description
    ## 
    ## Results from an experiment to compare yields (as measured by dried weight of
    ## plants) obtained under a control and two different treatment conditions.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item group
    ## Treatment condition group.
    ## @item weight
    ## Weight of plants.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Dobson, A. J. (1983). @cite{An Introduction to Statistical Modelling}.
    ## London: Chapman and Hall.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.PlantGrowth;
    ## 
    ## # TODO: Port anova to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = PlantGrowth ()
      name = 'PlantGrowth';
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
    ## @node dataset.precip
    ## @deftypefn {Static Method} {@var{out} =} precip ()
    ##
    ## Annual Precipitation in US Cities
    ##
    ## @subsubheading Description
    ## 
    ## The average amount of precipitation (rainfall) in inches for each of 70 United
    ## States (and Puerto Rico) cities.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item city
    ## City observed.
    ## @item precip
    ## Annual precipitation (in).
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## @cite{Statistical Abstracts of the United States}, 1975.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. R. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.precip;
    ## 
    ## # TODO: Port dot plot to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = precip ()
      name = 'precip';
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
    ## @node dataset.presidents
    ## @deftypefn {Static Method} {@var{out} =} presidents ()
    ##
    ## Quarterly Approval Ratings of US Presidents
    ##
    ## @subsubheading Description
    ## 
    ## The (approximately) quarterly approval rating for the President of the United
    ## States from the first quarter of 1945 to the last quarter of 1974.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item date
    ## Approximate date of the observation.
    ## @item approval
    ## Approval rating (%).
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## The data are actually a fudged version of the approval ratings. See McNeil’s book
    ## for details.
    ## 
    ## @subsubheading Source
    ## 
    ## The Gallup Organisation.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. R. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.presidents;
    ## 
    ## figure
    ## plot (datenum (t.date), t.approval)
    ## datetick ("x")
    ## xlabel ("Date")
    ## ylabel ("Approval rating (%)")
    ## title ("presidents data")
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = presidents ()
      name = 'presidents';
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
    ## @node dataset.pressure
    ## @deftypefn {Static Method} {@var{out} =} pressure ()
    ##
    ## Vapor Pressure of Mercury as a Function of Temperature
    ##
    ## @subsubheading Description
    ## 
    ## Data on the relation between temperature in degrees Celsius and vapor pressure
    ## of mercury in millimeters (of mercury).
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item temperature
    ## Temperature (deg C).
    ## @item pressure
    ## Pressure (mm Hg).
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Weast, R. C., ed. (1973). @cite{Handbook of Chemistry and Physics}. Cleveland: CRC Press.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. R. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.pressure;
    ## 
    ## figure
    ## plot (t.temperature, t.pressure)
    ## xlabel ("Temperature (deg C)")
    ## ylabel ("Pressure (mm of Hg)")
    ## title ("pressure data: Vapor Pressure of Mercury")
    ## 
    ## figure
    ## semilogy (t.temperature, t.pressure)
    ## xlabel ("Temperature (deg C)")
    ## ylabel ("Pressure (mm of Hg)")
    ## title ("pressure data: Vapor Pressure of Mercury")
    ## 
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = pressure ()
      name = 'pressure';
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
    ## @node dataset.Puromycin
    ## @deftypefn {Static Method} {@var{out} =} Puromycin ()
    ##
    ## Reaction Velocity of an Enzymatic Reaction
    ##
    ## @subsubheading Description
    ## 
    ## Reaction velocity versus substrate concentration in an enzymatic reaction
    ## involving untreated cells or cells treated with Puromycin.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item state
    ## Whether the cell was treated.
    ## @item conc
    ## Substrate concentrations (ppm).
    ## @item rate
    ## Instantaneous reaction rates (counts/min/min).
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## Data on the velocity of an enzymatic reaction were obtained by Treloar
    ## (1974). The number of counts per minute of radioactive product from the
    ## reaction was measured as a function of substrate concentration in parts per
    ## million (ppm) and from these counts the initial rate (or velocity) of the
    ## reaction was calculated (counts/min/min). The experiment was conducted once
    ## with the enzyme treated with Puromycin, and once with the enzyme untreated.
    ## 
    ## @subsubheading Source
    ## 
    ## The data are given in Box & Jenkins (1976). Obtained from the Time Series Data
    ## Library at @url{http://www-personal.buseco.monash.edu.au/~hyndman/TSDL/}.
    ## 
    ## @subsubheading References
    ## 
    ## Bates, D.M. and Watts, D.G. (1988). @cite{Nonlinear Regression Analysis and
    ## Its Applications}. New York: Wiley. Appendix A1.3.
    ## 
    ## Treloar, M. A. (1974). @cite{Effects of Puromycin on Galactosyltransferase
    ## in Golgi Membranes}. M.Sc. Thesis, U. of Toronto.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.Puromycin;
    ## 
    ## # TODO: Port example to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = Puromycin ()
      name = 'Puromycin';
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
    ## @node dataset.quakes
    ## @deftypefn {Static Method} {@var{out} =} quakes ()
    ##
    ## Locations of Earthquakes off Fiji
    ##
    ## @subsubheading Description
    ## 
    ## The data set give the locations of 1000 seismic events of MB > 4.0. The events
    ## occurred in a cube near Fiji since 1964.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item lat
    ## Latitude of event.
    ## @item long
    ## Longitude of event.
    ## @item depth
    ## Depth (km).
    ## @item mag
    ## Richter magnitude.
    ## @item stations
    ## Number of stations reporting.
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## There are two clear planes of seismic activity. One is a major plate junction;
    ## the other is the Tonga trench off New Zealand. These data constitute a subsample
    ## from a larger dataset of containing 5000 observations.
    ## 
    ## @subsubheading Source
    ## 
    ## This is one of the Harvard PRIM-H project data sets. They in turn obtained it
    ## from Dr. John Woodhouse, Dept. of Geophysics, Harvard University.
    ## 
    ## @subsubheading References
    ## 
    ## G. E. P. Box and G. M. Jenkins (1976). @cite{Time Series Analysis, Forecasting and
    ## Control}. San Francisco: Holden-Day. p. 537.
    ## 
    ## P. J. Brockwell and R. A. Davis (1991). @cite{Time Series: Theory and Methods}.
    ## Second edition. New York: Springer-Verlag. p. 414.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # TODO: Come up with example code here
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = quakes ()
      name = 'quakes';
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
    ## @node dataset.randu
    ## @deftypefn {Static Method} {@var{out} =} randu ()
    ##
    ## Random Numbers from Congruential Generator RANDU
    ##
    ## @subsubheading Description
    ## 
    ## 400 triples of successive random numbers were taken from the VAX FORTRAN
    ## function RANDU running under VMS 1.5.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item record
    ## Index of the record.
    ## @item x
    ## X value of the triple.
    ## @item y
    ## Y value of the triple.
    ## @item z
    ## Z value of the triple.
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## In three dimensional displays it is evident that the triples fall on 15
    ## parallel planes in 3-space. This can be shown theoretically to be true
    ## for all triples from the RANDU generator.
    ## 
    ## These particular 400 triples start 5 apart in the sequence, that is they
    ## are ((U[5i+1], U[5i+2], U[5i+3]), i= 0, ..., 399), and they are rounded
    ## to 6 decimal places.
    ## 
    ## Under VMS versions 2.0 and higher, this problem has been fixed.
    ## 
    ## @subsubheading Source
    ## 
    ## David Donoho
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.randu;
    ## 
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = randu ()
      name = 'randu';
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
    ## @node dataset.rivers
    ## @deftypefn {Static Method} {@var{out} =} rivers ()
    ##
    ## Lengths of Major North American Rivers
    ##
    ## @subsubheading Description
    ## 
    ## This data set gives the lengths (in miles) of 141 “major” rivers in North
    ## America, as compiled by the US Geological Survey.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item rivers
    ## A vector containing 141 observations.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## @cite{World Almanac and Book of Facts}, 1975, page 406.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. R. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## octave.dataset.rivers;
    ## 
    ## longest_river = max (rivers)
    ## shortest_river = min (rivers)
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = rivers ()
      name = 'rivers';
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
    ## @node dataset.rock
    ## @deftypefn {Static Method} {@var{out} =} rock ()
    ##
    ## Measurements on Petroleum Rock Samples
    ##
    ## @subsubheading Description
    ## 
    ## Measurements on 48 rock samples from a petroleum reservoir.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item area
    ## Area of pores space, in pixels out of 256 by 256.
    ## @item peri
    ## Perimeter in pixels.
    ## @item shape
    ## Perimeter/sqrt(area).
    ## @item perm
    ## Permeability in milli-Darcies.
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## Twelve core samples from petroleum reservoirs were sampled by 4
    ## cross-sections. Each core sample was measured for permeability, and each
    ## cross-section has total area of pores, total perimeter of pores, and shape.
    ## 
    ## @subsubheading Source
    ## 
    ## Data from BP Research, image analysis by Ronit Katz, U. Oxford.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.rock;
    ## 
    ## figure
    ## scatter (t.area, t.perm)
    ## xlabel ("Area of pores space (pixels out of 256x256)")
    ## ylabel ("Permeability (milli-Darcies)")
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = rock ()
      name = 'rock';
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
    ## @node dataset.sleep
    ## @deftypefn {Static Method} {@var{out} =} sleep ()
    ##
    ## Student’s Sleep Data
    ##
    ## @subsubheading Description
    ## 
    ## Data which show the effect of two soporific drugs (increase in hours of sleep
    ## compared to control) on 10 patients.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item id
    ## Patient ID.
    ## @item group
    ## Drug given.
    ## @item extra
    ## Increase in hours of sleep.
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## The @code{group} variable name may be misleading about the data: They
    ## represent measurements on 10 persons, not in groups.
    ## 
    ## @subsubheading Source
    ## 
    ## Cushny, A. R. and Peebles, A. R. (1905). The action of optical isomers:
    ## II hyoscines. @cite{The Journal of Physiology}, 32, 501–510.
    ## 
    ## Student (1908). The probable error of the mean. @cite{Biometrika}, 6, 20.
    ## 
    ## @subsubheading References
    ## 
    ## Scheffé, Henry (1959). @cite{The Analysis of Variance}. New York, NY: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.sleep;
    ## 
    ## # TODO: Port to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = sleep ()
      name = 'sleep';
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
    ## @node dataset.stackloss
    ## @deftypefn {Static Method} {@var{out} =} stackloss ()
    ##
    ## Brownlee's Stack Loss Plant Data
    ##
    ## @subsubheading Description
    ## 
    ## Operational data of a plant for the oxidation of ammonia to nitric acid.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item AirFlow
    ## Flow of cooling air.
    ## @item WaterTemp
    ## Cooling Water Inlet temperature.
    ## @item AcidConc
    ## Concentration of acid (per 1000, minus 500).
    ## @item StackLoss
    ## Stack loss
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## “Obtained from 21 days of operation of a plant for the oxidation of ammonia
    ## (NH3) to nitric acid (HNO3). The nitric oxides produced are absorbed in a
    ## countercurrent absorption tower”. (Brownlee, cited by Dodge, slightly reformatted by MM.)
    ## 
    ## @code{AirFlow} represents the rate of operation of the plant. @code{WaterTemp} is the
    ## temperature of cooling water circulated through coils in the absorption tower.
    ## @code{AcidConc} is the concentration of the acid circulating, minus 50, times 10:
    ## that is, 89 corresponds to 58.9 per cent acid. @code{StackLoss} (the dependent variable)
    ## is 10 times the percentage of the ingoing ammonia to the plant that escapes from
    ## the absorption column unabsorbed; that is, an (inverse) measure of the over-all
    ## efficiency of the plant.
    ## 
    ## @subsubheading Source
    ## 
    ## Brownlee, K. A. (1960, 2nd ed. 1965). @cite{Statistical Theory and Methodology
    ## in Science and Engineering}. New York: Wiley. pp. 491–500.
    ## 
    ## @subsubheading References
    ## 
    ## Becker, R. A., Chambers, J. M. and Wilks, A. R. (1988). @cite{The New S
    ## Language}. Monterey: Wadsworth & Brooks/Cole.
    ## 
    ## Dodge, Y. (1996). The guinea pig of multiple regression. In: @cite{Robust
    ## Statistics, Data Analysis, and Computer Intensive Methods; In Honor of
    ## Peter Huber’s 60th Birthday}, 1996, @cite{Lecture Notes in Statistics}
    ## 109, Springer-Verlag, New York.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.stackloss;
    ## 
    ## # TODO: Create linear model and print summary
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = stackloss ()
      name = 'stackloss';
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
    ## @node dataset.state
    ## @deftypefn {Static Method} {@var{out} =} state ()
    ##
    ## US State Facts and Figures
    ##
    ## @subsubheading Description
    ## 
    ## Data related to the 50 states of the United States of America.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item abb
    ## State abbreviation.
    ## @item name
    ## State name.
    ## @item area
    ## Area (sq mi).
    ## @item lat
    ## Approximate center (latitude).
    ## @item lon
    ## Approximate center (longitude).
    ## @item division
    ## State division.
    ## @item revion
    ## State region.
    ## @item Population
    ## Population estimate as of July 1, 1975.
    ## @item Income
    ## Per capita income (1974).
    ## @item Illiteracy
    ## Illiteracy as of 1970 (percent of population).
    ## @item LifeExp
    ## Lfe expectancy in years (1969-71).
    ## @item Murder
    ## Murder and non-negligent manslaughter rate per 100,000 population (1976).
    ## @item HSGrad
    ## Percent high-school graduates (1970).
    ## @item Frost
    ## Mean number of days with minimum temperature below freezing (1931-1960)
    ## in capital or large city.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## U.S. Department of Commerce, Bureau of the Census (1977) @cite{Statistical
    ## Abstract of the United States}.
    ## 
    ## U.S. Department of Commerce, Bureau of the Census (1977) @cite{County
    ## and City Data Book}.
    ## 
    ## @subsubheading References
    ## 
    ## Becker, R. A., Chambers, J. M. and Wilks, A. R. (1988). @cite{The New S
    ## Language}. Monterey: Wadsworth & Brooks/Cole.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.state;
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = state ()
      name = 'state';
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
    ## @node dataset.sunspot_month
    ## @deftypefn {Static Method} {@var{out} =} sunspot_month ()
    ##
    ## Monthly Sunspot Data, from 1749 to “Present”
    ##
    ## @subsubheading Description
    ## 
    ## Monthly numbers of sunspots, as from the World Data Center, aka SIDC. This
    ## is the version of the data that may occasionally be updated when new counts
    ## become available.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item month
    ## Month of the observation.
    ## @item sunspots
    ## Number of sunspots.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## WDC-SILSO, Solar Influences Data Analysis Center (SIDC), Royal Observatory
    ## of Belgium, Av. Circulaire, 3, B-1180 BRUSSELS.
    ## Currently at @url{http://www.sidc.be/silso/datafiles}.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.sunspot_month;
    ## 
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = sunspot_month ()
      name = 'sunspot_month';
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
    ## @node dataset.sunspot_year
    ## @deftypefn {Static Method} {@var{out} =} sunspot_year ()
    ##
    ## Yearly Sunspot Data, 1700-1988
    ##
    ## @subsubheading Description
    ## 
    ## Yearly numbers of sunspots from 1700 to 1988 (rounded to one digit).
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item year
    ## Year of the observation.
    ## @item sunspots
    ## Number of sunspots.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## H. Tong (1996) @cite{Non-Linear Time Series}. Clarendon Press, Oxford, p. 471.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.sunspot_year;
    ## 
    ## figure
    ## plot (t.year, t.sunspots)
    ## xlabel ("Year")
    ## ylabel ("Sunspots")
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = sunspot_year ()
      name = 'sunspot_year';
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
    ## @node dataset.sunspots
    ## @deftypefn {Static Method} {@var{out} =} sunspots ()
    ##
    ## Monthly Sunspot Numbers, 1749-1983
    ##
    ## @subsubheading Description
    ## 
    ## Monthly mean relative sunspot numbers from 1749 to 1983. Collected at Swiss
    ## Federal Observatory, Zurich until 1960, then Tokyo Astronomical Observatory.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item month
    ## Month of the observation.
    ## @item sunspots
    ## Number of observed sunspots.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Andrews, D. F. and Herzberg, A. M. (1985) @cite{Data: A Collection
    ## of Problems from Many Fields for the Student and Research Worker}. 
    ## New York: Springer-Verlag.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.sunspots;
    ## 
    ## figure
    ## plot (datenum (t.month), t.sunspots)
    ## datetick ("x")
    ## xlabel ("Date")
    ## ylabel ("Monthly sunspot numbers")
    ## title ("sunspots data")
    ## 
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = sunspots ()
      name = 'sunspots';
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
    ## @node dataset.swiss
    ## @deftypefn {Static Method} {@var{out} =} swiss ()
    ##
    ## Swiss Fertility and Socioeconomic Indicators (1888) Data
    ##
    ## @subsubheading Description
    ## 
    ## Standardized fertility measure and socio-economic indicators for each of 47
    ## French-speaking provinces of Switzerland at about 1888.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item Fertility
    ## Ig, ‘common standardized fertility measure’.
    ## @item Agriculture
    ## % of males involved in agriculture as occupation.
    ## @item Examination
    ## % draftees receiving highest mark on army examination.
    ## @item Education
    ## % education beyond primary school for draftees.
    ## @item Catholic
    ## % ‘Catholic’ (as opposed to ‘Protestant’).
    ## @item InfantMortality
    ## Live births who live less than 1 year.
    ## @end table
    ## 
    ## All variables but ‘Fertility’ give proportions of the population.
    ## 
    ## @subsubheading Source
    ## 
    ## (paraphrasing Mosteller and Tukey):
    ## 
    ## Switzerland, in 1888, was entering a period known as the demographic transition;
    ## i.e., its fertility was beginning to fall from the high level typical of
    ## underdeveloped countries.
    ## 
    ## The data collected are for 47 French-speaking “provinces” at about 1888.
    ## 
    ## Here, all variables are scaled to [0, 100], where in the original, all but
    ## @code{Catholic} were scaled to [0, 1].
    ## 
    ## @subsubheading Note
    ## 
    ## Files for all 182 districts in 1888 and other years have been available at 
    ## @url{https://opr.princeton.edu/archive/pefp/switz.aspx}.
    ## 
    ## They state that variables @code{Examination} and @code{Education} are averages
    ## for 1887, 1888 and 1889.
    ## 
    ## @subsubheading References
    ## 
    ## Becker, R. A., Chambers, J. M. and Wilks, A. R. (1988). @cite{The New S
    ## Language}. Monterey: Wadsworth & Brooks/Cole.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.swiss;
    ## 
    ## # TODO: Port linear model to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = swiss ()
      name = 'swiss';
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
    ## @node dataset.Theoph
    ## @deftypefn {Static Method} {@var{out} =} Theoph ()
    ##
    ## Pharmacokinetics of Theophylline
    ##
    ## @subsubheading Description
    ## 
    ## An experiment on the pharmacokinetics of theophylline.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item Subject
    ## Categorical identifying the subject on whom the observation was made. The
    ## ordering is by increasing maximum concentration of theophylline observed.
    ## @item Wt
    ## Weight of the subject (kg).
    ## @item Dose
    ## Dose of theophylline administerred orally to the subject (mg/kg).
    ## @item Time
    ## Time since drug administration when the sample was drawn (hr).
    ## @item conc
    ## Theophylline concentration in the sample (mg/L).
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## Boeckmann, Sheiner and Beal (1994) report data from a study by Dr. Robert
    ## Upton of the kinetics of the anti-asthmatic drug theophylline. Twelve subjects
    ## were given oral doses of theophylline then serum concentrations were measured
    ## at 11 time points over the next 25 hours.
    ## 
    ## These data are analyzed in Davidian and Giltinan (1995) and Pinheiro and Bates
    ## (2000) using a two-compartment open pharmacokinetic model, for which a
    ## self-starting model function, SSfol, is available.
    ## 
    ## @subsubheading Source
    ## 
    ## The data are given in Box & Jenkins (1976). Obtained from the Time Series Data
    ## Library at @url{http://www-personal.buseco.monash.edu.au/~hyndman/TSDL/}.
    ## 
    ## @subsubheading References
    ## 
    ## Boeckmann, A. J., Sheiner, L. B. and Beal, S. L. (1994). @cite{NONMEM Users
    ## Guide: Part V}. NONMEM Project Group, University of California, San Francisco.
    ## 
    ## Davidian, M. and Giltinan, D. M. (1995). @cite{Nonlinear Models for Repeated
    ## Measurement Data}. London: Chapman & Hall. (section 5.5, p. 145 and section 6.6, p. 176)
    ## 
    ## Pinheiro, J. C. and Bates, D. M. (2000). @cite{Mixed-effects Models in
    ## S and S-PLUS}. New York: Springer. (Appendix A.29)
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.Theoph;
    ## 
    ## # TODO: Coplot
    ## # TODO: Yet another linear model to port to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = Theoph ()
      name = 'Theoph';
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
    ## @node dataset.Titanic
    ## @deftypefn {Static Method} {@var{out} =} Titanic ()
    ##
    ## Survival of passengers on the Titanic
    ##
    ## @subsubheading Description
    ## 
    ## This data set provides information on the fate of passengers on the fatal
    ## maiden voyage of the ocean liner ‘Titanic’, summarized according to
    ## economic status (class), sex, age and survival.
    ## 
    ## @subsubheading Format
    ## 
    ## @code{n} is a 4-dimensional array resulting from cross-tabulating 2201 observations
    ## on 4 variables. The dimensions of the array correspond to the following variables:
    ## 
    ## @table @code
    ## @item Class
    ## 1st, 2nd, 3rd, Cre.
    ## @item Sex
    ## Male, Female.
    ## @item Age
    ## Child, Adult.
    ## @item Survived
    ## No, Yes.
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## The sinking of the Titanic is a famous event, and new books are still being
    ## published about it. Many well-known facts—from the proportions of first-class
    ## passengers to the ‘women and children first’ policy, and the fact that that
    ## policy was not entirely successful in saving the women and children in the
    ## third class—are reflected in the survival rates for various classes of
    ## passenger.
    ## 
    ## These data were originally collected by the British Board of Trade in their
    ## investigation of the sinking. Note that there is not complete agreement among
    ## primary sources as to the exact numbers on board, rescued, or lost.
    ## 
    ## Due in particular to the very successful film ‘Titanic’, the last years saw a
    ## rise in public interest in the Titanic. Very detailed data about the passengers
    ## is now available on the Internet, at sites such as Encyclopedia Titanica
    ## (@url{https://www.encyclopedia-titanica.org/}).
    ## 
    ## @subsubheading Source
    ## 
    ## Dawson, Robert J. MacG. (1995). The ‘Unusual Episode’ Data Revisited.
    ## @cite{Journal of Statistics Education}, 3.
    ## 
    ## The source provides a data set recording class, sex, age, and survival status
    ## for each person on board of the Titanic, and is based on data originally
    ## collected by the British Board of Trade and reprinted in:
    ## 
    ## British Board of Trade (1990). @cite{Report on the Loss of the ‘Titanic’
    ## (S.S.)}. British Board of Trade Inquiry Report (reprint). Gloucester,
    ## UK: Allan Sutton Publishing.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## octave.dataset.Titanic;
    ## 
    ## # TODO: Port mosaic plot to Octave
    ## 
    ## # TODO: Check for higher survival rates in children and females
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = Titanic ()
      name = 'Titanic';
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
    ## @node dataset.ToothGrowth
    ## @deftypefn {Static Method} {@var{out} =} ToothGrowth ()
    ##
    ## The Effect of Vitamin C on Tooth Growth in Guinea Pigs
    ##
    ## @subsubheading Description
    ## 
    ## The response is the length of odontoblasts (cells responsible for tooth growth)
    ## in 60 guinea pigs. Each animal received one of three dose levels of vitamin C
    ## (0.5, 1, and 2 mg/day) by one of two delivery methods, orange juice or
    ## ascorbic acid (a form of vitamin C and coded as @code{VC}).
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item supp
    ## Supplement type.
    ## @item dose
    ## Dose (mg/day).
    ## @item len
    ## Tooth length.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## C. I. Bliss (1952). @cite{The Statistics of Bioassay}. Academic Press.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. R. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
    ## 
    ## Crampton, E. W. (1947). The growth of the odontoblast of the incisor
    ## teeth as a criterion of vitamin C intake of the guinea pig. @cite{The
    ## Journal of Nutrition}, 33(5), 491–504.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.ToothGrowth;
    ## 
    ## octave.examples.coplot (t, "dose", "len", "supp");
    ## 
    ## # TODO: Port Lowess smoothing to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = ToothGrowth ()
      name = 'ToothGrowth';
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
    ## @node dataset.treering
    ## @deftypefn {Static Method} {@var{out} =} treering ()
    ##
    ## Yearly Treering Data, -6000-1979
    ##
    ## @subsubheading Description
    ## 
    ## Contains normalized tree-ring widths in dimensionless units.
    ## 
    ## @subsubheading Format
    ## 
    ## A univariate time series with 7981 observations.
    ## 
    ## Each tree ring corresponds to one year.
    ## 
    ## @subsubheading Details
    ## 
    ## The data were recorded by Donald A. Graybill, 1980, from Gt Basin
    ## Bristlecone Pine 2805M, 3726-11810 in Methuselah Walk, California.
    ## 
    ## @subsubheading Source
    ## 
    ## Time Series Data Library: @url{http://www-personal.buseco.monash.edu.au/~hyndman/TSDL/},
    ## series ‘CA535.DAT’.
    ## 
    ## @subsubheading References
    ## 
    ## For some photos of Methuselah Walk see
    ## @url{https://web.archive.org/web/20110523225828/http://www.ltrr.arizona.edu/~hallman/sitephotos/meth.html}.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.treering;
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = treering ()
      name = 'treering';
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
    ## @node dataset.trees
    ## @deftypefn {Static Method} {@var{out} =} trees ()
    ##
    ## Diameter, Height and Volume for Black Cherry Trees
    ##
    ## @subsubheading Description
    ## 
    ## This data set provides measurements of the diameter, height and volume of
    ## timber in 31 felled black cherry trees. Note that the diameter (in inches)
    ## is erroneously labelled Girth in the data. It is measured at 4 ft 6 in
    ## above the ground.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item Girth
    ## Tree diameter (rather than girth, actually) in inches.
    ## @item Height
    ## Height in ft.
    ## @item Volume
    ## Volume of timber in cubic feet.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Ryan, T. A., Joiner, B. L. and Ryan, B. F. (1976). @cite{The Minitab
    ## Student Handbook}. Duxbury Press.
    ## 
    ## @subsubheading References
    ## 
    ## Atkinson, A. C. (1985). @cite{Plots, Transformations and Regression}.
    ## Oxford: Oxford University Press.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.trees;
    ## 
    ## figure
    ## octave.examples.plot_pairs (t);
    ## 
    ## figure
    ## loglog (t.Girth, t.Volume)
    ## xlabel ("Girth")
    ## ylabel ("Volume")
    ## 
    ## # TODO: Transform to log space for the coplot
    ## 
    ## # TODO: Linear model
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = trees ()
      name = 'trees';
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
    ## @node dataset.UCBAdmissions
    ## @deftypefn {Static Method} {@var{out} =} UCBAdmissions ()
    ##
    ## Student Admissions at UC Berkeley
    ##
    ## @subsubheading Description
    ## 
    ## Aggregate data on applicants to graduate school at Berkeley for the six
    ## largest departments in 1973 classified by admission and sex.
    ## 
    ## @subsubheading Format
    ## 
    ## A 3-dimensional array resulting from cross-tabulating 4526 observations on
    ## 3 variables. The variables and their levels are as follows:
    ## 
    ## @table @code
    ## @item Admit
    ## Admitted, Rejected.
    ## @item Gender
    ## Male, Female.
    ## @item Dept
    ## A, B, C, D, E, F.
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## This data set is frequently used for illustrating Simpson's paradox, see
    ## Bickel et al (1975). At issue is whether the data show evidence of sex bias
    ## in admission practices. There were 2691 male applicants, of whom 1198 (44.5%)
    ## were admitted, compared with 1835 female applicants of whom 557 (30.4%) were
    ## admitted. This gives a sample odds ratio of 1.83, indicating that males were
    ## almost twice as likely to be admitted. In fact, graphical methods (as in the
    ## example below) or log-linear modelling show that the apparent association
    ## between admission and sex stems from differences in the tendency of males
    ## and females to apply to the individual departments (females used to apply
    ## more to departments with higher rejection rates).
    ## 
    ## @subsubheading Source
    ## 
    ## The data are given in Box & Jenkins (1976). Obtained from the Time Series Data
    ## Library at @url{http://www-personal.buseco.monash.edu.au/~hyndman/TSDL/}.
    ## 
    ## @subsubheading References
    ## 
    ## Bickel, P. J., Hammel, E. A., and O'Connell, J. W. (1975). Sex bias in
    ## graduate admissions: Data from Berkeley. @cite{Science}, 187, 398–403. 
    ## @url{http://www.jstor.org/stable/1739581}.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## octave.dataset.UCBAdmissions;
    ## 
    ## # TODO: Port mosaic plot to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = UCBAdmissions ()
      name = 'UCBAdmissions';
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
    ## @node dataset.UKDriverDeaths
    ## @deftypefn {Static Method} {@var{out} =} UKDriverDeaths ()
    ##
    ## Road Casualties in Great Britain 1969-84
    ##
    ## @subsubheading Description
    ## 
    ## @code{UKDriverDeaths} is a time series giving the monthly totals of car drivers in Great Britain killed
    ## or seriously injured Jan 1969 to Dec 1984. Compulsory wearing of seat belts
    ## was introduced on 31 Jan 1983.
    ## 
    ## @code{Seatbelts} is more information on the same problem.
    ## 
    ## @subsubheading Format
    ## 
    ## @code{UKDriverDeaths} is a table with the following variables:
    ## 
    ## @table @code
    ## @item month
    ## Month of the observation.
    ## @item deaths
    ## Number of deaths.
    ## @end table
    ## 
    ## @code{Seatbelts} is a table with the following variables:
    ## 
    ## @table @code
    ## @item month
    ## Month of the observation.
    ## @item DriversKilled
    ## Car drivers killed.
    ## @item drivers
    ## Same as @code{UKDriverDeaths} @code{deaths} count.
    ## @item front
    ## Front-seat passengers killed or seriously injured.
    ## @item rear
    ## Rear-seat passengers killed or seriously injured.
    ## @item kms
    ## Distance driven.
    ## @item PetrolPrice
    ## Petrol price.
    ## @item VanKilled
    ## Number of van (“light goods vehicle”) drivers killed.
    ## @item law
    ## 0/1: was the seatbelt law in effect that month?
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Harvey, A.C. (1989). @cite{Forecasting, Structural Time Series Models and
    ## the Kalman Filter}. Cambridge: Cambridge University Press. pp. 519–523.
    ## 
    ## Durbin, J. and Koopman, S. J. (2001). @cite{Time Series Analysis by State
    ## Space Methods}. Oxford: Oxford University Press. @url{http://www.ssfpack.com/dkbook/}
    ## 
    ## @subsubheading References
    ## 
    ## Harvey, A. C. and Durbin, J. (1986). The effects of seat belt legislation
    ## on British road casualties: A case study in structural time series
    ## modelling. @cite{Journal of the Royal Statistical Society} series A, 149, 187–227.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## octave.dataset.UKDriverDeaths;
    ## d = UKDriverDeaths;
    ## s = Seatbelts;
    ## 
    ## # TODO: Port the model and plots to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = UKDriverDeaths ()
      name = 'UKDriverDeaths';
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
    ## @node dataset.UKgas
    ## @deftypefn {Static Method} {@var{out} =} UKgas ()
    ##
    ## UK Quarterly Gas Consumption
    ##
    ## @subsubheading Description
    ## 
    ## Quarterly UK gas consumption from 1960Q1 to 1986Q4, in millions of therms.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item date
    ## Quarter of the observation
    ## @item gas
    ## Gas consumption (MM therms).
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Durbin, J. and Koopman, S. J. (2001). @cite{Time Series Analysis by State
    ## Space Methods}. Oxford: Oxford University Press. @url{http://www.ssfpack.com/dkbook/}.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.UKgas;
    ## 
    ## plot (datenum (t.date), t.gas);
    ## datetick ("x")
    ## xlabel ("Month")
    ## ylabel ("Gas consumption (MM therms)")
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = UKgas ()
      name = 'UKgas';
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
    ## @node dataset.UKLungDeaths
    ## @deftypefn {Static Method} {@var{out} =} UKLungDeaths ()
    ##
    ## Monthly Deaths from Lung Diseases in the UK
    ##
    ## @subsubheading Description
    ## 
    ## Three time series giving the monthly deaths from bronchitis, emphysema and
    ## asthma in the UK, 1974–1979.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item date
    ## Month of the observation.
    ## @item ldeaths
    ## Total lung deaths.
    ## @item fdeaths
    ## Lung deaths among females.
    ## @item mdeaths
    ## Lung deaths among males.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## P. J. Diggle (1990). @cite{Time Series: A Biostatistical Introduction}. Oxford. table A.3
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.UKLungDeaths;
    ## 
    ## figure
    ## plot (datenum (t.date), t.ldeaths);
    ## title ("Total UK Lung Deaths")
    ## xlabel ("Month")
    ## ylabel ("Deaths")
    ## 
    ## figure
    ## plot (datenum (t.date), [t.fdeaths t.mdeaths]);
    ## title ("UK Lung Deaths buy sex")
    ## legend (@{"Female", "Male"@})
    ## xlabel ("Month")
    ## ylabel ("Deaths")
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = UKLungDeaths ()
      name = 'UKLungDeaths';
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
    ## @node dataset.USAccDeaths
    ## @deftypefn {Static Method} {@var{out} =} USAccDeaths ()
    ##
    ## Accidental Deaths in the US 1973-1978
    ##
    ## @subsubheading Description
    ## 
    ## A time series giving the monthly totals of accidental deaths in the USA.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item month
    ## Month of the observation.
    ## @item deaths
    ## Accidental deaths.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Brockwell, P. J. and Davis, R. A. (1991). @cite{Time Series: Theory and Methods}.
    ## New York: Springer.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.USAccDeaths;
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = USAccDeaths ()
      name = 'USAccDeaths';
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
    ## @node dataset.USArrests
    ## @deftypefn {Static Method} {@var{out} =} USArrests ()
    ##
    ## Violent Crime Rates by US State
    ##
    ## @subsubheading Description
    ## 
    ## This data set contains statistics, in arrests per 100,000 residents for
    ## assault, murder, and rape in each of the 50 US states in 1973. Also given
    ## is the percent of the population living in urban areas.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item State
    ## State name.
    ## @item Murder
    ## Murder arrests (per 100,000).
    ## @item Assault
    ## Assault arrests (per 100,000).
    ## @item UrbanPop
    ## Percent urban population.
    ## @item Rape
    ## Rape arrests (per 100,000).
    ## @end table
    ## 
    ## @subsubheading Note
    ## 
    ## @code{USArrests} contains the data as in McNeil's monograph. For the
    ## @code{UrbanPop} percentages, a review of the table (No. 21) in the
    ## Statistical Abstracts 1975 reveals a transcription error for Maryland
    ## (and that McNeil used the same “round to even” rule), as found by
    ## Daniel S Coven (Arizona).
    ## 
    ## See the example below on how to correct the error and improve accuracy
    ## for the ‘<n>.5’ percentages.
    ## 
    ## @subsubheading Source
    ## 
    ## @cite{World Almanac and Book of Facts 1975}. (Crime rates).
    ## 
    ## @cite{Statistical Abstracts of the United States 1975}, p.20, (Urban rates),
    ## possibly available as @url{https://books.google.ch/books?id=zl9qAAAAMAAJ&pg=PA20}.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. R. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.USArrests;
    ## 
    ## summary (t);
    ## 
    ## octave.examples.plot_pairs (t(:,2:end));
    ## 
    ## # TODO: Difference between USArrests and its correction
    ## 
    ## # TODO: +/- 0.5 to restore the original <n>.5 percentages
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = USArrests ()
      name = 'USArrests';
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
    ## @node dataset.USJudgeRatings
    ## @deftypefn {Static Method} {@var{out} =} USJudgeRatings ()
    ##
    ## Lawyers’ Ratings of State Judges in the US Superior Court
    ##
    ## @subsubheading Description
    ## 
    ## Lawyers’ ratings of state judges in the US Superior Court.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item CONT
    ## Number of contacts of lawyer with judge.
    ## @item INTG
    ## Judicial integrity.
    ## @item DMNR
    ## Demeanor.
    ## @item DILG
    ## Diligence.
    ## @item CFMG
    ## Case flow managing.
    ## @item DECI
    ## Prompt decisions.
    ## @item PREP
    ## Preparation for trial.
    ## @item FAMI
    ## Familiarity with law.
    ## @item ORAL
    ## Sound oral rulings.
    ## @item WRIT
    ## Sound written rulings.
    ## @item PHYS
    ## Physical ability.
    ## @item RTEN
    ## Worthy of retention.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## New Haven Register, 14 January, 1977 (from John Hartigan).
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.USJudgeRatings;
    ## 
    ## figure
    ## octave.examples.plot_pairs (t(:,2:end));
    ## title ("USJudgeRatings data")
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = USJudgeRatings ()
      name = 'USJudgeRatings';
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
    ## @node dataset.USPersonalExpenditure
    ## @deftypefn {Static Method} {@var{out} =} USPersonalExpenditure ()
    ##
    ## Personal Expenditure Data
    ##
    ## @subsubheading Description
    ## 
    ## This data set consists of United States personal expenditures (in billions
    ## of dollars) in the categories: food and tobacco, household operation,
    ## medical and health, personal care, and private education for the years 1940,
    ## 1945, 1950, 1955 and 1960.
    ## 
    ## @subsubheading Format
    ## 
    ## A 2-dimensional matrix @code{x} with Category along dimension 1 and Year along dimension 2.
    ## 
    ## @subsubheading Source
    ## 
    ## @cite{The World Almanac and Book of Facts}, 1962, page 756.
    ## 
    ## @subsubheading References
    ## 
    ## Tukey, J. W. (1977). @cite{Exploratory Data Analysis}. Reading, Mass: Addison-Wesley.
    ## 
    ## McNeil, D. R. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## octave.dataset.USPersonalExpenditure;
    ## 
    ## # TODO: Port medpolish() from R, whatever that is.
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = USPersonalExpenditure ()
      name = 'USPersonalExpenditure';
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
    ## @node dataset.uspop
    ## @deftypefn {Static Method} {@var{out} =} uspop ()
    ##
    ## Populations Recorded by the US Census
    ##
    ## @subsubheading Description
    ## 
    ## This data set gives the population of the United States
    ## (in millions) as recorded by the decennial census for the period 1790–1970.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item year
    ## Year of the census.
    ## @item population
    ## Population, in millions.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## McNeil, D. R. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.uspop;
    ## 
    ## figure
    ## semilogy (t.year, t.population)
    ## xlabel ("Year")
    ## ylabel ("U.S. Population (millions)")
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = uspop ()
      name = 'uspop';
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
    ## @node dataset.VADeaths
    ## @deftypefn {Static Method} {@var{out} =} VADeaths ()
    ##
    ## Death Rates in Virginia (1940)
    ##
    ## @subsubheading Description
    ## 
    ## Death rates per 1000 in Virginia in 1940.
    ## 
    ## @subsubheading Format
    ## 
    ## A 2-dimensional matrix @code{deaths}, with age group along dimension 1 and
    ## demographic group along dimension 2.
    ## 
    ## @subsubheading Details
    ## 
    ## The death rates are measured per 1000 population per year. They are
    ## cross-classified by age group (rows) and population group (columns). The
    ## age groups are: 50–54, 55–59, 60–64, 65–69, 70–74 and the population groups
    ## are Rural/Male, Rural/Female, Urban/Male and Urban/Female.
    ## 
    ## This provides a rather nice 3-way analysis of variance example.
    ## 
    ## @subsubheading Source
    ## 
    ## Molyneaux, L., Gilliam, S. K., and Florant, L. C.(1947) Differences
    ## in Virginia death rates by color, sex, age, and rural or urban
    ## residence. @cite{American Sociological Review}, 12, 525–535.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. R. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## octave.dataset.VADeaths;
    ## 
    ## # TODO: Port to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = VADeaths ()
      name = 'VADeaths';
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
    ## @node dataset.volcano
    ## @deftypefn {Static Method} {@var{out} =} volcano ()
    ##
    ## Topographic Information on Auckland’s Maunga Whau Volcano
    ##
    ## @subsubheading Description
    ## 
    ## Maunga Whau (Mt Eden) is one of about 50 volcanos in the Auckland volcanic
    ## field. This data set gives topographic information for Maunga Whau on a
    ## 10m by 10m grid.
    ## 
    ## @subsubheading Format
    ## 
    ## A matrix @code{volcano} with 87 rows and 61 columns, rows corresponding
    ## to grid lines running east to west and columns to grid lines running south
    ## to north.
    ## 
    ## @subsubheading Source
    ## 
    ## Digitized from a topographic map by Ross Ihaka. These data should not be regarded as accurate.
    ## 
    ## @subsubheading References
    ## 
    ## Box, G. E. P. and Jenkins, G. M. (1976). @cite{Time Series Analysis, Forecasting and
    ## Control}. San Francisco: Holden-Day. p. 537.
    ## 
    ## Brockwell, P. J. and Davis, R. A. (1991). @cite{Time Series: Theory and Methods}.
    ## Second edition. New York: Springer-Verlag. p. 414.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## octave.dataset.volcano;
    ## 
    ## # TODO: Figure out how to do a topo map in Octave. Just a gridded color plot
    ## # should be fine. And then maybe do a 3-d mesh plot.
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = volcano ()
      name = 'volcano';
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
    ## @node dataset.warpbreaks
    ## @deftypefn {Static Method} {@var{out} =} warpbreaks ()
    ##
    ## The Number of Breaks in Yarn during Weaving
    ##
    ## @subsubheading Description
    ## 
    ## This data set gives the number of warp breaks per loom, where a loom
    ## corresponds to a fixed length of yarn.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item wool
    ## Type of wool (A or B).
    ## @item tension
    ## The level of tension (L, M, H).
    ## @item breaks
    ## Number of breaks.
    ## @end table
    ## 
    ## There are measurements on 9 looms for each of the six types of warp (AL, AM, AH, BL, BM, BH).
    ## 
    ## @subsubheading Source
    ## 
    ## Tippett, L. H. C. (1950). @cite{Technological Applications of Statistics}.
    ## New York: Wiley. Page 106.
    ## 
    ## @subsubheading References
    ## 
    ## Tukey, J. W. (1977). @cite{Exploratory Data Analysis}. Reading, Mass: Addison-Wesley.
    ## 
    ## McNeil, D. R. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.warpbreaks;
    ## 
    ## summary (t)
    ## 
    ## # TODO: Port the plotting code and OPAR to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = warpbreaks ()
      name = 'warpbreaks';
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
    ## @node dataset.women
    ## @deftypefn {Static Method} {@var{out} =} women ()
    ##
    ## Average Heights and Weights for American Women
    ##
    ## @subsubheading Description
    ## 
    ## This data set gives the average heights and weights for American women aged 30–39.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item height
    ## Height (in).
    ## @item weight
    ## Weight (lbs).
    ## @end table
    ## 
    ## @subsubheading Details
    ## 
    ## The data set appears to have been taken from the American Society of Actuaries
    ## Build and Blood Pressure Study for some (unknown to us) earlier year.
    ## 
    ## The World Almanac notes: “The figures represent weights in ordinary indoor
    ## clothing and shoes, and heights with shoes”.
    ## 
    ## @subsubheading Source
    ## 
    ## @cite{The World Almanac and Book of Facts}, 1975.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. R. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.women;
    ## 
    ## figure
    ## scatter (t.height, t.weight)
    ## xlabel ("Height (in)")
    ## ylabel ("Weight (lb")
    ## title ("women data: American women aged 30-39")
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = women ()
      name = 'women';
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
    ## @node dataset.WorldPhones
    ## @deftypefn {Static Method} {@var{out} =} WorldPhones ()
    ##
    ## The World’s Telephones
    ##
    ## @subsubheading Description
    ## 
    ## The number of telephones in various regions of the world (in thousands).
    ## 
    ## @subsubheading Format
    ## 
    ## A matrix with 7 rows and 8 columns. The columns of the matrix give the
    ## figures for a given region, and the rows the figures for a year.
    ## 
    ## The regions are: North America, Europe, Asia, South America, Oceania,
    ## Africa, Central America.
    ## 
    ## The years are: 1951, 1956, 1957, 1958, 1959, 1960, 1961.
    ## 
    ## @subsubheading Source
    ## 
    ## AT&T (1961) @cite{The World’s Telephones}.
    ## 
    ## @subsubheading References
    ## 
    ## McNeil, D. R. (1977). @cite{Interactive Data Analysis}. New York: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## octave.dataset.WorldPhones;
    ## 
    ## # TODO: Port matplot() to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = WorldPhones ()
      name = 'WorldPhones';
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
    ## @node dataset.WWWusage
    ## @deftypefn {Static Method} {@var{out} =} WWWusage ()
    ##
    ## WWWusage
    ##
    ## @subsubheading Description
    ## 
    ## A time series of the numbers of users connected to the Internet through
    ## a server every minute.
    ## 
    ## @subsubheading Format
    ## 
    ## A time series of length 100.
    ## 
    ## @subsubheading Source
    ## 
    ## Durbin, J. and Koopman, S. J. (2001). @cite{Time Series Analysis by State
    ## Space Methods}. Oxford: Oxford University Press. @url{http://www.ssfpack.com/dkbook/}
    ## 
    ## @subsubheading References
    ## 
    ## Makridakis, S., Wheelwright, S. C. and Hyndman, R. J. (1998). @cite{Forecasting:
    ## Methods and Applications}. New York: Wiley.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # TODO: Come up with example code here
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = WWWusage ()
      name = 'WWWusage';
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
    ## @node dataset.zCO2
    ## @deftypefn {Static Method} {@var{out} =} zCO2 ()
    ##
    ## Carbon Dioxide Uptake in Grass Plants
    ##
    ## @subsubheading Description
    ## 
    ## The @code{CO2} data set has 84 rows and 5 columns of data from an experiment
    ## on the cold tolerance of the grass species Echinochloa crus-galli.
    ## 
    ## @subsubheading Format
    ## 
    ## @subsubheading Details
    ## 
    ## The CO2 uptake of six plants from Quebec and six plants from Mississippi was
    ## measured at several levels of ambient CO2 concentration. Half the plants of
    ## each type were chilled overnight before the experiment was conducted.
    ## 
    ## @subsubheading Source
    ## 
    ## Potvin, C., Lechowicz, M. J. and Tardif, S. (1990). The statistical
    ## analysis of ecophysiological response curves obtained from experiments
    ## involving repeated measures. @cite{Ecology}, 71, 1389–1400.
    ## 
    ## Pinheiro, J. C. and Bates, D. M. (2000). @cite{Mixed-effects Models
    ## in S and S-PLUS}. New York: Springer.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.zCO2;
    ## 
    ## # TODO: Coplot
    ## # TODO: Port the linear model to Octave
    ## 
    ## @end example
    ## 
    ##
    ## @end deftypefn
    function out = zCO2 ()
      name = 'zCO2';
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
