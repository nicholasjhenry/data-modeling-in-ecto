## Typedoc

- Write a `typedoc` for this Ecto Schema.
- The typedoc must appear above the `typespec`.
- If `@typedoc` already exists, skip.

Typedoc for fields should exclude:

- `id` field
- description of the struct type
- values for enums (Ecto.Enum)
- timestamps
- foreign key ID's

Fields must be documented with one of the following categories:

- descriptive: Domain-specific and tracking fields
- time: date or time fields
- lifecycle state: status of one-way state transitions (e.g., nomination status: pending, in review, approved, rejected)
- operating state: status of two-way state transitions (e.g., sensor state: off, on)
- role: classification of people (e.g., team member role: chair, admin, member)
- type: classification of places, things, and events (e.g., store type: physical, online, phone)

Fields documentation must be formatted as a list of bullet points using the following template:

```TEMPLATE
`{field_name}` ({field category}): {documentation}
```
