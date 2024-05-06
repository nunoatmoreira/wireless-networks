classdef node
    
    properties
        id;
        connection;
        routing_table = struct("dest", [], "next_hop", [], "cost", [], ...
                                "seq_cnt_id", [], "seq_cnt_val", []);
        pending_discovery;
    end
    
    %% NODES
    methods
        function obj = node(id)
            obj.id = id;
            obj.connection = [];
            obj.routing_table.dest = id;
            obj.routing_table.next_hop = id;
            obj.routing_table.cost = 0;
            obj.routing_table.seq_cnt_id = id;
            obj.routing_table.seq_cnt_val = 0;
            obj.pending_discovery = 1;
        end
        
        function obj = increment_seq_counter(node, increment)
            obj = node;

            obj.routing_table(1).seq_cnt_val = node.routing_table(1).seq_cnt_val + increment;
            
            obj.pending_discovery = 0;
        end

        function obj = updateRoutingTable(node, src, incomingTable)
            
            obj = node;
            
            % Update cost metrics of incoming table
            tmp_table = obj.updateIncomingTable(src, incomingTable);
            
            % Merge node table and updated incoming table
            merge_table = [obj.routing_table; tmp_table];

            % Check for duplicate entries
            resulting_table = obj.removeDuplicates(merge_table);

            % Check if updates were performed
            updated = obj.compareTables(obj.routing_table, resulting_table);

            % Assign pending discovery
            if(updated == 1)
                obj.pending_discovery = 1;
            end

            % Return updated table
            obj.routing_table = resulting_table;

        end

        function updatedTable = updateIncomingTable(~, src, incomingTable)
            
            updatedTable = [];
            
            for k = 1:length(incomingTable)
                
                tmp_entry = incomingTable(k);

                tmp_entry.cost = incomingTable(k).cost + 1;

                if(tmp_entry.cost > 1)
                    tmp_entry.next_hop = src;
                end

                updatedTable = [updatedTable; tmp_entry];
            end
            
        end
    
        function updatedTable = removeDuplicates(~, table)
            
            table_dest_tmp = [];
            for k = 1:length(table)
                table_dest_tmp = [table_dest_tmp table(k).dest];
            end

            % Get the unique values from the table
            uniqueVal = unique(table_dest_tmp);
            
            tmp_table = [];

            % For each unique value
            for k = 1:length(uniqueVal)
                
                % Get the number of repeated values
                num_elem = find(table_dest_tmp == uniqueVal(k));
                
                tmp_tmp_table = [];
                tmp_tmp_seq = [];
                % Create a temporary table with all the repeated entries
                for g = 1:length(num_elem)
                    tmp_tmp_table = [tmp_tmp_table; table(num_elem(g))];
                    tmp_tmp_seq = [tmp_tmp_seq; table(num_elem(g)).seq_cnt_val];
                end

                % Get the maximum sequence counter
                max_seq_cnt = max(tmp_tmp_seq);

                % Get all the entries with the maximum sequence number
                num_elem = find(tmp_tmp_seq+1 == max_seq_cnt+1);

                tmp_tmp_tmp_table = [];
                tmp_tmp_tmp_cost = [];
                % Create a temporary table with all the repeated entries
                for g = 1:length(num_elem)
                    tmp_tmp_tmp_table = [tmp_tmp_tmp_table; tmp_tmp_table(g)];
                    tmp_tmp_tmp_cost = [tmp_tmp_tmp_cost; tmp_tmp_table(g).cost];
                end

                % Get the minimum cost
                [~, idx] = min(tmp_tmp_tmp_cost);

                % Update table
                tmp_table = [tmp_table; tmp_tmp_tmp_table(idx)];
            end

            updatedTable = tmp_table;
        end
    
        function updatedFlag = compareTables(~, old, new)
            
            updatedFlag = 0;

            if(length(old) ~= length(new))
                updatedFlag = 1;
            else
                old_next = old.next;
                new_next = new.next;

                if(~isequal(old_next, new_next))
                    updatedFlag = 1;
                else
                    old_cost = old.cost;
                    new_cost = new.cost;

                    if(~isequal(old_cost, new_cost))
                        updatedFlag = 1;
                    end
                end
            end
            
        end
    end

end

