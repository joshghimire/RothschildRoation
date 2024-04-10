classdef SleapHDF5Loader
    properties
        FilePath string
        
        TrackOccupancy
        Tracks
        TrackNames
        NodeNames
        EdgeNames
        EdgeInds
        PointScores
        InstanceScores
        TrackingScores
    end
    
    methods
        function obj = SleapHDF5Loader(filePath)
            obj.FilePath = filePath;
            obj=obj.loadAll();
        end
        
        function obj = loadTrackOccupancy(obj)
            obj.TrackOccupancy = h5read(obj.FilePath, '/track_occupancy');
        end
        
        function obj = loadTracks(obj)
            obj.Tracks = h5read(obj.FilePath, '/tracks');
        end
        
        function obj = loadTrackNames(obj)
            obj.TrackNames = h5read(obj.FilePath, '/track_names');
            % Convert to string or perform necessary conversion here
        end
        
        function obj = loadNodeNames(obj)
            obj.NodeNames = h5read(obj.FilePath, '/node_names');
            % Convert to string or perform necessary conversion here
        end
        
        function obj = loadEdgeNames(obj)
            obj.EdgeNames = h5read(obj.FilePath, '/edge_names');
            % Convert to string or perform necessary conversion here
        end
        
        function obj = loadEdgeInds(obj)
            obj.EdgeInds = h5read(obj.FilePath, '/edge_inds');
        end
        
        function obj = loadPointScores(obj)
            obj.PointScores = h5read(obj.FilePath, '/point_scores');
        end
        
        function obj = loadInstanceScores(obj)
            obj.InstanceScores = h5read(obj.FilePath, '/instance_scores');
        end
        
        function obj = loadTrackingScores(obj)
            obj.TrackingScores = h5read(obj.FilePath, '/tracking_scores');
        end
        
        function obj = loadAll(obj)
            obj = obj.loadTrackOccupancy();
            obj = obj.loadTracks();
            obj = obj.loadTrackNames();
            obj = obj.loadNodeNames();
            obj = obj.loadEdgeNames();
            obj = obj.loadEdgeInds();
            obj = obj.loadPointScores();
            obj = obj.loadInstanceScores();
            obj = obj.loadTrackingScores();
        end
    end
end
