classdef network
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pkt_queue;
        NODE;
    end
    
    %% CONSTRUCTOR
    methods
        function obj = network()
            obj.pkt_queue = [];
        end
    
        function obj = addNode(network, node)
            obj = network;

            obj.NODE = [obj.NODE; node];
        end
    end
    
    %% PACKET QUEUE MANAGEMENT
    methods
        function obj = addPacketToQueue(network, packet)
            obj = network;
            obj.pkt_queue = [obj.pkt_queue; packet];
        end

        function [packet, obj] = removePacketFromQueue(network)
            obj = network;
            packet = obj.pkt_queue(1);
            obj.pkt_queue = obj.pkt_queue(2:end);
        end
    end

    %% PACKET GENERATION
    methods
        % TX
        function obj = generateDiscoveryPacket(network, src_node)
            
            obj = network;
            
            % Increment Source Counter
            obj.NODE(src_node) = obj.NODE(src_node).increment_seq_counter(2);
            
            % Generate Discovery Packet
            tx_pkt = packet();
            tx_pkt = tx_pkt.generateDiscoveryPacket(obj.NODE(src_node).id, ...
                                                    obj.NODE(src_node).routing_table);
            
            % Add packet to Queue
            obj = obj.addPacketToQueue(tx_pkt);
        end

        % RX
        function obj = packetRx(network)
            
            obj = network;

            % Remove last packet from queue
            [rx_pkt, obj] = obj.removePacketFromQueue();

            if(rx_pkt.dest == 255)
                if(rx_pkt.type == 1)
                    obj = obj.decodeDiscoveryPacket(rx_pkt);
                else
                    % decodeBroadcastDataPacket;
                end
            else
                if(rx_pkt.type == 0)
                    % decodeP2pDataPacket;
                end
            end
                    
        end

        % Discovery Packets
        function [obj, updated] = decodeDiscoveryPacket(network, disc_packet)
            
            obj = network;
            
            % For each available node
            for tmp_dest = 1:length(obj.NODE)
            
                % That is different from the transmission node
                if(tmp_dest ~= disc_packet.src)
                    
                    % Get node connection list
                    conn_list = obj.NODE(tmp_dest).connection;

                    % If source node and destination node are connected
                    if(conn_list(disc_packet.src))
                        obj.NODE(tmp_dest) = obj.NODE(tmp_dest).updateRoutingTable(disc_packet.src, disc_packet.data);
                    end
                end
            end
        end
    end


end

