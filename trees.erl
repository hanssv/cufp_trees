-module(trees).
-include_lib("eqc/include/eqc.hrl").
-compile({parse_transform,eqc_cover}).
-compile(export_all).


to_list(leaf) ->
  [];
to_list({node, L, X, R}) ->
  to_list(L) ++ [X] ++ to_list(R).

%% member

member(_, leaf) ->
  false;
member(X, {node, L, Y, R}) ->
  if
    X < Y ->
      member(X, R);
    X == Y ->
      true;
    X > Y ->
      member(X, L)
  end.

%% insert

%% insert(X, leaf) ->
%%   {node, leaf, X, leaf};
%% insert(X, {node, L, Y, R}) ->
%%   if X < Y ->
%%       {node, insert(X, L), Y, R};
%%      X >= Y ->
%%       {node, L, Y, insert(X, R)}
%%   end.
