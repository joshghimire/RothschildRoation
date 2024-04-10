%% Trying again:
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