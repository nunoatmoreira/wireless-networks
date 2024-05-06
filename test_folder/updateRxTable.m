function [updated_table, genPkt] = updateRxTable(src_table, src, incoming_table)
    
    len = length(incoming_table(:,1));

    for k = 1:len
        
        incoming_table(k,3) = string(double(incoming_table(k,3)) + 1);
        
        if(double(incoming_table(k,3)) > 1)
            incoming_table(k,2) = src;
        end
    end

    tmp_table = [src_table; incoming_table];
    
    %% Remove duplicates
    len = length(tmp_table(:,1));

    for k = 1:len
        
        dest = tmp_table(k,1);

        for g = 2:len

            dest2com = tmp_table(g,1);

            if(strcmp(dest, dest2com) == 1)
                
            end

        end
    end

    %% Immediate response
    dest_origin = src_table(:,1);
    dest_final = tmp_table(:,1);

    metric_origin = src_table(:,3);
    metric_final = tmp_table(:,3);

    if(strcmp(dest_origin, dest_final) == 0 || strcmp(metric_origin, metric_final) == 0)
        genPkt = 1;
    else
        genPkt = 0;
    end

    updated_table = tmp_table;
end

