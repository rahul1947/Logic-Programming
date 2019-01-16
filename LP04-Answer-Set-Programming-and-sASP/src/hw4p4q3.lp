% CS6374: Computational Logic - Homework 04
% Rahul Nalawade [RSN170330]
% Date: 2018-03-25

%----------------------------------------------------------
% Represent a state as [CL,ML,B,CR,MR]

%:-legalMove(CL,ML,CR,MR), ML < 0, CL < 0,  MR < 0, CR < 0, (ML < CL ; ML is 0), (MR < CR ; MR is 0).

legalMove(CL,ML,CR,MR) :- ML >= 0, CL >= 0, MR >= 0, CR >= 0, (ML >= CL ; ML is 0), (MR >= CR ; MR is 0).

%legalMove(CL,ML,CR,MR) :-
%    not -legalMove(CL,ML,CR,MR).

%-legalMove(CL,ML,CR,MR) :-
%    ML < 0, CL < 0, MR < 0, CR < 0,
%    (ML < CL; ML is 0),
%    (MR < CR; MR is 0).

% Possible moves:
    % Two missionaries cross left to right.
move([CL,ML,left,CR,MR],[CL,ML2,right,CR,MR2]):-
    MR2 is MR + 2,
    ML2 is ML - 2,
    legalMove(CL,ML2,CR,MR2).

    % Two cannibals cross left to right.
move([CL,ML,left,CR,MR],[CL2,ML,right,CR2,MR]):-
    CR2 is CR + 2,
    CL2 is CL - 2,
    legalMove(CL2,ML,CR2,MR).

    %  One missionary and one cannibal cross left to right.
move([CL,ML,left,CR,MR],[CL2,ML2,right,CR2,MR2]):-
    CR2 is CR + 1,
    CL2 is CL - 1,
    MR2 is MR + 1,
    ML2 is ML - 1,
    legalMove(CL2,ML2,CR2,MR2).

    % One missionary crosses left to right.
move([CL,ML,left,CR,MR],[CL,ML2,right,CR,MR2]):-
    MR2 is MR + 1,
    ML2 is ML - 1,
    legalMove(CL,ML2,CR,MR2).

    % One cannibal crosses left to right.
move([CL,ML,left,CR,MR],[CL2,ML,right,CR2,MR]):-
    CR2 is CR + 1,
    CL2 is CL - 1,
    legalMove(CL2,ML,CR2,MR).

    % Two missionaries cross right to left.
move([CL,ML,right,CR,MR],[CL,ML2,left,CR,MR2]):-
    MR2 is MR - 2,
    ML2 is ML + 2,
    legalMove(CL,ML2,CR,MR2).

    % Two cannibals cross right to left.
move([CL,ML,right,CR,MR],[CL2,ML,left,CR2,MR]):-
    CR2 is CR - 2,
    CL2 is CL + 2,
    legalMove(CL2,ML,CR2,MR).

    %  One missionary and one cannibal cross right to left.
move([CL,ML,right,CR,MR],[CL2,ML2,left,CR2,MR2]):-
    CR2 is CR - 1,
    CL2 is CL + 1,
    MR2 is MR - 1,
    ML2 is ML + 1,
    legalMove(CL2,ML2,CR2,MR2).

    % One missionary crosses right to left.
move([CL,ML,right,CR,MR],[CL,ML2,left,CR,MR2]):-
    MR2 is MR - 1,
    ML2 is ML + 1,
    legalMove(CL,ML2,CR,MR2).

    % One cannibal crosses right to left.
move([CL,ML,right,CR,MR],[CL2,ML,left,CR2,MR]):-
    CR2 is CR - 1,
    CL2 is CL + 1,
    legalMove(CL2,ML,CR2,MR).

%----------------------------------------------------------
% Recursive call for searching
searchMoves([CL1,ML1,B1,CR1,MR1],[CL2,ML2,B2,CR2,MR2],Explored,MovesList) :-
   move([CL1,ML1,B1,CR1,MR1],[CL3,ML3,B3,CR3,MR3]),
   \+ member([CL3,ML3,B3,CR3,MR3],Explored),
   searchMoves([CL3,ML3,B3,CR3,MR3],[CL2,ML2,B2,CR2,MR2],[[CL3,ML3,B3,CR3,MR3]|Explored],[ [[CL3,ML3,B3,CR3,MR3],[CL1,ML1,B1,CR1,MR1]] | MovesList ]).

% Terminating condition
searchMoves([CL,ML,B,CR,MR],[CL,ML,B,CR,MR],_,MovesList):-
    printList(MovesList).

% Printing
printList([]) :- nl.
printList([[A,B]|MovesList]) :-
    printList(MovesList),
    write(B), write(' -> '), write(A), nl.

%member
member(X,[X|_]).
member(X,[_|Y]) :- member(X,Y).

%----------------------------------------------------------
?- searchMoves([3,3,left,0,0],[0,0,right,3,3],[[3,3,left,0,0]],_).

% REFERENCE:
% https://github.com/marianafranco/missionaries-and-cannibals/blob/master/prolog/missionaries_and_cannibals.pl
%----------------------------------------------------------