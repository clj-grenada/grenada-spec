# Usage scenarios for Grenada

Notes:

 - This document got a bit out of control. Right now it shouldn't be considered
   a main part of the specification.

## GREN001: Extract "usual" metadata from the current project

Story:

 1. The user has created a library project with Leiningen and written some code.
 2. She wants to have the "usual" metadata from the code extracted, packaged and
    uploaded to Clojars.

Considerations:

 - This should be as easy and unobtrusive as possible.
 - Therefore has to be integrated with Leiningen workflow.
 - Provide plugin: `lein grenada extract`, `lein grenada jar`, `lein grenada
   deploy` + hooks so that this happens automatically (on `lein compile`, `lein
   jar`, `lein deploy`?)

## GREN002: Extract "usual" and "unusual" metadata from the current project

Extends: GREN001

Story:

 2'. She wants to extract some metadata that are not extracted by Grenada by
     default.

Considerations:

 - There might be some extractors not activated in Grenada by default or there
   is a third-party extractor.
 - The built-in-but-not-default extractors can easily be activated in
   `project.clj`.
 - Third-party ones are a bit more tricky.
    - The user needs to specify the dependency in some way. Either in the
      `:grenada` section of `project.clj` or in the ordinary dependencies.
    - If it is in the ordinary dependencies, Grenada has to be told to activate
      that extractor.
    - The third-party extractor might require its own configuration.
 - There might be pre-configured extractors that can just be activated in a
   declarative way in `project.clj`.
 - Or there might be extractor building blocks that require the user to write
   some code and somehow activate this in project.clj or just pass it to `lein
   grenada extract`.
 - How should third-party extractors look? Regular Clojure libraries, I guess.
 - We should be able to run a Grenada build on the REPL, independent of build
   tools. The build tools just have to take care of pulling in the libraries
   with the extractors, transformer etc. that we need. Once we have this, we can
   write Boot tasks and Leiningen plugins using our library that do the same as
   we do on the REPL, just integrated with some build process.

## GREN003: Extract "usual" and custom metadata from the current project

Extends: GREN001

Story:

 2'. She wants to extract some metadata that neither Grenada nor an existing
     Grenada third-party extractor extract. Maybe it's a kind of metadata that
     is project-specific.

Considerations:

 - Of course she could write her own third-party extractor and use it the same
   way as in GREN002. In this case we'd have to make it very easy to write
   third-party extractors. However, there is always this burden of deploying it
   locally and updating the dependencies in the project that uses it.
 - So there should be the possibility of writing something locally.
    - This might have the declarative interface or the assemble-your-own
      interface.
    - Again, need to register it with Grenada. Either through `project.clj` or
      as command line argument.

## GREN002, GREN003: Considerations

 - Of course we should also be able to switch off extracting the "usual"
   metadata and have only the "unusual" or custom metadata extracted.
 - How do we combine multiple extractors?
    - We can let them run over the source separately and then merge their
      results.
       - I have to write at least one extractor myself. I can publish most of
         its components of the building blocks that can be used by extenders to
         build their extractors.
    - We can have a framework procedure running over the sources that the
      different extractors hook into.
    - Or we can have both: a default framework procedure and the possibility for
      extenders to write their own.
    - We always have to pay attention that they don't produce overlapping data,
      or, that if the they produce overlapping data, those data can be combined
      in a meaningful way.
 - How do we guarantee compatibility if the user can just declare arbitrary
   extractors that are chased across the sources?
    - Grenada sees which extractors are called for.
    - It runs all the standalone extractors, hooked up with the specified
      extractor hooks.
    - It merges all the data produced by the standalone extractors.
    - We have a few blessed extractors that can write data to the toplevel of
      the metadata map. The others write to the :extensions section.
        - This way they don't get in the way of each other.
        - If some extractor wants to write to the toplevel, they can do that,
          but there would be no guarantees about interoperability for those.
 - What happens if the non-standalone extractors offer hooks?
 - Even our default extractor is not a single one probably. We will have to have
   an extractor for Clojure sources and for ClojureScript sources at least. And
   then there are other weird things like CLJC sources and CLJX. How does CLJX
   work? Anyway, as long as we have the extractors and can provide them with the
   right entry points, it should be fine.
    - For example, we will hook something for non-vars into the Clojure
      extractor.
    - How do protocols and records and types in ClojureScript work? Do they also
      produce interfaces and classes?
    - Maybe the extractors themselves can be decomposed into
      platform-independent and platform-dependent components.
 - The hooks are specific to the standalone extractors. That means, for every
   standalone extractor, we also specify the hooks it will run with.

## GREN004: Write external metadata

Story:

 - A user wants to write metadata annotations for an arbitrary artifact in a
   place external to the sources of that artifact.

Considerations:

 - The artifact might or might not be under control of the user. In the latter
   cases it should be clear why the user wants to write the metadata externally.
   In the former case it might have various reasons:
    - The user doesn't want to change the artifact.
    - The user wants to revision control the metadata separately.
    - The user wants to provide an alternative set of metadata.
 - If it's not in control of the user and closed-source, she still needs to know
   which coordinates it has, of course.
 - Different users might want to write the external metadata in different
   formats. Different filesystem structures are possible. Maybe someday a crazy
   person writes a graphical user interface. Then they'd probably want to store
   it in a database.
 - For small sets of external metadata a single file with a vector of maps or
   just multiple maps of metadata could be suitable. For large sets people
   probably want some more structure. For example, one file with all namespaces
   and a file each for the defs in a namespace. Grenada might be agnostic of the
   filesystem structure, just search all given files and rely on the coordinates
   in every map.

## GREN005: Extract a skeleton

General story:

 Someone wants to extract from something a skeleton of metadata that contains
 only the coordinates.

Considerations:

 - This is a convenience thing for when the someone wants to write external
   metadata. – She doesn't need to write all the boilerplate by herself.
 - Could be achieved through inclusion/exclusion rules.
 - Maybe she also wants the tool to put a `[:my-extensions/foo {:name "" :gender
   ""}]¸ in each of the metadata maps to reduce the boilerplate further. Or just
   in the metadata maps for defs… → transformation rules
 - Maybe she only wants skeletons for namespaces. → inclusion/exclusion rules
   again
 - Skeleton might have to be extracted from:
    - stuff on disk/stuff downloaded as JAR
       - For JARs or stuff on disk where we don't want to modify the project's
         `project.clj`, we again need some sort of repo format where we specify
         what the program should do and where the output can go.
    - source code/compiled files/metadata
       - from source code it could use the ordinary extraction mechanism
       - from compiled files it could also use the extraction mechanism, but
         possibly more limited
       - from metadata it would be a transformation of metadata

## GREN006: Assemble a metadata JAR (or other things)

Story:

 The user wants to create a JAR of metadata from different sources.

Considerations:

 - User might also want to have the metadata in her ordinary JAR.
    - So maybe we don't even want a separate metadata JAR, but just the metadata
      on disk.
 - Sources might be:
    - Source files of the current project or of a different project on disk.
       - Only things on classpath? Hmm, maybe not sufficient.
    - Sources or compiled stuff from JAR files.
       - Here we might rely entirely on the classpath and dependencies in a
         local Maven repo and not mess with filesystem paths directly. But of
         course users could write extensions.
    - Existing metadata from current project or different project on disk or
      metadata JAR file or from a database!
 - If we admit anything else but existing metadata, we need to compose the
   assembly step with an extraction step.
 - For existing metadata we might need to compose the assembly step with a
   transformation step.

   ```
    sources/compilates  ex. metadata
           ↓                  ↓
       extraction       transformation
           ↓                  ↓
     transformation       filtration
           ↓                  |
       filtration             |
           |                  |
           +---------+--------+
                     ↓
                  merging
                     ↓
                 filtration
                     ↓
               transformation
                     ↓
                   files
                     ↓
                 POM + JAR (in this case)
   ```
 - Of course, from this process, any kind of output is imaginable.

## GREN007: Merge two structures of metadata

Story:

 The user has two structures of metadata in the same format (to make it easier)
 and wants them combined.

Considerations:

 - This is not a historical merge. We're not dealing with documents that got
   changed in different ways and then we have to reassemble them again.
    - Though this will become necessary when we're dealing with external
      metadata under version control. – Seems that everything comes back:
      gettext tools…
 - Rather we have two different metadata maps with the same coordinates and want
   to create a new one that contains the metadata from both. (If one metadata
   map doesn't have a counterpart with the same coordinates in the other
   structure, we can just include it without further ado. Or if the counterpart
   is just the same, we can also include it.)
 - On the map level the same principle applies. Entries that are the same on
   both sides or don't have a counterpart, are included. The only problem arises
   when we have the same key with different values on each sides. We could
   forbid this to happen. – The user would have to do a pre-transform. – Or
   demand manual intervention. Manual intervention is equivalent to putting
   both versions of the value and a marker in a vector or whatever. Multiple
   solutions are possible. It's just important to put it under the same key. If
   we use a special CONFLICT key, we might have to deal with the situation that
   is key is already present in the map as well… I mean, it could be namespaced,
   but we'd still have to check and build in a special case. This has to be
   weighed.

## Misc. considerations

 - Should the metadata maps carry information by whom they were created? I.e.,
   should each metadata map carry the coordinates of the artifact it belongs to?
    - Might be used for automatic resolution of merge conflicts.
    - In a JAR it can be found out easily which artifact the metadata belongs
      to.
    - There might be no artifact in a Maven sense. – For example a Database.
    - Might be useful for debugging.
    - Should be easy to build in afterwards when needed.
    - Also useful/necessary when the metadata are not in a JAR, but just as a
      file structure.
 - Several metadata structures in same repo for merging/packaging in different
   ways?
 - Inclusion/exclusion rules for merging or generating packages.
 - Integration with Leiningen should be as dumb as possible. Want a
   comprehensive core that can also be used from Boot, Maven and whatever there
   might come.
 - Conversion between all sorts of data stores. See [](GrenadaFormats.md) and
   [](GrenadaParts.md#converters).
 - Hoplon
 - It would be kind of cool if after some time all my original extractors and
   transformations and stuff would be exchanged with new things but the
   infrastructure would still be the same.
 - Ideas for implementation:
    - using transducers
    - using channels
    - using pipelines cf. Boot, Ring middleware
    - (those three might essentially turn out to be one thing)
    - using Graph
    - Can we provide both easily?
    - Is it right that the former use function composition and stuff like that
      to construct the systems whereas with Graph we construct the system by
      manipulating data structures?
 - How do we deal with outdated things? For example, we capture metadata from an
   artifact Av1 and then merge it with newly captured metadata from artifact
   Av2, where a function was renamed.
    - Might not occur so often, but we would need a merger that supports a
      procedure like this:
       - Extract all possible coordinates from an artifact.
       - Warn if there are discrepancies between these coordinates and some set
         of metadata.
