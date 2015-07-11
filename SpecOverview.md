# Grenada Specification

This is a rough and work-in-progress specification of how Grenada is supposed to
work. It consists of this overview and the files (to be explored in this order):

 - [model-diagram.dia](model-diagram.dia) and
   [model-diagram.pdf](model-diagram.pdf) – A UML class diagram describing the
   data model which Grenada is based on. This diagram type might not be the
   optimal fit, but it's better than if I make up something myself.

 - [GrenadaModel.md](GrenadaModel.md) – Comments on the data model that I don't
   want to cram into the diagram.

 - [GrenadaDraft.md](GrenadaDraft.md) – Collection of information that didn't
   fit anywhere else (or that I haven't made fit yet). Read the section on
   terminology and skim the rest, then move on.

 - [GrenadaFormats.md](GrenadaFormats.md) – Specification of a concrete
   implementation of the model. Describes different storage formats for
   different purposes.

 - [GrenadaParts.md](GrenadaParts.md) – Description of conceptual components for
   assembling Grenada build processes.

 - [GrenadaScenarios.md](GrenadaScenarios.md) – Formally this also belongs to
   this specification, but it is more a historical heap of notes than anything
   else. You can ignore it.


## Version

0.2.0

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
