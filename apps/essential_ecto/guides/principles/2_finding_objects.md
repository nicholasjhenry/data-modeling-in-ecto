# Finding Objects

## The Pattern Players

**People**
- Actor
- Role

**Places**
- Place
- Outer Place

**Things**
- Item
- Specific Item
- Assembly
- Part
- Container
- Content
- Group
- Member

**Events**

- Transaction
- Composite Transaction
- Line Item
- Follow-up Transaction

## Object Think

**7. Personify Objects**

Object model a domain by imagining it entities as active, knowing objects, capable of performing complex actions.

**8. Give Object Responsibilities**

Turn information about a real-world entity and the actions performed on it into responsibilities of the object representing the entity.

**9. Object's Responsibilities**

An object's responsibilities are: who I know--my collaborations with others; what I do--my services; and what I know--my properties.

**10. Talk like an Object**

To scope an object's responsibilities, imagine yourself as the object, and adopt the first-person voice when discussing it.

## Object Selection

**11. The People Principle**

Use an actor object to model individual people participating in a system. Also use an actor object to model an organization of people participating in a system as a single entity.

**12. The Context Principle**

A context of participation exists whenever a person or organization undertakes actions that are tracked and recorded. Actions that require different permissions or information from the person or organization belong in different contexts.

**13. The Role Principle**

For each context an entity participates in, create a separate role object. Put the information and permissions needed for that context into the role.

**14. The Place Principle**

Model a location where recorded actions occur with a place object. Model a hierarchical location with an outer place containing a place. Model the uses of a place or outer place in different contexts with role objects.

**15. The Thing Principle**

Model a thing with two objects: an item that acts as a description defining a set containing similar things, and a specific item that distinguishes a particular thing from others in the set. Model the uses of a thing different context with role objects.

**16. The Aggregate Thing Principle**

Model a receptacle of things as a container with content objects. Model a classification of things as a group with member objects. Model an ensemble of things with an assembly of part objects.

**17. The Event Principle**

Model the event of people interacting at a place with a thing as a transaction object. Model a point-in-time interaction as a transaction with a single timestamp; model a time-interval interaction as a transaction object with multiple timestamps.

**18. The History Principle**

To record historical or time-sensitve information about a person, place, or thing, use a time-interval transaction.

**19. The Composite Event Principle**

Model people interacting at a place with multiple things as a composite transaction; for each thing involved, include a line item to capture specific interaction details.

**20. The Follow-up Event Principle**

Model an event that follows and depends on a pervious event with a follow-up transaction.