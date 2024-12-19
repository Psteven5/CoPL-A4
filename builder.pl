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
place_tents(_, _, Result, 0, _, Result) :- !.
place_tents(_, _, _, _, 0, _) :- !,
	fail.
place_tents(M, N, Cells, K, Depth, Result) :-
	random(0, M, Y),
	random(0, N, X),
	( check_tents(Cells, Y, X) ->
		modify_cell(Cells, Y, X, tent, Cells_),
		K_ is K - 1,
		place_tents(M, N, Cells_, K_, Depth, Result)
	;
		Depth_ is Depth - 1,
		place_tents(M, N, Cells, K, Depth_, Result)).
place_tents(M, N, Cells, K, Result) :-
	( place_tents(M, N, Cells, K, 13, Cells_) ->
		Result = Cells_
	; place_tents(M, N, Cells, K, Result)).

% build_row/2 builds an empty row of a Tents and Trees puzzle board of size N
% is a helper function to build_board/4
build_row(0, []) :- !.
build_row(C, [empty | Tl]) :-
	C_ is C - 1,
	build_row(C_, Tl).

% build_board/4 builds a valid Tents and Trees puzzle board of size M * N with K trees
build_board(0, _, []) :- !.
build_board(R, N, [Row | Acc]) :-
	build_row(N, Row),
	R_ is R - 1,
	build_board(R_, N, Acc).
build_board(M, N, K, (M, N, Cells_)) :-
	1 < M, 1 < N, 0 < K,
	% add constraint for max K here...
	build_board(M, N, Cells),
	place_tents(M, N, Cells, K, Cells_).