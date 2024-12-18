% helper.pl contains utility functions unrelated to the program
:- ['helper.pl'].

% a cell can be empty, a tree, or a tent
cells([empty, tree, tent]).

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
	board(Size, TreeIdxs, [], Size, Result).
