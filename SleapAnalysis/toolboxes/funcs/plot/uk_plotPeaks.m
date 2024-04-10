function [ ] = uk_plotPeaks( cond_roi,conditions )
%UK_PLOT_WAVELET_AVERAGES Summary of this function goes here
%   Detailed explanation goes here
mons=get(groot,'MonitorPositions');
cond_sub_roi_mod_loc=cond_roi.locs.bimodal;
cond_sub_roi_mod_pks=cond_roi.pks.bimodal;
locsmean=squeeze(nanmean(cond_sub_roi_mod_loc,2));
locstd=squeeze(nanstd(cond_sub_roi_mod_loc,0,2));
locserr=locstd/sqrt(size(cond_sub_roi_mod_loc,2));

pksmean=squeeze(nanmean(cond_sub_roi_mod_pks,2));
pksstd=squeeze(nanstd(cond_sub_roi_mod_pks,0,2));
pkserr=pksstd/sqrt(size(cond_sub_roi_mod_pks,2));

modality=2;
modalityStr={'AV','AV-A','AV-A-V'};
anovaRange=1:8;
figure('OuterPosition',mons(end,:))
props={'-ok','-+k','-.*k','x:k'};
for iroi=1:size(locsmean,2)
    subplot(size(locsmean,2),2,(iroi-1)*2+1);    
    E1=errorbar(squeeze(locsmean(:,iroi,modality)),squeeze(locserr(:,iroi,modality)),'-.ko');
    SOAs=squeeze(cond_sub_roi_mod_loc(:,:,iroi,modality))';
    Vs=repmat(squeeze(cond_roi.locs.unimodal.V(:,iroi)),1,8);
    [h,pt,ci,statst] =ttest(SOAs,Vs,'Alpha',.05);
    for ittest=1:length(h)
        text(ittest,locsmean(ittest,iroi,modality),sprintf('%.3f',pt(ittest)),'FontSize',6,'HorizontalAlignment','right')
        if h(ittest), text(ittest,locsmean(ittest,iroi,modality),'*','FontSize',30,'Color','red','HorizontalAlignment','center');end
    end
    ylabel([roistr{iroi}])
    if iroi==1, title('Peak Latencies (ms.)');end
    set(gca,'XTick',1:numConds,'XtickLabel',conditionswavelet1);
    legend([E1 ],modalityStr{modality},'Location','southeast')
    [p,tbl,stats]=anova1(squeeze(locs(anovaRange,:,iroi,modality))',conditionswavelet1(anovaRange),'off');
    strANOVA=sprintf('F(%d,%d) = %.2f, p=%.3f',tbl{2,3},tbl{3,3},tbl{2,5},tbl{2,6});
    if p<.05, annColor='r';else,annColor='k'; end
    annotation(gcf,'textbox',...
    [0.3 .88-(iroi-1)*.22 0.06 0.03],...
    'String',{strANOVA},...
    'FitBoxToText','on','Color',annColor);
    grid on

    subplot(size(locsmean,2),2,(iroi-1)*2+2)
    E1=errorbar(squeeze(pksmean(:,iroi,modality)),squeeze(pkserr(:,iroi,modality)),'-.ko');
    SOAs=squeeze(pks(1:8,:,iroi,modality))';
    Vs=repmat(squeeze(pks(9,:,iroi,modality))',1,8);
    [h,pt,ci,statst] =ttest(SOAs,Vs,'Alpha',.05);
    for ittest=1:length(h)
        text(ittest,pksmean(ittest,iroi,modality),sprintf('%0.3f',pt(ittest)),'FontSize',6,'HorizontalAlignment','right')
        if h(ittest), text(ittest,pksmean(ittest,iroi,modality),'*','FontSize',30,'Color','red','HorizontalAlignment','center');end
    end
    if iroi==1, title('Peak Powers (dB.)');end
    set(gca,'XTick',1:numConds,'XtickLabel',conditionswavelet1);
    legend([E1 ],modalityStr{modality},'Location','southeast');
    [p,tbl,stats]=anova1(squeeze(pks(anovaRange,:,iroi,modality))',conditionswavelet1(anovaRange),'off');
    strANOVA=sprintf('F(%d,%d) = %.2f, p=%.3f',tbl{2,3},tbl{3,3},tbl{2,5},tbl{2,6});
    if p<.05, annColor='r';else,annColor='k'; end
    annotation(gcf,'textbox',...
    [0.75 .88-(iroi-1)*.22 0.06 0.03],...
    'String',{strANOVA},...
    'FitBoxToText','on','Color',annColor);
    grid on
end

end

