# Implementing Aspects

If you want to define an Aspect A, you have to do the following things.

## Prerequisites

Think about which other Aspects a Thing has to have for A to be added. Write
down those in a set.

   Example:

   You want to declare the Aspect `:grenada.aspects/fn`. `:a/fn` (Outside code I
   will write `a` for `grenada.aspects`.) requires that a Thing already is
   `:a/find` and `:a/var-backed`. So you write:

   ```
   #{:grenada.aspects/find :grenada.aspects/var-backed}
   ```

Note that we don't resolve dependencies for you, because dependency chains are
expected to be short. That's why you have to write `:a/find` even though it's
implied by `:a/var-backed`.

## Semantics

Write down what it means when a Thing has the Aspect A.

  Example:

  A Thing with the Aspect `:a/fn` describes a concrete Clojure fn, that is, an
  object that satisfies `fn?`.

## Canonical name

Write down how the canonical name of the concrete Thing can be obtained.

  Example:

  `:a/fn` doesn't define the way to obtain the canonical name, since its
  prerequisite `:a/var-backed` already does.

  So here's the definition of the canonical name of an `:a/var-backed` Find:

  Be v a var interned in some namespace under the symbol `s`. v was interned
  when some concrete thing x was defined. X is the `:a/var-backed` Find that
  contains data about x. `(str s)` is the name of X.

## Remarks

Write down anything that you think is important to know about A. If there's a
lot to know about A, you can structure this section more. If you would generally
want to change the structure of defining an Aspect, please start a discussion.

  Example:

  Somewhat confusingly, Finds with the Aspect `:a/fn` can have multiple
  different names. For example, see this:

  ```clojure
  user=> (def bark (fn meeow [] (throw (Exception. "😠 Grunt."))))
  #'user/bark
  user=> (bark)

  Exception Grunt.  user/meeow (NO_SOURCE_FILE:1)
  user=>
  ```

  However, the canonical name is always the name of the intern, in this case
  `bark`.

## Changelog

You should document every change you make to the definition of an Aspect, the
problems it causes when old data are processed and how to solve these problems.

Reason: Aspects don't have version numbers, since this would make APIs horrible to use.
Instead, we have to make version problems relatively easy to resolve. For this
we need comprehensive changelogs that guide in diagnosing and fixing problems.

Example:

  Grenada x.y.z:

   - The semantics of Aspect `:a/fn` changed in this and that way. This might
     result in these problems with old data:

      - The … might throw …. In this case you have to apply ….

      - Take care with …. There might suddenly appear …. Check twice that this
        doesn't happen. If it happens, convert … to … and look if you can get
        the version m.n.o of ….
