% CS6374: Computational Logic - Homework 05
% Rahul Nalawade [RSN170330]
% Date: 2018-03-26

:- use_module(library(clpfd)).

%-------------------------- Q3 ----------------------------
% solves the ZEBRA PUZZLE with 14 rules.
% with following sequence of variables:
%
% solve([Englishman,    Spaniard,   Japanese,   Italian,    Norwegian], 
%       [Green,         Red,        Yellow,     Blue,       White], 
%       [Painter,       Diplomat,   Violinist,  Doctor,     Sculptor], 
%       [Dog,           Zebra,      Fox,        Snail,      Horse], 
%       [Juice,         Water,      Tea,        Coffee,     Milk]).

solve(N,C,P,A,D) :-
    
    N ins 1..5, C ins 1..5, P ins 1..5, A ins 1..5, D ins 1..5,

    all_different(N), all_different(C), all_different(P), all_different(A), all_different(D),

    N = [N1,N2,N3,N4,N5], C = [C1,C2,C3,C4,C5], P = [P1,P2,P3,P4,P5], A = [A1,A2,A3,A4,A5], D = [D1,D2,D3,D4,D5],
    
    %Rules: 1, 2, 3, 4, 5,
    N1 #= C2, N2 #= A1, N3 #= P1, N4 #= D3, N5 #= 1,

    %Rules: 6, 7, 8, 9, 10,
    C1 #= D4, C1 #= C5 + 1, P5 #= A4, P2 #= C3, D5 #= 3,

    %Rules: 11, 12, 13, 14.
    N5 #= C4 + 1 #\/ N5 #= C4 - 1, 
    P3 #= D1,
    A3 #= P4 + 1 #\/ A3 #= P4 - 1,
    A5 #= P2 + 1 #\/ A5 #= P2 - 1,

    labeling([ff],N), labeling([ff],C), labeling([ff],P), labeling([ff],A), labeling([ff],D),

    H = [lives(englishman,N1), lives(spaniard,N2), lives(japanese,N3), lives(italian,N4), lives(norwegian,N5)],
    
    member(lives(Owner1,A2), H), write('Zebra owner: '), write(Owner1), nl,
    member(lives(Owner2,D2), H), write('Water drinker: '), write(Owner2), nl.

%----------------------- COMMANDS -------------------------

%$ solve([Englishman, Spaniard, Japanese, Italian, Norwegian], [Green, Red, Yellow, Blue, White], [Painter, Diplomat, Violinist, Doctor, Sculptor], [Dog, Zebra, Fox, Snail, Horse], [Juice, Water, Tea, Coffee, Milk]).

%----------------- ZEBRA PROBLEM: RULES -------------------

%1. The Englishman lives in the red house.
%2. The Spaniard owns a dog.
%3. The Japanese is a painter.
%4. The Italian drinks tea. 
%5. The Norwegian lives in the first house.
%6. The owner of the green house drinks coffee.
%7. The green house is on the right of the white house.
%8. The sculptor breeds the snail.
%9. The diplomat lives in the yellow house.
%10. Milk is drunk in the middle house.
%11. The Norwegian's house is next to the blue one.
%12. Violinist drinks fruit juice.
%13. The fox is in the house next to that of the doctor.
%14. The horse is in the house next to that of the diplomat.

%----------------------------------------------------------