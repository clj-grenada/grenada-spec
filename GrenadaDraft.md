# Draft of the Grenada specification

Version: 0.1.2-SNAPSHOT

Notes:

 - The name "Grenada" itself is only a working title.

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

## Filesystem format

 - This format will be used for the metadata JARs.
 - Directory structure parallels coordinates. The levels of the hierarchy will
   be as seen in `Coordinates`.
 - Each entity has its data.edn file.
 - Anything that is not Cmetadata has to go in :extensions.

   ```clojure
   (def Level (s/enum :grimoire.things/group
                      :grimoire.things/artifact
                      :grimoire.things/version
                      :grimoire.things/platform
                      :grimoire.things/namespace
                      :grimoire.things/def))

   (def Kind (s/enum :var :deftype :record :multimethod))

   (def Entity {:name s/Str
                :level Level
                :coords Coordinates
                :kind Kind
                :cmeta {s/Any s/Any} ; Should be write- and readable.
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
 - Not sure whether to include the :coords.
 - Should the items in `Kind` be strings or keywords?
 - I guess we don't want to include the :source. Or should it be configurable?
 - With Grimoire you can select macros, vars, fns, sentinels etc. Do we need an
   extra map entry for this? Macros have Cmetadata indicating that they are
   macros, but not the other things. So I gues this goes into :extensions as
   well.

## Adding extension metadata to entities without support for Cmetadata

 - Extension metadata can be added to any entity by way of external metadata.
 - In order to add metadata to entities not supporting metadata close to where
   they're defined, we need some extra construct. Proposal:

   ```clojure
   (ns ex.ample
     (:require [grenada.core :as grenada]))

   (defrecord Repository [path]
     ILookup
     (get [this id] nil)

   (grenada/annotate! Repository
     {:grenada.extensions.default/doc
      {:doc "Represents a Git repository."
       :protocols {"ILookup"
                   {"get" {:arglists '([this id])
                           :doc "Returns a GitObject with the given ID. Not
                                implemented yet."}}}}})
       :author "Richard Möhn}}})
   ```

Notes:

 - I think we need this, because I think a library author wouldn't want to
   document their records in a separate external metadata file in most cases.
 - How do we use this to add metadata to multimethod methods?
 - How do we find out what deftypes and records were defined and where?


## Changelog

### 0.1.2-SNAPSHOT

 - Name of metadata files: `data.clj` → `data.edn`
