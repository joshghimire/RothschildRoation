function data = performNormalization(timeVec, data, baseline, baselinetype)

baselineTimes = (timeVec >= baseline(1) & timeVec <= baseline(2));

if length(size(data)) ~= 3,
  error('time-frequency matrix should have three dimensions (chan,freq,time)');
end

% compute mean of time/frequency quantity in the baseline interval,
% ignoring NaNs, and replicate this over time dimension
meanVals = repmat(nanmean(data(:,:,baselineTimes), 3), [1 1 size(data, 3)]);

if (strcmp(baselinetype, 'absolute'))
  data = data - meanVals;
elseif (strcmp(baselinetype, 'relative'))
  data = data ./ meanVals;
elseif (strcmp(baselinetype, 'relchange'))
  data = (data - meanVals) ./ meanVals;
elseif (strcmp(baselinetype, 'vssum'))
  data = (data - meanVals) ./ (data + meanVals);
elseif (strcmp(baselinetype, 'db'))
  data = 10*log10(data ./ meanVals);
else
  error('unsupported method for baseline normalization: %s', baselinetype);
end