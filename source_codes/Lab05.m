clearvars; close all; clc;

% Parametry terenu
terrain_width = 80;   % szerokość terenu (m)
terrain_height = 70;  % wysokość terenu (m)

% Parametry robotów i stacji referencyjnych
num_robots = 90;     % liczba robotów
sigma_angle = 2;     % odchylenie standardowe dla kąta (w stopniach)

% Pozycje stacji referencyjnych w rogach prostokąta
ref_stations = [
    0, 0;
    terrain_width, 0;
    terrain_width, terrain_height;
    0, terrain_height
];

% Losowa pozycja robotów na terenie
robot_positions = [terrain_width * rand(num_robots, 1), terrain_height * rand(num_robots, 1)];

% Macierz przechowująca wyznaczone pozycje robotów
estimated_positions = zeros(num_robots, 2);

% Główna pętla dla każdego robota
for i = 1:num_robots
    % Inicjalizacja macierzy do algorytmu najmniejszych kwadratów
    A = zeros(4, 2);
    b = zeros(4, 1);
    
    for j = 1:4
        % Wektor od robota do stacji referencyjnej
        dx = ref_stations(j, 1) - robot_positions(i, 1);
        dy = ref_stations(j, 2) - robot_positions(i, 2);
        
        % Sprawdzenie, czy dx i dy są różne od zera
        if dx == 0 && dy == 0
            continue; % Pomiń, gdy robot jest w tym samym miejscu co stacja
        end
        
        % Prawdziwy kąt nadejścia sygnału
        true_angle = atand(dy / dx);
        
        % Dodanie błędu do kąta nadejścia sygnału
        observed_angle = true_angle + sigma_angle * randn;
        
        % Zapisanie równań do macierzy A i wektora b
        A(j, :) = [tand(observed_angle), -1];
        b(j) = tand(observed_angle) * ref_stations(j, 1) - ref_stations(j, 2);
    end
    
    % Wyznaczenie pozycji robota za pomocą algorytmu najmniejszych kwadratów
    try
        estimated_positions(i, :) = (A' * A) \ (A' * b);
    catch
        estimated_positions(i, :) = [NaN, NaN]; % Ustal pozycję jako NaN, gdy nie można obliczyć
    end
end

% Obliczenie średniego błędu lokalizacji
localization_error = sqrt(sum((robot_positions - estimated_positions).^2, 2));
localization_error(isnan(localization_error)) = []; % Usunięcie NaN
mean_error = mean(localization_error);

% Wizualizacja wyników
figure;
subplot(1,2,1);
hold on;
% Pozycje stacji referencyjnych
plot(ref_stations(:, 1), ref_stations(:, 2), 'bs', 'MarkerSize', 10, 'DisplayName', 'Stacje referencyjne');

% Prawdziwe pozycje robotów
plot(robot_positions(:, 1), robot_positions(:, 2), 'go', 'DisplayName', 'Prawdziwe pozycje robotów');

% Wyznaczone pozycje robotów
plot(estimated_positions(:, 1), estimated_positions(:, 2), 'rx', 'DisplayName', 'Wyznaczone pozycje robotów');

% Legenda i tytuły
legend show;
title(sprintf('Symulacja lokalizacji robotów, średni błąd lokalizacji: %.2f m', mean_error));
xlabel('X (m)');
ylabel('Y (m)');
axis([0 terrain_width 0 terrain_height]);
grid on;
hold off;

% -----------------------------------------
% Symulacja mapy błędu lokalizacji dla każdego punktu na siatce 1x1 m
% -----------------------------------------

% Parametry mapy błędu
error_map = zeros(terrain_height + 1, terrain_width + 1); % Macierz przechowująca błędy

% Pętla dla każdej pozycji na siatce 1x1 m
num_simulations = 50;
for x = 0:terrain_width
    for y = 0:terrain_height
        total_error = 0; % Suma błędów dla danej pozycji (x, y)
        
        for sim = 1:num_simulations
            % Rzeczywista pozycja robota
            robot_position = [x, y];
            
            % Inicjalizacja macierzy dla metody najmniejszych kwadratów
            A = zeros(4, 2);
            b = zeros(4, 1);
            
            for j = 1:4
                % Wektor od stacji referencyjnej do robota
                dx = ref_stations(j, 1) - robot_position(1);
                dy = ref_stations(j, 2) - robot_position(2);
                
                % Sprawdzenie, czy dx i dy są różne od zera
                if dx == 0 && dy == 0
                    continue; % Pomiń, gdy robot jest w tym samym miejscu co stacja
                end
                
                % Prawdziwy kąt
                true_angle = atand(dy / dx);
                
                % Szacowany kąt z błędem
                observed_angle = true_angle + sigma_angle * randn;
                
                % Równania do algorytmu najmniejszych kwadratów
                A(j, :) = [tand(observed_angle), -1];
                b(j) = tand(observed_angle) * ref_stations(j, 1) - ref_stations(j, 2);
            end
            
            % Wyznaczanie pozycji metodą najmniejszych kwadratów
            try
                estimated_position = (A' * A) \ (A' * b);
            catch
                estimated_position = NaN(2, 1); % Ustal pozycję jako NaN, gdy nie można obliczyć
            end
            
            % Obliczenie błędu dla danej symulacji
            if all(~isnan(estimated_position))
                error = norm(estimated_position' - robot_position);
            else
                error = NaN; % W przypadku osobliwości, ustal błąd jako NaN
            end
            
            total_error = total_error + error;
        end
        
        % Uśredniony błąd dla pozycji (x, y)
        error_map(y + 1, x + 1) = total_error / num_simulations;
    end
end

% Wyświetlanie mapy błędu
subplot(1,2,2);
pcolor(transpose(error_map));
shading interp;
colorbar;
title('Mapa błędu lokalizacji w zależności od pozycji robota');
xlabel('X (m)');
ylabel('Y (m)');
