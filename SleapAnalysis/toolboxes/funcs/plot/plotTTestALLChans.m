function [  ] = plotTTestALLChans( cond_chan_tps, conditions, expInfo )
%PLOTTTESTALLCHANS Summary of this function goes here
%   Detailed explanation goes here
conf=readconf('plotTTestALLChans_conf');
mons=get(groot,'MonitorPositions');
figArea=mons(end,:);
horLength=figArea(3);
clims=[str2double(conf.CLIMS{1}) str2double(conf.CLIMS{2})];
medfilt=str2double(conf.MEDIANFILT);
RTs=[310.769231000000 320.769231000000 320 334.615385000000 343.076923000000 356.153846000000 365.384615000000 367.692308000000 369.230769000000 NaN];

changroups{1}=conf.CHANNELGROUP1;
changroups{2}=conf.CHANNELGROUP2;
changroups{3}=conf.CHANNELGROUP3;
changroups{4}=conf.CHANNELGROUP4;
changroups{5}=conf.CHANNELGROUP5;
changroupsNameStr=conf.CHANNELGROUPNAMES;
changroupsStr=cell(5,1);
for i=1:length(changroups)
    changroupsStr{i}='';
    for j=1:length(changroups{i})
        changroupsStr{i}=strcat(changroupsStr{i},',',changroups{i}{j});
    end
end

step=horLength/length(changroups);
for igroups=1:length(changroups)
    chanorderStr=[changroups{igroups}];
    channels={expInfo.Channels.Name};
    [Lia,chanorder] = ismember(chanorderStr,channels);
    shift=0;
    
    figlocarea=figArea;
    figlocarea(1)=figArea(1)+step*(igroups-1);
    figlocarea(3)=step;
    
    figure('OuterPosition',figlocarea);
    conds=1:length(conditions);
    iter=0;
    for icond=conds
        iter=iter+1;
        subplot(length(conds),1,iter);%figure('OuterPosition',mons(end,:))
        sub_pos = get(gca,'position'); % get subplot axis position
        set(gca,'position',sub_pos.*[1 1 1 1.3]) % stretch its width and height
        chan_tps=squeeze(cond_chan_tps(icond,:,:));
        h=imagesc(expInfo.t,[],medfilt2(chan_tps(chanorder,:),[1 medfilt]),clims);
        set(gca,'YTick',1:length(Lia),'YTickLabel',{});%channels(chanorder)
        ylabel(conditions(icond).name);
        if icond==1,title([changroupsNameStr{igroups}]);end % changroupsStr{igroups}{1}(2:end)
        if icond~=length(conds)
            set(gca,'XTickLabel',{});
        else
            xlabel('Time (ms)')
        end
        
        axis([00,400,-inf,inf])
        %     line([0 0], ylim,'Color','b','DisplayName',' ')
        %     line([lines(i) lines(i)], ylim,'Color','g','DisplayName',' ')
        line([RTs(icond+1)-shift RTs(icond+1)-shift], [1 length(chanorder)],'Color','k','DisplayName',' ')
        grid on
    end
    
end

