# Defining Aspects

If you want to define an Aspect A, you have to do the following things.

## Semantics

Write down what it means when a Thing has the Aspect A.

> ##### Example
>
> *(Outside code I will write `a` for `grenada.aspects`.)*
>
> A Thing with the Aspect `:a/fn` describes a **concrete Clojure fn**, that is,
> an object that satisfies `fn?`.

## Prerequisites

Think about which other Aspects a Thing has to have for A to be added. Write a
function that when **passed a set of Aspects** that fulfils the prerequisites,
returns `true`, otherwise falsey.

> ##### Example
>
> ```clojure
> (defn fn-prereqs-fulfilled?
>   "`:a/fn`  requires that a Thing already be `:a/find` and `:a/var-backed`."
>   [aspects]
>   (set/subset? #{:grenada.aspects/find :grenada.aspects/var-backed}
>                aspects))
> ```

Note that `:a/var-backed` implies `:a/find` (though the definitions are not
written down yet). Being explicit might avoid [version problems](#changelog),
but it's up to your judgement.

## Canonical name

Write down how the canonical name of the concrete Thing can be obtained.

> ##### Examples
>
> `:a/fn` doesn't define the way to obtain the canonical name, since its
> prerequisite `:a/var-backed` already does.
>
> *So here's the definition of the canonical name of an `:a/var-backed` Find:*
>
> Be v a var interned in some namespace under the symbol `s`. v was interned
> when some concrete thing x was defined. X is the `:a/var-backed` Find that
> contains data about x. `(str s)` is the name of X.
>
> ```
> (ns name.space)
>                      (ns-interns (find-ns 'name.space))
>                      ;=> {… …
> (def… … …)   ---->        s v
>                           … …}
> ```

## Remarks

Write down anything that you think is **important to know** about A. If there's
a lot to know about A, you might structure this section more. If you would
generally want to change the structure of defining an Aspect, please start a
discussion.

> ##### Example
>
> Somewhat confusingly, Finds with the Aspect `:a/fn` can have multiple
> **different names**. For example, see this:
>
> ```clojure
> user=> (def bark (fn miaow [] (throw (Exception. "🐷 Grunt."))))
> #'user/bark
> user=> (bark)
>
> Exception 🐷 Grunt.  user/miaow (NO_SOURCE_FILE:1)
> user=>                 ; ‾‾‾‾‾
> ```

However, the canonical name is always the name of the intern, in the case of the
example, `bark`.

## Changelog

You should document **every change** you make to the definition of an Aspect,
the **problems** it causes when old data are processed and how to **solve**
these problems.

Reason: Aspects don't have version numbers, since this would make APIs horrible
to use. Instead, we have to make **version problems** relatively easy to
resolve. For this we need comprehensive changelogs that guide in **diagnosing
and fixing** problems.

> ##### Example
>
> Grenada x.y.z:
>
>  - The semantics of Aspect `:a/fn` changed in this and that way. This might
>    result in these problems with old data:
>
>     - The … might throw **…**. In this case you have to apply ….
>
>     - Take care with **…**. There might suddenly appear **…**. **Check** twice
>       that this doesn't happen. If it happens, convert … to … and look if you
>       can get version m.n.o of ….

## Code

Other code has to work with your Aspect, so you have to render a minor part of
the above Things in code. Write a namespace like this:

  ```clojure
  (ns <suffix>.aspects
    "<documentation for this namespace>"
    …
    (:require [grenada.things.def :as things.def]))

  …

  (defn <Aspect name>-def
    "<documentation for this Aspect>"
    []
    (things.def/map->aspect {:name ::<Aspect name>
                             :prereqs-pred <prerequisites predicate>
                             :name-pred <name predicate>}))

  …

  ;;;; optional

  (def aspect-defs
    "A collection of the definitions of all Aspects defined in this namespace."
    #{… <Aspect name>-def …})
  ```

 - `<suffix>` can be anything you want.
 - `<Aspect name>` is the name you want to give your Aspect.
 - `<prerequisites predicate>` is the function checking prerequisites as defined
   [above](#prerequisites). The **default** for `:prereqs-pred` is `(constantly
   true)`.
 - `<name predicate>` is a function that will be passed the name (i.e. the last
   coordinate) of the Thing the Aspect is going to be applied to. If it returns
   something falsey, attaching the Aspect will fail. The **default** for
   `:name-pred` is `(constantly true)`.
 - `<documentation …>` might be good places to put all the prose rest of the
   Aspect definition.

> ##### Example
>
> ```clojure
> (ns grenada.aspects
>   "Definitions of the Aspects provided by Grenada."
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
> (defn fn-def
>   "Returns information about the Aspect `::fn`. This Aspect is defined as
>   follows:
>
>   ## Semantics
>   …
>   …"
>   {:grenada.cmeta/bars {:doro.bars/markup :common-mark}}
>   []
>   (things.def/map->aspect {:name ::fn
>                            :prereqs-pred fn-prereqs-fulfilled?})
>
> …
>
>   (def aspect-defs
>     "…"
>     #{… fn-def …}))
> ```
