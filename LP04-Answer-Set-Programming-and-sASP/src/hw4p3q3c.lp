% "American citizens normally live in United States. American diplomats
% may or may not live in the United States. John, Miriam, and Caleb 
% are American citizens. John lives in Italy. Miriam is an American 
% Diplomat."

% a. Assume we do not have complete list of American diplomats. 
% (Note that your program should not be able to conclude that Caleb 
% lives in United States.)

% b. Now assume we have a complete list of American diplomats. Add 
% this information to the program. What does your new program say 
% about Caleb's place of residence?

% c. Rewrite the program from 3b by using the simplified form of the 
% cancellation axiom.

country(united_states;italy).
american_citizen(john;miriam;caleb).
american_diplomat(miriam).

% CWA: american_diplomats: UNCOMMENT for part b
-american_diplomat(X) :- 
    american_citizen(X),
    not american_diplomat(X).

% ABNORMAL: from part a
ab_citizen(X) :- 
    american_citizen(X),
    not -american_diplomat(X). % Cancellation axiom part c

live_in(john,italy).

% Normally american_citizens live in united_states
live_in(X,united_states) :-
    american_citizen(X),
    %-american_diplomat(X), % NO NEED HERE, see line no 27
    not ab_citizen(X),
    not -live_in(X,united_states).

% Diplomat may or may not live in united_states:
    % Diplomat living in united_states
    live_in(X,united_states) :- 
        not -live_in(X,united_states), 
        american_diplomat(X).

    % Diplomat not living in united_states
    -live_in(X,united_states) :- 
        not live_in(X,united_states), 
        american_diplomat(X).

% Person can live only in one country
-live_in(X,Z) :-
    american_citizen(X), country(Z),
    live_in(X,Y), country(Y), Y != Z.

#show live_in/2.
#show -live_in/2.