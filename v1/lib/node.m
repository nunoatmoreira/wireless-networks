classdef node
    
    %% ADDRESS
    properties
        id;
    end

    %% POSITION
    properties
        x;
        y;
        %z;
    end

    %% VELOCITY
    properties
        vx;
        vy;
        %vz;
    end
    
    %% RF CONFIGURATIONS
    properties 
        frequency;
        sensitivity;
        tx_power;
        range;
    end

    %% GRAPHICAL PROPERITES
    properties 
        circle_node;
        circle_connection;
        text;
    end
    
    %% TRAFFIC PROPERTIES
    properties
        tx_packet;
        rx_packet;
    end

    %% INITIALIZATION METHODS
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

                obj.tx_packet = [];
                obj.rx_packet = [];
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
             
    end

    %% TRAFFIC METHODS
    methods
        function updated_node = addTxPacket(node, tx_packet)
            
            % Get list of Transmitted Packets
            tx_list = node.tx_packet;

            % Add packet to the list
            tx_list = [tx_list; tx_packet];

            % Sort list
            tx_list = node.sortPacketList(tx_list);

            % Return node object
            updated_node = node;
            updated_node.tx_packet = tx_list;

        end
    end

    methods (Access = private)
        function updated_list = sortPacketList(~, list)
            
            ts = zeros(1, length(list));

            for k = 1:length(ts)
                ts(k) = list(k).timestamp;
            end

            new_list = [];

            for k = 1:length(list)
                [~, idx] = min(ts);
                
                new_list = [new_list; list(idx)];

                ts = [ts(1:idx-1) ts(idx+1:end)];
                list = [list(1:idx-1) list(idx+1:end)];
            end

            updated_list = new_list;
        end
    end

end

