% CS6374: Computational Logic - Assignment 02
% Rahul Nalawade [RSN170330]
% Date: 2018-02-01 

%--------------------- i. -----------------------
%i. substitute(X,Y,L1,L2): where L2 is the result of 
%	substituting Y for all occurences of X in L1
substitute(_,_,[],[]). 

substitute(X,Y,[X|T1],[Y|T2]) :-
	substitute(X,Y,T1,T2).

substitute(X,Y,[Z|T1],[Z|T2]) :-
	Z \= X,
	substitute(X,Y,T1,T2).

%-------------------- ii. -----------------------
% select(X,List,R): R is a List with one removed X
select(X,[X|T],T).
select(X,[H|T],[H|R]) :- 
	%X \= H,
	select(X,T,R).

%-------------------- iii. ----------------------
% no_doubles(L1,L2): L2 is list of all distinct 
%	values in L1.
no_doubles([],[]).

no_doubles([H|T],R) :-
	member(H,T),
	no_doubles(T,R).

no_doubles([H|T],[H|R]) :-
	\+ member(H,T),
	no_doubles(T,R).
	
% delete(X,List,HasNoXs)
delete(H,[H|T],R) :- 
	delete(H,T,R).

delete(Z,[H|T],[H|R]) :- 
	H \= Z, 
	delete(Z,T,R).

delete(_,[],[]).

%--------------------- v. -----------------------
% mergeSort(ListX,ListR): sorts ListX to give ListR
mergeSort([],[]).
mergeSort([X],[X]).

mergeSort([X|T],ListR) :- splitHalves([X|T],L,R),
	mergeSort(L,L1),
	mergeSort(R,R1),
	merge(L1,R1,ListR).

%splitHalves(List,ListL,ListR): split List into 
%	two halves ListL and ListR.
splitHalves([],[],[]).
splitHalves([X],[X],[]).

splitHalves([H|T1],[H|L1],R) :- removeLast(T1,T),
	splitHalves(T,L1,R1),
	last(S,T1),
	reverse([S|R1],R).

% last(X,List): X is last element in List
last(X,List) :- reverse(List,[X|_]).

%removeLast(List,R): removing last element 
%	from List gives R.
removeLast([],[]).
removeLast(X,R) :- reverse(X,[_|T]),
	reverse(T,R).

% b: Reverse-accumulate
reverse(Xs,Ys) :- reverse(Xs,[],Ys).

reverse([X|Xs],Acc,Ys) :- reverse(Xs,[X|Acc],Ys).
reverse([],Ys,Ys).

%merge(List1,List2,List3): merges sorted lists
%	List1 and List2 to give a sorted List3
merge(L,[],L).
merge([],[],[]).

merge([H1|T1],[H2|T2],[H1|R]) :- H1 < H2,
	merge(T1,[H2|T2],R).

merge([H1|T1],[H2|T2],[H2|R]) :- H2 < H1,
	merge([H1|T1],T2,R).

%-------------------- vi. -----------------------
% KTH_LARGEST

%kth_largest(Kl,K,List): Kl is Kth largest element 
% 	from the List.

kth_largest(Kl,K,List) :- 
	
	split5(List,List5),
	medians(List5,MediansL),
	medianM(MediansL,MedOfMed),

	partition(List,MedOfMed,Ls,Bs),
	lengthL(Bs,B),
	P is B+1,

	( P == K -> 
		Kl is MedOfMed;
		
		( P > K -> 
			kth_largest(Kl,K,Bs);
			K1 is K-P,
			kth_largest(Kl,K1,Ls)
		)
	).
% algorithm referred from: 
% https://www.geeksforgeeks.org/kth-smallestlargest-element-unsorted-array-set-3-worst-case-linear-time/

%------------------------------------------------
% DONT TOUCH THIS

% given a list List, splits List into group of 
% 	5 elements as R.
split5(List, R) :- 
	lengthL(List,D),
	M is mod(D,5),
	( M \= 0 -> 
		( 5 < D ->
		J is D-M, slice(List,1,J,List1),
		I is J+1, slice(List,I,D,List2),
		addList(List2,[],List3),
		group(List1,R1),
		append(R1,List3,R);
			
		makeList(List,R));
		
	group(List,R)).

%--------------- NEW PREDICATES -----------------

% makes the list of list from arg1.
% makeList([2],[[2]]). is true.
% makeList([2,3,4],[[2,3,4]]). is true.

makeList([X],[[X]]).
makeList([H|T],[[H|T]]).

% group(L,R): groups elements from list L into
% 	group of 5 elements. 
% Length of L must be a multiple of 5.
group([], []).
group([A1,A2,A3,A4,A5 | Tail], [[A1,A2,A3,A4,A5] | NewTail]) :-
    group(Tail, NewTail).

% adds Item to the List resulting into [Item|List].
addList(Item,List,[Item|List]).
addList(Item,[],[Item]).

% slice(L1,I,K,L2): L2 is the list of the elements of L1 between
%    index I and index K (both included).
%    (list,integer,integer,list) (?,+,+,?)

slice([X|_],1,1,[X]).

slice([X|Xs],1,K,[X|Ys]) :- K > 1, 
   K1 is K - 1, slice(Xs,1,K1,Ys).

slice([_|Xs],I,K,Ys) :- I > 1, 
   I1 is I - 1, K1 is K - 1, slice(Xs,I1,K1,Ys).

%------------------- MEDIAN ---------------------

% when there is only one list, so one [median]
medians([X],[Med]) :- 
	medianM(X,Med).
	%makeList([Med],M).

% when there are multiple lists, so [medians]
medians([H|T],[Med|R]) :- 
	medianM(H,Med),
	medians(T,R).

% finds M as a median of list L.
medianM(L, M) :- 
    member(M, L), 
    partition(L, M, A, B), 
    lengthL(A, X), lengthL(B, Y), 
    sameLength(X,Y).

sameLength(X,Y) :- 
	( X is Y+1 -> true; X == Y).

%----------------- PARTITIONING -----------------
% partitions [H|T] into Ls1 and Bs1 at P.
partition([],_,[],[]).

partition([H|T],P,Ls1,Bs1) :- 
	(H =< P -> partition(T,P,Ls,Bs), Ls1 = [H|Ls], Bs1 = Bs;
		partition(T,P,Ls,Bs), Ls1 = Ls, Bs1 = [H|Bs]).

%--------------- OLD PREDICATES -----------------

% prefix(P,L): P is prefix of L.
prefix([],_).
prefix([H|X],[H|Y]) :- prefix(X,Y).

% sublist(Sub,List): Sub is a sublist of List.
% c: recursive definition of a sublist
sublist(Xs,Ys) :- prefix(Xs,Ys).
sublist(Xs,[_|Ys]) :- sublist(Xs,Ys).


% append(X,Y,Z): appends Y to X to give Z.
append([],[],[]).
append(Y,[],Y).
append([],Y,Y).
append([H|X],Y,[H|Z]) :- append(X,Y,Z).

%------------------- LENGTH ---------------------
% length_itr(List,A,L): L is length of List, 
% 	A being accumulator

lengthL([],0).
lengthL([H|T],L) :- length_itr([H|T],0,L).

length_itr([_|T],A,L) :- 
	A1 is A+1,
	length_itr(T,A1,L).

length_itr([],A,A).

%------------------------------------------------
% please, see pokerA2.pl for part vii.
%------------------------------------------------
