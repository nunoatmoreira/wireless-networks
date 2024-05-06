% DSDV Algorithm Implementation in MATLAB

% Initialize network
NETWORK = network();

% Initialize the network topology
numNodes = 3; % Number of nodes in the network

for k = 1:numNodes
    NODE = node(k);
    NETWORK = NETWORK.addNode(NODE);
end

NETWORK.NODE(1).connection = [0 1 0];
NETWORK.NODE(2).connection = [1 0 1];
NETWORK.NODE(3).connection = [0 1 0];

% Define the initial node
first_node = 1;
 
pkt_queue = [];
 
%% Generate the First Packet
NETWORK = NETWORK.generateDiscoveryPacket(first_node);


%% Receive Packet
NETWORK = NETWORK.packetRx();