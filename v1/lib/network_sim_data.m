classdef network_sim_data
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        packet_queue = [];
        tx_packets = [0 0];
        tx_p2p = [0 0];
        tx_broad = [0 0];
        rx_packets = [0 0];
        rx_p2p = [0 0];
        rx_broad = [0 0];
        drop_packets = [0  0];
    end
   
    %% CONSTRUCTOR
    methods (Access = public)

        function obj = network_sim_data()

        end
    end

    %% PRIVATE METHODS
    methods (Access = private)
        %% TX
        % Add Tx Packet to Queue Monitor Data
        function obj = addPacketQueueSimData(network_sim_data, packet)

            obj = network_sim_data;

            obj.packet_queue = [obj.packet_queue; packet];
        end

        % Add Tx Packet Monitor Data
        function obj = addTxPacketSimData(network_sim_data, sim_time)
            
            obj = network_sim_data;
        
            if ~isempty(network_sim_data.tx_packets)
                last_val = network_sim_data.tx_packets(end,2);
    
                new_entry = [sim_time last_val+1];
            else
                new_entry = [sim_time 1];
            end

            obj.tx_packets = [network_sim_data.tx_packets; new_entry];
        end

        % Add P2P Tx Packet Monitor Data
        function obj = addP2pTxPacketSimData(network_sim_data, sim_time)
            
            obj = network_sim_data;

            if ~isempty(network_sim_data.tx_p2p)
                last_val = network_sim_data.tx_p2p(end,2);
    
                new_entry = [sim_time last_val+1];
            else
                new_entry = [sim_time 1];
            end


            obj.tx_p2p = [network_sim_data.tx_p2p; new_entry];
        end

        % Add Broadcast Tx Packet Monitor Data
        function obj = addBroadcastTxPacketSimData(network_sim_data, sim_time)
            
            obj = network_sim_data;
            
            if ~isempty(network_sim_data.tx_broad)
                last_val = network_sim_data.tx_broad(end,2);
    
                new_entry = [sim_time last_val+1];
            else
                new_entry = [sim_time 1];
            end

            obj.tx_broad = [network_sim_data.tx_broad; new_entry];
        end
                
        %% RX
        % Add Rx Packet Monitor Data
        function obj = addRxPacketSimData(network_sim_data, sim_time)
            
            obj = network_sim_data;

            if ~isempty(network_sim_data.rx_packets)
                last_val = network_sim_data.rx_packets(end,2);
    
                new_entry = [sim_time last_val+1];
            else
                new_entry = [sim_time 1];
            end

            obj.rx_packets = [network_sim_data.rx_packets; new_entry];
        end

        % Add P2P Rx Packet Monitor Data
        function obj = addP2pRxPacketSimData(network_sim_data, sim_time)
            
            obj = network_sim_data;

            if ~isempty(network_sim_data.rx_p2p)
                last_val = network_sim_data.rx_p2p(end,2);
    
                new_entry = [sim_time last_val+1];
            else
                new_entry = [sim_time 1];
            end

            obj.rx_p2p = [network_sim_data.rx_p2p; new_entry];
        end

        % Add Broadcast Rx Packet Monitor Data
        function obj = addBroadcastRxPacketSimData(network_sim_data, sim_time)
            
            obj = network_sim_data;
           
            if ~isempty(network_sim_data.rx_broad)
                last_val = network_sim_data.rx_broad(end,2);
    
                new_entry = [sim_time last_val+1];
            else
                new_entry = [sim_time 1];
            end

            obj.rx_broad = [network_sim_data.rx_broad; new_entry];
        end

        %% DROPPED
        % Add Dropped Packet Monitor Data
        function obj = addDropPacketSimData(network_sim_data, sim_time)
            
            obj = network_sim_data;
                       
            if ~isempty(network_sim_data.drop_packets)
                last_val = network_sim_data.drop_packets(end,2);
    
                new_entry = [sim_time last_val+1];
            else
                new_entry = [sim_time 1];
            end

            obj.drop_packets = [network_sim_data.drop_packets; new_entry];
        end

    end

    %% RX
    methods (Access = public)

        function obj = rxBroadcastPacketMonitor(network_sim_data, sim_time, rcv_flg)

            obj = network_sim_data;

            if(rcv_flg)
                obj = obj.addBroadcastRxPacketSimData(sim_time);
                obj = obj.addRxPacketSimData(sim_time);
            else
                obj = network_sim_data.addDropPacketSimData(sim_time);
            end

        end

        function obj = rxP2pPacketMonitor(network_sim_data, sim_time, rcv_flg)
            
            obj = network_sim_data;

            if(rcv_flg)
                obj = obj.addP2pRxPacketSimData(sim_time);
                obj = obj.addRxPacketSimData(sim_time);
            else
                obj = network_sim_data.addDropPacketSimData(sim_time);
            end

        end
    
    end

    %% TX
    methods (Access = public)
        
        function obj = packetQueueMonitor(network_sim_data, packet)
        
            obj = network_sim_data;

            obj = obj.addPacketQueueSimData(packet);
            
        end

        function obj = txPacketMonitor(newtork_sim_data, sim_time, dest_add)

            obj = newtork_sim_data;
            
            obj = obj.addTxPacketSimData(sim_time);

            if(dest_add == 255)
                obj = obj.addBroadcastTxPacketSimData(sim_time);
            else
                obj = obj.addP2pTxPacketSimData(sim_time);
            end

        end
    end
end

