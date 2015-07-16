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

And along comes the next problem.

 - If we attach the `:doro.bars/markup-all` Bar to the namespace, nobody else
   will know.
 - The processing tool would have to find all the Finds in that namespace and
   attach a `:doro.bars/markup` to them.
    - If not all Finds in that namespace are present at the time of processing,
      those that aren't present might not get the attachment.
 - That's one direction. In the other direction, the tool that potentially does
   the formatting, would have to look upwards in the coordinates for every Find
   that doesn't have a `:doro.bars/markup` Bar and see if there's a
   `:doro.bars/markup-all` Bar there.
    - If the Things upwards in the coordinates are not present at the point of
      processing, they might have `:doro.bars/markup-all`, but it wouldn't get
      added to the the dependent Things down the coordinates.
       - This is easier to mitigate than the equivalent problem in reverse as
         described above. Above, you don't know which Finds might be lurking
         somewhere. Here you would see if the upwards Thing isn't there and take
         appropriate action.
 - There are problems with both of the approaches mentioned before.
 - Is it feasible to do one of these manually?
    - When would this processing happen?
       - It could be in the last possible place: the documentation generator.
         When it reads the doc string of one Thing, it could look up in the
         tree (root pointing upwards, of course) whether there's a
         `:doro.bars/markup-all` somewhere.
       - That would go all the way up to the group level.
 - How often does it occur that a Bar also applies to children?
    - markup language
    - encoding? Should be UTF-8 everywhere anyway. :(
    - macro requires
    - grouping defs for cheatsheets
    - If I can come up with three, other people will come up with three times
      as many.
 - One could also automate this and do the full prototype-based thing.
 - This again creates other problems.
    - Things have parent links. We have to persist them together.
    - The higher-level Things must be there before the lower-level Things. Or
      can we apply a higher-level Thing to an existing lower-level Thing. Hmm, I
      guess so.
    - In languages with mutable data structures a change to the parent would
      automatically have an effect on the children, because they keep their
      reference and the parent gets mutated. How is this done in Clojure? If we
      "add" a Bar to a parent,  we get a new parent, but the children still have
      information from the old parent. If we look up a property in the children
      and they don't have it and the old parent didn't have it and only the new
      parent has it, we won't find it. Hmm, hmm, hmm.
       - This is with the reference-based approached as exemplified in Joy of
         Clojure.
       - Of course, we could also have parent referral via keywords and the
         parents would be freshly looked up every time. Then we need a data
         structure where we can look up all the Things by keyword/coordinates.
       - Or we could keep it all in a big data structure where it is clear which
         are the children and if we return a new version of the data structure
         with a new parent, it also contains all new children.
       - In a sense we already have the parent link with the coordinates
         shortened by the final coordinate.
    - It should be optional. For many Bars it doesn't make sense to look them up
      in the parent if they aren't there.

 - Easiest solution: the Bars declare that they can have an effect on children.
   Then those who care for those Bars, know that and if they get a collection of
   data, they can look if the parents are also there and look for the Bars in
   them. The parent links are already implicit in the coordinates. We can
   provide some functions that make the lookup easy.
