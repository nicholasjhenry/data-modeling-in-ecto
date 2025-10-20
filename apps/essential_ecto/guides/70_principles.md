# Principles

Principles quoted from Streamlined Object Modeling.

## State Properties

### Principle 40 - Knowing Where in the Lifecycle

> In a person, place, or thing object, make the lifecycle state a property derived
> from event collaborators. In an event, make the lifecycle state a property,
> unless it is derived from follow-up events.

```elixir
# nomify/documents/nomination.ex
#
field :status, Ecto.Enum,
  values: [:pending, :in_review, :rejected, :approved],
  default: :pending
```

### Principle 43 - Only Change State When Conducting Business

> Allow only conduct business services to change an object’s lifecycle or
> operational state properties.

```elixir
# nomify/documents/nomination.ex
#
field :status, Ecto.Enum,
  values: [:pending, :in_review, :rejected, :approved],
  default: :pending
```

## Implementing Objects

### Principle 75 - Properties Before Collaborators

> Object construction methods initialize properties before establishing collaborations because
> collaboration rules may check property values.

```elixir
# nomify/teams.ex
%TeamMember{}
|> TeamMember.insert_changeset()
|> TeamMember.put_team_changeset(team)
|> TeamMember.put_person_changeset(person)
|> Repo.insert()
```
