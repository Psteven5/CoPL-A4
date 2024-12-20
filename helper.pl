% empty/1 returns whether List is empty
empty([]).

% head/2 returns the first Item in List
head([Hd | _], Hd).

% tail/2 returns the tail of List
tail([_ | Tl], Tl).

% get/3 returns Item at index I in List
get([Result | _], 0, Result) :- !.
get([_ | Tl], I, Result) :-
	I_ is I - 1,
	get(Tl, I_, Result).	

get_random(List, Result) :-
	length(List, Length),
	random(0, Length, I),
	get(List, I, Result).

% find/3 returns the index of Item if it is in List
find([Item | _], Item, Result, Result) :- !.
find([_ | Tl], Item, I, Result) :-
	I_ is I + 1,
	find(Tl, Item, I_, Result).
find(List, Item, Result) :-
	find(List, Item, 0, Result).

% inc/3 increments Item at index I in List
inc([], _, []) :- !.
inc([Item | Tl], 0, [Item_ | Acc]) :- !,
	Item_ is Item + 1,
	inc(Tl, -1, Acc).
inc([Item | Tl], I, [Item | Acc]) :-
	I_ is I - 1,
	inc(Tl, I_, Acc).

% rm_idx/3 removes item from List at index Idx
rm_idx([_ | Tl], 0, Tl).
rm_idx([Hd | Tl], Idx, [Hd | NewTl]) :-
    Idx > 0,
    NextIdx is Idx - 1,
    rm_idx(Tl, NextIdx, NewTl).

% sum/2 calculates the sum of a list of integers
sum([], 0).
sum([Hd | Tl], Sum) :-
    sum(Tl, TlSum),
    Sum is Hd + TlSum.

% get_col/3 returns a column of Matrix at Idx as a List
get_col([], _, []).
get_col([Row | RestRows], Idx, [Elem | RestElem]) :-
    find(Row, Elem, 0, Idx),
    get_col(RestRows, Idx, RestElem).

% insert/4 inserts Elem at Idx in List
insert(Tl, 0, Elem, Result) :- Result = [Elem | Tl].
insert([Hd | Tl], Idx, Elem, Result) :-
    Idx > 0,
    NewIdx is Idx - 1,
    insert(Tl, NewIdx, Elem, Rest),
    Result = [Hd | Rest].

% get_elems/2 goes over every element of a list
get_elems(Elem, [Elem|_]).
get_elems(Elem, [_|Tail]) :-
    get_elems(Elem, Tail).

% split_at/4 splits a List at the first instance of Num
split_at([Hd | Tl], Hd, [], Tl) :- !.
split_at([Hd | Tl], Num, [Hd | Fst], Lst) :-
    split_at(Tl, Num, Fst, Lst), !.

% list_length/2 calculates the length of List
list_len([], 0).
list_len([_ | Tl], Length) :-
    list_len(Tl, TlLength),
    Length is TlLength + 1.
