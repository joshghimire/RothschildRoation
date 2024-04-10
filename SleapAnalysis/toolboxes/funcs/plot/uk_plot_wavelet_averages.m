function [ ] = uk_plot_wavelet_averages( ...
    wavelets,expInfo,conditions )
%UK_PLOT_WAVELET_AVERAGES Summary of this function goes here
%   Detailed explanation goes here
ft_defaults;
mons=get(groot,'MonitorPositions');

conf=readconf('uk_plot_wavelet_averages_conf');
Lim.X=[str2double(conf.XLIM{1}) str2double(conf.XLIM{2})];
Lim.Y=[str2double(conf.YLIM{1}) str2double(conf.YLIM{2})];
Lim.C=[str2double(conf.CLIM{1}) str2double(conf.CLIM{2})];
baseline=[str2double(conf.BASELINE{1}) str2double(conf.BASELINE{2})];
baselinetype=conf.BASELINETYPE;
numcol=str2double(conf.NUMCOL);
modality=str2double(conf.MODALITY);
[~,channels]=ismember(conf.CHANNELS,{expInfo.Channels.Name});
for ichan=1:length(channels)
    chan=channels(ichan);
    wavelet=wavelets(chan);
    bimodal=wavelet.bimodal;
    figure('OuterPosition',mons(end,:));
    for icond=1:length(bimodal)
        chan_freq_time(1,:,:)=abs(bimodal(icond).AV);
        chan_freq_time(2,:,:)=abs(bimodal(icond).AV_A);
        chan_freq_time(3,:,:)=abs(bimodal(icond).AV_A_V);
        chan_freq_time=performNormalization(...
            expInfo.t,chan_freq_time,baseline,baselinetype);
        subplot(length(bimodal)/numcol,numcol,icond);
        chan_freq_time(chan_freq_time<0)=0;
%         sub_pos = get(gca,'position'); % get subplot axis position
%         set(gca,'position',sub_pos.*[1 .95 1.2 1.1]) % stretch its width and height
        surf(expInfo.t,expInfo.wavelet.rfreq,squeeze(chan_freq_time(modality,:,:)));
        shading interp;rotate3d on;colormap('jet');
        set(gca,'YDir','normal','CLim',Lim.C);
        axis([Lim.X(1) Lim.X(2) min(expInfo.wavelet.rfreq)...
            max(expInfo.wavelet.rfreq)]);
        title(conditions(icond).name);
    if icond==5,ylabel('Frequency (Hz)');end
    if icond>=5,xlabel('Time (ms)');end
    end
end

end

