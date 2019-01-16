% CS6374: Computational Logic - Homework 03
% Rahul Nalawade [RSN170330]
% Date: 2018-02-18

%---------------------------------------------- Q9 ------------------------------------------------
missionary(m1).
missionary(m2).
missionary(m3).

cannibal(c1).
cannibal(c2).
cannibal(c3).

% On both the banks Ls and Rs, Cannibals shouldn't outnumber Missionaries present, if any.
legalState(Ls,Rs) :- 
	validCount(Ls), validCount(Rs).

% If no Missionary simply, don't care,
% Else No of Cannibals <= No of Missionaries.
validCount(L) :- 
	findall(X,(cannibal(X),member(X,L)),Cs),
	findall(Y,(missionary(Y),member(Y,L)),Ms),
	length(Cs,C), length(Ms,M), 
	(M == 0 ; C =< M).

%-------------------------------------------- MOVES -----------------------------------------------
% DIFFERENT MOVES - LEFT TO RIGHT: from [L1,R1] to [L2,R2].
% Moved: those who travelled in the boat.

	% Two missionaries cross.
move([L1,R1], l2r,[L2,R2],Moved) :-
	findall(Y,(missionary(Y),member(Y,L1)),Ms),
	length(Ms,M), M > 1, Ms = [M1, M2|_],
	select(M1,L1,Temp), select(M2,Temp,L2),
	append(R1,[M1,M2],R2),
	Moved = [M1,M2], 
	legalState(L2,R2).

	% Two cannibals cross.
move([L1,R1], l2r,[L2,R2],Moved) :-
	findall(Y,(cannibal(Y),member(Y,L1)),Cs),
	length(Cs,C), C > 1, Cs = [C1, C2|_],
	select(C1,L1,Temp), select(C2,Temp,L2),
	append(R1,[C1,C2],R2),
	Moved = [C1,C2], 
	legalState(L2,R2).

	% One missionary and One cannibal cross.
move([L1,R1], l2r,[L2,R2],Moved) :-
	findall(Y,(missionary(Y),member(Y,L1)),Ms),
	length(Ms,M), M > 0, Ms = [M1|_],

	findall(Y,(cannibal(Y),member(Y,L1)),Cs),
	length(Cs,C), C > 0, Cs = [C1|_],
	select(M1,L1,Temp), select(C1,Temp,L2),
	append(R1,[M1,C1],R2),
	Moved = [M1,C1], 
	legalState(L2,R2).

	% One missionary cross.
move([L1,R1], l2r,[L2,R2],Moved) :-
	findall(Y,(missionary(Y),member(Y,L1)),Ms),
	length(Ms,M), M > 0, Ms = [M1|_],
	select(M1,L1,L2),
	append(R1,[M1],R2),
	Moved = [M1,xx], 
	legalState(L2,R2).

	% One cannibal cross.
move([L1,R1], l2r,[L2,R2],Moved) :-
	findall(Y,(cannibal(Y),member(Y,L1)),Cs),
	length(Cs,C), C > 0, Cs = [C1|_],
	select(C1,L1,L2),
	append(R1,[C1],R2),
	Moved = [C1,xx], 
	legalState(L2,R2).

% DIFFERENT MOVES - RIGHT TO LEFT: from [L2,R2] to [L1,R1].
	% Two missionaries cross.
move([L1,R1], r2l,[L2,R2],Moved) :-
	findall(Y,(missionary(Y),member(Y,R2)),Ms),
	length(Ms,M), M > 1, Ms = [M1, M2|_],
	select(M1,R2,Temp), select(M2,Temp,R1),
	append(L2,[M1,M2],L1),
	Moved = [M1,M2], 
	legalState(L1,R1).

	% Two cannibals cross.
move([L1,R1], r2l,[L2,R2],Moved) :-
	findall(Y,(cannibal(Y),member(Y,R2)),Cs),
	length(Cs,C), C > 1, Cs = [C1, C2|_],
	select(C1,R2,Temp), select(C2,Temp,R1),
	append(L2,[C1,C2],L1),
	Moved = [C1,C2], 
	legalState(L1,R1).

	% One missionary and One cannibal cross.
move([L1,R1], r2l,[L2,R2],Moved) :-
	findall(Y,(missionary(Y),member(Y,R2)),Ms),
	length(Ms,M), M > 0, Ms = [M1|_],

	findall(Y,(cannibal(Y),member(Y,R2)),Cs),
	length(Cs,C), C > 0, Cs = [C1|_],
	select(M1,R2,Temp), select(C1,Temp,R1),
	append(L2,[M1,C1],L1),
	Moved = [M1,C1], 
	legalState(L1,R1).

	% One missionary cross.
move([L1,R1], r2l,[L2,R2],Moved) :-
	findall(Y,(missionary(Y),member(Y,R2)),Ms),
	length(Ms,M), M > 0, Ms = [M1|_],
	select(M1,R2,R1),
	append(L2,[M1],L1),
	Moved = [M1,xx], 
	legalState(L1,R1).

	% One cannibal cross.
move([L1,R1], r2l,[L2,R2],Moved) :-
	findall(Y,(cannibal(Y),member(Y,R2)),Cs),
	length(Cs,C), C > 0, Cs = [C1|_],
	select(C1,R2,R1),
	append(L2,[C1],L1),
	Moved = [C1,xx], 
	legalState(L1,R1).

%----------------------------------------- SEARCH MOVES -------------------------------------------
% Recursively searches for the moves until GOAL: [L2,R2] is reached.

% searches moves when BOAT is travelled from LEFT to RIGHT.
searchMovesL2R([L1,R1],[L2,R2],Visited,Moves) :- 
	sort(L1,L1s), sort(L2,L2s), sort(R1,R1s), sort(R2,R2s),
	move([L1s,R1s], l2r,[L3,R3],Moved),
	sort(L3,L3s), sort(R3,R3s),
	\+ (member([L3s,R3s],Visited)),
	searchMovesR2L([L3s,R3s],[L2s,R2s],[[L3s,R3s]|Visited],[[[L3s,R3s],Moved,[L1s,R1s]]|Moves]).

% searches moves when BOAT is travelled from RIGHT to LEFT.
searchMovesR2L([L1,R1],[L2,R2],Visited,Moves) :- 
	sort(L1,L1s), sort(L2,L2s), sort(R1,R1s), sort(R2,R2s),
	move([L3,R3], r2l,[L1s,R1s],Moved),
	sort(L3,L3s), sort(R3,R3s),
	\+ (member([L3s,R3s],Visited)),
	searchMovesL2R([L3s,R3s],[L2s,R2s],[[L3s,R3s]|Visited],[[[L3s,R3s],Moved,[L1s,R1s]]|Moves]).

% Termination of Search: must occur when attempts to search a RIGHT to LEFT move.
searchMovesR2L([L1,R1],[L2,R2],_,Moves) :-   
	sort(L1,L), sort(L2,L), sort(R1,R), sort(R2,R),
	length(Moves,M),
	write('No of Moves = '), write(M), nl,
	writeMoves(Moves,0).

%---------------------------------------- WRITING OUTPUT ------------------------------------------

% Writes Moves in Zig-Zag manner.
writeMoves([],_) :- nl.
writeMoves([[[L2s,R2s],Moved,[L1s,R1s]]|T],Flag) :- 
	(Flag == 0 -> 
		writeMoves(T,1),
		writeList(L1s), write(', '), writeList(R1s), 
		write(' -> '), writeList(Moved), write(' -> '),
		writeList(L2s), write(', '), writeList(R2s), nl; 
	
		writeMoves(T,0),
		writeList(L2s), write(', '), writeList(R2s), 
		write(' <- '), writeList(Moved), write(' <- '),
		writeList(L1s), write(', '), writeList(R1s), nl).

% writes the List [H|T].
writeList([]).
writeList([H|T]) :- write(H), write(' '), writeList(T).

%---------------------------------------- MAIN PREDICATE ------------------------------------------
% Represent a state as [L,R]
% start: 	[[c1,c2,c3,m1,m2,m3],[]]
% goal: 	[[],[c1,c2,c3,m1,m2,m3]]
% N0TE - Start and Goal States must be sorted.

search :- 
	Start = [[c1,c2,c3,m1,m2,m3],[]],
	Goal = [[],[c1,c2,c3,m1,m2,m3]],
	searchMovesL2R(Start,Goal,[Start],_).
