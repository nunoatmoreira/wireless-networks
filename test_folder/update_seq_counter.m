function updated_table = update_seq_counter(table, increment)
    
    tmp_table = table;
    
    tmp_table = tmp_table(1,4);

    tmp_seq_counter = updateString(tmp_table, increment);

    updated_table = table;

    updated_table(1,4) = tmp_seq_counter;
end

