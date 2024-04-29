addpath('R:\DataBackup\RothschildLab\utku\Josh')
addpath(genpath('C:\Users\gidlab-admin\Documents')) % Add folder and subfolders to Matlab Search Path
load('PositionTable.mat')
pt = ratontrack.PositionTable;
nodes=unique(pt.Node);
for inode=1:numel(nodes)
    pt1=pt(pt.Node==inode,:);
    x1=pt1.XCoordinate;
    y1=pt1.YCoordinate;

    % pt2=pt(pt.Node==2,:);   % hardcoded for now
    % x2=pt2.XCoordinate;   % hardcoded
    % y2=pt2.YCoordinate;   % hardcoded
    
    % Adjust coordinates to be relative to the center
    x_relative = x1 - ratontrack.Center(1);
    y_relative = y1 - ratontrack.Center(2);

    % Calculate the angle in radians
    angleRadians = -atan2(y_relative, x_relative);
    % Convert the angle to degrees
    angleDegrees = rad2deg(angleRadians);
    filledNanAngleDegrees = fillmissing(angleDegrees,'linear');
    smoothAngleDegrees = medfilt1(filledNanAngleDegrees, 10);
    % Adjust angles to be within the range [0, 360) if necessary
    % angleDegrees = mod(angleDegrees, 360);
    time1=pt1.Frame/fr/60;
    scatter(time1,angleDegrees,size1(inode),color1(inode,:), ...
        "filled", MarkerEdgeAlpha=alpha(inode),MarkerFaceAlpha=alpha(inode))
end


% %% Next attempt. OH Videos were always on R: server. Try above solutions with local videos. 
% %cd C:\Users\gidlab-admin\Documents\Josh
% videoFile = 'Basler_acA4024-29um__24844056__20240125_130929331_RUN.mp4';
% v = VideoReader(videoFile);
% sleapDownSampling = 2.5; % videos fed into SLEAP are downsampled from 2500x2500 to 1000x1000
% 
% workingDir = 'C:\Users\gidlab-admin\Documents\Josh';
% %mkdir(workingDir)
% %mkdir(workingDir,"images")
% % 
% % i = 1;
% % while hasFrame(v)
% %    img = readFrame(v);
% %    filename = sprintf("%03d",i)+".jpg";
% %    fullname = fullfile(workingDir,"images",filename);
% %    imwrite(img,fullname)    % Write to a JPEG file (001.jpg, 002.jpg, ..., 121.jpg)
% %    i = i+1;
% % end
% xPositions = x1 * sleapDownSampling; 
% yPositions = y1 * sleapDownSampling;
% 
% i = 1;
% while hasFrame(v)
%    img = readFrame(v);
%    %x(i) = imshow(img);
%    imshow(img);
%    hold on
%    scatter(xPositions(i), yPositions(i), 'r')
%    plot(angleDegrees(i))
%    hold off
%    i = i+1;
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Tryin to plot theta angle as well
addpath 'C:\Users\gidlab-admin\Documents\Josh';
videoFile = 'Basler_acA4024-29um__24844056__20240125_130929331_RUN.mp4';
v = VideoReader(videoFile);
sleapDownSampling = 2.5; % videos fed into SLEAP are downsampled from 2500x2500 to 1000x1000

xPositions1 = x1 * sleapDownSampling; 
yPositions1 = y1 * sleapDownSampling;

% xPositions2 = x2 * sleapDownSampling; 
% yPositions2 = y2 * sleapDownSampling;

centerX = v.Width / 2;
centerY = v.Height / 2;

figure
i = 1;
while hasFrame(v)
   img = readFrame(v);
   %angleRadians = insertMarker(img, ratontrack.Center);
   imshow(img);
   hold on

   % Calculate the endpoint coordinates based on the angle
   angle = angleRadians(i); % Replace angles(i) with your angle data
   lineLength = 1000; % Define the length of the line

   % Calculate endpoint coordinates
   xEnd = centerX + lineLength * cos(angle);
   yEnd = centerY - lineLength * sin(angle);

   % Plot the line
   plot([centerX, xEnd], [centerY, yEnd], 'b', 'LineWidth', 2);

   scatter(xPositions1(i), yPositions1(i), 'r')
   %scatter(xPositions2(i), yPositions2(i), 'b')
   %1plot(angleDegrees(i))
   hold off
   i = i+1;
end
%% angleRadiansCheck- Is angleRadians is the direction relative to the center of the track? 
% No, it might be the angle direction of the center?? of the head 
cd 'C:\Users\gidlab-admin\Documents\Josh';
videoFile = 'Basler_acA4024-29um__24844056__20240125_130929331_RUN.mp4';
v = VideoReader(videoFile);
sleapDownSampling = 2.5; % videos fed into SLEAP are downsampled from 2500x2500 to 1000x1000

xPositions1 = x1 * sleapDownSampling; 
yPositions1 = y1 * sleapDownSampling;

% xPositions2 = x2 * sleapDownSampling; 
% yPositions2 = y2 * sleapDownSampling;

centerX = v.Width / 2;
centerY = v.Height / 2;

figure
i = 1;
while hasFrame(v)
   img = readFrame(v);
   %angleRadians = insertMarker(img, ratontrack.Center);
   imshow(img);
   hold on
    
   % Calculate the endpoint coordinates based on the angle
   angle = angleRadians(i); % Replace angles(i) with your angle data
   lineLength = 100; % Define the length of the line
    
   % Calculate endpoint coordinates
   xEnd = xPositions1(i) + lineLength * cos(angle);
   yEnd = yPositions1(i) - lineLength * sin(angle);
    
     % Plot the line
   plot([centerX, xEnd], [centerY, yEnd], 'b', 'LineWidth', 2);
   
   scatter(xPositions1(i), yPositions1(i), 'r')
   %scatter(xPositions2(i), yPositions2(i), 'b')
   %1plot(angleDegrees(i))
   hold off
   i = i+1;
end

%% TO DO: Plot history of points: Plot points from the last 2-5 seconds?

%% Velocity Calculations
videoFrameRate = 25;            % Hardcoded for now, frame rate of video file.
videoTimeBinSize = 0.5;           % size of time bin to use (in seconds of video) for velocity calculations
videoTimeBinFrames = videoTimeBinSize * videoFrameRate; 


for i = 2:(v.NumFrames/videoTimeBinFrames)
    angularVelDegPerFrame(i) = (angleDegrees(videoFrameRate * i) - angleDegrees(videoFrameRate * i-1))/videoFrameRate;  % How much does the angle in degrees change per frame bin size?
    angularVelDegPerSec(i) = angularVelDegPerFrame(i) * (videoFrameRate); % How much does the angle in degrees change per second?
end

angularVelDegPerFrame = angularVelDegPerFrame';
angularVelDegPerSec = angularVelDegPerSec';
angularVelDegPerSec = medfilt1(angularVelDegPerSec, 5, 'omitnan');

normalizedAngularVelDegPerSec = angularVelDegPerSec;
% normalizedAngularVelDegPerSec = normalize(angularVelDegPerSec, 'range');
% normalizedAngularVelDegPerSec = normalize(angularVelDegPerSec);

%%
%% New Velocity Calculations
videoFrameRate = 25;            % Hardcoded for now, frame rate of video file.
videoTimeBinSize = 0.5;           % size of time bin to use (in seconds of video) for velocity calculations
videoTimeBinFrames = videoTimeBinSize * videoFrameRate; 

angleDeg = diff(smoothAngleDegrees)/.04;
figure;
%plot(angleDeg)
angleDeg1 = medfilt1(angleDeg, 10, 'omitnan');
angleDeg1 = smoothdata(angleDeg1, 'gaussian', 25);
angleDeg1(abs(zscore(angleDeg1))>4)=nan
hold on
plot((angleDeg1))
ax=gca;
ax.YGrid="on"

for i = 2:(v.NumFrames/videoTimeBinFrames)
    angularVelDegPerFrame(i) = (angleDegrees(videoFrameRate * i) - angleDegrees(videoFrameRate * i-1))/videoFrameRate;  % How much does the angle in degrees change per frame bin size?
    angularVelDegPerSec(i) = angularVelDegPerFrame(i) * (videoFrameRate); % How much does the angle in degrees change per second?
end

angularVelDegPerFrame = angularVelDegPerFrame';
angularVelDegPerSec = angularVelDegPerSec';
angularVelDegPerSec = medfilt1(angularVelDegPerSec, 5, 'omitnan');

normalizedAngularVelDegPerSec = angularVelDegPerSec;
% normalizedAngularVelDegPerSec = normalize(angularVelDegPerSec, 'range');
% normalizedAngularVelDegPerSec = normalize(angularVelDegPerSec);

%% plot angular velocity
%%% Works!
figure
plot(angularVelDegPerSec)  % plot absolute value of angular velocity, encode negative val via color next time
title('Angular Velocity vs. Time')
%ylim([0 8])
xlim([1 length(angularVelDegPerSec)])
xlabel(sprintf('Time (bin size %d seconds)', videoTimeBinSize))
ylabel('Velocity (delta angle / 25 frames)')
%% Try to plot normalized angular velocity
% Looks bizarre.
figure
plot(normalizedAngularVelDegPerSec)  % plot absolute value of angular velocity, encode negative val via color next time
title('Angular Velocity vs. Time')
ylim([0 .5])
xlim([1 length(angularVelDegPerSec)])
xlabel(sprintf('Time (bin size %d seconds)', videoTimeBinSize))
ylabel('Velocity (delta angle / 25 frames)')

%% Plotting normalized angular velocity
% Actually try to plot with normalized angular velocity. 
% Doesn't work because hsvColor(colorIndices) can't work with negative
% numbers. Normalizig AngularVelDegPerSec with 'range' gives me an unclear
% plot

% Generate HSV colormap
numColors = 256;
hsvColors = hsv(numColors);

% Map normalized velocity to the color map
% Ensure the indices are within the valid range of the colormap
colorIndices = ceil(normalizedAngularVelDegPerSec * (numColors - 1)) + 1;
colorIndices(isnan(colorIndices))=1;
colorIndices = ceil(normalize(colorIndices, 'range') * 255) + 1;
colorVector = hsvColors(colorIndices, :);

xAxis = 1:length(angularVelDegPerSec);
figure
scatter(xAxis, abs(normalizedAngularVelDegPerSec), ones(size(xAxis))*5,colorVector, ...
    "filled", MarkerEdgeAlpha=.2,MarkerFaceAlpha=1)  % plot absolute value of angular velocity, encode negative val via color next time
title('Normalized Angular Velocity vs. Time')

xlim([1 length(angularVelDegPerSec)])
xlabel(sprintf('Time (bin size %d seconds)', videoTimeBinSize))
ylabel(sprintf('Normalized Velocity (delta angle / %d frames)', videoFrameRate * videoTimeBinSize))

%%
% Find Frames at Reward Well
rewardWellLowerAngle = 138;     % Based on eyeballing (plot(angleDegrees)), 138deg to 143deg for angleDeg might be a good first estimate of where the animal is at the correct reward well.                             
rewardWellHigherAngle = 143;
framesAtRewardWell = find(angleDegrees > rewardWellLowerAngle & angleDegrees < rewardWellHigherAngle); % Frames where the animal is at the thresholds defined as the reward well. 

% Find Frames Where Head Angle is 90degrees??. 

% Ensure Counter Clockwise Movement:

% For the number of frames at the rewatd well
% take the frame number of the ith frame
changePtsFramesAtRewardWell = findchangepts(framesAtRewardWell,'Statistic', 'linear', 'MinThreshold', 10000);

% Gives the index of the frames at which a change in signal finishes.
%   For ex, if you have a vector 680; 681; 1337; 1338,
%   This will give you 3 as the value, as the large change started at 681 or index
%   2, but the change finished at 1337, or index 3.
%   'Minsthreshold' Specify a minimum residual error improvement of 10k.

for i = 1:length(changePtsFramesAtRewardWell)
    framesLeavingRewardWell(i,1) = framesAtRewardWell(changePtsFramesAtRewardWell(i)-1);
    %entryExitFrames(i,1) = framesLeavingRewardWell(i,1);
end

changePtsFramesAtRewardWell = [1; changePtsFramesAtRewardWell]; % Adding 1 to changePtsFramesAtRewardWell

% calculate the frames where the animal enters the rewardWell area and
% exits the reward well area.
for i = 1:length(changePtsFramesAtRewardWell) - 1
    rewardWellEntryExit(i, 1) = framesAtRewardWell(changePtsFramesAtRewardWell(i));
    rewardWellEntryExit(i, 2) = framesLeavingRewardWell(i);
end 