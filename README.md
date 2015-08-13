# Grenada Specification and Misc

[![Map indicating the location of Grenada in the Lesser
Antilles.](https://upload.wikimedia.org/wikipedia/commons/5/53/Grenada_in_its_region.svg)](https://commons.wikimedia.org/wiki/File:Grenada_in_its_region.svg#/media/File:Grenada_in_its_region.svg)
[(Listen also.)](http://www.bbc.co.uk/programmes/b02x5j69)

Grenada is a Clojure metadata build and distribution system. Features:

 - for **library authors**: assemble and publish documentation packages similar
   to Javadoc JARs, but containing well-defined data instead of HTML.

 - for **documentation editors**: jazz up the documentation of existing Clojure
   libraries; assemble documentation and examples from different sources.

 - for **toolsmiths**: build on a rigorously flexible model of metadata about
   things in the Clojure ecosystem.

 - for **developers**: annotate Clojure objects that don't support doc strings with
   easily accessible documentation (to be implemented).

This repo houses the Grenada specification (start with reading the
[overview](SpecOverview.md)) and other things, which I couldn't find a better
place for.

## Comparison

Here a list of tools, libraries etc. that are more or less closely related (in
spirit) with Grenada.

### Incorporable

These are sources of documentation whose contents could be packaged in Datadoc
JARs.

 - [Clojure Reference Documentation](http://clojure.org/documentation): the
   official Clojure documentation – often terse and with few examples.

 - [Clojure Cheat Sheet](http://clojure.org/cheatsheet): helps you find what you
   want in the official Clojure docs and selected external libraries.

 - [ClojureDocs](https://clojuredocs.org): attempt to patch over the official
   documentation's terseness with community-contributed notes, examples and
   see-alsos – easy to use and contribute to, but centered around JVM Clojure
   and not very structured.

 - [Clojure Grimoire](http://conj.io): similar to ClojureDocs, but highly
   structured and with support for arbitrary libraries on many Clojure
   platforms. Utilizes the aforementioned cheat sheet for easy navigation.
   Contributing is a little more tedious than in ClojureDocs. Offers libraries
   for programmatic access.

 - [Thalia](https://github.com/jafingerhut/thalia): extensions to the doc
   strings of core Clojure namespaces that you can load into your REPL.

 - [Suchwow](https://github.com/marick/suchwow): assortment of stuff, which also
   contains some doc string extensions like Thalia.

 - [cljs.info](http://cljs.info/cheatsheet/): something like emancipating
   ClojureScript documentation from Clojure documentation. Also allows community
   contributions. Quite useful.

### Build on

These tools could build on the Grenada format or Datadoc JARs.

 - [Codeq](http://blog.datomic.com/2012/10/codeq.html): imports Git history of
   Clojure (and potentially other) projects into Datomic, so that you can query
   it somewhat semantically.

 - [CrossClj](https://crossclj.info/): pretty impressive (and confusing) site.
   Lets you search and browse the majority of Clojure libraries, their source
   code, documentation and, most of all, interrelations. It wouldn't make sense
   to build this entirely on top of Grenada, but Grenada could be a part of the
   foundation.

 - [Codox](https://github.com/weavejester/codox): generates static HTML from
   doc strings in Clojure and ClojureScript code.

 - [Autodoc](https://github.com/tomfaulhaber/autodoc): same purpose as Codox,
   but only for JVM Clojure, as far as I see. Used for creating the official
   Clojure API documentation.

### Built on (infrastructure)

Things used by Grenada.

 - [Clojars](https://clojars.org): hosts JARs of Clojure libraries and also
   Datadoc JARs.

 - [lib-grimoire](https://github.com/clojure-grimoire/lib-grimoire): library
   behind Clojure Grimoire (mentioned above). Supports querying, reading and
   writing data about concrete Clojure things in the Grimoire format. Grenada
   draws on the Grimoire format and lib-grimoire.

 - [lein-grim](https://github.com/clojure-grimoire/lein-grim): Leiningen
   ‘plugin’ that can be used to extract documentation data from Clojure code.

### In-depth guides

These don't have much to do with Grenada, other than that they're also about
Clojure documentation.

 - [Clojure Cookbook](https://github.com/clojure-cookbook/clojure-cookbook):
   recipes for accomplishing common tasks in Clojure.

 - [clojure-doc.org](http://clojure-doc.org/): tutorials and topical guides on
   Clojure.


## Git Workflow

Except for a few commits in the beginning, branching and merging follows
[Driessen's model](http://nvie.com/posts/a-successful-git-branching-model/).
Versions and releases are those of the specification.

## See also

The repositories grouped under https://github.com/clj-grenada are all in some
way related to Grenada development.

## Thanks

…to Reid McKenzie (@arrdem) and Alex Miller (@puredanger) for mentoring me in
this project.

## License

Copyright (c) 2015 Richard Möhn

This README and the specifiction are licensed under the Creative Commons
Attribution 4.0 International License. To view a copy of this license, see
[LICENSE.txt](LICENSE.txt) or visit http://creativecommons.org/licenses/by/4.0/.

The image files in the directory [logo](/logo) are licensed separately, but also
under the Creative Commons Attribution 4.0 International License.

The Perl script in the directory [logo](/logo) is licensed under the MIT
license, the text of which can be found at http://opensource.org/licenses/MIT.

The map of the location of Grenada is sourced directly from the Wikimedia
Commons. For license information, simply click on the image.
