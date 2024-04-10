function [ time_sub_chan_mod_cond, conditions ] = uk_phase_saveAveragesOverSubjects( condFolder, conditions, expInfo)
%UK_PHASE_GETAVERAGES Summary of this function goes here
%   Channels: array, channel numbers
conf=readconf('conf');
baseline.beg=getTimePoint(str2double(conf.BASELINE{1}),expInfo.t);
baseline.end=getTimePoint(str2double(conf.BASELINE{2}),expInfo.t);
load( fullfile(condFolder, conditions(1).name));
[numChan,numSubj]=size(chan_sub__trial_time); %#ok<USENS>
[~,numT]=size(chan_sub__trial_time{1,1});
time_sub_chan_mod_cond=NaN(numT,numSubj,numChan,3,length(conditions(2:9)));
chan_sub_time=uk_phase_get_average(chan_sub__trial_time,baseline);
clear chan_sub__trial_time;
time_sub_chan_AOnly=permute(chan_sub_time,[3 2 1]);

load( fullfile(condFolder, conditions(10).name));
chan_sub_time=uk_phase_get_average(chan_sub__trial_time,baseline);
clear chan_sub__trial_time;
time_sub_chan_VOnly=permute(chan_sub_time,[3 2 1]);
    
for icond=1:8
    display(icond);
    load( fullfile(condFolder, conditions(icond+1).name));
    chan_sub_time=uk_phase_get_average(chan_sub__trial_time,baseline);
    clear chan_sub__trial_time;
    time_sub_chan=permute(chan_sub_time,[3 2 1]);
    time_sub_chan_mod_cond(:,:,:,1,icond)=time_sub_chan;
    pointShifts=conditions(icond+1).SOA/(1000/expInfo.SampleRate);
    time_sub_chan_AOnlyshifted=circshift(time_sub_chan_AOnly,pointShifts,1);
    time_sub_chan_mod_cond(:,:,:,2,icond)=time_sub_chan_AOnlyshifted;
    time_sub_chan_mod_cond(:,:,:,3,icond)=time_sub_chan_VOnly;
end
file=fullfile(conf.IMPORTFOLDER, 'averages');
conditions=conditions(2:9);
save(file,'time_sub_chan_mod_cond')
end

