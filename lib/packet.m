classdef packet
    %PACKET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tx_time;
        src;
        pkt_id;
        rx_time;
        dest;
    end
    
    methods
        function obj = packet()
            obj.tx_time = [];
            obj.src = [];
            obj.rx_time = [];
            obj.dest = [];
        end

        function obj = txPacket(obj, src, tx_time, pkt_id, dest)
            obj.tx_time = tx_time;
            obj.src = src;
            obj.pkt_id = pkt_id;
            obj.rx_time = [];
            obj.dest = dest;

        end
    end

end

