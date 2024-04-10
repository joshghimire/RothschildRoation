function [ cond_chan_thypo, cond_chan_tps ] = uk_phase_getTTests( time_sub_chan_mod_cond, expInfo,conf )
%UK_PHASE_GETTTESTS Summary of this function goes here
%   Detailed explanation goes here
condInterest=1:8;
[numtime,numsub,numchan,nummod,numconds]=size(time_sub_chan_mod_cond);
cond_chan_thypo=NaN(length(condInterest),numchan,numtime);
cond_chan_tps=NaN(length(condInterest),numchan,numtime);
chan_time_sub_mod1=NaN(numchan,numtime,numsub,nummod);
baseline.beg=str2double(conf.BASELINE{1});
baseline.end=str2double(conf.BASELINE{2});
ttestpval=str2double(conf.TTESTPVAL);
for icond=condInterest
    time_sub_chan_mod=time_sub_chan_mod_cond(:,:,:,:,icond);
    chan_time_sub_mod=permute(time_sub_chan_mod,[3 1 2 4]);
    for idim=1:size(chan_time_sub_mod,4)
        for isubj=1:size(chan_time_sub_mod,3)
            chan_time=squeeze(chan_time_sub_mod(:,:,isubj,idim));
            chan_time_sub_mod1(:,:,isubj,idim)=ft_preproc_baselinecorrect(chan_time,...
                getTimePoint(baseline.beg,expInfo.t),...
                getTimePoint(baseline.end,expInfo.t));
        end
    end
    chan_time_sub_mod1(:,:,:,4)=chan_time_sub_mod1(:,:,:,1)-chan_time_sub_mod1(:,:,:,2);
    for ichans=1:expInfo.ChannelCount
        time_sub_mod=squeeze(chan_time_sub_mod1(ichans,:,:,:));
        time_sub_VO=time_sub_mod(:,:,3);
        time_sub_AV_A=time_sub_mod(:,:,4);
        [h,p]=ttest(time_sub_VO,time_sub_AV_A,'Alpha',ttestpval,'Dim',2);
        cond_chan_thypo(icond,ichans,:)=h';
        cond_chan_tps(icond,ichans,:)=p';
    end
end

end

