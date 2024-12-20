% helper.pl contains utility functions unrelated to the program
:- ['helper.pl'].

% check_tents_row/5 is a helper function to check_tents/3
check_tents_row([], _, _, _, _) :- !.
check_tents_row([Cell | Tl], R, C, Y, X) :-
	\+ ( tent == Cell,
	     (Y =:= R - 1; Y =:= R; Y =:= R + 1),
	     (X =:= C - 1; X =:= C; X =:= C + 1)),
	C_ is C + 1,
	check_tents_row(Tl, R, C_, Y, X).

% check_tents/3 checks whether there are no tents at (Y,X) and all 8 of its neighbors
% this is because tents cannot be adjacent to each other
check_tents([], _, _, _) :- !.
check_tents([Row | Tl], R, Y, X) :-
	check_tents_row(Row, R, 0, Y, X),
	R_ is R + 1,
	check_tents(Tl, R_, Y, X).
check_tents(Cells, Y, X) :-
	check_tents(Cells, 0, Y, X).

% modify_cell_row/7 is a helper function to modify_cell/5
modify_cell_row([], _, _, _, _, _, []) :- !.
modify_cell_row([_ | Tl], Y, X, Y, X, Value, [Value | Result]) :- !,
	X_ is X + 1,
	modify_cell_row(Tl, Y, X_, Y, X, _, Result).
modify_cell_row([Cell | Tl], R, C, Y, X, Value, [Cell | Result]) :-
	C_ is C + 1,
	modify_cell_row(Tl, R, C_, Y, X, Value, Result).

% modify_cell/5 gives a new Cells with Value at (Y,X)
% if (Y,X) is out of range, Result = Cells
modify_cell([], _, _, _, _, []) :- !.
modify_cell([Row | Tl], R, Y, X, Value, [Row_ | Result]) :-
	modify_cell_row(Row, R, 0, Y, X, Value, Row_),
	R_ is R + 1,
	modify_cell(Tl, R_, Y, X, Value, Result).
modify_cell(Cells, Y, X, Value, Result) :-
	modify_cell(Cells, 0, Y, X, Value, Result).

% place_tents/5 randomly places K tents on a board
% check_tents/3 makes sure that there are no tent neighbors at (Y,X)
% if the max depth is reached, it is assumed that there is no valid tent placement to be done anymore, so the building starts anew
place_tents(_, _, Cells, 0, _, Cells, Tents, Tents) :- !.
place_tents(_, _, _, _, 0, _, _, _) :- !, fail.
place_tents(M, N, Cells, K, Depth, Cells_, TentsIn, TentsOut) :-
	random(0, M, Y),
	random(0, N, X),
	( check_tents(Cells, Y, X) ->
		modify_cell(Cells, Y, X, tent, Cells__),
		K_ is K - 1,
		I is Y * N + X,
		place_tents(M, N, Cells__, K_, Depth, Cells_, [I | TentsIn], TentsOut)
	;
		Depth_ is Depth - 1,
        	place_tents(M, N, Cells, K, Depth_, Cells_, TentsIn, TentsOut)).
place_tents(M, N, Cells, K, Cells_, Tents) :-
	( place_tents(M, N, Cells, K, 10, Cells__, [], Tents) ->
		Cells_ = Cells__
	; place_tents(M, N, Cells, K, Cells_, Tents)).

% check_tents_row/5 is a helper function to check_tents/3
get_empties_row([], _, _, _, _, Result, Result) :- !.
get_empties_row([Cell | Tl], R, C, Y, X, Acc, Result) :-
	C_ is C + 1,
	( empty == Cell,
	  (((Y =:= R - 1; Y =:= R + 1), X =:= C);
	    (Y =:= R, (X =:= C - 1; X =:= C + 1))) ->
		get_empties_row(Tl, R, C_, Y, X, [(R, C) | Acc], Result)
	;
		get_empties_row(Tl, R, C_, Y, X, Acc, Result)).

% check_tents/3 checks whether there are no tents at (Y,X) and all 8 of its neighbors
% this is because tents cannot be adjacent to each other
get_empties([], _, _, _, Result, Result) :- !.
get_empties([Row | Tl], R, Y, X, Acc, Result) :-
	get_empties_row(Row, R, 0, Y, X, Acc, Acc_),
	R_ is R + 1,
	get_empties(Tl, R_, Y, X, Acc_, Result).
get_empties(Cells, Y, X, Result) :-
	get_empties(Cells, 0, Y, X, [], Result).

place_trees(_, Result, [], Result) :- !.
place_trees(N, Cells, [I | Tl], Result) :-
	R is I // N,
	C is mod(I, N),
	get_empties(Cells, R, C, Empties),
	\+ empty(Empties),
	get_random(Empties, (Y, X)),
	modify_cell(Cells, Y, X, tree, Cells_), 
	place_trees(N, Cells_, Tl, Result).

% build_row/2 builds an empty row of a Tents and Trees puzzle board of size N
% is a helper function to build_board/4
remove_tents_row([], []) :- !.
remove_tents_row([tent | Tl], [empty | Acc]) :- !,
	remove_tents_row(Tl, Acc).
remove_tents_row([Cell | Tl], [Cell | Acc]) :-
	remove_tents_row(Tl, Acc).

% build_board/4 builds a valid Tents and Trees puzzle board of size M * N with K trees
remove_tents([], []) :- !.
remove_tents([Row | Tl], [Row_ | Acc]) :-
	remove_tents_row(Row, Row_),
	remove_tents(Tl, Acc).

% build_row/2 builds a row of a Tents and Trees puzzle board of size N
% is a helper function to build_board/4
build_row(0, _, []) :- !.
build_row(C, Cell, [Cell | Tl]) :-
	C_ is C - 1,
	build_row(C_, Cell, Tl).

% build_counts_y_(_, [], Result, Result) :- !.
% build_counts_y_(N, [I | Tl], Counts, Result) :-
% 	R is I // N,
% 	inc(Counts, R, Counts_),
% 	build_counts_y_(N, Tl, Counts_, Result).
% build_counts_y(M, N, Tents, Result) :-
% 	build_row(M, 0, Counts),
% 	build_counts_y_(N, Tents, Counts, Result).

build_counts(_, [], CountsY, CountsX, CountsY, CountsX) :- !.
build_counts(N, [I | Tl], CountsY, CountsX, CountsY_, CountsX_) :-
	R is I // N,
	C is mod(I, N),
	inc(CountsY, R, CountsY__),
	inc(CountsX, C, CountsX__),
	build_counts(N, Tl, CountsY__, CountsX__, CountsY_, CountsX_).
build_counts(M, N, Tents, CountsY, CountsX) :-
	build_row(M, 0, CountsY_),
	build_row(N, 0, CountsX_),
	build_counts(N, Tents, CountsY_, CountsX_, CountsY, CountsX).

% build_board/4 builds a valid Tents and Trees puzzle board of size M * N with K trees
build_board(0, _, []) :- !.
build_board(R, N, [Row | Acc]) :-
	build_row(N, empty, Row),
	R_ is R - 1,
	build_board(R_, N, Acc).
build_board(M, N, K, Result) :-
	1 < M, 1 < N, 0 < K,
	% add constraint for max K here...
	build_board(M, N, Cells),
	place_tents(M, N, Cells, K, Cells_, Tents),
	( place_trees(N, Cells_, Tents, Cells__) ->
		remove_tents(Cells__, Cells___),
		build_counts(M, N, Tents, CountsY, CountsX),
		Result = (M, N, CountsY, CountsX, Cells___)
	; build_board(M, N, K, Result)).