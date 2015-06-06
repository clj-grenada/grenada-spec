# Conceptual components for assembling Grenada builds

Notes:

 - Whenever I write "blessed format", any other format is fine, as long as it is
   documented which and how to convert it to the blessed format.
 - Indeed, anything else is also fine, but then you have to deal with
   interoperability issues.
 - Non-standard formats are likely to occur in cases where parts are composed of
   parts again. For example, it would be clumsy to require the lowest-level
   procedure of the Clojure source extractor to produce complete metadata maps.
   Yet, in order to create a full Clojure source extractor, we can wire it up
   with a couple of sources, transformers, mergers and a sink to finally produce
   standard-compliant data. Thus we would have a standard-compliant extractor
   that is made up of smaller parts that communicate in a format appropriate to
   their needs.
 - All the intermediate steps could be transducers, couldn't they?
 - The extractor needs some special semantics like hooks, because there the
   metadata maps aren't complete and it might be too overkill to assemble a new
   extractor every time. But maybe it wouldn't. We'll see.
 - The details on how to connect those parts and on how to iterate over
   collections are irrelevant at the conceptual level and up to the
   implementation.

## Preprocessor

 - Provides a uniform entrypoint for extractors.

Note:

 - Not sure if this is needed.

## Extractor (Source)

 - Given an entry point to Clojure sources or whatever, extracts metadata from
   there and returns them in the blessed format.
 - May take a set (vector?) of callback functions that are called for every some
   piece of low level information.
 - More generally, this is just a source. It gets data from somewhere (possibly
   directly as Clojure data structure) and returns it in some usable way.

## Transformer

 - A function that maps from metadata map to metadata map.
 - If it returns nil, this means that the input metadata map should be deleted
   from a metadata collection.

Notes:

 - Not sure if transformers should operate on single metadata maps or on
   collections of metadata maps. The former case is easier to implement (and
   would eliminate the need for nil as a special value), the latter is more
   flexible.

## Merger

 - A function that takes a pair of metadata maps and returns one.

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

 - "Postprocessor" might be too wide-scoped. Before I had "Packager", which was
   too narrow-scoped.
