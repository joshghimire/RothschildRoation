function [timePoint]=getTimePoint(time,t)
    timePoint=find(t<time,1,'last');
end