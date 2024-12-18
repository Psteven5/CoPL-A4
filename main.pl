% helper.pl contains utility functions unrelated to the program
:- ['helper.pl'].

% A cell is empty, contains a tree or a tent
cell(Name, Result) :- find([
	empty,
	tree,
	tent
], Name, Result).

board(0, _, Result, _, Result) :- !.
board(I, TreeIdxs, Acc, N, Result) :-
	I_ is I - 1,
	( empty(TreeIdxs) ->
		board(I_, TreeIdxs, [empty | Acc], N, Result)
	; head(TreeIdxs) =:= N - I_ ->
		board(I_, tail(TreeIdxs), [tree | Acc], N, Result)
	; board(I_, TreeIdxs, [empty | Acc], N, Result)).
board(M, N, K, Result) :-
	Size is M * N,
	randset(K, Size, TreeIdxs),
	board(Size, TreeIdxs, [], Size, Result).
