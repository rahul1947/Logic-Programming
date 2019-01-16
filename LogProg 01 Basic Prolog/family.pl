% CS6374: Computational Logic - Assignment 01
% Rahul Nalawade [RSN170330]
% Date: 2018-01-18 

% Assumption 01: To be called as 'married', 
% 	one needs to have atleast a child.

% Fact (which I didnt knew): 
% 1. husband of ones sisterinlaw = brotherinlaw
% 2. wife of ones brotherinlaw = sisterinlaw 
% 3. nepehew/niece = son/daughter of sibling OR 
% 		son/daughter of ones married sibling

%-------------------------------- Q1 --------------------------------
male(tony).	male(abe).	male(bill).	
male(john).	male(rob).	male(jack).
male(phil).	male(rick).	male(jim).

female(lisa).	female(nancy).	female(sarah).
female(mary).	female(susan).	female(jill).	
female(ann).	female(martha).	female(kim).

% female(X) :- \+ male(X).

father(tony, abe).	father(tony, sarah).
father(abe, john).	father(bill, susan).	father(john, jill).
father(rob, jack).	father(rob, phil).		father(jack, jim).	
%father(jack, kim).	%father(phil, ann).		%father(jim, martha).

mother(lisa, abe).		mother(lisa, sarah).	mother(nancy, john).
mother(sarah, susan).	mother(mary, jill).
mother(susan, jack).	mother(susan, phil).
%mother(jill, rick).

%-------------------------------- Q2 --------------------------------

% a father or a mother.
parent(X,Y) :- father(X,Y).

parent(X,Y) :- mother(X,Y).

child(X,Y) :- parent(Y,X).

% https://www.csee.umbc.edu/~finin/prolog/sibling/siblings.html
% sibling: one with same or common parent(s)
sibling(X,Y) :- 
	setof((X,Y), 
		P^(parent(P,X),parent(P,Y),\+X=Y), Sibs),
	member((X,Y), Sibs).

son(X,Y) :- 
	male(X), parent(Y,X).

daughter(X,Y) :- 
	female(X), parent(Y,X).

% male sibling
brother(X,Y) :- 
	male(X), sibling(X,Y). 

% female sibling
sister(X,Y) :- 
	female(X), sibling(X,Y). 

% a parent of ones father or mother (parent)
grandparent(X,Y) :- 
	parent(X,Z), parent(Z,Y).

% Extended married(X,Y) facts due to Q4.
married(jill,rick).		married(rick,jill).	married(jack,kim).
married(kim,jack).		married(phil,ann).	married(ann,phil).
married(jim,martha).	married(martha,jim).

% married(X,Y): X and Y have atleast one child/offspring
married(X,Y) :- 
	setof((X,Y), 
		Z^(parent(X,Z),parent(Y,Z),\+X=Y), Pairs),
	member((X,Y), Pairs).

husband(X,Y) :- 
	married(X,Y), male(X).

wife(X,Y) :-
	married(X,Y), female(X).

% uncle: brother of ones mother or father
uncle(X,Y) :- 
	parent(Z,Y), brother(X,Z).

% *uncle: husband of aunt
% uncle(X,Y) :- 
%	aunt(Z,Y), husband(X,Z).


% aunt: sister of ones father or mother
aunt(X,Y) :- 
	parent(Z,Y), sister(X,Z).

% *aunt: wife of uncle
% aunt(X,Y) :- 
%	uncle(Z,Y), wife(X,Z).

% *uncle: husband of aunt and vice-versa, causes looping infinitely!

% husband of ones sister
brotherinlaw(X,Y) :- 
	sister(Z,Y), husband(X,Z).

% brother of ones wife or husband
brotherinlaw(X,Y) :- 
	married(Z,Y), brother(X,Z).

% *brotherinlaw: husband of ones sisterinlaw
% brotherinlaw(X,Y) :- 
%	sisterinlaw(Z,Y), husband(X,Z).

% sister of ones husband or wife
sisterinlaw(X,Y) :- 
	married(Z,Y), sister(X,Z), X \= Y.

% wife of ones brother
sisterinlaw(X,Y) :- 
	brother(Z,Y), wife(X,Z).

% *sisterinlaw: wife of ones brotherinlaw
% sisterinlaw(X,Y) :- 
%	brotherinlaw(Z,Y), wife(X,Z).

% *sisterinlaw: wife of brotherinlaw and vice-versa, causes
% looping infinitely!

%------------------------------- Q2a --------------------------------

% fcousin(X,Y): X and Y are first cousins
% child of ones uncle or aunt
fcousin(X,Y) :- 
	uncle(Z,Y), child(X,Z).

fcousin(X,Y) :- 
	aunt(Z,Y), child(X,Z).

%------------------------------- Q2b --------------------------------

% scousin(X,Y): X and Y are second cousins
% child of (ones parents first cousin)
scousin(X,Y) :- 
	parent(W,Y), fcousin(Z,W), child(X,Z).

%------------------------------- Q2c --------------------------------

% grnephew(X,Y): X is grand nephew of Y
% son of ones nephew or niece
grnephew(X,Y) :- 
	nephew(Z,Y), son(X,Z).

grnephew(X,Y) :- 
	niece(Z,Y), son(X,Z).

%------------------------------- Q2d --------------------------------

nephew(X,Y) :- 
	setof((X,Y), 
		Z^(sibling(Z,Y), son(X,Z), \+X=Y), Paired),
	member((X,Y), Paired).

nephew(X,Y) :- 
	setof((X,Y),
		Z^(married(Y,W),sibling(W,Z),son(X,Z),\+X=Y), Paired),
	member((X,Y), Paired).

% male child of ones sibling
% nephew(X,Y) :-
%	sibling(Z,Y), son(X,Z).

% son of ones brotherinlaw or sisterinlaw
% nephew(X,Y) :- 
%	son(X,Z), brotherinlaw(Z,Y).

% nephew(X,Y) :- 
%	son(X,Z), sisterinlaw(Z,Y).

%--------------------------------------------------------------------

% niece(X,Y): X is a niece of Y
% female child of ones sibling
% niece(X,Y) :-
%	sibling(Z,Y), daughter(X,Z).

% daughter of ones brotherinlaw or sisterinlaw
% niece(X,Y) :- 
%	brotherinlaw(Z,Y), daughter(X,Z).

% niece(X,Y) :- 
%	sisterinlaw(Z,Y), daughter(X,Z).

niece(X,Y) :- 
	setof((X,Y), 
		Z^(sibling(Z,Y), daughter(X,Z),\+X=Y), Paired),
	member((X,Y), Paired).

niece(X,Y) :- 
	setof((X,Y), 
		Z^(married(Y,W),sibling(W,Z),daughter(X,Z),\+X=Y), Paired),
	member((X,Y), Paired).

%------------------------------- Q2e --------------------------------

% manc(X,Y): X is a male ancestor of Y
ancestor(X,Y) :- parent(X,Y).

ancestor(X,Y) :- 
	parent(Z,Y), ancestor(X,Z).

manc(X,Y) :- 
	male(X), ancestor(X,Y).

%-------------------------------- Q3 --------------------------------

% Define a rule for checking if X and Y are “cousins of the same
% generation,” i.e., X and Y are descendents of a common person
% and both are same no. of links down from the common ancestor. 

generation(X,G):-	
	%X=='lisa'-> G=1;
	X=='tony' -> G=1;
	parent(P,X),
	generation(P,G1),
	G is G1 + 1.

%generations(X,G) :- 
%	findall(Y,generation(Y,G),X).

samegeneration(X,Y) :- 
	setof((X,Y), 
		G^(generation(X,G),generation(Y,G),\+X=Y), Samegen),
	member((X,Y), Samegen).

%-------------------------------- Q4 --------------------------------

% Suppose the double arrows depict the relationship “married.” Two 
% individuals are also married if they have a common offspring. 
% Rewrite the rules grnephew and niece taking into account 
% relationships by marriage also.

% ANSWER: 
% Already done above. Please, goto line 150-206 for 
% grnephew, nephew and niece definitions.

% Also, double arrow relationships, which were considered as 
% parent-child, are commented and replaced by married(X,Y) facts, 
% which are added at the beginning of married predicate. Line no. 69.

%-------------------------------- Q5 --------------------------------

% Draw the search tree that Prolog will create for the query 
% manc(bill,jim) using your definition above.

% https://stackoverflow.com/questions/40086736/how-to-redirect-trace-output-to-a-file

% $ prolog -s familyPRO.pl 
% ?- leash(-all). 
% ?- visible(+all).
% ?- protocol('./traceOutput.txt').
% ?- trace.
% ?- manc(bill,jim).
% ?- nodebug.
% ?- noprotocol.
% ?- halt.

% please, find the attached file 'traceOutput.txt' 
%--------------------------------------------------------------------
