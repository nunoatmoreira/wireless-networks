classdef node
    %NODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id;
        x;
        y;
        %z;
        vx;
        vy;
        %vz;
        frequency;
        sensitivity;
        tx_power;
        range;
        circle_node;
        circle_connection;
        text;
        tx_packet;
        rx_packet;
    end
    
    %% DSDV
    properties
        routing_table = struct('dest', [], 'next_hop', [], ...
                    'distance', [], 'seq', []);
    end
    
    methods
        function obj = node(id, x, y ,options)
            arguments
                id;
                x;
                y;
               options.vx (1,1) = 0;
               options.vy (1,1) = 0;
               options.vz (1,1) = 0;
               options.frequency = 2430;
               options.sensitivity(1,1) = -100.00;
               options.tx_power(1,1) = 35;
            end
                obj.id = id;
               
                obj.x = x;
                obj.y = y;
                
                obj.vx = options.vx;
                obj.vy = options.vy;
                
                obj.frequency = options.frequency;
                obj.sensitivity = options.sensitivity;
                obj.tx_power = options.tx_power;

                %% DSDV
                obj.routing_table.dest = id;
                obj.routing_table.next_hop = id;
                obj.routing_table.distance = 0;
                obj.routing_table.seq = 0;
        end
        
        function obj = setNodePosition(node, x, y, z)
            obj = node;
            obj.x = x;
            obj.y = y;
            obj.z = z;
        end
        
        function obj = setNodeVelocity(node, vx, vy, vz)
            obj = node;
            obj.vx = vx;
            obj.vy = vy;
            obj.vz = vz;
        end
         
        function obj = setNodeAcceleration(ax, ay, az)
            obj.ax = ax;
            obj.ay = ay;
            obj.az = az;
        end           
        
        function obj = setDistances(distances)
            obj.distances = distances;
        end
        
        function obj = setConnections(connections)
            obj.connections = connections; 
        end

        function connections = getConnections(node)
            connections = node.connections;
        end
    end

    %% DSDV
    methods
        function obj = updateDSDVTableEntry(node, dest, next_hop, distance, seq)
            
            route_table = node.routing_table;

            current_dest = route_table.dest;
            
            [log, val] = ismember(dest, current_dest)

            if log == 1
                if route_table(val).seq < seq
                    route_table(val).dest = dest;
                    route_table(val).next_hop = next_hop;
                    route_table(val).distance = distance;
                    route_table(val).seq = seq;
                end
            else
               new_entry.seq = seq;
               new_entry.dest = dest;
               new_entry.next_hop = next_hop;
               new_entry.distance = distance;

               route_table = [route_table; new_entry];
            end
            
            % Sort routing table by distance
            route_table = struct2table(route_table);
            route_table = sortrows(route_table, 'distance');
            route_table = table2struct(route_table);

            node.routing_table = route_table;

            obj = node;

        end
    
        function obj = updateDSDVRemoteTable(node, src_node, remoteTable)
            
            route_table = node.routing_table;
            
            for k = 1:length(remoteTable.dest)
                
                tmp_dest_to_check = remoteTable.dest(k);
                tmp_table = struct2table(route_table);
                tpm_dest_array = tmp_table.dest(:);
                [log,val] = ismember(tmp_dest_to_check,tpm_dest_array);
                
                % If the entry does not exist, add it
                if log == 0
                    new_entry.dest = remoteTable.dest(k);
                    new_entry.next_hop = src_node;
                    new_entry.seq = remoteTable.seq;
                    new_entry.distance = remoteTable.hop + 1;

                    route_table = [route_table; new_entry];

                else
                    
                    % If the entry exists, substitute if the sequence value
                    % is lower than the received one
                    tmp_remote_seq = struct2table(remoteTable);
                    tmp_remote_seq = tmp_remote_seq.seq;
                    tmp_table_seq = tmp_table.seq;

                    if floor(tmp_remote_seq(k)*10) > floor(tmp_table_seq(val)*10)

                        route_table(val,1).dest = remoteTable(k,1).dest;
                        route_table(val,1).next_hop = src_node;
                        route_table(val,1).seq = remoteTable(k,1).seq;
                        route_table(val,1).distance = remoteTable(k,1).hop + 1;

                    % If the entry exists, but the sequence value is the
                    % same, substitute only if the distance is closer than
                    % it was before
                    elseif floor(tmp_remote_seq(k)*10) == floor(tmp_table_seq(val)*10)
                        
                        tmp_table_dist = tmp_table.distance;
                        tmp_remote_dist = struct2table(remoteTable);
                        tmp_remote_dist = tmp_remote_dist.distance;

                        if(tmp_table_dist(val) > tmp_remote_dist(k)+1)
                            route_table(val,1).dest = remoteTable(k,1).dest;
                            route_table(val,1).next_hop = src_node;
                            route_table(val,1).seq = remoteTable(k,1).seq;
                            route_table(val,1).distance = remoteTable(k,1).hop + 1;
                        end
                    end                    
                end
            end

            % Sort routing table by distance
            route_table = struct2table(route_table);
            route_table = sortrows(route_table, 'distance');
            route_table = table2struct(route_table);
            
            node.routing_table = route_table;
            obj = node;
        end
    end
end

