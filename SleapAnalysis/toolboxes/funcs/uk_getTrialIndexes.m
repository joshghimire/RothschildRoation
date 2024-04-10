function [ I ] = uk_getTrialIndexes(Markers, Type, Description)
% GETBADINTERVALS Give the Markers exported from Analyzer
%   [ I ] = getTrials(Markers, Type, Description)
%   output I
%   input Markers 
%   input type 'bad interval' 'stimulus'
%   inout Description, if type is stimulus, marker code
I=[];
numTrials=size(Markers,1);
numMarkerWithinTrials=size(Markers,2);
for iTrial=1:numTrials
    for iWithin=1:numMarkerWithinTrials
        if strcmpi(Type,Markers(iTrial,iWithin).Type)
            switch lower(Type)
                case 'bad interval'
                    I(end+1)=iTrial;
                case 'stimulus'
                    if strcmpi(Description,Markers(iTrial,iWithin).Description)
                        I(end+1)=iTrial;
                    end
                otherwise
                    warning(['bad type: ' Type]);
            end
        end
    end
end
end

