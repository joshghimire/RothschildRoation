function [  ] = plotRawERPs( time_sub_chan_mod_cond,conditions,expInfo )
%PLOTRAWERPS Summary of this function goes here
%   Detailed explanation goes here
conf=readconf('plotRawERPs_conf');
[~,chans]=ismember(conf.CHANNELS,{expInfo.Channels.Name});
time_chan_mod_cond=squeeze(mean(time_sub_chan_mod_cond,2));
time_chan_mod_cond=time_chan_mod_cond(:,chans,:,:);
[numtime,numchan,nummod,numcond]=size(time_chan_mod_cond);
for icond=1:
    
end

end

