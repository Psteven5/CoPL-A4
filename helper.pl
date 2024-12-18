% head/2 gets the first Item in List
head([Hd | _], Hd).

% tail/2 gets the tail of List
tail([_ | Tl], Tl).

% find/3 gets the index of Item if it is in List
find([Item | _], Item, Result, Result) :- !.
find([_ | Tl], Item, I, Result) :-
	I_ is I + 1,
	find(Tl, Item, I_, Result).
find(List, Item, Result) :-
	find(List, Item, 0, Result).
