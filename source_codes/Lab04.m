clearvars;close all;clc;



%cw 1 - do uzytkownikow dociera sygnal w roznym czasie
%dane - router, moc, pozycje uzytkownikow, odleglosc miedzy antenami
AP = [100, 0];
Pt = 10*log10(5e-3);
f = 6e9;
c = 3e8;
lambda = c/f;
user_1 = [50, 70];
user_2 = [160, 50];
dif_anthen = 0.0125;
noise = -135;

%dystans
r_1 = sqrt((user_1(1)-(AP(1)-dif_anthen))^2+(user_1(2))^2);
r_2 = sqrt((user_1(1)-(AP(1)+dif_anthen))^2+(user_1(2))^2);

delta_r12 = abs(r_1-r_2);
phase_1 = (delta_r12*2*pi)/lambda;

%transmitancja
H_1 = lambda/(4*pi*r_1)*exp(-1j*(2*pi*r_1)/lambda)*exp(-1j*phase_1);    
H_2 = lambda/(4*pi*r_2)*exp(-1j*(2*pi*r_2)/lambda);
H12_abs = abs(H_1+H_2);

%moc odbierana przez uzytkownikow i SNR
Pr_12 = Pt + 20*log10(H12_abs) - 3;
SNR_12 = Pr_12 - noise;


%cw 2- beamforming - cwiczenie nie zodtalo dokonczone na labach (wyniki sa zblizone do poprawnych ale jednak zle)
r_3 = sqrt((user_2(1)-(AP(1)-dif_anthen))^2+(user_2(2))^2);
r_4 = sqrt((user_2(1)-(AP(1)+dif_anthen))^2+(user_2(2))^2);

delta_r34 = abs(r_3-r_4);
phase_2 = (delta_r34*2*pi)/lambda;

H_3 = lambda/(4*pi*r_3)*exp(-1j*(2*pi*r_3)/lambda)*exp(1j*phase_2);
H_4 = lambda/(4*pi*r_4)*exp(-1j*(2*pi*r_4)/lambda);
H34_abs = abs(H_3+H_4);

Pr_34 = Pt + 20*log10(H34_abs) - 3;
SNR_34 = Pr_34 - noise;

phase_11 = 1;
phase_12 = 1;
phase_33 = 1;
phase_34 = 1;
