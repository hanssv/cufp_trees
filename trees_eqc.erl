-module(trees_eqc).

-include_lib("eqc/include/eqc.hrl").
-compile({parse_transform,eqc_cover}).
-compile(export_all).

%% -- Generators -------------------------------------------------------------

tree() ->
  ?SIZED(Size, tree(-Size, Size)).

tree(Lo, Hi) when Hi < Lo ->
  leaf;
tree(Lo, Hi) ->
  frequency(
    [{1, leaf},
     {2, ?LET(X, choose(Lo, Hi),
                 ?LET({L, R}, {tree(Lo, X - 1), tree(X + 1, Hi)},
                      ?SHRINK({node, L, X, R}, [leaf, L, R])))}]).


%% -- Properties -------------------------------------------------------------
prop_ordered() ->
  ?FORALL(T, tree(), ordered(trees:to_list(T))).

prop_member() ->
  ?FORALL({X, T},{nat(), tree()},
          equals(trees:member(X, T), lists:member(X, trees:to_list(T)))).

prop_insert() ->
  ?FORALL({X, T}, {nat(), tree()},
    begin
      L = trees:to_list(trees:insert(X, T)),
      equals(L, lists:umerge([X], trees:to_list(T)))
    end).

%% -- Auxillary functions ----------------------------------------------------
ordered(Xs) ->
  lists:usort(Xs) == Xs.
