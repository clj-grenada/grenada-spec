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


## A new, bootstrapped model

 - Have only few basic elements: Object, Attributes and Aspects.
 - An Object is an arbitrary piece of data.
 - It has Attributes, which are identified by a name.
 - The values of the Attributes are Objects.
 -
 - Attaching an aspect adds to the semantics of the data structure.
 - All objects adhering to this model have the Aspect Ur.

### Semantics of a data object having the Aspect Ur

 - It has the attributes Aspects, which is a set containing at least Ur.
 - In addition to that it can have arbitrary attributes with arbitray values.
 - Aspects can contain more Aspects that limit (from above and below) the set of
   attributes the object can have and the sets of values the attributes can
   have. It describes the meaning of those attributes and values. Having these
   two properties, an Aspect adds to the semantics of the object.

### Bootstrapping Things

 1. An object with the Aspect Thing is called a "Thing".
 2. A Thing has the attributes Aspects, Coordinates and Bars.
 3. The Bars contain data about a concrete object, the "concrete Thing".
 4. The Coordinates tell where we can find the concrete Thing
 5. Every Bar is of a type.
 6. The type of a Bar defines the shape and the meaning of the data it can
    contain.
 7. A Thing cannot have two Bars of the same type.
