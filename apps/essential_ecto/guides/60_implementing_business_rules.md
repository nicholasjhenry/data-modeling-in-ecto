# Implementing Business Rules

## Rule Types

- Type
- Cardinality
- Fields
- State
- Conflict

## Field Validations

Domain-specific limits on field values implemented using `Ecto.Changeset.validate_*` functions.

> 1. checking the logical validity of the new value, e.g `Ecto.Changeset.validate_required/3`
> 2. checking the business rule validity of the new value

Functions for enforcing field validations for business rules `validate_FIELD/1`, e.g.
`validate_title/1`. Wrapping encourages cohesive functions that include all related validations,
helpful for Cross-Field Validations (see below).

How to handle enums?? `validate_FIELD_VALUE/1`, e.g. `validate_status_accepted/1`

Validation rules by field category:

- **Descriptive and Time**: (1) State transition rules prevent fields from changing; (2) limit the range of possible values
- **State, Role and Type**: `Ecto.Enum` and may limit changes, e.g. state transition

Note: **Type Rules** are also defined by the Ecto schema association. e.g. `has_one ValidType`

Cross-Field Validation:

- Validate a change in one record requires checking business-rules in another.
- Record validates own field, associated record checks if the field value invalidates the association.
- Indicates a separate action/changeset is required

## Association Validations

Guidelines:

- Dual Validation: Both association players (record modules) validate the association (Why? Extensability, cohesiveness, locality)
- NJH: Commutative Rule Checking ???

## Steps

Follow the dependency graph to update Actions (changesets) :

1. Add "check" `check_ASSOC/1` functions to each associated record where required,
   see [Association Validations]()
2. Add validation functions for association changeset to call `check_ASSOC/1` functions
3. Add validations for each category as needed, see [Association Validations]()

`put_ASSOC_changeset/2` => `validate_ASSOC_1/1` => `check_ASSOC_1/1`
                        => `validate_ASSOC_2/1` => `check_ASSOC_2/1`

- Generic-Specific => `validate_GENERIC/1` ("inherited" fields)
- Whole-Part => `validate_WHOLE/1` => `WHOLE.check_PART/2`
- Transaction-Specific => `validate_SPECIFIC/1` => `SPECIFIC.check_TRANSACTION/1`

## Conflict Validations

Validates conflicts between in-direct associated records for a intermediary record.

`validate_PLAYER_1_PLAYER_2_conflict/1` can be implemented to any player that
has associations with different records.

- Implemented using `Ecto.Changeset.unique_constraint/3`
- Implemented calling `check_ASSOC/1` for indirect associated records.
