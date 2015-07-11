# Comments on the model

Various specifications in addition to [the diagram](model-diagram.pdf). For
thoughts on a concrete implementation, see [GrenadaFormats](GrenadaFormats.md)
and also [GrenadaDraft](GrenadaDraft.md).

## Namespaces and canonical names of Things

 - The `name` of a Thing is the same as its last coordinate. For most Things it
   is clear what name they have. However, some Def Things are difficult.
 - The namespace coordinate of a Def Thing is the name of the namespace in which
   the `(def…)` was written that defined the Thing.
 - The only Def Things that aren't defined with a `(def…)` form are Specials.
   Their namespace coordinate shall be "special".
 - Almost all Def Things get their name through the parameter to a `(def…)`
   form. This parameter, made into a string, is the canonical name of the Thing.
 - The only exceptions I can think of are Specials and Defmethods.
 - Specials can only be defined in the compiler and their canonical name is the
   name by which we call them.
 - The canonical name of a Defmethod shall be of the format "a[b]" where a is
   the name of the multimethod to which they belong and b their dispatch value
   made into a string.

Notes:

 - These requirements are problematic for several reasons:
    - There is hierarchy, but we flatten everything to be on the Def level:
      Defmethods always belong to a defmulti.
    - Might make defmulti Defmulti. See below.
    - There is also a (fallback) hierarchy of types, which we don't represent:
      If we can't determine that something is a Defmulti, we fall back to
      classifying it as a Fn. If we can't determine that something is a Fn or
      Macro or Protocol, we fall back to classifying it as a Plain-def.
    - One Thing can have many names, which is why we need a canonical name.
      Even worse, this is dependent on the platform. In Clojure, by using
      different names, we can also get at different flavours of the same Thing.
      For example, when we define a protocol `A` in the namespace `user`,
      evaluating `user/A` gives us the map backing the protocol and evaluating
      `user.A` gives us the `Class` backing the protocol. Crazy, isn't it?
    - Not sure about what to include. More defs that could be Defs:
       - defmulti
       - definterface
       - deftest
       - defstruct
