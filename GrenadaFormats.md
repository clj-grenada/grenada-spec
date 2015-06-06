# Formats for storing Grenada data

## in-memory

Notes:

 - We need some sort of indication of which format we're dealing with when we
   just get a data structure. Possibilities:
    - Put them in a record.
    - Make a vector `[:hierarchical {…}]`.
 - Formats migth evolve. So in addition to the "which format", we might also
   need information about the version of the format.

### in-memory, hierarchical

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
   sets of entities at a specifiec level.

Disadvantages:

 - Not so easy to build.
 - Harder to iterate over for transformations etc.
 - Hard to query in a non-hierarchical way. E.g., perform fulltext search on
   entity docstrings for "seq".

Notes:

 - Somehow like the Grimoire Big Map.
 - The Grimoire Big Map is much harder to query, though. Why is it the way it
   is?

### in-memory, sequential

 - Grenada data is just a sequence of metadata maps.

Advantages:

 - Easy to build.
 - Easy to apply common sequence operations.

Disadvantages:

 - Slow to find specific metadata maps.

### in-memory, mapping

 - Grenada data is a sorted map of coordinates to metadata maps.

Advantages:

 - Easy to build.
 - Fairly easy to apply common sequence operations. – Though not as easy as for
   sequential format.
 - Easy to find specific metadata maps.

Disadvantages:

 - Slow to find sets of metadata maps.

### in-memory, database

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


## filesystem

### filesystem, flat

 - One file contains all the metadata.

Advantages:

 - Easy to read and write by computer.
 - No filesystem navigation by the user required.
 - No cleanup required. – Just always write the whole file.

Disadvantages:

 - Unwieldy with a lot of data.
    - Slow to read and write just specific parts
    - User doesn't want to search and edit huge metadata files.

### filesystem, hierarchical

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

### filesystem, arbitrary

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
 - Hard to find something specific from Grimoire. – Either read in all the data
   for searching or have to write tailormade search.


## database

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
 - Proprietary license.

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
