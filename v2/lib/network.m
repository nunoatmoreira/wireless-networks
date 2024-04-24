classdef network
    %NETWORK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       tx_packet;
       rx_packet;
       search_period = 6;
    end
    
    %% PRIVATE UTILITIES
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

    %% TX PRIVATE
    methods (Access = private)
        
        % Define a random node to send a packet
        function src_node = getRandomSourceNode(~, node_list)
            % Get number of nodes
            n_nodes = length(node_list);

            % Get the source node
            src = randi([1 n_nodes], 1, 1);

            % Return source node id
            src_node = node_list(src).id;

        end
        
        % Get the route table of a given node
        function route_table = getNodeRoutingTable(~, node)
            route_table = node.routing_table;
        end
    
        % Define a random destination node
        function dest_node = getRandomDestNode(network, ...
                                               src_node, ...
                                               node_list, ...
                                               sim_time)
            
            % Get Routing Table of Source Node
            route_table = network.getNodeRoutingTable(node_list(src_node));
            
            % Get the number of nodes
            n_nodes = length(node_list);

            % Generate random destination address
            dest = randi([1 n_nodes], 1, 1);

            if ~ismember(dest, route_table.dest)
                dest_node = 255;
            else
                if mod(round(sim_time), network.search_period) == 1
                    dest_node = 255;
                else
                    if dest == src_node
                        dest_node = 255;
                    else
                        dest_node = dest;
                    end
                end
            end
        end
        
        % Get Packet ID
        function pkt_id = getPktId(~, src_node, node_list)
            
            % Get the list of packets already transmitted
            tx_packet_table = node_list(src_node).tx_packet;
            
            % Compute packet_id
            if isempty(tx_packet_table)
                % Initialize Pkt Id
                pkt_id = [src_node 1];
            else
                % Get the last transmitted packet
                tx_packet_last = tx_packet_table(end);

                % Compute next pkt ID
                pkt_id = [src_node tx_packet_last.pkt_id(2)+1];
            end
        end

        % Generate TX packet
        function updated_network = getTxPacket(network, ...
                                               src_node, ...
                                               dest_node, ...
                                               node_list, ... 
                                               sim_time)
            
            % Initialization
            this.tx_packet = packet;
            
            % Get packet ID
            pkt_id = network.getPktId(src_node, node_list);

            if dest_node == 255
                data = network.getNodeRoutingTable(node_list(src_node));

                this.tx_packet = this.tx_packet.genDiscPacket(src_node, ...
                                                              sim_time, ...
                                                              pkt_id, ...
                                                              data);
            else
                data = [];

                this.tx_packet = this.tx_packet.genDataPacket(src_node, ...
                                                              sim_time, ...
                                                              dest_node, ...
                                                              data);
            end
            
            % Update network argument
            network.tx_packet = [network.tx_packet this.tx_packet];
               
            % Return updated network class
            updated_network = network;
        end
    
        % Add TX packet to node list
        function updated_node_list = addTxPacketToNode(network, ...
                                                       src_node, ...
                                                       node_list)
            
            % Get last packet in the network
            last_packet = network.tx_packet(end);
            
            % Get list of transmitted packets by the source node
            list_tx_packet = node_list(src_node).tx_packet;

            % Update list of Tx packets
            list_tx_packet = [list_tx_packet; last_packet];

            % Update node
            node_list(src_node).tx_packet = list_tx_packet;

            % Return node lsit
            updated_node_list = node_list; 
        end
    end

    %% TX PUBLIC
    methods (Access = public)

        function [updated_net, updated_node] = genTxPackets(network, ...
                                                            node_list, ...
                                                            sim_time)
            
            % Get source node
            src_node = network.getRandomSourceNode(node_list);
            
            % Get destination node
            dest_node = network.getRandomDestNode(src_node, ...
                                                  node_list, ...
                                                  sim_time);

            % Generate Data Packet or Discovery Packet based on destination
            % address
            network = network.getTxPacket(src_node, ...
                                          dest_node, ...
                                          node_list, ...
                                          sim_time);

            % Update node list with the Tx Packet
            node_list = network.addTxPacketToNode(src_node, node_list);

            % Return values
            updated_net = network;
            updated_node = node_list;
        end
    end

    methods (Access = public)
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
                            tmp_rx_time = tx_packet;
                            tmp_rx_time.rx_time = rx_time;
                            node_dest.rx_packet = [node_dest.rx_packet tmp_rx_time];
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
                        
                            pkt_id = rx_time;

                            % if isempty(tx_packet_list)
                            %     pkt_id = 1;
                            % else
                            %     pkt_id = node.tx_packet(end).pkt_id + 1;
                            % end
                            
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

