%PAWEL KULAKOWSKI, PhD, DSc

% Funkcja dwawektory(A_x,A_y,B_x,B_y,C_x,C_y,D_x,D_y) sprawdza, czy wektory sie przecinaja.
% A = (A_x,A_y) i B = (B_x,B_y) to wspolrzedne poczatku i konca pierwszego wektora,
% punkty C = (C_x,C_y) i (D_x,D_y) to odpowiednio wspolrzedne poczatku i konca drugiego z wektorow.
% Funkcja zwraca:
%         1 jezeli wektory sie przecinaja (krzyzuja),
%         0 jezeli stykaja sie w jednym punkcie lub czesciowo pokrywaja,
%        -1 jezeli sa rozlaczne.

function result = dwawektory (A_x, A_y, B_x, B_y, C_x, C_y, D_x, D_y) ;

% sprawdzenie czy punkty C i D leza po tej samej stronie prostej
% wyznaczonej przez punkty A i B
% jezeli tak, to 'score' da wynik dodatni:
score = ((C_x-A_x)*(B_y-A_y) - (B_x-A_x)*(C_y-A_y)) * ((D_x-A_x)*(B_y-A_y) - (B_x-A_x)*(D_y-A_y)) ;

if score > 0   % wektory sa rozlaczne
    result = -1 ;
    
else
    % sprawdzenie czy punkty A i B leza po tej samej stronie prostej
    % wyznaczonej przez punkty C i D
    % jezeli tak, to 'score2' da wynik dodatni:
    score2 = ((A_x-C_x)*(D_y-C_y) - (D_x-C_x)*(A_y-C_y)) * ((B_x-C_x)*(D_y-C_y) - (D_x-C_x)*(B_y-C_y)) ;
    
    if score2 > 0   % wektory sa rozlaczne
        result = -1 ;
        
    elseif (score < 0) && (score2 < 0)  % wektory sie krzyzuja
        result = 1 ;
    
    elseif (score == 0) && (score2 < 0) % wektory sa styczne
        result = 0 ;
        
    elseif (score < 0) && (score2 == 0) % wektory sa styczne
        result = 0 ;
        
    elseif (A_x < C_x) && (A_x < D_x) && (B_x < C_x) && (B_x < D_x)
        result = -1 ;   % wektory sa rozlaczne
        
    elseif (A_x > C_x) && (A_x > D_x) && (B_x > C_x) && (B_x > D_x)
        result = -1 ;   % wektory sa rozlaczne
        
    elseif (A_y < C_y) && (A_y < D_y) && (B_y < C_y) && (B_y < D_y)
        result = -1 ;   % wektory sa rozlaczne 
        
    elseif (A_y > C_y) && (A_y > D_y) && (B_y > C_y) && (B_y > D_y)
        result = -1 ;   % wektory sa rozlaczne 
     
    else 
        result = 0 ;   % wektory sa styczne
        
    end

end
