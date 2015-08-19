# Roadmap

Not really a roadmap, but the name makes it easy to find. This will give you an
idea of where Grenada might go if there is enough interest and time. For more
details (and less tidyness), have a look at the PivotalTracker [instance for
Grenada](https://www.pivotaltracker.com/n/projects/1404396).

## Model

 - Solicit, receive and incorporate feedback.
 - Mergers.
 - Support for other backends than Things Tvals. Datomic protocol, for example.

## Bar types

 - Grouping Things.
 - Semantic information about macros.

## Datadoc JARs

 - Specify the format. – Currently there's only an implementation, but no
   specification.
 - Include source information.
 - Provide an index.
 - Include other metadata. The libraries used in assembling a Datadoc JAR, for
   example.

## Documentation

 - More accessible structure. Currently everything is sprawling.
 - Wiki with overview over existing Bar types. People can add links to their
   own.

## API of lib-grenada

 - More doc strings.
 - Coordinate accessors, extended validation, mergers, more converters.

## Capturing of metadata

 - Move away from lein-grim as capturer. – Possibly provide a unified basis for
   the existing metadata capturers.
 - Support other platforms than JVM Clojure.
 - Aspects and capturing for non-var-backed finds: defmethods, records etc.
 - Everything annotatable. – Not just concrete things supporting Cmetadata.

## lein-datadoc and other plugins

 - Maven plugin, Boot task for producing Datadoc JARs.
 - Attach projects' READMEs and other docs to Things.
 - Attaching data to arbitrary Things from inside and from outside source code.

## Tools using Datadoc JARs

 - ClojureScript app for downloading Datadoc JARs to your machine and displaying
   their contents. Would be a nifty first step in replacing statically generated
   documentation pages.
 - Clojure\* library and documentation search page.
