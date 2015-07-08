# Conceptual components for assembling Grenada builds

Notes:

 - Whenever I write "blessed format", any other format is fine, as long as it is
   documented which and how to convert it to the blessed format.
 - Indeed, anything else is also fine, but then you have to deal with
   interoperability issues.
 - Non-standard formats are likely to occur in cases where parts are composed of
   parts again. For example, it would be clumsy to require the lowest-level
   procedure of the Clojure source extractor to produce complete Things.
   Yet, in order to create a full Clojure source extractor, we can wire it up
   with a couple of transformers to produce standard-compliant data. Thus we
   would have a standard-compliant extractor that is made up of smaller parts
   that communicate in a non-standard format appropriate to their needs.
 - The extractor needs some special semantics like hooks, because there the
   metadata maps aren't complete and it might be too overkill to assemble a new
   extractor for every purpose. But maybe it wouldn't. We'll see.
 - The details on how to connect those parts and on how to iterate over
   collections are irrelevant at the conceptual level and up to the
   implementation.
 - But, fret not, most of this stuff will be plain old Clojure functions and
   procedures. I won't require any more formality than is necessary.
 - Have to think about the overlap between transformers and converters.

## Preprocessor

 - Provides a uniform entry point for extractors.

Note:

 - Not sure if this is needed.

## Extractor (Source, Importer)

 - Given an entry point to Clojure sources (a filename, for example), extracts
   metadata from there and returns them in the blessed format.
 - May take a set (vector?) of callback functions that are called for every some
   piece of low level information.
 - More generally, this is just a source. It gets data from somewhere (possibly
   directly as Clojure data structure) and returns it in a usable way.

## Transformer

 - There can be two kinds of transformers:
    1. Functions that map from Tmap to Tmap.
    2. Functions that map from a metadata collection to a metadata collection.
 - The first kind should be sufficient in most cases.
 - The second kind can be used for reordering the whole collection or throwing
   out Tmaps that are not needed.

## Merger

 - merge-2: A function that takes a pair of Tmaps for the same entity and
   returns one.
 - merge: A function that takes two collections of Tmaps and applies merge-2 to
   a pair of Tmaps describing the same Thing in order to obtain one collection
   of Tmaps.

Implementation ideas:

 - The default merge-2 merges metadata maps using `merge-with` and a function
   that throws an exception upon collisions of any other than the `:extensions`
   entries. The extensions entries again are merged using `merge-with` and a
   function that tries to resolve collisions using any provided plugins and
   throws an exception if it can't do so.
 - The default merge converts two sequential collections of metadata to a
   mapping collection, applies `merge-with` with the merge-2 and converts back
   to a sequential collection.

Notes:

 - I considered merging all maps on corresponding levels with the same keys, but
   I think that doesn't make sense. If, for example, there a two Tmaps with
   different `:cmeta` entries that could be merged without collisions, the
   result wouldn't have any sensible semantics. But, as always, you can
   implement your own if you disagree with me. I will make it as easy as I can.
 - I think that in general the sequential format is much more idiomatic to work
   with than the mapping format. That's why we're converting back and forth
   instead of using the mapping format all the time.

## Converter

 - A function that takes a whole metadata collection and returns a whole
   metadata collection containing the same information in a different format.

## Exporter (Sink)

 - A procedure that takes a metadata collection in the blessed format and writes
   it to somewhere.

## Postprocessor

 - Takes an output artifact and produces another output artifact from it.
 - Example: Packaging metadata in hierarchical filesystem format into a JAR.

Notes:

 - "Postprocessor" might be a too loose term. Before, I had "Packager", which
   was too narrow.


## Changelog

### 0.1.5

 - Extend the concept of a transformer to something that can also take whole
   collections of metadata Tmaps.
 - Add note about conceptual overlap between transformers and converters.
 - Add implementation ideas to the [converter section](#converter).
