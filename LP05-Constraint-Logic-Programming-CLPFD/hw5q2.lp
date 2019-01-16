% CS6374: Computational Logic - Homework 05
% Rahul Nalawade [RSN170330]
% Date: 2018-03-26

:- use_module(library(clpfd)).

%-------------------------- Q2 ----------------------------
% Solves generic cryptarithmetic problems of any length for
% producing third list as sum of two lists.
%	    E A T
% + 	  T H A T
%-----------------
%  	A P P L E	

genCrypt([H1|T1] + [H2|T2] = [H3|T3]):- 
	%combines all varibales
	append([H1|T1],[H2|T2],Temp), 
	append(Temp,[H3|T3],Duplicates),

	%produce a distinct set
	list_to_set(Duplicates,DistictSet),
	%setting up the domains
	DistictSet ins 0..9, 
	%making all of them different
	all_distinct(DistictSet), 

	% trivial
	H1 #> 0, H2 #> 0, H3 #> 0,
	
	%evaluating their values
	value([H1|T1],S1), 
	value([H2|T2],S2), 
	value([H3|T3],S3), 
	S3 #= S1 + S2,

	%printing them
	labeling([],DistictSet).

% value([1,2,3],123). true.
value([],0).
value([H|T],V) :- 
	length(T,L), Base #= 10^L, 
	BaseValue #= Base * H,
	
	V #= V1 + BaseValue,
	value(T,V1).

%----------------------- COMMANDS -------------------------

%$ genCrypt([S,E,N,D] + [M,O,R,E] = [M,O,N,E,Y]).
%$ genCrypt([A,M] + [P,M] = [D,A,Y]).
%$ genCrypt([L,I,V,E] + [V,I,L,E] = [E,V,I,L]).

%$ genCrypt([B,I,K,E] + [R,I,D,E] = [R,O,A,D,S]).
%$ genCrypt([E,A,T] + [T,H,A,T] = [A,P,P,L,E]).
%$ genCrypt([D,O,N,A,L,D] + [G,E,R,A,L,D] = [R,O,B,E,R,T]).

%----------------------------------------------------------
