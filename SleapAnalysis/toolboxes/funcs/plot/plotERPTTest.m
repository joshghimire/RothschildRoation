function [  ] = plotERPTTest( time_sub_chan_mod_cond,cond_chan_tps,conditions,expInfo )
%UNTÝTLED Summary of this function goes here
%   Detailed explanation goes here
mons=get(groot,'MonitorPositions');
conf=readconf('plotERPTTest_conf');
baseline.beg=getTimePoint(str2double(conf.BASELINE{1}),expInfo.t);
baseline.end=getTimePoint(str2double(conf.BASELINE{2}),expInfo.t);
RTs=[310.769231000000 320.769231000000 320 334.615385000000 343.076923000000 356.153846000000 365.384615000000 367.692308000000 369.230769000000 NaN];
xlim=[str2double(conf.XLIM{1}) str2double(conf.XLIM{2})];
ylim=[str2double(conf.YLIM{1}) str2double(conf.YLIM{2})];
for ichan=1:length(conf.CHANNELS)
    
    figure('OuterPosition',mons(end,:).*[1 1 .25 1])
    
    [~,channumber]=ismember(conf.CHANNELS{ichan},{expInfo.Channels.Name});
    for icond=1:length(conditions)
        time_sub_mod=squeeze(time_sub_chan_mod_cond(:,:,channumber,:,icond));
        time_mod=squeeze(mean(time_sub_mod,2));
        time_mod(:,4)=time_mod(:,1)-time_mod(:,2);
        mod_time=permute(time_mod,[2 1]);
        % baseline correction
        mod_time(:,:)=ft_preproc_baselinecorrect(mod_time,...
            baseline.beg, baseline.end);
        ps=squeeze(cond_chan_tps(icond,channumber,:));
        xmarkers=expInfo.t(medfilt2((ps<str2double(conf.PVALUE)),...
            [str2double(conf.MEDFILT) 1]));
        xmarkers(xmarkers>RTs(icond+1))=[];
        mod_time_LP=ft_preproc_lowpassfilter(mod_time,...
            expInfo.SampleRate,str2double(conf.LOWPASS));
    
        subplot(length(conditions),1,icond);
        sub_pos = get(gca,'position'); % get subplot axis position
        set(gca,'position',sub_pos.*[1 1 1 1.3]) % stretch its width and height
    
        plot(expInfo.t,mod_time_LP(1,:),'r-','LineWidth',1.5);hold on;
        plot(expInfo.t,mod_time_LP(3,:),'g-','LineWidth',1.5);
        plot(expInfo.t,mod_time_LP(4,:),'b:','LineWidth',1.5);
        if ~isempty(xmarkers), plot(xmarkers,ylim(1),'m.','MarkerSize',10);end
        axis([xlim(1) xlim(2) ylim(1) ylim(2)]);%ylim(1) ylim(2)
        line([1 1], ylim,'Color','g','LineStyle',':','LineWidth',1.2)
        line([conditions(icond).SOA conditions(icond).SOA], ylim,'Color','r','LineStyle',':','LineWidth',1.2)
        line([RTs(icond+1) RTs(icond+1)], ylim,'Color','k','LineStyle',':','LineWidth',1.2)
        ylabel(conditions(icond).name);
        text(xlim(1)*1.35,ylim(2),'\muV');
        
        if icond~=length(conditions), set(gca,'XTickLabel',{});else xlabel('Time (ms.)'); end
        ax=gca;
        
        if icond==1,title(conf.CHANNELS{ichan});end
        ax.XTick=-200:100:600;
        ax.XGrid='off';
        if icond==8,legend('AV','V','AV-A','Location','southwest');end
        hold off
        
    end
    
end

end

