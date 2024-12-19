% head/2 returns the first Item in List
head([Hd | _], Hd).

% tail/2 returns the tail of List
tail([_ | Tl], Tl).

% get/3 returns Item at index I in List
get([Result | _], 0, Result) :- !.
get([_ | Tl], I, Result) :-
	I_ is I - 1,
	get(Tl, I_, Result).	

% find/3 returns the index of Item if it is in List
find([Item | _], Item, Result, Result) :- !.
find([_ | Tl], Item, I, Result) :-
	I_ is I + 1,
	find(Tl, Item, I_, Result).
find(List, Item, Result) :-
	find(List, Item, 0, Result).