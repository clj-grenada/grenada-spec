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


## A new model

 - We have Things.
 - A Thing is a data object containing data about a concrete thing.
 - (Not writing "concrete" everywhere is okay as long as it's made clear what is
   meant (by capitalization in writing and by context in speaking).)
 - A Thing has Bars that *contain data* about the concrete thing.
 - A Thing has Aspects that *define its semantics*.
 - A Thing has Coordinates that tell where we can find the concrete thing.
 - The parent Thing P of a Thing C is the Thing with C's coordinates except the
   last. Please extrapolate this to other notions of relatedness like "child",
   "ancestor" etc.

### More on Bars

 - Bars may be added to or deleted from a Thing.
 - Every Bar has a type (I'm tempted to call it Mould). The type defines the
   meaning and shape of the information the Bar contains. It also defines the
   prerequisites of the Bar, that is, the Aspects and types of Bars required to
   be present on a Thing before the Bar can be added to it.
 - Nothing will stop you from requiring not only the presence of a Bar, but also
   some properties of their contents. However, I advise against relying on
   anything more than what the Bar *type* guarantees, since it might make
   version progression more difficult.
 - A Thing cannot have two Bars of the same type.

### More on Aspects

 - Aspects may be added to, but not deleted from a Thing.
 - Aspects may not make any statement about the Bars of a Thing.
 - An Aspect may define prerequisites, that is, the Aspects required to be
   present on a Thing before the Aspect can be added to it.
 - A Thing cannot have two conflicting Aspects.
 - A Thing has exactly one of the following Aspects.

#### Group

 - A Thing with the Aspect Group contains data about a concrete Maven group.
 - It has one coordinate, the name of the concrete group.

#### Artifact

 - A Thing with the Aspect Artifact contains data about a concrete Maven
   artifact.
 - It has two coordinates, the coordinate of the concrete group the concrete
   artifact belongs to and the name of the concrete artifact.

#### Version

 - A Thing with the Aspect Version contains data about a concrete Maven version.
 - It has three coordinates, the coordinates of the concrete artifact the
   concrete version belongs to and the name of the concrete version itself (also
   called a "version string").

#### Platform

 - A Thing with the Aspect Platform contains data about the code for a concrete
   Clojure platform that a concrete version contains.
 - It has four coordinates, the coordinates of the concrete version that
   contains the code for the concrete platform and the canonical name of the
   concrete platform itself.
 - Canonical names for the concrete platforms are the same as [those defined in
   lib-grimoire](https://github.com/clojure-grimoire/lib-grimoire/blob/master/src/grimoire/util.clj#L40-L53):
   "clj", "cljs", "cljclr", "ox", "pixi", "toc".

#### Namespace

 - A Thing with the Aspect Namespace contains data about a concrete Clojure
   namespace.
 - It has five coordinates, the coordinates of the concrete platform whose code
   contains the concrete namespace and the name of the concrete namespace
   itself.
 - In Clojure, namespaces are named with symbols. In Grenada we're only dealing
   with strings, so if `s` is the symbol that names a namespace in Clojure is
   `(str s)` is its name in Grenada.

#### Find

 - A Thing with the Aspect Find contains data about a concrete find dug up in a
   concrete Clojure namespace.
 - A concrete find is something that is defined in some way in a concrete
   Clojure namespace. There are many kinds of finds imaginable, for example fns
   and deftypes.
 - The more specific semantics of a Find and a definition of the kind of find it
   contains data for are defined by the Find's other Aspects.
 - A Find has six coordinates, the coordinates of the concrete namespace in
   which the concrete find is defined and the canonical name of the concrete
   find itself.
 - If not otherwise clear by internment, a Find X is said to be defined in a
   namespace N if the code that sets it into existence occors after the
   declaration of N via and before the declaration of any other namespace via
   `(ns …)` forms.
 - If a Find cannot be associated with any namespace (example: Clojure special
   forms), it has to have at least one Aspect that also defines what the
   namespace coordinate shall be.
 - The Aspect Find itself doesn't define how the canonical name of a Find should
   be obtained. Since a Thing has to have a name, a Find has to have at least
   one other Aspect that defines how its canonical name is to be obtained.


### QYMH (Questions you might have)

*Aspects are not allowed to make statements about the Bars. What about the Cmeta
Bar? Surely the Cmetadata entries of fns are different from those of plain
var-defs. So, implicitly the Aspect is making a statement about the Cmeta Bar,
isn't it?*

Yes, it would, if there was a Cmeta Bar. However, exactly for the reasons that
the contents and shape of Cmetadata are very fuzzily defined in Clojure and even
vary from case to case, I would advise against defining a Cmeta Bar at all.
Rather, we should have Bars that are derived from Cmetadata entries like
`:arglists`, but no Bars that capture the whole Cmetadata map.

If you still find it practical to define a Cmeta Bar, you should only look at
its contents and not at any Aspects in order to decide what you want to do.
