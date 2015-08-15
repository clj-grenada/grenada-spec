# Grenada Specification

(If this is not what you were looking for, see the [general
overview](https://github.com/clj-grenada/lib-grenada/doc/overview.md).)

This is a rough and work-in-progress specification of how Grenada is supposed to
work. In the course of a major revision I haven't corrected the existing files,
but added new ones. So currently we have two rather diverging sets of files,
with the new ones being the state of the art and the old ones containing
information that is partly outdated and partly still applies. Reconciliation
will happen in a [visible](https://en.wikiquote.org/wiki/Herbert_A.%5fSimon)
future.

The specification consists of this overview and these files (to be explored in
this order, first three are new, the others old school):

 - [NewModel.md](NewModel.md) – The current definition of the **model**.

 - [AspectsImp.md](AspectsImp.md) – Guide to defining **Aspects**.

 - [BarsImp.md](BarsImp.md) – Guide to defining **Bars**.

 - [model-diagram.dia](model-diagram.dia) and
   [model-diagram.pdf](model-diagram.pdf) (very outdated) – A UML class diagram
   describing the data model which Grenada is based on. This diagram type might
   not be the optimal fit, but it's better than if I make up something myself.

 - [GrenadaModel.md](GrenadaModel.md) (very outdated) – Comments on the data
   model that I don't want to cram into the diagram.

 - [GrenadaDraft.md](GrenadaDraft.md) (kind of outdated) – Collection of
   information that didn't fit anywhere else (or that I haven't made fit yet).
   Read the section on **terminology** and skim the rest, then move on.

 - [GrenadaFormats.md](GrenadaFormats.md) (partly outdated) – Specification of a
   concrete **implementation** of the model. Describes different **storage**
   formats for different purposes.

 - [GrenadaParts.md](GrenadaParts.md) (not so much outdated) – Description of
   conceptual components for assembling Grenada **build processes**.

 - [GrenadaScenarios.md](GrenadaScenarios.md) (never been current) – Formally
   this also belongs to this specification, but it is more a historical heap of
   notes than anything else. You can ignore it.


## `**Strong**` text

Littered throughout the new parts of the spec you will find words and phrases in
bold face. (Or at least I guess that they are rendered in bold face by your
favourite Markdown processor.) These are **not intended** as **extracts** of the
**content** (as opposed to their use in this sentence). Rather, they are
intended to **guide the reader's eye** when she's looking for specific
information. At least most of the time.

In other words: I expect people to read the spec once and then come back
repeatedly to refresh their understanding of something they're working with.
Text emphasis is a tool to make this easier. It is not the optimal tool. – If I
could place keywords in the margin, I would do that. – But it's cheap and does
the job well enough.


## Version

1.0.0-rc.1

## Notes

 - ❁ Important notes are marked with ❁. Those you should read. The other notes
   might still be interesting, but are more notes to myself. However, if you
   have a question about something, please read the notes on it first. – They
   might already contain the answer.
 - The distribution of information across files has gotten better, but is still
   not good.

## Changelog

Contains only changes that can't be assigned to a single document. All
changelogs only list changes I consider important and interesting. Typos,
rewordings and additions of some notes are usually not included.

### 1.0.0-rc.1

 - Abandon the old model and introduce a [new one](NewModel.md).
 - Adapt this overview to these changes.
 - Improve the markup to make the text more easily accessible.

### 0.2.0

 - Introduce a proper model, comprising a [diagram](model-diagram.pdf) and a
   [text file](GrenadaModel.md).
 - (Not really spec.) Introduce a logo.
 - Make name "Grenada" permanent.

### 0.1.5

 - Introduce the marker ❁.
 - Rearrange some things between files.

### 0.1.4

 - Add README as an overview and in order to provide uniform versioning for all
   the documents.
 - Add documents about different storage formats and about the conceptual
   components for creating Grenada builds.
