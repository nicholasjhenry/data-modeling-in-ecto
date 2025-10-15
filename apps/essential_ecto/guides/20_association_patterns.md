# Association Patterns

## Documentation

Association documentation must be formatted as a list of bullet points using the following template:

```TEMPLATE
`{association_name}` ({association pattern}): {documentation}
```

## Patterns

Asssocations must be documented with one of the following patterns:

**Actor - Role**

Use to model the participation of a person, organization, place, or thing in a context.

- An _actor_ knows about zero to many _roles_, but typically takes on only or of each kind.
- A _role_ represents a unique view of its _actor_ with a context. The _role_ depends on its _actor_ and cannot exist without it.

**OuterPlace - Place**

Use to model a hierarchy of locations where events happen.

- An _outer place_ is the container for zero or more _places_.
- A _place_ knows at most one o_uter place_. The _place's_ location depends on the location of its _outer place_.

**Item - SpecificItem**

Use to model a thing that exists in several distinct variations.

- An _item_ is the common description for zero to many _specific items_.
- A _specific item_ knows and depends on one _item_. The _specific item's_ property values distinguish it from other _specific items_ described by the same _item_.

**Assembly - Part**

Use to model an ensemble of things.

- An _assembly_ has one or more _parts_. Its _parts_ determine its properties, and the _assembly_ cannot exist without them.
- A _part_ belongs to at most one _assembly_ at a time. The _part_ can exist on its own.

**Container - Content**

Use to model a receptacle for things.

- A _container_ holds zero or more _content_ objects. Unlike an _assembly_, it can be empty.
- A _content_ object can be in at most one _container_ at a time. The _content_ object can exist on its own.

**Group - Member**

Use to model a classification of things.

- A _group_ contains zero or more _members_. _Groups_ are used to classify objects.
- A _member_, unlike a _part_ or _content_ objects, can belong to more than one _group_.

**Role - Transaction**

Use to record participants in events.

- A _transaction_ knows one _role_, the doer of its interaction.
- A _role_ knows about zero or more _transactions_. The _role_ provides a contextual description of the person, organization, thing, or place involved in the _transaction_.

**Place - Transaction**

Use to record where an event happens.

- A _transaction_ occurs at one _place_.
- A _place_ knows about zero to many _transactions_. The _transactions_ record the history of interactions at the _place_.

**SpecificItem - Transaction**

Use to record an event involving a single thing.

- A _transaction_ knows about on _specific item_.
- A _specific item_ can be involved in zero to many _transactions._ The _transactions_ record the _specific item's_ history or interactions.

**CompositeTransaction - LineItem**

Use to record an event involving more than one thing.

- A _composite transaction_ must contain at least one _line item_.
- A _line item_ knows only one _composite transaction_. The _line item_ depends on the _composite transaction_ and cannot exist without it.

**SpecificItem - LineItem**

Use to record the particular involvement of a thing in an event involving multiple things.

- A _specific item_ can be involved in zero to many _line items_.
- A _line item_ knows exactly one _specific item_. The _line item_ captures details about the _specific item's_ interaction a _composite transaction_.

**Transaction - FollowupTransaction**

Use to record an event that occurs only after a previous event.

- A _transaction_ knows about some number of _follow-up transactions_.
- A follow-up transaction_ follows and depends on exactly one previous _transaction_.
