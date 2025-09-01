# Implementing Association Pairs

There are three implementation templates:

> ... 12 collaboration patterns can be classified into three categories: generic – specific, whole – part, or transaction – specific. The same prototyping template can implement all collaborations within a given category; thus, only three templates are required to implement all 12 collaboration patterns.
>
> -- Streamlined Object Modeling

> #### Templates {: .warning}
>
> Each template applies to two records.

**Generic - Specific Template**

- Actor - Role
- Item - Specific Item
- Composite Transaction - Line Item

**Whole - Part Template**

- Outer Place - Place
- Assembly - Part
- Container - Content
- Group - Member

**Specific - Transaction Template**

- Role - Transaction
- Place - Transaction
- Specific item - Transaction
- Transaction - Follow-up Transaction
- Specific Item - Line Item

## DAmpIER

How to define record and context modules:

1. Define (`def*`)

- Name: Give the record module a name
- Fields: Define the schema with fields with sensible defaults
- Associations: Add associations to the schema
- Context: Give the context module a name
- Migrations: Write the migrations

2. Actions

- Fields: Write `insert_changeset/2` and `update_changeset/2 function` in the schema module with field validations
- Associations: Write `put_ASSOC_changeset/2` functions in schema module (`delete_ASSOC_changeset/2`) ???
- Context: Write the actions functions

3. Inspect

- Fields
- Associations

4. Equality?

5. Run?

## Record Module Definitions

Record modules include:

- Fields (properties)
- Associations (object collaborations)
- Changesets; Fields and Associations
- Validations; Fields and Associations (object collaboration rules)

### Changesets

Write validations for each field as appropriate:

- validated with `Ecto.Changeset` validation functions, e.g., `validate_length/3`.
- `Ecto.Changeset` validation functions wrapped, e.g., `validate_title/1`

### Associations

Write association changesets for the dependent record:

- `put_ASSOC_changeset/2`, e.g., `put_team_member_changeset/2`

### Validations (Business Rules)

Convert business rules to validations:

- validate associations with `validate_ASSOC/1`, e.g. `validate_team_member/1`
  - calls `ASSOC_RECORD.check_RECORD/1`, e.g. `TeamMember.check_nomination/1`
- validate association conflicts with `validate_RECORD_conflict`
  - conflict exists between two or more associations
  - calls `ASSOC_RECORD.check_RECORD_conflict/2`

## Templates

TODO: Add examples from DAIER for each template

Associations Summary:

| Player 1    | Player 2 | assoc              |          | assoc        |          |
| ----------- | -------- | ------------------ | -------- | ------------ | -------- |
| Generic     | Specific | `has_one/has_many` |          | `belongs_to` | required |
| Whole       | Part     | `has_many`         |          | `belongs_to` | optional |
| Transaction | Specific | `belongs_to`       | required | `has_many`   |          |

NOTE: The dependent record is identified by the `belongs_to` association (or foreign_key).

### Generic - Specific Template

Generic:

- Associations: one association for each Specific; `has_one` or `has_many` dependent on business rules

Specific:

- Fields: Include "inherited" fields from Generic; populated in query functions
- Associations: `belongs_to` Generic (required)
- Record: `put_GENERIC_changeset/2`
- Context: `create_SPECIFIC(GENERIC, params)`

### Whole - Part Template

Whole:

- Associations: `has_many` Parts (optional)

Part:

- Associations: `belongs_to` Whole (optional)
- Record: `put_WHOLE_changeset/2`
- Context: `put_PART(WHOLE, PART)` or `create_PART(WHOLE, params)`

### Transaction - Specific Template

Transaction:

- Associations: `belongs_to` Specific (required)
- Context: `create_TRANSACTION(SPECIFIC, params)` (can be renamed to a business revealing action)
- Record: `put_SPECIFIC_changeset/2`

Specific:

- Associations: `has_many` Transactions
