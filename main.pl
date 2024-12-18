% helper.pl contains utility functions unrelated to the program
:- ['helper.pl'].

% a cell can be empty, a tree, or a tent
cells([empty, tree, tent]).

print_cell(Cell) :-
	( empty == Cell ->
		write(' ')
	; tree == Cell ->
		write('*')
	; tent == Cell ->
		write('%')).

% board/4 generates a tent puzzle board of M * N with K trees
board(0, _, Result, _, Result) :- !.
board(I, TreeIdxs, Acc, N, Result) :-
	I_ is I - 1,
	( head(TreeIdxs, Hd), Hd =:= N - I_ ->
 		tail(TreeIdxs, Tl),
		board(I_, Tl, [tree | Acc], N, Result)
	; board(I_, TreeIdxs, [empty | Acc], N, Result)).
board(M, N, K, Result) :-
	Size is M * N,
	randset(K, Size, TreeIdxs),
	board(Size, TreeIdxs, [], Size, Cells),
	Result = (M, N, K, Cells).

print_row(0, Result, Result) :- !.
print_row(I, [Hd | Tl], Result) :-
	print_cell(Hd), write(' '),
	I_ is I - 1,
	print_row(I_, Tl, Result).

print_board((0, _, _, _)) :- !.
print_board((I, N, K, Cells)) :-
	print_row(N, Cells, Tl), write('\n'),
	I_ is I - 1,
	print_board((I_, N, K, Tl)).

main :-
	board(3, 3, 3, Board),
	print_board(Board).