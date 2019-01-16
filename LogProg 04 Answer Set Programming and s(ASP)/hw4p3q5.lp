%"A field that studies pure ideas does not study the natural world. A
% field that studies the natural world does not study the pure ideas.
% Mathematics normally studies pure ideas. Science normally studies 
% the natural world. As a computer scientist, Daniela studies both 
% mathematics and science. Both mathematics and science study our 
% place in the world."
%
% Make sure your program can deduce that Daniela studies our place in the world.

field(mathematics).
field(science).

studies_natural_world(X) :- 
	field(X),
	not studies_pure_ideas(X).

studies_pure_ideas(X) :- 
	field(X),
	not studies_natural_world(X).

studies_pure_ideas(X) :- 
	field(X), 
	X == mathematics,
	not ab_pi(X).

studies_natural_world(X) :-
	field(X),
	X == science,
	not ab_nw(X).

ab_pi(X) :- 
	X == science.

ab_nw(X) :- 
	X == mathematics.

person(daniela).

%studies(daniela,mathematics).
%studies(daniela,science).
studies(X,Y) :- 
	person(X), field(Y).

studies_our_place_in_the_world(P) :- 
	studies(P,mathematics),
	studies(P,science),
	person(P).
