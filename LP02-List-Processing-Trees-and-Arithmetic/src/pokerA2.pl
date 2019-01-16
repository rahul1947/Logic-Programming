% CS6374: Computational Logic - Assignment 02
% Rahul Nalawade [RSN170330]
% Date: 2018-02-08 

%-------------------- vii. ----------------------
% BETTER_POKER_HAND

% card(Suit,Value).
card(diamonds,2).	card(diamonds,3). 	card(diamonds,4).
card(diamonds,5).	card(diamonds,6).	card(diamonds,7).
card(diamonds,8).	card(diamonds,9).	card(diamonds,10).
card(diamonds,jack).	card(diamonds,queen).	card(diamonds,king).
card(diamonds,ace).

card(clubs,2).	card(clubs,3).	card(clubs,4).
card(clubs,5).	card(clubs,6).	card(clubs,7).
card(clubs,8).	card(clubs,9).	card(clubs,10).
card(clubs,jack).	card(clubs,queen).	card(clubs,king).
card(clubs,ace).

card(hearts,2).	card(hearts,3).	card(hearts,4).
card(hearts,5).	card(hearts,6).	card(hearts,7).
card(hearts,8).	card(hearts,9).	card(hearts,10).
card(hearts,jack).	card(hearts,queen).	card(hearts,king).
card(hearts,ace).

card(spades,2).	card(spades,3).	card(spades,4).
card(spades,5).	card(spades,6).	card(spades,7).
card(spades,8).	card(spades,9).	card(spades,10).
card(spades,jack).	card(spades,queen).	card(spades,king).
card(spades,ace).

%-------------- VALUE PRECEDENCE ----------------

% 2,3,4,5,6,7,8,9,10,jack,queen,king,ace

immediateGreaterValue(ace,king). immediateGreaterValue(king,queen).
immediateGreaterValue(queen,jack). immediateGreaterValue(jack,10).
immediateGreaterValue(10,9). immediateGreaterValue(9,8).
immediateGreaterValue(8,7).	immediateGreaterValue(7,6).	
immediateGreaterValue(6,5). immediateGreaterValue(5,4).	
immediateGreaterValue(4,3).	immediateGreaterValue(3,2).

% greaterValue(X,Y): X is better value than Y.
greaterValue(X,Y) :- immediateGreaterValue(X,Y).
greaterValue(X,Y) :- 
	immediateGreaterValue(Z,Y), greaterValue(X,Z).

%-------------- TYPES PRECEDENCE ----------------

% no pairs < one pair < two pairs < three of a kind < ﬂush < 
% straight < full house < four of a kind < straight flush.

immediateGreaterType(straightFlush,fourOfAKind). 
immediateGreaterType(fourOfAKind,fullHouse).
immediateGreaterType(fullHouse,straight).
immediateGreaterType(straight,flush).
immediateGreaterType(flush,threeOfAKind).
immediateGreaterType(threeOfAKind,twoPairs).
immediateGreaterType(twoPairs,onePair).
immediateGreaterType(onePair,noPair).

% greaterType(X,Y): X is better Type than Y.
greaterType(X,Y) :- immediateGreaterType(X,Y).
greaterType(X,Y) :- 
	immediateGreaterType(Z,Y), greaterType(X,Z).

%----------------- VALIDATION -------------------
% validHand(H): H is a valid Hand.
validHand(Hand) :-
	length(Hand,5),
	no_doubles(Hand,Hand).

% no_doubles(L1,L2): L2 is list of all distinct values in L1.
no_doubles([],[]).

no_doubles([H|T],R) :-
	member(H,T),
	no_doubles(T,R).

no_doubles([H|T],[H|R]) :-
	\+ member(H,T),
	no_doubles(T,R).

%----------------- PARTITIONING -----------------
% partitions [H|T] into Ls1 and Bs1 at P.
partition([],_,[],[]).

partition([card(Hs,H)|T],card(Ps,P),Ls1,Bs1) :- 
	(greaterValue(P,H) -> 
		partition(T,card(Ps,P),Ls,Bs), Ls1 = [card(Hs,H)|Ls], Bs1 = Bs;
		partition(T,card(Ps,P),Ls,Bs), Ls1 = Ls, Bs1 = [card(Hs,H)|Bs]).

%------------------ QUICKSORT -------------------
% quicksort(Hand,SortedHand): sorts Hand to SortedHand
quicksort([card(Xs,X)|T],Ys) :- 
	partition(T,card(Xs,X),Littles,Bigs),
	quicksort(Littles,Ls),
	quicksort(Bigs,Bs),
	append(Ls,[card(Xs,X)|Bs],Ys).

quicksort([],[]).

%--------------- OLD PREDICATES -----------------

% append(X,Y,Z): appends Y to X to give Z.
append([],[],[]).
append(Y,[],Y).
append([],Y,Y).
append([H|X],Y,[H|Z]) :- append(X,Y,Z).

% last(X,List): X is last element in List
last(X,List) :- reverse(List,[X|_]).

% b: Reverse-accumulate
reverse(Xs,Ys) :- reverse(Xs,[],Ys).

reverse([X|Xs],Acc,Ys) :- reverse(Xs,[X|Acc],Ys).
reverse([],Ys,Ys).

%------------------------------------------------

% no pairs < one pair < two pairs < three of a kind < ﬂush < 
% straight < full house < four of a kind < straight flush.

% findHandType(H,T): T is type of Hand H.
findHandType(Hand,Type) :- 
	validHand(Hand),
	quicksort(Hand,SHand),
	(hasStraightFlush(SHand) -> Type =  straightFlush;
		(hasFourOfAKind(SHand) -> Type = fourOfAKind;
			(hasFullHouse(SHand) -> Type = fullHouse;
				(hasStraight(SHand) -> Type = straight;
					(hasFlush(SHand) -> Type = flush;
						(hasThreeOfAKind(SHand) -> Type = threeOfAKind;
							(hasTwoPairs(SHand) -> Type = twoPairs;
								(hasOnePair(SHand) -> Type = onePair;
									Type = noPair)))))))).

% hasStraightFlush(H): H has a straight as well as flush.
hasStraightFlush([card(S,X1),card(S,X2),card(S,X3),card(S,X4),card(S,X5)]) :- 
	immediateGreaterValue(X5,X4), immediateGreaterValue(X4,X3), 
	immediateGreaterValue(X3,X2), immediateGreaterValue(X2,X1).

% hasFourOfAKind(H): H has 4 cards with same value.
hasFourOfAKind([card(_,X1),card(_,X2),card(_,X2),card(_,X2),card(_,X3)]) :- 
	X2=X1; X2=X3.

% hasFullHouse(Hand): Hand has three cards with the same value but, 
% 	in different suits, and the other two cards have the same different value.
hasFullHouse([card(_,X2),card(_,X2),card(_,X3),card(_,X4),card(_,X4)]) :- 
	X3=X2; X3=X4.

% hasFlush(Hand): true when all cards in Hand has same Suit.
hasFlush([card(S,_),card(S,_),card(S,_),card(S,_),card(S,_)]).

% hasStraight(Hand): Hand has all cards with consecutive values.
hasStraight([card(_,X1),card(_,X2),card(_,X3),card(_,X4),card(_,X5)]) :- 
	immediateGreaterValue(X5,X4), immediateGreaterValue(X4,X3), 
	immediateGreaterValue(X3,X2), immediateGreaterValue(X2,X1).

% hasThreeOfAKind(H): H has 3 cards with same value.
hasThreeOfAKind([card(_,X1),card(_,X2),card(_,X3),card(_,X4),card(_,X5)]) :- 
	(X1=X2, X2=X3); (X2=X3, X3=X4); (X3=X4, X4=X5).

% hasTwoPair(H): H has two pairs.
hasTwoPairs([card(_,X1),card(_,X1),card(_,X3),card(_,X3),card(_,_)]).
hasTwoPairs([card(_,_),card(_,X1),card(_,X1),card(_,X3),card(_,X3)]).
hasTwoPairs([card(_,X1),card(_,X1),card(_,_),card(_,X3),card(_,X3)]).

% hasOnePair(H): H has one pair.
hasOnePair([card(_,X1),card(_,X2),card(_,X3),card(_,X4),card(_,X5)]) :-
	X1=X2; X2=X3; X3=X4; X4=X5.

%hasNoPair(Hand) :- 
%	\+ (hasOnePair(Hand);		hasTwoPairs(Hand);
%		hasThreeOfAKind(Hand);	hasStraight(Hand);
%		hasFlush(Hand);			hasFullHouse(Hand);
%		hasFourOfAKind(Hand);	hasStraightFlush(Hand)).

%----------------- TIE-BREAKS -------------------
% All these cases before GAME are for tie-breaks.

% betterDenomination(H1,H2,T,R): for tie-break of type T, R is winner
% 	out of H1 or H2.
betterDenomination(Hand1,Hand2,Type,R) :-
	((Type == fullHouse; Type == fourOfAKind; Type == twoPairs;
	Type == onePair; Type == noPair) -> 
		getDenomination5(Hand1,D1), getDenomination5(Hand2,D2),
		(winner(D1,D2,D1) -> R = Hand1;
			R = Hand2);
		getDenomination3(Hand1,E1), getDenomination3(Hand2,E2),
		(winner(E1,E2,E1) -> R = Hand1;
			R = Hand2)).

%------------------------------------------------
% works for noPair, onePair, twoPairs, fourOfAKind, fullHouse
% getDenomination5(H,D): D is value of highest card in H.
getDenomination5(Hand,D) :- 
	quicksort(Hand,S),
	hasPair(S,D).

% hasPair(H,P): P is value of highest paired card in H.
hasPair([card(_,X1),card(_,X2),card(_,X3),card(_,X4),card(_,X5)],Pair) :-
	( X4=X5 -> Pair = X4; 
		( X4=X3 -> Pair = X3; 
			( X3=X2 -> Pair = X2; 
				( X2=X1 -> Pair = X1;
					Pair = X5)))).

% winner(D1,D2,D): D is winner out of D1 or D2.
winner(D1,D2,D) :- 
	(greaterValue(D1,D2) -> D = D1;
		D = D2).

%------------------------------------------------
% works for straight, flush, straightFlush
% getDenomination3(H,D): D is value of highest card in H.
getDenomination3(Hand,D) :- 
	quicksort(Hand,S),
	last(card(_,D),S).

%-------------------- GAME ----------------------

% game begins here
% better_poker_hand(H1,H2,H): H is better hand out of H1 or H2.
better_poker_hand(Hand1,Hand2,R) :- 
	findHandType(Hand1,Type1),
	findHandType(Hand2,Type2),
	(Type1 == Type2 -> 
		betterDenomination(Hand1,Hand2,Type1,R);
		(greaterType(Type1,Type2) -> R = Hand1;
			R = Hand2)).

%------------------------------------------------