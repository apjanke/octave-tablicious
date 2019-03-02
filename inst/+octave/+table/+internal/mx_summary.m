function out = mx_summary (x)
  %MX_SUMMARY "Summary" data for an arbitrary array, with specific type support
  %
  % Returns a scalar struct.

  out = struct;
  out.Size = size (x);
  out.Type = class (x);

  if isnumeric (x)
  	out = mx_summary_numeric (x, out);
  elseif isa (x, 'datetime')
    out = mx_summary_datetime (x, out);
  elseif isa (x, 'duration')
    out = mx_summary_numeric (x, out); % Works because duration supports isnan()
  elseif islogical (x)
    out = mx_summary_logical (x, out);
  elseif isa (x, 'categorical')
    error ('mx_summary: categorical is not yet implemented in Octave.');
  else
  	% nop: we've already got Szie and Type; that's all that is supported
  endif
endfunction

function out = mx_summary_numeric (x, out)
  out.Min = min (x);
  out.Median = median (x);
  out.Max = max (x);
  out.NumMissing = numel (find (isnan (x)));
endfunction

function out = mx_summary_datetime (x, out)
  out.Min = min (x);
  out.Median = median (x);
  out.Max = max (x);
  out.NumMissing = numel (find (isnat (x))); % friggin' NaT; sigh...
end

function out = mx_summary_logical (x, out)
  out.True = numel (find (x));
  out.False = numel (find (~x));
end