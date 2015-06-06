# Draft of the Grenada specification

Notes:

 - The name "Grenada" itself is only a working title. When I've found a better
   title, I will case-insensitively search through the occurences of the string
   "grenada" in this document and do the necessary amendments.

## Terminology

 - Cmetadata: The construct called "metadata" in Clojure. – Stuff returned by
   clojure.core/meta. I need to introduce a dedicated term for this, because
   the existing term "metadata" can be far more general.

## Plugins/extensions

 - I still have to determine the exact extension points Grenada should have.
   Examples are: capturing phase, assembling of artifacts, doing something with
   corresponding extension metadata (fx registering one extension per extension
   metadata tag).
 - A lot of the functionality of Grenada will be provided through Grenada-owned
   plugins.

### Extension points

 - When finding Clojure source files. Call a function on each path and put in
   our map what it returns.
    - :grenada.extensions.default/file.

Notes:

 - I want the extension system to be more flexible, though. –
   [Composable](http://nealford.com/memeagora/2013/01/22/why_everyone_eventually_hates_maven.html)
   and not based on a few hooks that are the limit of what the extender can do.

## External metadata

 - Written in EDN to files external to the main source code or repository.
 - To be merged with other metadata artifacts.
 - Specify an entity by its coordinates and add something.

   ```clojure
   (def Coordinates [(s/one s/Str "group")
                     (s/optional s/Str "artifact")
                     (s/optional s/Str "version")
                     (s/optional s/Str "platform")
                     (s/optional s/Str "namespace")
                     (s/optional s/Str "def")]

   (def Extensions {s/Keyword ; namespace-qualified
                    s/Any})   ; Should be write- and readable.

   (def External [{:entity Coordinates
                   :extensions Extensions}])
   ```

Notes:

 - Specifying entity's coordinates as a vector, because it doesn't require
   parsing a string before being able to find the entity in, a nested map, for
   example.
 - Could be specified in Schema: one coordinate requires all the preceding
   coordinates to be present.

## Metadata map

 - The metadata for each entity are represented as a map.
 - Anything that is not Cmetadata has to go in :extensions.

   ```clojure
   (def Level (s/enum :grimoire.things/group
                      :grimoire.things/artifact
                      :grimoire.things/version
                      :grimoire.things/platform
                      :grimoire.things/namespace
                      :grimoire.things/def))

   (def DefKind (s/enum :var :deftype :record :multimethod))

   (def Entity {:name s/Str
                :level Level
                :coords Coordinates
                (s/optional-key :kind) DefKind
                (s/optional-key :cmeta) {s/Any s/Any}
                  ; Only those entries write- and readable as EDN.
                :extensions Extensions})
   ```

Notes:

 - Inspired by the Grimoire format, but:
    - Am I right that "def" also includes non-var def…s like deftype?
    - Fewer top-level keys in the map for an entity in favour of the extension
      entry where you can put anything. Not sure if we should have more
      top-level keys. But if we don't make Cmetadata/nonC-metadata the
      criterion, which one should it be?
    - Not sure if I should use the grimoire.things namespace or define my own.
 - Not sure whether to make the `Kind` namespace-qualified or not.
 - Should the items in `Kind` be strings or keywords?
 - I guess we don't want to include the :source. Or should it be configurable?
 - With Grimoire you can select macros, vars, fns, sentinels etc. Do we need an
   extra map entry for this? Macros have Cmetadata indicating that they are
   macros, but not the other things. So I gues this goes into :extensions as
   well.
 - Might be specified rigorously in Schema:
    - Currently only entities at the `:grimoire.things/def` level can be of
      different `:kind`s.
    - Above the namespace level there is nothing that supports Cmetadata.
 - At the early stages of assembling metadata not all coordinates are present.
   For these cases we need alternative coordinate data structures. A map?

## Intermediate format

 - We want to support multiple formats of storing the metadata, fx in Datomic,
   in JARs, in memory. In order to convert between these formats in a sensible
   way, we need an intermediate format.
 - This will also be the form of the metadata whenever we carry out operations
   of them that aren't simply queries. Fx, metadata when freshly captured from
   source, metadata in the state of being merged with other metadata.

   ```clojure
   (def Metadata [Entity])
   ```

Notes:

 - During my experimentation I used a linear format, i.e. metadata for all
   entities is represent as a sequence of maps, one for every entity. This
   appears to be the easiest to work with, but also has some drawbacks:
    - Lookup of entities is slow. – If we have one sequence of maps and want to
      merge in another sequence of maps (`External`, for example) that is
      ordered differently, a lot of jumping around will happen. For these cases
      a map from coordinates to entity map might be a convenient representation.
    - Is it complected? We throw all entities into the same data structure. That
      saves us from keeping track of six different data structures, but might
      also introduce duplicated control structures for splicing apart the
      different kinds of entities in various corners of the code.
 - All in all, this is the current state and not much thought about. I will
   leave it like that until I've collected more material for thought. I think
   this can be left open until I've decided about the extension architecture.

## Filesystem/JAR format

 - This format will be used for the metadata JARs.
 - The JAR will have the classifier "grenadata".
 - Directory structure parallels coordinates. The levels of the hierarchy
   correspond to the `Coordinates`.
 - Each entity has its data.edn file, which contains its `Entity` map.
 - Example:

    ```
    coordinates: ["clj-grenada" "grenada-lib" "0.1.0" "clj" "grenada-lib.core"]
    relative path: clj-grenada/grenada-lib/0.1.0/clj/grenada-lib.core/data.edn
    ```

 - In a Leiningen project directory we store the directory hierarchy in
   `<root>/grenada-data` and the JAR along with a `pom.xml` in
   `<root>/target/grenada".

Notes:

 - Sorry for "grenadata". Hopefully it will get better with a better name.
 - Also inspired by the Grimoire format of storing data about Things on disk.

## Adding extension metadata to entities without support for Cmetadata

 - Extension metadata can be added to any entity by way of external metadata.
 - In order to add metadata to entities not supporting metadata close to where
   they're defined, we need some extra construct. Proposal:

   ```clojure
   (ns ex.ample
     (:require [grenada.core :as grenada]))

   (defrecord Repository [path]
     ILookup
     (get [this id] nil))

   (grenada/defrecord Repository
      {:doc "Represents a Git repository."
       :author "Richard Möhn"}}
     [path]

     ILookup
     {:arglists '([this id])
      :doc "Returns a GitObject with the given ID. Not implemented yet."}
     (get [this id] nil))
   ```

Notes:

 - I think we need this, because I think a library author wouldn't want to
   document their records in a separate external metadata file in most cases.
 - How do we use this to add metadata to multimethod methods?
 - How do we find out what deftypes and records were defined and where?
 - Have to think how to design the syntax so that it doesn't get unwieldy,
   especially in cases where we want to attach extension metadata to methods.


## Changelog

### 0.1.4

 - Outsource versioning to README.
 - Rewrite attaching metadata to a record to something arguably more elegant.

### 0.1.3

 - Add section [Extension points](#extension-points).
 - Add note about `Coordinates` Schema.
 - Separate sections "Filesystem format" into [Metadata map](#metadata-map),
   [Intermediate format](#intermediate-format) and [Filesystem/JAR
   format](#filesystem%2Fjar-format). Change and add a number of things there.

### 0.1.2

 - Name of metadata files: `data.clj` → `data.edn`
 - Make `:kind` and `:cmeta` entries in `Entity` optional.
 - Rename `Kind` to `DefKind`.
 - Add notes concerning `:kind`s and the (non-)existence of Cmetadata.
