# Essential Ecto

## Record Categories

Through discovery find the following category of records:

- **People**: a record of a person or an organization; an _actor_ participating in a system.
- **Places**: a record of the location where an event occurs; places in multiple contexts record
  their participation as a _role_.
- **Articles**: a _subject_ of an **event**; people or places as the subject of an event act like
  articles. Articles require two records to represent them -- a generalized record (item) shared
  between many specific records (specific item). **Aggregated Articles** require two records to
  represent the receptacle and the article in the receptacle; these include _containers_ (_content_),
  _groups_ (_member_) and _assemblies_ (_part_).
- **Events**: a historical record of the particpation of people, places or articles in a context.
  Events are recorded as transactions in two way: **point-in-time** (single timestamp) or
  **time-interval** (start and end timestamps). Events may require multiple transaction records for
  _composite_ or _follow-up_ events.

## Association Players

Typically associations are thought of in terms of `has_many`, `has_one`, `belongs_to`. etc, and each
record form a parent-child relationship, limiting our ability to model the domain.

Thinking beyond Ecto associations, records forming an association play a richer part than simply
parent-child:

**People**

- Actor
- Role

**Places**

- Place
- OuterPlace

**Articles**

- Item
- SpecificItem
- Assembly
- Part
- Container
- Content

**Events**

- Transaction
- CompositeTransaction
- LineItem
- Follow-upTransaction

> "the presence of a given type of object suggests the presences of its likely collaborators"
> -- Streamlined Object Modeling

## Theory

1. [Association Patterns]()
2. [Association Validations]()
3. [Fields and Actions]()

## Implementation

The implementation is performed in two steps:

1. [Implement the association pairs](); i.e. schema and context modules
2. [Implement the buiness rules]()
