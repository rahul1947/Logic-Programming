% CS6374: Computational Logic - Homework 04
% Rahul Nalawade [RSN170330]
% Date: 2018-03-25

%-------------------------- Q2 ----------------------------
%State is represented by a list of relations on(X,Y),
% where X is a block and Y is a block or a place. 

%?- testPlan(test2,Plan), length(Plan,L), writeList(Plan).
% transform([on(b,a),on(a,p),on(c,q),on(e,d),on(d,r)],[on(e,d),on(d,p),on(b,q),on(a,c),on(c,r)],Plan), length(Plan,L), writeList(Plan).
%----------------------------------------------------------

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
    not member(State,Visited),
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


member(X, [X| _]).
member(X, [Y| T]) :- X \= Y, member(X, T).

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
clear(X,State) :- not member(on(A,X),State).

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
substitute(_,_,[],[]). 

substitute(X,Y,[X|T1],[Y|T2]) :-
    substitute(X,Y,T1,T2).

substitute(X,Y,[Z|T1],[Z|T2]) :-
    Z \= X,
    substitute(X,Y,T1,T2).

% permute(P,R): R is a permutation of list P.
permute([],[]).
permute(P,[R|Rs]) :-
    select(R,P,T), permute(T,Rs).

% select(X,List,R): R is a List with one removed X
select(X,[X|T],T).
select(X,[H|T],[H|R]) :- %X \= H, 
    select(X,T,R).

% writes the List [H|T].
writeList([]) :- nl.
writeList([H|T]) :- write(H), write(' '), writeList(T).

%--------------------- OPTIMIZATION -----------------------
truncateMoves([E],[E]).
truncateMoves([],[]).

% toBlock - toBlock
truncateMoves([toBlock(X,Y,Z), toBlock(X,Z,W) | T], [toBlock(X,Y,W) | R]) :-
    truncateMoves(T,R).

truncateMoves([toBlock(X,A,B), toBlock(Y,P,Q) | T], [toBlock(X,A,B), toBlock(Y,P,Q) | R]) :-
    X \= Y, truncateMoves(T,R).

% toBlock - toPlace
truncateMoves([toBlock(X,Y,Z), toPlace(X,Z,W) | T], [toPlace(X,Y,W) | R]) :-
    truncateMoves(T,R).

truncateMoves([toBlock(X,A,B), toPlace(Y,P,Q) | T], [toBlock(X,A,B), toPlace(Y,P,Q) | R]) :-
    X \= Y, truncateMoves(T,R).

% toPlace - toBlock
truncateMoves([toPlace(X,Y,Z), toBlock(X,Z,W) | T], [toBlock(X,Y,W) | R]) :-
    truncateMoves(T,R).

truncateMoves([toPlace(X,A,B), toBlock(Y,P,Q) | T], [toPlace(X,A,B), toBlock(Y,P,Q) | R]) :-
    X \= Y, truncateMoves(T,R).

% toPlace - toPlace
truncateMoves([toPlace(X,Y,Z), toPlace(X,Z,W) | T], [toPlace(X,Y,W) | R]) :-
    truncateMoves(T,R).

truncateMoves([toPlace(X,A,B), toPlace(Y,P,Q) | T], [toPlace(X,A,B), toPlace(Y,P,Q) | R]) :-
    X \= Y, truncateMoves(T,R).

% optimizes list L to list P until same length.
optimizedMoves(L,P) :-
    truncateMoves(L,R),
    length(L,L1), length(R,R1), L1 > R1,
    optimizedMoves(R,P).

optimizedMoves(L,R) :-
    truncateMoves(L,R),
    length(L,L1), length(R,L1), 
    write(L1), nl,
    writeList(R).
%----------------------------------------------------------
%show update/3.
?- transform([on(b,a),on(a,p),on(c,q),on(e,d),on(d,r)],[on(e,d),on(d,p),on(b,q),on(a,c),on(c,r)],Plan).