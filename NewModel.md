# A new data model

## Issues with the old model

 - Cmetadata: Putting the entry for Cmetadata at the top level of the Tmaps was
   arbitrary.
    - Why should it be there when all other pieces of attached data are in the
      `extensions`?
    - It is not very well defined. – Putting it at the toplevel kind of exempted
      it from rigorous examination.
    - Less than half of the Thing types have it.
    - It is only a little more easily available than other kinds of metadata.

 - Groupings: Also quite arbitrary.
    - They were semantically not equivalent. For example, `has-cmeta` is a
      different category of statement than `var-backed`.
    - Indeed, they didn't have any defined semantics. `has-cmeta` just said that
      you could expect a `cmeta` entry, but not how this entry looked or whether
      there actually was something inside it.

 - Naming and choice of Defs:
    - No criteria what would be a Def or not. There was a lot of uncertainty
      whether we should have Defmethods and Structs or not. I hadn't even
      thought that protocol methods could be separate Things as well, but it
      probably makes sense.
    - Taxonomy not taken into account. We had Plain-defs and Fns, but nothing
      said that a Fn is also a Plain-def or that a Plain-def might be a Fn, but
      we just hadn't found out yet.

 - Name Def itself:
    - Special was already an exception. When we include protocol implementations
      introduced through `extend.*`, there's more Things that have never seen a
      `def`, but are called Defs.

 - Validation and identification not helpful:
    - This is more of an implementation issue, but still. We could identify a
      Thing by its tag and we could validate it, making sure that the `name` and
      `coordinates` were bona fide, that the `cmeta` and `extension` entries
      existed and adhered to some loose schema. Could we use that for anything?
      No. We still had no clue whether the information we wanted was actually
      there and in the expected shape.
