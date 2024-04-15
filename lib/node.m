classdef node
    %NODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id;
        x;
        y;
        %z;
        vx;
        vy;
        %vz;
        frequency;
        sensitivity;
        tx_power;
        range;
        circle_node;
        circle_connection;
        text;
        tx_packet;
        rx_packet;
    end
    
    methods
        function obj = node(id, x, y ,options)
            arguments
                id;
                x;
                y;
               options.vx (1,1) = 0;
               options.vy (1,1) = 0;
               options.vz (1,1) = 0;
               options.frequency = 2430;
               options.sensitivity(1,1) = -100.00;
               options.tx_power(1,1) = 35;
            end
                obj.id = id;
               
                obj.x = x;
                obj.y = y;
                
                obj.vx = options.vx;
                obj.vy = options.vy;
                
                obj.frequency = options.frequency;
                obj.sensitivity = options.sensitivity;
                obj.tx_power = options.tx_power;
        end
        
        function obj = setNodePosition(node, x, y, z)
            obj = node;
            obj.x = x;
            obj.y = y;
            obj.z = z;
        end
        
        function obj = setNodeVelocity(node, vx, vy, vz)
            obj = node;
            obj.vx = vx;
            obj.vy = vy;
            obj.vz = vz;
        end
         
        function obj = setNodeAcceleration(ax, ay, az)
            obj.ax = ax;
            obj.ay = ay;
            obj.az = az;
        end           
        
        function obj = setDistances(distances)
            obj.distances = distances;
        end
        
        function obj = setConnections(connections)
            obj.connections = connections; 
        end

        function connections = getConnections(node)
            connections = node.connections;
        end
    end
end

