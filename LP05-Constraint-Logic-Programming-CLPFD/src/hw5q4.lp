% CS6374: Computational Logic - Homework 05
% Rahul Nalawade [RSN170330]
% Date: 2018-03-26

:- use_module(library(clpfd)). 

%------------------------- Q4 ---------------------------
% solves sudoku puzzle for 9x9 matrix.

sudoku(Rows) :- 
    length(Rows, 9), maplist(same_length(Rows), Rows), 
    append(Rows, Vs), Vs ins 1..9, 
    maplist(all_distinct, Rows), 
    transpose(Rows, Columns), 
    maplist(all_distinct, Columns), 
    Rows = [A,B,C,D,E,F,G,H,I], 
    blocks(A, B, C), blocks(D, E, F), blocks(G, H, I).

blocks([], [], []). 

blocks([A,B,C|Bs1], [D,E,F|Bs2], [G,H,I|Bs3]) :- 
    all_distinct([A,B,C,D,E,F,G,H,I]), 
    blocks(Bs1, Bs2, Bs3). 

%REFERENCE: http://www.swi-prolog.org/pldoc/man?section=clpfd-sudoku

%----------------------- PRINTING -------------------------

writeRow([H1,H2,H3,H4,H5,H6,H7,H8,H9]) :- 
    write('|'), 
    %(var(H1) -> write('_'); write(H1)), write(' '),
    (var(H1) -> write('_'); write(H1)), write(' '),
    (var(H2) -> write('_'); write(H2)), write(' '),
    (var(H3) -> write('_'); write(H3)), write(' '), write('|'),
    (var(H4) -> write('_'); write(H4)), write(' '),
    (var(H5) -> write('_'); write(H5)), write(' '),
    (var(H6) -> write('_'); write(H6)), write(' '), write('|'),
    (var(H7) -> write('_'); write(H7)), write(' '),
    (var(H8) -> write('_'); write(H8)), write(' '),
    (var(H9) -> write('_'); write(H9)), write(' '),
    write('|'), nl.

%writeSudoku([]) :- nl.
writeSudoku([H1,H2,H3,H4,H5,H6,H7,H8,H9]) :- 
    writeOuterLine([1,2,3,4,5,6,7,8,9]),
    writeRow(H1),
    writeRow(H2),
    writeRow(H3), writeInnerLine([1,2,3,4,5,6,7,8,9]),
    writeRow(H4),
    writeRow(H5),
    writeRow(H6), writeInnerLine([1,2,3,4,5,6,7,8,9]),
    writeRow(H7),
    writeRow(H8),
    writeRow(H9), 
    writeOuterLine([1,2,3,4,5,6,7,8,9]), nl.

writeInnerLine([H|T]) :-
    write('|'), 
    length([H|T],L), Temp is sqrt(L), N is ceil(Temp),
    Dashes is N+L*2-1, writeInnerDashes(Dashes).

writeInnerDashes(0) :- write('|'), nl.
writeInnerDashes(N) :- write('-'), N1 is N - 1, writeInnerDashes(N1).

writeOuterLine([H|T]) :-
    write('*'), 
    length([H|T],L), Temp is sqrt(L), N is ceil(Temp),
    Dashes is N+L*2-1, writeOuterDashes(Dashes).

writeOuterDashes(0) :- write('*'), nl.
writeOuterDashes(N) :- write('-'), N1 is N - 1, writeOuterDashes(N1).

%----------------- 3 DIFFERENT PROBLEMS -------------------
:- dynamic problem/2.
% EASY
problem(1, [[_,_,_,_,_,_,_,_,_], 
            [_,_,_,_,_,3,_,8,5], 
            [_,_,1,_,2,_,_,_,_], 
            [_,_,_,5,_,7,_,_,_], 
            [_,_,4,_,_,_,1,_,_], 
            [_,9,_,_,_,_,_,_,_], 
            [5,_,_,_,_,_,_,7,3], 
            [_,_,2,_,1,_,_,_,_], 
            [_,_,_,_,4,_,_,_,9]]).
% MEDIUM
problem(2, [[_,_,_,2,6,_,7,_,1], 
            [6,8,_,_,7,_,_,9,_], 
            [1,9,_,_,_,4,5,_,_],
            [8,2,_,1,_,_,_,4,_],
            [_,_,4,6,_,2,9,_,_],
            [_,5,_,_,_,3,_,2,8],
            [_,_,9,3,_,_,_,7,4],
            [_,4,_,_,5,_,_,3,6],
            [7,_,3,_,1,8,_,_,_]]).

% HARD
problem(3, [[1,_,_,4,8,9,_,_,6], 
            [7,3,_,_,_,_,_,4,_], 
            [_,_,_,_,_,1,2,9,5],
            [_,_,7,1,2,_,6,_,_],
            [5,_,_,7,_,3,_,_,8],
            [_,_,6,_,9,5,7,_,_],
            [9,1,4,6,_,_,_,_,_], 
            [_,2,_,_,_,_,_,3,7], 
            [8,_,_,5,1,2,_,_,4]]).

%----------------------- COMMANDS -------------------------

%problem(1,Rows), sudoku(Rows), maplist(writeln, Rows).
%problem(3,Rows), writeSudoku(Rows), sudoku(Rows), writeSudoku(Rows).

%----------------------------------------------------------