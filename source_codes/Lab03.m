%zaniki sygnału w komunikacji mobilnej

clearvars; close all; clc;

% Parametry początkowe
v = 30; % prędkość w m/s
t_max = 6; % czas obserwacji w sekundach
dt = 0.01; % krok czasu, 10 ms
t = 0:dt:t_max; % wektor czasu

% Pozycja początkowa użytkownika i stacji bazowej
user_pos_start = [50, 10]; % (x, y) początkowe użytkownika
user_velocity = [0, v]; % prędkość (x, y)
bs_pos = [110, 190]; % pozycja stacji BS

% Pozycje ścian
wall1_start = [20, 30]; wall1_end = [20, 300];
wall2_start = [70, 100]; wall2_end = [130, 100];

% Inne parametry
P_BS = 5; % Moc stacji bazowej w Watach
f = 3e9; % Częstotliwość 3 GHz
c = 3e8; % prędkość światła
lambda = c / f; % długość fali
reflection_coeff = 0.8; % współczynnik odbicia ścian

% Funkcja do obliczania odległości między dwoma punktami
distance = @(p1, p2) sqrt((p1(1)-p2(1))^2 + (p1(2)-p2(2))^2);

% Wyznaczenie obrazów stacji BS przez odbicie od ścian
bs_image1 = bs_pos; bs_image1(1) = 2*wall1_start(1) - bs_pos(1); % odbicie przez ścianę 1
bs_image2 = bs_pos; bs_image2(2) = 2*wall2_start(2) - bs_pos(2); % odbicie przez ścianę 2

% Inicjalizacja wektora mocy
P_received = zeros(size(t));

% Symulacja ruchu użytkownika i obliczenie mocy sygnału
for i = 1:length(t)
    user_pos = user_pos_start + user_velocity * t(i); % pozycja użytkownika w danym czasie
    
    % Odległości do BS i jego obrazów
    d_direct = distance(user_pos, bs_pos);
    d_reflect1 = distance(user_pos, bs_image1);
    d_reflect2 = distance(user_pos, bs_image2);
    
    % Moc sygnału bezpośredniego
    P_direct = P_BS * (lambda / (4 * pi * d_direct))^2;
    
    % Moc sygnałów odbitych
    P_reflect1 = P_BS * (lambda / (4 * pi * d_reflect1))^2 * reflection_coeff;
    P_reflect2 = P_BS * (lambda / (4 * pi * d_reflect2))^2 * reflection_coeff;
    
    % Sumowanie mocy (uwzględniamy sumę kwadratów ze względu na interferencję)
    P_received(i) = P_direct + P_reflect1 + P_reflect2;
end

% Wykres mocy odbieranego sygnału
figure;
plot(t, 10*log10(P_received));
xlabel('Czas [s]');
ylabel('Moc odbieranego sygnału [dB]');
title('Moc odbieranego sygnału przez użytkownika');
grid on;
