# Defining Bar types

TODO: Adapt these to how I actually defined them. (RM 2015-08-09)

*The **length** of Bar type definitions typically ranges from **15 to 80 lines**
of text and code. Defining Bar types usually is neither tedious nor hard.*

If you want to define a Bar type β, you have to do the following things. (In
some aspects, Bars are similar to Aspects, so you will see some referrals to the
[Aspects guide](AspectsImp.md). You'd better read it first. It isn't that long.)

## Model

Write down how a Bar of type β will look and what the data in it will mean. How
you do this is up to you, but ultimately it's the **interface** which the users
of β have to rely on. So try to be precise, yet comprehensible.

I strongly recommend writing a **schema** or a **predicate** that, given a Bar,
returns if it conforms to β or not. Or both. Do what's most appropriate to the
case.

> ##### Example
>
> Attaching a Bar of type `:doro.bars/markup-all` to a Thing T has the same
> meaning as attaching a Bar of type `:doro.bars/markup` to T and all of its
> descendants that  don't have a `:doro.bars/markup` Bar already. For details,
> see the definition of `:doro.bars/markup`.
>
> Note: this means that if you're building a tool that has to do with
> `:doro.bars` Bars, you also have to **look at the ancestors** of Things
> whether they say something about the markup.
>
> ```clojure
> (defn markup-all-valid? [bar]
>   (markup-valid? bar))
> ```
>
> *Here the definition for `:doro.bars/markup`:*
>
> `:doro.bars/markup` Bars specify the markup language used for the doc string
> of a Thing. If you annotate a concrete thing with a Bar of this type, you say
> that its **doc string** is written in the specified markup language. Other
> Bars and **consumers dealing** with doc strings should take this into account.
>
> **Annotations** with `:doro.bars/doc` Bars are also considered doc strings in
> this context. Those are necessary for concrete things that don't support doc
> strings, for example defmethods.
>
> Currently the following markup **languages** are **supported**:
>
>  - [CommonMark](http://commonmark.org/)
>  - [GitHub-flavoured
>    Markdown](https://help.github.com/articles/github-flavored-markdown/)
>  - [HTML](http://www.w3.org/TR/html/)
>  - [plain text](http://www.unicode.org/versions/Unicode6.1.0/ch02.pdf)
>
> This Bar type does not **guarantee** that the documentation processor at the
> other end will be able to handle any of these formats properly.
>
> ```clojure
> (defn markup-valid? [bar]
>   (contains? #{::common-mark ::github-mark ::html ::plain} bar))
> ```

I recommend only using objects that can be printed using `pr` and then read
using `clojure.edn/read`. Otherwise your β Bars can't be **persisted**. Support
for custom writer and reader fns might be added later, though.

## Prerequisites

Think about which **Aspects** and **Bars** of other types a Thing has to have
for a β Bar to be added. Write functions that check a Thing's Aspects and Bars
in the same fashion as the [function that checks Aspects
prerequisites](AspectsImp.md#prerequisites).

See the [rules of the model for Bars](NewModel.md#more-on-bars) for advice on
whether or not to look at **Bars' contents** in these predicates.

> ##### Example
>
> *Right now I can't come up with a Bar type that depends on another Bar type's
> presence, so I will provide only an Aspect prerequisite.*
>
> ```clojure
> (require '[grenada.things :as t])
>
> (defn markup-all-aspect-prereqs-fulfilled? [aspects]
>   (some #(t/above-incl ::t/namespace %) aspects))
> ```


## Remarks

See the [corresponding section in the Aspects guide](AspectsImp.md#remarks).

## Changelog

See the [corresponding section in the Aspects guide](AspectsImp.md#changelog).

## Code

Render those parts of the definition of β in code that can be rendered in code.
Write a namespace that **exports a map** mapping Bar type keywords to Bar type
definitions. I recommend naming it `def-for-bar-type`. Follow this model:

```clojure
(ns <suffix>.bars
  "<documentation for this namespace>"
  …
  (:require [grenada.things.def :as things.def]))

…

(def <Bar type name>-def
  "<documentation for this Bar type>"
  (things.def/map->bar-type
    {:name ::<Bar type name>
     :aspect-prereqs-pred <Aspect prerequisites predicate>
     :bar-prereqs-pred <Bar prerequisites predicate>
     :valid-pred <Bar validation predicate>
     :schema <Schema for Bar type>}))

…

;;;; Public API

(def def-for-bar-type
  "A collection of the definitions of all Aspects defined in this namespace."
  (things.def/map-from-defs #{… <Bar type name>-def …}))
```

 - `<suffix>` can be anything you want.
 - `<Bar type name>` is the name you want to give your Bar type.
 - `<Aspect prerequisites predicate>` and `<Bar prerequisites predicate>` are
   the functions checking prerequisites as defined [above](#prerequisites).
   The **default** is `(fn [_] true)` in both cases.
 - `<Bar validation predicate>` is the function checking if the Bar is
   well-formed as defined [above](#model). The **default** is `(fn [_]
   true)`.
 - `<Schema for Bar type>` is a Prismatic Schema that will be used to validate
   Bars. The **default** is `schema.core/Any`.
 - `<documentation …>` might be good places to put all the prose rest of the
   Bar type definition.

> ##### Example
>
> ```clojure
> (ns doro.bars
>   "Definitions of the Bars types provided by Doro. …"
>   …
>   (:require [grenada.things :as t]
>             [grenada.things.def :as things.def]))
>
> …
>
> ;;; The defns from above would go somewhere here.
>
> …
>
> (def
>   ^{:grenada.cmeta/bars {:doro.bars/markup :common-mark}}
>   markup-all-def
>   "Definition of the Bar type `::markup-all`.
>
>   ## Semantics
>   …
>   …"
>   (things.def/map->bar-type
>     {:name ::markup-all
>      :aspect-prereqs-pred markup-all-aspect-prereqs-fulfilled?
>      :bar-valid-pred markup-all-valid?}))
>
> …
>
> (def bar-type-defs
>   "…"
>   (things.def/map-from-defs #{… markup-all-def …}))
> ```

TODO: Have the Bars types provide a Datomic schema. (RM 2015-07-17)
