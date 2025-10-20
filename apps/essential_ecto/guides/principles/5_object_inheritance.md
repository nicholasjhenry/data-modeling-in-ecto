# Object Inheritance

## Parent-Child Responsibilities

**47. Object inheritance**

Use object inheritance between two objects representing a single entity or event when the entity participates in multiple contexts, when the entity comes in many variations, or when the event involves multiple interactions.

**48. Parent responsibilities**

In object inheritance, the parent object contains information and behaviours that are valid across multiple contexts, multiple interactions, and multiple variations of an object.

**49. Child responsibilities**

In object inheritance, the child object represents the parent in a specialized context, in a particular interaction, or a s a distinct variation.

**50. Child assumes the parent's profile**

In object inheritance, the child object assumes its parent's profile, enabling it to answer read-only requests for information about properties and collaborators of the parent.

## Object inheritance vs. class inheritance

**51. Objects not classes**

Object inheritance relates two objects, each representing different views of the same entity or event. Class inheritance relates two classes, one extending the structure defined in the other.

**52. Representation vs. specialization**

Use object inheritance to represent multiple views of an entity. Use class inheritance to specialize an existing class of objects.

**53. Values vs. structure**

Object inheritance is the sharing of actual property values from a parent object. Class inheritance is the sharing of the structure for holding property values from an existing class definition.

**54. Dynamic vs. static**

Object inheritance is dynamic since shared property values often change their state during the course of a parent object's lifetime. Class inheritance is static because the structure for holding property values rarely changes during a class definition's lifetime.

## Object Inheritance of Properties

**55. Values through services**

Use object inheritance to allow a child to share property values with it parent. Add a read accessor in the child for each property value it object inherits from it parent.

**56. Read but no write**

Never allow a child object to change property values in its parent.

**57. Only public properties**

Properties of the parent that are not publicly accessible cannot be object inherited by a child object.

**58. No design, just business**

Don't allow a child to object inherit design properties that were added to the parent to improve efficiency, support persistence storage, allow interactive display, or satisfy programming practices.

**59. Queries not states**

Don't allow a child to object inherit read accessors for state, type, or role properties. Do allow the child to object inherit related property value services, such as "isPublished", "isCancelled", "isAdmin", etc.

## Object Inheritance of Collaborations

**60. In my parent's groups**

Always allow a child to object inherit its parent's group, assembly, and container collaborations.

**61. Remembering my parent's events**

Always allow a child to object inherit its parent's historical and event transactions.

**62. Family ties**

Always allow a child to object inherit its parent's parent, but do not allow a child to object inherit other child objects belong to its parent.

**63. Share and share alike**

Allow a child to object inherit follow-up transactions for it parent's events if and only if the follow-up transactions are valid for all the parent's children.

**64. My parent the event**

Allow a line item child to object inherit the role and place collaborations of its composite transaction parent.

## Object Inheritance of Services

**65. Determine mine, too**

A determine mine service of a parent is object inheritable if every child object could be asked the question the determine mine service answers.

**66. Analyze only what you know**

An analyze transactions service of a parent is object inheritable if the child object c an object inherit the transactions being analyzed.

**67. Children cannot conduct business**

A conduct business service of a parent is never object inheritable because the child cannot alter the parent or the context of the parent.

## Child vs. Strategy Objects

**68. It's a child not a function**

Use internal, stateless Strategy objects to encapsulate pluggable functionality of Context objects. Use external, stateful child objects to model another view of parent objects.