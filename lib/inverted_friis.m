function distance = inverted_friis(frequency, link_loss)

    % Frequency in MHz
    % Distance is in km
    % Link loss in dB
    distance = 10^((link_loss - 20*log10(frequency) - 32.45)/20);
end