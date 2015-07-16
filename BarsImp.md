# Implementing Bars

If you want to define a Bar B, you have to do the following things. (In some
aspects, Bars are similar to Aspects, so you will see some referrals to the
[Aspects guide](AspectsImp.md). I won't repeat some other conventions I've used
there, so please read it first. It isn't that long.)

## Prerequisites

Think about which Aspects and other Bars a Thing has to have for B to be added.
Write them down as sets in a map with the keys `:aspect-prereqs` and
`:bar-prereqs`.

> ##### Example
>
> *You want to declare the Bar `:doro.bars/markup-all`.
> `:doro.bars/markup-all` requires that the Thing have the Aspect `:a/namespace`
> and the Bar `:grenada.bars/doc-string`. So you write:*
>
> ```clojure
> {:aspect-prereqs #{:grenada.aspects/namespace}
>  :bar-prereqs #{:grenada.bars/doc-string}}
> ```
