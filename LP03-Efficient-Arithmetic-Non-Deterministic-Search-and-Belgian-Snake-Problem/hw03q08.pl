% CS6374: Computational Logic - Homework 03
% Rahul Nalawade [RSN170330]
% Date: 2018-02-18

%-------------------------- Q8 ----------------------------
%State is represented by a list of relations on(X,Y),
% where X is a block and Y is a block or a place. 

%?- testPlan(test2,Plan), length(Plan,L), writeList(Plan).
% transform([on(b,a),on(a,p),on(c,q),on(e,d),on(d,r)],[on(e,d),on(d,p),on(b,q),on(a,c),on(c,r)],Plan), length(Plan,L), writeList(Plan).
%----------------------------------------------------------
testPlan(Name,Plan) :- 
	initial(Name,I), final(Name,F),
	transform(I,F,Plan).

initial(test1,[on(a,b),on(b,p),on(c,r)]).
initial(test2,[on(b,a),on(a,p),on(c,q),on(e,d),on(d,r)]).

final(test1,[on(a,b),on(b,c),on(c,r)]).
final(test2,[on(e,d),on(d,p),on(b,q),on(a,c),on(c,r)]).

block(a). block(b). block(c). block(d). block(e).

place(p). place(q). place(r). 

%----------------------------------------------------------
% transform(S1,S2,P): P is plan of actions that is produced
% to transform from state S1 to state S2.
transform(State1,State2,Plan) :- 
	transform(State1,State2,[State1],Plan).

%transform(State,State,Visited,[]).
transform(State1,State2,Visited,[]) :- 
	permute(State1,State2).

transform(State1,State2,Visited,[Action|Actions]) :- 
	%legalAction(Action,State1),
	chooseAction(Action,State1,State2),
	update(Action,State1,State),
	\+ member(State,Visited),
	transform(State,State2,[State|Visited],Actions).

% chooses a legal action Action from state State1, 
% to see if we can reach State2 by taking Action  
chooseAction(Action,State1,State2) :- 
	suggest(Action,State2), legalAction(Action,State1).

% Else, chooses the legal action Action from State1.
chooseAction(Action,State1,State2) :- 
	legalAction(Action,State1).

% will suggest to go in state State, if we find
% on(X,Z) in state State, Z can be place or block.
suggest(toPlace(X,Y,Z), State) :-
	member(on(X,Z),State), place(Z).

suggest(toBlock(X,Y,Z), State) :- 
	member(on(X,Z),State), block(Z).

% moving a block Block to a place Place, from state State.
legalAction(toPlace(Block,Y,Place),State) :- 
	%ERROR: on(Block,Y,State), % on(Block,Y) in state State
	member(on(Block,Y),State),
	clear(Block,State), % nothing on Block in state State
	place(Place), clear(Place,State). % place Place is clear in state State.

% moving a block Block1 to another block Block2, from state State.
legalAction(toBlock(Block1,Y,Block2),State) :- 
	%ERROR on(Block1,Y,State), 
	member(on(Block1,Y), State), 
	clear(Block1,State),
	block(Block2), Block1 \= Block2,
	clear(Block2,State).

% in state State, there is nothing on X, 
clear(X,State) :- \+ member(on(A,X),State).

% we have on(X,Y) in state State.
on(X,Y,State) :- member(on(X,Y), State).

% updates State to State1, as X is moved from Y to Z
update(toBlock(X,Y,Z), State, State1) :- 
	substitute(on(X,Y),on(X,Z),State,State1).

update(toPlace(X,Y,Z), State, State1) :- 
	substitute(on(X,Y),on(X,Z),State,State1).


%-------------------- OLD PREDICATES ----------------------
% Program 9.3 for substitute.
% substitute(Old,New,OldTerm,NewTerm): NewTerm is the result
% of replacing all occurrences of Old in OldTerm by New.

substitute(Old,New,Old,New).

substitute(Old,_,Term,Term) :- 
	constant(Term), Term \== Old.

substitute(Old,New,Term,Term1) :- 
	compound(Term), functor(Term,F,N), 
	functor(Term1,F,N), substitute(N,Old,New,Term,Term1).

substitute(N,Old,New,Term,Term1) :-
	N > 0, arg(N,Term,Arg), 
	substitute(Old,New,Arg,Arg1),
	arg(N,Term1,Arg1), N1 is N-1, 
	substitute(N1,Old,New,Term,Term1).

substitute(0,_,_,_,_).

constant(X) :- atomic(X).

% permute(P,R): R is a permutation of list P.
permute([],[]).
permute(P,[R|Rs]) :-
	select(R,P,T), permute(T,Rs).

% writes the List [H|T].
writeList([]) :- nl.
writeList([H|T]) :- write(H), write(' '), writeList(T).

%----------------------------------------------------------