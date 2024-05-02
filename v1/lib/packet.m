classdef packet
    %PACKET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        timestamp;
        header = struct('src', [], 'dest', [], 'pkt_id', [], 'pkt_type', []);
        data;
    end
    
    methods (Access = public)
        
        %% Constructor
        function obj = packet()
            obj.timestamp = [];

            obj.header.src = [];
            obj.header.dest = [];
            obj.header.pkt_id = [];
            obj.header.pkt_type = [];

            obj.data = [];
        end
    
        %% Convert struct to class
        function obj = convPacket(struct_packet)
            obj = packet();

            obj.timestamp = struct_packet.timestamp;
        end

        %% CREATE PACKET
        function obj = createPacket(~, tx_time, source, destination, pkt_id, pkt_type, data)
            obj = packet();
            obj.timestamp = tx_time;
            obj.header.src = source;
            obj.header.dest = destination;
            obj.header.pkt_id = pkt_id;
            obj.header.pkt_type = pkt_type;
            obj.data = data;
        end

        %% TIMESTAMP 
        % Get Timestamp
        function timestamp =getPacketTimestamp(packet)
            timestamp = packet.timestamp;
        end
        
        %% HEADER
        % Get Packet Header
        function header = getPacketHeader(packet)
            header = packet.header;
        end

        % Get Source Address
        function src = getPacketSrc(packet)
            src = packet.header.src;
        end
        
        % Get Destination Address
        function dest = getPacketDest(packet)
            dest = packet.header.dest;
        end

        % Get Packet ID
        function pkt_id = getPacketId(packet)
            pkt_id = packet.header.pkt_id;
        end

        % Get Packet Type
        function pkt_type = getPacektType(packet)
            pkt_type = packet.header.pkt_type;
        end

        %% DATA
        % Get Packet Data
        function data = getPacketData(packet)
            data = packet.data;
        end


    end

end

