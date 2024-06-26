classdef network
    
    properties (Access = public)
        node_list;
        packet_queue;
        sim_data;
    end

    properties (Access = private)
        broadcast_add = 255;
    end

    %% INITIALIZE
    methods (Access = public)
        
        function obj = network(node_list)
            obj.node_list = node_list;
            obj.packet_queue = [];
            obj.sim_data = network_sim_data;
        end
        
    end

    %% GENERATE TRAFFIC
    methods (Access = public)
        
        %% TX
        function updated_net = generateTxPackets(network, sim_time, data)

            % Get source node address
            src_add = network.getRandomSourceNode();
            
            % Get destination node address
            dest_add = network.getRandomDestNode(src_add);
            
            % Get packet id
            pkt_id = network.getPktId(src_add);

            % Get packet type 
            pkt_type = network.getPktType(dest_add);

            % Set Packet data
            pkt_data = data;

            % Generate Tx Packet
            tx_packet = createPacket(packet, sim_time, src_add, dest_add, pkt_id, pkt_type, pkt_data);

            % Add packet to packet queue
            updated_net = network.addPacketToQueue(tx_packet);

            % Monitor Data
            sim = updated_net.sim_data;
            updated_net.sim_data = sim.txPacketMonitor(sim_time, dest_add);
            sim = updated_net.sim_data;
            updated_net.sim_data = sim.packetQueueMonitor(tx_packet);

        end

        %% RX
        function updated_net = getRxPackets(network, sim_time)
            
            % Initialize return class
            updated_net = network;

            % Get the first Tx Packet from queue
            rx_packet = network.packet_queue(1);
            
            % Get the packet source
            src_add = rx_packet.getPacketSrc();
            
            % Get the packet destination
            dest_add = rx_packet.getPacketDest();
            
            if(dest_add == 255)
                
                % Get the node list
                node_list = network.node_list;

                % Get the number of nodes
                n_nodes = length(node_list);
                
                % Received flag 
                rcv_flg = 0;

                for dest = 1:n_nodes
                    
                    if dest ~= src_add

                        [updated_net, tmp_rcv_flg] = updated_net.rxPacketRoutine(src_add, dest, rx_packet);
                        
                        rcv_flg = rcv_flg + tmp_rcv_flg;

                    end
                end
                
                % Monitor Data
                sim = network.sim_data;
                sim = sim.rxBroadcastPacketMonitor(sim_time, rcv_flg);
            else
                [updated_net, rcv_flg] = updated_net.rxPacketRoutine(src_add, dest_add, rx_packet);

                % Monitor Data
                sim = updated_net.sim_data;
                sim = sim.rxP2pPacketMonitor(sim_time, rcv_flg);
            end
            

            % Remove Packet from TX Queue
            if(length(updated_net.packet_queue) == 1)
                updated_net.packet_queue = []; 
            else
                updated_net.packet_queue = updated_net.packet_queue(2:end);  
            end

            % Update Monitor Data
            updated_net.sim_data = sim;
        end

    end

    %% QUEUE METHODS
    methods (Access = private)
       
        % Add packet to Network Queue
        function updated_net = addPacketToQueue(network, packet)

            % Get the current queue
            pkt_queue = network.packet_queue;

            % Add packet to the queue
            pkt_queue = [pkt_queue; packet];

            % Sort packet_queue
            pkt_queue = network.sortPacketQueue(pkt_queue);

            % Update transimtter node
            this.node_list = network.addPacketToTxNode(packet);

            % Return updated network
            updated_net = network;
            updated_net.node_list = this.node_list;
            updated_net.packet_queue = pkt_queue;

        end
        
        % Add Packet to Transmitter Node
        function updated_node_list = addPacketToTxNode(network, packet)

            % Get node list
            this.node_list = network.node_list;

            % Get source Address
            src_add = packet.getPacketSrc();
        
            % Get node
            node = this.node_list(src_add);

            % Add packet to node
            updated_node = node.addTxPacket(packet);

            % Return node list
            updated_node_list = this.node_list;
            updated_node_list(src_add) = updated_node;

        end
        
        % Add Packet to Receiver Node
        function updated_net = addPacketToRxNode(network, dest_add, packet)

            % Get node list
            this.node_list = network.node_list;

            % Get Rx node
            node = this.node_list(dest_add);

            % Add packet to node
            updated_node = node.addRxPacket(packet);

            % Return updated network
            updated_net = network;
            updated_net.node_list(dest_add) = updated_node;

        end

        % Sort network queue by timestamp
        function updated_queue = sortPacketQueue(~, pkt_queue)
            
            ts = zeros(1, length(pkt_queue));
            
            for k = 1:length(ts)
                ts(k) = pkt_queue(k).timestamp;
            end
            
            new_queue = [];

            for k = 1:length(pkt_queue)
                [~, idx] = min(ts);
                
                new_queue = [new_queue; pkt_queue(idx)];

                ts = [ts(1:idx-1) ts(idx+1:end)];
                pkt_queue = [pkt_queue(1:idx-1) pkt_queue(idx+1:end)];
            end

            updated_queue = new_queue;

        end
    end

    %% PRIVATE UTILITIES
    methods (Access = private)
        
        function distance = netGetDistance(network, node_src, node_dest)
            
            x_src = node_src.x;
            y_src = node_src.y;

            x_dest = node_dest.x;
            y_dest = node_dest.y;

            distance = sqrt((x_src - x_dest)^2 + (y_src - y_dest)^2);
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
        function src_add = getRandomSourceNode(network)
            % Get number of nodes
            n_nodes = length(network.node_list);

            % Get the source node
            src = randi([1 n_nodes], 1, 1);

            % Return source node id
            src_add = network.node_list(src).id;
        end

        % Define a random destination node
        function dest_add = getRandomDestNode(network, src_add)
                        
            % Get the number of nodes
            n_nodes = length(network.node_list);
            
            % Generate random destination address
            dest = randi([1 n_nodes], 1, 1);
            
            % If the destination node is equal to source node
            if dest == src_add
                dest_add = network.broadcast_add;
            else
                dest_add = network.node_list(dest).id;
            end

        end
        
        % Get Packet ID
        function pkt_id = getPktId(network, src_add)

            % Get the node list
            this.node_list = network.node_list;
            
            % Get the list of packets already transmitted
            tx_packet_table = this.node_list(src_add).tx_packet;
            
            % Compute packet_id
            if isempty(tx_packet_table)
                % Initialize Pkt Id
                pkt_id = [src_add 1];
            else
                % Get the last transmitted packet
                tx_packet_last = tx_packet_table(end);

                % Compute next pkt ID
                pkt_id = [src_add tx_packet_last.header.pkt_id(2)+1];
            end
        end
        
        % Get Packet Type
        % pkt_type = 0 -> Data
        % pkt_type = 1 -> Discovery
        function pkt_type = getPktType(network, dest_add)
            
            if(dest_add == network.broadcast_add)
                pkt_type = randi([0 1], 1, 1);
            else
                pkt_type = 0;
            end

        end
    end
    
    %% RX PRIVATE
    methods (Access = private)
        
        function [updated_net, rx_flg] = rxPacketRoutine(network, src_add, dest_add, rx_packet)
            
            % Initialize return values
            rx_flg = 0;
            updated_net = network;

            % Get the source node
            node_src = network.node_list(src_add);

            % Get the destination node
            node_dest = network.node_list(dest_add);

            % Check if there are connection between nodes
            connection = network.netGetConnection(node_src, node_dest);

            if(connection == 1)
                % Timestamp
                rx_packet.timestamp = rx_packet.timestamp + network.netGetPropDelay(node_src, node_dest);

                % Add RX packet to the destination node
                updated_net = network.addPacketToRxNode(dest_add, rx_packet);
                
                % Add received packets
                rx_flg = 1;
            else
                % Add dropped packets
                rx_flg = 0;
            end

        end
    end
end

