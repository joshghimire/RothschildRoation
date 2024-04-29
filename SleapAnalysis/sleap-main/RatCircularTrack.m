% 3.20.24 Josh- According to node_names, Node 1 is Head_front,
% 2:Head-back, 3: middle, 4: tail

% According to edge_names: Wait how do I read edge_Names?
% Is edge_Names(1,1) start of edge and edge_Names(1,2) end of that edge?.
% Probably yes.

% I guess pt=obj.PositionTable aka pt below might be a good place to start with
% plotting?
%

classdef RatCircularTrack < SleapHDF5Loader
    properties
        % Add properties specific to RatCircularTrack analysis here
        PositionTable
        Center
        Radius
    end

    methods
        % Constructor
        function obj = RatCircularTrack(filePath)
            % Call superclass constructor
            obj@SleapHDF5Loader(filePath);
            % Initialization code specific to RatCircularTrack
            % Preallocate table
            numFrames = size(obj.Tracks, 1);
            numNodes = size(obj.Tracks, 2);

            % Flatten the data for table conversion
            [frames, nodes] = ndgrid(1:numFrames, 1:numNodes);
            xCoordinates = squeeze(obj.Tracks(:, :, 1));
            yCoordinates = squeeze(obj.Tracks(:, :, 2));

            % Creating the table
            obj.PositionTable = table(frames(:), nodes(:), xCoordinates(:), yCoordinates(:), ...
                'VariableNames', {'Frame', 'Node', 'XCoordinate', 'YCoordinate'});
            obj.PositionTable.PointScores= reshape( obj.PointScores,[],1);
            obj.PositionTable.InstanceScores= repmat( obj.InstanceScores,4,1);
            obj.Tracks=[];
            obj.PointScores=[];
            obj.TrackOccupancy=[];
            obj.TrackingScores=[];
        end

        % Example method to calculate center of circular track
        function obj = plotRawTime(obj)
            pbaspect([20 1 1])
            hold on
            pt=obj.PositionTable;
            color1=linspecer(20,'sequential');
            size1=[2 5 10 1]*3;
            alpha=[.5 .2 .1 .1];
            fr=25;
            nodes=unique(pt.Node);
            for inode=1:numel(nodes)
                pt1=pt(pt.Node==inode,:);
                x1=pt1.XCoordinate;
                y1=pt1.YCoordinate;
                time1=pt1.Frame/fr/60;
                scatter3(time1,x1,y1,size1(inode),color1(inode,:), ...
                    "filled", MarkerEdgeAlpha=alpha(inode),MarkerFaceAlpha=alpha(inode))
            end
            scatter3(time1, ...
                ones(size(time1))*obj.Center(1), ...
                ones(size(time1))*obj.Center(2), ...
                30,[.5 .5 .5],"filled", ...
                MarkerEdgeAlpha=.5,MarkerFaceAlpha=.5);
            ax=gca;
            ax.YLim=[0 1000];
            ax.ZLim=[0 1000];
        end        % Example method to calculate center of circular track
        function obj = plotAngleTime(obj)
            ax=gca;
            pbaspect([20 1 1])
            hold on
            pt=obj.PositionTable;
            color1=linspecer(20,'sequential');
            size1=[5 5 1 1]*3;
            alpha=[.1 .5 .1 .1];
            fr=25;
            nodes=unique(pt.Node);
            for inode=1:numel(nodes)
                pt1=pt(pt.Node==inode,:);
                x1=pt1.XCoordinate;
                y1=pt1.YCoordinate;
                % Adjust coordinates to be relative to the center
                x_relative = x1 - obj.Center(1);
                y_relative = y1 - obj.Center(2);

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
        end
        function obj = plotHeadDirectionColor(obj)
            ax=gca;
            pbaspect([20 1 1])
            hold on
            pt=obj.PositionTable;
            fr=25;
            pt1=pt(pt.Node==1,:);
            x1=pt1.XCoordinate;
            y1=pt1.YCoordinate;
            pt2=pt(pt.Node==2,:);
            x2=pt2.XCoordinate;
            y2=pt2.YCoordinate;
            % Step 1: Calculate the midpoint M
            mx = (x1 + x2) / 2;
            my = (y1 + y2) / 2;
            % Adjust coordinates to be relative to the center
            x_relative = mx - obj.Center(1);
            y_relative = my - obj.Center(2);

            % Calculate the angle in radians
            angleRadians = -atan2(y_relative, x_relative);
            % Convert the angle to degrees
            angleDegrees = rad2deg(angleRadians);

            % Step 2: Calculate the direction (angle) of the vector from P1 to P2
            vectorAngleDegrees = rad2deg(atan2(y2 - y1, x2 - x1));

            % Calculate vector from center to midpoint
            cx = mx - obj.Center(1);
            cy = my - obj.Center(2);

            % Calculate the direction (angle) of this vector
            centerToMidpointAngleDegrees = rad2deg(atan2(cy, cx));

            % Step 3: Calculate the angle between the two vectors
            angleBetweenVectors = mod(centerToMidpointAngleDegrees - vectorAngleDegrees, 360);

            % % Ensure the angle is within the range [0, 180]
            % if angleBetweenVectors > 180
            %     angleBetweenVectors = 360 - angleBetweenVectors;
            % end
            % Normalize angle to [0, 1]
            normalizedAngle = angleBetweenVectors / 360;

            % Generate HSV colormap
            numColors = 256; % You can adjust the number of colors
            hsvColors = hsv(numColors);

            % Map normalized angle to the colormap
            % Ensure the indices are within the valid range of the colormap
            colorIndices = ceil(normalizedAngle * (numColors - 1)) + 1;
            colorIndices(isnan(colorIndices))=1;
            colorVector = hsvColors(colorIndices, :);

            time1=pt1.Frame/fr/60;
            scatter(time1,angleDegrees,ones(size(time1))*5,colorVector, ...
                "filled", MarkerEdgeAlpha=.2,MarkerFaceAlpha=.2)
        end
        function obj = plotHeadDirection(obj)
            ax=gca;
            pbaspect([20 1 1])
            hold on
            pt=obj.PositionTable;
            fr=25;
            pt1=pt(pt.Node==1,:);
            x1=pt1.XCoordinate;
            y1=pt1.YCoordinate;
            pt2=pt(pt.Node==2,:);
            x2=pt2.XCoordinate;
            y2=pt2.YCoordinate;
            % Step 1: Calculate the midpoint M
            mx = (x1 + x2) / 2;
            my = (y1 + y2) / 2;
            % Adjust coordinates to be relative to the center
            x_relative = mx - obj.Center(1);
            y_relative = my - obj.Center(2);

            % Calculate the angle in radians
            angleRadians = -atan2(y_relative, x_relative);
            % Convert the angle to degrees
            angleDegrees = rad2deg(angleRadians);

            % Step 2: Calculate the direction (angle) of the vector from P1 to P2
            vectorAngleDegrees = rad2deg(atan2(y2 - y1, x2 - x1));

            % Calculate vector from center to midpoint
            cx = mx - obj.Center(1);
            cy = my - obj.Center(2);

            % Calculate the direction (angle) of this vector
            centerToMidpointAngleDegrees = rad2deg(atan2(cy, cx));

            % Step 3: Calculate the angle between the two vectors
            angleBetweenVectors = mod(centerToMidpointAngleDegrees - vectorAngleDegrees, 360);

            % Normalize angle to [0, 1]
            normalizedAngle = angleBetweenVectors / 360;

            % Generate HSV colormap
            numColors = 256; % You can adjust the number of colors
            hsvColors = hsv(numColors);

            % Map normalized angle to the colormap
            % Ensure the indices are within the valid range of the colormap
            colorIndices = ceil(normalizedAngle * (numColors - 1)) + 1;
            colorIndices(isnan(colorIndices))=1;
            colorVector = hsvColors(colorIndices, :);

            time1=pt1.Frame/fr/60;

            scatter(time1,abs(mod(angleBetweenVectors+180,360)-180),ones(size(time1))*5,colorVector, ...
                "filled", MarkerEdgeAlpha=.2,MarkerFaceAlpha=.2)
        end
        % Example method to calculate center of circular track
        function obj = plotAngularVelocity(obj) % Josh plotting velocity plo
            pt = obj.PositionTable;
            fr=25;
            pt1=pt(pt.Node==1,:);
            x1=pt1.XCoordinate;
            y1=pt1.YCoordinate;
            pt2=pt(pt.Node==2,:);
            x2=pt2.XCoordinate;
            y2=pt2.YCoordinate;
            % Step 1: Calculate the midpoint M
            mx = (x1 + x2) / 2;
            my = (y1 + y2) / 2;
            % Adjust coordinates to be relative to the center
            x_relative = mx - obj.Center(1);
            y_relative = my - obj.Center(2);

            % Calculate the angle in radians
            angleRadians = -atan2(y_relative, x_relative);
            % Convert the angle to degrees
            angleDegrees = rad2deg(angleRadians);
            filledNanAngleDegrees = fillmissing(angleDegrees,'linear'); % Fill missing data using linear interpolation
            smoothAngleDegrees = medfilt1(filledNanAngleDegrees, 10);% Apply a 10th order 1 dimensional medial filter.
            % Adjust angles to be within the range [0, 360) if necessary
            % angleDegrees = mod(angleDegrees, 360)
            angleDeg = [diff(smoothAngleDegrees)/.04 ; 0];
            %plot(angleDeg)
            angleDeg1 = medfilt1(angleDeg, 10, 'omitnan');
            angleDeg1 = smoothdata(angleDeg1, 'gaussian', 25);
            angleDeg1(abs(zscore(angleDeg1))>4)=nan;
            hold on
            time1=pt1.Frame/fr/60;

            plot(time1, angleDeg1)
            ax=gca;
            ax.YGrid="on";


        end
        function obj = setCenter(obj,center)
            obj.Center=center;
        end
        function obj = getHeadPosition(obj)
        end
        % Example method to calculate center of circular track
        function obj = calculateTrackCenter(obj)
            % Dummy implementation - replace with actual calculation
            obj.CenterCoordinates = [0, 0]; % This would be replaced with actual calculations
        end

        % Example method to calculate radius of circular track
        function obj = calculateTrackRadius(obj)
            % Dummy implementation - replace with actual calculation
            obj.Radius = 0; % This would be replaced with actual calculations
        end

        % Override or add new methods here for specific RatCircularTrack functionality
        function obj = viewShoddyVideo(obj)

            %% Tryin to plot theta angle as well
            cd R:\DataBackup\RothschildLab\utku\Josh
            load('PositionTable.mat')
            pt = ratontrack.PositionTable;
            nodes=unique(pt.Node);
            for inode=1:1
                pt1=pt(pt.Node==inode,:);
                x1=pt1.XCoordinate;
                y1=pt1.YCoordinate;

                pt2=pt(pt.Node==2,:);   % hardcoded for now
                x2=pt2.XCoordinate;   % hardcoded
                y2=pt2.YCoordinate;   % hardcoded

                % Adjust coordinates to be relative to the center
                x_relative = x1 - ratontrack.Center(1);
                y_relative = y1 - ratontrack.Center(2);

                % Calculate the angle in radians
                angleRadians = -atan2(y_relative, x_relative);
                % Convert the angle to degrees
                angleDegrees = rad2deg(angleRadians);
                % Adjust angles to be within the range [0, 360) if necessary
                % angleDegrees = mod(angleDegrees, 360);
                %time1=pt1.Frame/fr/60;
                %scatter(time1,angleDegrees,size1(inode),color1(inode,:), ...
                %"filled", MarkerEdgeAlpha=alpha(inode),MarkerFaceAlpha=alpha(inode))
            end
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
            videoStartTimeInMinutes = input("Video start frame in whole minutes: ");
            startFrame = videoStartTimeInMinutes * 60;  % To use v.CurrentTime (which is timestamp in seconds from video start, need to convert)
                
            v.CurrentTime = startFrame;
            
            figure
            i = v.CurrentTime * v.FrameRate;
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
        end
    end
end
