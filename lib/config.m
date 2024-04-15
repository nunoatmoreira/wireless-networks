classdef config
    %CONFIG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        randNet;            % Random network
        numNodes;           % Number of Nodes
        numConnections;     % Number of Connections
        commRange;          % Communication Range
        % Simulation Area
        area_x;
        area_y;
        area_z;
        % Position
        position_x;
        position_y;
        position_z;
        % Velocity
        velocity_x;
        velocity_y;
        velocity_z;
        % Acceleration
        acceleration_x;
        acceleration_y;
        acceleration_z;        
    end
    
    methods
        function obj = config(options)
            arguments
                options.randNet (1,1) = 1;
                options.numNodes (1,1) = 3;
                options.numConnections (1,1) = 10;
                options.commRange (1,1) = 100;
                options.areaX (1,1) = 100;
                options.areaY (1,1) = 100;
                options.areaZ (1,1) = 0;
                options.x (1,1) = 1;
                options.y (1,1) = 1;
                options.z (1,1) = 0;
                options.vx (1,1) = 1;
                options.vy (1,1) = 1;
                options.vz (1,1) = 0;
                options.ax (1,1) = 0;
                options.ay (1,1) = 0;
                options.az (1,1) = 0;                
            end
            
                obj.randNet = options.randNet;
                obj.numNodes = options.numNodes;
                obj.numConnections = options.numConnections;
                obj.commRange = options.commRange;
                obj.area_x = options.areaX;
                obj.area_y = options.areaY;
                obj.area_z = options.areaZ;
                obj.position_x = options.x;
                obj.position_y = options.y;
                obj.position_z = options.z;
                obj.velocity_x = options.vx;
                obj.velocity_y = options.vy;
                obj.velocity_z = options.vz;
                obj.acceleration_x = options.ax;
                obj.acceleration_y = options.ay;
                obj.acceleration_z = options.az;  
        end
        
    end
end

