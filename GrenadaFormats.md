# Formats for storing Grenada data

## Metadata for one Thing: tagged metadata map

 - Contains metadata for a Thing.
 - This is the official format for exchanging metadata. On the inside,
   components may use whatever format they want.
 - Anything that is not Cmetadata has to go in :extensions.

   ```clojure
   (def Level (s/enum :grenada.things/group
                      :grenada.things/artifact
                      :grenada.things/version
                      :grenada.things/platform
                      :grenada.things/namespace
                      :grenada.things/def))

   (def DefKind (s/enum :var :deftype :record :multimethod))

   (def Coordinates [(s/one s/Str "group")
                     (s/optional s/Str "artifact")
                     (s/optional s/Str "version")
                     (s/optional s/Str "platform")
                     (s/optional s/Str "namespace")
                     (s/optional s/Str "def")]

   (def Extensions {s/Keyword ; namespace-qualified
                    s/Any})   ; Should be write- and readable.

   (def Entity {:name s/Str
                :level Level
                :coords Coordinates
                (s/optional-key :kind) DefKind
                (s/optional-key :cmeta)
                ,,{s/optional-key :grenada.cmeta/extensions Extensions
                   s/Any s/Any}
                  ; Only those entries write- and readable as EDN.
                :extensions Extensions})
   ```

 - The value for the `:cmeta` key will contain the map returned by `(meta
   <obj>)` with these exceptions:

    - The default capturer runs on a separate Clojure instance and communicates
      back what it captures through `pr` and `clojure.edn/read`. No efforts are
      made to preserve values that can't pass this process unharmed. The same
      goes for metadata export/import. Of course you can transform the metadata
      beforehand or write your own capturers, exporters and importers that are
      more capable.
    - An entry with the key `:grenada.cmeta/extensions` will be `dissoc`-ed from
      the Cmetadata map and its map `merge`-d into the value of the
      `:extensions` key of the `Entity`.

Notes:

 - Inspired by the Grimoire format, but:
    - Fewer top-level keys in the map for a Thing in favour of the extension
      entry where you can put anything. Not sure if we should have more
      top-level keys. But if we don't make Cmetadata/nonC-metadata the
      criterion, which one should it be?
    - ❁ No explicit storage of parent. The parent of a Thing can always be
      found by looking up the coordinates of the thing with the last entry
      chopped off. @Reid: what was the rationale for including the parent? It
      appears like a lot of overhead to me.
 - I used to call Things "entities", but will gradually convert to Thing . – If
   we're using nondescript names, we should at least all use the same. Grenada
   Thing maps are a bit different from Grimoire's. Therefore qualify them with a
   different namespace.
 - Specifying an entity's coordinates as a vector, because it doesn't require
   parsing a string before being able to find the entity, in a nested map, for
   example.
 - ❁ The shape of the data structure is going to change (Guten-tag), but the
   information it contains look okay to me for now.
 - I guess we don't want to include the :source. Or should it be configurable?
 - With Grimoire you can select macros, vars, fns, sentinels etc. Do we need an
   extra map entry for this? Macros have Cmetadata indicating that they are
   macros, but not the other things. So I guess this goes into :extensions as
   well.
 - Will be specified rigorously in Schema/Guten-tag with "smart constructors":
    - Currently only entities at the `:grimoire.things/def` level can be of
      different `:kind`s.
    - Above the namespace level there is nothing that supports Cmetadata.
 - The remove-and-merge of the `:grenada.cmeta/extensions` entry is a bit ugly,
   but I think there is no alternative. For convenience reasons we have to allow
   the attachment of extension metadata in the Cmetadata map, but it would be
   annoying if we had to take care of extension metadata in two places
   afterwards. Taking care only in one place can be achieved only by having
   those data in one place.
 - TODO: Make a list of extension metadata keys I've already experimentally used
         somewhere. (RM 2015-06-30)
 - TODO: Specify what the canonical name for each Thing looks like. (RM
         2015-06-30)
 - TODO: Think about how to handle `defmulti`s. (RM 2015-06-30)
 - TODO: Specify what the namespace coordinate for special forms should be. (RM
         2015-06-30)
 - TODO: Think about whether we need to support structs. (RM 2015-06-30)

## Metadata for many Things

 - In the following sections, different formats for storing the metadata of many
   Things will be discussed.

Notes:

 - They are complex? In the sequential and mapping structures, we throw all
   entities into the same compartment of a data structure. That saves us from
   keeping track of six different data structures, but might also introduce
   duplicated control structures for splicing apart the different kinds of
   entities in various corners of the code. Have to see how this plays out.

## In-memory

Notes:

 - We need some sort of indication of which format we're dealing with when we
   just get a data structure. Possibilities:
    - Put them in a record.
    - Make a vector `[:hierarchical {…}]`.
 - Formats might evolve. So in addition to the "which format", we might also
   need information about the version of the format.
 - Should try out Guten-tag.

### In-memory, hierarchical

 - In a way that data about an entity can be lookup up by

   ```clojure
   (get-in data ["org.clojure" "clojure" "1.6.0" "clj" "clojure.core" :this])
   ```

   and its children by

   ```clojure
   (-> data
       (get-in ["org.clojure" "clojure" "1.6.0" "clj" "clojure.core")
       (dissoc :this)
       vals)
   ```

Advantages:

 - Easy to find specific entities and sets of children of specific entities and
   sets of entities at a specific level.

Disadvantages:

 - Not so easy to build.
 - Harder to iterate over for transformations etc.
 - Hard to query in a non-hierarchical way. E.g., perform fulltext search on
   entity docstrings for "seq".

Notes:

 - Similar to the Grimoire Big Map. (The Big Map issue should have a reference
   to Guten-tag, though. I was wondering for some time why it looks how it
   looks.)

### In-memory, sequential

 - Grenada data is just a sequence of metadata maps.

Advantages:

 - Easy to build.
 - Easy to apply common sequence operations.

Disadvantages:

 - Slow to find specific metadata maps.

### In-memory, mapping

 - Grenada data is a sorted map of coordinates to metadata maps.

Advantages:

 - Easy to build.
 - Fairly easy to apply common sequence operations. – Though not as easy as for
   sequential format.
 - Easy to find specific metadata maps.

Disadvantages:

 - Slow to find sets of metadata maps.
 - Common sequence operations get more clumsy.
 - Doesn't preserve order unless we use sorted or ordered maps.

Note:

 - Maybe we should make information about the implementation details explicit
   somewhere. Using ordinary, sorted or unsorted maps does make a difference.

### In-memory, database

 - Have all the data in an in-memory database that supports Datalog queries.

Advantages:

 - All the advantages of the other in-memory formats about querying combined.
 - See also database section below.

Disadvantages:

 - Can't use any of the ordinary functions directly. – Always have to query,
   (transform,) transact.
 - Datomic is proprietary. – Would put off some people. – Also requires messing
   around with a schema.
 - DataScript works only in ClojureScript.
 - PossibleDB doesn't support in-memory mode.
 - See also database section below.


## Filesystem

### Filesystem, flat

 - One file contains all the metadata.

Advantages:

 - Easy to read and write by computer.
 - No filesystem navigation by the user required.
 - No cleanup required. – Just always write the whole file.

Disadvantages:

 - Unwieldy with a lot of data.
    - Slow to read and write just specific parts.
    - User doesn't want to search and edit huge metadata files.

### Filesystem, hierarchical

 - Analogous to the hierarchical in-memory format.
 - Use directory structure for hierarchy and write one file per metadata map.

Advantages:

 - For searching, see hierarchical in-memory format.
 - Easy to work with from applications that present hierarchical view. – Cf.
   Grimoire.

Disadvantages:

 - See hierarchical in-memory format.
 - If we don't throw away the whole directory structure every time before
   writing data, we have to take care not to end up with stale `data.edn`.
 - Harder to search with command line tools.

### Filesystem, arbitrary

 - User stores EDN files in any structure of files she likes.
 - For reading by Grenada, she just provides the files and Grenada reads all the
   metadata maps from them.

Advantages:

 - User can choose what format is best for them. – Especially important for
   writing external metadata.
 - Depending on the choices of the user, easy to search with command line tools.

Disadvantages:

 - Hard to write by the computer. – At least it requires some programming in
   order to get what you want.
 - Stale data see hierarchical filesystem format.
 - Hard to find something specific. – Either read in all the data for searching
   or have to write tailormade search.


## Database

### Datomic

Advantages:

 - Very flexible querying.
 - Durable, but immutable.

Disadvantages:

 - Each external metadata format also has to provide a Datomic schema in order
   to participate in storing in Datomic. This gets especially complicated when
   pieces of external metadata :db.type/ref each other.
 - Have to build transaction data structures. Also gets complicated for
   :db.cardinality/many and :db.type/ref.
 - Proprietary license. → PossibleDB

Notes:

 - As an alternative to schema snippets, Grenada could just throw out the items
   that don't fit the schema or store them as blobs.

### DataScript

Advantages:

 - Very flexible querying.

Disadvantages:

 - Only runs in ClojureScript.
 - See those about schema and transaction data structures in Datomic. Not as
   severe, though.


## Changelog

### 0.1.5

 - Take over section
   [GrenadaFormats](GrenadaFormats.md#metadata-for-one-thing-tagged-metadata-map)
   from [GrenadaDraft](GrenadaDraft.md).
    - Add note about limitation to `pr`intable things.
    - Add the thing about `:grenada.cmeta/extensions`.
    - Add note about the parents.
    - Start transition from "entity" to "Thing".
    - Change the namespace from `grimoire.things` to `grenada.things`.
    - Pre-announce change of structure towards using Guten-tag.
 - Add note about complexity of formats.
 - Pre-announce Guten-tag also for formats.
 - Add notes to [mapping format](#in-memory-mapping) about clumsiness and
   order-preservation.
