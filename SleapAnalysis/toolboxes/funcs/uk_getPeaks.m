function [ cond_roi ] = uk_getPeaks( waveletssubject, expInfo )
%UK_GETPEAKS Summary of this function goes here
%   Detailed explanation goes here
conf=readconf('conf');
conf2=readconf('uk_plot_wavelet_averages_conf');% for only reading configuration
peakFindRange=getTimePoint(str2double(conf.ROITIME{1}),expInfo.t)...
    :getTimePoint(str2double(conf.ROITIME{2}),expInfo.t);
baseline=[str2double(conf2.BASELINE{1})...
    str2double(conf2.BASELINE{2})];
baselinetype=conf2.BASELINETYPE;
channels=expInfo.wavelet.channels;
for iroi=1:length(conf.ROIS)/2
    rois(iroi,1)=str2double(conf.ROIS{iroi*2-1});
    rois(iroi,2)=str2double(conf.ROIS{iroi*2});
end
numroi=size(rois,1);
numcond=size(waveletssubject(1).bimodal,2);
numfield=size(fieldnames(waveletssubject(1).bimodal(1)),1);
numsub=size(waveletssubject(1).bimodal(1).AV,1);
% pks=nan(numcond,numsub,numroi,numfield);
% locs=nan(numcond,numsub,numroi,numfield);
for ichan=1:length(channels)
    fprintf('\tchan:%d\n',channels(ichan))
    bimodals=waveletssubject(ichan).bimodal;
    for icond=1:length(bimodals)
        fprintf('\tcond:%d\n',icond)
        bimodal=bimodals(icond);
        fields=fieldnames(bimodal);
        for isub=1:size(bimodal.AV,1)
            for iroi=1:size(rois,1)
                for ifield=1:numel(fields)
                    sub_freq_time=abs(bimodal.(fields{ifield}));
                    sub_freq_time=performNormalization(...
                        expInfo.t,sub_freq_time,baseline,baselinetype);
                    [pks1, locs1] = findpeaks(squeeze(...
                        sub_freq_time(isub,iroi,peakFindRange)...
                        ),expInfo.t(peakFindRange));
                    [M,I]=max(pks1);
                    if isempty(M),M=NaN;end
                    pks.bimodal(icond,isub,iroi,ifield)=M;
                    if isempty(I),locs.bimodal(icond,isub,iroi,ifield)=NaN;
                    else locs.bimodal(icond,isub,iroi,ifield)=locs1(I);end
                    clear pks1 locs1
                end
            end
        end
    end
    unimodal=waveletssubject(ichan).unimodal;
    fields=fieldnames(unimodal);
    for isub=1:size(unimodal.A,1)
        for iroi=1:size(rois,1)
            for ifield=1:numel(fields)
                sub_freq_time=abs(unimodal.(fields{ifield}));
                sub_freq_time=performNormalization(...
                    expInfo.t,sub_freq_time,baseline,baselinetype);
                [pks1, locs1] = findpeaks(squeeze(...
                    sub_freq_time(isub,iroi,peakFindRange)...
                    ),expInfo.t(peakFindRange));
                [M,I]=max(pks1);
                if isempty(M),M=NaN;end
                pks.unimodal.(fields{ifield})(isub,iroi)=M;
                if isempty(I),locs.unimodal.(fields{ifield})(isub,iroi)=NaN;
                else locs.unimodal.(fields{ifield})(isub,iroi)=locs1(I);end
                clear pks1 locs1
            end
        end
    end
end
cond_roi.pks=pks;
cond_roi.locs=locs;

end

