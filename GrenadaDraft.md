# Draft of the Grenada specification

## Terminology

 - Cmetadata: The construct called "metadata" in Clojure. – Stuff returned by
   clojure.core/meta. I need to introduce a dedicated term for this, because
   the existing term "metadata" can be far more general.
 - Tmap, Tval: I'm too lazy to write tagged map or tagged value everytime I'm
   talking about something that has to do with Guten-tag. If someone knows a
   better term, please tell me. (I will gradually adopt this terminology.)
 - Def: Defs are the Things at the lowest level. They are defined in code that
   belongs to namespaces and you define them usually with an expression like
   `(def… …)`.

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

Notes:

 - I want the extension system to be more flexible, though. –
   [Composable](http://nealford.com/memeagora/2013/01/22/why_everyone_eventually_hates_maven.html)
   and not based on a few hooks that are the limit of what the extender can do.

### Extension metadata

I've already played with the following keys for extension entries:

 - `:poomoo.ext/ex-raw` for unprocessed examples.
 - `:poomoo.ext/examples` for processed examples.
 - `:voyt.ext/requires` for namespaces that have to be `required` for a macro
   expansion to work.
 - `:voyt.ext/defines` for a list of symbols a macro defines.
 - `:grenada.ext.default/doc` for doc strings on Things that don't support doc
   strings.

## Filesystem/JAR format

 - This format will be used for the metadata JARs.
 - The JAR will have the classifier "datadoc".
 - Directory structure parallels coordinates. The levels of the hierarchy
   correspond to the `Coords` (see [model](model-diagram.pdf). Coordinates will
   be `grimoire.util/munge`d for use as file and directory names.
 - Each entity has its data.edn file, which contains its `Thing` Tmap.
 - Example (path demunged):

    ```
    coordinates: ["clj-grenada" "grenada-lib" "0.1.0" "clj" "grenada-lib.core"]
    relative path: clj-grenada/grenada-lib/0.1.0/clj/grenada-lib.core/data.edn
    ```

 - The Leiningen plugin would store the directory hierarchy in
   `<root>/grenada-data` and the JAR along with a `pom.xml` in
   `<root>/target/grenada".

Notes:

 - See also [the formats document](GrenadaFormats.md#filesystem-hierarchical).
 - Also inspired by the Grimoire format of storing data about Things on disk.

## Metadata annotations: extension metadata for entities without support for Cmetadata

 - Extension metadata can be added to any entity by way of external metadata.
 - In order to add metadata to entities not supporting metadata close to where
   they're defined, we need some extra construct. Proposal:

   ```clojure
   (ns ex.ample
     (:require [grenada.core :as grenada]))

   (defprotocol Repository [path]
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

 - For cases where people already use a macro wrapping `defrecord` or friends,
   we need an alternative syntax:

   ```clojure
   (grenada/annotate! Repository
     {:grenada.ext.default/doc
      {:doc "Represents a Git repository."
       :protocols {"ILookup"
                   {"get" {:arglists '([this id])
                           :doc "Returns a GitObject with the given ID. Not
                                implemented yet."}}}}})
       :author "Richard Möhn}}})
    ```
 - Things that do support Cmetadata can also be annotated.

Notes:

 - I think we need this, because I think a library author wouldn't want to
   document their records in a separate external metadata file in most cases.
 - How do we find out what deftypes and records were defined and where?
 - Have to think how to design the syntax so that it doesn't get unwieldy,
   especially in cases where we want to attach extension metadata to methods.
 - Implementation maybe like `core.typed` with an atom that holds all the
   annotations.
 - The above example exposes a problem: we somehow need to remove the right
   amount of whitespace from the strings.


## Changelog

### 0.1.5

 - Add the term Tmap.
 - Move specs and notes from [External metadata](#external-metadata) to
   [GrenadaFormats](GrenadaFormats.md).
 - Remove outdated notes from [External metadata](#external-metadata).
 - Remove outdated notes from section Metadata map and move it to
   [GrenadaFormats](GrenadaFormats.md#metadata-for-one-thing-tagged-metadata-map).
 - Remove section Intermediate format. – This has been superseded by
   [GrenadaFormats](GrenadaFormats.md).
 - Add reference to section [Filesystem/JAR format](#filesystem-jar-format),
   correct typo and add the old way of attaching metadata back as an
   alternative.

### 0.1.4

 - Outsource versioning to README.
 - Rewrite attaching metadata to a record to something arguably more elegant.
 - Add munging of paths.

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
