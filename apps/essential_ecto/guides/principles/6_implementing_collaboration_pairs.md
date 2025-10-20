# Implement Collaboration Pairs

## Object Definition Interfaces

**69. Showing your profile everywhere**

To implement object inheritance, describe the parent's object inheritable services with a profile interface, and require all child objects to exhibit the profile interface.

**70. Conduct business interfaces**

A conduct business interface includes all the business services of an object, either directly or by extending the object's profile interface.

**81. How I see you**

Collaborators refer to one another using their conduct business interfaces.

**82. Make the children parent-ready**

To allow future system growth, define profile interfaces for child objects so they can later become parents.

## Implementing Objects

**73. Minimum parameter rule**

Only properties and collaborations necessary for an object to exist should be passed into the object's construction method.

**74. Most specific carriers the load**

When work requires cooperation between two collaborators, encapsulate the majority of the effort within the most specific collaborator.

```elixir
#  TODO: Example
```

**75. Properties before collaborations**

Object construction methods initialized properties before establishing collaborations because collaboration rules may check property values.

```elixir
# nomify/teams.ex
%TeamMember{}
|> TeamMember.insert_changeset()
|> TeamMember.put_team_changeset(team)
|> TeamMember.put_person_changeset(person)
|> Repo.insert()
```

**76. Part carriers the load**

When work requires cooperation between a whole collaborator and a part collaborator, encapsulate the majority of the effort within the part collaborator.

**77. Putting parents first**

When an object must establish two or more collaborations to be valid, parent collaborations must be established first.

**78 Let the coordinator direct**

When different types of objects are united by a single common coordinator and must work toward a common goal, allow the coordinator to direct the actions.
