function [chan_sub_time]=uk_phase_get_average(chan_sub__trial_time,baseline)
[numchan, numsubj]=size(chan_sub__trial_time);
numtime=size(chan_sub__trial_time{1,1},2);
chan_sub_time=NaN(numchan,numsubj,numtime);
for isub=1:numsubj
    for ichan=1:numchan
        trial_time=chan_sub__trial_time{ichan,isub};
        trial_time=ft_preproc_baselinecorrect(trial_time,baseline.beg,baseline.end);
        chan_sub_time(ichan,isub,:)=mean(trial_time,1);
    end
end
end