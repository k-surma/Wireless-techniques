% Parametry
Pt_dBm = 10 * log10(5e-3);  % Moc nadajnika w dBm
f = 3.6e9;  % Częstotliwość w Hz
c = 3e8;    % Prędkość światła w m/s

% Współrzędne nadajnika
tx_x = 12.05;
tx_y = 7.05;

% Współczynnik odbicia ścian
odbicie = 0.7;

% Siatka punktów odbiornika
[wspX, wspY] = meshgrid(0:0.1:16, 0:0.1:28);

% Zainicjalizowanie macierzy do przechowywania mocy sygnału
signal_power = zeros(size(wspX));

% Obliczanie mocy sygnału dla każdego punktu odbiornika
for i = 1:size(wspX, 1)
    for j = 1:size(wspX, 2)
        % Współrzędne punktu odbiornika
        rx_x = wspX(i, j);
        rx_y = wspY(i, j);
        
        % Sprawdzanie warunku LOS (czy linia przechodzi przez ścianę działową)
        if dwawektory(tx_x, tx_y, rx_x, rx_y, 0, 20.05, 16, 20.05) == -1 || ...
           dwawektory(tx_x, tx_y, rx_x, rx_y, 10, 20.05, 13, 20.05) == 1
            % Oblicz odległość nadajnik - odbiornik
            d = sqrt((rx_x - tx_x)^2 + (rx_y - tx_y)^2);
            
            % Oblicz tłumienie w wolnej przestrzeni
            PL = 20*log10(d) + 20*log10(f) + 20*log10(4*pi/c);
            
            % Moc odbierana
            signal_power(i, j) = Pt_dBm - PL;
        else
            % Jeżeli LOS jest blokowany, moc sygnału jest bardzo niska
            signal_power(i, j) = -100;  % np. bardzo niski poziom mocy
        end
    end
end

% Wyświetlanie mapy mocy sygnału
figure;
pcolor(wspX, wspY, signal_power);
shading interp;
colorbar;
title('Mapa mocy sygnału w dBm');
xlabel('x [m]');
ylabel('y [m]');
