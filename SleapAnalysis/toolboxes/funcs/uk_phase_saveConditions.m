function [ ] = uk_phase_saveConditions( rawFilesFolder, conditions, outFolder )
%SAVECONDITIONS Read Exported data and select not bad trials and group
% under conditions
%   [ ] = uk_phase_saveConditions( rawFilesFolder, conditions, outFolder )
% rawFilesFolder: the folder containnig the raw files of each subjet
% exported from Analyzer
% conditions: a structure contaning 10 conditions in this experiment.
% Structure should contain name of the condition, SOA for that condition
% and marker code from pressentation computer.


files=dir([outFolder '/*.mat']);
if length(files)<10
    files=dir([rawFilesFolder '/SCSF-*1.mat']);
    fileNames={files.name};
    numSubj=length(fileNames);
    subj=load(fullfile(rawFilesFolder, fileNames{1}));
    channelNames={subj.Channels.Name};
    ChannelCount=subj.ChannelCount;
    % group data into conditions
    chan_sub__trial_time=cell(ChannelCount,numSubj);
    for icond=1:length(conditions)
        disp(['c ' num2str(icond)])
        for isub=1:numSubj
            fileName=fileNames{isub};
            subj=load(fileName);
            Markers=subj.Markers;
            IBad=uk_getTrialIndexes(Markers,'bad interval');
            I=uk_getTrialIndexes(Markers,'Stimulus',conditions(icond).markerCode);
            IClean=setdiff(I,IBad);
            for ichan=1:ChannelCount
                channelname=channelNames{ichan};
                trial_time=subj.(channelname);
                chan_sub__trial_time{ichan,isub}=trial_time(IClean,:);
            end
            disp(['--s ' num2str(isub)])
        end
        save([outFolder '\' conditions(icond).name],'chan_sub__trial_time');
    end
    subj=rmfield(subj,channelNames);
    subj=rmfield(subj,{'Markers','MarkerCount'});
    save('expInfo','-struct','subj');
end
end