## Typespec

- Write a `typespec` for this Ecto Schema.
- The `typespec` should always appear above the Ecto schema.
- If `@type` already exists, skip.

The typespec must include:

- all fields (including timestamps and foreign key ID's)
- associations, e.g. belongs_to, has_one, has_many

The typedoc must use this template where places holders are {} and directives are //:

```TEMPLATE
## Fields

A {human_form_of_module_name} has these fields:

{list_of_fields}

//OPTIONAL(start): include only when assocations are defined

## Associations

A {human_form_of_module_name} associates with:

{list_of_associations}
```

Typespec for fields should include:

- `id` field

Types for fields:

- `id: integer()`
