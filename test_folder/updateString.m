function updatedString = updateString(strToUpdate, increment)

    A = char(strToUpdate);
    
    B1 = A(1:2);
    B2 = A(3:end);
    
    C = string(B2);

    D = str2double(C);

    E = D + increment;

    F = string(B1);
    G = sprintf("%03d", E);

    updatedString = append(F, G);
    
end