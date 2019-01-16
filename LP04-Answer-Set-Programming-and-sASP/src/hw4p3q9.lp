% Using the notions of hierarchy and defaults as detailed in Section 5.4, write 
% an ASP program to represent the following information. Be as general as you can. 
%   
%   1. A Selmer Mark VI is a saxophone.
%   2. Jake's saxophone is a Selmer Mark VI.
%   3. Mo's saxophone is a Selmer Mark VI.
%   4. Part of a saxophone is a high D key.
%   5. Part of the high D key is a spring that makes it work.
%   6. The spring is normally not broken.
%   7. Mo's spring for his high D key is broken. 
%
% Make sure that your program correctly entails that Jake's saxophone works while 
% Mo's is broken. For simplicity, assume that no one has more than one saxophone, 
% and hence, saxophones can be identified by the name of their owner.

%   1. A Selmer Mark VI is a saxophone.
saxophone(sm6). 
part(spring). part(high_D_key).

%   2. Jake's saxophone is a Selmer Mark VI.
%   3. Mo's saxophone is a Selmer Mark VI.
has(jake,sm6). has(mo,sm6).
%   4. Part of a saxophone is a high D key.
-is_part(Sub,Super) :- part(Sub),
    part(Super); saxophone(Super),
    not is_part(Sub,Super).

is_part(high_D_key,sm6).
is_part(spring,high_D_key).

%   5. Part of the high D key is a spring that makes it work.
is_part(Sub,Super) :- Sub != Super, 
    is_part(Sub2,Super),
    is_part(Sub,Sub2).

works(Person,Sxp) :-
    saxophone(Sxp), has(Person,Sxp),
    is_part(spring,Sxp),
    -broken(Person,spring).

-works(Person,Sxp) :-
    saxophone(Sxp), has(Person,Sxp),
    not works(Person,Sxp).

%   6. The spring is normally not broken.
-broken(Person,spring) :- 
    has(Person,Sxp), saxophone(Sxp),
    owns(Person,spring),
    not broken(Person,spring).

%   7. Mo's spring for his high D key is broken. 
owns(Person,Part) :- has(Person,Sxp), 
    saxophone(Sxp),is_part(Part,Sxp),
    not -is_part(Part,Sxp).

broken(mo,spring).