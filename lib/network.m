classdef network
    %NETWORK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       tx_packet;
       rx_packet;
    end
    
    methods (Access = private)
        
        function distance = netGetDistance(network, node_src, node_dest)
            
            x_src = node_src.x;
            y_src = node_src.y;

            x_dest = node_dest.x;
            y_dest = node_dest.y;

            distance = sqrt((x_src+x_dest)^2 + (y_src + y_dest)^2);
        end

        function link_budget = netGetLinkBudget(network, node_src, node_dest)
            
            % Get Tx Power from source node
            tx_power = node_src.tx_power;
            
            % Get Tx Frequency from source node
            freq = node_src.frequency;
            
            % Compute the distance between two nodes
            distance = network.netGetDistance(node_src, node_dest);
            
            % Get the link loss between each node
            link_loss = friis(freq, distance);
            
            % Compute the link budget
            link_budget = tx_power - link_loss;
        end

        function hasConn = netGetConnection(network, node_src, node_dest)
            
            % Compute the link budget
            link_budget = network.netGetLinkBudget(node_src, node_dest);

            % If the link budget is above the destination sensitivity
            if link_budget > node_dest.sensitivity
                hasConn = 1; % Link may be established
            else
                hasConn = 0;
            end

        end

        function delay = netGetPropDelay(network, node_src, node_dest)
            
            % Compute the distance between two nodes
            distance = network.netGetDistance(node_src, node_dest);

            % Get the delay
            delay = distance / 299792.458;
        end
    end

    methods (Access = public)
        
        function obj = network()
            obj.tx_packet;
            obj.rx_packet;
        end

        function [obj, updated_node] = genTxPackets(network, node_list, sim_time)
            
            % Get number of nodes in the network
            n_nodes = length(node_list);
            
            % Get the source node
            src = randi([1 n_nodes], 1, 1);
            node = node_list(src);

            % Get number of sent packets
            tx_packet_list = node.tx_packet;

            if isempty(tx_packet_list)
                pkt_id = 1;
            else
                pkt_id = node.tx_packet(end).pkt_id + 1;
            end

            % Get the node routing table
            route_table = node_list(src).routing_table;

            if mod(pkt_id,6) == 1
                % Send discovery route
                tx_packet = packet;

                % Update routing table with sequence
                node_list(src).routing_table.seq = sim_time;

                tx_packet = tx_packet.genDiscPacket(src, sim_time, pkt_id, node_list(src).routing_table);
            else
                % Send data packet
                
                % Set the node destination
                dest = src;
                
                % Possible destinations
                possible_dest = route_table.dest;
                while dest == src
                    dest = randi([1 length(possible_dest)], 1, 1);
                    dest = possible_dest(dest);
                end

                tx_packet = genDataPacket(src, sim_time, pkt_id, dest, []);
            end
            
            tx_packet_list = network.tx_packet;
            tx_packet_list = [tx_packet_list  tx_packet];
            network.tx_packet = tx_packet_list;
            obj = network;
            updated_node = node_list;
        end
    
        function obj = rxPacket(network, node_list, sim_time)
            
            % Get number of nodes
            n_nodes = length(node_list);

            % Get the oldest packet in the network
            tx_packet = network.tx_packet(1);

            if ~isempty(tx_packet)
                
                src = tx_packet.src;
                % For each node
                for id_dest=1:n_nodes
                    
                    if id_dest ~= src
                        
                        node_src = node_list(src);
                        node_dest = node_list(id_dest);

                        hasConn = network.netGetConnection(node_src, node_dest);
                        
                        if(hasConn == 1)
                            rx_time = tx_packet.tx_time + network.netGetPropDelay(node_src, node_dest);
                        end

                        if (tx_packet.dest == 255)

                            % UPDATE DESTINATION NODE TABLE
                            node_dest = node_dest.updateDSDVTableEntry(tx_packet.src, ...
                                 tx_packet.src, 1, tx_packet.data.seq);
                            node_dest = node_dest.updateDSDVRemoteTable(tx_packet.src, tx_packet.data);

                            % SENDS DISCOVER PACKET
                            src = node_dest.id;
                            
                            % Get number of sent packets
                            tx_packet_list = node_dest.tx_packet;
                        
                            if isempty(tx_packet_list)
                                pkt_id = 1;
                            else
                                pkt_id = node.tx_packet(end).pkt_id + 1;
                            end
                            
                            tx_packet = packet;
                            tx_packet = tx_packet.genDiscPacket(src, sim_time, pkt_id, node_list(src).routing_table);
                            
                            network.tx_packet = [network.tx_packet; tx_packet];

                        else
                            
                            % RECEIVE AND POSSIBLE FORWARD DATA PACKET

                        end

                    end
                end
                
                len = length(network.tx_packet);
                if(len > 1)
                    network.tx_packet = network.tx_packet(2:end);
                else
                    network.tx_packet = [];
                end
            end

            obj = network;
        end
    end
end

