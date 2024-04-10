function [ wavelets, expInfo ] = uk_getWaveletsSubjects( time_sub_chan_mod_cond, conditions, expInfo )
%UK_GETWAVELETSOVERAVERAGE Summary of this function goes here
%   Detailed explanation goes here
conf=readconf('conf');

freqrange=[str2double(conf.FREQRANGE{1}) str2double(conf.FREQRANGE{2})];
rfreq=freqrange(1):str2double(conf.FREQSTEP):freqrange(2);
[~,channels]=ismember(conf.WAVELETCHANNELS,{expInfo.Channels.Name});
time_sub_chan_mod_cond=time_sub_chan_mod_cond(:,:,channels,:,:);
time_sub_chan_mod_cond(:,:,:,4,:)=...
    time_sub_chan_mod_cond(:,:,:,1,:)-time_sub_chan_mod_cond(:,:,:,2,:);
time_sub_chan_mod_cond(:,:,:,5,:)=...
    time_sub_chan_mod_cond(:,:,:,4,:)-time_sub_chan_mod_cond(:,:,:,3,:);
expInfo.wavelet.modalities(1).no=1;
expInfo.wavelet.modalities(1).name='AV';
expInfo.wavelet.modalities(2).no=2;
expInfo.wavelet.modalities(2).name='A';
expInfo.wavelet.modalities(3).no=3;
expInfo.wavelet.modalities(3).name='V';
expInfo.wavelet.modalities(4).no=4;
expInfo.wavelet.modalities(4).name='AV-A';
expInfo.wavelet.modalities(5).no=5;
expInfo.wavelet.modalities(5).name='AV-A-V';
expInfo.wavelet.rfreq=rfreq;
expInfo.wavelet.channels=channels;

[~,numsub,numchan,~,numcond]=size(time_sub_chan_mod_cond);

for iroi=1:length(conf.ROIS)/2
    rois(iroi,1)=str2double(conf.ROIS{iroi*2-1}); %#ok<AGROW>
    rois(iroi,2)=str2double(conf.ROIS{iroi*2}); %#ok<AGROW>
end
fprintf('wavelet transforms. \n');

for icond=1:numcond
    fprintf('cond %s\n',conditions(icond).name);
    for isub=1:numsub
        time_chan_mod_cond=squeeze(time_sub_chan_mod_cond(:,isub,:,:,:));
        for ichan=1:numchan
            timeAV=time_chan_mod_cond(:,ichan,1,icond);
            timeAV_A=time_chan_mod_cond(:,ichan,4,icond);
            timeAV_A_V=time_chan_mod_cond(:,ichan,5,icond);
            wavelets(ichan).bimodal(icond).AV(isub,:,:)=cmorTransSpec(timeAV,...
                expInfo.SampleRate,rfreq);
            wavelets(ichan).bimodal(icond).AV_A(isub,:,:)=cmorTransSpec(timeAV_A,...
                expInfo.SampleRate,rfreq);
            wavelets(ichan).bimodal(icond).AV_A_V(isub,:,:)=cmorTransSpec(timeAV_A_V,...
                expInfo.SampleRate,rfreq);
            if icond==5
                timeA=time_chan_mod_cond(:,ichan,2,icond);
                timeV=time_chan_mod_cond(:,ichan,3,icond);
                wavelets(ichan).unimodal.A(isub,:,:)=cmorTransSpec(timeA,...
                    expInfo.SampleRate,rfreq);
                wavelets(ichan).unimodal.V(isub,:,:)=cmorTransSpec(timeV,...
                    expInfo.SampleRate,rfreq);
            end
        end
    end
end

end

