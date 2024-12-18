% helper.pl contains utility functions unrelated to the program
:- ['helper.pl'].

% a cell can be empty, a tree, or a tent
cells([empty, tree, tent]).

print_cell(empty) :- write(' ').
print_cell(tree)  :- write('*').
print_cell(tent)  :- write('^').

% board/4 generates a tent puzzle board of M * N with K trees
% board(0, _, Result, _, Result) :- !.
% board(I, TreeIdxs, Acc, N, Result) :-
% 	I_ is I - 1,
% 	( head(TreeIdxs, Hd), Hd =:= N - I_ ->
%  		tail(TreeIdxs, Tl),
% 		board(I_, Tl, [tree | Acc], N, Result)
% 	; board(I_, TreeIdxs, [empty | Acc], N, Result)).
% board(M, N, K, Result) :-
% 	Size is M * N,
% 	randset(K, Size, TreeIdxs),
% 	board(Size, TreeIdxs, [], Size, Cells),
% 	Result = (M, N, Cells).

row(_, 0, _, _, Result2, Result1, Result1, Result2) :- !.
row(R, C, M, N, TreeIdxs, Acc, Result1, Result2) :-
	C_ is C - 1,
	( head(TreeIdxs, Hd), Hd =:= (M - R) * N + (N - C_)  ->
 		tail(TreeIdxs, Tl),
		row(R, C_, M, N, Tl, [tree | Acc], Result1, Result2)
	; row(R, C_, M, N, TreeIdxs, [empty | Acc], Result1, Result2)).

board(0, _, _, _, _, Result, Result) :- !.
board(R, _, M, N, TreeIdxs, Acc, Result) :-
	row(R, N, M, N, TreeIdxs, [], Row, TreeIdxs_),
	R_ is R - 1,
	board(R_, _, M, N, TreeIdxs_, [Row | Acc], Result).
board(M, N, K, Result) :-
	randset(K, M * N, TreeIdxs),
	board(M, N, M, N, TreeIdxs, [], Cells),
	Result = (M, N, Cells).

print_row([]) :- !.
print_row([Hd | Tl]) :-
	print_cell(Hd), write(' '),
	print_row(Tl).

print_board((_, _, [])) :- !.
print_board((_, _, [Hd | Tl])) :-
	print_row(Hd), write('\n'),
	print_board((_, _, Tl)).

main :-
	board(2, 3, 5, Board),
	print_board(Board).