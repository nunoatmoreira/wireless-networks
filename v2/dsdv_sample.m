% Define parameters
numNodes = 5;
numIterations = 20;
updateInterval = 3; % Interval for routing table updates

% Initialize nodes
for i = 1:numNodes
    nodes(i).ID = i;
    nodes(i).routingTable = []; % Initialize routing table
    nodes(i).sequenceNumbers = zeros(1, numNodes); % Initialize sequence numbers
    % Initialize neighbors (define your own network topology)
    nodes(i).neighbors = setdiff(1:numNodes, i); % All nodes are neighbors initially
end

% Main simulation loop
for iter = 1:numIterations
    % Periodic routing table updates
    if mod(iter, updateInterval) == 1
        for i = 1:numNodes
            % Broadcast routing table to neighbors
            broadcastRoutingTable(nodes(i));
        end
    end
    
    % Routing table maintenance (upon receiving updates)
    for i = 1:numNodes
        % Receive updates from neighbors
        receiveUpdates(nodes(i));
        % Update routing table based on received updates
        updateRoutingTable(nodes(i));
    end
    
    % Display routing tables (optional)
    dispRoutingTables(nodes);
end

% Functions
function broadcastRoutingTable(node)
    % Broadcast routing table to neighbors
    for neighborID = node.neighbors
        neighborNode = getNodeByID(neighborID);
        % Simulate broadcast transmission (you may implement your own communication model)
        % For simplicity, we'll just update the neighbor's routing table directly
        neighborNode.routingTable = node.routingTable;
    end
end

function receiveUpdates(node)
    % Receive updates from neighbors
    for neighborID = node.neighbors
        neighborNode = getNodeByID(neighborID);
        % Simulate receiving updates (you may implement your own communication model)
        % For simplicity, we'll assume the neighbor's routing table is directly accessible
        if ~isempty(neighborNode.routingTable)
            % Update sequence numbers for received routes
            for j = 1:length(neighborNode.routingTable)
                destID = neighborNode.routingTable(j).destination;
                neighborSeqNum = neighborNode.sequenceNumbers(destID);
                if neighborSeqNum > node.sequenceNumbers(destID)
                    node.sequenceNumbers(destID) = neighborSeqNum;
                end
            end
        end
    end
end

function updateRoutingTable(node)
    % Update routing table based on received updates
    for neighborID = node.neighbors
        neighborNode = getNodeByID(neighborID);
        if ~isempty(neighborNode.routingTable)
            for j = 1:length(neighborNode.routingTable)
                destID = neighborNode.routingTable(j).destination;
                neighborSeqNum = neighborNode.sequenceNumbers(destID);
                if neighborSeqNum > node.sequenceNumbers(destID)
                    % Update routing table entry
                    node.routingTable(destID) = neighborNode.routingTable(j);
                    % Update sequence number
                    node.sequenceNumbers(destID) = neighborSeqNum;
                end
            end
        end
    end
end

function node = getNodeByID(nodeID)
    % Helper function to retrieve a node by its ID
    global nodes;
    for i = 1:length(nodes)
        if nodes(i).ID == nodeID
            node = nodes(i);
            return;
        end
    end
    node = [];
end

function dispRoutingTables(nodes)
    % Display routing tables for all nodes
    for i = 1:length(nodes)
        disp(['Node ', num2str(nodes(i).ID), ' Routing Table:']);
        disp(nodes(i).routingTable);
        disp(' ');
    end
end
