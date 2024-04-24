function link_loss = friis(frequency, distance)

    % Frequency in MHz
    % Distance is in km
    % Link loss in dB
    link_loss = 32.45 + 20*log10(frequency) + 20*log10(distance);
end

