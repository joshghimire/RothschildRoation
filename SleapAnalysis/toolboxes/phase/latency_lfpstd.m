% latency_std.m
% latency based on standard deviations
% Hulusi Kafaligonul 

function Latency = latency_lfpstd(Resp, Time, win_param);
% ten consecutive bins that greater than n*std of the baseline
% latency is the time of the first bin
% SV latency analysis

nstd1 = 3;     %%xin used 1, 1.5, 2

% baseline period
baseTs = win_param(1);
baseTe = win_param(2);
IdxbaseTs = find(Time == baseTs);
IdxbaseTe = find(Time == baseTe);

% response period
respTs = win_param(3);
respTe = win_param(3)+200; % 385 for P or AP Time(length(Time)-3)
IdxrespTs = find(Time == respTs);
IdxrespTe = find(Time == respTe);

% baseline mean and standard deviation
bmean = mean(Resp(IdxbaseTs:IdxbaseTe));
bstd =  std(Resp(IdxbaseTs:IdxbaseTe));

% amplitude at different significant points
pstd1 = bmean + nstd1*bstd;  % n*standard deviation
pmax  = max(Resp(IdxrespTs:IdxrespTe));  % peak

% time index at significant points
IdxTs = IdxrespTs + min(find(Resp(IdxrespTs:IdxrespTe) >= pstd1)) - 1;

if isempty(IdxTs),   % signal is not n*std greater than the mean of the baseline
    Latency = NaN;
    return;
end;    

found = 0;
bin_num = IdxTs;                         % start from next bin from pre_onset_time
upper_bin = find(Time == respTe);
while ((~found) && (bin_num <= upper_bin-20)),
   if Resp(bin_num+1) > pstd1, 
    if Resp(bin_num+2) > pstd1,
     if Resp(bin_num+3) > pstd1, 
      if Resp(bin_num+4) > pstd1,
       if Resp(bin_num+5) > pstd1, 
        if Resp(bin_num+6) > pstd1,
         if Resp(bin_num+7) > pstd1, 
          if Resp(bin_num+8) > pstd1,
           if Resp(bin_num+9) > pstd1, 
            if Resp(bin_num+10) > pstd1, 
             if Resp(bin_num+11) > pstd1,
              if Resp(bin_num+12) > pstd1, 
               if Resp(bin_num+13) > pstd1,
                if Resp(bin_num+14) > pstd1, 
                 if Resp(bin_num+15) > pstd1, 
                  if Resp(bin_num+16) > pstd1,
                   if Resp(bin_num+17) > pstd1, 
                    if Resp(bin_num+18) > pstd1,
                     if Resp(bin_num+19) > pstd1, 
                        Latency = Time(bin_num); % was just bin_num
                        found = 1;
                     end;
                    end;
                   end;
                  end;
                 end;
                end;
               end;
              end;
             end;
            end;
           end;
          end;
         end;
        end;
       end;
      end;
     end;
    end;
   end;
  bin_num = bin_num + 1;
end;   % end while  

if found ~= 1, 
    Latency = NaN;
end; 

return;