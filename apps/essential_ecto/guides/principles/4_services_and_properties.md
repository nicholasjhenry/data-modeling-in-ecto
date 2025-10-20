# Service and Properties

## Object Think Processes

**Principle 23. Be Objective with Processes**

Be objective when asking about processes. Talk instead about the objects--people, places, things, and events--involved in the process and the actions on these objects, rather than asking clients how they "want to do it."

**Principle 24. Do it Myself**

Objects that are acted upon by others in the real world do the work themselves in the boject world.

**Principle 25. Do it with Data**

Objects encapsulate data representing an entity together with the services that act on it.

## Distributing the Work

**Principle 26. Director Principle**

Real-world actions on entities map to one of the objects representing that entity. This object is called the direct of the action because it directs itself and its collaborators in carrying out the action.

**Principle 27. Most Specific Directs**

When a real-world action maps to two collaborators representing a single entity or an aggregation of entities, the direct is the most specific, local, or detailed pattern player.

**Principle 28. Events Direct the Work**

When an action requires cooperation among the collaborating entities of an event, the event directs the action.

**Types of Services**

**Principle 29. Let the Director Conduct**

Use the "specific directs" and "event directs" principles to find the director of a process. Assign the director a conduct business service to initiate the process.

**Principle 30. Most Knowledgeable is Responsible**

When a role acts on a specific item at a give place and the event is recorded, give the most knowledgeable or restrictive object a conduct business service that establishes the transaction.

**Principle 31. Let an Object Determine Mine**

Provide an object with determine mine services so it may answer requests for current information.

**Principle 32. Let an Object Assess Events**

Provide an object with analyze transactions services so it may assess its historical information, past events, and future scheduled events.

## Descriptive Properties

**Principle 33. Make it Real and Relevant**

Descriptive properties come from an object's relevant real-world characteristics. Use domain experts, legacy databases, and information architectures to locate relevant descriptive properties.

**Principle 34. Track but don't key**

Keep keys and object IDs off the diagram. Include identifying properties only if they come from the domain.

**Principle 35. Hide Redundant Accessors**

Assume each property listed in the object definition has a read and write accessor, but don't put them in the diagram.

**Principle 36. Show Derived Accessors**

Represent a derived property with a read accessor in the service section.

**Principle 37. Always Date Events**

Transaction object always include date and/or time properties.

**Principle 38. Date Objects with Special Occurrences**

Put date and/or time properties in non-transaction objects to record a non-repeatable occurrence or a repeatable occurrence that does not require history.

**Principle 39. Historical Properties Need Objects**

Use history event object to keep an audit trail of values of a property. Treat the property like a derived one; include a special acessor to read the property value for a give date.

## State Properties

**Principle 40. Knowing where in the Lifecycle**

In a person, place, or thing, make the lifecycle state a property derived from event collaborators. In an event, make the lifecycle state a property, unless it is derived from follow-up events.

```elixir
# nomify/documents/nomination.ex
#
field :status, Ecto.Enum,
  values: [:pending, :in_review, :rejected, :approved],
  default: :pending
```

**Principle 41. Knowing which Operational State**

Put an operating state property in any person, place, or thing object that switches between different operation modes.

**Principle 42. Cache when Final**

When an object reaches one of its final lifecycle states, consider caching its derived properties.

**Principle 43. Only Change State when Conducting Business**

Allow only conduct business services to change an object's lifecycle or operational state properties.

```elixir
# nomify/documents/nomination.ex
#
field :status, Ecto.Enum,
  values: [:pending, :in_review, :rejected, :approved],
  default: :pending
```

## Complex Properties

**Principle 44. Collapse Clutter Objects**

Collapse objects whose only purpose is to represent complex information into the properties.

**Principle 45. Classify Roles**

Use a role classification property to distinguish different levels of participation only if the participation level requires no history and no additional properties, behaviours, or collaborations.

**Principle 46. Classify Types**

Use a type classification property to distinguish different object types only if the type requires no history and has no additional properties, behaviours, or collaborations.
