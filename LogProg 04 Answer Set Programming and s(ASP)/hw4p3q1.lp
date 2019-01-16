%"Apollo and Helios are lions in a zoo. Normally lions are dangerous. Baby lions 
%are not dangerous. Helios is a baby lion." Assume that the zoo has a complete list 
%of baby lions that it maintains regularly. Your program should be able to deduce 
%that Apollo is dangerous, whereas Helios is not. Make sure that
%(a) if you add another baby lion to knowledge base, the program would derive that 
%it is not dangerous, even though that knowledge is not explicit; and
%(b) if you add an explicit fact that Apollo is not dangerous, there is no 
%contradiction and the program answers intelligently.

lion(apollo). 
lion(helios).

lion(X) :- 
	baby_lion(X).

dangerous(X) :- 
	lion(X), 
	not baby_lion(X),
	not -dangerous(X).

-dangerous(X) :- 
	baby_lion(X).

-dangerous(apollo).

baby_lion(helios).
baby_lion(sam).

#show dangerous/1.
#show -dangerous/1.

% CWA:
% -father(X,Y) :- not father(X,Y).