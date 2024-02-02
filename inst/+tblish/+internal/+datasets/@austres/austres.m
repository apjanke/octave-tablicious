## Copyright (C) 1994-9 W. N. Venables and B. D. Ripley
## Copyright (C) 2019, 2023, 2024 Andrew Janke
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

# This is based on the austres dataset from R’s datasets package

classdef austres < tblish.internal.dataset

  methods

    function this = austres ()
      this.name = "austres";
      this.summary = "Australian Population";
    endfunction

    function out = load (this)
      residents = 1000 * [13067.3, 13130.5, 13198.4, 13254.2, 13303.7, 13353.9, ...
        13409.3, 13459.2, 13504.5, 13552.6, 13614.3, 13669.5, 13722.6,  ...
        13772.1, 13832, 13862.6, 13893, 13926.8, 13968.9, 14004.7, 14033.1, ...
        14066, 14110.1, 14155.6, 14192.2, 14231.7, 14281.5, 14330.3, ...
        14359.3, 14396.6, 14430.8, 14478.4, 14515.7, 14554.9, 14602.5, ...
        14646.4, 14695.4, 14746.6, 14807.4, 14874.4, 14923.3, 14988.7, ...
        15054.1, 15121.7, 15184.2, 15239.3, 15288.9, 15346.2, 15393.5, ...
        15439, 15483.5, 15531.5, 15579.4, 15628.5, 15677.3, 15736.7, ...
        15788.3, 15839.7, 15900.6, 15961.5, 16018.3, 16076.9, 16139, ...
        16203, 16263.3, 16327.9, 16398.9, 16478.3, 16538.2, 16621.6, ...
        16697, 16777.2, 16833.1, 16891.6, 16956.8, 17026.3, 17085.4, ...
        17106.9, 17169.4, 17239.4, 17292, 17354.2, 17414.2, 17447.3, ...
        17482.6, 17526, 17568.7, 17627.1, 17661.5]';
      start_date = datetime(1971, 3, 1);
      # Now, the data says it's from Mar 1971 to Mar 1994, but there's only 89
      # observations there, which only takes us up to Mar 1993.
      #end_date = datetime(1994, 3, 1);
      end_date = datetime(1993, 3, 1);
      date = [start_date:calmonths(3):end_date]';

      out = table (date, residents);
    endfunction

  endmethods

endclassdef
