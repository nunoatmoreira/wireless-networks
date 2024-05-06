function pkt = create_discovery_packet(src, dest, table)

    if(dest == 255)
        pkt.src = src;
        pkt.dest = dest;
        
        pkt.data = table;
    end

end