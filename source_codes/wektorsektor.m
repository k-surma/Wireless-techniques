% Funkcja wektorsektor (ax,ay,bx,by,cx,cy,w,h) sprawdza, czy wektor (ax,ay,bx,by)
% i sektor (cx,cy,w,h) sie przecinaja.
% (ax,ay) i (bx,by) to wspolrzedne poczatku i konca wektora
% (cx,cy) to wspolrzedne lewego dolnego rogu sektora
% (w,h) to szerokosc i wysokosc sektora
% Funkcja zwraca:
%         -1, jezeli wektor i sektor sie nie przecinaja (co moze rowniez oznaczac,
%             ze wektor rozpoczyna sie i koñczy w srodku sektora),
%         0,  jezeli jeden z koncow wektora znajduje sie wewnatrz sektora a
%             drugi na zewnatrz,
%         1,  jezeli wektor przecina sektor (oba koñce wektora znajduja sie
%             poza sektorem, ale wektor przez ten sektor przechodzi), obejmuje
%             to równiez przypadek, gdy wektor styka sie z sektorem



function result = wektorsektor (ax, ay, bx, by, cx, cy, w, h) ;

result = -1 ;
if dwawektory (ax, ay, bx, by, cx, cy, cx+w, cy) ~= -1
    result = result+1 ;
end
if dwawektory (ax, ay, bx, by, cx, cy, cx, cy+h) ~= -1
    result = result+1 ;
end
if dwawektory (ax, ay, bx, by, cx+w, cy, cx+w, cy+h) ~= -1
    result = result+1 ;
end
if dwawektory (ax, ay, bx, by, cx, cy+h, cx+w, cy+h) ~= -1
    result = result+1 ;
end

lowx = ax ;
highx = bx ;
if bx < ax
    lowx = bx ;
    highx = ax ;
end

lowy = ay ;
highy = by ;
if by < ay
    lowy = by ;
    highy = ay ;
end

if cx > highx
    result = -1 ;
end
if cy > highy
    result = -1 ;
end

if cx+w < lowx
    result = -1 ;
end
if cy+h < lowy
    result = -1 ;
end

if result > 1
    result = 1 ;
end

