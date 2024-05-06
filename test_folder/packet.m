classdef packet
    %PACKET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        src;
        dest;
        type;
        data;
    end
    
    methods
        function obj = packet()

        end
        
        function obj = generateDataPacket(packet, src, dest, data)
            obj = packet;
            obj.src = src;
            obj.dest = dest;
            obj.type = 0;
            obj.data = data;
        end

        function obj = generateDiscoveryPacket(packet, src, data)
            obj = packet;
            obj.src = src;
            obj.dest = 255;
            obj.type = 1;
            obj.data = data;
        end
    end
end

