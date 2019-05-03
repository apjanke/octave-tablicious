/*
Copyright (C) 2019 Andrew Janke <floss@apjanke.net>

This file is part of Octave.

Octave is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Octave is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Octave; see the file COPYING.  If not, see
<https://www.gnu.org/licenses/>.
*/

#include <octave/oct.h>
#include <iostream>

// Inputs:
//  1: target values (needles)
//  2: search array (haystack); must be a sorted vector
// Returns:
//  1: Indexes: positive if found, negative if not found. 1-based.

template <class T>
octave_idx_type *binsearch (const T vals[], octave_idx_type vals_len, const T arr[], octave_idx_type len) {
  auto *out = new octave_idx_type[vals_len];
  for (octave_idx_type i = 0; i < vals_len; i++) {
    T val = vals[i];
    octave_idx_type low = 0;
    octave_idx_type high = len - 1;
    int found = 0;
    while (low <= high) {
      octave_idx_type mid = (low + high) / 2;
      if (arr[mid] > val)
        high = mid - 1;
      else if (arr[mid] < val)
        low = mid + 1;
      else if (arr[mid] == val) {
        found = 1;
        out[i] = mid + 1; // found
        break;
      } else {
        //std::string msg = std::string ("Total ordering violation: neither <, >, nor == was true. ")
        //        + "vals[" + i + "] = " + val + ", arr[" + mid + "] = " + arr[mid];
        error ("Total ordering violation: neither <, >, nor == was true. i=%ld, mid=%ld",
          i, mid);
      }
    }
    if (!found)
      out[i] = -1 * (low + 1); // not found
  }
  return out;
}

DEFUN_DLD (__oct_time_binsearch__, args, nargout,
  "Vectorized binary search\n"
  "\n"
  "-*- texinfo -*-\n"
  "@deftypefn {Function File} {@var{out} =} __oct_time_binsearch__ (@var{needles}, @var{haystack})\n"
  "\n"
  "Undocumented internal function for chrono package.\n"
  "\n"
  "@end deftypefn\n")
{
  octave_idx_type nargin = args.length ();
  if (nargin != 2) {
    error ("Invalid number of arguments: expected 2; got %ld", (long) nargin);
  }
  
  octave_value vals = args(0);
  octave_value arr = args(1);
  builtin_type_t vals_type = vals.builtin_type ();
  builtin_type_t arr_type = vals.builtin_type ();
  if (vals_type != arr_type) {
    error ("Inputs must be the same type");
    // This results in a compiler error
    //std::string msg = std::string("Error: inputs must be same type; got types ") + vals_type
    //  + " and " + arr_type + "\n";
  }
  octave_idx_type *indexes;
  switch (vals_type) {
    case btyp_double:
      indexes = binsearch(vals.array_value ().fortran_vec (), vals.numel (), 
        arr.array_value ().fortran_vec (), arr.numel ());
      break;
    case btyp_float:
      indexes = binsearch(vals.float_array_value ().fortran_vec (), vals.numel (), 
        arr.float_array_value ().fortran_vec (), arr.numel ());
      break;
    case btyp_int8:
      indexes = binsearch(vals.int8_array_value ().fortran_vec (), vals.numel (), 
        arr.int8_array_value ().fortran_vec (), arr.numel ());
      break;
    case btyp_int16:
      indexes = binsearch(vals.int16_array_value ().fortran_vec (), vals.numel (), 
        arr.int16_array_value ().fortran_vec (), arr.numel ());
      break;
    case btyp_int32:
      indexes = binsearch(vals.int32_array_value ().fortran_vec (), vals.numel (), 
        arr.int32_array_value ().fortran_vec (), arr.numel ());
      break;
    case btyp_uint8:
      indexes = binsearch(vals.uint8_array_value ().fortran_vec (), vals.numel (), 
        arr.uint8_array_value ().fortran_vec (), arr.numel ());
      break;
    case btyp_uint16:
      indexes = binsearch(vals.uint16_array_value ().fortran_vec (), vals.numel (), 
        arr.uint16_array_value ().fortran_vec (), arr.numel ());
      break;
    case btyp_uint32:
      indexes = binsearch(vals.uint32_array_value ().fortran_vec (), vals.numel (), 
        arr.uint32_array_value ().fortran_vec (), arr.numel ());
      break;
    case btyp_uint64:
      indexes = binsearch(vals.uint64_array_value ().fortran_vec (), vals.numel (), 
        arr.uint64_array_value ().fortran_vec (), arr.numel ());
      break;
    default:
      error ("Unsupported input data type");
  }

  NDArray out (vals.dims ());
  octave_idx_type n = vals.numel ();
  for (octave_idx_type i = 0; i < n; i++) {
    out(i) = indexes[i];
  }
  delete [] indexes;
  return octave_value (out);
}

