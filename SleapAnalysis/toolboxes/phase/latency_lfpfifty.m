% latency_lfpfifty.m
% latency based on standard deviations
% Hulusi Kafaligonul 

function Latency = latency_lfpfifty(Resp, Time);
% ten consecutive bins that greater than n*std of the baseline
% latency is the time of the first bin
% SV latency analysis

nstd1 = 0.52;     %50 percent point

% find the peak and minimum
IdpeakTs = 1;
IdpeakTe = length(Time)-1;
peak = max(Resp(IdpeakTs:IdpeakTe));
base = min(Resp(IdpeakTs:IdpeakTe));
Idpeak=find(Resp(IdpeakTs:IdpeakTe)==peak);
pstd1 = nstd1*(peak+base);  % 50% of peak

% response period
IdrespTs = 1;
IdrespTe = Idpeak;

% time index at significant points
IdxTs = IdrespTs + min(find(Resp(IdrespTs:IdrespTe) >= pstd1)) - 1;

if isempty(IdxTs),   % signal is not n*std greater than the mean of the baseline
    Latency = NaN;
    return;
end;    

found = 0;
bin_num = IdxTs;                         % start from next bin from pre_onset_time
upper_bin = IdrespTe;

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





