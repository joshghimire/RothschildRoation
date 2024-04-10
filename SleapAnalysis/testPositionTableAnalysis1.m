cd R:\DataBackup\RothschildLab\utku\Josh
load('PositionTable.mat')
pt = ratontrack.PositionTable;
nodes=unique(pt.Node);
for inode=1:numel(nodes)
    pt1=pt(pt.Node==inode,:);
    x1=pt1.XCoordinate;
    y1=pt1.YCoordinate;
    % Adjust coordinates to be relative to the center
    x_relative = x1 - ratontrack.Center(1);
    y_relative = y1 - ratontrack.Center(2);

    % Calculate the angle in radians
    angleRadians = -atan2(y_relative, x_relative);
    % Convert the angle to degrees
    angleDegrees = rad2deg(angleRadians);
    % Adjust angles to be within the range [0, 360) if necessary
    % angleDegrees = mod(angleDegrees, 360);
    time1=pt1.Frame/fr/60;
    scatter(time1,angleDegrees,size1(inode),color1(inode,:), ...
        "filled", MarkerEdgeAlpha=alpha(inode),MarkerFaceAlpha=alpha(inode))
end

%% Video File Part
cd C:\Users\gidlab-admin\Documents\Josh
videoFile = VideoReader('Basler_acA4024-29um__24844056__20240125_130929331_RUN.mp4');
frameHeight = videoFile.Height;
frameWidth = videoFile.Width;
videoPlayer = vision.VideoPlayer('Position', [100 100 frameWidth frameHeight]);

for i = 1:videoFile.NumberOfFrames
    frame = readFrame(videoFile); % Read the current video frame
    
    % Superimpose the dot on the frame
    frame = insertShape(frame, 'FilledCircle', [x1, y1, 5],'Color', 'red', 'Opacity', 1);
    
    step(videoPlayer, frame); % Display the modified frame
end

release(videoPlayer); % Release the video player
release(videoFile); % Release the video reader

%% Kind of works, shows all node 1 locations at once due to while has frame. Maybe need to change mp4 to h5?
cd C:\Users\gidlab-admin\Documents\Josh
videoFile = 'Basler_acA4024-29um__24844056__20240125_130929331_RUN.mp4';
v = VideoReader(videoFile);

xPositions = x1 * 2.5; % Your vector of x positions
yPositions = y1 * 2.5;% Your vector of y positions

figure;
while hasFrame(v)
    frame = readFrame(v);
    imshow(frame);
    hold on;
    plot(xPositions, yPositions, 'ro', 'MarkerSize', 10); % Red dot with size 10
    hold off;
    % Pause to control the frame rate (optional)
    pause(1/v.FrameRate);
end
%%
cd C:\Users\gidlab-admin\Documents\Josh
videoFile = 'Basler_acA4024-29um__24844056__20240125_130929331_RUN.mp4';
v = VideoReader(videoFile);
currAxes = axes;
while hasFrame(v)
    vidFrame = readFrame(v);
    image(vidFrame,"Parent",currAxes)
    currAxes.Visible = "off";
    pause(1/v.FrameRate)
end

%% 
%% Trying again with demoVidPlot. Takes absolute ages, too slow.
cd C:\Users\gidlab-admin\Documents\Josh
videoFile = 'Basler_acA4024-29um__24844056__20240125_130929331_RUN.mp4';
v = VideoReader(videoFile);

% Initial guess for preallocating structure to store video frames
nFrames = ceil(v.FrameRate * v.Duration);
s(nFrames) = struct('cdata', [], 'colormap', []);

% Set up figure, axes to hold image, image, and plot
% This allows us to keep everything positioned in the proper order, and
% just change the image data and the plot location every loop iteration
hFig = figure('MenuBar','none',...
    'Units','pixels',...
    'Position',[100 100 v.Width v.Height]);
hAx = axes('Parent',hFig,...
    'Units','pixels',...
    'Position',[0 0 v.Width v.Height],...
    'NextPlot','add',...
    'Visible','off',...
    'XTick',[],...
    'YTick',[]);
hIm = image(uint8(zeros(v.Height,v.Width,3)),...
    'Parent',hAx);
hLine(1) = plot(hAx,[1 v.Width],[3 3],'-b','LineWidth',2);
hLine(2) = plot(hAx,[1 1],[3 3],'-b','LineWidth',4);
hLine(3) = plot(hAx,1,3,'ob','MarkerSize',10,'MarkerFaceColor','b');

% Loop through video, grabbing frames and updating plots
k = 1;
while hasFrame(v)
    im = readFrame(v);
    hIm.CData = im;
    % Simulate progress bar
    hLine(2).XData(2) = v.Width*k/nFrames;
    hLine(3).XData = v.Width*k/nFrames;
    drawnow
    % Save the frame in structure for later saving to video file
    s(k) = getframe(hAx);
    k = k+1;
end

% Loop through video, grabbing frames and updating plots
k = 1;
while hasFrame(v)
    im = readFrame(v);
    hIm.CData = im;
    % Simulate progress bar
    hLine(2).XData(2) = v.Width*k/nFrames;
    hLine(3).XData = v.Width*k/nFrames;
    drawnow
    % Save the frame in structure for later saving to video file
    s(k) = getframe(hAx);
    k = k+1;
end

%% Next attempt. OH Videos were always on R: server. Try above solutions with local videos. 
cd C:\Users\gidlab-admin\Documents\Josh
videoFile = 'Basler_acA4024-29um__24844056__20240125_130929331_RUN.mp4';
v = VideoReader(videoFile);

workingDir = 'C:\Users\gidlab-admin\Documents\Josh';
%mkdir(workingDir)
%mkdir(workingDir,"images")
% 
% i = 1;
% while hasFrame(v)
%    img = readFrame(v);
%    filename = sprintf("%03d",i)+".jpg";
%    fullname = fullfile(workingDir,"images",filename);
%    imwrite(img,fullname)    % Write to a JPEG file (001.jpg, 002.jpg, ..., 121.jpg)
%    i = i+1;
% end
xPositions = x1 * 2.5; % Your vector of x positions
yPositions = y1 * 2.5;% Your vector of y positions

i = 1;
while hasFrame(v)
   img = readFrame(v);
   imshow(img) 
   hold on
   scatter(xPositions(i), yPositions(i), 'r');
   hold off
   i = i+1;
end