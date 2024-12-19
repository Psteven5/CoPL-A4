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

% rm_idx/3 removes item from List at index Idx
rm_idx(0, [_ | Tl], Tl).
rm_idx(Idx, [Hd | Tl], [Hd | NewTl]) :-
    Idx > 0,
    NextIdx is Idx - 1,
    rm_idx(NextIdx, Tl, NewTl).

% sum/2 calculates the sum of a list of integers
sum([], 0).
sum([Hd | Tl], Sum) :-
    sum(Tl, TlSum),
    Sum is Hd + TlSum.
