# Implementing Bars

If you want to define a Bar B, you have to do the following things. (In some
aspects, Bars are similar to Aspects, so you will see some referrals to the
[Aspects guide](AspectsImp.md). I won't repeat some other conventions I've used
there, so please read it first. It isn't that long.)

## Prerequisites

Think about which Aspects and other Bars a Thing has to have for B to be added.
Write functions that check a Thing's Aspects and Bars in the same fashion as the
[function that checks Aspects prerequisites](AspectsImp.md#Prerequisites).

See the [rules of the model for Bars](NewModel.md#more-on-bars) for advice on
whether or not to look at Bars' contents in these predicates.

> ##### Example
>
> Right now I can't come up with a Bar that depends on another Bar's presence.
> See the [guide on Aspects](AspectsImp.md#prerequisites) for an example of a
> prerequisites predicate.

TODO: Add section about inheriting Bars. See contents of this file at commit
      499cd94. (RM 2015-07-16)
