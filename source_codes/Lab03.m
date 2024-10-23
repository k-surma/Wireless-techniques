%zaniki sygnału w komunikacji mobilnej

clearvars; close all; clc; 

v = 20; % m/s - prędkość użytkownika
initial_pos = [20,20]; % Pozycja początkowa użytkownika [x,y]
final_pos = [20,500]; % Pozycja końcowa użytkownika (nie jest bezpośrednio używana w kodzie)
duration = 5; % Czas trwania ruchu w sekundach
dt = 0.01; % Krok czasowy symulacji (co 0.01 sekundy)
time_steps = 0:dt:duration; % Wektor czasu od 0 do 'duration' z krokiem 'dt'

P_bs = 10; % W - Moc nadajnika bazowego (BS)
BS_pos = [160, 20]; % Pozycja nadajnika bazowego [x,y]
frequency = 2e9; % Częstotliwość sygnału (2 GHz)
reflection_coeff = 0.7; % Współczynnik odbicia sygnału od ścian
c = 3e8; % Prędkość światła (300 000 000 m/s)

% Pozycje ścian
wall1_start = [0,10]; wall1_end = [200,10]; % Ściana 1 pozioma
wall2_start = [60,50]; wall2_end = [100,50]; % Ściana 2 pionowa

num_steps = length(time_steps); % Liczba kroków czasowych

% Inicjalizacja macierzy na pozycje użytkownika
user_positions = zeros(num_steps, 2); 
for n = 1:num_steps 
    % Obliczanie pozycji użytkownika w każdej chwili (porusza się tylko wzdłuż osi Y)
    user_positions(n, :) = initial_pos + [0, v * time_steps(n)]; 
end 

% Inicjalizacja macierzy na moc sygnału odbieranego w każdym kroku
received_power = zeros(size(time_steps)); 

for n = 1:num_steps 
    % Aktualna pozycja użytkownika
    user_pos = user_positions(n, :); 
    
    % Obliczenie odległości od nadajnika do użytkownika (sygnał bezpośredni)
    direct_distance = norm(BS_pos - user_pos); 
    direct_signal = P_bs / (direct_distance^2); % Moc sygnału bezpośredniego (prawo odwrotności kwadratu odległości)

    % Obliczenie odległości odbicia od ściany 1 (pozioma ściana)
    reflected_point1 = [wall1_start(1), user_pos(2)]; % Punkt odbicia na ścianie 1
    reflected_distance1 = norm(BS_pos - reflected_point1) + norm(reflected_point1 - user_pos); 
    reflected_signal1 = reflection_coeff * P_bs / (reflected_distance1^2); % Moc sygnału odbitego od ściany 1

    % Obliczenie odległości odbicia od ściany 2 (pionowa ściana)
    reflected_point2 = [user_pos(1), wall2_start(2)]; % Punkt odbicia na ścianie 2
    reflected_distance2 = norm(BS_pos - reflected_point2) + norm(reflected_point2 - user_pos); 
    reflected_signal2 = reflection_coeff * P_bs / (reflected_distance2^2); % Moc sygnału odbitego od ściany 2

    % Obliczenie długości fali sygnału
    wavelength = c / frequency; % Długość fali w metrach
    
    % Obliczenie przesunięć fazowych dla sygnałów (w zależności od przebytej odległości)
    phase_shift_direct = 2 * pi * direct_distance / wavelength; % Przesunięcie fazowe sygnału bezpośredniego
    phase_shift2 = 2 * pi * reflected_distance2 / wavelength; % Przesunięcie fazowe dla ściany 2
    phase_shift1 = 2 * pi * reflected_distance1 / wavelength; % Przesunięcie fazowe dla ściany 1
    
    % Sumowanie sygnału bezpośredniego i odbitych z przesunięciem fazowym
    combined_signal = direct_signal + ...
                      reflected_signal1 * exp(1j * phase_shift1) + ...
                      reflected_signal2 * exp(1j * phase_shift2); 
                  
    % Obliczenie mocy sygnału (moduł sygnału zsumowanego podniesiony do kwadratu)
    received_power(n) = abs(combined_signal)^2; 
end 

% Rysowanie wykresu mocy odbieranego sygnału w dB w funkcji czasu
figure; 
plot(time_steps, 10*log10(received_power)); % Konwersja mocy na skalę dB
xlabel('Czas (s)'); % Oś x: Czas
ylabel('Moc odbieranego sygnału (dB)'); % Oś y: Moc w dB
title('Moc odbieranego sygnału w czasie z efektami wielodrogowymi'); % Tytuł wykresu
grid on; 
