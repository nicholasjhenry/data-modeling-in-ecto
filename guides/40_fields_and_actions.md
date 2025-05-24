# Fields and Actions

## Fields

- Except _descriptive_ fields, typically fields are validated and changed by a business service.
- Fields maybe _calculated or derived_, e.g. order total. They may be cached once a value cannot change.
- Fields maybe "_inherited_" from a record when two tables are need to present a "complete" record (Actor – Role, Item – SpecificItem,  CompositeTransaction – Line Item, see Generic - Specific Template below)
- Calculated or inherited fields are implemented using _virtual fields_.
- Historical fields are modeled as a _transaction_ (e.g. PriceHistory, RoleHistory)

Five categories of fields:

- **Descriptive**: Domain-specific and _tracking_ fields
- **Time**: date or time fields, typically records occurence of a transaction
- **Lifecycle state**: status of one-way state transitions (e.g., nomination status: pending, in review, approved, rejected)
- **Operating state**: status of two-way state transitions (e.g., sensor state: off, on)
- **Role**: classification of people (e.g., team member role: chair, admin, member)
- **Type**: classification of places, things, and events (e.g., store type: physical, online, phone)

Categorizing fields help us to decide how to represent them and what [business rules]() need to be consider.

## Actions

Three categories of actions:

- **Business Actions**: validate and change state (field and associations); create new records (typically transactions)
- **Query Actions**: return current state, e.g. predicates
- **Reporting Actions**: report on future or historical state
