function [ wavelets, expInfo ] = uk_getWaveletsOverAverage( time_sub_chan_mod_cond, conditions, expInfo )
%UK_GETWAVELETSOVERAVERAGE Summary of this function goes here
%   Detailed explanation goes here
conf=readconf('conf');

freqrange=[str2double(conf.FREQRANGE{1}) str2double(conf.FREQRANGE{2})];
rfreq=freqrange(1):str2double(conf.FREQSTEP):freqrange(2);

time_chan_mod_cond= squeeze(mean(time_sub_chan_mod_cond,2));
time_chan_mod_cond(:,:,4,:)=time_chan_mod_cond(:,:,1,:)-time_chan_mod_cond(:,:,2,:);
time_chan_mod_cond(:,:,5,:)=time_chan_mod_cond(:,:,4,:)-time_chan_mod_cond(:,:,3,:);
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
% [~,channels]=ismember(conf.CHANNELS,{expInfo.Channels.Name});
% time_chan_mod_cond=time_chan_mod_cond(:,channels,:,:);
[numtime,numchan,nummod,numcond]=size(time_chan_mod_cond);

fprintf('wavelet transforms. \n');

for icond=1:numcond
    fprintf('cond %s\n',conditions(icond).name);
        for ichan=1:numchan
            timeAV=time_chan_mod_cond(:,ichan,1,icond);
            timeAV_A=time_chan_mod_cond(:,ichan,4,icond);
            timeAV_A_V=time_chan_mod_cond(:,ichan,5,icond);
            wavelets(ichan).bimodal(icond).AV=cmorTransSpec(timeAV,...
                expInfo.SampleRate,rfreq);
            wavelets(ichan).bimodal(icond).AV_A=cmorTransSpec(timeAV_A,...
                expInfo.SampleRate,rfreq);
            wavelets(ichan).bimodal(icond).AV_A_V=cmorTransSpec(timeAV_A_V,...
                expInfo.SampleRate,rfreq);
            if icond==5
                timeA=time_chan_mod_cond(:,ichan,2,icond);
                timeV=time_chan_mod_cond(:,ichan,3,icond);
                wavelets(ichan).unimodal.A=cmorTransSpec(timeA,...
                    expInfo.SampleRate,rfreq);
                wavelets(ichan).unimodal.V=cmorTransSpec(timeV,...
                    expInfo.SampleRate,rfreq);
            end
        end
end

end

