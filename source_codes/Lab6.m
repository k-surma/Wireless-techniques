clearvars; close all; clc;

%cw1

% Wymiary pomieszczenia
room_x = 60;
room_y = 40;

% Współrzędne nadajników
transmitters = [5.5, 4.5; 5.5, 20; 5.5, 34];

% Współrzędne odbiorników
receivers = [54, 10.5; 54, 16.5; 54, 24.5; 54, 30.5];

% Tworzymy wykres
figure;
hold on;
axis([0 room_x 0 room_y]);
grid on;

% Rysujemy pomieszczenie
rectangle('Position', [0, 0, room_x, room_y], 'EdgeColor', 'k', 'LineWidth', 2);

% Rysujemy nadajniki
for i = 1:size(transmitters, 1)
    plot(transmitters(i, 1), transmitters(i, 2), 'ro', 'MarkerSize', 10, 'DisplayName', 'Nadajnik');
end

% Rysujemy odbiorniki
for i = 1:size(receivers, 1)
    plot(receivers(i, 1), receivers(i, 2), 'bo', 'MarkerSize', 10, 'DisplayName', 'Odbiornik');
end

% Rysujemy drogi propagacji LOS
for i = 1:size(transmitters, 1)
    for j = 1:size(receivers, 1)
        line([transmitters(i, 1), receivers(j, 1)], [transmitters(i, 2), receivers(j, 2)], 'Color', 'g');
    end
end

legend('show');
title('Wizualizacja pomieszczenia z nadajnikami i odbiornikami');
hold off;


% Położenie obiektu pasywnego
object_position = [20, 18];
object_width = 1;
object_height = 1;

% Rysujemy obiekt
rectangle('Position', [object_position(1), object_position(2), object_width, object_height], 'FaceColor', 'r', 'EdgeColor', 'k');

% Sprawdzamy, które drogi są zablokowane
for i = 1:size(transmitters, 1)
    for j = 1:size(receivers, 1)
        % Sprawdzamy pozycje nadajnika i odbiornika
        tx = transmitters(i, :);
        rx = receivers(j, :);

    % Funkcja sprawdzająca czy linia i obiekt się przecinają
        if wektorsektor(tx(1), tx(2), rx(1), rx(2), object_position(1), object_position(2), object_width, object_height) == 1
            line([tx(1), rx(1)], [tx(2), rx(2)], 'Color', 'm', 'LineWidth', 2); % Prosto zablokowana
        end
    end
end

hold off;


%cw2
% Tworzymy macierz do obserwacji sektorów
potential_locations = zeros(room_x, room_y);

% Sprawdzamy sektory
for x = 0:(room_x-1)
    for y = 0:(room_y-1)
        % Sprawdzamy, czy wszystkie blokowane promienie znajdują się w sektorze
        sector_blocked = true;
        
        for i = 1:size(transmitters, 1)
            for j = 1:size(receivers, 1)
                % Sprawdzamy, czy promień jest zablokowany
                if wektorsektor(transmitters(i, 1), transmitters(i, 2), receivers(j, 1), receivers(j, 2), x, y, 1, 1) == 1
                    sector_blocked = false; % Promień znajduje się poza sektorem
                end
            end
        end
        
        % Oznaczamy potencjalne sektory
        if sector_blocked
            potential_locations(x+1, y+1) = 1; % 1 oznacza potencjalne miejsce obiektu
            rectangle('Position', [x, y, 1, 1], 'EdgeColor', 'b', 'FaceColor', 'g', 'LineWidth', 1); % Zaznaczamy sektor
        end
    end
end