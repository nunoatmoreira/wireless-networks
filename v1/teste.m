clc
clear all

addpath("lib/")

NETWORK = network;

NODE_LIST = node(1, 1, 1);
NODE_LIST = [NODE_LIST node(2, 3, 5)];

[NETWORK, NODE_LIST] = NETWORK.genTxPackets(NODE_LIST,1)

NETWORK = NETWORK.rxPacket(NODE_LIST,1)

%% TEST TX PRIVATE
for d = 1
    clear all;
    clc
    
    MAX_NODES = 2;
    
    % Generate random nodes
    NODE_LIST = [];
    for k = 1:MAX_NODES
    
        x = randi([1 5], 1, 1);
        y = randi([1 5], 1, 1);
        
        NODE_LIST = [NODE_LIST node(k, x, y)];
    end
    
    % Create Network 
    NETWORK = network;
    
    % Get source nodes
    src_nodes = [];
    for k = 1:10
        src_nodes = [src_nodes; NETWORK.getRandomSourceNode(NODE_LIST)];
    end
    
    % Get Routing Tables
    route_table = [];
    for k = 1:10
        tmp_node_id = src_nodes(k);
        
        tmp_node = NODE_LIST(tmp_node_id);
        
        tmp_route_table = NETWORK.getNodeRoutingTable(tmp_node);
    
        route_table = [route_table tmp_route_table];
    end
    
    % Get Destination Node
    dest_node = [];
    for k = 1:10
        
        tmp_sim_time = k;
        
        tmp_sorce_node = src_nodes(k);
    
        tmp_dest_node = NETWORK.getRandomDestNode(tmp_sorce_node, ...
                                                  NODE_LIST, tmp_sim_time);
    
        dest_node = [dest_node; tmp_dest_node];
    end
    
    % Get Pkt Id
    pkt_id = [];
    for k = 1:10
        tmp_node_id = src_nodes(k);
        
       pkt_id = [pkt_id; NETWORK.getPktId(tmp_node_id, NODE_LIST)]; 
    end
    
    % Generate TX Packet
    for k = 1:10
        
        tmp_sim_time = k;
    
        tmp_src_node = src_nodes(k);
        
        tmp_dest_node = dest_node(k);
    
        NETWORK = NETWORK.getTxPacket(tmp_src_node, ...
                                      tmp_dest_node, ...
                                      NODE_LIST, ...
                                      tmp_sim_time);
    end
    
    % Add Tx Packet to node list
    for k = 1:10
    
    tmp_src_node = src_nodes(k);

    NODE_LIST = NETWORK.addTxPacketToNode(tmp_src_node, ...
                                          NODE_LIST);
end
end

%% TEST TX PUBLIC
% GEN TX PACKET
for d = 1
    clear all;
    clc
    
    MAX_NODES = 2;
    
    % Generate random nodes
    NODE_LIST = [];
    for k = 1:MAX_NODES
    
        x = randi([1 5], 1, 1);
        y = randi([1 5], 1, 1);
        
        NODE_LIST = [NODE_LIST node(k, x, y)];
    end
    
    % Create Network 
    NETWORK = network;

    for k = 1:10

        tmp_sim_time = k;

        [NETWORK, NODE_LIST] = NETWORK.genTxPackets(NODE_LIST, ...
                                                    tmp_sim_time);
    end


end

%% TEST RX PRIVATE
for d = 1
    clear all;
    clc
    
    MAX_NODES = 2;
    
    % Generate random nodes
    NODE_LIST = [];
    for k = 1:MAX_NODES
    
        x = randi([1 5], 1, 1);
        y = randi([1 5], 1, 1);
        
        NODE_LIST = [NODE_LIST node(k, x, y)];
    end
    
    % Create Network 
    NETWORK = network;

    % Create TX Packet
    [NETWORK, NODE_LIST] = NETWORK.genTxPackets(NODE_LIST, 1);

    % Receive RX Packet
    [NETWORK, NODE_LIST] = NETWORK.getRxPackets(NODE_LIST, 1);

end


%% TEST QUEUE
s.a.b = 1;
s.a.c = 2;
s.d = 3;

d.a.b = 3;
d.a.c = 5;
d.d = 1;

st = [s; d];

st = struct2table(st);

%% TEST TX
NODE = node(1,2,3);
NODE_2 = node(2,3,4);

NODE = [NODE; NODE_2];

NETWORK = network(NODE);

NETWORK = NETWORK.generateTxPackets(1,[1]);
NETWORK = NETWORK.generateTxPackets(1.2,[2]);
NETWORK = NETWORK.generateTxPackets(0.1,[3]);
NETWORK = NETWORK.generateTxPackets(0.1,[3]);


clear k x y d tmp* 