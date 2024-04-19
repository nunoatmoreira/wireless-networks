classdef packet
    %PACKET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tx_time;
        src;
        pkt_id;
        rx_time;
        dest;
        data;
    end
    
    methods

        function obj = packet()

        end

        function obj = genDiscPacket(packet, src, tx_time, pkt_id, data)
            obj.tx_time = tx_time;
            obj.src = src;
            obj.pkt_id = pkt_id;
            obj.rx_time = [];
            obj.dest = 255;
            obj.data = data;
        end

        function obj = genDataPacket(packet, src, tx_time, pkt_id, dest, data)
            obj.tx_time = tx_time;
            obj.src = src;
            obj.pkt_id = pkt_id;
            obj.rx_time = [];
            obj.dest = 255;
            obj.data = data;
        end
    end

end

